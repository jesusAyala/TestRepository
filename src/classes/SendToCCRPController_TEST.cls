/**
*  This test class used to test class SendToCCRPController.
*    
@author Rajesh K    
@created 2016-03-22
@version 1.0 
* 
*/
@isTest
Public Class SendToCCRPController_TEST
{
    static testmethod void SendToCCRPController_test1()
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
        c2.Product_Category__c = 'test';
        c2.Customer_Reference__c = 'test';
        c2.Severity__c = 'High';
        c2.Target_Resolution_Date__c = System.today() + 1;
        c2.Division__c = 'DM';
        c2.Product_Group__c = 'TEST';
        c2.Serial_Number__c = '23413';
        c2.ABB_Order_Number__c = 'TEST';
        c2.Sales_Order_Number__c = '234123';
        c2.Purchase_Order_Number__c = '234123';
        c2.Service_Agreement__c = 'test';
        c2.SAP_Number__c = '314';
        c2.Project_Number__c = '123434';
        insert c2;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SendCCRPProductMockHttpResponseGen());
        apexpages.currentpage().getparameters().put('id', c2.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(c2);
        SendToCCRPController objccrp = new SendToCCRPController(sc);  
        objccrp.strSubstituteFedId = 'test@abb.com';
        objccrp.updatestatus();
        Test.StopTest();   
    }
}