/**
 * TriggerClass -  ClsTriggerAccountPlanTeam
 * Release R5
 * @author  Vasanthi M(Accenture)
 * @created 2016-03-08
 * @version 1.0
 * Created 
  Purpose: Providing sharing permission to Account Plan records based on Account Plan Team. 
 */
  
public without sharing class ClsTriggerAccountPlanTeam extends ClsTriggerVirtual {
    
    Set<Id> adminUserIdSet = new Set<Id>();
    
    /**
     * constructor
    */
    public ClsTriggerAccountPlanTeam() {
        
        Map<Id, User> adminUserMap = new Map<Id, User> ([ SELECT Id, Name FROM User WHERE Profile.Name = :Label.Sys_Admin_Profile_Name AND IsActive = TRUE LIMIT 50000]);
        adminUserIdSet.addAll(adminUserMap.KeySet());
    }   
    
    /**
     * @see IntHelper.afterTrigger
    */
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
        createOrRemoveShare(trgCtx);
    }
    
    /**    
     * To grant/revoke access
    */ 
    public void createOrRemoveShare(ClsWrappers.TriggerContext trgCtx) {
        
        List<Account_Plan_Team__c> qualList = (trgCtx.IsDelete) ? trgCtx.OldList : trgCtx.newList;
        
        List<Account_Plan_Team__c> processList = new List<Account_Plan_Team__c>();
        List<Account_Plan__Share> tobeUpsertedList = new List<Account_Plan__Share>();
        List<Account_Plan__Share> tobeDeletedList = new List<Account_Plan__Share>();
        Map<String, Account_Plan__Share> existingShareMap = new Map<String, Account_Plan__Share>();
        Set<Id> accountPlanIdset = new Set<Id>();
        Set<Id> userIdSet = new Set<Id>();     
        Set<String> accPlanAndUserIdSet = new Set<String>();       
        
        for (Account_Plan_Team__c team: qualList) {
            
            Account_Plan_Team__c oldteam =  (trgCtx.isUpdate) ? (Account_Plan_Team__c) trgCtx.oldMap.get(team.Id) : NULL;
            
            if(team.User__c != null && team.Access__c == null){
                ClsTriggerFactory.prodQualErrorMsg = TRUE;
                team.Access__c.addError(System.label.CL00097); // CL00097 => Please select access level 
            }
            
            
            if(team.User__c == team.Account_Plan_Owner__c){
                ClsTriggerFactory.prodQualErrorMsg = TRUE;
                team.addError(System.label.CL00031); // CL00031=> Record Owner has access already.
            }

            if(team.User__c != null && adminUserIdSet.contains(team.User__c)){
                ClsTriggerFactory.prodQualErrorMsg = TRUE;
                team.addError(Label.System_CL00094); // System_CL00094 = > Cannot add System Administrator as a User 
            }   

            if( team.User__c == Userinfo.getUserid() && !trgCtx.isInsert){      
                ClsTriggerFactory.prodQualErrorMsg = TRUE;
                team.adderror(Label.System_CL00095);   //System_CL00095 => Cannot edit/delete yourself. Please contact Record owner or System Administrator. 
            }
            
            if(!adminUserIdSet.contains(Userinfo.getUserid()) && (team.Account_Plan_Status__c == Label.System_Account_Plan_Status_Closed_R5) ){   // System_Account_Plan_Status_Closed_R5  => Closed 
                ClsTriggerFactory.prodQualErrorMsg = TRUE;
                team.addError(Label.Cannot_Save_Changes_Account_Plan_R5);     //Cannot_Save_Changes_Account_Plan_R5 => You cannot save the changes as Account Plan Status is Closed.                                               
            }
            
            if(team.User__c != null) {
                if (accPlanAndUserIdSet.contains(String.valueOf(team.Account_Plan__c) + team.User__c )) {
                    ClsTriggerFactory.prodQualErrorMsg = TRUE;
                    team.addError(Label.Bus_Duplicate_Team_User_Err);     //Cannot add Duplicate Users                                              
                }
               
                accPlanAndUserIdSet.add(String.valueOf(team.Account_Plan__c) + team.User__c );
            }   
                 
            if (team.Account_Plan__c != NULL && team.Access__c != NULL && (trgCtx.IsInsert || trgCtx.IsDelete || (trgCtx.IsUpdate && 
                (oldteam.User__c != team.User__c || oldteam.Access__c != team.Access__c )))) {
                
                processList.add(team);
                 
                if (!trgCtx.IsUpdate) {
                    accountPlanIdset.add(team.Account_Plan__c);
                    userIdSet.add(team.User__c);
                }
                
                if (trgCtx.IsUpdate) {
                    accountPlanIdset.add(oldteam.Account_Plan__c);
                    userIdSet.add(oldteam.User__c);
                }
            }
        }
        
        if (accountPlanIdset.size() > 0 && userIdSet.size() > 0) {
            Integer limitRows = Limits.getLimitQueryRows() - Limits.getQueryRows();
            
            for (Account_Plan__Share share: [ SELECT Id,ParentId, UserOrGroupId FROM Account_Plan__Share WHERE ParentId IN: accountPlanIdset AND USerOrGroupID IN :userIDSet LIMIT :limitRows] ) {
                existingShareMap.put(String.valueOf(share.ParentId) + share.UserOrGroupId, share);
            }
        }
        
      
        for (Account_Plan_Team__c team: processList) {
            
           
            Account_Plan_Team__c oldteam =  (trgCtx.isUpdate) ? (Account_Plan_Team__c) trgCtx.oldMap.get(team.Id) : NULL;
            
            if ((trgCtx.isInsert || (trgCtx.IsUpdate && oldteam.User__c != team.User__c)) && existingShareMap.containsKey(String.valueOf(team.Account_Plan__c)+team.User__c)) {
                ClsTriggerFactory.prodQualErrorMsg = TRUE;
                team.addError(Label.Cannot_add_an_Existing_User_R5); //You cannot add an existing User to the Account Plan Team
               
            } else if (trgCtx.IsUpdate && oldteam.User__c == team.User__c && existingShareMap.containsKey(String.valueOf(team.Account_Plan__c)+team.User__c)) { //access level only changed
               
               
               Account_Plan__Share updateShare = existingShareMap.get(String.valueOf(team.Account_Plan__c)+team.User__c);
              
               if(team.Access__c == System.label.System_CL00037){  //System_CL00037 => Read/Write
                    updateShare.AccessLevel = System.label.System_CL00026;    //System_CL00025 => AccessLevel ,System_CL00026 => 'Edit'
               }  else {
                    updateShare.AccessLevel = System.label.Read_Access;    //'Read'
               } 
               
               tobeUpsertedList.add(updateShare);
            } else if (trgCtx.isInsert || trgCtx.IsUpdate) {
                
                Account_Plan__Share newShare = new Account_Plan__Share(ParentId = team.Account_Plan__c, UserOrGroupId = team.USer__c, RowCause = System.label.System_CL00028); //System_CL00027 => RowCause , System_CL00028 => 'Manual');
                
                if(team.Access__c == System.label.System_CL00037){  //System_CL00037 => Read/Write
                    newShare.AccessLevel = System.label.System_CL00026;    //System_CL00025 => AccessLevel ,System_CL00026 => 'Edit'
                } else {
                    newShare.AccessLevel = System.label.Read_Access;    //'Read'
                } 
                tobeUpsertedList.add(newShare);
            } 
            
            if (trgCtx.IsDelete && existingShareMap.containsKey(String.valueOf(team.Account_Plan__c)+team.User__c)) {
                tobeDeletedList.add(existingShareMap.get(String.valueOf(team.Account_Plan__c)+team.User__c));
            }
            
            if (trgCtx.IsUpdate && oldteam.User__c != team.User__c && existingShareMap.containsKey(String.valueOf(oldteam.Account_Plan__c)+oldteam.User__c)) {
                tobeDeletedList.add(existingShareMap.get(String.valueOf(oldteam.Account_Plan__c)+oldteam.User__c));
            }           
        }
        
        
        try {
            if (tobeDeletedList.size() > 0) delete tobeDeletedList;
            if (tobeUpsertedList.size() > 0) Upsert tobeUpsertedList;
            
        }Catch(DMLException de) {
            String error = '';
                
            for(Integer i=0;i<de.getNumDml();i++) {            
                error += de.getDmlMessage(i) +Label.Line_Break;
            }
            
            for (Account_Plan_Team__c team: processList) {
                team.addError(error, FALSE);
            }
        }
    }
}