/**
*  This test class used to test class SendLeadsToNPSClass.
*    
@author Rajesh K    
@created 2016-03-23
@version 1.0 
* 
*/
@isTest(seeAlldata = true)
Public Class SendLeadsToNPSClass_TEST
{
    static testmethod void SendLeadsToNPSClass_test1()
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
        u.FederationIdentifier = 'test@abb.com';
        insert u;
        RecordType rect = [Select Id from RecordType where Name = 'Contact Center'];
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
        acc.Root_Account_GUID__c = 'ABC1213';
        acc.Account_Type__c = 'Group';
        Insert acc;
        
        Account acc1 = new Account(); 
        acc1.Name = 'Test1';
        acc1.BillingStreet = 'dajie';
        acc1.BillingCity = 'berlin';
        acc1.BillingState = 'Berlin';
        acc1.BillingPostalCode = '20012';
        acc1.BillingCountry = 'Germany';
        acc1.rating='Hot';
        acc1.industry='Manufacturing';
        acc1.Phone='+41 123 123456';
        acc1.Type='Prospect';
        acc1.Active__C= true;
        acc1.guid__c = 'ABC1213';
        acc1.Account_Type__c = 'Group';
        Insert acc1;
        
        Contact con = new Contact ();
        con.firstname ='Test';
        con.lastname='Contact1';
        con.email='test@test.com';
        con.phone='9988776600';
        con.accountid=acc.id;
        insert con;
                
        Lead la =new Lead();
        la.Salutation = 'Mr.';
        la.FirstName = 'test';
        la.LastName ='saipppp';
        la.Company = 'ABB';
        la.Status ='Contacted';
        la.Subject__c = 'fjkdnmkan';
        la.Description ='mfldsfkgj;lklhglklkgfkg';
        la.Originating_Country__c ='India';
        //la.Address ='jfdm,nagdf';
        la.Division__c= 'DM';
        la.Business_Unit__c= 'DMDR';
        la.Product_Group__c = '1339 - Non-Core Various';
        la.Request_Type__c = 'Sales';
        la.Applicable_for_NPS_Survey__c= true;
        //la.NPS_Survey_Reminder_Needed__c = true;
        la.Participant_reminder__c= system.today()+1;
        la.Description__c ='fdkksnmfgl';
        la.NPS_Survey_Status__c = '123';
        la.Lead_Origin__c ='Phone';
        la.country = 'Brazil';
        la.Email ='abc@abc.com';
        la.Phone ='41 123 1234567';
        la.NPS_ID__c = null;
        la.Related_existing_Contact__c= con.id;
        la.Related_Account__c = acc.id;
        la.RecordTypeID = rect.ID;
        insert la;
        
        System.debug('Final: '+la.NPS_Ready__c);
        List<ID> lstLead = new List<ID>();
        lstLead.add(la.id);
        Test.startTest();
            SendLeadsToNPSClass.validator(lstLead);
        Test.StopTest();   
    }
    static testmethod void SendLeadsToNPSClass_test2()
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
        u.FederationIdentifier = 'test@abb.com';
        insert u;
        RecordType rect = [Select Id from RecordType where Name = 'Contact Center'];
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
        acc.Root_Account_GUID__c = 'ABC1213';
        acc.Account_Type__c = 'Group';
        Insert acc;
        
        Account acc1 = new Account(); 
        acc1.Name = 'Test1';
        acc1.BillingStreet = 'dajie';
        acc1.BillingCity = 'berlin';
        acc1.BillingState = 'Berlin';
        acc1.BillingPostalCode = '20012';
        acc1.BillingCountry = 'Germany';
        acc1.rating='Hot';
        acc1.industry='Manufacturing';
        acc1.Phone='+41 123 123456';
        acc1.Type='Prospect';
        acc1.Active__C= true;
        acc1.guid__c = 'ABC1213';
        acc1.Account_Type__c = 'Group';
        Insert acc1;
        
        Contact con = new Contact ();
        con.firstname ='Test';
        con.lastname='Contact1';
        con.email='test@test.com';
        con.phone='9988776600';
        con.accountid=acc.id;
        insert con;
                
        Lead la =new Lead();
        la.Salutation = 'Mr.';
        la.FirstName = 'test';
        la.LastName ='saipppp';
        la.Company = 'ABB';
        la.Status ='Contacted';
        la.Subject__c = 'fjkdnmkan';
        la.Description ='mfldsfkgj;lklhglklkgfkg';
        la.Originating_Country__c ='India';
        //la.Address ='jfdm,nagdf';
        la.Division__c= 'DM';
        la.Business_Unit__c= 'DMDR';
        la.Product_Group__c = '1339 - Non-Core Various';
        la.Request_Type__c = 'Sales';
        la.Applicable_for_NPS_Survey__c= true;
        //la.NPS_Survey_Reminder_Needed__c = true;
        la.Participant_reminder__c= system.today()+1;
        la.Description__c ='fdkksnmfgl';
        la.NPS_Survey_Status__c = '123';
        la.Lead_Origin__c ='Phone';
        la.country = 'Brazil';
        la.Email ='abc@abc.com';
        la.Phone ='41 123 1234567';
        la.NPS_ID__c = null;
        la.Related_existing_Contact__c= null;
        la.Related_Account__c = null;
        la.RecordTypeID = rect.ID;
        insert la;
        
        System.debug('Final: '+la.NPS_Ready__c);
        List<ID> lstLead = new List<ID>();
        lstLead.add(la.id);
        Test.startTest();
            //Test.setMock(HttpCalloutMock.class, new SendCCRPProductMockHttpResponseGen());
            SendLeadsToNPSClass.validator(lstLead);
        Test.StopTest();   
    }
}