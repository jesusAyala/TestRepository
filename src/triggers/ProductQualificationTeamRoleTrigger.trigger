/**
 * Trigger - centual adapter for all Product Qualification Team Role trigger
 * 
 *      
 * Release R4
 *  
 * @author  Abiramasundari Radha (Accenture)
 * @created 2015-07-29
 * @version 1.0
 *
 * - Created
 */
trigger ProductQualificationTeamRoleTrigger on Product_Qualification_Team_Role__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {

    ClsTriggerFactory.createHandler(Product_Qualification_Team_Role__c.sObjectType);
}