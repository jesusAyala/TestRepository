/**
* Release 5
* @Author Shankaranarayanan V
* Created 2015-12-30
* Version 1.0
*/
trigger VisitReportTeamMemberTrigger on Visit_Report_Team_Member__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
/**
 * trigger runs only for custom label has below value
 *      
 */  
    if (!System.label.SYS_RunOpportunityTrigger.equalsIgnoreCase(System.Label.SYS_TRIGGER_NO)) {           
        ClsTriggerFactory.createHandler(Visit_Report_Team_Member__c.sObjectType);
    }
}