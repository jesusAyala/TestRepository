/**
 * TriggerClass - centual adapter for all Contact Role
 *      
 * Release - R4 
 *  
 * @author  Abiramasundari Radha (Accenture)
 * @created 2015-09-22
 * @version 1.0
 *
 * - Created
 */
trigger ContactRole on Contact_Role__c (before delete) {
    if (!System.label.SYS_RunOpportunityTrigger.equalsIgnoreCase('NO')) {                                                     
        ClsTriggerFactory.createHandler(Contact_Role__c.sObjectType);
    }
}