/**
*  @Name: ClsTriggerOpportunityHandler
*  @return - void
*  @Description - This class helps to control the Opportunity Trigger logic
*  @Author : Rajesh Kaliyaperumal (Accenture)
*  Opportuniyt Handler : Set LPU and LPG* Opportuniyt Handler : Set LPU and LPG
*   Release R4
*  @author  MohanRaj Kasinathan (Accenture)
*  @created  2015-09-08* @version 1.0

*/
public with sharing class ClsTriggerOpportunityHandler extends ClsTriggerVirtual {

    public Static Set<Id> processedOpptyIdSet = new Set<Id>();
/**
 * @see IntHelper.beforeTrigger
*/
public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {       
        setOpportunityRecordtypeBefore(trgCtx);
          
       //Req 2280 - Updating Account End User with Account Customer if Channel Class is 'DEU' and Account End User is empty
       updateAccountEndUser(trgCtx);
       
       //Req 2500 - Preventing Account Customer LSO reference data and Account End User LSO reference data population from any account except the Account Customer and the Account End User
       checkAccountCustandAccountEULSOPopulation(trgCtx);
        //Req 2168 - Local reference data auto population on opportunity
        setLSORefDatafromAccount(trgCtx);    
       //Req 2504 - Preventing opportunity with open quotations from closure
       preventOpptyClosure(trgCtx);    
       
       //Req 2510 - Updating the main opportunity
       updateMainOpportunity(trgCtx);
            try
        {
            setLBUandLPG(trgCtx);
        }
        catch(DMLException e){  string err = e.getmessage(); } 
        //R5 ServIS integration
       sendCloseOppRequestToServIS(trgCtx);
          
    }    
/**    
 * @see IntHelper.afterTrigger
*/
public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
    setContactAsPrimaryContactRole(trgCtx);
     setOpportunityRecordtypeAfter(trgCtx);
     try
        {
            setContactAsPrimaryContactRole(trgCtx);
            opportunityCreation(trgCtx);
            
            //Req 2281 - Making the Competitor's Winning company field blank in case the Opportunity Winner selected is not a part of Competitor
            syncWinnerManualUpdate(trgCtx);
            
            //Req 2281 - Update Estimated Wnner's Price when Opportunity value is changed
            updateWinnerPrice(trgCtx);
            
            
        }
    catch(DMLException e){  string err = e.getmessage(); } 
    }  
    /**
     *This trigger is used to send request to ServIS.
     @author  Rajesh Kaliyaperumal
     @created 2016-02-22
    */
   @TestVisible 
    private void sendCloseOppRequestToServIS(ClsWrappers.TriggerContext trgCtx) {    
        if (trgCtx.isUpdate && trgCtx.isBefore) {
            Set<ID> setOppids = new Set<ID>();
            for (sobject so : trgCtx.newList) {
                Opportunity oppy = (Opportunity)so; 
                System.debug('ServIS Init Closure'+oppy.stageName + ' '+oppy.ServIS_Initiated__c + ' ' +oppy.ServIS_Iterator_check__c);              
                if(oppy.stageName.contains(System.label.Closed) && oppy.ServIS_Initiated__c && oppy.ServIS_Iterator_check__c){                  
                    System.debug('ServIS Identified Closure');
                    setoppids.add(oppy.id);
                    oppy.ServIS_Iterator_check__c= false;
                }
            }            
            if(setoppids.size()>0){
                System.debug('ServIS Method Closure');
                if(System.isFuture()) {
                    return;
                }
                requesttoServIS(setoppids);
            }                 
            /*if(setOppids.size()>0 && setOppids.size()<100){
                for(ID oppid : setOppids){              
                    
                }
                List<OpportunityLineItem> lstopplineitem = [Select ServIS_Opp_Id__c from OpportunityLineItem where opportunityid in: setOppids and ServIS_Opp_Id__c != null];
                if(lstopplineitem.size()>0 && lstopplineitem.size()<100){
                    for(OpportunityLineItem oppli : lstopplineitem){
                        if(oppli.ServIS_Opp_Id__c != null){
                            requesttoServIS(String.valueof(oppli.ServIS_Opp_Id__c), oppli.id);
                        }                       
                    }
                }
            }*/
        } 
    } 
