/**
*  This test class used to test class ClsBatch_calcAPLPreviousForecast.
*
@author Lili Zhao
@created 2014-11-26
*
@changelog
* coverage  81%
*  
2014-11-26 Lili Zhao <lili.zhao@itbconsult.com>
* - Created  
*/
@isTest
private class ClsBatch_cloneAccountAttachments_Test {
    static testMethod void myUnitTest() {
        Account acc = new Account();
        acc.Name = 'AMP Foundries Inc';
        acc.BillingStreet = 'Teststr.1';
        acc.BillingCountry = 'China';
        acc.BillingCity = 'Musterstadt';
        acc.ShippingCountry = 'China';
        acc.ShippingStreet  = 'Teststr.1';
        acc.ShippingCity = 'Musterstadt';
        insert acc;
        
        Account acc1 = new Account();
        acc1.Name = 'AMP Foundries Inc123';
        acc1.BillingStreet = 'Teststr. Inc123';
        acc1.BillingCountry = 'Spain';
        acc1.BillingCity = 'MusterstadtInc123';
        acc1.Successor_Company__c = acc.Id; 
        acc1.Reason_for_Deactivation__c = 'Duplicate';
        acc1.ShippingCountry = 'Spain';
        acc1.ShippingStreet  = 'Teststr. Inc123';
        acc1.ShippingCity = 'Musterstadt123';        
        insert acc1;
        
        Attachment no = new Attachment();
        no.ParentId = acc1.Id;
        no.Name = 'test';
        no.Body = Blob.valueOf('test');
        insert no;
        
        map<String, String> map_accId_successorCompany = new map<String, String>();
        map_accId_successorCompany.put(acc1.Id, acc.Id);
        Test.startTest();
        ClsBatch_cloneAccountAttachments cls = new ClsBatch_cloneAccountAttachments();
        cls.map_accId_successorCompany = map_accId_successorCompany;
        database.executeBatch(cls);
        Test.stopTest();
    }
}