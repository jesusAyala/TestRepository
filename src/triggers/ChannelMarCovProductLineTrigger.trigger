/**
 * TriggerClass - centual adapter for all Channel Market Coverage Product Lines
 *      
 * Release - R5 
 *  
 * @author  Indhu Selvi Ramalingam (Accenture)
 * @created 2016-01-27
 * @version 1.0
 *
 * - Created
 */
trigger ChannelMarCovProductLineTrigger on Channel_Market_Coverage_Product_Lines__c (after delete, after insert, after update, before delete, before insert, before update) {
     
    if (!System.label.SYS_RunOpportunityTrigger.equalsIgnoreCase(System.Label.SYS_TRIGGER_NO)) {                                  
        ClsTriggerFactory.createHandler(Channel_Market_Coverage_Product_Lines__c.sObjectType);
    }
}