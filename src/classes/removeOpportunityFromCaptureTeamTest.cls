/*
*  This test class used to test class removeOpportunityFromCaptureTeam.
*
@author Aswini Arasu
@created 2015-03-16
@version 1.0  
*/
@istest(SeeAllData = False)
  public class removeOpportunityFromCaptureTeamTest{

    static testMethod void  methodTest(){
    
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
    a.Name = 'TestAccount';
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
   // RecordType rg = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Opportunity' and DeveloperName = 'Regular'];
    Opportunity o = new Opportunity();
    o.AccountId = a.id;
   // o.RecordtypeId = rg.id;
    //o.Account_End_User__c =a.id;
    o.End_User_Project__c = eu.id;
    o.Name = 'TestOpportunity';
    o.StageName = 'Prospecting';
    o.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    o.Specific_Opportunity_Info__c ='Test';
    o.Confidence_Level__c ='No Delay Expected';    
    o.CloseDate = date.today();    
    o.Industry_Usage__c = 'BLD.10.1';
    o.Channel_Class__c = 'DIS-Distributor';
    o.Customer_Buying_Path__c = 'Awareness';
    o.Opportunity_Winner__c = a.id;
    o.Capture_Team__c = cap.id;   
    
   /* Opportunity o1 = new Opportunity();
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
    o1.Capture_Team__c = cap.id; 
    
    Opportunity o2 = new Opportunity();
    o2.AccountId = a.id;
    //o1.RecordtypeId = rg.id;
    //o1.Account_End_User__c =a.id;
    o2.End_User_Project__c = eu.id;
    o2.Name = 'TestOpp';
    o2.StageName = 'Prospecting';
    o2.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    o2.Specific_Opportunity_Info__c ='Test';
    o2.Confidence_Level__c ='No Delay Expected';    
    o2.CloseDate = date.today();    
    o2.Industry_Usage__c = 'BLD.10.1';
    o2.Channel_Class__c = 'DIS-Distributor';
    o2.Customer_Buying_Path__c = 'Awareness';
    o2.Opportunity_Winner__c = a.id; */
    
    List<Opportunity> lstopps = new List<Opportunity>();
    lstopps.add(o);
    //lstopps.add(o1);
   // lstopps.add(o2);
    insert lstopps;
    
    //ApexPages.currentPage().getParameters().put('Id',+cap.Id);    
    
    //delete lstopps;
    Test.StartTest();
    PageReference pageRef = Page.Remove_Opportunity_From_Capture_Team; 
    pageRef.getParameters().put('id', String.valueOf(cap.Id));
    Test.setCurrentPage(pageRef);
    
    ApexPages.StandardSetController stdOpp = new ApexPages.StandardSetController(lstopps);
    stdOpp.setSelected(lstopps);
    removeOpportunityFromCaptureTeam objController  =  new removeOpportunityFromCaptureTeam(stdOpp);    
    objController.getOpportunities();
    
    removeOpportunityFromCaptureTeam.OpportunityWrapper obj = new removeOpportunityFromCaptureTeam.OpportunityWrapper();
    
    List<removeOpportunityFromCaptureTeam.OpportunityWrapper> opportunities = objController.getOpportunities();
    for(removeOpportunityFromCaptureTeam.OpportunityWrapper w : opportunities)
    {
        w.selected = true;
    }
    
    objController.removeSelectedOpportunities();
    //objController.selectedOpptyId=o.Id;
    pagereference pr=objController.removeSelectedOpportunities();
    objController.back();
    String error=objController.error;
    Test.StopTest();
    }
    }
    }