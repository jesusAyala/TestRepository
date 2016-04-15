trigger ErpMappingPicKDescTrigger on LSO_Field_Entries__c(before insert, before update) {
ClsTriggerFactory.createHandler(LSO_Field_Entries__c.sObjectType);
}