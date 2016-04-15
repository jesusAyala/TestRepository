/*
*  This test class used to test class addNewOpportunityOnCaptureTeam.
*
@author Aswini Arasu
@created 2015-12-23
@version 1.0  
*/
@istest(SeeAllData = False)
  public class addNewOpportunityOnCaptureTeamTest{

    static testMethod void  methodTest(){
     Test.StartTest();
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
    a.Name = 'Acciona, S.A';
    a.BillingStreet = 'dajie';
    a.BillingCity = 'berlin';
    a.BillingState = 'Berlin';
    a.BillingPostalCode = '20012';
    a.BillingCountry = 'Germany';
    insert a;
    
    End_User_Project__c eu = new End_User_Project__c();
    eu.Name = 'Test';
    eu.Account_End_User__c = a.id;
    eu.End_User_Project_Status__c = 'Open';
    insert eu;
    
    Capture_Team__c cap = new Capture_Team__c();
    cap.Name = 'TestCap';
    cap.End_User_Project__c = eu.id;    
    insert cap;
    
    //RecordType ft = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Opportunity' and DeveloperName = 'Fast_Track'];  
    RecordType rg = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Opportunity' and DeveloperName = 'Regular'];
    Opportunity o = new Opportunity();
    o.AccountId = a.id;
   // o.RecordtypeId = rg.id;
    //o.Account_End_User__c =a.id;
    o.End_User_Project__c = eu.id;
    o.Name = 'ES-Acciona, S.A-Test';
    o.StageName = 'Prospecting';
    o.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    o.Specific_Opportunity_Info__c ='Test';
    o.Confidence_Level__c ='No Delay Expected';    
    o.CloseDate = date.today();    
    o.Industry_Usage__c = 'BLD.10.1';
    o.Channel_Class__c = 'DIS-Distributor';
    o.Customer_Buying_Path__c = 'Awareness';
    o.Opportunity_Winner__c = a.id;
    //o.Capture_Team__c = cap.id;   
    
    /*Opportunity o1 = new Opportunity();
    o1.AccountId = a.id;
    //o1.RecordtypeId = rg.id;
    //o1.Account_End_User__c =a.id;
    o1.End_User_Project__c = eu.id;
    o1.Name = 'TestOpp';
    o1.StageName = 'Prospecting';
    o1.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    o1.Specific_Opportunity_Info__c ='Test';
    o1.Confidence_Level__c ='No Delay Expected';    
    o1.CloseDate = date.today();    
    o1.Industry_Usage__c = 'BLD.10.1';
    o1.Channel_Class__c = 'DIS-Distributor';
    o1.Customer_Buying_Path__c = 'Awareness';
    o1.Opportunity_Winner__c = a.id;
    //o1.Capture_Team__c = cap.id; */
    
    List<Opportunity> lstopps = new List<Opportunity>();
    lstopps.add(o);
    //lstopps.add(o1);
    insert lstopps;
    
    //ApexPages.currentPage().getParameters().put('Id',+cap.Id);    
    PageReference pageRef = Page.Add_New_Opportunity_on_Capture_Team; 
    pageRef.getParameters().put('id', String.valueOf(cap.Id));
    Test.setCurrentPage(pageRef);
    
    ApexPages.StandardSetController stdOpp = new ApexPages.StandardSetController(lstopps);
    stdOpp.setSelected(lstopps);
    addNewOpportunityOnCaptureTeam objController  =  new addNewOpportunityOnCaptureTeam(stdOpp);    
    objController.getOpportunities();
    
    addNewOpportunityOnCaptureTeam.OpportunityWrapper obj = new addNewOpportunityOnCaptureTeam.OpportunityWrapper();
    
    List<addNewOpportunityOnCaptureTeam.OpportunityWrapper> opportunities = objController.getOpportunities();
    for(addNewOpportunityOnCaptureTeam.OpportunityWrapper w : opportunities)
    {
        w.selected = true;
    }
    
    objController.addSelectedOpportunities();
    objController.back();
    Test.StopTest();
    }
    }
    }