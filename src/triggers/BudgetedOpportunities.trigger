/**
 * TriggerClass - centual adapter for all Budget_Opp__c
 *      
 * Release - R5 
 *  
 * @author  Indhu Selvi Ramalingam (Accenture)
 * @created 2016-02-15
 * @version 1.0
 *
 * - Created
 */
trigger BudgetedOpportunities on Budget_Opp__c (before delete) {      
    if (!System.label.SYS_RunOpportunityTrigger.equalsIgnoreCase(System.Label.SYS_TRIGGER_NO)) {                                                                                                                                                 
        ClsTriggerFactory.createHandler(Budget_Opp__c.sObjectType);
    }
}