/**
 * Trigger - centual adapter for all Opportunity 
 * 
 */
trigger OpportunityTrigger on Opportunity (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
 /**
 * trigger runs only for custom label has below value
 *      
 */          
    If( !(ClsAccountUtil.isAccMergeFlag) &&!System.label.SYS_RunOpportunityTrigger.equalsIgnoreCase(System.Label.SYS_TRIGGER_NO) && !ClsTriggerFactory.isSkipOpptyTrigger){
    
    ClsTriggerFactory.createHandler(Opportunity.sObjectType);
    }
    
}