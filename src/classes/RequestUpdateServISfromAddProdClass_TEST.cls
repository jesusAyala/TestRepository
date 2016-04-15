/**
*  This test class used to test class RequestUpdateToServISfromAddProdClass.
*    
@author Rajesh K    
@created 2016-03-22
@version 1.0 
* 
*/
@isTest
Public Class RequestUpdateServISfromAddProdClass_TEST
{
    static testmethod void RequestUpdateServISfromAddProdClass_test1()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        User u = new User();
        u.Alias = 'email'; 
        u.Email='email@email.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='Testing'; 
        u.LanguageLocaleKey='en_US'; 
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='email@testcoverage.com';
        insert u;

        RecordType rt = [Select Id from RecordType where DeveloperName = 'Services'];
        Account acc = new Account(); 
        acc.Name = 'Test1';
        acc.BillingStreet = 'dajie';
        acc.BillingCity = 'berlin';
        acc.BillingState = 'Berlin';
        acc.BillingPostalCode = '20012';
        acc.BillingCountry = 'Germany';
        acc.rating='Hot';
        acc.industry='Manufacturing';
        acc.Phone='+41 123 123456';
        acc.Type='Prospect';
        acc.Active__C= true;
        Insert acc;
        
        Contact con = new Contact ();
        con.firstname ='Test';
        con.lastname='Contact1';
        con.email='test@test.com';
        con.phone='9988776600';
        con.accountid=acc.id;
        insert con;
        
        Case c2 = new Case();
        C2.subject = 'TestCase 1';
        C2.status ='Open';
        C2.type='Mechanical';
        C2.reason='Installation';
        C2.Business_unit__c ='EPCP - Control Products';
        C2.contactid=con.id;
        C2.RecordTypeId = rt.ID;
        C2.Originating_Country__c = 'Bangladesh';
        c2.Category_2__c ='Homologation';
        c2.CCRP_Status__c ='qw1';
        c2.Description = 'fhshfks';
        C2.SuppliedEmail='abc@abc.com';    
        C2.accountid=acc.id;
        c2.OwnerID =  u.id;
        insert c2;
        
        Additional_Product__c oAP = new Additional_Product__c();
        oAP.Case__c = c2.id;
        oAP.Purchase_Order__c = '2333';
        oAP.Serial_Number__c = '2221';
        insert oAP;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ServeISProductMockHttpResponseGen1());

        RequestUpdateToServISfromAddProdClass.requestUpdatetoServis(oAP.id);     
        Test.StopTest();   
    }
    static testmethod void RequestUpdateToServISfromAddProdClass_test2()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        User u = new User();
        u.Alias = 'email'; 
        u.Email='email@email.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='Testing'; 
        u.LanguageLocaleKey='en_US'; 
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='email@testcoverage.com';
        insert u;

        RecordType rt = [Select Id from RecordType where DeveloperName = 'Services'];
        Account acc = new Account(); 
        acc.Name = 'Test1';
        acc.BillingStreet = 'dajie';
        acc.BillingCity = 'berlin';
        acc.BillingState = 'Berlin';
        acc.BillingPostalCode = '20012';
        acc.BillingCountry = 'Germany';
        acc.rating='Hot';
        acc.industry='Manufacturing';
        acc.Phone='+41 123 123456';
        acc.Type='Prospect';
        acc.Active__C= true;
        Insert acc;
        
        Contact con = new Contact ();
        con.firstname ='Test';
        con.lastname='Contact1';
        con.email='test@test.com';
        con.phone='9988776600';
        con.accountid=acc.id;
        insert con;
        
        Case c2 = new Case();
        C2.subject = 'TestCase 1';
        C2.status ='Open';
        C2.type='Mechanical';
        C2.reason='Installation';
        C2.Business_unit__c ='EPCP - Control Products';
        C2.contactid=con.id;
        C2.RecordTypeId = rt.ID;
        C2.Originating_Country__c = 'Bangladesh';
        c2.Category_2__c ='Homologation';
        c2.CCRP_Status__c ='qw1';
        c2.Description = 'fhshfks';
        C2.SuppliedEmail='abc@abc.com';    
        C2.accountid=acc.id;
        c2.OwnerID =  u.id;
        insert c2;
        
        Additional_Product__c oAP = new Additional_Product__c();
        oAP.Case__c = c2.id;
        oAP.Purchase_Order__c = '2333';
        oAP.Serial_Number__c = '2221';
        insert oAP;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ServeISProductMockHttpResponseGen2());

        RequestUpdateToServISfromAddProdClass.requestUpdatetoServis(oAP.id);     
        Test.StopTest();   
    }
}