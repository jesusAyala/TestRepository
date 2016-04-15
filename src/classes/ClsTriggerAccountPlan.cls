/**   
* TriggerClass :  ClsTriggerAccountPlan
*    
* Release R5
*  
* @author  Indhu Selvi Ramalingam (Accenture)
* @created 2016-01-18
* @version 1.0
*
* - Created
*/
public without sharing class ClsTriggerAccountPlan extends ClsTriggerVirtual {
    
    public Map<Id, RecordType> rtMap = new Map<Id, RecordType>();
    public Static Set<Id> processedIdSet = new Set<Id>();
    public Id freezeBudgetRTId = null;
    public Id abbBasicAdminProfileId = NULL;
/**   
* Constructor ClsTriggerAccountPlan 
*    
* Release R5
*/
    public ClsTriggerAccountPlan () {
        Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
        rtMap = new Map<Id, RecordType>([SELECT Id, Name FROM RecordType WHERE SobjectType =: Label.Account_Plan_Sobject AND IsActive = TRUE LIMIT :remLimit]); //'Account_Plan__c'
        
        Profile[] basicProf = [ SELECT ID, Name FROM Profile WHERE Name =: Label.Account_Plan_Profile LIMIT :remLimit];
        
        abbBasicAdminProfileId = (basicProf != NULL && basicProf.size() > 0) ? basicProf[0].Id : NULL;
        
        for(RecordType rt : rtMap.values()){
            if (rt.Name == Label.Account_Plan_Freeze_Budget) {
                freezeBudgetRTId = rt.Id;
            }
        } 
      
    }
 
/**   
* As per Req #2737
* When the user uncheckbox 'Freeze Budgets' then it will allow the user to Add any of the budgets by swapping the Record Type.         
* Release R5
*/   
    public override void bulkBefore(ClsWrappers.TriggerContext trgCtx) {
        
        if (trgCtx.isUpdate) {
        
            for (SObject sobj: trgCtx.newList) {
                
                if (!processedIdSet.contains(sobj.Id)) {
                
                    Account_Plan__c newAccountPlan = (Account_Plan__c) sobj;
                    Account_Plan__c oldAccountPlan = (Account_Plan__c) trgCtx.oldMap.get(sobj.Id);
                    
                   // system.debug('::new::'+newAccountPlan.Freeze_Account_Plan_Budgets__c  +':::'+oldAccountPlan.Freeze_Account_Plan_Budgets__c  +':::'+newAccountPlan.Old_Record_Type_Value__c);
                   // system.debug('::RTMap :::'+RTMap );  
                    
                    if (newAccountPlan.Freeze_Account_Plan_Budgets__c !=  oldAccountPlan.Freeze_Account_Plan_Budgets__c && newAccountPlan.Freeze_Account_Plan_Budgets__c == TRUE) {
                        
                        newAccountPlan.Old_Record_Type_Value__c = newAccountPlan.RecordTypeId; // Copy the previous record type
                        newAccountPlan.RecordTypeId = (freezeBudgetRTId != NULL) ? freezeBudgetRTId :  newAccountPlan.RecordTypeId;
                    } else if (newAccountPlan.Freeze_Account_Plan_Budgets__c != oldAccountPlan.Freeze_Account_Plan_Budgets__c && newAccountPlan.Freeze_Account_Plan_Budgets__c == FALSE && 
                        newAccountPlan.Old_Record_Type_Value__c != NULL && newAccountPlan.Old_Record_Type_Value__c != '' &&
                        rtMap.containsKey(newAccountPlan.Old_Record_Type_Value__c)){
                        
                        newAccountPlan.RecordTypeId = newAccountPlan.Old_Record_Type_Value__c;  // Update the previous record type
                    } 
                    
                    //system.debug('::after::newAccountPlan:::'+newAccountPlan.RecordTypeId+'::before::newAccountPlan:::'+newAccountPlan.Old_Record_Type_Value__c);
                    
                    processedIdSet.add(sobj.Id);
                } else{}              
            }
        }
    }
         
 
 
   /**
* @see IntHelper.beforeTrigger
*/  
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {        
        
        accountPlanRecordSharing(trgCtx); 
        if(trgCtx.isDelete) {  
            accountPlanRecordDelete(trgCtx);
            deleteValidation(trgCtx);
        }           
    } 
    
    
    
       /**
    To prevent deletion when the account plan status is closed
    */
     Public void deleteValidation(ClsWrappers.TriggerContext trgCtx){
         ID sysAdminProfileId = Label.CL00075;
         for (Account_Plan__c con : (List<Account_Plan__c>) trgCtx.oldList) {             
             if (sysAdminProfileId  != Userinfo.getProfileid() && con.Master_Account_Plan_Status__c == Label.Closed ) {
                 con.addError(Label.Business_Account_Plan_delete_Err); //You cannot save the changes as Master Account Plan Status is Closed.
             }
         }        
     }
/**
* @see IntHelper.afterTrigger
* As part of Req - 2738; KAD-00823;
*/   
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {        
        updateAccPlanInfoRecords(trgCtx);              
    }
    
/**     
Method : accountPlanRecordSharing - Method to create/view the Account Plan record only by Account team member
@author  Indhu Selvi Ramalingam(Accenture)
*/
    @TestVisible   
    private void accountPlanRecordSharing(ClsWrappers.TriggerContext trgCtx) {
    
      if(trgCtx.isInsert && trgCtx.isBefore){
            Set<ID> setAccTeamUserIds = new Set<ID>(); //capture the Account team users ids
            Set<ID> setAccIds = new Set<ID>(); //capture the Account Ids
            Map<ID, Set<Id>> mapUsersId = new Map<ID, Set<Id>>();
            Id labelId = Label.CL00075;
            Id userProfileId = Userinfo.getProfileid();
            Id currUser = UserInfo.getUserId();
            Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
            for(sobject so :trgCtx.newList){
                Account_Plan__c accPlan = (Account_Plan__c)so;
                setAccIds.add(accPlan.Account__c);
            }
            
            if (setAccIds.size() > 0) {
                for(AccountTeamMember atm : [SELECT id, UserId, AccountId FROM AccountTeamMember where AccountId IN:setAccIds LIMIT :remLimit]){
                    if(!mapUsersId.containsKey(atm.AccountId)){
                        mapUsersId.put(atm.AccountId, new Set<ID>());
                    }
                    mapUsersId.get(atm.AccountId).add(atm.UserId);
                } 
                
                Map<ID, Account> accMap = new Map <Id, Account> ([SELECT ID, OwnerID FROM Account WHERE ID IN :setAccIds LIMIT :remLimit]);
                
                for(sobject so : trgCtx.newList){
                    Account_Plan__c accPlan = (Account_Plan__c)so;
                    if(accPlan.Account__c != NULL && mapUsersId.containsKey(accPlan.Account__c)){
                        setAccTeamUserIds = mapUsersId.get(accPlan.Account__c);                  
                    }
                    
                    if(accPlan.Account__c != NULL && !setAccTeamUserIds.contains(currUser) && currUser != accMap.get(accPlan.Account__c).OwnerId && abbBasicAdminProfileId != userProfileId ){
                        so.addError(System.label.System_CL00102);
                    }
                }
            }
           
        } 
     }
     
/* 
* Method - Deleting Account Plan Records will delete Account Plan Information  - KAD-00823 (Req #2738)
*/    
    @TestVisible
    public void accountPlanRecordDelete(ClsWrappers.TriggerContext trgCtx) {
        
        Set<Id> setAccPlanId = new Set<Id>();
        Map<Id,Account_Plan__c> accPlanIdAndRecordMap = new Map<Id, Account_Plan__c>();
        Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
    
        for(sobject so : trgCtx.oldList) {
            Account_Plan__c sobjAccPlan = (Account_Plan__c)so;
            setAccPlanId.add(sobjAccPlan.Id);
        } 
        
        if (setAccPlanId.size() > 0) {
        
            List<Account_Plan_Information__c> listAccPlanInfo = new List<Account_Plan_Information__c> ([SELECT Id, Name, Account_Plan__c, BU__c, DIV__c,
                                                                                                    Account_Plan_Status__c, Account_Plan_Year__c,
                                                                                                    Account_Plan_Owner__c FROM Account_Plan_Information__c WHERE Account_Plan__c =: setAccPlanId LIMIT :remLimit]);
           /* for(Account_Plan_Information__c  accPlanInfo : listAccPlanInfo) {
                
                if(trgCtx.isDelete) {
                    
                    accPlanInfo.Account_Plan_Owner__c = NULL;
                    accPlanInfo.BU__c = '';
                    accPlanInfo.DIV__c = '';
                    accPlanInfo.Account_Plan_Start_Date__c = NULL;
                    accPlanInfo.Account_Plan_End_Date__c = NULL;
                    accPlanInfo.Account_Plan_Status__c = '';
                }
            }*/
            
            if (listAccPlanInfo.size() > 0) {
                try {
                    Database.Delete(listAccPlanInfo);
                } Catch (DMLException e) {
                    
                    List<Sobject> objList = trgCtx.newList;
            
                    String error = '';
                    
                    for (Integer i=0; i < e.getNumDML(); i++) {
                        error += e.getDmlMessage(i) + Label.Line_Break;
                    }
                    for (Sobject obj: objList) {                
                        Account_Plan__c qtm = (Account_Plan__c ) obj;
                        qtm.addError(error, false);            
                    }            
                }       
            }
       }
    }
        
           
/* 
* Method - Update Account Plan Information Records based on Account Plan - KAD-00823 (Req #2738)
*/     
    @TestVisible
    public void updateAccPlanInfoRecords(ClsWrappers.TriggerContext trgCtx) {
    
        Set<Id> setAccPlanId = new Set<Id>();
        Map<Id,Account_Plan__c> accPlanIdAndRecordMap = new Map<Id, Account_Plan__c>();
        Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
        List<Account_Plan_Information__c> listAccPlanInfo = new List<Account_Plan_Information__c>();
        
        //system.debug('::trgCtx::'+trgCtx);
        
        if(trgCtx.isUpdate) {
            for(sobject so : trgCtx.newList) {
                Account_Plan__c newAccPlan = (Account_Plan__c) so;
                Account_Plan__c oldAccPlan = (Account_Plan__c) trgCtx.oldMap.get(so.Id);
                
                if(newAccPlan.Status__c != oldAccPlan.Status__c || newAccPlan.Name != oldAccPlan.Name || newAccPlan.BU__c != oldAccPlan.BU__c ||
                   newAccPlan.DIV__c != oldAccPlan.DIV__c || newAccPlan.OwnerID != oldAccPlan.OwnerID || newAccPlan.Account__c != oldAccPlan.Account__c ||
                   newAccPlan.Product_Lines__c != oldAccPlan.Product_Lines__c|| newAccPlan.PG__c != oldAccPlan.PG__c || newAccPlan.RecordTypeId != oldAccPlan.RecordTypeId ||
                   newAccPlan.Account_Plan_Year__c != oldAccPlan.Account_Plan_Year__c) {
                    setAccPlanId.add(newAccPlan.Id);
                    accPlanIdAndRecordMap.put (newAccPlan.Id, newAccPlan);
                }
                
            }
        } 
           
        if(trgCtx.isInsert) {
            for(sobject so : trgCtx.newList) {
            
                Account_Plan__c accPlan = (Account_Plan__c) so;
                Account_Plan_Information__c sobjAccPlanInfo = new Account_Plan_Information__c();
                sobjAccPlanInfo.Account_Plan_Owner__c = accPlan.OwnerId;
                sobjAccPlanInfo.Account_Plan__c = accPlan.ID;
                sobjAccPlanInfo.Account__c = accPlan.Account__c;
                sobjAccPlanInfo.BU__c = accPlan.BU__c;
                sobjAccPlanInfo.DIV__c = accPlan.DIV__c;
               
                sobjAccPlanInfo.Account_Plan_Status__c = accPlan.Status__c;
                sobjAccPlanInfo.PG__c = accPlan.PG__C;    
                sobjAccPlanInfo.Product_Lines__c = accPlan.Product_Lines__c;
                sobjAccPlanInfo.Account_Plan_Year__c = accPlan.Account_Plan_Year__c;
                sobjAccPlanInfo.Account_Plan_Type__c= (rtMap.containsKey(accPlan.RecordTypeId)) ? rtMap.get(accPlan.RecordTypeId).Name : '';  
                listAccPlanInfo.add(sobjAccPlanInfo);
            }
        }
        
        
        if (setAccPlanId.size() > 0) {
        
            listAccPlanInfo = [SELECT Id, Account__c, Name, Account_Plan__c, BU__c, PG__C, Product_Lines__c, DIV__c, Account_Plan_Status__c,
                            Account_Plan_Year__c, Account_Plan_Owner__c FROM Account_Plan_Information__c WHERE Account_Plan__c =: setAccPlanId LIMIT :remLimit];
            
            //system.debug('::listAccPlanInfo :::'+listAccPlanInfo );
            
            for(Account_Plan_Information__c  accPlanInfo : listAccPlanInfo) {
                    
                Account_Plan__c accPlan = accPlanIdAndRecordMap.get(accPlanInfo.Account_Plan__c);
                
                accPlanInfo.Account_Plan_Owner__c = accPlan.OwnerId;
                accPlanInfo.BU__c = accPlan.BU__c;
                accPlanInfo.DIV__c = accPlan.DIV__c;              
                accPlanInfo.Account_Plan_Status__c = accPlan.Status__c;    
                accPlanInfo.Account__c = accPlan.Account__c;
                accPlanInfo.PG__c = accPlan.PG__C;    
                accPlanInfo.Product_Lines__c = accPlan.Product_Lines__c;
                accPlanInfo.Account_Plan_Year__c = accPlan.Account_Plan_Year__c; 
                accPlanInfo.Account_Plan_Type__c= (rtMap.containsKey(accPlan.RecordTypeId)) ? rtMap.get(accPlan.RecordTypeId).Name : ''; 
                  
                           
            }
        }
        
        if (listAccPlanInfo.size() > 0) {
            
            try {
                Database.Upsert(listAccPlanInfo);
            }  Catch (DMLException e) {   
                
                List<Sobject> objList = trgCtx.newList;
        
                String error = '';
                
                for (Integer i=0; i < e.getNumDML(); i++) {
                    error += e.getDmlMessage(i) + Label.Line_Break;
                }
                for (Sobject obj: objList) {                
                    Account_Plan__c qtm = (Account_Plan__c ) obj;
                    qtm.addError(error, false);            
                }            
            }         
        }
        
    }
}