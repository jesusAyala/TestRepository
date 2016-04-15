trigger End_User_ProjectTrigger on End_User_Project__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
    If(!System.label.SYS_RunEndUserProjectTrigger.equalsIgnoreCase('NO')){
    ClsTriggerFactory.createHandler(End_User_Project__c.sObjectType);
    }
}