/**
    @Author Rajesh K
    @name ClsTriggerCaptureTeamMemberHandler
    @CreateDate 9/14/2015
    @Description Providing sharing permission to End user project and Capture Team objects.
    @Version 1.0
    **/
public without sharing class ClsTriggerCaptureTeamMemberHandler extends ClsTriggerVirtual {
    /**
     * @see IntHelper.beforeTrigger
    */
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
        captureTeamMembervalidation(trgCtx);
        captureTeamMemberDeletion(trgCtx);
    }    
    /**
     * @see IntHelper.afterTrigger
    */
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
        captureTeamMemberCreation(trgCtx);
        captureTeamMemberUpdation(trgCtx);
    }    
   /*  Description of the purpose of the method. 
    *  @name captureTeamMembervalidation
    *  @Description - Validation for Capture Team member addition.
    *  @return Nothing - 
    */
    @TestVisible 
    private void captureTeamMembervalidation(ClsWrappers.TriggerContext trgCtx) {
        if (trgCtx.isInsert && trgCtx.isBefore) {
            Set<ID> teamids = new Set<ID>();
            Set<ID> userids = new Set<ID>();
            Map<Id,User> mapUser = new Map<Id,User>();
            for (sobject so : trgCtx.newList) {
                Capture_Team_Member__c ctm = (Capture_Team_Member__c)so;
                teamids.add(ctm.Capture_Team__c);
                userids.add(ctm.User__c);
            }
            for(User objuser : [Select id,Profile.Name from User where id IN:userids 
            and Profile.Name =:System.label.System_CL00098 LIMIT 50000]){
                mapUser.put(objuser.id,objuser);
            }           
            List<Capture_Team__Share> lstDupCheckshare = [SELECT Id,UserOrGroupId,ParentId 
            FROM Capture_Team__Share WHERE ParentId IN :teamids AND RowCause =: System.label.System_CL00030];  //System_CL00030=> 'Owner'  
            for (sobject so : trgCtx.newList) {
                Capture_Team_Member__c ctm = (Capture_Team_Member__c)so;
                if(mapUser.containsKey(ctm.User__c) && mapUser.get(ctm.User__c).Profile.Name.equals(System.label.System_CL00098)){ // CL00098 => System Administrator
                    ClsTriggerFactory.insertcheck = false;
                    ctm.User__c.addError(System.label.System_CL00094); //System_CL00094 => Cannot add System Administrator as a User 
                }
                for(Capture_Team__Share dupT : lstDupCheckshare){
                    if(ctm.User__c == dupT.UserOrGroupId && ctm.Capture_Team__c == dupT.ParentId){
                        ClsTriggerFactory.insertcheck = false;
                        ctm.User__c.addError(System.label.CL00031);  // CL00031=> Record Owner has access already.
                    }
                }
            }           
            List<Capture_Team_Member__c> lstDupCheck = [SELECT Id,Capture_Team__c,User__c,Team_Role__c 
            FROM Capture_Team_Member__c WHERE Capture_Team__c IN: teamids];
            for (sobject so : trgCtx.newList) {
                Capture_Team_Member__c ctm = (Capture_Team_Member__c)so;
                for(Capture_Team_Member__c dupT : lstDupCheck){                    
                    if(ctm.User__c == dupT.User__c && ctm.Capture_Team__c == dupT.Capture_Team__c){
                        ClsTriggerFactory.insertcheck = false;
                        ctm.User__c.addError(System.label.CL00099);   // CL00099=> You Cannot add an existing user.
                    }
                    if(ctm.Team_Role__c == dupT.Team_Role__c && ctm.Capture_Team__c == dupT.Capture_Team__c && ctm.Team_Role__c == System.label.System_CL00034){ //System_CL00034 => Capture Team Leader
                        ClsTriggerFactory.insertcheck = false;
                        ctm.Team_Role__c.addError(System.label.CL00033);  // CL00033=> Capture Team Leader Role already exist.
                    }
                    if(ctm.User__c != null && ctm.Access_Level__c == null){
                        ClsTriggerFactory.insertcheck = false;
                        ctm.Access_Level__c.addError(System.label.CL00097); // CL00097 => Please select access level
                    }
                }
            }
        }   
    }
    /*  Description of the purpose of the method. 
    *  @name captureTeamMemberDeletion
    *  @Description - Remove the Capture Team permission while delete member.
    *  @return Nothing - 
    */
    @TestVisible 
    private void captureTeamMemberDeletion(ClsWrappers.TriggerContext trgCtx) {
        if(Trigger.isDelete && Trigger.isBefore){
            Set<ID> setCapTeam = new Set<ID>();
            List<Capture_Team__Share> lstcaptureTeamDelete = new List<Capture_Team__Share>();
            for(Capture_Team_Member__c objCapTeamMember : [Select id,Capture_Team__c from Capture_Team_Member__c where id IN:trgCtx.oldMap.keySet()]){
                setCapTeam.add(objCapTeamMember.Capture_Team__c);
            }       
            List<Capture_Team__Share> sharesToDelete = [SELECT Id,UserOrGroupId,ParentId FROM Capture_Team__Share 
            WHERE ParentId IN :setCapTeam AND RowCause =: System.label.System_CL00028];   //System_CL00028 => 'Manual' 
            
            for (sobject so : trgCtx.oldList) {
                Capture_Team_Member__c capT = (Capture_Team_Member__c)so;
                for(Capture_Team__Share objCT: sharesToDelete){
                    if(capT.User__c == objCT.UserOrGroupId && capT.Capture_Team__c == objCT.ParentId){
                        lstcaptureTeamDelete.add(objCT);
                    }
                }
            }
            if(lstcaptureTeamDelete.size()>0){
                Database.delete(lstcaptureTeamDelete);
            }
        }   
    }
    /*  Description of the purpose of the method. 
    *  @name captureTeamMemberUpdation
    *  @Description - Update the Capture Team permission while Update member.
    *  @return Nothing - 
    */
    @TestVisible 
    private void captureTeamMemberUpdation(ClsWrappers.TriggerContext trgCtx) {
        if(Trigger.isUpdate && Trigger.isAfter){
            //ID captureTeamId;
            //ID ctLeader = null;
            Set<ID> setCapTeam = new Set<ID>();
            List<Capture_Team__Share> lstcaptureTeamUpdate = new List<Capture_Team__Share>();
            List<Sobject> lstshare = new List<Sobject>();
            
            for (sobject so : trgCtx.newList) {
                Capture_Team_Member__c capT = (Capture_Team_Member__c)so;
                setCapTeam.add(capT.Capture_Team__c);                   
            }
            List<Capture_Team__Share> sharesToUpdate = [SELECT Id,UserOrGroupId,ParentId,Accesslevel 
            FROM Capture_Team__Share WHERE ParentId IN :setCapTeam AND RowCause =: System.label.System_CL00028]; //System_CL00028 => 'Manual'   
            for (sobject so : trgCtx.newList) {
                Capture_Team_Member__c capT = (Capture_Team_Member__c)so;
                for(Capture_Team__Share objCT: sharesToUpdate){
                    if(capT.User__c == objCT.UserOrGroupId && capT.Capture_Team__c == objCT.ParentId){
                        /*if(((Capture_Team_Member__c)trgCtx.oldMap.get(capT.Id)).Team_Role__c != capT.Team_Role__c && capT.Team_Role__c == 'Capture Team Leader'){
                            ctLeader = capT.User__c;
                            captureTeamId = capT.Capture_Team__c;
                        }*/
                        if(capT.Access_Level__c == System.label.System_CL00035){  //System_CL00035 => Read Only
                            objCT.Accesslevel = System.label.System_CL00036;   //System_CL00036 => Read
                        }
                        else if(capT.Access_Level__c == System.label.System_CL00037){ //System_CL00037 => Read/Write
                            objCT.Accesslevel = System.label.System_CL00026;  //System_CL00026 => 'Edit'
                        }                           
                        lstcaptureTeamUpdate.add(objCT);
                    }
                }
            }
            if(lstcaptureTeamUpdate.size()>0){
                Database.update(lstcaptureTeamUpdate);
            }
           /* if(ctLeader!=null){
                List<End_User_Project__c> lstupdEndUserProj = new List<End_User_Project__c>();
                List<Capture_Team__c> lstcaptureteam = [Select id,End_User_Project__c from Capture_Team__c where id =: captureTeamId]; 
                if(lstcaptureteam.size()>0){
                    lstupdEndUserProj.add(new End_User_Project__c(id = lstcaptureteam[0].End_User_Project__c,CT_Leader__c = Id.valueof(ctLeader)));
                }
                if(lstupdEndUserProj.size()>0){
                    Database.update(lstupdEndUserProj);
                }
            }*/                
        }
    }
    /*  Description of the purpose of the method. 
    *  @name captureTeamMemberCreation
    *  @Description - Provide the Capture Team permission while create member.
    *  @return Nothing - 
    */
    @TestVisible 
    private void captureTeamMemberCreation(ClsWrappers.TriggerContext trgCtx) {
        if(Trigger.isInsert && Trigger.isAfter){
            //ID captureTeamId;
            //ID ctLeader = null;
            List<Capture_Team__Share> lstshare = new List<Capture_Team__Share>();            
            for (sobject so : trgCtx.newList) {
                Capture_Team_Member__c capT = (Capture_Team_Member__c)so;
                Map<String, Schema.SObjectType> tokens = Schema.getGlobalDescribe();
                if(tokens.containsKey('Capture_Team__Share')) { 
                    Capture_Team__Share objCTS = new Capture_Team__Share();
                    objCTS.ParentId = capT.Capture_Team__c;
                    objCTS.UserOrGroupId = capT.User__c;
                    if(capT.Access_Level__c == System.label.System_CL00035){   //System_CL00035 => Read Only
                        objCTS.AccessLevel = System.label.System_CL00036;   //System_CL00025 => AccessLevel, System_CL00036 => Read
                    }
                    else if(capT.Access_Level__c == System.label.System_CL00037){  //System_CL00037 => Read/Write
                        objCTS.AccessLevel = System.label.System_CL00026;    //System_CL00025 => AccessLevel ,System_CL00026 => 'Edit'
                    }                 
                    objCTS.RowCause = System.label.System_CL00028; //System_CL00027 => RowCause , System_CL00028 => 'Manual'
                    /*captureTeamId = capT.Capture_Team__c;
                    if(capT.Team_Role__c == 'Capture Team Leader'){
                        ctLeader = capT.User__c;
                    }*/
                    lstshare.add(objCTS);
                } 
            }
            if(lstshare.size()>0){
                Database.insert(lstshare);
            }
            /*if(ctLeader!=null){
                List<End_User_Project__c> lstupdEndUserProj = new List<End_User_Project__c>();
                List<Capture_Team__c> lstcaptureteam = [Select id,End_User_Project__c from Capture_Team__c where id =: captureTeamId]; 
                if(lstcaptureteam.size()>0){
                    lstupdEndUserProj.add(new End_User_Project__c(id = lstcaptureteam[0].End_User_Project__c,CT_Leader__c = Id.valueof(ctLeader)));
                }
                if(lstupdEndUserProj.size()>0){
                    Database.update(lstupdEndUserProj);
                }
            }*/                
        }
    }  
}