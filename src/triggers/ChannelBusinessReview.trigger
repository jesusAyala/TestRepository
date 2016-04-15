/**
 * TriggerClass - centual adapter for all Channel_Business_Review__c 
 *      
 * Release - R5 
 *  
 * @author  Ayiravalli A (Accenture)
 * @created 2016-1-12
 * @version 1.0
 *
 * - Created
 */
trigger ChannelBusinessReview on Channel_Business_Review__c (after insert, after update, before insert, before update) {      
                                                                                        
    if (!System.label.SYS_RunOpportunityTrigger.equalsIgnoreCase(System.Label.SYS_TRIGGER_NO)) {  
        ClsTriggerFactory.createHandler(Channel_Business_Review__c.sObjectType);
    }
}