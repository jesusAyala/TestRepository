/**
 * TriggerClass -  To share the Channel Pre Qualification
 * Release R5
 * @author  Vasanthi M(Accenture)
 * @created 2016-03-02
 * @version 1.0
 * Created
 
  Purpose: To share the Channel Pre Qualification
 
*/
  public without sharing class ClsTriggerChannelQualificationTeam extends ClsTriggerVirtual {
    
    Set<Id> adminUserIdSet = new Set<Id>();
    
    /**
     * constructor
    */
    public ClsTriggerChannelQualificationTeam() {
        
        Map<Id, User> adminUserMap = new Map<Id, User> ([ SELECT Id, Name FROM User WHERE Profile.Name =: Label.Sys_Admin_Profile_Name AND IsActive = TRUE LIMIT 50000]);
        adminUserIdSet.addAll(adminUserMap.KeySet());
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
         
         for (Channel_Pre_Qualification_Team__c con : (List<Channel_Pre_Qualification_Team__c>) trgCtx.oldList) {             
             if (!adminUserIdSet.contains(UserInfo.getUSerId())  && con.Channel_Qualification_Status__c  == Label.Closed ) {
                 con.addError(Label.Business_Channel_Qualification_Err); //You cannot save the changes - Channel Partner Pre Qualification is Closed.
             }
         }        
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
        
        List<Channel_Pre_Qualification_Team__c> qualList = (trgCtx.IsDelete) ? trgCtx.OldList : trgCtx.newList;
        
        List<Channel_Pre_Qualification_Team__c> processList = new List<Channel_Pre_Qualification_Team__c>();
        List<Channel_Qualifications__Share> tobeInsertedList = new List<Channel_Qualifications__Share>();
        List<Channel_Qualifications__Share> tobeDeletedList = new List<Channel_Qualifications__Share>();
        Map<String, Channel_Qualifications__Share> existingShareMap = new Map<String, Channel_Qualifications__Share>();
        Set<Id> qualIdSet = new Set<Id>();
        Set<Id> userIdSet = new Set<Id>();
        Set<String> ParentIdAndUserIdSet = new Set<String>();
        
        for (Channel_Pre_Qualification_Team__c channel: qualList) {
            
            Channel_Pre_Qualification_Team__c oldChannel =  (trgCtx.isUpdate) ? (Channel_Pre_Qualification_Team__c) trgCtx.oldMap.get(channel.Id) : NULL;
            if (channel.Channel_Pre_Qualification__c != NULL && channel.Access__c != NULL && (trgCtx.IsInsert || trgCtx.IsDelete || (trgCtx.IsUpdate && oldChannel.User__c != channel.User__c))) {
                processList.add(channel);
                 
                 
                if (!trgCtx.IsUpdate) {
                    qualIdSet.add(channel.Channel_Pre_Qualification__c);
                    userIdSet.add(channel.User__c);
                }
                if (trgCtx.IsUpdate) {
                    qualIdSet.add(oldChannel.Channel_Pre_Qualification__c);
                    userIdSet.add(oldChannel.User__c);
                }
                
                if(channel.User__c == channel.Channel_Qualification_OwnerID__c){
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
                    if (ParentIdAndUserIdSet.contains(String.valueOf(channel.Channel_Pre_Qualification__c) + channel.User__c )) {
                        ClsTriggerFactory.prodQualErrorMsg = TRUE;
                        channel.addError(Label.Bus_Duplicate_Team_User_Err);     //Cannot add Duplicate Users                                              
                    }
                    
                    ParentIdAndUserIdSet.add(String.valueOf(channel.Channel_Pre_Qualification__c) + channel.User__c );
                }   
            }
        }
        
        if (qualIdSet.size() > 0 && userIdSet.size() > 0) {
            Integer limitRows = Limits.getLimitQueryRows() - Limits.getQueryRows();
            
            for (Channel_Qualifications__Share share: [ SELECT Id,ParentId, UserOrGroupId FROM Channel_Qualifications__Share WHERE ParentId IN: qualIdSet AND USerOrGroupID IN :userIDSet LIMIT :limitRows] ) {
                existingShareMap.put(String.valueOf(share.ParentId) + share.UserOrGroupId, share);
            }
        }
        
      
        for (Channel_Pre_Qualification_Team__c channel: processList) {
            
            Channel_Pre_Qualification_Team__c oldChannel =  (trgCtx.isUpdate) ? (Channel_Pre_Qualification_Team__c) trgCtx.oldMap.get(channel.Id) : NULL;
            
            if ((trgCtx.isInsert || trgCtx.IsUpdate) && existingShareMap.containsKey(String.valueOf(channel.Channel_Pre_Qualification__c)+channel.User__c)) {
                channel.addError(Label.CL00032); //You cannot add an existing User to the Qualification Team
            } else if (trgCtx.isInsert || trgCtx.IsUpdate) {
                 Channel_Qualifications__Share newShare = new Channel_Qualifications__Share(ParentId = channel.Channel_Pre_Qualification__c, USerOrGroupId = channel.USer__c, RowCause = System.label.System_CL00028); //System_CL00027 => RowCause , System_CL00028 => 'Manual');
                if(channel.Access__c == System.label.System_CL00037){  //System_CL00037 => Read/Write
                    newShare.AccessLevel = System.label.System_CL00026;    //System_CL00025 => AccessLevel ,System_CL00026 => 'Edit'
                }
                tobeInsertedList.add(newShare);
            } 
            
            if (trgCtx.IsDelete && existingShareMap.containsKey(String.valueOf(channel.Channel_Pre_Qualification__c)+channel.User__c)) {
                tobeDeletedList.add(existingShareMap.get(String.valueOf(channel.Channel_Pre_Qualification__c)+channel.User__c));
            }
            
            if (trgCtx.IsUpdate && existingShareMap.containsKey(String.valueOf(oldChannel.Channel_Pre_Qualification__c)+oldChannel.User__c)) {
                tobeDeletedList.add(existingShareMap.get(String.valueOf(oldChannel.Channel_Pre_Qualification__c)+oldChannel.User__c));
            }
        }
        
        
        try {
            if (tobeDeletedList.size() > 0) Database.Delete(tobeDeletedList);
            if (tobeInsertedList.size() > 0) Database.Insert(tobeInsertedList);
            
        }Catch(DMLException de) {
            String error = '';
                
            for(Integer i=0;i<de.getNumDml();i++) {            
                error += de.getDmlMessage(i) +Label.Line_Break;
            }
            
            for (Channel_Pre_Qualification_Team__c channel: processList) {
                channel.addError(error, FALSE);
            }
        }
    }
}