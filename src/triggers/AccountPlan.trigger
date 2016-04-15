/**
 * TriggerClass - centual adapter for all Account_Plan__c 
 *      
 * Release - R5 
 *  
 * @author  Indhu Selvi Ramalingam (Accenture)
 * @created 2016-12-21
 * @version 1.0
 *
 * - Created
 */
trigger AccountPlan on Account_Plan__c (after insert, after update, before delete, before insert, before update) {  
/**
 * trigger runs only for custom label has below value
 *      
 */                                                                                                                                         
    if (!System.label.SYS_RunOpportunityTrigger.equalsIgnoreCase(System.Label.SYS_TRIGGER_NO)) {                                  
        ClsTriggerFactory.createHandler(Account_Plan__c.sObjectType);
    }
}