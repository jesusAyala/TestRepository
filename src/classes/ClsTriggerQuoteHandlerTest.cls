/**
*  This test class used to test class ClsTriggerquoteHandler.
*
@author Aswini Arasu
@created 2016-02-22
@version 1.0  
*/
@istest(SeeAllData = False)
public class ClsTriggerQuoteHandlerTest{
    static testMethod void  checkQuoteStatusTest1(){
     Profile p = [SELECT id FROM profile WHERE name = 'ABB Sales Standard Profile'];
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
    
    
    APTS_Common_Config_Settings__c ap=new APTS_Common_Config_Settings__c();
    ap.Name='Global_Record_Type';
    ap.APTS_Value__c='Test';
    ap.APTS_Description__c='testdescr';
    insert ap;
    
    APTS_Common_Config_Settings__c ap1=new APTS_Common_Config_Settings__c();
    ap1.Name='LP_USER_DIVISION';
    ap1.APTS_Value__c='Test';
    ap1.APTS_Description__c='testdescr';
    insert ap1;
    
    APTS_Common_Config_Settings__c ap2=new APTS_Common_Config_Settings__c();
    ap2.Name='DEFAULT_SAP_DIVISION';
    ap2.APTS_Value__c='Test';
    ap2.APTS_Description__c='testdescr';
    insert ap2;
    
    APTS_Common_Config_Settings__c ap3=new APTS_Common_Config_Settings__c();
    ap3.Name='SPAIN_LOCALE';
    ap3.APTS_Value__c='Test';
    ap3.APTS_Description__c='testdescr';
    insert ap3;
    
    APTS_Common_Config_Settings__c ap4=new APTS_Common_Config_Settings__c();
    ap4.Name='DIVISION';
    ap4.APTS_Value__c='Test';
    ap4.APTS_Description__c='testdescr';
    insert ap4;
    
    APTS_Common_Config_Settings__c ap5=new APTS_Common_Config_Settings__c();
    ap5.Name='APPROVAL_COUNTRY';
    ap5.APTS_Value__c='Test';
    ap5.APTS_Description__c='testdescr';
    insert ap5;
    
    Opportunity o = new Opportunity();
    o.AccountId = a.id;
    o.Name = 'ES-Acciona, S.A-Test';
    o.StageName = 'Opportunity Pursuit';
    o.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    o.Specific_Opportunity_Info__c ='Test';
    o.Confidence_Level__c ='No Delay Expected';
    o.CloseDate = date.today();
    o.Industry_Usage__c = 'BLD.10.1';
    o.Channel_Class_Level1__c = 'DEU';
    o.All_Quotes_Closed__c = False;
    o.Customer_Buying_Path__c = 'Awareness';
    insert o;
    Test.StartTest();
    RecordType rt = [select id,Name from RecordType where SobjectType='Apttus_Proposal__Proposal__c' and Name='CQP' Limit 1];
    Apttus_Proposal__Proposal__c apt1 = new Apttus_Proposal__Proposal__c();
    apt1.RecordTypeId = rt.id;
    apt1.Apttus_Proposal__Opportunity__c = o.id;
    apt1.Quotation_status__c = 'Sent to bol';
    insert apt1;
    Test.StopTest();
    Opportunity Oppty = [Select Id,Name,All_Quotes_Closed__c from Opportunity where id =:o.id];
    System.assertEquals(Oppty.All_Quotes_Closed__c,True);
    //apt1.Quotation_status__c = 'Sent to bol';
    //update apt1;
    }
    }
    static testMethod void  checkQuoteStatusTest2(){
     Profile p = [SELECT id FROM profile WHERE name = 'ABB Sales Standard Profile'];
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
    
    
    APTS_Common_Config_Settings__c ap=new APTS_Common_Config_Settings__c();
    ap.Name='Global_Record_Type';
    ap.APTS_Value__c='Test';
    ap.APTS_Description__c='testdescr';
    insert ap;
    
    APTS_Common_Config_Settings__c ap1=new APTS_Common_Config_Settings__c();
    ap1.Name='LP_USER_DIVISION';
    ap1.APTS_Value__c='Test';
    ap1.APTS_Description__c='testdescr';
    insert ap1;
    
    APTS_Common_Config_Settings__c ap2=new APTS_Common_Config_Settings__c();
    ap2.Name='DEFAULT_SAP_DIVISION';
    ap2.APTS_Value__c='Test';
    ap2.APTS_Description__c='testdescr';
    insert ap2;
    
    APTS_Common_Config_Settings__c ap3=new APTS_Common_Config_Settings__c();
    ap3.Name='SPAIN_LOCALE';
    ap3.APTS_Value__c='Test';
    ap3.APTS_Description__c='testdescr';
    insert ap3;
    
    APTS_Common_Config_Settings__c ap4=new APTS_Common_Config_Settings__c();
    ap4.Name='DIVISION';
    ap4.APTS_Value__c='Test';
    ap4.APTS_Description__c='testdescr';
    insert ap4;
    
    APTS_Common_Config_Settings__c ap5=new APTS_Common_Config_Settings__c();
    ap5.Name='APPROVAL_COUNTRY';
    ap5.APTS_Value__c='Test';
    ap5.APTS_Description__c='testdescr';
    insert ap5;
    
    Opportunity o = new Opportunity();
    o.AccountId = a.id;
    o.Name = 'ES-Acciona, S.A-Test';
    o.StageName = 'Opportunity Pursuit';
    o.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    o.Specific_Opportunity_Info__c ='Test';
    o.Confidence_Level__c ='No Delay Expected';
    o.CloseDate = date.today();
    o.Industry_Usage__c = 'BLD.10.1';
    o.Channel_Class_Level1__c = 'DEU';
    o.All_Quotes_Closed__c = False;
    o.Customer_Buying_Path__c = 'Awareness';
    insert o;
    Test.StartTest();
    RecordType rt = [select id,Name from RecordType where SobjectType='Apttus_Proposal__Proposal__c' and Name='CQP' Limit 1];
    Apttus_Proposal__Proposal__c apt1 = new Apttus_Proposal__Proposal__c();
    apt1.RecordTypeId = rt.id;
    apt1.Apttus_Proposal__Opportunity__c = o.id;
    apt1.Quotation_status__c = 'Quotation Created';
    insert apt1;
    Test.StopTest();
    Opportunity Oppty = [Select Id,Name,All_Quotes_Closed__c from Opportunity where id =:o.id];
    System.assertEquals(Oppty.All_Quotes_Closed__c,False);
    }
    }
    static testMethod void updateOpptyChangeOnQTMTest(){
     Profile p = [SELECT id FROM profile WHERE name = 'ABB Sales Standard Profile'];
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
    
    
    APTS_Common_Config_Settings__c ap=new APTS_Common_Config_Settings__c();
    ap.Name='Global_Record_Type';
    ap.APTS_Value__c='Test';
    ap.APTS_Description__c='testdescr';
    insert ap;
    
    APTS_Common_Config_Settings__c ap1=new APTS_Common_Config_Settings__c();
    ap1.Name='LP_USER_DIVISION';
    ap1.APTS_Value__c='Test';
    ap1.APTS_Description__c='testdescr';
    insert ap1;
    
    APTS_Common_Config_Settings__c ap2=new APTS_Common_Config_Settings__c();
    ap2.Name='DEFAULT_SAP_DIVISION';
    ap2.APTS_Value__c='Test';
    ap2.APTS_Description__c='testdescr';
    insert ap2;
    
    APTS_Common_Config_Settings__c ap3=new APTS_Common_Config_Settings__c();
    ap3.Name='SPAIN_LOCALE';
    ap3.APTS_Value__c='Test';
    ap3.APTS_Description__c='testdescr';
    insert ap3;
    
    APTS_Common_Config_Settings__c ap4=new APTS_Common_Config_Settings__c();
    ap4.Name='DIVISION';
    ap4.APTS_Value__c='Test';
    ap4.APTS_Description__c='testdescr';
    insert ap4;
    
    APTS_Common_Config_Settings__c ap5=new APTS_Common_Config_Settings__c();
    ap5.Name='APPROVAL_COUNTRY';
    ap5.APTS_Value__c='Test';
    ap5.APTS_Description__c='testdescr';
    insert ap5;
    
    Opportunity o = new Opportunity();
    o.AccountId = a.id;
    o.Name = 'ES-Acciona, S.A-Test';
    o.StageName = 'Opportunity Pursuit';
    o.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    o.Specific_Opportunity_Info__c ='Test';
    o.Confidence_Level__c ='No Delay Expected';
    o.CloseDate = date.today();
    o.Industry_Usage__c = 'BLD.10.1';
    o.Channel_Class_Level1__c = 'DEU';
    o.Customer_Buying_Path__c = 'Awareness';
    
    Opportunity o1 = new Opportunity();
    o1.AccountId = a.id;
    o1.Name = 'Test1';
    o1.StageName = 'Opportunity Pursuit';
    o1.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    o1.Specific_Opportunity_Info__c ='Test';
    o1.Confidence_Level__c ='No Delay Expected';
    o1.CloseDate = date.today();
    o1.Industry_Usage__c = 'BLD.10.1';
    o1.Channel_Class_Level1__c = 'DEU';
    o1.Customer_Buying_Path__c = 'Awareness';
 
    List<Opportunity> lstopps = new List<Opportunity>();
    lstopps.add(o);
    lstopps.add(o1);
    insert lstopps;
    
    RecordType rt = [select id,Name from RecordType where SobjectType='Apttus_Proposal__Proposal__c' and Name='CQP' Limit 1];
    Apttus_Proposal__Proposal__c apt1 = new Apttus_Proposal__Proposal__c();
    apt1.RecordtypeId = rt.id;
    apt1.Apttus_Proposal__Opportunity__c = o.id;
    apt1.Quotation_status__c = 'Pre handled';
    insert apt1;
    
    Quote_Team_Member__c qm = new Quote_Team_Member__c();
    qm.Access_Level__c = 'Read/Write';
    qm.Team_Role__c = 'Account Engineer';
    qm.Quotation__c = apt1.id;
    qm.User__c = u1.id;
    insert qm;
    
    Test.StartTest();
    apt1.Apttus_Proposal__Opportunity__c = o1.id;
    Update apt1;
    Test.StopTest();
    Quote_Team_Member__c qtm = [Select Id,Oppty_changed_on_quote__c from Quote_Team_Member__c where id =:qm.id];
    System.assertEquals(qtm.Oppty_changed_on_quote__c ,True);
    }
    }
}