trigger APTS_LSOFieldEntriesTrigger on LSO_Field_Entries__c (after insert, after update, after delete) {

    APTS_LSOFieldEntriesTriggerHandler LSOFieldEntriesTriggerHandler = new APTS_LSOFieldEntriesTriggerHandler();
    
    /* After Insert */
    if (Trigger.isInsert && Trigger.isafter) {
        LSOFieldEntriesTriggerHandler.OnAfterInsert(trigger.new);
    }
    
    /* After Update */
    if (Trigger.isUpdate && Trigger.isAfter) {
        LSOFieldEntriesTriggerHandler.OnAfterUpdate(Trigger.newMap, Trigger.oldMap);
    }

    /* After Delete */
    if (Trigger.isDelete && Trigger.isAfter) {
        LSOFieldEntriesTriggerHandler.OnAfterDelete(Trigger.oldMap);
    }

}