/**
      
 * Release - R5 
 *  
 * @author  - Vasanthi (Accenture)
 * @created - 2016-3-7
 * @version - 1.0
 * @Description - 
 * - Created
 */
trigger populateJBPCurrency on Joint_Business_Plan_Market_Coverage__c (before delete, before insert) {                                               
    if (!System.label.SYS_RunOpportunityTrigger.equalsIgnoreCase(System.Label.SYS_TRIGGER_NO)) {           
        ClsTriggerFactory.createHandler(Joint_Business_Plan_Market_Coverage__c.sObjectType);
    }
}