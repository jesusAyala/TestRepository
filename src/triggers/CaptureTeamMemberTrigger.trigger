trigger CaptureTeamMemberTrigger on Capture_Team_Member__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
    ClsTriggerFactory.createHandler(Capture_Team_Member__c.sObjectType);
}