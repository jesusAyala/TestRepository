trigger ErpMappingLSODescTrigger on ERP_Mapping__c (before insert, before update) {
ClsTriggerFactory.createHandler(ERP_Mapping__c.sObjectType);
}