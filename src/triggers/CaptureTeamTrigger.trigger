trigger CaptureTeamTrigger on Capture_Team__c (after delete, after insert, after undelete, 
                                                after update, before delete, before insert, before update) {
    ClsTriggerFactory.createHandler(Capture_Team__c.sObjectType);
}