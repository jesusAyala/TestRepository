/**
    @Author Aswini Arasu
    @name ClsTriggerRfpTeamHandler
    @CreateDate 02/05/2015
    @Description Providing sharing permission to Rfp Team object.
    @Version 1.0
    **/
public without sharing class ClsTriggerRfpTeamHandler extends ClsTriggerVirtual {
    /**
     * @see IntHelper.beforeTrigger
    */
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
        rfpTeamMemberValidation(trgCtx);
        rfpTeamMemberDeletion(trgCtx);
    }    
    /**
     * @see IntHelper.afterTrigger
    */
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
       rfpTeamMemberCreation(trgCtx);
       rfpTeamMemberUpdate(trgCtx);
    }    
   /*  Description of the purpose of the method. 
    *  @name rfpTeamMemberValidation
    *  @Description - Validation for RFP Team Member addition.
    *  @return Nothing - 
    */
    @TestVisible 
    private void rfpTeamMemberValidation(ClsWrappers.TriggerContext trgCtx) {
        if (trgCtx.isInsert && trgCtx.isBefore) {
            Set<ID> teamids = new Set<ID>();
            Set<ID> userids = new Set<ID>();
            Map<Id,User> mapUser = new Map<Id,User>();
            for (sobject so : trgCtx.newList) {
                RFP_Team__c rfpTeamMember = (RFP_Team__c)so;
                teamids.add(rfpTeamMember.RFP__c);
                userids.add(rfpTeamMember.User__c);
            }
            for(User objuser : [Select id,Profile.Name from User where id IN:userids 
            and Profile.Name =:System.label.System_CL00098 LIMIT 50000]){ //System_CL00098 => 'System Administrator'
                mapUser.put(objuser.id,objuser);
            }           
            List<RFP__Share> lstDupCheckshare = [SELECT Id,UserOrGroupId,ParentId 
            FROM RFP__Share WHERE ParentId IN :teamids AND RowCause =: System.label.System_CL00030 LIMIT 50000];  //System_CL00030=> 'Owner'  
            for (sobject so : trgCtx.newList) {
                RFP_Team__c rfpTeamMember = (RFP_Team__c)so;
                if(mapUser.containsKey(rfpTeamMember.User__c) && mapUser.get(rfpTeamMember.User__c).Profile.Name.equals(System.label.System_CL00098)){ // CL00098 => System Administrator
                    ClsTriggerFactory.insertcheck = false;
                    rfpTeamMember.User__c.addError(System.label.System_CL00094); //System_CL00094 => Cannot add System Administrator as a User 
                }
                for(RFP__Share dupT : [SELECT Id,UserOrGroupId,ParentId 
            FROM RFP__Share WHERE ParentId IN :teamids AND RowCause =: System.label.System_CL00030 LIMIT 50000]){
                    if(rfpTeamMember.User__c == dupT.UserOrGroupId && rfpTeamMember.RFP__c == dupT.ParentId){
                        ClsTriggerFactory.insertcheck = false;
                        rfpTeamMember.User__c.addError(System.label.CL00031);  // CL00031=> Record Owner has access already.
                    }
                }
            }           
            List<RFP_Team__c> lstDupCheck = [SELECT Id,RFP__c,User__c,Team_Role__c 
            FROM RFP_Team__c WHERE RFP__c IN: teamids LIMIT 50000];
            for (sobject so : trgCtx.newList) {
                RFP_Team__c rfpTeamMember = (RFP_Team__c)so;
                for(RFP_Team__c dupT : [SELECT Id,RFP__c,User__c,Team_Role__c 
            FROM RFP_Team__c WHERE RFP__c IN: teamids LIMIT 50000]){                    
                    if(rfpTeamMember.User__c == dupT.User__c && rfpTeamMember.RFP__c == dupT.RFP__c){
                        ClsTriggerFactory.insertcheck = false;
                        rfpTeamMember.User__c.addError(System.label.CL00099);   // CL00099=> You Cannot add an existing user.
                    }
                    if(rfpTeamMember.User__c != null && rfpTeamMember.Access_Level__c == null){
                        ClsTriggerFactory.insertcheck = false;
                        rfpTeamMember.Access_Level__c.addError(System.label.CL00097); // CL00097 => Please select access level
                    }
                }
            }
        }   
    }
    /*  Description of the purpose of the method. 
    *  @name rfpTeamMemberDeletion
    *  @Description - Remove the RFP record access while deleting the member.
    *  @return Nothing - 
    */
    @TestVisible 
    private void rfpTeamMemberDeletion(ClsWrappers.TriggerContext trgCtx) {
        if(Trigger.isDelete && Trigger.isBefore){
            Set<ID> setRfpTeam = new Set<ID>();
            List<RFP__Share> lstRfpTeamDelete = new List<RFP__Share>();
            for(RFP_Team__c objRfpTeamMember : [Select id,RFP__c from RFP_Team__c where id IN:trgCtx.oldMap.keySet() LIMIT 50000]){
                setRfpTeam.add(objRfpTeamMember.RFP__c);
            }       
            List<RFP__Share> sharesToDelete = [SELECT Id,UserOrGroupId,ParentId FROM RFP__Share 
            WHERE ParentId IN :setRfpTeam AND RowCause =: System.label.System_CL00028 LIMIT 50000];   //System_CL00028 => 'Manual' 
            
            for (sobject so : trgCtx.oldList) {
                RFP_Team__c rfpTeam = (RFP_Team__c)so;
                for(RFP__Share objRFP: [SELECT Id,UserOrGroupId,ParentId FROM RFP__Share 
            WHERE ParentId IN :setRfpTeam AND RowCause =: System.label.System_CL00028 LIMIT 50000]){
                    if(rfpTeam.User__c == objRFP.UserOrGroupId && rfpTeam.RFP__c == objRFP.ParentId){
                        lstRfpTeamDelete.add(objRFP);
                    }
                }
            }
            if(lstRfpTeamDelete.size()>0){
                Database.delete(lstRfpTeamDelete);
            }
        }   
    }
    /*  Description of the purpose of the method. 
    *  @name rfpTeamMemberUpdate
    *  @Description - Update the RFP Team permission while member is updated.
    *  @return Nothing - 
    */
    @TestVisible 
    private void rfpTeamMemberUpdate(ClsWrappers.TriggerContext trgCtx) {
        if(Trigger.isUpdate && Trigger.isAfter){
            Set<ID> setRfpTeam = new Set<ID>();
            List<RFP__Share> lstrfpTeamUpdate = new List<RFP__Share>();
            List<Sobject> lstshare = new List<Sobject>();
            
            for (sobject so : trgCtx.newList) {
                RFP_Team__c rfpTeam = (RFP_Team__c)so;
                setRfpTeam.add(rfpTeam.RFP__c);                   
            }
            List<RFP__Share> sharesToUpdate = [SELECT Id,UserOrGroupId,ParentId,Accesslevel 
            FROM RFP__Share WHERE ParentId IN :setRfpTeam AND RowCause =: System.label.System_CL00028 LIMIT 50000]; //System_CL00028 => 'Manual'   
            for (sobject so : trgCtx.newList) {
                RFP_Team__c rfpTeam = (RFP_Team__c)so;
                for(RFP__Share objRFP: [SELECT Id,UserOrGroupId,ParentId,Accesslevel 
            FROM RFP__Share WHERE ParentId IN :setRfpTeam AND RowCause =: System.label.System_CL00028 LIMIT 50000]){
                    if(rfpTeam.User__c == objRFP.UserOrGroupId && rfpTeam.RFP__c == objRFP.ParentId){
                        if(rfpTeam.Access_Level__c == System.label.System_CL00037){ //System_CL00037 => Read/Write
                            objRFP.Accesslevel = System.label.System_CL00026;  //System_CL00026 => 'Edit'
                        }
                        if(rfpTeam.Access_Level__c == System.label.System_CL00035){ //System_CL00035 => Read Only
                            objRFP.Accesslevel = System.label.System_CL00036;  //System_CL00036 => Read
                        }                           
                        lstrfpTeamUpdate.add(objRFP);
                    }
                }
            }
            try{
                if(lstrfpTeamUpdate.size()>0){
                    Database.update(lstrfpTeamUpdate);
                }
            }
            catch(Exception e)
            {
                string err = e.getmessage();
            } 
    }
    }
    /* Description of the purpose of the method. 
    *  @namerfpTeamMemberCreation
    *  @Description - Provide the RFP Team permission during member creation.
    *  @return Nothing - 
    */
    @TestVisible 
    private void rfpTeamMemberCreation(ClsWrappers.TriggerContext trgCtx) {
        if(Trigger.isInsert && Trigger.isAfter){
            List<RFP__Share> lstshare = new List<RFP__Share>();  
                      
            for (sobject so : trgCtx.newList) {
            
                RFP_Team__c rfpTeam = (RFP_Team__c)so;
                system.debug('XXXXXXXXXX'+rfpTeam);
                Map<String, Schema.SObjectType> tokens = Schema.getGlobalDescribe();
                if(tokens.containsKey(System.label.Rfp_Share)) { 
                    RFP__Share objRFPS = new RFP__Share();
                    objRFPS.ParentId = rfpTeam.RFP__c;
                    objRFPS.UserOrGroupId = rfpTeam.User__c;
                    if(rfpTeam.Access_Level__c == System.label.System_CL00026 || rfpTeam.Access_Level__c == System.label.System_CL00037){  //System_CL00037 => Read/Write 
                        system.debug('0000000000000');
                        objRFPS.AccessLevel = System.label.System_CL00026;    //System_CL00025 => AccessLevel ,//System_CL00026 => Edit
                    }
                    if(rfpTeam.Access_Level__c == System.label.System_CL00036 || rfpTeam.Access_Level__c == System.label.System_CL00035){ //System_CL00035 => Read Only
                        objRFPS.Accesslevel = System.label.System_CL00036;  //System_CL00036 => Read
                    }                  
                    objRFPS.RowCause = System.label.System_CL00028; //System_CL00027 => RowCause , System_CL00028 => 'Manual'
                    lstshare.add(objRFPS);
                } 
            }
            try{
                if(lstshare.size()>0){
                    Database.insert(lstshare);
                }   
            }
            catch(Exception e){string err = e.getmessage();}           
        }
    }  
    }