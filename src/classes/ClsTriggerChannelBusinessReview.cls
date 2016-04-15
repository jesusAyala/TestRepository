/**   
* TriggerClass :  ClsTriggerChannelBusinessReview
* 
* Count the Open JBP action records and update it in the Channel business review object's Answer2 value(Actions review section)    
* Release R5
*  
* @author  Ayiravalli A (Accenture)
* @created 2016-1-12
* @version 1.0
*
* - Created
*/
public without sharing class ClsTriggerChannelBusinessReview extends ClsTriggerVirtual {
        
    public Set<Id> rtIdSet = new Set<Id>();
    public Static Set<Id> processedIdSet = new Set<Id>();
    Integer remLimit;                 

/**   
* Constructor - ClsTriggerChannelBusinessReview
* 
*/    
    public ClsTriggerChannelBusinessReview () {
    
        //RTMap = new Map<Id, RecordType>([SELECT Id, Name FROM RecordType WHERE SobjectType =: Label.Channel_Partner_Business_Review_API_Name AND IsActive = TRUE LIMIT 50000]);
        for (Schema.RecordTypeInfo rt: Schema.SObjectType.Channel_Business_Review__c.getRecordTypeInfosByName().values()) {
            rtIdSet.add(rt.getRecordTypeId());
        }
        
    }
    
    /**   
    * This method created by Vasanthi 
    * As per Req #2728
    * If the status changes from "Obsolete"  or "Completed" to "Draft/In Approval/Additional Details Required/Completed" then change the record type "Obsolete" to "Open"    
    */      
    public override void bulkBefore(ClsWrappers.TriggerContext trgCtx) {
        
        if (trgCtx.isInsert) {
            assingnCurrency (trgCtx);           
        }
        
        if (trgCtx.isUpdate) {
        
            for (SObject sobj: trgCtx.newList) {
                
                if (!processedIdSet.contains(sobj.Id)) {
                
                    Channel_Business_Review__c newChannelRev= (Channel_Business_Review__c) sobj;
                    Channel_Business_Review__c oldChannelRev= (Channel_Business_Review__c) trgCtx.oldMap.get(sobj.Id);
                    
                  
                    if (newChannelRev.Status__c !=  oldChannelRev.Status__c && (newChannelRev.Status__c == Label.Channel_Business_Review_Status_Obsolete ||
                                                                                newChannelRev.Status__c == Label.Status_Completed)) {
                        
                        newChannelRev.Old_Record_Type_Value__c = oldChannelRev.RecordTypeId; // Copy the previous record type
                    
                    } else if (newChannelRev.Status__c !=  oldChannelRev.Status__c && (oldChannelRev.Status__c == Label.Channel_Business_Review_Status_Obsolete ||
                                oldChannelRev.Status__c == Label.Status_Completed) && newChannelRev.Old_Record_Type_Value__c != NULL && newChannelRev.Old_Record_Type_Value__c != '' &&
                        rtIdSet.contains(newChannelRev.Old_Record_Type_Value__c)){
                        
                        newChannelRev.RecordTypeId = newChannelRev.Old_Record_Type_Value__c;  // Update the previous record type
                    } 
                    // system.debug('::after old RT::'+newChannelRev.Old_Record_Type_Value__c);
                     //system.debug('::after new RT::'+newChannelRev.RecordTypeId);
                    processedIdSet.add(sobj.Id);
                } else{}              
            }
        }
    }
            
        
    /**
    * @see IntHelper.beforeTrigger
    */  
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {        
            countJBPActionRecords(trgCtx); 
                         
    }
        
    /**
    * @see IntHelper.AfterTrigger
    *To copy the opportunity information
    */  
    public override void bulkAfter(ClsWrappers.TriggerContext trgCtx) {
        if (trgCtx.isInsert) {
            copytheOpportuntiyInfos(trgCtx);
            copySalesTargetsResultsAndContactInfo(trgCtx);
            copyPlanAction(trgCtx);
        }
    }
    
     /**    
    *To copy the opportunity information
    */ 
    public void copytheOpportuntiyInfos(ClsWrappers.TriggerContext trgCtx){
        
        Set<Id> accountIdSet = new Set<Id>();
        List<Opportunity_Info_Channel_Business_Review__c> toBeCreatedOppReviewList = new List<Opportunity_Info_Channel_Business_Review__c>();
        Map<Id, List<Channel_Business_Review__c>> accIDChannelBusinessReviewListMap = new Map<Id, List<Channel_Business_Review__c>>();
        
        for (Sobject sobj : trgCtx.newList) {
            Channel_Business_Review__c review = (Channel_Business_Review__c )sObj;
            
            if (review.Account__c != NULL) {
                accountIdSet.add(review.Account__c);
                if (!accIDChannelBusinessReviewListMap.containsKey(review.Account__c)) {
                    accIDChannelBusinessReviewListMap.put(review.Account__c, new List<Channel_Business_Review__c>());
                }
                accIDChannelBusinessReviewListMap.get(review.Account__c).add(review);
            }
        }
        
        if (accountIdSet.size() > 0) {
            
            remLimit =  limits.getLimitQueryRows() - limits.getQueryRows(); 
            
            for (Opportunity_Information__c oppInfo: [SELECT Id, Name, Opportunity_Name_m__r.AccountId FROM Opportunity_Information__c WHERE Opportunity_Name_m__r.AccountId IN : accountIdSet LIMIT :remLimit ] ) {
                
                for (Channel_Business_Review__c channel : accIDChannelBusinessReviewListMap.get(oppInfo.Opportunity_Name_m__r.AccountId)) {
                    
                    toBeCreatedOppReviewList.add( new Opportunity_Info_Channel_Business_Review__c(Channel_Partner_Business_Review__c = channel.Id, Opportunity_Information__c = oppInfo.Id));
                }
            }
        }
        
        try {
            if (toBeCreatedOppReviewList.size() > 0) {
                Database.Insert(toBeCreatedOppReviewList);
            }
        } Catch(DMLException e) {
            String err = '';
            for (Integer i = 0; i < e.getNumDML(); i++) {
                err += e.getDMLMessage(i) +Label.Line_Break;
            }
            
            for (Sobject sobj : trgCtx.newList) {
                sobj.addError(err, false);
            }
        }
    }
    
/**    
*To copy Actions from Channel Partner Business Plan to Channel Partner Business Review
*/  
 
    public void copyPlanAction(ClsWrappers.TriggerContext trgCtx){
        
        List<Action_Information_Channel_Business_Revi__c> actionReviewList = new List<Action_Information_Channel_Business_Revi__c>();
        Map<Id, List<Channel_Business_Review__c >> planIdReviewListMap  = new Map<Id, List<Channel_Business_Review__c >>();
      
        
        for (Sobject sobj : trgCtx.newList) {
            
            Channel_Business_Review__c sobjJBP = (Channel_Business_Review__c )sObj;
            if (sobjJBP.Joint_Business_Plan__c != NULL) {
                if (!planIdReviewListMap.containsKey(sobjJBP.Joint_Business_Plan__c)) {
                    planIdReviewListMap.put(sobjJBP.Joint_Business_Plan__c, new List<Channel_Business_Review__c>());
                }
                planIdReviewListMap.get(sobjJBP.Joint_Business_Plan__c).add(sobjJBP);
            }
        }
        
        if (!planIdReviewListMap.isEmpty()) {
            
            remLimit =  limits.getLimitQueryRows() - limits.getQueryRows(); 
            
            for (Joint_Business_Plan_Actions__c actionPlan: [SELECT Id, Joint_Business_Plan__c, Action_Description__c, Comments__c FROM Joint_Business_Plan_Actions__c WHERE Joint_Business_Plan__c IN : planIdReviewListMap.KeySet() LIMIT :remLimit ] ) {
            
            for (Channel_Business_Review__c channel : planIdReviewListMap.get(actionPlan.Joint_Business_Plan__c)){
                                 
                    Action_Information_Channel_Business_Revi__c actionReview = new Action_Information_Channel_Business_Revi__c();
                    actionReview.Channel_Partner_Business_Review__c = channel.Id;
                    actionReview.Action__c = actionPlan.Id;
                    actionReview.Action_Description__c = actionPlan.Action_Description__c;
                    actionReview.Comments__c = actionPlan.Comments__c;
                    actionReviewList.add(actionReview);
                }
            }
        }
        
        try {
            if (actionReviewList.size() > 0) {
                insert actionReviewList;
            }
        } Catch(DMLException e) {
            String err = '';
            for (Integer i = 0; i < e.getNumDML(); i++) {
                err += e.getDMLMessage(i) +Label.Line_Break;
            }
            
            for (Sobject sobj : trgCtx.newList) {
                sobj.addError(err, false);
            }
        }
    }
        
    /**
    * Req #1960 (Update Joint Business Plan currency to Channel Business Review).     
    */     
    public void assingnCurrency(ClsWrappers.TriggerContext trgCtx) {
            
        Set<Id> parentIdSet = new Set<Id>();
        
        for (Sobject sobj : trgCtx.newList) {
            Channel_Business_Review__c sobjJBP = (Channel_Business_Review__c )sObj;
            parentIdSet.add(sobjJBP.Joint_Business_Plan__c);
        }
        
        if (parentIdSet.size() > 0) {
        
            remLimit =  limits.getLimitQueryRows() - limits.getQueryRows(); 
            Map<Id, Joint_Business_Plan__c> jointBusPlanMap = new Map<Id, Joint_Business_Plan__c> ([ SELECT Id, Channel_Market_Coverage__c, Channel_Market_Coverage__r.Focussed_Industry1__c, Channel_Market_Coverage__r.Product_Line1__c, CurrencyISOCode FROM Joint_Business_Plan__c WHERE Id IN :parentIdSet LIMIT :remLimit ] );
            
            for (Sobject sobj : trgCtx.newList) {
                Channel_Business_Review__c sobjJBP = (Channel_Business_Review__c )sObj;
                sobjJBP.CurrencyISOCode = jointBusPlanMap.get(sobjJBP.Joint_Business_Plan__c).CurrencyISOCode;
                
                if (jointBusPlanMap.get(sobjJBP.Joint_Business_Plan__c).Channel_Market_Coverage__c != NULL ) {
                    sobjJBP.Focused_Industry_hidden__c = jointBusPlanMap.get(sobjJBP.Joint_Business_Plan__c).Channel_Market_Coverage__r.Focussed_Industry1__c;
                    sobjJBP.Product_Line_Hidden_from_scope__c = jointBusPlanMap.get(sobjJBP.Joint_Business_Plan__c).Channel_Market_Coverage__r.Product_Line1__c ;
                }
            }
        }
    }
  
    /**    
*To copy Sales Targets and Results from Channel Partner Business Plan
*/  
    public void copySalesTargetsResultsAndContactInfo(ClsWrappers.TriggerContext trgCtx){
        
        List<Sales_and_Target_channel_business_review__c> salesTargetReviewList = new List<Sales_and_Target_channel_business_review__c>();
        Map<Id, List<Channel_Business_Review__c >> planIdReviewListMap  = new Map<Id, List<Channel_Business_Review__c >>();
        List<Contact_Information_Channel_Business_Rev__c> insertList = new List<Contact_Information_Channel_Business_Rev__c>();
        
        for (Sobject sobj : trgCtx.newList) {
            
            Channel_Business_Review__c sobjJBP = (Channel_Business_Review__c )sObj;
            if (sobjJBP.Joint_Business_Plan__c != NULL) {
                if (!planIdReviewListMap.containsKey(sobjJBP.Joint_Business_Plan__c)) {
                    planIdReviewListMap.put(sobjJBP.Joint_Business_Plan__c, new List<Channel_Business_Review__c>());
                }
                planIdReviewListMap.get(sobjJBP.Joint_Business_Plan__c).add(sobjJBP);
            }
        }
        
        if (!planIdReviewListMap.isEmpty()) {
            
            remLimit =  limits.getLimitQueryRows() - limits.getQueryRows(); 
            
            for (Joint_Business_Plan_Product_Lines__c prdLine : [SELECT Id, Joint_Business_Plan__r.CurrencyISOCode, Joint_Business_Plan__c  FROM Joint_Business_Plan_Product_Lines__c WHERE Joint_Business_Plan__c IN : planIdReviewListMap.KeySet() LIMIT :remLimit ] ) {
                
                for (Channel_Business_Review__c review: planIdReviewListMap.get(prdLine.Joint_Business_Plan__c)) {
                    
                    Sales_and_Target_channel_business_review__c salesTargetReview = new Sales_and_Target_channel_business_review__c();
                    salesTargetReview.Channel_Partner_Business_Review__c = review.Id;
                    salesTargetReview.Sales_Targets_and_Results__c = prdLine.Id;
                    salesTargetReview.CurrencyISOCode = prdLine.Joint_Business_Plan__r.CurrencyISOCode;
                    salesTargetReviewList.add(salesTargetReview);
                }
            }
            
            
            for (Joint_Business_Plan_Contact_Role__c role: [SELECT Id, Joint_Business_Plan__c, Product_Lines__c FROM Joint_Business_Plan_Contact_Role__c WHERE Joint_Business_Plan__c IN : planIdReviewListMap.KeySet() LIMIT :remLimit ] ) {
                
                for (Channel_Business_Review__c review: planIdReviewListMap.get(role.Joint_Business_Plan__c)) {
                    
                    insertList.add( new Contact_Information_Channel_Business_Rev__c(
                         Channel_Partner_Business_Review__c = review.Id, Channel_Partner_Contact_Roles__c = role.Id,
                          Product_Lines_form_ContactRole__c = role.Product_Lines__c));
                }
            }
        }
        
        try {
            if (salesTargetReviewList.size() > 0) {
                insert salesTargetReviewList;
            }
            
             if (insertList.size() > 0) insert insertList;
        } Catch(DMLException e) {
            String err = '';
            for (Integer i = 0; i < e.getNumDML(); i++) {
                err += e.getDMLMessage(i) +Label.Line_Break;
            }
            
            for (Sobject sobj : trgCtx.newList) {
                sobj.addError(err, false);
            }
        }
    }
       
    /**
    * void method countJBPActionRecords 
    */     
    @TestVisible 
    private void countJBPActionRecords(ClsWrappers.TriggerContext trgCtx) {  
        Integer openActionsCnt = null;
        Set<String> jbpIds = new Set<String>();
        Map<Id,Integer> mapJBP=new Map<Id,Integer>();
        Map<Id,Integer> mapJBPInProgActions = new Map<Id,Integer>();
        Map<Id,Integer> mapJBPCompletedActions = new Map<Id,Integer>();
        
        
        if(trgCtx.isInsert || trgCtx.isUpdate){
            for (sobject sObj : trgCtx.newList) { 
                Channel_Business_Review__c chanBusReview = (Channel_Business_Review__c)sObj;
                if(chanBusReview.Joint_Business_Plan__c != null){
                    jbpIds.add(chanBusReview.Joint_Business_Plan__c);
                }
            }
            if(jbpIds != NULL && jbpIds.size() > 0 ){      
               for(Joint_Business_Plan_Actions__c ActionsRecs : [select Id, Status__c, Joint_Business_Plan__c from Joint_Business_Plan_Actions__c  where  Joint_Business_Plan__c =:jbpIds LIMIT 50000]){
                   
                   if(mapJBP.containskey(ActionsRecs.Joint_Business_Plan__c)){
                       mapJBP.put(ActionsRecs.Joint_Business_Plan__c, mapJBP.get(ActionsRecs.Joint_Business_Plan__c)+1 );
                       
                   }else{
                       mapJBP.put(ActionsRecs.Joint_Business_Plan__c,1);
                   }
                   //checking In Progress status Joint Business Plan Actions
                   if(mapJBPInProgActions.containskey(ActionsRecs.Joint_Business_Plan__c) && (ActionsRecs.Status__c== Label.Actions_Status_In_Progress)){
                       mapJBPInProgActions.put(ActionsRecs.Joint_Business_Plan__c, mapJBPInProgActions.get(ActionsRecs.Joint_Business_Plan__c)+1 );
                       
                   }else if(ActionsRecs.Status__c== Label.Actions_Status_In_Progress){
                       mapJBPInProgActions.put(ActionsRecs.Joint_Business_Plan__c,1);
                   }else{}
                   //checking Completed status Joint Business Plan Actions
                   if(mapJBPCompletedActions.containskey(ActionsRecs.Joint_Business_Plan__c) && (ActionsRecs.Status__c== Label.Actions_Status_Completed)){
                       mapJBPCompletedActions.put(ActionsRecs.Joint_Business_Plan__c, mapJBPCompletedActions.get(ActionsRecs.Joint_Business_Plan__c)+1 );
                       
                   }else if(ActionsRecs.Status__c== Label.Actions_Status_Completed){
                       mapJBPCompletedActions.put(ActionsRecs.Joint_Business_Plan__c,1);
                   }else{}
                    
                //System.debug('------------'+ mapJBP.get(ActionsRecs.Joint_Business_Plan__c)); 
               } 
                        
            }
           
            for (sobject sObj : trgCtx.newList) { 
                Channel_Business_Review__c chanBusReview = (Channel_Business_Review__c)sObj;
                chanBusReview.Actions_Answer_2__c ='';
                chanBusReview.Total_Number_of_Actions_In_Progress__c='';
                chanBusReview.Total_Number_of_Actions_Completed__c='';
                if(mapJBP.containskey(chanBusReview.Joint_Business_Plan__c)){
                //System.debug('loop1'+chanBusReview.Status__c);
                    chanBusReview.Actions_Answer_2__c=string.ValueOf(mapJBP.get(chanBusReview.Joint_Business_Plan__c));
                }
                if(mapJBPInProgActions.containskey(chanBusReview.Joint_Business_Plan__c)){
                //System.debug('loop2'+chanBusReview.Status__c);
                    chanBusReview.Total_Number_of_Actions_In_Progress__c=string.ValueOf(mapJBPInProgActions.get(chanBusReview.Joint_Business_Plan__c));
                }
                if(mapJBPCompletedActions.containskey(chanBusReview.Joint_Business_Plan__c) ){
                //System.debug('loop3'+chanBusReview.Status__c);
                chanBusReview.Total_Number_of_Actions_Completed__c=string.ValueOf(mapJBPCompletedActions.get(chanBusReview.Joint_Business_Plan__c));
                }
            } 
        }            
    } 
}