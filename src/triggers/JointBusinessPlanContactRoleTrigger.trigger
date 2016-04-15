/**
* Release 5
* 
* @Author Vasanthi(Accenture)
* Created 2016-3-17
* Version 1.0
*/
trigger JointBusinessPlanContactRoleTrigger on Joint_Business_Plan_Contact_Role__c (after insert, after update, before delete) {
    
    if (!System.label.SYS_RunOpportunityTrigger.equalsIgnoreCase(System.Label.SYS_TRIGGER_NO)) {           
        ClsTriggerFactory.createHandler(Joint_Business_Plan_Contact_Role__c.sObjectType);
    }
}