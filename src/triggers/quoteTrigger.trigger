/**   
 * Release - R5 
 *  
 * @author  - Shankar Anand (Accenture)
 * @created - 2016-2-05
 * @version - 1.0
 * @Description - Req#2504
 * - Created
 */
trigger quoteTrigger on Apttus_Proposal__Proposal__c (after insert, after update, after delete) {
    If(!System.label.SYS_RunQuoteTrigger.equalsIgnoreCase(System.label.System_CL0002)){ // System_CL0002 -> 'NO'
         ClsTriggerFactory.createHandler(Apttus_Proposal__Proposal__c.sObjectType);
    }
}