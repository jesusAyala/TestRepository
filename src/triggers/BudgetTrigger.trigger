/**
 * TriggerClass - centual adapter for all Budget__c 
 *      
 * Release - R5 
 *  
 * @author  Indhu Selvi Ramalingam (Accenture)
 * @created 2015-12-21
 * @version 1.0
 *
 * - Created
 */
trigger BudgetTrigger on Budget__c (after delete, after insert, after update, before delete, before insert, before update) {    
                                                                                         
     if (!System.label.SYS_RunOpportunityTrigger.equalsIgnoreCase(System.Label.SYS_TRIGGER_NO)) {  
         ClsTriggerFactory.createHandler(Budget__c.sObjectType);
     }
}