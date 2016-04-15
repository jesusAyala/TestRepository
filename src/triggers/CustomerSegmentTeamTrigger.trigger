/**
 * Trigger - centual adapter for all CustomerSegmentation Team trigger
 * 
 *      
 * Release R5
 *  
 * @author  Indhu Selvi Ramalingam (Accenture)
 * @created 2016-01-12
 * @version 1.0
 *
 * - Created
 */
trigger CustomerSegmentTeamTrigger on Customer_Segmentation_Team__c (after delete, after insert, after update, before delete, before insert, before update) {
    if (!System.label.SYS_RunOpportunityTrigger.equalsIgnoreCase(System.Label.SYS_TRIGGER_NO)) {              
        ClsTriggerFactory.createHandler(Customer_Segmentation_Team__c.sObjectType);
    }
}