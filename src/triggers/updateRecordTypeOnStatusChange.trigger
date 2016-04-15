/**
      
 * Release - R5 
 *  
 * @author  - Vasanthi (Accenture)
 * @created - 2016-1-25
 * @version - 1.0
 * @Description - If the status changes from "Closed" to "Draft/In Approval/Additional Details Required/Active" then change the record type "Closed" to "Open" as per Req#2450
     Whenever the JBP Start date changes then mutually agreed will be unchecked as per Req #2746 (KAD-00895)
     
     //Req #1960 (Update Joint Business Plan currency to Joint Business Plan Product Lines).  
 * - Created
 */
trigger updateRecordTypeOnStatusChange on Joint_Business_Plan__c (before insert, before update, after update) {
    ClsTriggerFactory.createHandler(Joint_Business_Plan__c.sObjectType);
}