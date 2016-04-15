/**
* Release 5
* @Author Aswini Arasu
* Created 2016-02-24
* Version 1.0
*/
trigger ResultsTrigger on Rfp_Results__c(after insert, 
after update, before insert, before update) {
 If(!System.label.SYS_RunResultsTrigger.equalsIgnoreCase(System.label.System_CL0002)){ // System_CL0002 --> 'NO'
    ClsTriggerFactory.createHandler(Rfp_Results__c.sObjectType);
    }
}