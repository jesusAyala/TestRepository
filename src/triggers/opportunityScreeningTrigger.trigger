/**
 * Trigger - centual adapter for all Opportunity Screening trigger
 * 
 *      
 * Release R4
 *  
 * @author  Abiramasundari Radha (Accenture)
 * @created 2015-07-29
 * @version 1.0
 *
 * - Created
 * @Modified by Sajila Kadayaprath
 * @Modified Date 2016-03-18
 * @Description : Added code to populate the Primary_Acc_Manager__c field when Gate_Status__c  field is updated with Bid / No Bid
 */
trigger opportunityScreeningTrigger on Opportunity_Screening__c (after delete, after insert, after undelete, 
                                                                    after update, before delete, before insert, before update) {    
/**
 * trigger runs only for custom label has below value
 *      
 */                                                                                                                                      
    If(!System.label.SYS_RunOpportunityScreeningTrigger.equalsIgnoreCase('NO')){
        ClsTriggerFactory.createHandler(Opportunity_Screening__c.sObjectType);
    }
   
}