/**
      
 * Release - R5 
 *  
 * @author  - Vasanthi (Accenture)
 * @created - 2016-2-15
 * @version - 1.0
 * @Description - Req #2182 (KAD-01000): To prevent the user, if they are trying to change already existing channel market scope if they are not account team member, Account Owner Local Administrator 3
 * - Created
 */
trigger channelMarketCoverageTrigger on Channel_Market_Coverage__c(after insert, after update, after delete, before Update) {                                           
     if (!System.label.SYS_RunOpportunityTrigger.equalsIgnoreCase(System.Label.SYS_TRIGGER_NO)) {              
        ClsTriggerFactory.createHandler(Channel_Market_Coverage__c.sObjectType);
    }
}