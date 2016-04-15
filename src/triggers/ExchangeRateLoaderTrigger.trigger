trigger ExchangeRateLoaderTrigger on Exchange_Rate_Loader__c(after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
    If(!System.label.SYS_RunExchageRateLoaderTrigger.equalsIgnoreCase('NO')){
           ClsTriggerFactory.createHandler(Exchange_Rate_Loader__c.sObjectType);
    }
}