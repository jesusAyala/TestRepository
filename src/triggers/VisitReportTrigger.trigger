/**
* Release 5
* 
* @Author Vasanthi(Accenture)
* Created 2016-3-16
* Version 1.0
*/
trigger VisitReportTrigger on Visit_Report__c (after update, before delete) {
    
    if (!System.label.SYS_RunOpportunityTrigger.equalsIgnoreCase(System.Label.SYS_TRIGGER_NO)) {           
        ClsTriggerFactory.createHandler(Visit_Report__c.sObjectType);
    }
}