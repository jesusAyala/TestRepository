@isTest
Public Class SendToNPSListController_TEST
{
    static testmethod void SendCaseToCCRPClass_TEST1()
    {
        RecordType rt = [Select Id from RecordType where Name = 'Contact Center'];
        
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
        insert acc;
        
        Contact con = new Contact ();
        con.firstname ='Test'; 
        con.lastname='Contact1';
        con.email='test@test.com';
        con.phone='78545454';
        con.accountid=acc.id;
        insert con;
        

        Lead la =new Lead();
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
        la.NPS_Survey_Reminder_Needed__c = true;
        la.Participant_reminder__c= system.today()+1;
        la.Description__c ='fdkksnmfgl';
        la.NPS_Survey_Status__c = '123';
        la.Lead_Origin__c ='Web';
        
        la.Email ='abc@abc.com';
        la.Phone ='41 123 1234567';
        //la.NPS_ID__c = '';
       la.Related_existing_Contact__c= con.id;
        la.RecordTypeID =rt.ID;
        List<id> lids= new List<id>();

        test.startTest();
           insert la;
           lids.add(la.id);
           //string id =la.id;
           ApexPages.currentPage().getParameters().put('lrecs', la.id);
           SendToNPSListController scrrp = new  SendToNPSListController(new ApexPages.StandardController(new Lead()));
             ApexPages.currentPage().getParameters().put('id', la.id);
             PageReference pageRef = scrrp.validator();
            PageReference pageRef1 = scrrp.back();
            Test.StopTest();

    }
    static testmethod void SendCaseToCCRPClass_TEST2()
    {
        RecordType rt = [Select Id from RecordType where Name = 'Contact Center'];
        
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
        insert acc;
        
        Contact con = new Contact ();
        con.firstname ='Test'; 
        con.lastname='Contact1';
        con.email='test@test.com';
        con.phone='78545454';
        con.accountid=acc.id;
        insert con;
        

        Lead la =new Lead();
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
        la.NPS_Survey_Reminder_Needed__c = true;
        la.Participant_reminder__c= system.today()+1;
        la.Description__c ='fdkksnmfgl';
        //la.NPS_Survey_Status__c = '';
        la.Lead_Origin__c ='Web';
        
        la.Email ='abc@abc.com';
        la.Phone ='41 123 1234567';
        //la.NPS_ID__c = '';
       la.Related_existing_Contact__c= con.id;
        la.RecordTypeID =rt.ID;
        List<id> lids= new List<id>();

        test.startTest();
           insert la;
           lids.add(la.id);
           //string id =la.id;
           ApexPages.currentPage().getParameters().put('lrecs', la.id);
           SendToNPSListController scrrp = new  SendToNPSListController(new ApexPages.StandardController(new Lead()));
             ApexPages.currentPage().getParameters().put('id', la.id);
             PageReference pageRef = scrrp.validator();
            PageReference pageRef1 = scrrp.back();

            Test.StopTest();

    }
 }