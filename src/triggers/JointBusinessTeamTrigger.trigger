/**
 * Trigger -  To share the Channel Partner Business Plan
 * Release R5
 * @author  Vasanthi M(Accenture)
 * @created 2016-03-08
 * @version 1.0
 * Created
 
  Purpose: To share the Channel Partner Business Plan
 
  */
trigger JointBusinessTeamTrigger on Joint_Business_Team__c (before delete, after insert, after update, after delete) {
    
    if (!System.label.SYS_RunOpportunityTrigger.equalsIgnoreCase(System.Label.SYS_TRIGGER_NO)) {           
        ClsTriggerFactory.createHandler(Joint_Business_Team__c.sObjectType);
    }    
}