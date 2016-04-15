/**
 * TriggerClass - centual adapter for all ChannelQualification
 *      
 * Release - R5 
 *  
 * @author  Abiramasundari Radha (Accenture)
 * @created 
 * @version 1.0
 *
 * - Created
 */
trigger ChannelQualifications on Channel_Qualifications__c (after insert, after update, before insert, before update) {
    
    if (!System.label.SYS_RunOpportunityTrigger.equalsIgnoreCase(System.Label.SYS_TRIGGER_NO)) {                                                                                          
        ClsTriggerFactory.createHandler(Channel_Qualifications__c.sObjectType);
    }
}