/**
*  This test class used to test class OpptyScreeningApprovalEmailController.
*
@author Aswini Arasu
@created 2016-03-21
@version 1.0  
*/
@istest(SeeAllData = False)
private class OpptyScreeningAppEmailCtlrTest{
static testMethod void getOpportunityScreeningSOTest(){
   
     Profile p = [SELECT id FROM profile WHERE name = 'System Administrator'];
     User u1 = new User(alias = 'chfree01',
     email = 'chatterfreeuser101@testorg.com',
     emailencodingkey = 'UTF-8',
     lastname = 'Testing',
     companyname = 'testorg',
     languagelocalekey = 'en_US',
     localesidkey = 'en_US',
     profileId = p.Id,
     timezonesidkey = 'America/Los_Angeles',
     username = 'chatterfreeuser101@testorg.com');
    insert u1;
    System.runAs(u1){
    Account a = new Account();
    a.Name = 'test';
    a.BillingStreet = 'dajie';
    a.BillingCity = 'berlin';
    a.BillingState = 'Berlin';
    a.BillingPostalCode = '20012';
    a.BillingCountry = 'Germany';
    insert a;
    
    Opportunity o = new Opportunity();
    o.AccountId = a.id;
    o.Name = 'ES-Acciona, S.A-Test';
    o.StageName = 'Prospecting';
    o.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    o.Specific_Opportunity_Info__c ='Test';
    o.Confidence_Level__c ='No Delay Expected';
    o.CloseDate = date.today();
    o.Industry_Usage__c = 'BLD.10.1';
    o.Customer_Buying_Path__c = 'Awareness';
    o.Opportunity_Winner__c = a.id;
    insert o;
    
    Opportunity_Screening__c ops = new Opportunity_Screening__c ();
    ops.Opportunity__c = o.id;
    ops.Gate_Status__c = 'BID';
    insert ops;
    
    Apttus_Approval__Approval_Request__c appReq = new Apttus_Approval__Approval_Request__c();
    appReq.Apttus_Approval__Object_Id__c = ops.id;
    appReq.Apttus_Approval__Approval_Status__c = 'Submitted';
    //appReq.Apttus_Approval__Object_Type__c = Opportunity_Screening__c;
    appReq.Apttus_Approval__Active__c = True;
    insert appReq;
    
    Test.StartTest();
    OpptyScreeningApprovalEmailController objController = new OpptyScreeningApprovalEmailController ();
    try{
    Opportunity_Screening__c os=objController.getOpportunityScreeningSO();
    }
    catch(Exception e){System.debug(e);}
    Opportunity_Screening__c os1=OpptyScreeningApprovalEmailController.getOpportunityScreeningSO(appReq.Apttus_Approval__Object_Id__c) ;
    Apttus_Approval.ContextApprovalEmailController c= objController.getContext();
    Test.StopTest();
    }
    }
    }