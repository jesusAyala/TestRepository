/**
    @Author Shankaranarayanan V
    @name ClsTriggerVisitReportTeamMemberHandler
    @CreateDate 12/30/2015
    @Description Providing sharing permission to Visit Report Team object.
    @Version 1.0
    **/
public without sharing class ClsTriggerVisitReportTeamMemberHandler extends ClsTriggerVirtual {
    /**
     * @see IntHelper.beforeTrigger
    */
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
    try{
        visitReportTeamMembervalidation(trgCtx);
        visitReportTeamMemberDeletion(trgCtx);
        }catch(DMLException e){  string err = e.getmessage();}
    }    
    /**
     * @see IntHelper.afterTrigger
    */
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
    try{
        visitReportTeamMemberCreation(trgCtx);
        visitReportTeamMemberUpdate(trgCtx);
        }catch(DMLException e){  string err = e.getmessage();}
        
        if (trgCtx.isInsert) {
            copyInfoRecords(trgCtx);
        }
    }   
    
    
    
    public void copyInfoRecords(ClsWrappers.TriggerContext trgCtx) {
                
        List<Visit_Team_Info_Channel_Business_Review__c> insertList = new List<Visit_Team_Info_Channel_Business_Review__c>();
        for (Visit_Report_Team_Member__c  team: (List<Visit_Report_Team_Member__c>)trgCtx.newList) {            
   
            if (team.CBR_ID__c != '' && team.CBR_ID__c  != NULL) {
                
                insertList.add( new Visit_Team_Info_Channel_Business_Review__c(Visit_Report_Team_Member__c = team.ID, Channel_Partner_Business_Review__c = team.CBR_ID__c));
            }
        }   

        if (insertList.size() > 0) insert insertList;
    }
            
             
   /*  Description of the purpose of the method. 
    *  @name visitReportTeamMembervalidation
    *  @Description - Validation for Visit Report Team Member addition.
    *  @return Nothing - 
    */
    @TestVisible 
    private void visitReportTeamMembervalidation(ClsWrappers.TriggerContext trgCtx) {
    
        if (trgCtx.isInsert && trgCtx.isBefore && ClsTriggerFactory.isSkipRecursiveVisitReportTrigger) {
            Set<String> ParentIdAndUserIdSet = new Set<String>(); 
            Set<ID> teamids = new Set<ID>();
            Set<ID> userids = new Set<ID>();
            Map<Id,User> mapUser = new Map<Id,User>();
            
            for (sobject so : trgCtx.newList) {
                Visit_Report_Team_Member__c visitReportTeamMember = (Visit_Report_Team_Member__c)so;
                teamids.add(visitReportTeamMember.Visit_Report__c);
                userids.add(visitReportTeamMember.User__c);
                
                if(visitReportTeamMember.User__c != null) {
                    if (ParentIdAndUserIdSet.contains(String.valueOf(visitReportTeamMember.Visit_Report__c) + visitReportTeamMember.User__c )) {
                        ClsTriggerFactory.insertcheck = false;
                        visitReportTeamMember.addError(Label.Bus_Duplicate_Team_User_Err);     //Cannot add Duplicate Users                                              
                    }
                   
                    ParentIdAndUserIdSet.add(String.valueOf(visitReportTeamMember.Visit_Report__c) + visitReportTeamMember.User__c );
                }   
            }
            for(User objuser : [Select id,Profile.Name from User where id IN:userids 
            and Profile.Name =:System.label.System_CL00098 LIMIT 50000]){ //System_CL00098 => 'System Administrator'
                mapUser.put(objuser.id,objuser);
            }           
            List<Visit_Report__Share> lstDupCheckshare = [SELECT Id,UserOrGroupId,ParentId 
            FROM Visit_Report__Share WHERE ParentId IN :teamids AND RowCause =: System.label.System_CL00030 LIMIT 50000];  //System_CL00030=> 'Owner'  
            for (sobject so : trgCtx.newList) {
                Visit_Report_Team_Member__c visitReportTeamMember = (Visit_Report_Team_Member__c)so;
                if(mapUser.containsKey(visitReportTeamMember.User__c) && mapUser.get(visitReportTeamMember.User__c).Profile.Name.equals(System.label.System_CL00098)){ // CL00098 => System Administrator
                    ClsTriggerFactory.insertcheck = false;
                    visitReportTeamMember.User__c.addError(System.label.System_CL00094); //System_CL00094 => Cannot add System Administrator as a User 
                }
                for(Visit_Report__Share dupT : [SELECT Id,UserOrGroupId,ParentId 
            FROM Visit_Report__Share WHERE ParentId IN :teamids AND RowCause =: System.label.System_CL00030 LIMIT 50000]){
                    if(visitReportTeamMember.User__c == dupT.UserOrGroupId && visitReportTeamMember.Visit_Report__c == dupT.ParentId){
                        ClsTriggerFactory.insertcheck = false;
                        visitReportTeamMember.User__c.addError(System.label.CL00031);  // CL00031=> Record Owner has access already.
                    }
                }
            }           
            List<Visit_Report_Team_Member__c> lstDupCheck = [SELECT Id,Visit_Report__c,User__c,Team_Role__c 
            FROM Visit_Report_Team_Member__c WHERE Visit_Report__c IN: teamids LIMIT 50000];
            for (sobject so : trgCtx.newList) {
                Visit_Report_Team_Member__c visitReportTeamMember = (Visit_Report_Team_Member__c)so;
                for(Visit_Report_Team_Member__c dupT : [SELECT Id,Visit_Report__c,User__c,Team_Role__c 
            FROM Visit_Report_Team_Member__c WHERE Visit_Report__c IN: teamids LIMIT 50000]){                    
                    if(visitReportTeamMember.User__c == dupT.User__c && visitReportTeamMember.Visit_Report__c == dupT.Visit_Report__c){
                        ClsTriggerFactory.insertcheck = false;
                        visitReportTeamMember.User__c.addError(System.label.CL00099);   // CL00099=> You Cannot add an existing user.
                    }
                    if(visitReportTeamMember.User__c != null && visitReportTeamMember.Access_Level__c == null){
                        ClsTriggerFactory.insertcheck = false;
                        visitReportTeamMember.Access_Level__c.addError(System.label.CL00097); // CL00097 => Please select access level
                    }
                }
            }
            ClsTriggerFactory.isSkipRecursiveVisitReportTrigger = false;
        }   
    }
    /*  Description of the purpose of the method. 
    *  @name visitReportTeamMemberDeletion
    *  @Description - Remove the Visit Report record access while deleting the member.
    *  @return Nothing - 
    */
    @TestVisible 
    private void visitReportTeamMemberDeletion(ClsWrappers.TriggerContext trgCtx) {
        if(Trigger.isDelete && Trigger.isBefore){
            Set<ID> setVisitTeam = new Set<ID>();
            List<Visit_Report__Share> lstVisitTeamDelete = new List<Visit_Report__Share>();
            for(Visit_Report_Team_Member__c objVisitTeamMember : [Select id,Visit_Report__c from Visit_Report_Team_Member__c where id IN:trgCtx.oldMap.keySet() LIMIT 50000]){
                setVisitTeam.add(objVisitTeamMember.Visit_Report__c);
            }       
            List<Visit_Report__Share> sharesToDelete = [SELECT Id,UserOrGroupId,ParentId FROM Visit_Report__Share 
            WHERE ParentId IN :setVisitTeam AND RowCause =: System.label.System_CL00028 LIMIT 50000];   //System_CL00028 => 'Manual' 
            
            for (sobject so : trgCtx.oldList) {
                Visit_Report_Team_Member__c visitTeam = (Visit_Report_Team_Member__c)so;
                for(Visit_Report__Share objVT: [SELECT Id,UserOrGroupId,ParentId FROM Visit_Report__Share 
            WHERE ParentId IN :setVisitTeam AND RowCause =: System.label.System_CL00028 LIMIT 50000]){
                    if(visitTeam.User__c == objVT.UserOrGroupId && visitTeam.Visit_Report__c == objVT.ParentId){
                        lstvisitTeamDelete.add(objVT);
                    }
                }
            }
            try{
                if(lstvisitTeamDelete.size()>0){
                    Database.delete(lstvisitTeamDelete);
                }
            }
            catch(Exception e){String err=e.getMessage();} 
        }   
    }
    /*  Description of the purpose of the method. 
    *  @name visitReportTeamMemberUpdate
    *  @Description - Update the Visit Team permission while member is updated.
    *  @return Nothing - 
    */
    @TestVisible 
    private void visitReportTeamMemberUpdate(ClsWrappers.TriggerContext trgCtx) {
        if(Trigger.isUpdate && Trigger.isAfter){
            Set<ID> setvisitTeam = new Set<ID>();
            List<Visit_Report__Share> lstvisitTeamUpdate = new List<Visit_Report__Share>();
            List<Sobject> lstshare = new List<Sobject>();
            
            for (sobject so : trgCtx.newList) {
                Visit_Report_Team_Member__c visitTeam = (Visit_Report_Team_Member__c)so;
                setvisitTeam.add(visitTeam.Visit_Report__c);                   
            }
            List<Visit_Report__Share> sharesToUpdate = [SELECT Id,UserOrGroupId,ParentId,Accesslevel 
            FROM Visit_Report__Share WHERE ParentId IN :setvisitTeam AND RowCause =: System.label.System_CL00028 LIMIT 50000]; //System_CL00028 => 'Manual'   
            for (sobject so : trgCtx.newList) {
                Visit_Report_Team_Member__c visitTeam = (Visit_Report_Team_Member__c)so;
                for(Visit_Report__Share objVT: [SELECT Id,UserOrGroupId,ParentId,Accesslevel 
            FROM Visit_Report__Share WHERE ParentId IN :setvisitTeam AND RowCause =: System.label.System_CL00028 LIMIT 50000]){
                    if(visitTeam.User__c == objVT.UserOrGroupId && visitTeam.Visit_Report__c == objVT.ParentId){
                        if(visitTeam.Access_Level__c == System.label.System_CL00037){ //System_CL00037 => Read/Write
                            objVT.Accesslevel = System.label.System_CL00026;  //System_CL00026 => 'Edit'
                        }                           
                        lstvisitTeamUpdate.add(objVT);
                    }
                }
            }
            try{
            if(lstvisitTeamUpdate.size()>0){
                Database.update(lstvisitTeamUpdate);
            }
            }
            catch(Exception e){String err=e.getMessage();} 
        }
    }
    /* Description of the purpose of the method. 
    *  @name visitReportTeamMemberCreation
    *  @Description - Provide the Visit Report Team permission during member creation.
    *  @return Nothing - 
    */
    @TestVisible 
    private void visitReportTeamMemberCreation(ClsWrappers.TriggerContext trgCtx) {
        if(Trigger.isInsert && Trigger.isAfter){
            List<Visit_Report__Share> lstshare = new List<Visit_Report__Share>();            
            for (sobject so : trgCtx.newList) {
                Visit_Report_Team_Member__c visitTeam = (Visit_Report_Team_Member__c)so;
                Map<String, Schema.SObjectType> tokens = Schema.getGlobalDescribe();
                if(tokens.containsKey(System.label.Visit_Report_Share)) { 
                    Visit_Report__Share objVTS = new Visit_Report__Share();
                    objVTS.ParentId = visitTeam.Visit_Report__c;
                    objVTS.UserOrGroupId = visitTeam.User__c;
                    if(visitTeam.Access_Level__c == System.label.System_CL00037){  //System_CL00037 => Read/Write
                        objVTS.AccessLevel = System.label.System_CL00026;    //System_CL00025 => AccessLevel ,System_CL00026 => 'Edit'
                    }
                    else if(visitTeam.Access_Level__c == System.label.System_CL00035){  //System_CL0003 => Read Only
                        objVTS.AccessLevel = System.label.System_CL00036;    //System_CL00025 => AccessLevel ,System_CL00036 => 'Read'
                    }                                
                    objVTS.RowCause = System.label.System_CL00028; //System_CL00027 => RowCause , System_CL00028 => 'Manual'
                    lstshare.add(objVTS);
                } 
            }
            try{
            if(lstshare.size()>0){
                Database.insert(lstshare);
            }  
            }
            catch(Exception e){String err=e.getMessage();} 
                  
        }
    }  
}