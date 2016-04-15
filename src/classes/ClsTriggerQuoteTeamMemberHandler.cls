/**   
* TriggerClass on the Quote Team Member object to sync the Quote Team Members with Opportunity Team Members
*       
* Release - R5 
 *  
 * @author  - Vasanthi (Accenture)
 * @created - 2016-1-05
 * @version - 1.0
 * @Description - To sync Quote Team Member with Opportunity Team Member as per Req#2503
    For CQP and APttus team member with Role 'Quote Manager' or 'Quote Support': 
    When user deleting or updating Quote Team Member, we have to delete the existing Opportunity Team Member only if the Team Role has matched
 
* - Created
*/
public without sharing class ClsTriggerQuoteTeamMemberHandler extends ClsTriggerVirtual {
    
    List<OpportunityTeamMember> upsertOpportunityTeamMembers;
    List<OpportunityTeamMember> deleteOpportunityTeamMembers;
    Map<String, String> oppIdWithUserIdAndAccessLevel;
    Public String apttusRTId = '';
    Public String cqpRTId = '';
    Public Set<String> quoteTeamRoles = new Set<String>();
    public Static Boolean noNeedToFireAfterInsertQTM = FALSE;
 /*   
    *  @name ClsTriggerQuoteTeamMemberHandler
*/ 
    public ClsTriggerQuoteTeamMemberHandler () {
    
        upsertOpportunityTeamMembers = new List<OpportunityTeamMember>();
        deleteOpportunityTeamMembers = new List<OpportunityTeamMember>();
        oppIdWithUserIdAndAccessLevel = new Map<String, String>();
       
        try{
        if (system.label.System_CL00106 != '') {
            cqpRTId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(system.label.System_CL00106).getRecordTypeId(); 
        }
        
        if (system.label.System_CL00107 != '') {
            apttusRTId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(system.label.System_CL00107).getRecordTypeId(); 
        }
        
        if (system.label.System_CL00108 != '') {            
            List<String> roleList = system.label.System_CL00108.split(',');
            quoteTeamRoles.addAll(roleList);
        }
        }catch(Exception e){String err=e.getMessage();}
    }
     public override void bulkBefore(ClsWrappers.TriggerContext trgCtx) {
            setReadAccess(trgCtx);
        }

 /*   
    *  @name bulkAfter
*/ 
    public override void bulkAfter(ClsWrappers.TriggerContext trgCtx) {
        try{
        if (noNeedToFireAfterInsertQTM == FALSE) { 
            syncQTMWithOTM(trgCtx);
        }
       }catch(Exception e){String err=e.getMessage();}
    }
 /*   
    *  @name setReadAccess
*/   
    public void setReadAccess(ClsWrappers.TriggerContext trgCtx) {
     if (trgCtx.IsInsert || trgCtx.IsUpdate ){           
            for (Sobject sobj: trgCtx.newList) {                              
               Quote_Team_Member__c qtm = (Quote_Team_Member__c) sobj;  
                  qtm.Access_Level__c = 'Read Only';
                  System.debug('*****'+qtm.Access_Level__c);
                }             
            }
            }
    
 /*   
    *  @name syncQTMWithOTM
*/   
    public void syncQTMWithOTM(ClsWrappers.TriggerContext trgCtx) {        
               
        
        Map<String, OpportunityTeamMember> opportunityWithUserIdAndTeam = new Map<String, OpportunityTeamMember>();
            
        List<Quote_Team_Member__c> quoteTeamMemberList = new List<Quote_Team_Member__c>();
        //List<Quote_Team_Member__c> oldQuoteTeamMemberList = new List<Quote_Team_Member__c>();
        
        Set<Id> cQPTeamMemberIdSet = new Set<Id>();
        Set<Id> apttusTeamMemberIdSet = new Set<Id>();
        Set<Id> opportunityIdSet = new Set<Id>();
        try{
        //For Quote Team Member creation and modification
        if (trgCtx.isInsert || Trigger.isUpdate) {
            
            for (Sobject sobj: trgCtx.newList) {
                
                
                Quote_Team_Member__c qtm = (Quote_Team_Member__c) sobj;   
                Quote_Team_Member__c oldQtm = (trgCtx.IsUpdate) ? (Quote_Team_Member__c) trgCtx.OldMap.get(sobj.Id) : NULL;   
                
                if (trgCtx.isInsert || (trgCtx.IsUpdate && oldQtm.User__c != qtm.User__c) || (trgCtx.IsUpdate && qtm.Oppty_changed_on_quote__c)) {             
                            
                    opportunityIdSet.add(qtm.Opportunity_Id__c);                        
                    
                    String oppIdUsrId = Id.valueOf(qtm.Opportunity_Id__c) + String.valueOf(qtm.User__c);
                    oppIdWithUserIdAndAccessLevel.put(oppIdUsrId, qtm.Access_Level__c);
                    
                    //While creating Oportunity Team Member for CQP team member, We have to set access level should be Read Only
                    if (qtm.Quote_RecordType_Id__c != '' && quoteTeamRoles.contains(qtm.Team_Role__c) && ( cqpRTId != '' && cqpRTId == qtm.Quote_RecordType_Id__c)) {                            
                         oppIdWithUserIdAndAccessLevel.put(oppIdUsrId, System.label.Read_only);
                         cQPTeamMemberIdSet.add(qtm.Id);
                    }
                    
                    
                    //Apttus Recordtype related quotes (Team roles should be Quote Support or Quote Manager)
                    if (qtm.Quote_RecordType_Id__c != '' && quoteTeamRoles.contains(qtm.Team_Role__c) && ( apttusRTId != '' && apttusRTId == qtm.Quote_RecordType_Id__c)) {                            
                        apttusTeamMemberIdSet.add(qtm.Id);
                    }
                       
                    quoteTeamMemberList.add(qtm); //For this we have to create Oppotunity Team Member
                    
                }            
            }
        }
        
       
        if (opportunityIdSet.size() > 0) {
            
            Map<Id, OpportunityTeamMember> teamMap = new Map<Id, OpportunityTeamMember> ([
                SELECT Id, OpportunityId, OpportunityAccessLevel, TeamMemberRole, UserId 
                FROM OpportunityTeamMember
                WHERE OpportunityId IN: opportunityIdSet LIMIT 50000]);
                
               
            for (OpportunityTeamMember otm: teamMap.values()) {
                
                String oppIdUsrId = String.ValueOf(otm.OpportunityId) + String.ValueOf(otm.UserId);
                opportunityWithUserIdAndTeam.put(oppIdUsrId, otm);
            }
                        
            //To create/update Opportunity Team Member
            if (quoteTeamMemberList.size() > 0) {
            
                for (Quote_Team_Member__c team: quoteTeamMemberList) {
                    
                    String oppIdUsrId = Id.valueOf(team.Opportunity_Id__c) + String.ValueOf(team.User__c);
                    
                    OpportunityTeamMember newTeam = new OpportunityTeamMember(
                        OpportunityId = team.Opportunity_Id__c, TeamMemberRole = team.Team_Role__c, UserId = team.User__c);
                    
                    if (!opportunityWithUserIdAndTeam.containsKey(oppIdUsrId)) {
                        upsertOpportunityTeamMembers.add(newTeam);
                    } 
                    
                    /*else {   
                        
                        OpportunityTeamMember existMem = opportunityWithUserIdAndTeam.get(oppIdUsrId);
                        if (existMem.TeamMemberRole == team.Team_Role__c || ((existMem.TeamMemberRole == 'Quote Manager' && team.Team_Role__c == 'Quote Support') ||
                            (existMem.TeamMemberRole == 'Quote Support' && team.Team_Role__c == 'Quote Manager') )) {
                            OpportunityTeamMember updateTeam = newTeam;                 
                            updateTeam.Id = opportunityWithUserIdAndTeam.get(oppIdUsrId).Id;
                            upsertOpportunityTeamMembers.add(updateTeam);
                        } else {
                            team.addError(system.label.System_CL00103);
                        }
                    } */           
                }
            }
        }  
       }catch(Exception e){String err=e.getMessage();}  
    }
    
  /*   
    *  @name andFinally
*/  
    public override void andFinally(ClsWrappers.TriggerContext trgCtx) {
        
        try {
            if (upsertOpportunityTeamMembers != NULL && upsertOpportunityTeamMembers.size() > 0) {
                Database.Upsert(upsertOpportunityTeamMembers);
                
                Set<ID> userIdSet = new Set<Id>();
                Set<ID> opportunityIdSet = new Set<Id>();
                Map<String, String> accessMap = new Map<String, String>{System.label.Read_only=> System.label.System_CL00036, System.label.System_CL00037=>System.label.System_CL00026};
                List<OpportunityShare> updateShareList = new List<OpportunityShare>();
                
                for (OpportunityTeamMember team: upsertOpportunityTeamMembers) {
                    
                    userIdSet.add(team.UserId);
                    opportunityIdSet.add(team.OpportunityId);
                }
                
                // To update the Opportunity Team Member Access level
                if (oppIdWithUserIdAndAccessLevel.size() > 0) {
                    
                    for (OpportunityShare share: [ SELECT Id, OpportunityId, UserOrGroupId, OpportunityAccessLevel, RowCause 
                          FROM OpportunityShare 
                          WHERE OpportunityId IN :opportunityIdSet AND UserOrGroupId IN: userIdSet AND RowCause = 'Team' LIMIT 50000]) {
                          
                          String oppIdUsrId = String.ValueOf(share.OpportunityId) + String.ValueOf(share.UserOrGroupId);
                          
                          if (oppIdWithUserIdAndAccessLevel.containsKey(oppIdUsrId)) {
                              
                              String access = accessMap.get(oppIdWithUserIdAndAccessLevel.get(oppIdUsrId));
                              if (access != share.OpportunityAccessLevel) {
                                  
                                  share.OpportunityAccessLevel = access;                                  
                                  updateShareList.add(share);
                              }
                          }
                    }                          
                }
                
                
                if (updateShareList.size() > 0) {
                    Database.Update(updateShareList);
                }
            }
            
        } Catch (DMLException e) {            
            
            List<Sobject> objList = trgCtx.newList;
            
            String error = '';
            for (Integer i=0; i <e.getNumDML(); i++) {
                error += e.getDmlMessage(i) + System.label.Line_Break;
            }
            for (Sobject obj: objList) {                
                Quote_Team_Member__c qtm = (Quote_Team_Member__c) obj;
                qtm.addError(error, false);            
            }
            
        }
        
    }
}