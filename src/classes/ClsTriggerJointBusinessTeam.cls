/**
 * TriggerClass -  To share the Channel Partner Business Plan
 * Release R5
 * @author  Vasanthi M(Accenture)
 * @created 2016-03-08
 * @version 1.0
 * Created
 
  Purpose: To share the Channel Partner Business Plan
 
  */
  public without sharing class ClsTriggerJointBusinessTeam extends ClsTriggerVirtual {
    
    
    Set<Id> adminUserIdSet = new Set<Id>();
    
    /**
     * constructor
    */
    public ClsTriggerJointBusinessTeam() {
        
        Map<Id, User> adminUserMap = new Map<Id, User> ([ SELECT Id, Name FROM User WHERE Profile.Name =: Label.Sys_Admin_Profile_Name AND IsActive = TRUE LIMIT 50000]);
        adminUserIdSet.addAll(adminUserMap.KeySet());
    }   
    
        
    /**
     * @see IntHelper.afterTrigger
    */
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
        createOrRemoveShare(trgCtx);
    }
    
    /**
     * @see IntHelper.beforeTrigger
    */
     public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {               
       
        if (trgCtx.IsDelete) {
            deleteValidation(trgCtx);
        }                   
    }
    
    
        /**
    To prevent deletion when the account plan status is closed
    */
     Public void deleteValidation(ClsWrappers.TriggerContext trgCtx){
         
         for (Joint_Business_Team__c con : (List<Joint_Business_Team__c>) trgCtx.oldList) {             
             if (!adminUserIdSet.contains(UserInfo.getUSerId()) && con.Channel_Partner_Business_Plan_Status__c == Label.Closed ) {
                 con.addError(Label.Business_Visit_Report_Business_Plan_Error); //You cannot save the changes - Channel Partner Business Plan is Closed/Obsolete.
             }
         }        
     }
