/**
 * TriggerClass - centual adapter for all Competitor Product Qualification
 *      
 * Release - R4 
 *  
 * @author  Abiramasundari Radha (Accenture)
 * @created 2015-09-10
 * @version 1.0
 *
 * - Created
 */
trigger CompetitorProductQualification on Competitor_Product_Qualification__c (after delete, after insert,
                                                after update, before delete, before insert, before update) {
                                                
    ClsTriggerFactory.createHandler(Competitor_Product_Qualification__c.sObjectType);
}