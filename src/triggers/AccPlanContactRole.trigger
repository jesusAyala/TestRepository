/**
* Release 5
* KAD -
* @Author Ayiravalli Arasu(Accenture)
* Created 2016-2-2
* Version 1.0
*/
trigger AccPlanContactRole on Contact_Roles__c (before insert, before update, before delete) {
    
    if (!System.label.SYS_RunOpportunityTrigger.equalsIgnoreCase(System.Label.SYS_TRIGGER_NO)) {           
        ClsTriggerFactory.createHandler(Contact_Roles__c.sObjectType);
    }
}