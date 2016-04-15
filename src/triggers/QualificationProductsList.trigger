/**
 * TriggerClass - centual adapter for all Qualification Products List 
 *      
 * Release - R4 
 *  
 * @author  Abiramasundari Radha (Accenture)
 * @created 2015-08-27
 * @version 1.0
 *
 * - Created
 */
trigger QualificationProductsList on Qualification_Products_List__c (after delete, after insert, after undelete, 
                                                after update, before delete, before insert, before update) {                                                
    if (!System.label.SYS_RunOpportunityTrigger.equalsIgnoreCase('NO')) {           
        ClsTriggerFactory.createHandler(Qualification_Products_List__c.sObjectType);
    }
}