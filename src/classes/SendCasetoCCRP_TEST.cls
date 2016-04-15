/**
*  This test class used to test class SendCasetoCCRPClass and SendSubstitutesToCCRPclass
*    
@author Saiprasad Telkapally
@version 1.0 
* 
*/
@isTest
Public Class SendCasetoCCRP_TEST
{
    static testmethod void SendCasetoCCRP_TEST1()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        String uName = 'userIsTestinProd@testisUser.test';
        User u = new User();
        u.Alias = 'zdxzxz'; 
        u.Email='email@email.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='Testing'; 
        u.LanguageLocaleKey='en_US'; 
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='userIsTestinProd@testisUser.test';
        insert u;
        
     /*    User u1 = new User(alias = 'zdxzxz', email='kbrazi@salesforce.com',
                            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='fr',
                            localesidkey='fr_FR_EURO', profileid = p.Id, country='France',
                            timezonesidkey='Europe/Paris', username='userIsTestinProd@testisUser.test',
                            IsActive = true);
    insert u1; */
        
        System.runAs(u){
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
        c2.Category_2__c ='Complaints';
       // c2.CCRP_Status__c =null;
       c2.Description = 'sai213';
        C2.SuppliedEmail='abc@abc.com';    
        C2.accountid=acc.id;
        c2.OwnerID =  u.id;
        
        System.assert(c2!=null);
         insert c2;

         
        
        system.debug('sai::accountid:::'+C2.accountid);
        system.debug('sai::::ContactId:::'+c2.ContactId);
        system.debug('sai::::Description::'+c2.Description);
        system.debug('sai::::RecordTypeId:'+ C2.RecordTypeId);
  
       CaseTeamRole CTR = new CaseTeamRole();
       CTR.AccessLevel='Edit';
       CTR.Name='Test Case Team Role';
       CTR.PreferencesVisibleInCSP=true;
        insert CTR;
        
      List<CaseTeamMember> CTMs = new List<CaseTeamMember>();
        CaseTeamMember CTM = new CaseTeamMember();
        CTM.MemberId=u.id;
        CTM.ParentId= c2.ID;
        CTM.TeamRoleId = CTR.Id;
        CTMs.add(CTM);

        Test.startTest();
      //  insert c2;
        insert CTMs;
      
        SendSubstitutesToCCRPclass.sendSubstitutes(c2.id);
        SendCaseToCCRPClass.sendtoCCRP(c2.id);    
        Test.StopTest();
    }
    }
    static testmethod void SendCasetoCCRP_TEST2()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User();
        u.Alias = 'zdxzyz'; 
        u.Email='email@email.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='Testing'; 
        u.LanguageLocaleKey='en_US'; 
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='userIsTestinProd@testisUser.test2';
        insert u;
        
     /*    User u1 = new User(alias = 'zdxzyz', email='kbrazi@salesforce.com',
                            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='fr',
                            localesidkey='fr_FR_EURO', profileid = p.Id, country='France',
                            timezonesidkey='Europe/Paris', username='userIsTestinProd@testisUser.test2',
                            IsActive = true);
    insert u1; */
        
        System.runAs(u){
        RecordType rt = [Select Id from RecordType where DeveloperName = 'Complaint'];
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
        c2.Category_2__c ='Complaints';
       // c2.CCRP_Status__c =null;
       c2.Description = 'sai213';
        C2.SuppliedEmail='abc@abc.com';    
        C2.accountid=acc.id;
        c2.OwnerID =  u.id;
        
        System.assert(c2!=null);
         insert c2;

       CaseTeamRole CTR = new CaseTeamRole();
       CTR.AccessLevel='Edit';
       CTR.Name='Test Case Team Role';
       CTR.PreferencesVisibleInCSP=true;
        insert CTR;
        
      List<CaseTeamMember> CTMs = new List<CaseTeamMember>();
        CaseTeamMember CTM = new CaseTeamMember();
        CTM.MemberId=u.id;
        CTM.ParentId= c2.ID;
        CTM.TeamRoleId = CTR.Id;
        CTMs.add(CTM);

        Test.startTest();
      //  insert c2;
      insert CTMs;
        Delete CTMs;
      
        SendSubstitutesToCCRPclass.sendSubstitutes(c2.id);
        SendCaseToCCRPClass.sendtoCCRP(c2.id);    
        Test.StopTest();
    }
    }
}