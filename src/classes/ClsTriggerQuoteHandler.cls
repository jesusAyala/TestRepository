/**   
* ClsTriggerQuoteHandler
* Release R5
*  
* @author  Shankar Anand (Accenture)
* @created 2015-12-11 @version 1.0 
* #2504
*/ 
public without sharing class ClsTriggerQuoteHandler extends ClsTriggerVirtual {
    public Static Set<Id> processedOppIdSet = new Set<Id>();
    /**
    * @see IntHelper.beforeTrigger
    */
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
        
    }
    
    /**
    * @see IntHelper.afterTrigger
    */
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
        try
        {
            checkQuoteStatus(trgCtx);
            updateOpptyChangeOnQTM(trgCtx);
        }
        catch(DMLException e){  string err = e.getmessage(); } 
    }
    
    
     /**
     *This trigger is used to check if all the quotes associated to the Opportunity are closed.
     *
     @author  Shankar Anand
     @created 2015-05-02
     @version 1.0
     @since   35.0 (Force.com ApiVersion)
     **/   
    @TestVisible 
    private void checkQuoteStatus(ClsWrappers.TriggerContext trgCtx) 
    {
     Map<Id,Apttus_Proposal__Proposal__c> quoteMap = new Map<Id,Apttus_Proposal__Proposal__c>();
     //Set<Apttus_Proposal__Proposal__c> quoteSet = new Set<Apttus_Proposal__Proposal__c>();
     //Map<Id,Set<Apttus_Proposal__Proposal__c>> opptyQuoteMap = new Map<Id,Set<Apttus_Proposal__Proposal__c>>(); 
     Map<Id,Opportunity> opptyMap = new Map<Id,Opportunity>();
     List<Opportunity> opptyList = new List<Opportunity>();
     List<User> user = new List<User>();
     Set<Id> opptyIds = new Set<Id>();
     Integer count =0;   
     if (trgCtx.isAfter && (trgCtx.isInsert || trgCtx.isUpdate)) 
        {        
            for(sobject so : trgCtx.newList)
            {
                Apttus_Proposal__Proposal__c quot = (Apttus_Proposal__Proposal__c)so;
                if(!processedOppIdSet.contains(quot.Id) && (trgCtx.isInsert || (trgCtx.isUpdate && (((Apttus_Proposal__Proposal__c)trgCtx.oldMap.get(quot.id)).Quotation_status__c!=quot.Quotation_status__c || ((Apttus_Proposal__Proposal__c)trgCtx.oldMap.get(quot.id)).APTS_Quotation_Category__c!=quot.APTS_Quotation_Category__c))))
                  {  
                      opptyIds.add(quot.Apttus_Proposal__Opportunity__c);
                      processedOppIdSet.add(quot.Id);
                  }
            }
            
            if(opptyIds.size()>0){
            Id CQP = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(System.label.System_CQP).getRecordTypeId();
            Id LPSpain = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(System.label.System_CL00107).getRecordTypeId();
            List<Id> recordTypes = new List<Id>();
            recordTypes.add(CQP);
            recordTypes.add(LPSpain);
           
            if(opptyIds.size()>0){
            user = [Select Id, Name,Bypass_Opportunity_Validations__c from User where id =: userinfo.getUserId() Limit 1];
            quoteMap = new Map<Id,Apttus_Proposal__Proposal__c>([Select Id, Name, Apttus_Proposal__Opportunity__c, Quotation_status__c,APTS_Quotation_Category__c from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c in : opptyIds and recordTypeid in :recordTypes and APTS_Is_Placeholder_Quote__c = false limit 50000]);
            opptyMap = new Map<Id,Opportunity>([Select Id, Name, All_Quotes_Closed__c from Opportunity where id in :opptyIds LIMIT 50000]);
            }
           
            for(sobject so : trgCtx.newList)
            {
            Apttus_Proposal__Proposal__c quot = (Apttus_Proposal__Proposal__c)so;
            Opportunity opp = opptyMap.get(quot.Apttus_Proposal__Opportunity__c);
            Set<Apttus_Proposal__Proposal__c> quoteSet = new Set<Apttus_Proposal__Proposal__c>();
            Map<Id,Set<Apttus_Proposal__Proposal__c>> opptyQuoteMap = new Map<Id,Set<Apttus_Proposal__Proposal__c>>();
            
            for(Apttus_Proposal__Proposal__c quo:quoteMap.values()){
                if(quot.Apttus_Proposal__Opportunity__c!=null&&quot.Apttus_Proposal__Opportunity__c.equals(quo.Apttus_Proposal__Opportunity__c)){
                    quoteSet.add(quo);
                }
            }
           
            opptyQuoteMap.put(quot.Apttus_Proposal__Opportunity__c,quoteSet);
            
            for(Apttus_Proposal__Proposal__c qut:opptyQuoteMap.get(quot.Apttus_Proposal__Opportunity__c)){
                if((qut.Quotation_status__c!=null &&(qut.Quotation_status__c.equals(System.label.Quote_Status_Closed) || qut.Quotation_status__c.equals(System.label.Quotation_status_won) || qut.Quotation_status__c.equals(System.label.Quotation_status_loss) || qut.Quotation_status__c.equals(System.label.Quotation_status_Partially_Ordered) || qut.Quotation_status__c.equals(System.label.Quotation_status_Ordered) || qut.Quotation_status__c.equals(System.label.Quotation_status_After_Order_Created) || qut.Quotation_status__c.equals(System.label.Quotation_status_Not_Ordered) || qut.Quotation_status__c.equals(System.label.Quotation_status_Sent_to_bol))) || (qut.APTS_Quotation_Category__c!=null && qut.APTS_Quotation_Category__c.equals(System.label.Apttus_Status_Closed))){
                    count++;
                }
            }
            
            if(opptyQuoteMap.get(quot.Apttus_Proposal__Opportunity__c)!=null && count!= 0 && opptyQuoteMap.get(quot.Apttus_Proposal__Opportunity__c).size() == count){    
                if(opp!=null){
                    opp.All_Quotes_Closed__c = true;
                }
            }
            else if(opptyQuoteMap.get(quot.Apttus_Proposal__Opportunity__c)!= null && opptyQuoteMap.get(quot.Apttus_Proposal__Opportunity__c).size() != count){
                if(opp!=null){
                    opp.All_Quotes_Closed__c = false;
                    opp.Closed_Quotes_Task_Created__c = false;
                }
            }
            if(opp!=null){
                opptyList.add(opp);
            }
            count = 0;
            }
        try{ 
            if(opptyList.size()>0){
            if(user.size()>0){
            user[0].Bypass_Opportunity_Validations__c = true;
            Database.Update(user,False);
            } 
            
            ClsTriggerFactory.isSkipOpptyTrigger = true;  
            Database.update(opptyList,false);
            if(user.size()>0){      
            user[0].Bypass_Opportunity_Validations__c = false;
            Database.Update(user,False);    
            }   
            } 
        }catch(Exception e){
            String err=e.getMessage();
            if(user.size()>0){
            user[0].Bypass_Opportunity_Validations__c = false;
            Database.Update(user,False);
            }
            }
        }    
        }
    }
    
    /**
     *This trigger is used to update the 'Oppty changed on quote' field on Quote Team member 
     *when the Opportunity on the existing Quote is changed in CQP.
     *
     @author  Shankar Anand
     @created 2015-05-02
     @version 1.0
     @since   35.0 (Force.com ApiVersion)
     **/   
    @TestVisible 
    private void updateOpptyChangeOnQTM(ClsWrappers.TriggerContext trgCtx) 
    {
    Set<Id> quoteSet = new Set<Id>();
    List<Quote_Team_Member__c> quoteTeamMemberList = new List<Quote_Team_Member__c>();
    Set<Quote_Team_Member__c> quoteTeamMemberSet = new Set<Quote_Team_Member__c>();
      if (trgCtx.isAfter && trgCtx.isUpdate) 
        {        
            for(sobject so : trgCtx.newList)
            {
                Apttus_Proposal__Proposal__c quot = (Apttus_Proposal__Proposal__c)so;
                if(((Apttus_Proposal__Proposal__c)trgCtx.oldMap.get(quot.id)).Apttus_Proposal__Opportunity__c != quot.Apttus_Proposal__Opportunity__c){     
                    quoteSet.add(quot.id);                  
                }
            }
            if(quoteSet.size()>0){
            Id CQP = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(System.label.System_CQP).getRecordTypeId();
            for(Quote_Team_Member__c qtm:[Select Id, Name, Oppty_changed_on_quote__c, Quotation__c from Quote_Team_Member__c where Quotation__c in :quoteSet and Quotation__r.recordTypeid =: CQP]){
                qtm.Oppty_changed_on_quote__c = true;
                quoteTeamMemberSet.add(qtm);
            }
            
            quoteTeamMemberList.addAll(quoteTeamMemberSet);
            Database.update(quoteTeamMemberList,false);
            }
        }
    
    }
    
}