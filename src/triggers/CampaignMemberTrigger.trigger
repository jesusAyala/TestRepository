/**
 * TriggerClass - centual adapter for all CampaignMember
 *      
 * @version 1.0
 *
 * - Created
 */
trigger CampaignMemberTrigger on CampaignMember (after delete, before delete) {

      ClsTriggerFactory.createHandler(CampaignMember.sObjectType);
     
}