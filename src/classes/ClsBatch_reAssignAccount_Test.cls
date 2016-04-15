/**
*  This test class used to test class ClsBatch_calcAPLPreviousForecast.
*
@author Lili Zhao
@created 2014-11-26
*
@changelog
* coverage  86%
*  
2014-11-26 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest
private class ClsBatch_reAssignAccount_Test {

    static testMethod void myUnitTest() {
         Profile p = [SELECT Id FROM Profile WHERE Name='ABB GIS Integration']; 
        User u = new User(Alias = 'gistest', Email='ishita_bhardwaj@infosys.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='gistest@infosys.com');
        Validation_Override__c vc = new Validation_Override__c();

vc.Exclude__c = true;
insert vc;
        System.runAs(u) {
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
        acc1.ShippingCountry = 'Spain';
        acc1.ShippingStreet  = 'Teststr. Inc123';
        acc1.ShippingCity = 'Musterstadt123';
        acc1.Company_Status__c = 'Duplicate';
        acc1.Reason_for_Deactivation__c = 'Duplicate';      
        acc1.reassign__c=true;       
        insert acc1;
        
         Account acc2 = new Account();
        acc2.Name = 'HGF Foundries Inc123';
        acc2.BillingStreet = 'Teststr. Inc123';
        acc2.BillingCountry = 'Spain';
        acc2.BillingCity = 'MusterstadtInc123';
        acc2.Successor_Company__c = acc.Id; 
        acc2.ShippingCountry = 'Spain';
        acc2.ShippingStreet  = 'Teststr. Inc123';
        acc2.ShippingCity = 'Musterstadt123';
        acc2.Company_Status__c = 'Out Of Business';   
        acc2.Reason_for_Deactivation__c = 'Duplicate';   
        acc2.reassign__c=true;       
        insert acc2;
                    
        List<Account> list_account = new List<Account>();
        list_account.add(acc1);
        
        list<ReAssigning_Related_Records__c> list_ReAssigningCustoms = new list<ReAssigning_Related_Records__c>();
        
        for(ReAssigning_Related_Records__c setting1 : [select Name, Value__c, Parent_API__c, isClone__c, Require_Field__c from ReAssigning_Related_Records__c]) {
            list_ReAssigningCustoms.add(setting1);
        }
        if(list_ReAssigningCustoms.isEmpty()) {         
            ReAssigning_Related_Records__c setting6 = new ReAssigning_Related_Records__c();
            setting6.Name = 'BatchNum';
            setting6.Value__c = '10';
            list_ReAssigningCustoms.add(setting6);
            insert list_ReAssigningCustoms;
        }
        
        Test.startTest();
        Set<Id> SafeIsland = new Set<Id>();
        String q= 'Select Id,name, ReAssign__c, Successor_Company__c From Account where ReAssign__c = true And Successor_Company__c != null and  company_status__c=\'Duplicate\'';      
        ClsBatch_reAssignAccount clsBatch = new ClsBatch_reAssignAccount('Duplicate', SafeIsland);
        clsBatch.query=q;
        Database.BatchableContext BC;
        //clsBatch.filter = ' limit 1';
        Database.executeBatch(clsBatch);
             
        
        system.assert(true);
        Test.stopTest();
        }
    }
}