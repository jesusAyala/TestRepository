/*
*  This test class used to test class addCompetitorOnCaptureTeam.
*
@author Aswini Arasu
@created 2015-12-24
@version 1.0  
*/
@istest(SeeAllData = False)
  public class addCompetitorOnCaptureTeamTest{
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
    
    Opportunity o = new Opportunity();
    o.AccountId = a.id;
    //o.RecordtypeId = rg.id;
    o.Account_End_User__c =a.id;
    o.End_User_Project__c = eu.id;
    o.Name = 'ES-Acciona, S.A-Test';
    o.StageName = 'Prospecting';
    o.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    o.Specific_Opportunity_Info__c ='Test';
    o.Confidence_Level__c ='No Delay Expected';    
    o.CloseDate = date.today();    
    o.Industry_Usage__c = 'BLD.10.1';
    o.Channel_Class__c = 'Direct Sales to End Customer / End User';
    o.Channel_Class_Level1__c= 'DEU';
    o.Customer_Buying_Path__c = 'Awareness';
    o.Opportunity_Winner__c = a.id;
    //o.Capture_Team__c = cap.id;   
    insert o;
   
    Capture_Team__c cap = new Capture_Team__c();
    cap.Name = 'TestCap';
    cap.End_User_Project__c = eu.id;    
    insert cap;
    
    Competitor__c c = new Competitor__c();
    c.Opportunity__c = o.id ;
    c.Competitor__c = a.id;
    //insert c;
    
    Competitor__c c1 = new Competitor__c();
    c1.Opportunity__c = o.id;
    c1.Competitor__c = a.id;
    //insert c1;
    
    List<Competitor__c> lstcomps = new List<Competitor__c>();
    lstcomps.add(c);
    lstcomps.add(c1);
    insert lstcomps;
    
    Test.startTest();
    PageReference pageRef = Page.Add_Competitor_On_Capture_Team; 
    pageRef.getParameters().put('id', String.valueOf(cap.Id));
    Test.setCurrentPage(pageRef);
    
    ApexPages.StandardSetController stdcomps = new ApexPages.StandardSetController(lstcomps);
    stdcomps.setSelected(lstcomps);
    addCompetitorOnCaptureTeam objController  =  new addCompetitorOnCaptureTeam(stdcomps);    
    objController.getCompetitorList();
    
    addCompetitorOnCaptureTeam.CompetitorWrapper obj = new addCompetitorOnCaptureTeam.CompetitorWrapper();
     
    List<addCompetitorOnCaptureTeam.CompetitorWrapper> competitors = objController.getCompetitorList();
    for(addCompetitorOnCaptureTeam.CompetitorWrapper w : competitors)
    {
        w.selected = true;
    }
    
    objController.addSelectedCompetitors();
    objController.back();
    objController.selectedComptId=a.Id;
    pagereference pr=objController.addCompetitor();
    Boolean b=objController.dupAcc;
    objController.dupAcc=true;
    Test.stopTest();
    }
    }
    
    static testMethod void  methodTest1(){
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
    
    Opportunity o = new Opportunity();
    o.AccountId = a.id;
    //o.RecordtypeId = rg.id;
    o.Account_End_User__c =a.id;
    o.End_User_Project__c = eu.id;
    o.Name = 'ES-Acciona, S.A-Test';
    o.StageName = 'Prospecting';
    o.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    o.Specific_Opportunity_Info__c ='Test';
    o.Confidence_Level__c ='No Delay Expected';    
    o.CloseDate = date.today();    
    o.Industry_Usage__c = 'BLD.10.1';
    o.Channel_Class__c = 'Direct Sales to End Customer / End User';
    o.Channel_Class_Level1__c= 'DEU';
    o.Customer_Buying_Path__c = 'Awareness';
    o.Opportunity_Winner__c = a.id;
    //o.Capture_Team__c = cap.id;   
    insert o;
    
    Capture_Team__c cap = new Capture_Team__c();
    cap.Name = 'TestCap';
    cap.End_User_Project__c = eu.id;    
    insert cap;
    
    Competitor_Capture_Team__c ccap = new Competitor_Capture_Team__c();
    ccap.Account__c = a.id;
    ccap.Capture_Team__c = cap.id;
    ccap.Comment__c = 'TestComment';
    ccap.Ranking__c = '1';
    //insert ccap;
    
    Competitor_Capture_Team__c ccap1 = new Competitor_Capture_Team__c();
    ccap1.Account__c = a.id;
    ccap1.Capture_Team__c = cap.id;
    ccap1.Comment__c = 'TestCommenttest';
    ccap1.Ranking__c = '2';
    //insert ccap1;
    
    List< Competitor_Capture_Team__c > lstccap = new List<Competitor_Capture_Team__c >();
    lstccap.add(ccap);
    lstccap.add(ccap1);
    insert lstccap;
    
    Test.startTest();
    
    PageReference pageRef = Page.Add_Competitor_On_Capture_Team; 
    pageRef.getParameters().put('id', String.valueOf(cap.Id));
    Test.setCurrentPage(pageRef);
    
    ApexPages.StandardSetController stdcomps = new ApexPages.StandardSetController(lstccap);
    stdcomps.setSelected(lstccap);
    addCompetitorOnCaptureTeam objController  =  new addCompetitorOnCaptureTeam(stdcomps);    
    objController.getCompetitorList();
    
    addCompetitorOnCaptureTeam.CompetitorWrapper obj = new addCompetitorOnCaptureTeam.CompetitorWrapper();
     
    List<addCompetitorOnCaptureTeam.CompetitorWrapper> competitors = objController.getCompetitorList();
    for(addCompetitorOnCaptureTeam.CompetitorWrapper w : competitors)
    {
        w.selected = true;
    }
    
    objController.addSelectedCompetitors();
    objController.back();
    
    objController.selectedComptId=a.Id;
    pagereference pr=objController.addCompetitor();
    Boolean b=objController.dupAcc;
    objController.dupAcc=true;
    Test.stopTest();
    }
    }
    }