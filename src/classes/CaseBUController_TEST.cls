@isTest
Public Class CaseBUController_TEST
{
    static testmethod void TestCaseBUController()
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

      Test.startTest();
        
        System.runAs(u){
        insert c2;
        CaseBUController caseBU = new CaseBUController();
        CheckCaseBusinessUnitDetailClass.checkCaseBU(C2.id);
       // SendSubstitutesToCCRPclass.sendSubstitutes(c2.id);
       // SendCaseToCCRPClass.sendtoCCRP(c2.id);
        
        
        system.debug('SAI::AccountId'+ c2.AccountId);       
        system.debug('SAI::ContactId'+ c2.ContactId);
        system.debug('SAI::Description'+ c2.Description);
        system.debug('SAI::Category_2__c'+ c2.Category_2__c.equalsIgnoreCase('Complaints'));
        system.debug('SAI::CCRP_Status__c'+ c2.CCRP_Status__c);
        system.debug('SAI::RecordtypeId'+ c2.RecordtypeId); 
        //system.debug('SAI::complaintRecTypeId'+ c2.rt);         
        system.debug('SAI::Owner_Type__c'+ c2.Owner_Type__c);
        system.debug('SAI::OwnerUd'+ c2.OwnerId );
        
        
        ApexPages.currentPage().getParameters().put('id', c2.id);
        ApexPages.currentPage().getParameters().put('object', 'Case_BU__c');
        ApexPages.currentPage().getParameters().put('sfdc_created__c', '1');
        ApexPages.currentPage().getParameters().put('Case__c', c2.CaseNumber);
        ApexPages.currentPage().getParameters().put('ID_Case__c', c2.id);
        ApexPages.currentPage().getParameters().put('retURL', c2.id);           

        PageReference pageRef = Page.CaseBU;
        pageRef= caseBU.redirect();

        Schema.Sobjecttype oGenericObj = Schema.getGlobalDescribe().get('case');
        sObject oGeneric = oGenericObj.newSObject();
        StaticFunctions.createLabelParameters(pageRef,oGeneric);
        

        Test.StopTest();
    }
    }
 
    
    static testmethod void TestCaseBUController1()
    {
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
        C2.Business_unit__c ='DMMG - Motors & Generators';
        C2.contactid=con.id;
        C2.RecordTypeId =rt.ID;
        C2.Originating_Country__c = 'Bangladesh';
        C2.SuppliedEmail='abc@abc.com';    
        C2.accountid=acc.id;
        Test.startTest();
        insert c2;
        CaseBUController caseBU = new CaseBUController();
        CheckCaseBusinessUnitDetailClass.checkCaseBU(C2.id);
        ApexPages.currentPage().getParameters().put('id', c2.id);
        ApexPages.currentPage().getParameters().put('object', 'Case_BU__c');
        ApexPages.currentPage().getParameters().put('sfdc_created__c', '1');
        ApexPages.currentPage().getParameters().put('Case__c', c2.CaseNumber);
        ApexPages.currentPage().getParameters().put('ID_Case__c', c2.id);
        ApexPages.currentPage().getParameters().put('retURL', c2.id);           

        PageReference pageRef = Page.CaseBU;
        pageRef= caseBU.redirect();

        Schema.Sobjecttype oGenericObj = Schema.getGlobalDescribe().get('case');
        sObject oGeneric = oGenericObj.newSObject();
        StaticFunctions.createLabelParameters(pageRef,oGeneric);
        Test.StopTest();
    }
    static testmethod void TestCaseBUController3()
    {
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
        C2.Business_unit__c ='DMDR - Drives and Controls';
        C2.contactid=con.id;
        C2.RecordTypeId =rt.ID;
        C2.Originating_Country__c = 'Bangladesh';
        C2.SuppliedEmail='abc@abc.com';    
        C2.accountid=acc.id;
        Test.startTest();
        insert c2;
        CaseBUController caseBU = new CaseBUController();
        CheckCaseBusinessUnitDetailClass.checkCaseBU(C2.id);
        ApexPages.currentPage().getParameters().put('id', c2.id);
        ApexPages.currentPage().getParameters().put('object', 'Case_BU__c');
        ApexPages.currentPage().getParameters().put('sfdc_created__c', '1');
        ApexPages.currentPage().getParameters().put('Case__c', c2.CaseNumber);
        ApexPages.currentPage().getParameters().put('ID_Case__c', c2.id);
        ApexPages.currentPage().getParameters().put('retURL', c2.id);           

        PageReference pageRef = Page.CaseBU;
        pageRef= caseBU.redirect();

        Schema.Sobjecttype oGenericObj = Schema.getGlobalDescribe().get('case');
        sObject oGeneric = oGenericObj.newSObject();
        StaticFunctions.createLabelParameters(pageRef,oGeneric);
        Test.StopTest();
    }
    static testmethod void TestCaseBUController4()
    {
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
        C2.Business_unit__c ='DMPC - Power Conversion';
        C2.contactid=con.id;
        C2.RecordTypeId =rt.ID;
        C2.Originating_Country__c = 'Bangladesh';
        C2.SuppliedEmail='abc@abc.com';    
        C2.accountid=acc.id;
        Test.startTest();
        insert c2;
        CaseBUController caseBU = new CaseBUController();
        CheckCaseBusinessUnitDetailClass.checkCaseBU(C2.id);
        ApexPages.currentPage().getParameters().put('id', c2.id);
        ApexPages.currentPage().getParameters().put('object', 'Case_BU__c');
        ApexPages.currentPage().getParameters().put('sfdc_created__c', '1');
        ApexPages.currentPage().getParameters().put('Case__c', c2.CaseNumber);
        ApexPages.currentPage().getParameters().put('ID_Case__c', c2.id);
        ApexPages.currentPage().getParameters().put('retURL', c2.id);           

        PageReference pageRef = Page.CaseBU;
        pageRef= caseBU.redirect();

        Schema.Sobjecttype oGenericObj = Schema.getGlobalDescribe().get('case');
        sObject oGeneric = oGenericObj.newSObject();
        StaticFunctions.createLabelParameters(pageRef,oGeneric);
        Test.StopTest();
    }
    static testmethod void TestCaseBUController5()
    {
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
        C2.Business_unit__c ='EPBP - Building Products';
        C2.contactid=con.id;
        C2.RecordTypeId =rt.ID;
        C2.Originating_Country__c = 'Bangladesh';
        C2.SuppliedEmail='abc@abc.com';    
        C2.accountid=acc.id;
        Test.startTest();
        insert c2;
        CaseBUController caseBU = new CaseBUController();
        CheckCaseBusinessUnitDetailClass.checkCaseBU(C2.id);
        ApexPages.currentPage().getParameters().put('id', c2.id);
        ApexPages.currentPage().getParameters().put('object', 'Case_BU__c');
        ApexPages.currentPage().getParameters().put('sfdc_created__c', '1');
        ApexPages.currentPage().getParameters().put('Case__c', c2.CaseNumber);
        ApexPages.currentPage().getParameters().put('ID_Case__c', c2.id);
        ApexPages.currentPage().getParameters().put('retURL', c2.id);           

        PageReference pageRef = Page.CaseBU;
        pageRef= caseBU.redirect();

        Schema.Sobjecttype oGenericObj = Schema.getGlobalDescribe().get('case');
        sObject oGeneric = oGenericObj.newSObject();
        StaticFunctions.createLabelParameters(pageRef,oGeneric);
        Test.StopTest();
    }
    static testmethod void TestCaseBUController6()
    {
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
        C2.RecordTypeId =rt.ID;
        C2.Originating_Country__c = 'Bangladesh';
        C2.SuppliedEmail='abc@abc.com';    
        C2.accountid=acc.id;
        Test.startTest();
        insert c2;
        CaseBUController caseBU = new CaseBUController();
        CheckCaseBusinessUnitDetailClass.checkCaseBU(C2.id);
        ApexPages.currentPage().getParameters().put('id', c2.id);
        ApexPages.currentPage().getParameters().put('object', 'Case_BU__c');
        ApexPages.currentPage().getParameters().put('sfdc_created__c', '1');
        ApexPages.currentPage().getParameters().put('Case__c', c2.CaseNumber);
        ApexPages.currentPage().getParameters().put('ID_Case__c', c2.id);
        ApexPages.currentPage().getParameters().put('retURL', c2.id);           

        PageReference pageRef = Page.CaseBU;
        pageRef= caseBU.redirect();

        Schema.Sobjecttype oGenericObj = Schema.getGlobalDescribe().get('case');
        sObject oGeneric = oGenericObj.newSObject();
        StaticFunctions.createLabelParameters(pageRef,oGeneric);
        Test.StopTest();
    }
    static testmethod void TestCaseBUController7()
    {
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
        C2.Business_unit__c ='EPMV - Medium Voltage Products';
        C2.contactid=con.id;
        C2.RecordTypeId =rt.ID;
        C2.Originating_Country__c = 'Bangladesh';
        C2.SuppliedEmail='abc@abc.com';    
        C2.accountid=acc.id;
        Test.startTest();
        insert c2;
        CaseBUController caseBU = new CaseBUController();
        CheckCaseBusinessUnitDetailClass.checkCaseBU(C2.id);
        ApexPages.currentPage().getParameters().put('id', c2.id);
        ApexPages.currentPage().getParameters().put('object', 'Case_BU__c');
        ApexPages.currentPage().getParameters().put('sfdc_created__c', '1');
        ApexPages.currentPage().getParameters().put('Case__c', c2.CaseNumber);
        ApexPages.currentPage().getParameters().put('ID_Case__c', c2.id);
        ApexPages.currentPage().getParameters().put('retURL', c2.id);           

        PageReference pageRef = Page.CaseBU;
        pageRef= caseBU.redirect();

        Schema.Sobjecttype oGenericObj = Schema.getGlobalDescribe().get('case');
        sObject oGeneric = oGenericObj.newSObject();
        StaticFunctions.createLabelParameters(pageRef,oGeneric);
        Test.StopTest();
    }
    static testmethod void TestCaseBUController8()
    {
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
        C2.Business_unit__c ='PACT - Control Technologies';
        C2.contactid=con.id;
        C2.RecordTypeId =rt.ID;
        C2.Originating_Country__c = 'Bangladesh';
        C2.SuppliedEmail='abc@abc.com';    
        C2.accountid=acc.id;
        Test.startTest();
        insert c2;
        CaseBUController caseBU = new CaseBUController();
        CheckCaseBusinessUnitDetailClass.checkCaseBU(C2.id);
        ApexPages.currentPage().getParameters().put('id', c2.id);
        ApexPages.currentPage().getParameters().put('object', 'Case_BU__c');
        ApexPages.currentPage().getParameters().put('sfdc_created__c', '1');
        ApexPages.currentPage().getParameters().put('Case__c', c2.CaseNumber);
        ApexPages.currentPage().getParameters().put('ID_Case__c', c2.id);
        ApexPages.currentPage().getParameters().put('retURL', c2.id);           

        PageReference pageRef = Page.CaseBU;
        pageRef= caseBU.redirect();

        Schema.Sobjecttype oGenericObj = Schema.getGlobalDescribe().get('case');
        sObject oGeneric = oGenericObj.newSObject();
        StaticFunctions.createLabelParameters(pageRef,oGeneric);
        Test.StopTest();
    }
    static testmethod void TestCaseBUController9()
    {
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
        C2.Business_unit__c ='PAMP - Measurement & Analytics';
        C2.contactid=con.id;
        C2.RecordTypeId =rt.ID;
        C2.Originating_Country__c = 'Bangladesh';
        C2.SuppliedEmail='abc@abc.com';    
        C2.accountid=acc.id;
        Test.startTest();
        insert c2;
        CaseBUController caseBU = new CaseBUController();
        CheckCaseBusinessUnitDetailClass.checkCaseBU(C2.id);
        ApexPages.currentPage().getParameters().put('id', c2.id);
        ApexPages.currentPage().getParameters().put('object', 'Case_BU__c');
        ApexPages.currentPage().getParameters().put('sfdc_created__c', '1');
        ApexPages.currentPage().getParameters().put('Case__c', c2.CaseNumber);
        ApexPages.currentPage().getParameters().put('ID_Case__c', c2.id);
        ApexPages.currentPage().getParameters().put('retURL', c2.id);           

        PageReference pageRef = Page.CaseBU;
        pageRef= caseBU.redirect();

        Schema.Sobjecttype oGenericObj = Schema.getGlobalDescribe().get('case');
        sObject oGeneric = oGenericObj.newSObject();
        StaticFunctions.createLabelParameters(pageRef,oGeneric);
        Test.StopTest();
    }
    static testmethod void TestCaseBUController10()
    {
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
        C2.Business_unit__c ='PAOG - Oil, Gas & Chemicals';
        C2.contactid=con.id;
        C2.RecordTypeId =rt.ID;
        C2.Originating_Country__c = 'Bangladesh';
        C2.SuppliedEmail='abc@abc.com';    
        C2.accountid=acc.id;
        Test.startTest();
        insert c2;
        CaseBUController caseBU = new CaseBUController();
        CheckCaseBusinessUnitDetailClass.checkCaseBU(C2.id);
        ApexPages.currentPage().getParameters().put('id', c2.id);
        ApexPages.currentPage().getParameters().put('object', 'Case_BU__c');
        ApexPages.currentPage().getParameters().put('sfdc_created__c', '1');
        ApexPages.currentPage().getParameters().put('Case__c', c2.CaseNumber);
        ApexPages.currentPage().getParameters().put('ID_Case__c', c2.id);
        ApexPages.currentPage().getParameters().put('retURL', c2.id);           

        PageReference pageRef = Page.CaseBU;
        pageRef= caseBU.redirect();

        Schema.Sobjecttype oGenericObj = Schema.getGlobalDescribe().get('case');
        sObject oGeneric = oGenericObj.newSObject();
        StaticFunctions.createLabelParameters(pageRef,oGeneric);
        Test.StopTest();
    }
    static testmethod void TestCaseBUController11()
    {
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
        C2.Business_unit__c ='PAPG - Power Generation';
        C2.contactid=con.id;
        C2.RecordTypeId =rt.ID;
        C2.Originating_Country__c = 'Bangladesh';
        C2.SuppliedEmail='abc@abc.com';    
        C2.accountid=acc.id;
        Test.startTest();
        insert c2;
        CaseBUController caseBU = new CaseBUController();
        CheckCaseBusinessUnitDetailClass.checkCaseBU(C2.id);
        ApexPages.currentPage().getParameters().put('id', c2.id);
        ApexPages.currentPage().getParameters().put('object', 'Case_BU__c');
        ApexPages.currentPage().getParameters().put('sfdc_created__c', '1');
        ApexPages.currentPage().getParameters().put('Case__c', c2.CaseNumber);
        ApexPages.currentPage().getParameters().put('ID_Case__c', c2.id);
        ApexPages.currentPage().getParameters().put('retURL', c2.id);           

        PageReference pageRef = Page.CaseBU;
        pageRef= caseBU.redirect();

        Schema.Sobjecttype oGenericObj = Schema.getGlobalDescribe().get('case');
        sObject oGeneric = oGenericObj.newSObject();
        StaticFunctions.createLabelParameters(pageRef,oGeneric);
        Test.StopTest();
    }
    static testmethod void TestCaseBUController12()
    {
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
        C2.Business_unit__c ='PAPI - Process Industries';
        C2.contactid=con.id;
        C2.RecordTypeId =rt.ID;
        C2.Originating_Country__c = 'Bangladesh';
        C2.SuppliedEmail='abc@abc.com';    
        C2.accountid=acc.id;
        Test.startTest();
        insert c2;
        CaseBUController caseBU = new CaseBUController();
        CheckCaseBusinessUnitDetailClass.checkCaseBU(C2.id);
        ApexPages.currentPage().getParameters().put('id', c2.id);
        ApexPages.currentPage().getParameters().put('object', 'Case_BU__c');
        ApexPages.currentPage().getParameters().put('sfdc_created__c', '1');
        ApexPages.currentPage().getParameters().put('Case__c', c2.CaseNumber);
        ApexPages.currentPage().getParameters().put('ID_Case__c', c2.id);
        ApexPages.currentPage().getParameters().put('retURL', c2.id);           

        PageReference pageRef = Page.CaseBU;
        pageRef= caseBU.redirect();

        Schema.Sobjecttype oGenericObj = Schema.getGlobalDescribe().get('case');
        sObject oGeneric = oGenericObj.newSObject();
        StaticFunctions.createLabelParameters(pageRef,oGeneric);
        Test.StopTest();
    }
        static testmethod void TestCaseBUController13()
    {
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
        C2.Business_unit__c ='PGGA - Grid Automation';
        C2.contactid=con.id;
        C2.RecordTypeId =rt.ID;
        C2.Originating_Country__c = 'Bangladesh';
        C2.SuppliedEmail='abc@abc.com';    
        C2.accountid=acc.id;
        Test.startTest();
        insert c2;
        CaseBUController caseBU = new CaseBUController();
        CheckCaseBusinessUnitDetailClass.checkCaseBU(C2.id);
        ApexPages.currentPage().getParameters().put('id', c2.id);
        ApexPages.currentPage().getParameters().put('object', 'Case_BU__c');
        ApexPages.currentPage().getParameters().put('sfdc_created__c', '1');
        ApexPages.currentPage().getParameters().put('Case__c', c2.CaseNumber);
        ApexPages.currentPage().getParameters().put('ID_Case__c', c2.id);
        ApexPages.currentPage().getParameters().put('retURL', c2.id);           

        PageReference pageRef = Page.CaseBU;
        pageRef= caseBU.redirect();

        Schema.Sobjecttype oGenericObj = Schema.getGlobalDescribe().get('case');
        sObject oGeneric = oGenericObj.newSObject();
        StaticFunctions.createLabelParameters(pageRef,oGeneric);
        Test.StopTest();
    }
    static testmethod void TestCaseBUController14()
    {
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
        C2.Business_unit__c ='PGGI - Grid Integration';
        C2.contactid=con.id;
        C2.RecordTypeId =rt.ID;
        C2.Originating_Country__c = 'Bangladesh';
        C2.SuppliedEmail='abc@abc.com';    
        C2.accountid=acc.id;
        Test.startTest();
        insert c2;
        CaseBUController caseBU = new CaseBUController();
        CheckCaseBusinessUnitDetailClass.checkCaseBU(C2.id);
        ApexPages.currentPage().getParameters().put('id', c2.id);
        ApexPages.currentPage().getParameters().put('object', 'Case_BU__c');
        ApexPages.currentPage().getParameters().put('sfdc_created__c', '1');
        ApexPages.currentPage().getParameters().put('Case__c', c2.CaseNumber);
        ApexPages.currentPage().getParameters().put('ID_Case__c', c2.id);
        ApexPages.currentPage().getParameters().put('retURL', c2.id);           

        PageReference pageRef = Page.CaseBU;
        pageRef= caseBU.redirect();

        Schema.Sobjecttype oGenericObj = Schema.getGlobalDescribe().get('case');
        sObject oGeneric = oGenericObj.newSObject();
        StaticFunctions.createLabelParameters(pageRef,oGeneric);
        Test.StopTest();
    }
        static testmethod void TestCaseBUController15()
    {
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
        C2.Business_unit__c ='PGGS - Grid Systems';
        C2.contactid=con.id;
        C2.RecordTypeId =rt.ID;
        C2.Originating_Country__c = 'Bangladesh';
        C2.SuppliedEmail='abc@abc.com';    
        C2.accountid=acc.id;
        Test.startTest();
        insert c2;
        CaseBUController caseBU = new CaseBUController();
        CheckCaseBusinessUnitDetailClass.checkCaseBU(C2.id);
        ApexPages.currentPage().getParameters().put('id', c2.id);
        ApexPages.currentPage().getParameters().put('object', 'Case_BU__c');
        ApexPages.currentPage().getParameters().put('sfdc_created__c', '1');
        ApexPages.currentPage().getParameters().put('Case__c', c2.CaseNumber);
        ApexPages.currentPage().getParameters().put('ID_Case__c', c2.id);
        ApexPages.currentPage().getParameters().put('retURL', c2.id);           

        PageReference pageRef = Page.CaseBU;
        pageRef= caseBU.redirect();

        Schema.Sobjecttype oGenericObj = Schema.getGlobalDescribe().get('case');
        sObject oGeneric = oGenericObj.newSObject();
        StaticFunctions.createLabelParameters(pageRef,oGeneric);
        Test.StopTest();
    }

}