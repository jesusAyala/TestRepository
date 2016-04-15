trigger LSODupeCheckTrigger on ERP_Reference_Data__c (before insert, before update) {
    if (!System.label.SYS_RunLocalReferenceDataTrigger.equalsIgnoreCase('NO')) {     
        ClsTriggerFactory.createHandler(ERP_Reference_Data__c.sObjectType);
    }
}
