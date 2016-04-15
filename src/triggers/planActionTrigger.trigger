/**
 * TriggerClass - centual adapter for all Joint_Business_Plan_Actions__c 
 *      
 * Release - R5 
 *  
 * @author Indhu Ramalingam (Accenture)
 * @created 2016-3-25
 * @version 1.0
 *
 * - Created
 */
trigger planActionTrigger on Joint_Business_Plan_Actions__c (after delete, after insert, after undelete, 
                                                after update, before delete, before insert, before update) {      
                                                                                        
    if (!System.label.SYS_RunOpportunityTrigger.equalsIgnoreCase(System.Label.SYS_TRIGGER_NO)) {  
        ClsTriggerFactory.createHandler(Joint_Business_Plan_Actions__c.sObjectType);
    }
}