/**
* Release 5
* @Author Shankar Anand
* Created 2015-02-26
* Version 1.0
*/
trigger ProcessingsTrigger on Rfp_Processing__c (before insert, after insert, before update, after update) {
    If(!System.label.SYS_RunProcessingsTrigger.equalsIgnoreCase(System.label.System_CL0002)){ // System_CL0002 --> 'NO'
        ClsTriggerFactory.createHandler(Rfp_Processing__c.sObjectType);
    }
   }