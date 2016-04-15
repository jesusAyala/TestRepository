/**
* Release 5
* 
* @Author Vasanthi(Accenture)
* Created 2016-3-16
* Version 1.0
*/
trigger CompetitorsTrigger on Competitors__c (before delete) {
    
    if (!System.label.SYS_RunOpportunityTrigger.equalsIgnoreCase(System.Label.SYS_TRIGGER_NO)) {           
        ClsTriggerFactory.createHandler(Competitors__c.sObjectType);
    }
}