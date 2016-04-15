/**
 * Trigger -  To share the Channel Pre Qualification
 * Release R5
 * @author  Vasanthi M(Accenture)
 * @created 2016-03-02
 * @version 1.0
 * Created
 
  Purpose: To share the Channel Pre Qualification
 
  */
trigger ChannelQualificationTeamTrigger on Channel_Pre_Qualification_Team__c (before delete, after insert, after update, after delete) {
    
    if (!System.label.SYS_RunOpportunityTrigger.equalsIgnoreCase(System.Label.SYS_TRIGGER_NO)) {           
        ClsTriggerFactory.createHandler(Channel_Pre_Qualification_Team__c.sObjectType);
    }    
}