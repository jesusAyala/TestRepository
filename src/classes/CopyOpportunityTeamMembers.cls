/**   
* Button JAvacript Class on the Quote Team Member object to sync the Quote Team Members with Opportunity Team Members
*       
* Release - R5 
 *  
 * @author  - Vasanthi (Accenture)
 * @created - 2016-2-04
 * @version - 1.0
 * @Description - To sync Quote Team Member with Opportunity Team Member as per Req#2503
* - Created
*/
global without sharing class CopyOpportunityTeamMembers {
   /* To sync Quote Team Member with Opportunity Team Member as per Req#2503*/ 
    webservice static string  copyTheRecords(Id oppId, Id QuoteID) {
        
        String retString = '';
        if (oppId != NULL && QuoteId != NULL) {
            
            List<Quote_Team_Member__c> qtmList = new List<Quote_Team_Member__c>();
            Map<Id, String> userIdAndAccessLevelMap = new Map<Id, String>();
            Map<Id, Id> userIdAndQuoteTeamMemberIdMap = new Map <Id, Id>();
            Map<String, String> accessMap = new Map<String, String>{System.label.System_CL00036=> System.label.Read_only, System.label.System_CL00026=>System.label.System_CL00037};
             
            OpportunityTeamMember[] teams = [ SELECT Id, OpportunityId, OpportunityAccessLevel, TeamMemberRole, UserId 
                FROM OpportunityTeamMember WHERE OpportunityId =: oppId LIMIT 50000];
            
            for (Quote_Team_Member__c qtm: [ SELECT Id, User__c, Quotation__c, Team_Role__c, Access_Level__c FROM Quote_Team_Member__c
                WHERE Quotation__c =: QuoteID LIMIT 50000]) {
                
                userIdAndQuoteTeamMemberIdMap.put(qtm.User__c, qtm.Id);
            }    
                    
            for (OpportunityShare share: [ SELECT Id, OpportunityId, UserOrGroupId, OpportunityAccessLevel, RowCause 
                  FROM OpportunityShare 
                  WHERE OpportunityId =:oppId AND RowCause = 'Team' LIMIT 50000]) {
                  
                 userIdAndAccessLevelMap.put( share.UserOrGroupId, share.OpportunityAccessLevel);                          
            }
            
            for (OpportunityTeamMember otm: [ SELECT Id, OpportunityId, OpportunityAccessLevel, TeamMemberRole, UserId 
                FROM OpportunityTeamMember WHERE OpportunityId =: oppId LIMIT 50000]) {
                
                Quote_Team_Member__c qtm = new Quote_Team_Member__c(User__c = otm.UserID, Quotation__c = QuoteId, Team_Role__c = otm.TeamMemberRole,
                    Access_Level__c = accessMap.get(userIdAndAccessLevelMap.get(otm.UserID)));
                
                if (userIdAndQuoteTeamMemberIdMap.containsKey(otm.UserId)) qtm.Id = userIdAndQuoteTeamMemberIdMap.get(otm.UserID);
                
                qtmList.add(qtm);
            }
            
            if (qtmList.size() > 0) {
                
                try {
                    ClsTriggerQuoteTeamMemberHandler.noNeedToFireAfterInsertQTM = TRUE;
                    Database.Upsert(qtmList,False);
                    retString = System.label.Success;
                }Catch (DMLException e) {   
                    retString = e.getDMLMessage(0);        
                }
            }            
        } 
        return retString;   
    }
}