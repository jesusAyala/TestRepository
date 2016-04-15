/**
*  This test class used to test class ExtRecalculateBudget.
*
@author MohanRaj
@created 2016-02-1
@version 1.0   
@since 28.0
*
@changelog
* coverage 85% 
* 
* 
2014-10-10 MohanRaj <Mohanraj.Kasinathan@accenture.com>
* - Created
*/
@isTest
private class TrgAccount_AU_setSuccessorCompany_Test {
    
    static Profile p = [SELECT Id FROM Profile WHERE Name= 'ABB Sales Standard Profile']; 
    static User u = new User(Alias = 'sysadmin', Email='SysAdmin@Accenture.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='admintest@accenture.com');    

    static Profile pi = [SELECT Id FROM Profile WHERE Name='ABB GIS Integration'];
    static User ui = new User(Alias = 'gistest', Email='gisInt@Accenture.com', 
    EmailEncodingKey='UTF-8', LastName='GIS Integration', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = pi.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='gis@Accenture.com');            

    
    static testMethod void myUnitTest_scenario1() {
               
        System.runAs(u) {

        Id GISApprovedID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('GIS Approved').getRecordTypeId();
        Id DefaultID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Default').getRecordTypeId();
        Id EXtNonBuyingID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('External Non-Buying Account').getRecordTypeId();

        List<Account> lstAccount = new List<Account>();
        
        Account acc=new Account();
        acc.RecordTypeId=EXtNonBuyingID;
        acc.Active__c=true;
        acc.Name = 'AMP Foundries Inc';
        acc.BillingStreet = 'Teststr. 1';
        acc.BillingCountry = 'China';
        acc.BillingCity = 'Musterstadt';        
        acc.ShippingCountry = 'China';
        acc.ShippingStreet  = 'Teststr. 1';
        acc.ShippingCity = 'Musterstadt';
        acc.Company_Status__c='Open';        
        lstAccount.add(acc);
        
        Account acc2 =new Account();
        acc2.RecordTypeId=EXtNonBuyingID;
        acc2.Active__c=true;
        acc2.Name = 'AMP Foundries Inc';
        acc2.BillingStreet = 'Teststr. 1';
        acc2.BillingCountry = 'China';
        acc2.BillingCity = 'Musterstadt';        
        acc2.ShippingCountry = 'China';
        acc2.ShippingStreet  = 'Teststr. 1';
        acc2.ShippingCity = 'Musterstadt';
        acc2.Company_Status__c='Open';        
        lstAccount.add(acc2);
        
        insert lstAccount; 
        
        Product_Group__c pg = new Product_Group__c();
        pg.Business_Unit__c = 'Test';
        pg.Name = 'TestName';
        pg.Division__c = 'DZ';
        insert pg;
        
        List<Safe_Island_Assessments__c> lstSIA = new List<Safe_Island_Assessments__c>();   
        Safe_Island_Assessments__c sia = new Safe_Island_Assessments__c();
        sia.PG__c = pg.Id;
        sia.Country__c = 'Sweden';
        sia.Credit_Assessment__c ='Weak (Credit rating 1 - 2)';
        sia.AccountCustomer__c = lstAccount[0].Id;
        insert sia; 
    
        Safe_Island_Assessments__c sia1 = new Safe_Island_Assessments__c();
        sia1.PG__c = pg.Id;
        sia1.Country__c = 'Sweden';
        sia1.Credit_Assessment__c ='Strong (Credit rating 4)';
        sia1.AccountCustomer__c = lstAccount[1].Id;
        insert sia1; 
         
        test.startTest();        
        
        lstAccount[0].Successor_Company__c = acc2.Id; 
        lstAccount[0].Reason_for_Deactivation__c = 'Duplicate';
        lstAccount[0].Company_Status__c = 'Duplicate';
        lstAccount[0].Active__c=true;
        update lstAccount[0];         
        
        Test.stopTest();}
        
    }   
    
    static testMethod void myUnitTest_scenario2() {
               
        System.runAs(u) {

        Id GISApprovedID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('GIS Approved').getRecordTypeId();
        Id DefaultID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Default').getRecordTypeId();
        Id EXtNonBuyingID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('External Non-Buying Account').getRecordTypeId();

        List<Account> lstAccount = new List<Account>();
        
        Account acc=new Account();
        acc.RecordTypeId=EXtNonBuyingID;
        acc.Active__c=true;
        acc.Name = 'AMP Foundries Inc';
        acc.BillingStreet = 'Teststr. 1';
        acc.BillingCountry = 'China';
        acc.BillingCity = 'Musterstadt';        
        acc.ShippingCountry = 'China';
        acc.ShippingStreet  = 'Teststr. 1';
        acc.ShippingCity = 'Musterstadt';
        acc.Company_Status__c='Open';        
        lstAccount.add(acc);
                
        Account acc5 =new Account();
        acc5.RecordTypeId=DefaultID;
        acc5.Active__c=true;
        acc5.Name = 'AMP Foundries Inc';
        acc5.BillingStreet = 'Teststr. 1';
        acc5.BillingCountry = 'China';
        acc5.BillingCity = 'Musterstadt';
        acc5.ShippingCountry = 'China';
        acc5.ShippingStreet  = 'Teststr. 1';
        acc5.ShippingCity = 'Musterstadt';
        acc5.Company_Status__c='Open';
        lstAccount.add(acc5);
                
        insert lstAccount; 
        
        Product_Group__c pg = new Product_Group__c();
        pg.Business_Unit__c = 'Test';
        pg.Name = 'TestName';
        pg.Division__c = 'DZ';
        insert pg;
        
        List<Safe_Island_Assessments__c> lstSIA = new List<Safe_Island_Assessments__c>();   
        Safe_Island_Assessments__c sia = new Safe_Island_Assessments__c();
        sia.PG__c = pg.Id;
        sia.Country__c = 'Sweden';
        sia.Credit_Assessment__c ='Weak (Credit rating 1 - 2)';
        sia.AccountCustomer__c = lstAccount[0].Id;
        insert sia; 
    
        Safe_Island_Assessments__c sia1 = new Safe_Island_Assessments__c();
        sia1.PG__c = pg.Id;
        sia1.Country__c = 'Sweden';
        sia1.Credit_Assessment__c ='Strong (Credit rating 4)';
        sia1.AccountCustomer__c = lstAccount[1].Id;
        insert sia1; 
         
        test.startTest();
        
        lstAccount[0].Successor_Company__c = acc5.Id; 
        lstAccount[0].Reason_for_Deactivation__c = 'Out of Business';
        lstAccount[0].Company_Status__c = 'Out of Business';
        lstAccount[0].Active__c=true;
        update lstAccount[0];     
        
        
        Test.stopTest();}
        
    }   
    
    static testMethod void myUnitTest_scenario3() {
               
        System.runAs(u) {

        Id GISApprovedID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('GIS Approved').getRecordTypeId();
        Id DefaultID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Default').getRecordTypeId();
        Id EXtNonBuyingID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('External Non-Buying Account').getRecordTypeId();

        List<Account> lstAccount = new List<Account>();
        
        Account acc=new Account();
        acc.RecordTypeId=EXtNonBuyingID;
        acc.Active__c=true;
        acc.Name = 'AMP Foundries Inc';
        acc.BillingStreet = 'Teststr. 1';
        acc.BillingCountry = 'China';
        acc.BillingCity = 'Musterstadt';        
        acc.ShippingCountry = 'China';
        acc.ShippingStreet  = 'Teststr. 1';
        acc.ShippingCity = 'Musterstadt';
        acc.Company_Status__c='Open';        
        lstAccount.add(acc);
        
        Account acc6 =new Account();
        acc6.RecordTypeId=GISApprovedID;
        acc6.Active__c=true;
        acc6.Name = 'AMP Foundries Inc';
        acc6.BillingStreet = 'Teststr. 1';
        acc6.BillingCountry = 'China';
        acc6.BillingCity = 'Musterstadt';
        acc6.ShippingCountry = 'China';
        acc6.ShippingStreet  = 'Teststr. 1';
        acc6.ShippingCity = 'Musterstadt';
        acc6.Company_Status__c='Approved';
        lstAccount.add(acc6);
        
        insert lstAccount; 
        
        Product_Group__c pg = new Product_Group__c();
        pg.Business_Unit__c = 'Test';
        pg.Name = 'TestName';
        pg.Division__c = 'DZ';
        insert pg;
        
        List<Safe_Island_Assessments__c> lstSIA = new List<Safe_Island_Assessments__c>();   
        Safe_Island_Assessments__c sia = new Safe_Island_Assessments__c();
        sia.PG__c = pg.Id;
        sia.Country__c = 'Sweden';
        sia.Credit_Assessment__c ='Weak (Credit rating 1 - 2)';
        sia.AccountCustomer__c = lstAccount[0].Id;
        insert sia; 
    
        Safe_Island_Assessments__c sia1 = new Safe_Island_Assessments__c();
        sia1.PG__c = pg.Id;
        sia1.Country__c = 'Sweden';
        sia1.Credit_Assessment__c ='Strong (Credit rating 4)';
        sia1.AccountCustomer__c = lstAccount[1].Id;
        insert sia1; 
         
        test.startTest();
        
        lstAccount[0].Successor_Company__c = acc6.Id; 
        lstAccount[0].Reason_for_Deactivation__c = 'Out of Business';
        lstAccount[0].Company_Status__c = 'Out of Business';
        lstAccount[0].Active__c=true;
        update lstAccount[0];               
        
        Test.stopTest();}
        
    }   
    
    static testMethod void myUnitTest_GISapproved1() {
        
        Validation_Override__c vc = new Validation_Override__c();
        vc.Account_Merge_Override__c = true;
        vc.Exclude__c = true;
        insert vc;
                
        System.runAs(ui) {

        Id GISApprovedID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('GIS Approved').getRecordTypeId();
        Id DefaultID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Default').getRecordTypeId();
        Id EXtNonBuyingID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('External Non-Buying Account').getRecordTypeId();

        List<Account> lstAccount = new List<Account>();     
        
        Account acc2 =new Account();
        acc2.RecordTypeId=GISApprovedID;
        acc2.Active__c=true;
        acc2.Name = 'AMP Foundries Inc';
        acc2.BillingStreet = 'Teststr. 1';
        acc2.BillingCountry = 'China';
        acc2.BillingCity = 'Musterstadt';        
        acc2.ShippingCountry = 'China';
        acc2.ShippingStreet  = 'Teststr. 1';
        acc2.ShippingCity = 'Musterstadt';
        acc2.Company_Status__c='Open';        
        lstAccount.add(acc2);
        
        Account acc3 =new Account();
        acc3.RecordTypeId=GISApprovedID;
        acc3.Active__c=true;
        acc3.Name = 'AMP Foundries Inc';
        acc3.BillingStreet = 'Teststr. 1';
        acc3.BillingCountry = 'China';
        acc3.BillingCity = 'Musterstadt';        
        acc3.ShippingCountry = 'China';
        acc3.ShippingStreet  = 'Teststr. 1';
        acc3.ShippingCity = 'Musterstadt';
        acc3.Company_Status__c='Open';        
        lstAccount.add(acc3);
        insert lstAccount; 
         
        test.startTest();

        lstAccount[0].Successor_Company__c = acc3.Id; 
        lstAccount[0].Reason_for_Deactivation__c = 'Duplicate';
        lstAccount[0].Company_Status__c = 'Duplicate';
        lstAccount[0].Active__c=true;
        update lstAccount[0];         
        
        Test.stopTest();}       
        
    }  
    
    static testMethod void myUnitTest_GISapproved2() {
        
        Validation_Override__c vc = new Validation_Override__c();
        vc.Account_Merge_Override__c = true;
        vc.Exclude__c = true;
        insert vc;
                
        System.runAs(ui) {

        Id GISApprovedID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('GIS Approved').getRecordTypeId();
        Id DefaultID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Default').getRecordTypeId();
        Id EXtNonBuyingID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('External Non-Buying Account').getRecordTypeId();

        List<Account> lstAccount = new List<Account>();     
        
        Account acc2 =new Account();
        acc2.RecordTypeId=DefaultID;
        acc2.Active__c=true;
        acc2.Name = 'AMP Foundries Inc';
        acc2.BillingStreet = 'Teststr. 1';
        acc2.BillingCountry = 'China';
        acc2.BillingCity = 'Musterstadt';        
        acc2.ShippingCountry = 'China';
        acc2.ShippingStreet  = 'Teststr. 1';
        acc2.ShippingCity = 'Musterstadt';
        acc2.Company_Status__c='Open';        
        lstAccount.add(acc2);
        
        Account acc3 =new Account();
        acc3.RecordTypeId=GISApprovedID;
        acc3.Active__c=true;
        acc3.Name = 'AMP Foundries Inc';
        acc3.BillingStreet = 'Teststr. 1';
        acc3.BillingCountry = 'China';
        acc3.BillingCity = 'Musterstadt';        
        acc3.ShippingCountry = 'China';
        acc3.ShippingStreet  = 'Teststr. 1';
        acc3.ShippingCity = 'Musterstadt';
        acc3.Company_Status__c='Open';        
        lstAccount.add(acc3);
        insert lstAccount; 
         
        test.startTest();

        lstAccount[0].Successor_Company__c = acc3.Id; 
        lstAccount[0].Reason_for_Deactivation__c = 'Out of Business';
        lstAccount[0].Company_Status__c = 'Out of Business';
        lstAccount[0].Active__c=true;
        update lstAccount[0];         
        
        Test.stopTest();}       
        
    }  
    
 
}