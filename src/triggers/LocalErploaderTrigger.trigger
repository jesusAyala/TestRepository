/**
 * TriggerClass - centual adapter for all Local ERP Loader trigger
 *      
 * Release - R3 
 *  
 * @author  Abiramasundari Radha (Accenture)
 * @created 2015-07-17
 * @version 1.0
 *
 * - Created
 */
trigger LocalErploaderTrigger on Local_ERP_Loader__c (after delete, after insert, after undelete, 
                                                after update, before delete, before insert, before update) {
  If(!System.label.SYS_RunLocalERPLoaderTrigger.equalsIgnoreCase('NO')){                                              
    ClsTriggerFactory.createHandler(Local_ERP_Loader__c.sObjectType);
   }
}