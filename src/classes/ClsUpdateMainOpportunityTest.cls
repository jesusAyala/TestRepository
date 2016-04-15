/**
*  This test class used to test class ClsTriggerOpportunityHandler.
*
@author Aswini Arasu
@created 2015-12-21
@version 1.0  
*/
@istest(SeeAllData = False)
public class ClsUpdateMainOpportunityTest{
/*  Description of the purpose of the method. 
    *  @name updateMainOpportunityScenario1Test
    *  @Description - Test Alternative Opportunity Scenario1
   */ 
 static testMethod void updateMainOpportunityScenario1Test(){
 Test.StartTest();
 Account a = new Account();
    a.Name = 'Acciona, S.A';
    a.BillingStreet = 'dajie';
    a.BillingCity = 'berlin';
    a.BillingState = 'Berlin';
    a.BillingPostalCode = '20012';
    a.BillingCountry = 'Germany';
    insert a;
    
    Opportunity Main = new Opportunity();
    Main.AccountId = a.id;
    //Main.Account_End_User__c = a.id;
    Main.Name = 'Main Oppty';
    Main.StageName = 'Opportunity Pursuit';
    Main.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    Main.Specific_Opportunity_Info__c ='Test';
    Main.Confidence_Level__c ='No Delay Expected';
    Main.CloseDate = date.today();
    Main.Industry_Usage__c = 'BLD.10.1';
    Main.Channel_Class__c = 'Direct Sales to End Customer / End User';
    Main.Channel_Class_Level1__c= 'DEU';
    Main.Customer_Buying_Path__c = 'Awareness';
    Main.Opportunity_Winner__c = a.id;
    insert Main;
    
    Opportunity Aa = new Opportunity();
    Aa.AccountId = a.id;
    //Aa.Account_End_User__c = a.id;
    Aa.Name = 'OppA S1';
    Aa.StageName = 'Opportunity Pursuit';
    Aa.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    Aa.Specific_Opportunity_Info__c ='Test';
    Aa.Confidence_Level__c ='No Delay Expected';
    Aa.CloseDate = date.today();
    Aa.Industry_Usage__c = 'BLD.10.1';
    Aa.Channel_Class__c = 'Direct Sales to End Customer / End User';
     Aa.Channel_Class_Level1__c= 'DEU';
    Aa.Customer_Buying_Path__c = 'Awareness';
    Aa.Opportunity_Winner__c = a.id;
    Aa.Alternative_Opportunity_To__c = Main.id;
    
    Opportunity B = new Opportunity();
    B.AccountId = a.id;
    //B.Account_End_User__c = a.id;
    B.Name = 'OppB S1';
    B.StageName = 'Opportunity Pursuit';
    B.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    B.Specific_Opportunity_Info__c ='Test';
    B.Confidence_Level__c ='No Delay Expected';
    B.CloseDate = date.today();
    B.Industry_Usage__c = 'BLD.10.1';
    B.Channel_Class__c = 'Direct Sales to End Customer / End User';
     B.Channel_Class_Level1__c= 'DEU';
    B.Customer_Buying_Path__c = 'Awareness';
    B.Opportunity_Winner__c = a.id;
    B.Alternative_Opportunity_To__c = Main.id;
    
    Opportunity C = new Opportunity();
    C.AccountId = a.id;
    //C.Account_End_User__c = a.id;
    C.Name = 'OppC S1';
    C.StageName = 'Opportunity Pursuit';
    C.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    C.Specific_Opportunity_Info__c ='Test';
    C.Confidence_Level__c ='No Delay Expected';
    C.CloseDate = date.today();
    C.Industry_Usage__c = 'BLD.10.1';
    C.Channel_Class__c = 'Direct Sales to End Customer / End User';
     C.Channel_Class_Level1__c= 'DEU';
    C.Customer_Buying_Path__c = 'Awareness';
    C.Opportunity_Winner__c = a.id;
    C.Alternative_Opportunity_To__c = Main.id;
    
    List<Opportunity> lstopps = new List<Opportunity>();
    //lstopps.add(Main);
    lstopps.add(Aa);
    lstopps.add(B);
    lstopps.add(C);
    insert lstopps;
   // Main.Alternative_Opportunity_To__c = lstopps[1].id;
    //Update Main;
    Profile p = [SELECT id FROM profile WHERE name = 'System Administrator' LIMIT 1];
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
    //Test.StartTest();
    Main.Alternative_Opportunity_To__c = B.id;
    Update Main;  
    Test.StopTest();
    }
   Opportunity opp = [Select Id,Alternative_Opportunity_To__c from Opportunity where ID = :B.Id limit 1];
   System.assertEquals(opp.Alternative_Opportunity_To__c, Null);
    
