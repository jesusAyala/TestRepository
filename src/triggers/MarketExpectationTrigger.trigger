/**
* Release 5
* 
* @Author Vasanthi(Accenture)
* Created 2016-3-16
* Version 1.0
*/
trigger MarketExpectationTrigger on Market_Expectation__c (before delete) {
    
    if (!System.label.SYS_RunOpportunityTrigger.equalsIgnoreCase(System.Label.SYS_TRIGGER_NO)) {           
        ClsTriggerFactory.createHandler(Market_Expectation__c.sObjectType);
    }
}