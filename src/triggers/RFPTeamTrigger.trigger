/**
* Release 5
* @Author Shankar Anand
* Created 2016-02-24
* Version 1.0
*/
trigger RFPTeamTrigger on RFP_Team__c(after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
 If(!System.label.SYS_RunRFPTeamTrigger.equalsIgnoreCase(System.label.System_CL0002)){ // System_CL0002 --> 'NO'
    ClsTriggerFactory.createHandler(RFP_Team__c.sObjectType);
    }
}