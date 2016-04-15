/**
 * TriggerClass - centual adapter for all Customer_Segmentation__c 
 *      
 * Release - R5 
 *  
 * @author  Abiramasundari Radha (Accenture)
 * @created 2015-12-21
 * @version 1.0
 *
 * - Created
 */
trigger CustomerSegmentation on Customer_Segmentation__c (after insert, after update, before insert, before update) {                                                                                           
    if (!System.label.SYS_RunOpportunityTrigger.equalsIgnoreCase(System.Label.SYS_TRIGGER_NO)) {           
        ClsTriggerFactory.createHandler(Customer_Segmentation__c.sObjectType);
    }
}