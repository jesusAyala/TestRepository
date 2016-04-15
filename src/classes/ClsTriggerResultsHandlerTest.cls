/**
*  This test class used to test class ClsTriggerResultsHandler.
*
@author Aswini Arasu
@created 2016-03-17
@version 1.0  
*/
@istest(SeeAllData = False)
public class ClsTriggerResultsHandlerTest{
   static testMethod void setActualCompletionDateFromResultsTest(){
   
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
    Test.StartTest();
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
    
    RFP__c rfp = new RFP__c();
    rfp.Name = 'Test';
    rfp.Rfp_Account_Manager__c = u1.id;
    rfp.Rfp_Opportunity__c = o.id;
    rfp.Rfp_Account_Manager_Country__c = 'Germany';
    rfp.Rfp_Due_Date__c = System.today();
    rfp.Rfp_A4__c = 'Budgetary';
    rfp.Rfp_Commercial_Terms__c = 'Previously Negotiated Agreement ';
    rfp.CurrencyIsoCode = 'USD';
    insert rfp;
    
    Rfp_Results__c res = new Rfp_Results__c();
    res.Rfp_Results__c =rfp.id;
    res.Rfp_Actual_Completion_Date__c = System.today();
    insert res;
    RFP__c  rfp1 = [Select Id,Actual_Completion_Date__c from RFP__c  where id=:rfp.id];
    Test.StopTest();
    System.assertEquals(rfp1.Actual_Completion_Date__c ,res.Rfp_Actual_Completion_Date__c);
    }
   }
}