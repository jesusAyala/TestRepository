/**
 * Trigger - centual adapter for all Account Plan Team trigger
 * 
 *      
 * Release R5
 *  
 * @author  Abiramasundari Radha (Accenture)
 * @created 2015-01-11
 * @version 1.0
 *
 * - Created
 */
trigger AccountPlanTeamTrigger on Account_Plan_Team__c (after delete, after insert, after update) {
/**
 * trigger runs only for custom label has below value
 *      
 */ 
     if (!System.label.SYS_RunOpportunityTrigger.equalsIgnoreCase(System.Label.SYS_TRIGGER_NO)) {              
         ClsTriggerFactory.createHandler(Account_Plan_Team__c.sObjectType);
     }
}