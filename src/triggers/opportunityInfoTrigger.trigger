/**
 * TriggerClass - centual adapter for all Opportunity_Information__c 
 *      
 * Release - R5 
 *  
 * @author Vasanthi (Accenture)
 * @created 2016-3-09
 * @version 1.0
 *
 * - Created
 */
trigger opportunityInfoTrigger on Opportunity_Information__c (after delete, after insert, after undelete, 
                                                after update, before delete, before insert, before update) {      
                                                                                        
    if (!System.label.SYS_RunOpportunityTrigger.equalsIgnoreCase('NO')) {  
        ClsTriggerFactory.createHandler(Opportunity_Information__c.sObjectType);
    }
}