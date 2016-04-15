/**
 * Trigger handler class for Case which does following actions
 * - 1. TBD
 * - 2. insert, undelete, update TargetGroupShare.
 *
 * @author Jinbo Shan
 * @created 2015-03-11
 * @version 1.0
 * @since 30.0
 *   
 * @changelog
 * 2015-03-11 Jinbo Shan <jinbo.shan@itbconsult.com>
 * - Created
 */
public class ClsTriggerCaseHandler  extends ClsTriggerVirtual {
    
    /**
     * @see IntHelper.beforeTrigger
    */
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
        //resetCaseNumber(trgCtx);
        //updateCaseInquiryNumber(trgCtx);
        recordTypeUpdate(trgCtx);
        resolutionDateUpdate(trgCtx);
        validateOwnerCountry(trgCtx);
        validateProfile(trgCtx);        
        //Req 2168 - Local reference data auto population on Case
        setLSOrefDataFromAccountOnUpdate(trgCtx);
        createTaskParentCaseOwner(trgCtx);
    }
    
    /**
     * @see IntHelper.afterTrigger
    */
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
      
        preventParentCloseParentCase(trgCtx);
        preventOpenActivity(trgCtx);
        updateChatterGroup(trgCtx);
        notificationForCaseClosure(trgCtx);
        sendToCCRP(trgCtx);
  

        //Req 2168 - Local reference data auto population on Case
         setLSORefDatafromAccountOnInsert(trgCtx);
        
    }
    /**
     *This trigger is used to send values to CCRP.
     @author  Rajesh K
     @created 2015-Jan-12
     @version 1.0
    */
    @TestVisible
    private void sendToCCRP(ClsWrappers.TriggerContext trgCtx) { 
        if (trgCtx.isAfter && trgCtx.isUpdate) {           
                     
            for(sobject so : trgCtx.newList) {
                Case c = (Case)so;              
                if(String.valueOf(trgCtx.oldMap.get(c.Id).get('Case_Substitute__c')) != c.Case_Substitute__c && c.Case_Substitute__c != 'NA'){
                    SendCaseToCCRPClass.sendtoCCRP(c.id);
                }                              
            }
        }        
    }

    /**
     *This trigger is used to create task for parent case owner.
     @author  Rajesh K
     @created 2015-1-11
     @version 1.0
    */  
    @TestVisible
    private void createTaskParentCaseOwner(ClsWrappers.TriggerContext trgCtx) { 
        if (trgCtx.isBefore && trgCtx.isUpdate) { 
            List<Task> lstTask = new List<Task>();
            for(sobject so : trgCtx.newList) {
            Case c = (Case)so;
               
                if((ClsTriggerFactory.isFirstTime == false) && c.Status != trgCtx.oldMap.get(c.Id).get('Status') && c.Status == 'Closed' && c.ParentID != Null && c.Owner_Type__c == 'User')   
                {         
                    Task newTask= new Task();         
                    newTask.OwnerId = c.Parent_Case_Owner__c;          
                    newTask.Subject = 'Sub-Case '+c.caseNumber+  ' is closed';
                    newTask.Priority = 'Normal';           
                    newTask.Status = 'Open';          
                    newTask.Type = 'Action';
                    newTask.whatid = c.ParentID;          
                    lstTask.add(newTask);
                   
                }
            }
            if(lstTask.size()>0){
                Database.insert(lstTask, false);
                ClsTriggerFactory.isFirstTime =true ;
            }
        }        
    }
    /**
     *This trigger is used to prevent case status edit.
     @author  Rajesh K
     @created 2015-12-23
     @version 1.0
    */
    @TestVisible
    private void validateProfile(ClsWrappers.TriggerContext trgCtx) { 
        if (trgCtx.isBefore && trgCtx.isUpdate) {           
            Boolean check = false;
            Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
            List<SYS_CCRP_Allowed_Profiles__c> ccrpProfiles = SYS_CCRP_Allowed_Profiles__c.getall().values();
            Profile objProfile = [select Name from profile where id = :Userinfo.getProfileId() LIMIT :remLimit];
            for(SYS_CCRP_Allowed_Profiles__c ccrpProf : ccrpProfiles){
                if(objProfile.Name == ccrpProf.Name){
                    check = true;
                }
            }           
            Id caseComplaintRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Complaint').getRecordTypeId();
            for(sobject so : trgCtx.newList) {
                Case c = (Case)so;
                if(String.valueOf(trgCtx.oldMap.get(c.Id).get('Status')) != c.Status && (String.valueOf(trgCtx.oldMap.get(c.Id).get('Status')) != 'New' && c.Status != 'Under Investigation') && check == false && c.RecordTypeId == caseComplaintRecTypeId){
                    c.Status.addError('You do not have permission to change Case Status because the Case has generated CCRP complaint.');
                }
                if(trgCtx.oldMap.get(c.Id).get('Ownerid') != c.Ownerid && check == false && c.RecordTypeId == caseComplaintRecTypeId){
                    c.addError('You do not have permission to change Case Owner because the Case has generated CCRP complaint.');
                }               
            }
        }        
    }
     /**
     *  This trigger is used to prevent case country legislation issue.
     @author  Rajesh K
     @created 2015-12-23
     @version 1.0
    */
      @TestVisible
   private void validateOwnerCountry(ClsWrappers.TriggerContext trgCtx) { 
        if (trgCtx.isBefore && trgCtx.isUpdate) {
            Set<id> owneridset = new Set<id>();
            set<id> inputAccountIds = new set<Id>();
             Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
            Map<String, Schema.RecordTypeInfo> AccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName();
            String ABBICV = AccountRecordType.get('ABB ICV').getRecordTypeId();
             String GISApproved = AccountRecordType.get('GIS Approved').getRecordTypeId();
            for(sobject so : trgCtx.newList) {
                Case c = (Case)so;
                owneridset.add(c.ownerID);
                inputAccountIds.add(c.AccountID);
            }
            Map<Id, User> caseOwnerMap = new Map<Id, User>([SELECT Id, Country FROM User WHERE Id IN: ownerIdSet LIMIT :remLimit]);
            map<Id,Account> detailAccMap = new Map<Id,Account>([Select Id,RecordtypeId From Account where Id IN: inputAccountIds and ((RecordtypeId =: GISApproved and Company_Status__c = 'Approved') OR (ICV_ID__c != ''and RecordtypeId =: ABBICV)) LIMIT :remLimit]); 
            Map<Id, Boolean> caseOwnerCountryValidateMap = new Map<Id, Boolean>();
            List<Lead_Owner_Countries__c> mcs = Lead_Owner_Countries__c.getall().values();
            for(User ownerRecord: caseOwnerMap.values()){
                for(Lead_Owner_Countries__c CID : mcs){
                    if(ownerRecord.country!= NUll &&ownerRecord.country == CID.Name){
                        if(!caseOwnerCountryValidateMap.containsKey(ownerRecord.Id)){
                            caseOwnerCountryValidateMap.put(ownerRecord.Id, true);
                        }
                    }
                }
            }
             for(sobject so : trgCtx.newList) {
                    Case c = (Case)so;
                    if(caseOwnerCountryValidateMap.containsKey(c.OwnerId)&&(c.NPS_Survey__c == true && c.Status == 'Closed' ))
                    { 
                        c.addError('For Case owner country Transactional NPS survey is not possible from SFDC due to legislation issues. Please execute from NPS directly.');
                    }
                    else if(((!detailAccMap.containsKey(c.accountId))&&(c.NPS_Survey__c == true && c.Status == 'Closed' )))
                    {
                        c.addError('Account changed on SFDC which are not yet approved by GIS cannot be survey by NPS.');
                    }
                }
            }        
    }
    /**
     *  Take the case Id
     *    
    */    
    @TestVisible
    private void recordTypeUpdate(ClsWrappers.TriggerContext trgCtx){
    
    if (trgCtx.isAfter) return;
        
        Id ClosedCaseID = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Closed Case').getRecordTypeId();
        if (trgCtx.isUpdate) {
          for(sobject so : trgCtx.newList) {
            Case c = (Case)so;
            if(c.Status == 'Closed') {            
                c.RecordTypeId=ClosedCaseID;
                if(c.NPS_ID__c == null && c.NPS_Survey__c == true && c.NPS_Error_Message__c ==NULL && c.NPS_Initiated__c== false){
                    c.NPS_Initiated__c = true;
                    NPS_SendRequestHandler.caseRequest(c.id);
                }
            }
          }
        }
    }
     
    /**
     *  This trigger is used to update resolutionDate on case closure
     *    
    */
    @TestVisible
    private void resolutionDateUpdate(ClsWrappers.TriggerContext trgCtx){
    
    if (trgCtx.isAfter) return;
        
        if (trgCtx.isUpdate) {
          for(sobject so : trgCtx.newList) {
            Case c = (Case)so;
            if(c.Status == 'Closed' && string.valueOf(trgCtx.oldMap.get(c.Id).get('Status')) != c.Status) {
            c.Assigned_Date__c= system.now();
            }
          }
        }
    }
    /**
     *  This trigger is used to prevent parent case changed to closed util all child cases are closed.
     *
     @author  Jinbo Shan
     @created 2015-03-12
     @version 1.0
     @since   30.0 (Force.com ApiVersion)
     *
     @changelog
     * 2015-03-12 Jinbo Shan <jinbo.shan@itbconsult.com>
     * - Created
    */    
    @TestVisible
    private void preventParentCloseParentCase(ClsWrappers.TriggerContext trgCtx) {
         Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
        // Check trigger event
        if (trgCtx.isBefore) return;
        
        if (trgCtx.isUpdate) {
            set<Id> set_cIds = new set<Id>();
            for (Case c : [select Id, ParentId, Status, Parent.Status from Case where Id IN: trgCtx.newMap.keySet() LIMIT :remLimit]) {
                if(trgCtx.oldMap.get(c.Id).get('Status') != c.Status) {
                    if(c.Status == 'Closed' ) {
                        set_cIds.add(c.Id);
                    }
                }
                if(trgCtx.oldMap.get(c.Id).get('ParentId') != c.ParentId && c.ParentId != null && c.Parent.Status == 'Closed') {
                    trgCtx.newMap.get(c.Id).addError(system.Label.Case_Can_Not_Reparent_To_No_Closed_Case);
                }
            }
            
            for(Case c : [SELECT Id, Status, ParentId, Parent.Complaint_ID__c FROM Case WHERE ParentId IN :set_cIds LIMIT :remLimit]) {
                if(c.Status != 'Closed' && trgCtx.newMap.containsKey(c.ParentId) && c.Parent.Complaint_ID__c == NULL) {    //Added Complaint ID check for R5 - Integration
                    trgCtx.newMap.get(c.ParentId).addError(system.Label.Case_Closed_All_Children_Should_Closed);
                }
            }
        }
        
        if(trgCtx.isInsert) {
            for (Case c : [select Id, ParentId, Status, Parent.Status from Case where Id IN: trgCtx.newMap.keySet() LIMIT :remLimit]) {
                if(c.ParentId != null && c.Status != 'Closed' && c.Parent.Status == 'Closed') {
                    trgCtx.newMap.get(c.Id).addError(system.Label.Case_Can_Not_Reparent_To_No_Closed_Case);
                }
                
            }
        }
        
    }
    
    /**
     *  This trigger is used to prevent case with OpenActivity.
     *
     @author  Sherlock Feng
     @created 2015-03-18
     @version 1.0
     @since   30.0 (Force.com ApiVersion)
     *
     @changelog
     * 2015-03-18 Sherlock Feng <sherlock.feng@itbconsult.com>
     * - Created
    */
    @TestVisible
    private void preventOpenActivity(ClsWrappers.TriggerContext trgCtx) {
         Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
        // Check trigger event
        if (trgCtx.isBefore) return;
        
        if (trgCtx.isUpdate) {
            set<Id> set_cId1 = new set<Id>();
            set<Id> set_cId2 = new set<Id>();
            for (Case c : [select Id, ParentId, Status, Parent.Status from Case where Id IN: trgCtx.newMap.keySet() LIMIT :remLimit]) {
                if(trgCtx.oldMap.get(c.Id).get('Status') != c.Status) {
                    if(c.Status == 'Closed' ) {
                        set_cId1.add(c.Id);
                    }
                }
            }
            
            for(Case c : [SELECT (SELECT WhatId FROM OpenActivities), Id, Status, Complaint_ID__c, ParentId FROM Case WHERE Id IN :set_cId1 LIMIT :remLimit]) {
                if(c.OpenActivities.size()>0 && c.Complaint_ID__c == null) {
                    trgCtx.newMap.get(c.Id).addError(system.Label.Case_Closed_Error_Open_Activity);
                }
            }
        }
        
    }
    
    /**
     *  This trigger is used to copy all account manager to case chatter group.
     *
     @author  Jinbo Shan
     @created 2015-03-25
     @version 1.0
     @since   30.0 (Force.com ApiVersion)
     *
     @changelog
     * 2015-03-25 Jinbo Shan <jinbo.shan@itbconsult.com>
     * - Created
    */
    @TestVisible
    private void updateChatterGroup(ClsWrappers.TriggerContext trgCtx){
        // Check trigger event
        if (trgCtx.isBefore) return;
        
        map<Id, set<Id>> map_accId_set_caseIds = new map<Id, set<Id>>();
        set<Id> set_accIds = new set<Id>();
        
        // Check trigger event
        if(trgCtx.isInsert) {
            for(sobject so : trgCtx.newList) {
                Case c = (Case)so;
                set_accIds.add(c.AccountId);
            }
        }
        
        if(trgCtx.isUpdate) {
            for(sobject so : trgCtx.newList) {
                if((Id)(string.valueOf(so.get('AccountId'))) != (Id)(string.valueOf(trgCtx.oldMap.get((Id)(string.valueOf(so.get('Id')))).get('AccountId')))) {
                    Case c = (Case)so;
                    set_accIds.add(c.AccountId);
                    if(!map_accId_set_caseIds.containsKey(((Case)(trgCtx.oldMap.get(c.Id))).AccountId)) {
                        map_accId_set_caseIds.put(((Case)(trgCtx.oldMap.get(c.Id))).AccountId, new set<Id>());
                    }
                    map_accId_set_caseIds.get(((Case)(trgCtx.oldMap.get(c.Id))).AccountId).add(c.Id);
                }
            }
        }
        //system.debug('**@@map_accId_set_caseIds = ' + map_accId_set_caseIds);
        //system.debug('**@@set_accIds = ' + set_accIds);
        if(map_accId_set_caseIds.size() > 0) {
            deleteOldEntitySubsForCase(map_accId_set_caseIds);
        }
        
        if(set_accIds.size() > 0) {
            insertEntitySubsForAccountTeamMem(set_accIds);
        }
    }
    
     /**
     *  This trigger is used to Notification upon Case Closure.
     *
     @author  Jinbo Shan
     @created 2015-04-27
     @version 1.0
     @since   33.0 (Force.com ApiVersion)
     *
     @changelog
     * 2015-04-27 Jinbo Shan <jinbo.shan@itbconsult.com>
     * - Created
    */
    @TestVisible
  private void notificationForCaseClosure(ClsWrappers.TriggerContext trgCtx) {
      // Check trigger event
        if (trgCtx.isBefore) return;
       
        set<Id> set_cIds = new set<Id>();
        map<Id, String> map_cId_email = new map<Id, String>();
        map<Id, Id> map_cId_conId = new map<Id, Id>();
        map<Id, Case> mapcase = new map<Id, Case>();
        Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
        if (trgCtx.isUpdate) {
          for(sobject so : trgCtx.newList) {
            Case c = (Case)so;
            if((ClsTriggerFactory.isRun == false)&&c.Status == 'Closed' && c.Update_Customer_via_Email__c && string.valueOf(trgCtx.oldMap.get(c.Id).get('Status')) != c.Status) {
              set_cIds.add(c.Id);
              mapcase.put(c.id,c);
            }
          }
        }
        
        if (set_cIds.size() > 0) {
          for (Case c : [SELECT Id, Contact.Email,SuppliedEmail, ContactId FROM Case WHERE Id IN : set_cIds LIMIT :remLimit]) {
            if (c.ContactId != null && c.Contact.Email != null) {
              map_cId_conId.put(c.Id, c.ContactId);
             
            } 
            /*else {
              if (c.SuppliedEmail != null) {
                map_cId_email.put(c.Id, c.Contact.Email);
              }
            }*/
          }
          /*if (map_cId_email.size() > 0) {
            for (Id caseId : map_cId_email.keySet()) {
              ClsUtil.sendTemplatedEmail(new list<string>{map_cId_email.get(caseId)}, new list<string>(), 'Case_Closure_Alert', caseId, caseId, null, true, new list<Attachment>());
            }
          }*/
          if(map_cId_conId.size() > 0) {
            for (Id caseId : map_cId_conId.keySet()) {
               try{
                    ClsUtil.sendTemplatedEmail(new list<string>(), new list<string>(), 'Case_Closure_Alert', map_cId_conId.get(caseId), caseId, null, true, new list<Attachment>());
               }Catch(Exception ex){
                   mapcase.get(caseId).addError(ex.getMessage());
               }
            }
          }       
           ClsTriggerFactory.isRun = true;
        }
    }
    
    
    /**
     *  This trigger is used to update Case Inquiry Number.
     *
     @author  Sherlock Feng
     @created 2015-03-19
     @version 1.0
     @since   30.0 (Force.com ApiVersion)
     *
     @changelog
     * 2015-03-19 Sherlock Feng <sherlock.feng@itbconsult.com>
     * - Created
    */
    /*@TestVisible
    private void updateCaseInquiryNumber(ClsWrappers.TriggerContext trgCtx) {
        
        // Check trigger event
        if (trgCtx.isAfter) return;
        
        if (trgCtx.isInsert) {
            //set<String> set_CaseInquiryNumber = new set<String>();
            List<String> list_addCaseInquiryNumber =  new List<String>();
            set<String> set_ExitCaseInquiryNumber = new set<String>();
            
            ClsUtil cu = new ClsUtil();
            for(Case c : [select Id, Case_Inquiry_Number__c from Case where CreatedDate = today]){
                set_ExitCaseInquiryNumber.add(c.Case_Inquiry_Number__c);
            }
            //system.debug('@set_CaseInquiryNumber.size()--'+set_CaseInquiryNumber.size());
            system.debug('@trgCtx.newMap.size()--'+trgCtx.newList.size());
            while(list_addCaseInquiryNumber.size()<trgCtx.newList.size()){
                String cin = cu.formatInquiryNumber();
                if(set_ExitCaseInquiryNumber.contains(cin)){
                    continue;
                }else{
                    set_ExitCaseInquiryNumber.add(cin);
                    list_addCaseInquiryNumber.add(cin);
                }
            }
            system.debug('@list_addCaseInquiryNumber--'+list_addCaseInquiryNumber);
            integer i = 0;
            for (SObject sobj : trgCtx.newList) {
                Case c = (Case)sobj;
                if(c.Case_Inquiry_Number__c == '' || c.Case_Inquiry_Number__c == null) {
                    //for(String s : set_CaseInquiryNumber){
                        //c.Case_Inquiry_Number__c = s;
                    //}
                    c.Case_Inquiry_Number__c = list_addCaseInquiryNumber.get(i);
                    i++;
                }
            }
            
        }
        
    }*/
    
    /**
     *  This trigger is used to insert account team member that role is account manager to EntitySubscription with its related cases.
     *
     @author  Jinbo Shan
     @created 2015-03-25
     @version 1.0
     @since   30.0 (Force.com ApiVersion)
     *
     @changelog
     * 2015-03-25 Jinbo Shan <jinbo.shan@itbconsult.com>
     * - Created
    */
    @TestVisible 
    private void insertEntitySubsForAccountTeamMem(set<Id> set_accIds) {
        
        set<Id> set_uIds = new set<Id>();
        map<Id, set<Id>> map_accId_set_uIds = new map<Id, set<Id>>();
        map<Id, set<Id>> map_accId_set_cIds = new map<Id, set<Id>>();
        set<Id> set_cIds = new set<Id>();
        map<Id, map<Id, EntitySubscription>> map_cId_uid_es = new map<Id, map<Id, EntitySubscription>>();
        list<EntitySubscription> list_es = new list<EntitySubscription>();
        Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
        //get all cases from accounts
        for(Case c : [select Id, AccountId from Case where AccountId IN :set_accIds LIMIT :remLimit]) {
            if(!map_accId_set_cIds.containsKey(c.AccountId)) {
                map_accId_set_cIds.put(c.AccountId, new set<Id>());
            }
            map_accId_set_cIds.get(c.AccountId).add(c.Id);
            set_cIds.add(c.Id);
        }
        
        //get the Account Manager for all accounts
        getManagerTeamMemForAccount(set_accIds, set_uIds, map_accId_set_uIds);
        
        //get exists EntitySubscription for filter
        getExistEntitySubs(set_cIds, set_uIds, map_cId_uid_es);
        
        //system.debug('**@@map_accId_set_uIds = ' + map_accId_set_uIds);
        //system.debug('**@@map_cId_uid_es = ' + map_cId_uid_es);
        
        //
        for(Id accId : map_accId_set_cIds.keySet()) {
            if(map_accId_set_uIds.containsKey(accId)) {
                for(Id uId : map_accId_set_uIds.get(accId)) {
                    for(Id cId : map_accId_set_cIds.get(accId)) {
                        if(!map_cId_uid_es.containsKey(cId) || !map_cId_uid_es.get(cId).containsKey(uId)) {
                            EntitySubscription es = new EntitySubscription();
                            es.ParentId = cId;
                            es.SubscriberId = uId;
                            list_es.add(es);
                        }
                    }

                }
                
            }
        }
        //system.debug('**@@list_es = ' + list_es);
        if(list_es.size() > 0){
            Database.Insert(list_es,False);
        }
    }
    
    /**
     *  This trigger is used to delete the EntitySubscription that is related to old value of the case and case.accountId.
     *
     @author  Jinbo Shan
     @created 2015-03-25
     @version 1.0
     @since   30.0 (Force.com ApiVersion)
     *
     @changelog
     * 2015-03-25 Jinbo Shan <jinbo.shan@itbconsult.com>
     * - Created
    */
    @TestVisible
    private void deleteOldEntitySubsForCase(map<Id, set<Id>> map_accId_set_caseIds) {
        map<Id, set<Id>> map_accId_set_uIds = new map<Id, set<Id>>();
        set<Id> set_uIds = new set<Id>();
        set<Id> set_cIds = new set<Id>();
        map<Id, map<Id, EntitySubscription>> map_cId_uid_es = new map<Id, map<Id, EntitySubscription>>();
        
        list<EntitySubscription> list_es4delete = new list<EntitySubscription>();
        
        //get the Account Manager for all accounts
        getManagerTeamMemForAccount(map_accId_set_caseIds.keySet(), set_uIds, map_accId_set_uIds);
        
        for(Id accId : map_accId_set_caseIds.keySet()) {
            set_cIds.addAll(map_accId_set_caseIds.get(accId));
        }
        
        //get exists EntitySubscription for filter
        getExistEntitySubs(set_cIds, set_uIds, map_cId_uid_es);
        
       // system.debug('**@@map_accId_set_uIds = ' + map_accId_set_uIds);
       // system.debug('**@@map_cId_uid_es = ' + map_cId_uid_es);
        //
        for(Id accId : map_accId_set_caseIds.keySet()) {
            if(map_accId_set_uIds.containsKey(accId)) {
                for(Id uId : map_accId_set_uIds.get(accId)) {
                    for(Id cId : map_accId_set_caseIds.get(accId)) {
                        if(map_cId_uid_es.containsKey(cId) && map_cId_uid_es.get(cId).containsKey(uId)) {
                            list_es4delete.add(map_cId_uid_es.get(cId).get(uId));
                        }
                    }
                }
            }
        }
        //system.debug('**@@list_es4delete = ' + list_es4delete);
        if(list_es4delete.size() > 0) {
            Database.Delete(list_es4delete,False);
        }
    }
    
    /**
     *  This trigger is get account team member that role is account manager for account.
     *
     @author  Jinbo Shan
     @created 2015-03-25
     @version 1.0
     @since   30.0 (Force.com ApiVersion)
     *
     @changelog
     * 2015-03-25 Jinbo Shan <jinbo.shan@itbconsult.com>
     * - Created
    */
    @TestVisible 
    private void getManagerTeamMemForAccount(set<Id> set_accIds, set<Id> set_uIds, map<Id, set<Id>> map_accId_set_uIds) {
        Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
        for(AccountTeamMember atm : [select Id, UserId, AccountId from AccountTeamMember where AccountId IN : set_accIds and TeamMemberRole = 'Account Manager' LIMIT :remLimit]) {
            if(!map_accId_set_uIds.containsKey(atm.AccountId)) {
                map_accId_set_uIds.put(atm.AccountId, new set<Id>());
            }
            map_accId_set_uIds.get(atm.AccountId).add(atm.UserId);
            set_uIds.add(atm.UserId);
        }
    }
    
    /**
     *  This trigger is used to get exist EntitySubscription for related case and user.
     *
     @author  Jinbo Shan
     @created 2015-03-25
     @version 1.0
     @since   30.0 (Force.com ApiVersion)
     *
     @changelog
     * 2015-03-25 Jinbo Shan <jinbo.shan@itbconsult.com>
     * - Created
    */
    @TestVisible 
    private void getExistEntitySubs(set<Id> set_cIds, set<Id> set_uIds, map<Id, map<Id, EntitySubscription>> map_cId_uid_es) {
        for(EntitySubscription es : [select ParentId, Id, SubscriberId from EntitySubscription where ParentId IN :set_cIds and SubscriberId IN :set_uIds limit 999]) {
            if(!map_cId_uid_es.containsKey(es.ParentId)) {
                map_cId_uid_es.put(es.ParentId, new map<Id, EntitySubscription>());
            }
            map_cId_uid_es.get(es.ParentId).put(es.SubscriberId, es);
        }
    }
    
    
     /*  Description of the purpose of the method. 
    *  @name setLSORefDatafromAccountOnInsert
    *  @Description - Req -2168. Auto populates the Local Reference Data from associated Accounts while creating a Case.
    *  @return - void
    *  @created by - Shankar Anand
    */
    private void setLSORefDatafromAccountOnInsert(ClsWrappers.TriggerContext trgCtx) {
   
      Set<Id> accountIds = new Set<Id>();
      Set<Id> caseOwnerIds = new Set<Id>(); 
      Set<id> caseIds = new Set<id>(); 
      String userLSO;
      String userLSO1;
      String accLSO;
      List<Case> caseList = new List<Case>();
      Map<Id,Case> oldCaseMap = new map<Id,Case>();
      Map<Id,Account> accountMap = new map<Id,Account>();
      Map<Id,User> userMap = new map<Id,User>();
      
      
      if(trgCtx!=null && trgCtx.isAfter && trgCtx.isInsert){
        for(sobject so : trgCtx.newList) {
                Case cse = (Case)so;
                accountIds.add(cse.AccountId);
                caseOwnerIds.add(cse.ownerId);
                caseIds.add(cse.id);
            }
            
      
      accountMap = new map<Id,Account>([Select Id, Name, (Select Id, name,LBU__c,LSO__c,LSO_ERP_Mapping_Value__c from LSO_Reference_Datas__r) from Account where ID IN :accountIds LIMIT 50000]);
      userMap = new map<Id,User>([Select Id, Name,Default_BU__c,Default_LSO__c,Default_Country_ISO_Code__c from User where Id in:caseOwnerIds LIMIT 50000]);          
      }
           
            if(trgCtx!=null && trgCtx.isAfter && trgCtx.isInsert){ 
               for(sobject so : trgCtx.newList) {
                Case cse = (Case)so; 
                Case cas = new Case(Id =cse.Id);
                Account eua = accountMap.get(cse.AccountId);
                User usr = userMap.get(cse.ownerid);
                if(usr!=null){
                   if(usr.Default_BU__c!=null){
                      userLSO = usr.Default_LSO__c+usr.Default_BU__c;
                     }
                   else{
                      userLSO1 = usr.Default_LSO__c;
                     }
                 
                 if(eua!=null){
                  for(ERP_Reference_Data__c lrd:eua.LSO_Reference_Datas__r){
                    accLSO = String.valueof(lrd.LSO__c)+String.valueof(lrd.LBU__c);       
                    if(usr.Default_LSO__c!= null && usr.Default_BU__c!=null &&  lrd.LBU__c!= null && userLSO!=null && accLSO!=null && userLSO.equalsIgnorecase(accLSO)){
                        cas.Account_LSO_Case__c = lrd.id;
                        break;
                    }
                    else if(usr.Default_LSO__c!= null && usr.Default_BU__c ==null &&  lrd.LBU__c == null && userLSO1!=null && userLSO1.equalsIgnorecase(String.valueof(lrd.LSO__c))){    
                        cas.Account_LSO_Case__c = lrd.id;
                        break;
                    }
                  }
                }
                }
                caseList.add(cas);
               }
               database.update(caseList);
            }
            
        }  

    /*  Description of the purpose of the method. 
    *  @name setLSOrefDataFromAccountOnUpdate
    *  @Description - Req -2168. Auto populates the Local Reference Data from associated Accounts while updating a Case.
    *  @return - void
    *  @created by - Shankar Anand
    */
    private void setLSOrefDataFromAccountOnUpdate(ClsWrappers.TriggerContext trgCtx){
      Set<Id> accountIds = new Set<Id>();
      Set<Id> caseOwnerIds = new Set<Id>(); 
      Set<id> caseIds = new Set<id>(); 
      String userLSO;
      String userLSO1;
      String accLSO;
      Map<Id,Case> oldCaseMap = new map<Id,Case>();
      Map<Id,Account> accountMap = new map<Id,Account>();
      Map<Id,User> userMap = new map<Id,User>();
      
     
      if(trgCtx!=null && trgCtx.isBefore && trgCtx.isUpdate){
        for(sobject so : trgCtx.newList) {
                Case cse = (Case)so;
                accountIds.add(cse.AccountId);
                caseOwnerIds.add(cse.ownerId);
                caseIds.add(cse.id);
            }
            
      accountMap = new map<Id,Account>([Select Id, Name, (Select Id, name,LBU__c,LSO__c,LSO_ERP_Mapping_Value__c from LSO_Reference_Datas__r) from Account where ID IN :accountIds LIMIT 50000]);
      userMap = new map<Id,User>([Select Id, Name,Default_BU__c,Default_LSO__c,Default_Country_ISO_Code__c from User where Id in:caseOwnerIds LIMIT 50000]);          
      }
            if(trgCtx!=null && trgCtx.isBefore && trgCtx.isUpdate){ 
    
                for(sobject so : trgCtx.oldList){
                    Case cse = (Case)so;
                    oldCaseMap.put(cse.id,cse);       
                } 

                for(sobject so : trgCtx.newList) {
                    Case cse = (Case)so;
                    Account eua = accountMap.get(cse.AccountId);
                    User usr = userMap.get(cse.ownerid);
                if(usr!=null){
                    if(usr.Default_BU__c!=null){
                        userLSO = usr.Default_LSO__c+usr.Default_BU__c;
                    }
                    else{
                        userLSO1 = usr.Default_LSO__c;
                    }
                    
                
                
                if((oldCaseMap.get(cse.id).AccountId != cse.AccountId) || (cse.ownerId != oldCaseMap.get(cse.id).ownerId && usr.Default_LSO__c!=null)){
                if(eua!=null){
                    List<ERP_Reference_Data__c> aeuLsoRefList = new List<ERP_Reference_Data__c>();
                    aeuLsoRefList.addall(eua.LSO_Reference_Datas__r);
           
                    if(aeuLsoRefList.size()>0){
                        for(ERP_Reference_Data__c lrd:eua.LSO_Reference_Datas__r){
                            accLSO = String.valueof(lrd.LSO__c)+String.valueof(lrd.LBU__c);          
                            if(usr.Default_BU__c!=null &&  lrd.LBU__c!= null && userLSO !=null && accLSO!=null && userLSO.equalsIgnorecase(accLSO)){ 
                                cse.Account_LSO_Case__c = lrd.id;
                                break;
                            }
                            else if(usr.Default_BU__c==null &&  lrd.LBU__c == null && userLSO1!=null && userLSO1.equalsIgnorecase(String.valueof(lrd.LSO__c))){
                                cse.Account_LSO_Case__c = lrd.id;
                                break;
                            }
                            else{
                                cse.Account_LSO_Case__c  = null;
                            }
                        }
                    }
                    else{
                        cse.Account_LSO_Case__c  = null;
                    }
                } 
                }
                }
                }         
            }
           
        } 

      
          
}