/**
 *void method void requesttoServIS.
*/        
    @Future(callout=true)
    Public static void requesttoServIS(Set<Id> setoppids)
    {
        List<Opportunity> lstupdOpportunity = new List<Opportunity>();
        for(Id oppid : setoppids){
            System.debug('ServIS Future Closure');
            HttpRequest req = new HttpRequest();
            req.setMethod(System.label.INTEG_SYS_SERVIS_Response_GET);
            String autorithationServIS = System.label.SYS_ServIS_Autorithation;
            req.setHeader('Authorization', autorithationServIS );
            //String reqbody = 'https://www1008.abb.com/stage/servisws/sfdc/Opportunity.svc/close/13Q1492017?email='+ 'mariusz.stala@pl.abb.com';
            String endpointS = System.label.INTEG_SYS_SERVIS_endPoint;
            String reqbody = endpointS + String.valueof(oppid) +'?email='+ UserInfo.getUserEmail();
            req.setEndpoint(reqbody); 
            Http http = new Http();
            try{
                HTTPResponse res = http.send(req);
                System.debug('Servis Feedback Object' + String.valueof(res));
                System.debug('Servis Feedback Body' + String.valueof(res.getBody()));
                //lstupdOpportunity.add(new Opportunity(id = oppid, ServIS_Response_Feedback__c = String.valueof(res.getBody())));
            }catch(Exception e){System.debug('ServIS error'+ e.getMessage());}
        }   
        /**try{     
        Database.update(lstupdOpportunity, false);
        }catch(Exception e){String err=e.getMessage();}*/
    }
    /**
    *  @Name: setOpportunityRecordtypeBefore
    *  @return - void
    *  @Description - Method to set default channel class from account,
    *  decide record type based on Product Group condition
    *  Method updated to set defalut channel class level1 and level2 from account
    */ 
    @TestVisible 
    private void setOpportunityRecordtypeBefore(ClsWrappers.TriggerContext trgCtx) {        
                    
        List<Opportunity> lstopp = new List<Opportunity>();
        Set<Id> accids = new Set<Id>();
        Set<Id> oppIds = new Set<Id>();
        Set<Id> productGroupids = new Set<Id>();
        Map<Id, List<OpportunityLineItem>> mapOppLineItems = new Map<Id, List<OpportunityLineItem>>();
        Set<String> productGroups = new Set<String>();
        Map<String,CurrencyType> conversion_rates = new Map<String,CurrencyType>();
        Map<String, Product_Group__c> mapProductGroups = new Map<String, Product_Group__c>();
        Map<String, Schema.RecordTypeInfo> oPPORTUNITY_RECORD_TYPES = Schema.SObjectType.Opportunity.getRecordTypeInfosByName();
        String oPP_INITIAL_RECORD_TYPE_ID = oPPORTUNITY_RECORD_TYPES.get(System.label.Opportunity_RecordType_Initial).getRecordTypeId();
        String oPP_REGULAR_RECORD_TYPE_ID = oPPORTUNITY_RECORD_TYPES.get(System.label.Opportunity_RecordType_Regular).getRecordTypeId();
        String oPP_FASTTRACK_RECORD_TYPE_ID = oPPORTUNITY_RECORD_TYPES.get(System.label.Opportunity_RecordType_FastTrack).getRecordTypeId();
        if((trgCtx.isBefore && trgCtx.isInsert) || (trgCtx.isBefore && trgCtx.isUpdate))
        { 
            for (sobject so : trgCtx.newList) {
                Opportunity oppy = (Opportunity)so;
                accids.add(oppy.AccountId);         
                if(oppy.Product_Group__c != null){
                    productGroupids.add(oppy.Product_Group__c);
                }
            }
            for(CurrencyType curr : [SELECT ISOCode, ConversionRate FROM CurrencyType WHERE IsActive=TRUE LIMIT 50000]){
                conversion_rates.put(curr.ISOCode,curr);
            }
        }
        
        if(trgCtx.isBefore && trgCtx.isInsert)
        {               
            Map<id,Account> mapaccount = new Map<Id,Account>([Select id, Channel_Class_Level1__c, Channel_Class_Level2__c ,Industry__c from Account where Id IN: accids LIMIT 50000]);
            Map<id,Product_Group__c> mapProductGroup = new Map<Id,Product_Group__c>([Select id, Opportunity_Default_Type__c, CurrencyIsoCode, Opportunity_Threshold__c from Product_Group__c where Id IN: productGroupids LIMIT 50000]);
            for (sobject so : trgCtx.newList) {
                Opportunity oppy = (Opportunity)so;                 
                if (mapaccount.containskey(oppy.AccountId) && mapaccount.get(oppy.AccountId).Channel_Class_Level1__c!= null && oppy.Channel_Class_Level1__c == null) {                    
                    oppy.Channel_Class_Level1__c = mapaccount.get(oppy.AccountId).Channel_Class_Level1__c;
                    oppy.Channel_Class_Level2__c = mapaccount.get(oppy.AccountId).Channel_Class_Level2__c;
                }
                /*if (mapaccount.containskey(oppy.AccountId) && mapaccount.get(oppy.AccountId).Channel_Class_Level2__c!= null && oppy.Channel_Class_Level2__c == null) {
                    //oppy.Channel_Class_Level2__c = mapaccount.get(oppy.AccountId).Channel_Class_Level2__c;
                }*/
                
               /* if (mapaccount.get(oppy.AccountId).Industry__c != null) { 
                    // oppy.Industry_Usage__c = mapaccount.get(oppy.AccountId).Industry__c;
                }*/
                /*if(oppy.Product_Group__c == null){
                    oppy.Recordtypeid = oPP_INITIAL_RECORD_TYPE_ID;
                }*/
                //set Record type change as per business logic, Product group's default equals "Regular" or opportunity's value exceeds Product Group's threshold
                if(mapProductGroup.containsKey(oppy.Product_Group__c) && oppy.Product_Group__c != null){
                    /*if(mapProductGroup.get(oppy.Product_Group__c).Opportunity_Default_Type__c.equals(System.label.Opportunity_RecordType_Regular) ||  
                    (oppy.Opportunity_Value__c != null && mapProductGroup.get(oppy.Product_Group__c).Opportunity_Threshold__c != null && 
                    (oppy.Opportunity_Value__c/conversion_rates.get(oppy.CurrencyIsoCode).ConversionRate) > (mapProductGroup.get(oppy.Product_Group__c).Opportunity_Threshold__c/conversion_rates.get(mapProductGroup.get(oppy.Product_Group__c).CurrencyIsoCode).ConversionRate))){
                        oppy.Recordtypeid = oPP_REGULAR_RECORD_TYPE_ID;
                    }else{
                        oppy.Recordtypeid = oPP_FASTTRACK_RECORD_TYPE_ID;
                    }*/
                    oppy.isPGManualUpdate__c = true;
                }
            }
        }        
        
        //set Record type change as per business logic, 
        //Product group's default equals "Regular" or opportunity's value exceeds Product Group's threshold
        if(trgCtx.isBefore && trgCtx.isUpdate && ClsTriggerFactory.isSkipOpportunityRecursiveTrigger == true){
            Set<String> productGroupNames = new Set<String>(); 
            Map<String,Product_Group__c> mapProductGroupNames = new Map<String,Product_Group__c>();
            for (sobject so : trgCtx.newList) {
                Opportunity oppy = (Opportunity)so;             
                productGroupNames.add(oppy.Product_Primary_PG__c);
            }
            for(Product_Group__c objPG : [Select id,Name from Product_Group__c where Name IN: ProductGroupNames LIMIT 50000]){
                mapProductGroupNames.put(objPG.Name,objPG);
            }
            for (sobject so : trgCtx.newList) {
                Opportunity oppy = (Opportunity)so;               
                if(((Opportunity)trgCtx.oldMap.get(oppy.Id)).Product_Group__c != oppy.Product_Group__c && oppy.Product_Group__c != null){
                    oppy.isPGManualUpdate__c = true;
                }
                /*if(((Opportunity)trgCtx.oldMap.get(oppy.Id)).Product_Group__c != oppy.Product_Group__c && oppy.Product_Group__c == null && oppy.Is_Product_Available__c == false){                   
                    oppy.Recordtypeid = oPP_INITIAL_RECORD_TYPE_ID;
                }else if(((Opportunity)trgCtx.oldMap.get(oppy.Id)).Product_Group__c != oppy.Product_Group__c && oppy.Product_Group__c == null && oppy.isPGManualUpdate__c == true && oppy.Product_Primary_PG__c == null){
                    oppy.Recordtypeid = oPP_INITIAL_RECORD_TYPE_ID;
                }*/
                if(oppy.isPGManualUpdate__c == false && oppy.Product_Primary_PG__c == null)
                    oppy.Product_Group__c = null;
                if(oppy.Product_Group__c == null && oppy.Product_Primary_PG__c != null && mapProductGroupNames.containskey(oppy.Product_Primary_PG__c)){                    
                    oppy.Product_Group__c = mapProductGroupNames.get(oppy.Product_Primary_PG__c).id;
                    oppy.isPGManualUpdate__c = false;
                }               
               /* if(oppy.Product_Group__c == null && oppy.Product_Primary_PG__c == null){
                    oppy.Recordtypeid = oPP_INITIAL_RECORD_TYPE_ID;
                }
                
                System.debug('Logging111:'+ oppy.Recordtypeid);
                System.debug('Logging222:'+ oppy.Product_Group__c);
                System.debug('Logging333:'+ oppy.Product_Primary_PG__c);*/
            }
            //ClsTriggerFactory.isSkipOpportunityRecursiveTrigger = false;
        }        
    }    
    /**
    *  @Name: setOpportunityRecordtypeAfter
    *  @return - void
    *  @Description - Method to set record type based on Product Group condition
    */ 
    @TestVisible 
    private void setOpportunityRecordtypeAfter(ClsWrappers.TriggerContext trgCtx) {     
        //if(trgCtx.isAfter && trgCtx.isUpdate && ClsTriggerFactory.isSkipOpportunityRecursiveTrigger == true){
        if(trgCtx.isAfter && trgCtx.isUpdate && ClsTriggerFactory.isSkipOpportunityRecursiveTrigger){
            Set<Id> productGroupids = new Set<Id>();
            Set<String> productGroupNames = new Set<String>();          
            List<Opportunity> lstupdOpportunity = new List<Opportunity>();
            //List<Opportunity> lstupdOpportunity1 = new List<Opportunity>();
            Map<String,CurrencyType> conversion_rates = new Map<String,CurrencyType>();
            Set<Id> oppIds = new Set<Id>();
            Set<Id> prodIds = new Set<Id>();
            Map<ID, String> mapProducts = new Map<ID, String>();
            Map<Id, List<OpportunityLineItem>> mapOppLineItems = new Map<Id, List<OpportunityLineItem>>();
            Map<String, Schema.RecordTypeInfo> oPPORTUNITY_RECORD_TYPES = Schema.SObjectType.Opportunity.getRecordTypeInfosByName();
            String oPP_INITIAL_RECORD_TYPE_ID = oPPORTUNITY_RECORD_TYPES.get(System.label.Opportunity_RecordType_Initial).getRecordTypeId();
            String oPP_REGULAR_RECORD_TYPE_ID = oPPORTUNITY_RECORD_TYPES.get(System.label.Opportunity_RecordType_Regular).getRecordTypeId();
            String oPP_FASTTRACK_RECORD_TYPE_ID = oPPORTUNITY_RECORD_TYPES.get(System.label.Opportunity_RecordType_FastTrack).getRecordTypeId();
            Map<String,Product_Group__c> mapProductGroupNames = new Map<String,Product_Group__c>();
            for (sobject so : trgCtx.newList) {
                Opportunity oppy = (Opportunity)so;
                //if(oppy.Is_Cancelled__c != true){
                //if(oppy.Is_Cancelled__c != true){
                    if(oppy.Product_Group__c != null){
                        productGroupids.add(oppy.Product_Group__c);                   
                    }
                    oppIds.add(oppy.id);
                    productGroupNames.add(oppy.Product_Primary_PG__c);
                //}


            }
            ClsTriggerOpportunityProductHandler objOppProductHandler = new ClsTriggerOpportunityProductHandler();
            mapOppLineItems = objOppProductHandler.buildOpportunitylineitem(oppIds);
            
            for(ID oppId : mapOppLineItems.Keyset())  
            { 
                for(OpportunityLineItem opplineRec : mapOppLineItems.get(oppId)){                   
                    prodIds.add(opplineRec.Product2id);
                }
            }
            for(Product2 prod : [Select id,Product_Group__c from Product2 where id in:prodIds LIMIT 50000]){
                mapProducts.put(prod.id,String.valueof(prod.Product_Group__c));
            } 
            
            for(CurrencyType curr : [SELECT ISOCode, ConversionRate FROM CurrencyType WHERE IsActive=TRUE LIMIT 50000]){
                conversion_rates.put(curr.ISOCode,curr);
            }
            Map<id,Product_Group__c> mapProductGroup = new Map<Id,Product_Group__c>([Select id, Opportunity_Default_Type__c, 
                                                                                     CurrencyIsoCode, Opportunity_Threshold__c 
                                                                                     FROM Product_Group__c 
                                                                                     WHERE Id IN: productGroupids LIMIT 50000]);           
            for(Product_Group__c objPG : [Select id,Name from Product_Group__c where Name IN: ProductGroupNames LIMIT 50000]){
                mapProductGroupNames.put(objPG.Name,objPG);
            }
            for (sobject so : trgCtx.newList) {
                Opportunity oppy = (Opportunity)so;
                //if(oppy.Is_Cancelled__c != true){
                //if(oppy.Is_Cancelled__c != true){
                    Boolean groupCheck = false;
                    if(mapOppLineItems.containsKey(oppy.id)){
                        for(OpportunityLineItem oppline : mapOppLineItems.get(oppy.id)){
                            if(mapProducts.get(oppline.Product2id) != null){
                                groupCheck = true;
                            }
                        }
                    }

                    //if(oppy.isPGManualUpdate__c == true && ((Opportunity)trgCtx.oldMap.get(oppy.Id)).Recordtypeid != oppy.Recordtypeid && oppy.Product_Group__c != null){                    
                   /* if(oppy.isPGManualUpdate__c == true && oppy.Product_Group__c != null){                    
                        if(mapProductGroup.get(oppy.Product_Group__c).Opportunity_Default_Type__c.equals(System.label.Opportunity_RecordType_Regular) ||  
                        (oppy.Opportunity_Value__c != null && mapProductGroup.get(oppy.Product_Group__c).Opportunity_Threshold__c != null && 
                        (oppy.Opportunity_Value__c/conversion_rates.get(oppy.CurrencyIsoCode).ConversionRate) > (mapProductGroup.get(oppy.Product_Group__c).Opportunity_Threshold__c/conversion_rates.get(mapProductGroup.get(oppy.Product_Group__c).CurrencyIsoCode).ConversionRate)) && oppy.Stagename == 'Opportunity Pursuit'){                        
                            lstupdOpportunity.add(new Opportunity(id = oppy.id, Recordtypeid = oPP_REGULAR_RECORD_TYPE_ID));
                        }//Added for 4.1 changes
                        else if(oppy.Stagename == 'Opportunity Pursuit'){
                            lstupdOpportunity.add(new Opportunity(id = oppy.id, Recordtypeid = oPP_FASTTRACK_RECORD_TYPE_ID));
                        }
                        //Removed for 4.1 changes
                        /*else if(((Opportunity)trgCtx.oldMap.get(oppy.Id)).Recordtypeid <> oPP_REGULAR_RECORD_TYPE_ID && oppy.Recordtypeid <> oPP_REGULAR_RECORD_TYPE_ID){
                            lstupdOpportunity.add(new Opportunity(id = oppy.id, Recordtypeid = oPP_FASTTRACK_RECORD_TYPE_ID));                                                             

                        }
                        








                    }*/

                    System.debug('Outside');
                    //if(oppy.isPGManualUpdate__c == false && (((Opportunity)trgCtx.oldMap.get(oppy.Id)).Opportunity_Value__c != oppy.Opportunity_Value__c)|| ((Opportunity)trgCtx.oldMap.get(oppy.Id)).Recordtypeid != oppy.Recordtypeid){
                    //if(oppy.isPGManualUpdate__c == false){
                    if(oppy.isPGManualUpdate__c == false){
                    System.debug('Inside');
                        ID productid = null;
                        if(mapProductGroupNames.containskey(oppy.Product_Primary_PG__c)){
                            productid = mapProductGroupNames.get(oppy.Product_Primary_PG__c).id;
                        }
                        //>>>>>>>>>>>>>>>>>>>
                        Decimal oppValue = 0;
                        if(oppy.Opportunity_Value__c != null){
                            oppValue = oppy.Opportunity_Value__c;
                        }    
                        //>>>>>>>>>>>>>
                       System.debug('Logging777:'+productid);
                       lstupdOpportunity.add(new Opportunity(id = oppy.id, Product_Group__c = productid));
                       /* if(oppy.Product_Group__c == null && groupCheck == false && (oppy.Product_Primary_PG__c == null || productid == null)){
                            lstupdOpportunity.add(new Opportunity(id = oppy.id, Recordtypeid = oPP_INITIAL_RECORD_TYPE_ID));
                        }else if(oppy.Is_Product_Available__c == true && (oppy.If_any_PG_Regular__c == true || oppValue/conversion_rates.get(oppy.CurrencyIsoCode).ConversionRate > oppy.Min_Product_Group_Threshold__c) && oppy.Stagename == 'Opportunity Pursuit'){
                            lstupdOpportunity.add(new Opportunity(id = oppy.id, Product_Group__c = productid, Recordtypeid = oPP_REGULAR_RECORD_TYPE_ID));
                        }else if(oppy.Is_Product_Available__c == true && (oppy.Recordtypeid == oPP_FASTTRACK_RECORD_TYPE_ID || ((Opportunity)trgCtx.oldMap.get(oppy.Id)).Recordtypeid != oPP_REGULAR_RECORD_TYPE_ID) && oppy.Stagename == 'Opportunity Pursuit'){   //Check here
                            lstupdOpportunity.add(new Opportunity(id = oppy.id, Product_Group__c = productid, Recordtypeid = oPP_FASTTRACK_RECORD_TYPE_ID));

                        }else{
                            lstupdOpportunity.add(new Opportunity(id = oppy.id, Product_Group__c = productid));
                        }*/
                    }

                    //Removed for 4.1 release
                    /*if(oppy.isRegularButtonUpdate__c == true){
                        lstupdOpportunity1.add(new Opportunity(id = oppy.id, isRegularButtonUpdate__c = false, Recordtypeid = oPP_REGULAR_RECORD_TYPE_ID));
                    }*/
                    
                //}

            }           
            ClsTriggerFactory.isSkipOpportunityRecursiveTrigger = false;
            if(lstupdOpportunity.size()>0){
                Database.update(lstupdOpportunity, false);
            }
            /*if(lstupdOpportunity1.size()>0){
                Database.update(lstupdOpportunity1, false);

            }*/
        }           
    }
    /**
     *  This trigger is used to Set Contact to Primary with a Role.
     @author  Jinbo Shan
     @created 2015-03-26
     @version 1.0
     @since   30.0 (Force.com ApiVersion)
     *
     @changelog
     * 2015-03-26 Jinbo Shan <jinbo.shan@itbconsult.com>
     * - Created
    */
    @TestVisible 
    private void setContactAsPrimaryContactRole(ClsWrappers.TriggerContext trgCtx) {
    
        if (trgCtx.isBefore){return;}
        
        if (trgCtx.isInsert) {
            list<OpportunityContactRole> list_ocrs = new list<OpportunityContactRole>();
            for (sobject so : trgCtx.newList) {
                Opportunity oppy = (Opportunity)so;
                if (oppy.Primary_Contact__c != null) {
                    OpportunityContactRole ocr = new OpportunityContactRole();
                    ocr.IsPrimary = true;
                    ocr.OpportunityId = oppy.Id;
                    ocr.ContactId = oppy.Primary_Contact__c;
                    ocr.Role = Label.System_CL00083;
                    list_ocrs.add(ocr);
                }
            }
            if(list_ocrs.size() > 0) {
                Database.Insert(list_ocrs);
            }
        } 
    }      
   
    /*  Description of the purpose of the method. 
    *  @name setLSORefDatafromAccount
    *  @Description - Req -2168. Auto populates the Local Reference Data from associated Accounts while creating or updating an opportunity.
    *  @return - void
    *  @created by - Shankar Anand
    */
    private void setLSORefDatafromAccount(ClsWrappers.TriggerContext trgCtx) {   
        Set<Id> accountCustIds = new Set<Id>();
        Set<Id> accountEndUserIds = new Set<Id>();
        Set<Id> opptyOwnerIds = new Set<Id>(); 
        Set<id> opptyIds = new Set<id>();
        Set<Id> primPartnerAccIds = new Set<Id>(); 
        String userLSO;
        String userLSO1;
        String accLSO;
        String primPartnerLSO;      
        //Map<Id,Opportunity> oldOpptyMap = new map<Id,Opportunity>();
        Map<Id,Account> accountCustMap = new map<Id,Account>();
        Map<Id,Account> accountEndUserMap = new map<Id,Account>();
        Map<Id,User> userMap = new map<Id,User>();
        //Map<Id,OpportunityPartner> primPartners= new map<Id,OpportunityPartner>();        
        Map<Id,Account> primPartnerAccnts = new map<Id,Account>();
        Set<ID> allAccountids = new Set<ID>();
        List<Account> lstAccounts = new List<Account>();
        Set<Id> opptyPrimPartLRDList = new Set<Id>();
        Boolean autoPopulate = true;
        
        if(trgCtx!=null && trgCtx.isBefore && 
           (trgCtx.isInsert || trgCtx.isUpdate) &&
           ClsTriggerFactory.isSkipRecursiveLSOTrigger)
           //ClsTriggerFactory.isSkipRecursiveLSOTrigger == true)//(trgCtx.isUpdate && ClsTriggerFactory.isSkipRecursiveLSOTrigger == true)))
        { 
            for(sobject so : trgCtx.newList) {
                Opportunity oppy = (Opportunity)so;
                if(trgCtx.isInsert || (trgCtx.isUpdate && ((Opportunity)trgCtx.oldMap.get(oppy.id)).accountId != oppy.accountId || 
                   ((Opportunity)trgCtx.oldMap.get(oppy.id)).ownerId != oppy.ownerId))
                {
                accountCustIds.add(oppy.accountId);
                }
                if(trgCtx.isInsert || (trgCtx.isUpdate && ((Opportunity)trgCtx.oldMap.get(oppy.id)).Account_End_User__c != oppy.Account_End_User__c || 
                   ((Opportunity)trgCtx.oldMap.get(oppy.id)).ownerId != oppy.ownerId))
                {
                accountEndUserIds.add(oppy.Account_End_User__c);
                }
                if(trgCtx.isInsert || (trgCtx.isUpdate && ((Opportunity)trgCtx.oldMap.get(oppy.id)).accountId != oppy.accountId || 
                   ((Opportunity)trgCtx.oldMap.get(oppy.id)).Account_End_User__c != oppy.Account_End_User__c || 
                   ((Opportunity)trgCtx.oldMap.get(oppy.id)).ownerId != oppy.ownerId))
                {
                opptyOwnerIds.add(oppy.ownerId);
                }
                opptyIds.add(oppy.id);
                if(trgCtx.isUpdate && ((Opportunity)trgCtx.oldMap.get(oppy.id)).Primary_Partner_LSO_Reference_Data__c != oppy.Primary_Partner_LSO_Reference_Data__c)
                {
                opptyPrimPartLRDList.add(oppy.Primary_Partner_LSO_Reference_Data__c);
                }
            }
            
            allAccountids.addall(accountCustIds);
            allAccountids.addall(accountEndUserIds);
            if(allAccountids.size()>0){
                lstAccounts = [Select Id, Name, (Select Id, name,LBU__c,LSO__c,LSO_ERP_Mapping_Value__c from LSO_Reference_Datas__r LIMIT 50000) 
                               FROM Account WHERE id in:allAccountids LIMIT 50000];
            }
            for(Account acc:lstAccounts){
                if(accountCustIds.contains(acc.id)){
                    accountCustMap.put(acc.id, acc);
                }
                if(accountEndUserIds.contains(acc.id)){
                    accountEndUserMap.put(acc.id,acc);
                }
            }
            /*if(accountCustIds.size()>0){
                accountCustMap = new map<Id,Account>([Select Id, Name, (Select Id, name,LBU__c,LSO__c,LSO_ERP_Mapping_Value__c from LSO_Reference_Datas__r) from Account where id in:accountCustIds LIMIT 50000]);
            }
            if(accountEndUserIds.size()>0){
                accountEndUserMap = new map<Id,Account>([Select Id, Name, (Select Id, name,LBU__c,LSO__c,LSO_ERP_Mapping_Value__c from LSO_Reference_Datas__r) from Account where id in:accountEndUserIds LIMIT 50000]);
            }*/
            
            if(opptyOwnerIds.size()>0){
            userMap = new map<Id,User>([Select Id, Name,Default_BU__c,Default_LSO__c,Default_Country_ISO_Code__c 
                                        FROM User WHERE Id in:opptyOwnerIds LIMIT 50000]);                     
            }               
        }
                   
        if(trgCtx!=null && trgCtx.isBefore && trgCtx.isInsert){ 
            for(sobject so : trgCtx.newList) {
                Opportunity oppy = (Opportunity)so;  
                Account acu = accountCustMap.get(oppy.accountId);
                Account eua = new Account();
                if(accountEndUserMap.containskey(oppy.Account_End_User__c)){
                    eua = accountEndUserMap.get(oppy.Account_End_User__c);
                }
                User usr = userMap.get(oppy.ownerid);
                if(usr!= null && usr.Default_BU__c != null){
                    userLSO = usr.Default_LSO__c + usr.Default_BU__c;
                }

                else if(usr!=null){
                    userLSO1 = usr.Default_LSO__c;
                }
                                           
                if(acu!=null){
                    for(ERP_Reference_Data__c lrd:acu.LSO_Reference_Datas__r){
                        accLSO = String.valueof(lrd.LSO__c)+String.valueof(lrd.LBU__c);
                        if(usr.Default_BU__c!=null && lrd.LBU__c!= null && userLSO!=null && userLSO.equalsIgnoreCase(accLSO)){
                            oppy.Account_Customer_LSO_Reference_Data__c = lrd.id;
                        }
                        else if(usr.Default_BU__c==null &&  lrd.LBU__c == null && 
                                userLSO1!=null && userLSO1.equalsIgnoreCase(String.valueof(lrd.LSO__c))){
                            oppy.Account_Customer_LSO_Reference_Data__c = lrd.id;
                        }
                       
                    }
                }
                
                if(eua!=null){
                    for(ERP_Reference_Data__c lrd:eua.LSO_Reference_Datas__r){
                        accLSO = String.valueof(lrd.LSO__c)+String.valueof(lrd.LBU__c);
                        if(usr.Default_BU__c!=null &&  lrd.LBU__c!= null && userLSO!=null && userLSO.equalsIgnoreCase(accLSO)){
                            oppy.End_User_LSO_Reference_Data__c = lrd.id;
                        }
                        else if(usr.Default_BU__c ==null &&  lrd.LBU__c == null && userLSO1!=null && userLSO1.equalsIgnoreCase(String.valueof(lrd.LSO__c))){    
                            oppy.End_User_LSO_Reference_Data__c = lrd.id;
                        }
                          
                    }
                }       
            }  
        } 

        //if(trgCtx!=null && trgCtx.isBefore && trgCtx.isUpdate && ClsTriggerFactory.isSkipRecursiveLSOTrigger == true)// && ClsTriggerFactory.isSkipRecursiveLSOTrigger == true)
        if(trgCtx!=null && trgCtx.isBefore && trgCtx.isUpdate && ClsTriggerFactory.isSkipRecursiveLSOTrigger )
        { 
            List<OpportunityPartner> primPartners = new List<OpportunityPartner>();
            Map<Id,ERP_Reference_Data__c> lrdMap = new Map<Id,ERP_Reference_Data__c>();
            Map<Id,OpportunityPartner> partnerMap = new Map<Id,OpportunityPartner>();     
            primPartners = [Select Id,role,isPrimary,OpportunityId,accountToId 
                            FROM OpportunityPartner WHERE isPrimary = true and OpportunityId in :opptyIds LIMIT 50000];
            
           
            for(OpportunityPartner prtnr : primPartners){
                        partnerMap.put(prtnr.OpportunityId,prtnr);
                }
                   
             for(sobject so : trgCtx.newList){
                Opportunity oppy1 = (Opportunity)so;
                OpportunityPartner opt = partnerMap.get(oppy1.id);
                if(opt!=null && oppy1.Primary_Partner_LSO_Reference_Data__r.account__c!=opt.accountToId){
                    primPartnerAccIds.add(opt.accountToId);
                }
                }    
                                 
            /*for(OpportunityPartner pp:primPartners){
                primPartnerAccIds.add(pp.accountToId);  
            }*/
            
            if(primPartnerAccIds.size()>0){
                primPartnerAccnts = new map<Id,Account>([Select Id, Name, (Select Id, name,LBU__c,LSO__c,LSO_ERP_Mapping_Value__c 
                                                         FROM LSO_Reference_Datas__r LIMIT 50000) FROM Account WHERE id in:primPartnerAccIds LIMIT 50000]);              
            }
            /*for(sobject so : trgCtx.oldList){
                Opportunity oppy = (Opportunity)so;
                oldOpptyMap.put(oppy.id,oppy);       
            }*/

        if(opptyPrimPartLRDList.size()>0){
        lrdMap = new Map<Id,ERP_Reference_Data__c>([Select Id, Name, Account__c 
                     from ERP_Reference_Data__c 
                     where Id in: opptyPrimPartLRDList LIMIT 50000]); 
        }                                                                          

            for(sobject so : trgCtx.newList) 
            {
                Opportunity oppy = (Opportunity)so;
                Account eua = new Account();
                if(accountEndUserMap.containskey(oppy.Account_End_User__c)){
                    eua = accountEndUserMap.get(oppy.Account_End_User__c);
                }    
                
                /*for(OpportunityPartner prtnr : primPartners){
                    if(prtnr.opportunityId == oppy.id){
                        partnerMap.put(oppy.Id,prtnr);
                    }
                }*/

                User usr = userMap.get(oppy.ownerid);
                if(usr!=null && usr.Default_BU__c!=null){
                    userLSO = usr.Default_LSO__c+usr.Default_BU__c;
                }

                else if(usr!=null){
                    userLSO1 = usr.Default_LSO__c;
                }
                
                
                
                if(((Opportunity)trgCtx.oldMap.get(oppy.id)).accountId != oppy.accountId || 
                   ((Opportunity)trgCtx.oldMap.get(oppy.id)).ownerId != oppy.ownerId){
                Account act = accountCustMap.get(oppy.accountId);    
                if(act!=null){  
                    List<ERP_Reference_Data__c> acLsoRefList = new List<ERP_Reference_Data__c>();
                    acLsoRefList.addall(act.LSO_Reference_Datas__r);                
                    if(acLsoRefList.size()>0){
                        for(ERP_Reference_Data__c lrd:act.LSO_Reference_Datas__r){
                            accLSO = String.valueof(lrd.LSO__c)+String.valueof(lrd.LBU__c);
                            if(usr!=null && usr.Default_BU__c!=null && lrd.LBU__c!= null && userLSO!=null && userLSO.equalsIgnoreCase(accLSO)){
                                oppy.Account_Customer_LSO_Reference_Data__c = lrd.id;

                                break;
                            }
                            else if(usr!=null && usr.Default_BU__c == null && lrd.LBU__c == null && 
                                    userLSO1!=null && userLSO1.equalsIgnoreCase(String.valueof(lrd.LSO__c))){
                                oppy.Account_Customer_LSO_Reference_Data__c = lrd.id;
                                break;
                            }
                            else{
                                oppy.Account_Customer_LSO_Reference_Data__c = null;
                            }
                        }
                    }
                    else{
                        oppy.Account_Customer_LSO_Reference_Data__c = null;
                    }               
                }

                }
                 
                 
                if(((Opportunity)trgCtx.oldMap.get(oppy.id)).Account_End_User__c != oppy.Account_End_User__c || 
                   ((Opportunity)trgCtx.oldMap.get(oppy.id)).ownerId != oppy.ownerId){    
                if(eua!=null){
                    List<ERP_Reference_Data__c> aeuLsoRefList = new List<ERP_Reference_Data__c>();
                    aeuLsoRefList.addall(eua.LSO_Reference_Datas__r);           
                    if(aeuLsoRefList.size()>0){
                        for(ERP_Reference_Data__c lrd:eua.LSO_Reference_Datas__r){
                            accLSO = String.valueof(lrd.LSO__c)+String.valueof(lrd.LBU__c);
                            if(usr!=null && usr.Default_BU__c!=null &&  lrd.LBU__c!= null && 
                               userLSO!=null && userLSO.equalsIgnoreCase(accLSO)){
                                oppy.End_User_LSO_Reference_Data__c = lrd.id;
                                break;
                            }
                            else if(usr!=null && usr.Default_BU__c==null &&  lrd.LBU__c == null 
                                    && userLSO1!=null && userLSO1.equalsIgnoreCase(String.valueof(lrd.LSO__c))){
                                oppy.End_User_LSO_Reference_Data__c = lrd.id;
                                break;
                            }
                            else{
                            oppy.End_User_LSO_Reference_Data__c  = null;
                            }
                        }
                    }
                    else{
                        oppy.End_User_LSO_Reference_Data__c  = null;
                    }
                }           

                }

                    
                    //R5-Req2500
                    OpportunityPartner opt = partnerMap.get(oppy.id);
                       if(opt == null && oppy.Primary_Partner_LSO_Reference_Data__c != null){              
                         oppy.addError(System.Label.Oppty_Primary_Partner_LSO_Error_Message);
                       } 
                       else if(opt!= null && opt.OpportunityId == oppy.Id 
                               && lrdMap.get(oppy.Primary_Partner_LSO_Reference_Data__c)!=null 
                               && lrdMap.get(oppy.Primary_Partner_LSO_Reference_Data__c).Account__c != opt.accountToId){
                                  oppy.addError(System.Label.Oppty_Primary_Partner_LSO_Error_Message);    
                       }
                       else if(opt!= null && opt.OpportunityId == oppy.Id && 
                               lrdMap.get(oppy.Primary_Partner_LSO_Reference_Data__c)!=null && 
                               lrdMap.get(oppy.Primary_Partner_LSO_Reference_Data__c).Account__c == opt.accountToId){
                        autoPopulate = false; 
                       } 
                     // END
              
        
               
                //if(partnerMap.containskey(oppy.id) && autoPopulate == true){
                if(partnerMap.containskey(oppy.id) && autoPopulate){
                    OpportunityPartner op = partnerMap.get(oppy.id);
                    List<ERP_Reference_Data__c> partnerLsoRefList = new List<ERP_Reference_Data__c>();
                    if(primPartnerAccnts!=null && op!=null && primPartnerAccnts.get(op.accountToId)!=null){
                       partnerLsoRefList.addall(primPartnerAccnts.get(op.accountToId).LSO_Reference_Datas__r);
                    }   
                    if(partnerLsoRefList.size()>0){  
                        for(ERP_Reference_Data__c lrd:primPartnerAccnts.get(op.accountToId).LSO_Reference_Datas__r){
                            primPartnerLSO = String.valueof(lrd.LSO__c)+String.valueof(lrd.LBU__c);
                            if(usr!=null && usr.Default_BU__c!=null &&  lrd.LBU__c!= null 
                               && userLSO!=null && userLSO.equalsIgnorecase(primPartnerLSO) 
                               &&  op.isPrimary){
                               //&&  op.isPrimary == true){
                                oppy.Primary_Partner_LSO_Reference_Data__c  = lrd.id;
                                break;
                            }
                            else if(usr!=null && usr.Default_BU__c ==null &&  lrd.LBU__c == null 
                                    && userLSO1!=null && userLSO1.equalsIgnorecase(String.valueof(lrd.LSO__c))  
                                     &&  op.isPrimary){
                                   // &&  op.isPrimary == true){
                                oppy.Primary_Partner_LSO_Reference_Data__c = lrd.id;
                                break;
                            }
                            else{
                                oppy.Primary_Partner_LSO_Reference_Data__c = null;
                            }
                        }
                    }
                    else{
                    oppy.Primary_Partner_LSO_Reference_Data__c = null;
                    }  
                }
            } 
            ClsTriggerFactory.isSkipRecursiveLSOTrigger = false;  
        }  
    }                
      

    /**   
    * Opportuniyt Handler : Set LPU and LPG Method
    * Release R4
    *  
    * @author  MohanRaj Kasinathan (Accenture)
    * @created  2015-09-08* @version 1.0
    *
    */    
    @TestVisible 
    private void setLBUandLPG(ClsWrappers.TriggerContext trgCtx) {
               
        if ((trgCtx.isBefore && trgCtx.isInsert) || (trgCtx.isBefore && trgCtx.isUpdate) ) {
            Set<String> setLBUCode = new Set<String>();
            Set<String> setLPGcode = new Set<String>();
            Set<Id> locIds = new Set<Id>();
            Map<Id,ABB_Location__c > abbLocMap = new Map<Id,ABB_Location__c >();
            Map<String, Id> lBUMap = new Map<String, Id>();
            Map<String, Id> lPGMap = new Map<String, Id>();
            for (sobject so : trgCtx.newList) {
                Opportunity oppy = (Opportunity)so;
                if ((trgCtx.isUpdate && ((Opportunity)trgCtx.oldMap.get(oppy.id)).ABB_Location__c!=oppy.ABB_Location__c 
                     && oppy.ABB_Location__c != null) 
                     || (trgCtx.isInsert && oppy.ABB_Location__c != null)) {                                  
                    locIds.add(oppy.ABB_Location__c);
                  }
            }
            if(locIds.size()>0){
            abbLocMap = new Map<Id,ABB_Location__c >([Select Id,Company__c,BU__c,Product_Group__c 
                                                      FROM ABB_Location__c WHERE Id in : locIds limit 50000]);
            }
            for(ABB_Location__c loc : abbLocMap .values()) {
            
            
            String strBU = '';                    
            if(loc.BU__c != null)
            {                   
            String[] strBUarr = loc.BU__c.split(Label.System_CL00081); 
            if(strBUarr.size() >0 ) {strBU = strBUarr[0].trim(); }                    
            }
            
            String strCompany = '';
            if(loc.Company__c != null)
            { strCompany = loc.Company__c;}                    
                                                   
            String strLBUCode = strCompany+Label.System_CL00081+strBU;  
             
            String strPG = '';
            if(loc.Product_Group__c != null)
            {
            String[] strPGarr = loc.Product_Group__c.split(Label.System_CL00081);
            if(strPGarr.size() >0 ) {strPG = strPGarr[0].trim(); }                     
            } 
                             
            String strLPGCode = strPG;  

            setLBUCode.add(strLBUCode);
            setLPGcode.add(strLPGCode);
            
            }
            
            if(setLBUCode.size()>0){                
            for (LBU_Code__c r : [Select Id, Name from LBU_Code__c where Name in : setLBUCode limit 50000]) {
            lBUMap.put(r.Name, r.Id);
            }
            }
            
            if(setLPGCode.size()>0){              
            for (Product_Group__c r : [Select Id, Name from Product_Group__c where Name in : setLPGCode limit 50000]) {
            lPGMap.put(r.Name, r.Id);
            }
            }

            for (sobject so : trgCtx.newList) {
                Opportunity oppy = (Opportunity)so;
                if (oppy.ABB_Location__c != null) {                                  
                    
                    String strBU = '';                    
                    if(abbLocMap.get(oppy.ABB_Location__c)!=null && abbLocMap.get(oppy.ABB_Location__c).BU__c != null)
                    {                   
                    String[] strBUarr = abbLocMap.get(oppy.ABB_Location__c).BU__c.split(Label.System_CL00081); 
                    if(strBUarr.size() >0 ) {strBU = strBUarr[0].trim(); }                    
                    }
                    
                    String strCompany = '';
                    if(abbLocMap.get(oppy.ABB_Location__c)!=null && abbLocMap.get(oppy.ABB_Location__c).Company__c != null)
                    { strCompany = abbLocMap.get(oppy.ABB_Location__c).Company__c;}                    
                                                           
                    String strLBUCode = strCompany+Label.System_CL00081+strBU;  
                     
                    String strPG = '';
                    if(abbLocMap.get(oppy.ABB_Location__c)!=null && abbLocMap.get(oppy.ABB_Location__c).Product_Group__c != null)
                    {
                    String[] strPGarr = abbLocMap.get(oppy.ABB_Location__c).Product_Group__c.split(Label.System_CL00081);
                    if(strPGarr.size() >0 ) {strPG = strPGarr[0].trim(); }                     
                    } 
                                     
                    String strLPGCode = strPG;  
                    
                    Id strLBUId = lBUMap.get(strLBUCode);   
                    Id strLPGId = lPGMap.get(strLPGCode); 
                    if(strLBUId!=null){                                                       
                    oppy.Local_Business_Unit__c = strLBUId;
                    }
                    if(strLPGId!=null){
                    oppy.Local_Product_Group__c = strLPGId;
                    }                    
                  }
            }



         } 
    }
    
    /*  Description of the purpose of the method. 
    *  @name opportunityCreation
    *  @Description - Provide the Status of Opportunity Capture Team Indicator while create a new Opportunity.
    *  @return Nothing - 
    */
    @TestVisible 
    private void opportunityCreation(ClsWrappers.TriggerContext trgCtx) {
        Set<Id> setEUPId = new Set<Id>();
        Map<Id,List<Opportunity>> mapEUPIdAndOpportunity = new Map<Id,List<Opportunity>>();
        List<End_User_Project__c> lstEndUsr = new List<End_User_Project__c>();
       
        if((Trigger.isInsert && Trigger.isAfter) || (Trigger.isUpdate && Trigger.isAfter))
        {
                        
             for(sobject objOpp : trgCtx.newList)
             {
                  Opportunity opp = (Opportunity)objOpp;
                  if(opp.End_User_Project__c != NULL)
                  {setEUPId.add(opp.End_User_Project__c);}
             }
             
                        
            for(Opportunity op : [SELECT Id,Capture_Team_Indicator_Status__c,End_User_Project__c 
                                  FROM Opportunity  where End_User_Project__c in: setEUPId LIMIT 10000] )
            {
                List<Opportunity> lstop = new List<Opportunity>();
                lstop.add(op);
                
                if (mapEUPIdAndOpportunity.containsKey(op.End_User_Project__c))
                {                    
                    mapEUPIdAndOpportunity.get(op.End_User_Project__c).add(op);
                }
                else
                {
                    mapEUPIdAndOpportunity.put(op.End_User_Project__c, lstop);
                }
            
            }
            
            
            for(String endusrid : setEUPId)
            {   
                String endUsrStatus = ''; 
                Boolean isFullRequired = False;
                Boolean isFullAvailable = False;
                Boolean isLiteRequired = False;
                Boolean isLiteAvailable = False;
                Boolean isNotRequired = False;       
                List<Opportunity> lstopty = new List<Opportunity>();
                if(mapEUPIdAndOpportunity.containsKey(endusrid)){
                    lstopty = mapEUPIdAndOpportunity.get(endusrid);
                }
                if(lstopty.size() >0){
                   for(Opportunity opp : lstopty)
                   {
                      if(null!=opp.Capture_Team_Indicator_Status__c&&opp.Capture_Team_Indicator_Status__c.equals(System.label.No_CT_Required))
                      { isNotRequired = True;}
                      if(null!=opp.Capture_Team_Indicator_Status__c&&opp.Capture_Team_Indicator_Status__c.equals(System.label.CT_Full_Available))
                      { isFullAvailable = True;}
                      if(null!=opp.Capture_Team_Indicator_Status__c&&opp.Capture_Team_Indicator_Status__c.equals(System.label.CT_Full_Required))
                      { isFullRequired = True;}
                      if(null!=opp.Capture_Team_Indicator_Status__c&&opp.Capture_Team_Indicator_Status__c.equals(System.label.CT_Lite_Available))
                      { isLiteAvailable = True;}
                      if(null!=opp.Capture_Team_Indicator_Status__c&&opp.Capture_Team_Indicator_Status__c.equals(System.label.CT_Lite_Required))
                      { isLiteRequired = True;}
                  
                   }
                }
                
                
                if(isFullAvailable)
                {
                    endUsrStatus = System.label.CT_Full_Available;
                }
                else if (isFullRequired)
                {
                    endUsrStatus = System.label.CT_Full_Required;
                }
                else if (isLiteAvailable)
                {
                    endUsrStatus = System.label.CT_Lite_Available;
                }
                else if (isLiteRequired)
                {
                    endUsrStatus = System.label.CT_Lite_Required;
                }
                else if(isNotRequired)
                {
                    endUsrStatus = System.label.No_CT_Required;
                }
                else
                {
                    endUsrStatus = System.label.No_CT_Required;
                }
                
                End_User_Project__c edUsrRec = new End_User_Project__c();
                edUsrRec.Id = endusrid;
                edUsrRec.Capture_Team_Status__c= endUsrStatus;                                
                lstEndUsr.add(edUsrRec);
            }
            
            if(lstEndUsr.size() > 0)
            {
                Database.update(lstEndUsr);
            }
        }
    } 
 /**   
    * This method prevents the user from closing an opportunity which has open quotes
    * Release R5
    *  
    * @author  Shankar Anand (Accenture)
    * @created  2015-16-12* @version 1.0
    *
    */    
    @TestVisible 
    private void preventOpptyClosure(ClsWrappers.TriggerContext trgCtx) 
    {
               
        if (trgCtx.isBefore && trgCtx.isUpdate) 
        {
            Set<Id> closedOpptyIds = new Set<Id>();
            Map<Id,Apttus_Proposal__Proposal__c> quoteMap = new Map<Id,Apttus_Proposal__Proposal__c>();
            for (sobject so : trgCtx.newList) 
            {
                Opportunity oppy = (Opportunity)so;
                if (oppy.StageName.equals(System.Label.Closed_Lost) || oppy.StageName.equals(System.Label.Opportunity_Closed_Won))
                {                                  
                    closedOpptyIds.add(oppy.Id);
                }
            }
            
            Id cqpId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(System.label.System_CL00106).getRecordTypeId();
            Id lpSpain = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(System.label.System_CL00107).getRecordTypeId();
            List<Id> recordTypes = new List<Id>();
            recordTypes.add(cqpId);
            recordTypes.add(lpSpain);
            if(closedOpptyIds.size()>0){
            quoteMap = new Map<Id,Apttus_Proposal__Proposal__c>([Select Id, Name, Apttus_Proposal__Opportunity__c, Quotation_status__c,APTS_Quotation_Category__c 
                                                                 FROM Apttus_Proposal__Proposal__c 
                                                                 WHERE Apttus_Proposal__Opportunity__c in : closedOpptyIds and recordTypeid in :recordTypes limit 50000]);
            }
         

            for (sobject so : trgCtx.newList) 
            {
                Opportunity oppy = (Opportunity)so;
                if(((Opportunity)trgCtx.oldMap.get(oppy.Id)).StageName!=oppy.StageName && closedOpptyIds.contains(oppy.Id)){
                for(Apttus_Proposal__Proposal__c quot: quoteMap.values()){
                    if (quot.Apttus_Proposal__Opportunity__c!=null && quot.Apttus_Proposal__Opportunity__c.equals(oppy.Id) 
                        && (
                        (quot.APTS_Quotation_Category__c==System.label.Open || 
                        (quot.Quotation_status__c==System.label.RFQ 
                         || quot.Quotation_status__c==System.label.Pre_handled 
                          || quot.Quotation_status__c==System.label.Quotation_created 
                           || quot.Quotation_status__c==System.label.Document_generated 
                            || quot.Quotation_status__c==System.label.In_approval_workflow 
                             || quot.Quotation_status__c==System.label.Approved
                              || quot.Quotation_status__c==System.label.Quote_approved_and_issued 
                               || quot.Quotation_status__c==System.label.PriceBook_refreshing
                               ||  quot.Quotation_status__c==System.label.Revisioned) 
                               )
                               ))
                        {                                  
                            oppy.addError(System.Label.Oppty_Error_Message);
                            System.debug('---'+quot);
                                   
                        }
                       
                }
                }
            }

         } 
    }
    /**   
    * This method updates the main opportunity on the alternative opportunities
    * Release R5
    *  
    * @author  Shankar Anand (Accenture)
    * @created  2015-16-12* @version 1.0
    *
    */    
     @TestVisible 
    private void updateMainOpportunity(ClsWrappers.TriggerContext trgCtx) {
        ClsTriggerAlternativeOpptyHandler.updateMainOpportunity(trgCtx);
       
    }
    
    
    
    /**   
    * This method prevents the user from populating the Account Customer LSO Reference Data field 
    * and the End User LSO Reference Data field from any account except from the Account Customer
    * and the Account End User
    * Release R5
    *  
    * @author  Shankar Anand (Accenture)
    * @created  2016-12-01* @version 1.0
    *
    */    
    @TestVisible 
    private void checkAccountCustandAccountEULSOPopulation(ClsWrappers.TriggerContext trgCtx) 
    {
    if (trgCtx.isBefore && trgCtx.isUpdate){

        Map<Id,ERP_Reference_Data__c> accCustlrdMap = new Map<Id,ERP_Reference_Data__c>();
        Map<Id,ERP_Reference_Data__c> accEUlrdMap = new Map<Id,ERP_Reference_Data__c>();
        Set<Id> opptyIds = new Set<Id>();
        Set<Id> opptyAccCustLRDList = new Set<Id>();
        Set<Id> opptyAccEULRDList = new Set<Id>();
        Set<ID> allLRDids = new Set<ID>();
        List<ERP_Reference_Data__c> lstLRDs = new List<ERP_Reference_Data__c>();
        String error ='';
        
        for(sobject so : trgCtx.newList) {
                Opportunity oppty = (Opportunity)so;
                opptyIds.add(oppty.id);
                opptyAccCustLRDList.add(oppty.Account_Customer_LSO_Reference_Data__c);
                opptyAccEULRDList.add(oppty.End_User_LSO_Reference_Data__c);      
            }
 
        allLRDids.addAll(opptyAccCustLRDList);
        allLRDids.addAll(opptyAccEULRDList); 
         
        
        if(allLRDids.size()>0){
           lstLRDs = [Select Id, Name, Account__c from ERP_Reference_Data__c where Id in: allLRDids LIMIT 50000];
          }
            
        for(ERP_Reference_Data__c lrd: [Select Id, Name, Account__c from ERP_Reference_Data__c where Id in: allLRDids LIMIT 50000]){
           if(opptyAccCustLRDList.contains(lrd.id)){
              accCustlrdMap.put(lrd.id, lrd);
             }
           if(opptyAccEULRDList.contains(lrd.id)){
              accEUlrdMap.put(lrd.id, lrd);
             }
           }

        for(sobject so : trgCtx.newList){
            Opportunity oppty = (Opportunity)so;
           
            if(((Opportunity)trgCtx.oldMap.get(oppty.id)).Account_Customer_LSO_Reference_Data__c!= oppty.Account_Customer_LSO_Reference_Data__c 
                && accCustlrdMap.get(oppty.Account_Customer_LSO_Reference_Data__c)!=null 
                && accCustlrdMap.get(oppty.Account_Customer_LSO_Reference_Data__c).Account__c != oppty.accountId){
               oppty.addError(System.Label.Opportunity_Account_Customer_LSO_error_message);
              }    
            else if(((Opportunity)trgCtx.oldMap.get(oppty.id)).End_User_LSO_Reference_Data__c!= oppty.End_User_LSO_Reference_Data__c 
                     && accEUlrdMap.get(oppty.End_User_LSO_Reference_Data__c)!=null 
                     && accEUlrdMap.get(oppty.End_User_LSO_Reference_Data__c).Account__c != oppty.Account_End_User__c){
               oppty.addError(System.Label.Opportunity_Account_End_User_LSO_error_message);
              }
              
            /*if(accCustlrdMap.get(oppty.Account_Customer_LSO_Reference_Data__c)!=null && accCustlrdMap.get(oppty.Account_Customer_LSO_Reference_Data__c).Account__c != oppty.accountId && accEUlrdMap.get(oppty.End_User_LSO_Reference_Data__c)!=null && accEUlrdMap.get(oppty.End_User_LSO_Reference_Data__c).Account__c != oppty.Account_End_User__c){
               error = System.Label.Opportunity_Account_Customer_LSO_error_message + '<br/>' + System.Label.Opportunity_Account_End_User_LSO_error_message;
               oppty.addError(error,false);
              }  
             */         
          }  
      }
      } 
      
       
      /**   
    * This method updates the Account End User with Account Customer 
    * if Channel Class is DEU and Account End User is empty.
    * Release R5
    *  
    * @author  Shankar Anand (Accenture)
    * @created  2015-19-01* @version 1.0
    *
    */    
    @TestVisible 
    private void updateAccountEndUser(ClsWrappers.TriggerContext trgCtx) 
    {
        if (trgCtx.isBefore && trgCtx.isInsert) 
        {
            for (sobject so : trgCtx.newList) 
            {
                Opportunity oppy = (Opportunity)so;
                if (null!=oppy.Channel_Class_Level1__c && oppy.Channel_Class_Level1__c.equals(System.label.DEU) && oppy.Account_End_User__c == null)
                {                                  
                    oppy.Account_End_User__c = oppy.AccountId;
                }

            }
        }      
    }
    
    
     
    /**   
    * This method updates the Estimated WInner's Price on Opportunity when the
    * Opportunity Value is updated and the Opportunity Winner is populated with a competitor
    * Release R5
    *  
    * @author  Shankar Anand (Accenture)
    * @created  2016-17-02* @version 1.0
    *
    */    
    @TestVisible 
    private void updateWinnerPrice(ClsWrappers.TriggerContext trgCtx) 
    {
    Set<Id> opptyIds = new Set<Id>();
    Map<Id,Opportunity> updOpptyIds = new Map<Id,Opportunity>();
    Map<Id,Competitor__c> compMap = new Map<Id,Competitor__c>();
    List<Opportunity> opptyList = new List<Opportunity>();
        if (trgCtx.isAfter && trgCtx.isUpdate) 
        {
            for (sobject so : trgCtx.newList) 
            {
                Opportunity oppy = (Opportunity)so;
                if ((((Opportunity)trgCtx.oldMap.get(oppy.id)).Opportunity_Value__c!=oppy.Opportunity_Value__c && oppy.Opportunity_Winner__c!=null))
                {                                 
                    opptyIds.add(oppy.Id);
                }

            }
        if(opptyIds.size()>0){ 
            compMap = new Map<Id,Competitor__c>([Select Id, Name, Competitor__c, Opportunity__c, Estimated_Sale_Price__c, Winning_Company__c 
                                                 FROM Competitor__c 
                                                 WHERE Opportunity__c in :opptyIds and Winning_Company__c = true LIMIT 50000]);   
        }
        
            for (sobject so : trgCtx.newList) 
            {
            Opportunity oppy = (Opportunity)so;
            Opportunity oppt = new Opportunity();
                if ((((Opportunity)trgCtx.oldMap.get(oppy.id)).Opportunity_Value__c!=oppy.Opportunity_Value__c && oppy.Opportunity_Winner__c!=null))
                {                 
                 for(Competitor__c cmp : compMap.values()){
                    if(cmp.Opportunity__c == oppy.Id && cmp.Competitor__c == oppy.Opportunity_Winner__c){                    
                        oppt = new Opportunity(id=oppy.Id,Winners_Price__c=cmp.Estimated_Sale_Price__c);
                    }
                 }
                 if(oppt.id == null){ 
                     oppt = new Opportunity(id=oppy.Id,Winners_Price__c=null);
                 }
                 updOpptyIds.put(oppt.id,oppt);
                }
            }
            if(updOpptyIds.values().size()>0 && !clsTriggerFactory.competitorUpdate){
                opptyList.addAll(updOpptyIds.values());
                Database.Update(opptyList);
            }
        }      
    }
    
    /**   
    * This method updates the Estimated WInner's Price on Opportunity when the
    * Opportunity Value is updated and the Opportunity Winner is populated with a competitor
    * Release R5
    *  
    * @author  Shankar Anand (Accenture)
    * @created  2016-17-02* @version 1.0
    *
    */    
    @TestVisible 
    private void syncWinnerManualUpdate(ClsWrappers.TriggerContext trgCtx) 
    {
    Set<Id> opptyIds = new Set<Id>();
    Map<Id,Opportunity> updOpptyMap = new Map<Id,Opportunity>();
    List<Opportunity> oppList = new List<Opportunity>();
    Map<Id,Competitor__c> updCompIds = new Map<Id,Competitor__c>();
    Map<Id,Competitor__c> compMap = new Map<Id,Competitor__c>();
    List<Competitor__c> comptList = new List<Competitor__c>();
        if (trgCtx.isAfter && trgCtx.isUpdate) 
        {
            for (sobject so : trgCtx.newList) 
            {
                Opportunity oppy = (Opportunity)so;
                if (((Opportunity)trgCtx.oldMap.get(oppy.id)).Opportunity_Winner__c!=oppy.Opportunity_Winner__c)
                {                                 
                    opptyIds.add(oppy.Id);
                }

            }
        
        if(opptyIds.size()>0){ 
            compMap = new Map<Id,Competitor__c>([Select Id, Name, Competitor__c, Opportunity__c, Estimated_Sale_Price__c, Winning_Company__c 
                                                 FROM Competitor__c 
                                                 WHERE Opportunity__c in :opptyIds LIMIT 50000]);   
        }
        
            for (sobject so : trgCtx.newList) 
            {
            Opportunity oppy = (Opportunity)so;
            Opportunity oppty = new Opportunity();
            Competitor__c compt = new Competitor__c();
                if (((Opportunity)trgCtx.oldMap.get(oppy.id)).Opportunity_Winner__c!=oppy.Opportunity_Winner__c)
                {                 
                 for(Competitor__c cmp : compMap.values()){
                    if(cmp.Opportunity__c == oppy.Id  && cmp.Competitor__c != oppy.Opportunity_Winner__c && cmp.Winning_Company__c){                    
                        compt = new Competitor__c(id=cmp.Id,Winning_Company__c = false);   
                    }
                    else if(cmp.Opportunity__c == oppy.Id  && cmp.Competitor__c == oppy.Opportunity_Winner__c && !cmp.Winning_Company__c){
                        oppty = new Opportunity(id=oppy.id,Winners_Price__c=cmp.Estimated_Sale_Price__c);
                        compt = new Competitor__c(id=cmp.Id,Winning_Company__c = true);
                    }
                  
                  if(compt.id != null){ 
                      updCompIds.put(compt.id,compt);
                  }
                 }
                 if(oppty.id != null){
                     updOpptyMap.put(oppty.id,oppty);
                 }
                 else if(null!= updCompIds.values() && updCompIds.values().size()>0 && null!= updOpptyMap.values() && updOpptyMap.values().size()==0  && ((Opportunity)trgCtx.oldMap.get(oppy.id)).Winners_Price__c == oppy.Winners_Price__c){
                     oppty = new Opportunity(id=oppy.id,Winners_Price__c=null);
                     updOpptyMap.put(oppty.id,oppty);
                 }
                }
            }
            
            if(null!=updCompIds.values() && updCompIds.values().size()>0 && !clsTriggerFactory.competitorUpdate){
                comptList.addAll(updCompIds.values());
                Database.Update(comptList);
            }
            
             if(null!=updOpptyMap.values() && updOpptyMap.values().size()>0 && !clsTriggerFactory.competitorUpdate){
                oppList.addAll(updOpptyMap.values());
                Database.Update(oppList);
            }
        }      
    }
        
}