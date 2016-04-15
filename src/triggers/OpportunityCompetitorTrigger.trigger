/**
* Release 5
* @Author Shankar Anand
* Created 2015-12-11
* Version 1.0
*/
trigger OpportunityCompetitorTrigger on Competitor__c (before insert, after insert, before update, after update, before delete, after delete) {
    If(!System.label.SYS_RunOpportunityCompetitorTrigger.equalsIgnoreCase(System.label.System_CL0002)){ // System_CL0002 --> 'NO'
        ClsTriggerFactory.createHandler(Competitor__c.sObjectType);
    }
    
}