   Opportunity opp1 = [Select Id,Alternative_Opportunity_To__c from Opportunity where id  =: Aa.id limit 1];
   System.assertEquals(opp1.Alternative_Opportunity_To__c ,B.id);
   Opportunity opp2 = [Select Id,Alternative_Opportunity_To__c from Opportunity where id  =: C.id limit 1];
   System.assertEquals(opp2.Alternative_Opportunity_To__c ,B.id);
   Opportunity opp3 = [Select Id,Alternative_Opportunity_To__c from Opportunity where id  =: Main.id limit 1];
   System.assertEquals(opp3.Alternative_Opportunity_To__c ,B.id);
   
    }
/*  Description of the purpose of the method. 
    *  @name updateMainOpportunityScenario2Test
    *  @Description - Test Alternative Opportunity Scenario2
   */     
 static testMethod void updateMainOpportunityScenario2Test(){
    Test.StartTest();
    Account a = new Account();
    a.Name = 'Acciona, S.A';
    a.BillingStreet = 'dajie';
    a.BillingCity = 'berlin';
    a.BillingState = 'Berlin';
    a.BillingPostalCode = '20012';
    a.BillingCountry = 'Germany';
    insert a;
    
    /*Account a1 = new Account();
    a1.Name = 'test';
    a1.BillingStreet = 'dajie';
    a1.BillingCity = 'berlin';
    a1.BillingState = 'Berlin';
    a1.BillingPostalCode = '20012';
    a1.BillingCountry = 'Germany';
    insert a1;*/
    
    Opportunity Main = new Opportunity();
    Main.AccountId = a.id;
    //Main.Account_End_User__c = a.id;
    Main.Name = 'Main Opp';
    Main.StageName = 'Opportunity Pursuit';
    Main.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    Main.Specific_Opportunity_Info__c ='Test';
    Main.Confidence_Level__c ='No Delay Expected';
    Main.CloseDate = date.today();
    Main.Industry_Usage__c = 'BLD.10.1';
    Main.Channel_Class__c = 'Direct Sales to End Customer / End User';
     Main.Channel_Class_Level1__c= 'DEU';
    Main.Customer_Buying_Path__c = 'Awareness';
    Main.Opportunity_Winner__c = a.id;
    Main.Alternative_Opportunity_To__c = Null;
    insert Main;
    
    
    Opportunity Aa = new Opportunity();
    Aa.AccountId = a.id;
    //Aa.Account_End_User__c = a.id;
    Aa.Name = 'OppA S2';
    Aa.StageName = 'Opportunity Pursuit';
    Aa.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    Aa.Specific_Opportunity_Info__c ='Test';
    Aa.Confidence_Level__c ='No Delay Expected';
    Aa.CloseDate = date.today();
    Aa.Industry_Usage__c = 'BLD.10.1';
    Aa.Channel_Class__c = 'Direct Sales to End Customer / End User';
     Aa.Channel_Class_Level1__c= 'DEU';
    Aa.Customer_Buying_Path__c = 'Awareness';
    Aa.Opportunity_Winner__c = a.id;
    Aa.Alternative_Opportunity_To__c = Main.id;
    
    Opportunity B = new Opportunity();
    B.AccountId = a.id;
    //B.Account_End_User__c = a.id;
    B.Name = 'OppB S2';
    B.StageName = 'Opportunity Pursuit';
    B.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    B.Specific_Opportunity_Info__c ='Test';
    B.Confidence_Level__c ='No Delay Expected';
    B.CloseDate = date.today();
    B.Industry_Usage__c = 'BLD.10.1';
    B.Channel_Class__c = 'Direct Sales to End Customer / End User';
     B.Channel_Class_Level1__c= 'DEU';
    B.Customer_Buying_Path__c = 'Awareness';
    B.Opportunity_Winner__c = a.id;
    B.Alternative_Opportunity_To__c = Main.id;
    
    Opportunity C = new Opportunity();
    C.AccountId = a.id;
    //C.Account_End_User__c = a.id;
    C.Name = 'OppC S2';
    C.StageName = 'Opportunity Pursuit';
    C.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    C.Specific_Opportunity_Info__c ='Test';
    C.Confidence_Level__c ='No Delay Expected';
    C.CloseDate = date.today();
    C.Industry_Usage__c = 'BLD.10.1';
    C.Channel_Class__c = 'Direct Sales to End Customer / End User';
     C.Channel_Class_Level1__c= 'DEU';
    C.Customer_Buying_Path__c = 'Awareness';
    C.Opportunity_Winner__c = a.id;
    C.Alternative_Opportunity_To__c = Main.id;
    
    Opportunity Main2 = new Opportunity();
    Main2.AccountId = a.id;
    //Main2.Account_End_User__c = a.id;
    Main2.Name = 'Main2 S2 Opp';
    Main2.StageName = 'Opportunity Pursuit';
    Main2.Sales_Pursuit_Progress__c = 'Opportunity Is Main2aptured';
    Main2.Specific_Opportunity_Info__c ='Test';
    Main2.Confidence_Level__c ='No Delay Expected';
    Main2.CloseDate = date.today();
    Main2.Industry_Usage__c = 'BLD.10.1';
    Main2.Channel_Class__c = 'Direct Sales to Customer / End User';
     Main2.Channel_Class_Level1__c= 'DEU';
    Main2.Customer_Buying_Path__c = 'Awareness';
    Main2.Opportunity_Winner__c = a.id;
    Main2.Alternative_Opportunity_To__c = Null;
    
    Opportunity D = new Opportunity();
    D.AccountId = a.id;
    //D.Account_End_User__c = a.id;
    D.Name = 'OppD S2';
    D.StageName = 'Opportunity Pursuit';
    D.Sales_Pursuit_Progress__c = 'Opportunity Is Daptured';
    D.Specific_Opportunity_Info__c ='Test';
    D.Confidence_Level__c ='No Delay ExpeDted';
    D.CloseDate = date.today();
    D.Industry_Usage__c = 'BLD.10.1';
    D.Channel_Class__c = 'Direct Sales to End Dustomer / End User';
     D.Channel_Class_Level1__c= 'DEU';
    D.Customer_Buying_Path__c = 'Awareness';
    D.Opportunity_Winner__c = a.id;
    D.Alternative_Opportunity_To__c = Main2.id;
    
    List<Opportunity> lstopps = new List<Opportunity>();
    //lstopps.add(Main);
    lstopps.add(Aa);
    lstopps.add(B);
    lstopps.add(C);
    lstopps.add(Main2);
    lstopps.add(D);
    insert lstopps;
    
     Profile p = [SELECT id FROM profile WHERE name = 'System Administrator' LIMIT 1];
    User u2 = new User(alias = 'chfree01',
                           email = 'chatterfreeuser101@testorg.com',
                           emailencodingkey = 'UTF-8',
                           lastname = 'Testing',
                           companyname = 'testorg',
                           languagelocalekey = 'en_US',
                           localesidkey = 'en_US',
                           profileId = p.Id,
                           timezonesidkey = 'America/Los_Angeles',
                           username = 'chatterfreeuser101@testorg.com');
    insert u2;
    System.runAs(u2){
    
    //Test.StartTest();
    Main2.Alternative_Opportunity_To__c  = Main.id;
    Update Main2;
    Test.StopTest();
    }
    Opportunity opp = [Select Id,Alternative_Opportunity_To__c from Opportunity where id  =: Main.id limit 1];
    System.assertEquals(opp.Alternative_Opportunity_To__c ,Null);
    Opportunity opp1 = [Select Id,Alternative_Opportunity_To__c from Opportunity where id  =: Aa.id limit 1];
    System.assertEquals(opp1.Alternative_Opportunity_To__c ,Main.id);
    Opportunity oppn = [Select Id,Alternative_Opportunity_To__c from Opportunity where id  =: B.id limit 1];
    System.assertEquals(oppn.Alternative_Opportunity_To__c ,Main.id);
    Opportunity opp2 = [Select Id,Alternative_Opportunity_To__c from Opportunity where id  =: C.id limit 1];
    System.assertEquals(opp2.Alternative_Opportunity_To__c ,Main.id);
    System.debug('::::::::::::::'+Opp2);
    //Opportunity opp3 = [Select Id,Alternative_Opportunity_To__c from Opportunity where id  =: D.id limit 1];
    //System.assertEquals(opp3.Alternative_Opportunity_To__c ,Main.id);
    Opportunity opp4 = [Select Id,Alternative_Opportunity_To__c from Opportunity where id  =: Main2.id limit 1];
    System.assertEquals(opp4.Alternative_Opportunity_To__c ,Main.id);
   
    }
 /*  Description of the purpose of the method. 
    *  @name updateMainOpportunityScenario3Test
    *  @Description - Test Alternative Opportunity Scenario3
   */     
 static testMethod void updateMainOpportunityScenario3Test(){
 
    Test.StartTest();
    Account a = new Account();
    a.Name = 'Acciona, S.A';
    a.BillingStreet = 'dajie';
    a.BillingCity = 'berlin';
    a.BillingState = 'Berlin';
    a.BillingPostalCode = '20012';
    a.BillingCountry = 'Germany';
    insert a;
    
     /*Account a1 = new Account();
    a1.Name = 'test';
    a1.BillingStreet = 'dajie';
    a1.BillingCity = 'berlin';
    a1.BillingState = 'Berlin';
    a1.BillingPostalCode = '20012';
    a1.BillingCountry = 'Germany';
    insert a1;*/
    
    Opportunity Main = new Opportunity();
    Main.AccountId = a.id;
    //Main.Account_End_User__c = a.id;
    Main.Name = 'Main S3';
    Main.StageName = 'Opportunity Pursuit';
    Main.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    Main.Specific_Opportunity_Info__c ='Test';
    Main.Confidence_Level__c ='No Delay Expected';
    Main.CloseDate = date.today();
    Main.Industry_Usage__c = 'BLD.10.1';
    Main.Channel_Class__c = 'Direct Sales to End Customer / End User';
     Main.Channel_Class_Level1__c= 'DEU';
    Main.Customer_Buying_Path__c = 'Awareness';
    Main.Opportunity_Winner__c = a.id;
    insert Main;
    
    Opportunity Aa = new Opportunity();
    Aa.AccountId = a.id;
    //Aa.Account_End_User__c = a.id;
    Aa.Name = 'OppA S3';
    Aa.StageName = 'Opportunity Pursuit';
    Aa.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    Aa.Specific_Opportunity_Info__c ='Test';
    Aa.Confidence_Level__c ='No Delay Expected';
    Aa.CloseDate = date.today();
    Aa.Industry_Usage__c = 'BLD.10.1';
    Aa.Channel_Class__c = 'Direct Sales to End Customer / End User';
     Aa.Channel_Class_Level1__c= 'DEU';
    Aa.Customer_Buying_Path__c = 'Awareness';
    Aa.Opportunity_Winner__c = a.id;
    Aa.Alternative_Opportunity_To__c = Main.id;
    
    Opportunity B = new Opportunity();
    B.AccountId = a.id;
    //B.Account_End_User__c = a.id;
    B.Name = 'OppB S3';
    B.StageName = 'Opportunity Pursuit';
    B.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    B.Specific_Opportunity_Info__c ='Test';
    B.Confidence_Level__c ='No Delay Expected';
    B.CloseDate = date.today();
    B.Industry_Usage__c = 'BLD.10.1';
    B.Channel_Class__c = 'Direct Sales to End Customer / End User';
     B.Channel_Class_Level1__c= 'DEU';
    B.Customer_Buying_Path__c = 'Awareness';
    B.Opportunity_Winner__c = a.id;
    B.Alternative_Opportunity_To__c = Main.id;
    
    Opportunity C = new Opportunity();
    C.AccountId = a.id;
    //C.Account_End_User__c = a.id;
    C.Name = 'OppC S3';
    C.StageName = 'Opportunity Pursuit';
    C.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    C.Specific_Opportunity_Info__c ='Test';
    C.Confidence_Level__c ='No Delay Expected';
    C.CloseDate = date.today();
    C.Industry_Usage__c = 'BLD.10.1';
    C.Channel_Class__c = 'Direct Sales to End Customer / End User';
     C.Channel_Class_Level1__c= 'DEU';
    C.Customer_Buying_Path__c = 'Awareness';
    C.Opportunity_Winner__c = a.id;
    C.Alternative_Opportunity_To__c = Main.id;
    
    Opportunity Main2 = new Opportunity();
    Main2.AccountId = a.id;
    //Main2.Account_End_User__c = a.id;
    Main2.Name = 'Main2 S3';
    Main2.StageName = 'Opportunity Pursuit';
    Main2.Sales_Pursuit_Progress__c = 'Opportunity Is Main2aptured';
    Main2.Specific_Opportunity_Info__c ='Test';
    Main2.Confidence_Level__c ='No Delay Expected';
    Main2.CloseDate = date.today();
    Main2.Industry_Usage__c = 'BLD.10.1';
    Main2.Channel_Class__c = 'Direct Sales to Customer / End User';
     Main2.Channel_Class_Level1__c= 'DEU';
    Main2.Customer_Buying_Path__c = 'Awareness';
    Main2.Opportunity_Winner__c = a.id;
    Main2.Alternative_Opportunity_To__c = Null;
    
    Opportunity D = new Opportunity();
    D.AccountId = a.id;
    //D.Account_End_User__c = a.id;
    D.Name = 'OppD S3';
    D.StageName = 'Opportunity Pursuit';
    D.Sales_Pursuit_Progress__c = 'Opportunity Is Daptured';
    D.Specific_Opportunity_Info__c ='Test';
    D.Confidence_Level__c ='No Delay ExpeDted';
    D.CloseDate = date.today();
    D.Industry_Usage__c = 'BLD.10.1';
    D.Channel_Class__c = 'Direct Sales to End Dustomer / End User';
     D.Channel_Class_Level1__c= 'DEU';
    D.Customer_Buying_Path__c = 'Awareness';
    D.Opportunity_Winner__c = a.id;
    D.Alternative_Opportunity_To__c = Main2.id;
    
    List<Opportunity> lstopps = new List<Opportunity>();
    //lstopps.add(Main);
    lstopps.add(Aa);
    lstopps.add(B);
    lstopps.add(C);
    lstopps.add(Main2);
    lstopps.add(D);
    insert lstopps;
    
     Profile p = [SELECT id FROM profile WHERE name = 'System Administrator' LIMIT 1];
    User u3 = new User(alias = 'chfree01',
                           email = 'chatterfreeuser101@testorg.com',
                           emailencodingkey = 'UTF-8',
                           lastname = 'Testing',
                           companyname = 'testorg',
                           languagelocalekey = 'en_US',
                           localesidkey = 'en_US',
                           profileId = p.Id,
                           timezonesidkey = 'America/Los_Angeles',
                           username = 'chatterfreeuser101@testorg.com');
    insert u3;
    System.runAs(u3){
    
    //Test.StartTest();
    Main2.Alternative_Opportunity_To__c = B.id;
    Update Main2;
    Test.StopTest();
    }
    Opportunity opp = [Select Id,Alternative_Opportunity_To__c from Opportunity where id  =: Main.id limit 1];
    System.assertEquals(opp.Alternative_Opportunity_To__c ,Null);
    Opportunity opp1 = [Select Id,Alternative_Opportunity_To__c from Opportunity where id  =: Aa.id limit 1];
    System.assertEquals(opp1.Alternative_Opportunity_To__c ,Main.id);
    Opportunity oppn = [Select Id,Alternative_Opportunity_To__c from Opportunity where id  =: B.id limit 1];
    System.assertEquals(oppn.Alternative_Opportunity_To__c ,Main.id);
    Opportunity opp2 = [Select Id,Alternative_Opportunity_To__c from Opportunity where id  =: C.id limit 1];
    System.assertEquals(opp2.Alternative_Opportunity_To__c ,Main.id);
    //Opportunity opp3 = [Select Id,Alternative_Opportunity_To__c from Opportunity where id  =: D.id limit 1];
    //System.assertEquals(opp3.Alternative_Opportunity_To__c ,Main.id);
    Opportunity opp4 = [Select Id,Alternative_Opportunity_To__c from Opportunity where id  =: Main2.id limit 1];
    System.assertEquals(opp4.Alternative_Opportunity_To__c ,Main.id);
    
    }
  /*  Description of the purpose of the method. 
    *  @name updateMainOpportunityScenario4Test
    *  @Description - Test Alternative Opportunity Scenario4
   */     
    static testMethod void updateMainOpportunityScenario4Test(){
    
    Test.StartTest();
    Account a = new Account();
    a.Name = 'Acciona, S.A';
    a.BillingStreet = 'dajie';
    a.BillingCity = 'berlin';
    a.BillingState = 'Berlin';
    a.BillingPostalCode = '20012';
    a.BillingCountry = 'Germany';
    insert a;
 
    Opportunity Main = new Opportunity();
    Main.AccountId = a.id;
    //Main.Account_End_User__c = a.id;
    Main.Name = 'Main S4';
    Main.StageName = 'Opportunity Pursuit';
    Main.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    Main.Specific_Opportunity_Info__c ='Test';
    Main.Confidence_Level__c ='No Delay Expected';
    Main.CloseDate = date.today();
    Main.Industry_Usage__c = 'BLD.10.1';
    Main.Channel_Class__c = 'Direct Sales to End Customer / End User';
    Main.Channel_Class_Level1__c= 'DEU';
    Main.Customer_Buying_Path__c = 'Awareness';
    Main.Opportunity_Winner__c = a.id;
    insert Main;
    
    Opportunity B = new Opportunity();
    B.AccountId = a.id;
    //B.Account_End_User__c = a.id;
    B.Name = 'OppB S4';
    B.StageName = 'Opportunity Pursuit';
    B.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    B.Specific_Opportunity_Info__c ='Test';
    B.Confidence_Level__c ='No Delay Expected';
    B.CloseDate = date.today();
    B.Industry_Usage__c = 'BLD.10.1';
    B.Channel_Class__c = 'Direct Sales to End Customer / End User';
     B.Channel_Class_Level1__c= 'DEU';
    B.Customer_Buying_Path__c = 'Awareness';
    B.Opportunity_Winner__c = a.id;
    B.Alternative_Opportunity_To__c = Main.id;
    insert B;
    Profile p = [SELECT id FROM profile WHERE name = 'System administrator' LIMIT 1];
    User u4 = new User(alias = 'chfree01',
                           email = 'chatterfreeuser101@testorg.com',
                           emailencodingkey = 'UTF-8',
                           lastname = 'Testing',
                           companyname = 'testorg',
                           languagelocalekey = 'en_US',
                           localesidkey = 'en_US',
                           profileId = p.Id,
                           timezonesidkey = 'America/Los_Angeles',
                           username = 'chatterfreeuser101@testorg.com');
    insert u4;
    System.runAs(u4){
    
    //Test.StartTest();
    B.Alternative_Opportunity_To__c = Null ;
    Update B;
    Test.stopTest();
    }
    Opportunity opp = [Select Id,Alternative_Opportunity_To__c from Opportunity where id  =: B.id limit 1];
    System.assertEquals(opp.Alternative_Opportunity_To__c ,Null);
    
    }
    }