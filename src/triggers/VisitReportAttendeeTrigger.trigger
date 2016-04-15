/**
* Release 5
* 
* @Author Vasanthi(Accenture)
* Created 2016-3-28
* Version 1.0
*/
trigger VisitReportAttendeeTrigger on Visit_Attendee__c (after insert, after delete) {
    
    if (!System.label.SYS_RunOpportunityTrigger.equalsIgnoreCase(System.Label.SYS_TRIGGER_NO)) {           
        ClsTriggerFactory.createHandler(Visit_Attendee__c.sObjectType);
    }
}