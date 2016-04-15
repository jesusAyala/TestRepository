/**
*  This test class used to test class ClsTriggerOpptyCompetitorHandler.
*
@author Aswini Arasu
@created 2015-12-21
@version 1.0  
*/
@istest(SeeAllData = False)
public class ClsTriggerOpptyCompetitorHandlerTest{
   static testMethod void  enforceSingleWinnerOnInsertTest(){
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
    Test.StartTest();
    Account a = new Account();
    a.Name = 'test';
    a.BillingStreet = 'dajie';
    a.BillingCity = 'berlin';
    a.BillingState = 'Berlin';
    a.BillingPostalCode = '20012';
    a.BillingCountry = 'Germany';
    
    Account a1 = new Account();
    a1.Name = 'test1';
    //a.RecordtypeId = ga.id;
    a1.BillingStreet = 'dajie';
    a1.BillingCity = 'berlin';
    a1.BillingState = 'Berlin';
    a1.BillingPostalCode = '20012';
    a1.BillingCountry = 'Germany';
    
    List<Account> acc = new List<Account>();
    acc.add(a);
    acc.add(a1);
    insert acc;
      
    Opportunity o = new Opportunity();
    o.AccountId = a.id;
    //o.RecordtypeId = rg.id;
    //o.Account_End_User__c =a.id;
    //o.End_User_Project__c = 'Testct';
    o.Name = 'ES-Acciona, S.A-Test';
    o.StageName = 'Prospecting';
    o.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    o.Specific_Opportunity_Info__c ='Test';
    o.Confidence_Level__c ='No Delay Expected';
    //o.Probability_Verification__c = '';
    //o.ABB_Location__c ='Test';
    o.CloseDate = date.today();
    //o.Opportunity_Value__c = '10';
    //o.Technical_Amount_USD = ''
    o.Industry_Usage__c = 'BLD.10.1';
    //o.Channel_Class__c = 'Direct Sales to End Customer / End User';
    o.Customer_Buying_Path__c = 'Awareness';
    o.Opportunity_Winner__c = a.id;
    insert o;
    
   Competitor__c c = new Competitor__c();
   c.Competitor__c = a.id;
   c.Opportunity__c = o.id;
   c.Winning_Company__c = True;
   insert c;
    
   Competitor__c c1 = new Competitor__c();
   c1.Competitor__c = a1.id;
   c1.Opportunity__c = o.id;
   c1.Customer_Relationship__c = 'Strong';
   c1.Winning_Company__c = True;
   insert c1;
   
   /*List<Competitor__c> comp = new List<Competitor__c>();
   comp.add(c);
   comp.add(c1);
   insert comp;*/
   
   //Test.StartTest();
   Competitor__c com = [Select Id,Winning_Company__c from Competitor__c where id=:c1.id];
   Test.StopTest();
     System.assertEquals(com.Winning_Company__c ,True);
   }
   }  
   
   static testMethod void  enforceSingleWinnerOnUpdateTest(){
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
    Test.StartTest();
    Account a = new Account();
    a.Name = 'test';
    a.BillingStreet = 'dajie';
    a.BillingCity = 'berlin';
    a.BillingState = 'Berlin';
    a.BillingPostalCode = '20012';
    a.BillingCountry = 'Germany';
    
    Account a1 = new Account();
    a1.Name = 'test1';
    //a.RecordtypeId = ga.id;
    a1.BillingStreet = 'dajie';
    a1.BillingCity = 'berlin';
    a1.BillingState = 'Berlin';
    a1.BillingPostalCode = '20012';
    a1.BillingCountry = 'Germany';
    
    List<Account> acc = new List<Account>();
    acc.add(a);
    acc.add(a1);
    insert acc;
    
    Opportunity o = new Opportunity();
    o.AccountId = a.id;
    //o.Account_End_User__c =a.id;
    //o.End_User_Project__c = 'Testct';
    o.Name = 'ES-Acciona, S.A-Test';
    o.StageName = 'Prospecting';
    o.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    o.Specific_Opportunity_Info__c ='Test';
    o.Confidence_Level__c ='No Delay Expected';
    //o.Probability_Verification__c = '';
    //o.ABB_Location__c ='Test';
    o.CloseDate = date.today();
    //o.Opportunity_Value__c = '10';
    //o.Technical_Amount_USD = ''
    o.Industry_Usage__c = 'BLD.10.1';
   // o.Channel_Class__c = 'Direct Sales to End Customer / End User';
    o.Customer_Buying_Path__c = 'Awareness';
    o.Opportunity_Winner__c = a.id;
    insert o;
    
   Competitor__c c = new Competitor__c();
   c.Competitor__c = a.id;
   c.Opportunity__c = o.id;
   c.Winning_Company__c = True;
   insert c;
  
   Competitor__c c1 = new Competitor__c();
   c1.Competitor__c = a1.id;
   c1.Opportunity__c = o.id;
   c1.Customer_Relationship__c = 'Strong';
   c1.Winning_Company__c = True;
   insert c1;
   
   /*List<Competitor__c> comp = new List<Competitor__c>();
   comp.add(c);
   comp.add(c1);
   insert comp;*/
 
   //Test.StartTest();  
   c.Winning_Company__c = True;
   update c;
   Test.stopTest();
   Competitor__c com = [Select Id,Winning_Company__c from Competitor__c where id=:c.id];
   System.assertEquals(com.Winning_Company__c ,True);
   
   }}
   
    static testMethod void  enforceSingleWinnerOnDelete(){
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
    Test.StartTest();
    Account a = new Account();
    a.Name = 'test';
    a.BillingStreet = 'dajie';
    a.BillingCity = 'berlin';
    a.BillingState = 'Berlin';
    a.BillingPostalCode = '20012';
    a.BillingCountry = 'Germany';
  
    Account a1 = new Account();
    a1.Name = 'test1';
    //a.RecordtypeId = ga.id;
    a1.BillingStreet = 'dajie';
    a1.BillingCity = 'berlin';
    a1.BillingState = 'Berlin';
    a1.BillingPostalCode = '20012';
    a1.BillingCountry = 'Germany';
    
    List<Account> acc = new List<Account>();
    acc.add(a);
    acc.add(a1);
    insert acc;
    
    Opportunity o = new Opportunity();
    o.AccountId = a.id;
    //o.Account_End_User__c =a.id;
    //o.End_User_Project__c = 'Testct';
    o.Name = 'ES-Acciona, S.A-Test';
    o.StageName = 'Prospecting';
    o.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    o.Specific_Opportunity_Info__c ='Test';
    o.Confidence_Level__c ='No Delay Expected';
    //o.Probability_Verification__c = '';
    //o.ABB_Location__c ='Test';
    o.CloseDate = date.today();
    //o.Opportunity_Value__c = '10';
    //o.Technical_Amount_USD = ''
    o.Industry_Usage__c = 'BLD.10.1';
    o.Channel_Class__c = 'Direct Sales to End Customer / End User';
    o.Customer_Buying_Path__c = 'Awareness';
    o.Opportunity_Winner__c = a.id;
    insert o;
    
   Competitor__c c = new Competitor__c();
   c.Competitor__c = a.id;
   c.Opportunity__c = o.id;
   c.Winning_Company__c = True;
   insert c;
    
   Competitor__c c1 = new Competitor__c();
   c1.Competitor__c = a1.id;
   c1.Opportunity__c = o.id;
   c1.Customer_Relationship__c = 'Strong';
   c1.Winning_Company__c = True;
   insert c1;

   /*List<Competitor__c> comp = new List<Competitor__c>();
   comp.add(c);
   comp.add(c1);
   insert comp;*/
    
 
   //Test.StartTest();  
   Delete c1;
   Test.stopTest();
   Opportunity Opp = [Select id ,Opportunity_Winner__c from Opportunity where id =:o.id];
   System.assertEquals(opp.Opportunity_Winner__c,NULL);
   }
   }
   
   }