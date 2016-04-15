/**
 * TriggerClass - centual adapter for all Product Qualification Level
 *      
 * Release - R4 
 *  
 * @author  Abiramasundari Radha (Accenture)
 * @created 2015-08-21
 * @version 1.0
 *
 * - Created
 */
trigger ProductQualificationLevel on Product_Qualification_Level__c (after delete, after insert, after undelete, 
                                                after update, before delete, before insert, before update) {
                                                
    ClsTriggerFactory.createHandler(Product_Qualification_Level__c.sObjectType);
}