/**    
 * To grant/revoke access
*/ 
    public void createOrRemoveShare(ClsWrappers.TriggerContext trgCtx) {
        
        List<Joint_Business_Team__c> qualList = (trgCtx.IsDelete) ? trgCtx.OldList : trgCtx.newList;
        
        List<Joint_Business_Team__c> processList = new List<Joint_Business_Team__c>();
        List<Joint_Business_Plan__Share> tobeInsertedList = new List<Joint_Business_Plan__Share>();
        List<Joint_Business_Plan__Share> tobeDeletedList = new List<Joint_Business_Plan__Share>();
        Map<String, Joint_Business_Plan__Share> existingShareMap = new Map<String, Joint_Business_Plan__Share>();
        Set<Id> businessPlanIdSet = new Set<Id>();
        Set<Id> userIdSet = new Set<Id>();
        Set<String> ParentIdAndUserIdSet = new Set<String>(); 
        
        for (Joint_Business_Team__c channel: qualList) {
            
            Joint_Business_Team__c oldChannel =  (trgCtx.isUpdate) ? (Joint_Business_Team__c) trgCtx.oldMap.get(channel.Id) : NULL;
            if (channel.Joint_Business_Plan__c!= NULL && channel.Access__c != NULL && (trgCtx.IsInsert || trgCtx.IsDelete || (trgCtx.IsUpdate && 
                (oldChannel.User__c != channel.User__c || oldChannel.Access__c != channel.Access__c )))) {
                
                processList.add(channel);
                 
                if (!trgCtx.IsUpdate) {
                    businessPlanIdSet.add(channel.Joint_Business_Plan__c);
                    userIdSet.add(channel.User__c);
                }
                if (trgCtx.IsUpdate) {
                    businessPlanIdSet.add(oldChannel.Joint_Business_Plan__c);
                    userIdSet.add(oldChannel.User__c);
                }
                  
                if(channel.User__c == channel.Channel_Business_Plan_OwnerID__c){
                    ClsTriggerFactory.prodQualErrorMsg = TRUE;
                    channel.addError(System.label.CL00031); // CL00031=> Record Owner has access already.
                }
                
                if (!trgCtx.IsDelete) {
                    if(channel.User__c != null && adminUserIdSet.contains(channel.User__c)){
                        ClsTriggerFactory.prodQualErrorMsg = TRUE;
                        channel.addError(Label.System_CL00094); // System_CL00094 = > Cannot add System Administrator as a User 
                    }   
                }
                
                if( channel.User__c == Userinfo.getUserid() && !trgCtx.isInsert){    
                    ClsTriggerFactory.prodQualErrorMsg = TRUE;
                    channel.adderror(Label.System_CL00095);   //System_CL00095 => Cannot edit/delete yourself. Please contact Record owner or System Administrator. 
                }
                
                if(channel.User__c != null) {
                    if (ParentIdAndUserIdSet.contains(String.valueOf(channel.Joint_Business_Plan__c) + channel.User__c )) {
                        ClsTriggerFactory.prodQualErrorMsg = TRUE;
                        channel.addError(Label.Bus_Duplicate_Team_User_Err);     //Cannot add Duplicate Users                                              
                    }
                   
                    ParentIdAndUserIdSet.add(String.valueOf(channel.Joint_Business_Plan__c) + channel.User__c );
                }  
            }
        }
        
        if (businessPlanIdSet.size() > 0 && userIdSet.size() > 0) {
            Integer limitRows = Limits.getLimitQueryRows() - Limits.getQueryRows();
            
            for (Joint_Business_Plan__Share share: [ SELECT Id,ParentId, UserOrGroupId FROM Joint_Business_Plan__Share WHERE ParentId IN: businessPlanIdSet AND USerOrGroupID IN :userIDSet LIMIT :limitRows] ) {
                existingShareMap.put(String.valueOf(share.ParentId) + share.UserOrGroupId, share);
            }
        }
        
      
        for (Joint_Business_Team__c channel: processList) {
            
            Joint_Business_Team__c oldChannel =  (trgCtx.isUpdate) ? (Joint_Business_Team__c) trgCtx.oldMap.get(channel.Id) : NULL;
            
            if ((trgCtx.isInsert || (trgCtx.IsUpdate && oldChannel.User__c != channel.User__c)) && existingShareMap.containsKey(String.valueOf(channel.Joint_Business_Plan__c)+channel.User__c)) {
                channel.addError(Label.CL00032); //You cannot add an existing User to the Qualification Team
            } else if (trgCtx.IsUpdate && oldChannel.User__c == channel.User__c && existingShareMap.containsKey(String.valueOf(channel.Joint_Business_Plan__c)+channel.User__c)) { //access level only changed
               
               
               Joint_Business_Plan__Share updateShare = existingShareMap.get(String.valueOf(channel.Joint_Business_Plan__c)+channel.User__c);
              
               if(channel.Access__c == System.label.System_CL00037){  //System_CL00037 => Read/Write
                    updateShare.AccessLevel = System.label.System_CL00026;    //System_CL00025 => AccessLevel ,System_CL00026 => 'Edit'
               } 
               
               if(channel.Access__c == System.label.System_CL00110){  //System_CL00110=> Read-Only
                    updateShare.AccessLevel = System.label.Read_Access;    //'Read'
               } 
               
               tobeInsertedList.add(updateShare);
            }else if (trgCtx.isInsert || trgCtx.IsUpdate) {
                Joint_Business_Plan__Share newShare = new Joint_Business_Plan__Share(ParentId = channel.Joint_Business_Plan__c, USerOrGroupId = channel.USer__c, RowCause = System.label.System_CL00028); //System_CL00027 => RowCause , System_CL00028 => 'Manual');
                if(channel.Access__c == System.label.System_CL00037){  //System_CL00037 => Read/Write
                    newShare.AccessLevel = System.label.System_CL00026;    //System_CL00025 => AccessLevel ,System_CL00026 => 'Edit'
                }
                if(channel.Access__c == System.label.System_CL00110){  //System_CL00110=> Read-Only
                    newShare.AccessLevel = System.label.Read_Access;    //'Read'
                } 
                tobeInsertedList.add(newShare);
            } 
            
            if (trgCtx.IsDelete && existingShareMap.containsKey(String.valueOf(channel.Joint_Business_Plan__c)+channel.User__c)) {
                tobeDeletedList.add(existingShareMap.get(String.valueOf(channel.Joint_Business_Plan__c)+channel.User__c));
            }
            
            if (trgCtx.IsUpdate && oldChannel.User__c != channel.User__c && existingShareMap.containsKey(String.valueOf(oldChannel.Joint_Business_Plan__c)+oldChannel.User__c)) {
                tobeDeletedList.add(existingShareMap.get(String.valueOf(oldChannel.Joint_Business_Plan__c)+oldChannel.User__c));
            }
        }
        
        
        try {
            if (tobeDeletedList.size() > 0) Database.Delete(tobeDeletedList);
            if (tobeInsertedList.size() > 0) Database.Upsert(tobeInsertedList);
            
        }Catch(DMLException de) {
            String error = '';
                
            for(Integer i=0;i<de.getNumDml();i++) {            
                error += de.getDmlMessage(i) +Label.Line_Break;
            }
            
            for (Joint_Business_Team__c channel: processList) {
                channel.addError(error, FALSE);
            }
        }
    }
}