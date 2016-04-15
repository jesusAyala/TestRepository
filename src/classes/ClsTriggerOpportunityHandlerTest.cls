/**
*  This test class used to test class ClsTriggerOpportunityHandler.
*
@author Aswini Arasu
@created 2015-12-21
@version 1.0  
*/
@istest(SeeAllData = False)
public without sharing class ClsTriggerOpportunityHandlerTest{
/* This method is used to test preventOpptyClosure as part of req 2504*/
 static testMethod void  preventOpptyClosureTest(){
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
    
    Account a1 = new Account();
    a1.Name = 'Test123';
    a1.BillingStreet = 'dajief';
    a1.BillingCity = 'berlin';
    a1.BillingState = 'Berlin';
    a1.BillingPostalCode = '20012';
    a1.BillingCountry = 'Germany';
    insert a1;
    
    //RecordType ft = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Opportunity' and DeveloperName = 'Fast_Track'];  
    RecordType rg = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Opportunity' and DeveloperName = 'Regular'];
    
    Opportunity o = new Opportunity();
    o.AccountId = a.id;
    o.RecordtypeId = rg.id;
    o.Account_End_User__c =a1.id;
    //o.End_User_Project__c = 'Testct';
    o.Name = 'ES-Acciona, S.A-Test';
    o.StageName = 'Opportunity Pursuit';
    o.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    o.Specific_Opportunity_Info__c ='Test';
    o.Confidence_Level__c ='No Delay Expected';
    //o.Probability_Verification__c = '';
    //o.ABB_Location__c ='Test';
    o.CloseDate = date.today();
    o.Opportunity_Value__c = 10;
    //o.Technical_Amount_USD = ''
    o.Industry_Usage__c = 'BLD.10.1';
    o.Channel_Class__c = 'Direct Sales to End Customer / End User';
    o.Customer_Buying_Path__c = 'Awareness';
    o.Opportunity_Winner__c = a.id;
    insert o; 
    
    APTS_Common_Config_Settings__c ap=new APTS_Common_Config_Settings__c();
    ap.Name='Global_Record_Type';
    ap.APTS_Value__c='Test';
    ap.APTS_Description__c='testdescr';
    //insert ap;
    
    APTS_Common_Config_Settings__c ap1=new APTS_Common_Config_Settings__c();
    ap1.Name='LP_USER_DIVISION';
    ap1.APTS_Value__c='Test';
    ap1.APTS_Description__c='testdescr';
    //insert ap1;
    
    APTS_Common_Config_Settings__c ap2=new APTS_Common_Config_Settings__c();
    ap2.Name='DEFAULT_SAP_DIVISION';
    ap2.APTS_Value__c='Test';
    ap2.APTS_Description__c='testdescr';
    //insert ap2;
    
    APTS_Common_Config_Settings__c ap3=new APTS_Common_Config_Settings__c();
    ap3.Name='SPAIN_LOCALE';
    ap3.APTS_Value__c='Test';
    ap3.APTS_Description__c='testdescr';
    //insert ap3;
    
    APTS_Common_Config_Settings__c ap4=new APTS_Common_Config_Settings__c();
    ap4.Name='DIVISION';
    ap4.APTS_Value__c='Test';
    ap4.APTS_Description__c='testdescr';
    //insert ap4;
    
    APTS_Common_Config_Settings__c ap5=new APTS_Common_Config_Settings__c();
    ap5.Name='APPROVAL_COUNTRY';
    ap5.APTS_Value__c='Test';
    ap5.APTS_Description__c='testdescr';
    //insert ap5;
    
    List<APTS_Common_Config_Settings__c> aptc = new List<APTS_Common_Config_Settings__c>();
    aptc.add(ap);
    aptc.add(ap1);
    aptc.add(ap2);
    aptc.add(ap3);
    aptc.add(ap4);
    aptc.add(ap5);
    insert aptc;
    Test.StartTest();
    Apttus_Proposal__Proposal__c apt = new Apttus_Proposal__Proposal__c();
    apt.Apttus_Proposal__Opportunity__c = o.id;
    apt.Quotation_status__c = 'RFQ';
    apt.Apttus_Proposal__Valid_Until_Date__c = System.today()-1;
    insert apt;
    /*try {
       o.StageName = 'Closed Lost';
       Update o;
     System.assert(false,'Exception expected');
    } catch (DMLException e) {
    System.assert(e.getMessage().contains('Opportunity cannot be closed because it has open quotations'), 'message=......' + e.getMessage());
    }*/
    Test.StopTest();
    }
    }
   /* This method is used to test updateAccountEndUser as part of req 2280*/
   static testMethod void updateAccountEndUserTest()
   {
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
    
    Opportunity o = new Opportunity();
    o.AccountId = a.id;
    //o.RecordtypeId = rg.id;
    //o.End_User_Project__c = 'Testct';
    o.Name = 'ES-Acciona, S.A-Test';
    o.StageName = 'Opportunity Pursuit';
    o.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    o.Specific_Opportunity_Info__c ='Test';
    o.Confidence_Level__c ='No Delay Expected';
    //o.Probability_Verification__c = '';
    //o.ABB_Location__c ='Test';
    o.CloseDate = date.today();
    //o.Opportunity_Value__c = '10';
    //o.Technical_Amount_USD = ''
    o.Industry_Usage__c = 'BLD.10.1';
    o.Channel_Class_Level1__c = 'DEU';
    o.Customer_Buying_Path__c = 'Awareness';
    o.Opportunity_Winner__c = a.id;
    insert o;
    Test.StartTest();
    Opportunity opp = [Select Id, AccountId, Account_End_User__c from Opportunity where Id = :o.Id limit 1];
    system.debug(':::::::::::::'+opp.AccountId+':::'+opp.Account_End_User__c ); 
    Test.StopTest();
       System.assertEquals(opp.Account_End_User__c ,o.AccountId );
    }
   }
   
   /* This method is used to test checkAccountCustandAccountEULSOPopulation as part of req 2500*/
   static testMethod void checkAccountCustandAccountEULSOPopulationTest(){
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
    Account ac = new Account();
    ac.Name = '2168 AccountCustomer1';
    ac.BillingCountry = 'India';
    ac.BillingStreet = 'Test Street';
    ac.BillingCity = 'Test City';
    insert ac;
    
    Account acc = new Account();
    acc.Name = 'test Enduser';
    acc.BillingCountry = 'India';
    acc.BillingStreet = 'Test Street';
    acc.BillingCity = 'Test City';
    insert acc;
    
    ERP_Reference_Data__c LSOac1 = new ERP_Reference_Data__c();        
    LSOac1.Account__c = ac.id;
    LSOac1.Country__c = 'Italy';                       
    LSOac1.LSO_ERP_Mapping_Value__c = 'LSO-LSO Description';
    LSOac1.LSO__c = 'LSOac1'; 
    LSOac1.LBU__c = 'LBUac1';  
    //insert LSOac1;
    
    ERP_Reference_Data__c LSOac2 = new ERP_Reference_Data__c();        
    LSOac2.Account__c = acc.id;
    LSOac2.Country__c = 'Italy';                       
    LSOac2.LSO_ERP_Mapping_Value__c = 'LSO-LSO Description';
    LSOac2.LSO__c = 'LSOac2'; 
    LSOac2.LBU__c = 'LBUac2';  
    //insert LSOac2;
    
    List<ERP_Reference_Data__c> erp = new List<ERP_Reference_Data__c>();
    erp.add(LSOac1);
    erp.add(LSOac2);
    insert erp;
   
    ERP_Reference_Data__c LSOerp= new ERP_Reference_Data__c();        
    LSOerp.Account__c = acc.id;
    LSOerp.Country__c = 'France';                       
    LSOerp.LSO_ERP_Mapping_Value__c = 'LSO-LSO Description';
    LSOerp.LSO__c = 'LSOac1'; 
    LSOerp.LBU__c = 'LBUac1';  
    //insert LSOerp;
    
    ERP_Reference_Data__c LSOerp1= new ERP_Reference_Data__c();        
    LSOerp1.Account__c = ac.id;
    LSOerp1.Country__c = 'France';                       
    LSOerp1.LSO_ERP_Mapping_Value__c = 'LSO-LSO Description';
    LSOerp1.LSO__c = 'LSOac2'; 
    LSOerp1.LBU__c = 'LBUac2';  
    //insert LSOerp1;
    
    List<ERP_Reference_Data__c> erp1 = new List<ERP_Reference_Data__c>();
    erp1.add(LSOerp);
    erp1.add(LSOerp1);
    insert erp1;
   
    Profile up = [Select Id, Name from Profile where profile.name = 'ABB Sales Standard Profile' Limit 1];
    User u = new User();
    u.firstname = '2168';
    u.lastname = 'Test user2168';
    u.Username ='test@xyzdg.com';
    u.Alias = 'tester';
    u.CommunityNickname = 'tester';
    u.TimeZoneSidKey ='Europe/London';
    u.LocaleSidKey ='en_US';
    u.EmailEncodingKey ='ISO-8859-1';
    u.LanguageLocaleKey ='en_US';
    u.email = 'abc@xyz.com';
    u.profileid = up.id;
    u.isActive = true;
    u.Default_BU__c = 'LBUac1';
    u.Default_LSO__c ='LSOac1';
    insert u;
         
    Opportunity o1 = new Opportunity();
    o1.ownerid = u.id;
    o1.accountId = ac.id;
    o1.Account_End_User__c = acc.id; 
    o1.Customer_Buying_Path__c = 'Awareness';
    o1.name = '2168 Oppty1';
    o1.Specific_Opportunity_Info__c = '2168TestAuto';
    o1.StageName = 'Prospecting';
    o1.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    o1.CloseDate = date.Today();
    //Test.StartTest();
    insert o1;    
    Test.StopTest();
    Opportunity Oppty = [Select Id,Name,Account_Customer_LSO_Reference_Data__c,End_User_LSO_Reference_Data__c from Opportunity where id =:o1.id];
    System.assertEquals(Oppty.Account_Customer_LSO_Reference_Data__c,LSOac1.Id);
    System.assertEquals(Oppty.End_User_LSO_Reference_Data__c,LSOerp.Id);
     /*try {
       o1.Account_Customer_LSO_Reference_Data__c = LSOac2.id;
       o1.End_User_LSO_Reference_Data__c = LSOerp1.id;
       Update o1;
      System.assert(false,'Exception expected');
    } catch (DMLException e){
    System.assert(e.getMessage().contains('The selected Account Customer LSO Reference Data is not associated with the Opportunity's Account Customer'), 'message=......' + e.getMessage());
    System.assert(e.getMessage().contains('The selected Account End User LSO Reference Data is not associated with the Opportunity's Account End User.'), 'message=......' + e.getMessage());
    }*/
   } 
}

static testMethod void updateWinnerPriceTest()
   {
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
    a.Name = '2168 AccountCustomer1';
    a.BillingCountry = 'India';
    a.BillingStreet = 'Test Street';
    a.BillingCity = 'Test City';
    insert a;
    
    Account acc = new Account();
    acc.Name = 'test Enduser';
    acc.BillingCountry = 'India';
    acc.BillingStreet = 'Test Street';
    acc.BillingCity = 'Test City';
    insert acc;
  
    Opportunity o = new Opportunity();
    o.AccountId = a.id;
    //o.RecordtypeId = rg.id;
    //o.End_User_Project__c = 'Testct';
    o.Name = 'ES-Acciona, S.A-Test';
    o.StageName = 'Opportunity Pursuit';
    o.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    o.Specific_Opportunity_Info__c ='Test';
    o.Confidence_Level__c ='No Delay Expected';
    //o.Probability_Verification__c = '';
    //o.ABB_Location__c ='Test';
    o.CloseDate = date.today();
    o.Opportunity_Value__c = 10;
    //o.Technical_Amount_USD = ''
    o.Industry_Usage__c = 'BLD.10.1';
    o.Channel_Class_Level1__c = 'DEU';
    o.Customer_Buying_Path__c = 'Awareness';
    //o.Opportunity_Winner__c = a.id;
    Test.StartTest();
    insert o;
    
    Competitor__c comp = new Competitor__c();
    comp.Opportunity__c = o.id;
    comp.Competitor__c = acc.id;
    comp.Winning_Company__c = True;
    comp.Percentage__c = '20';
    insert comp;
    
    Test.StopTest();
    
    Competitor__c compt = [Select Id,Estimated_Sale_Price__c from Competitor__c where id =:comp.id];
    Opportunity Oppty = [Select Id,Name,Opportunity_Winner__c,Winners_Price__c from Opportunity where id =:o.id];
    System.assertEquals(Oppty.Opportunity_Winner__c,acc.Id);
    System.assertEquals(Oppty.Winners_Price__c ,compt.Estimated_Sale_Price__c );
    //System.assertEquals(Oppty.Winners_Price__c ,3 );
    }
    }
    static testMethod void syncWinnerManualUpdateTest()
   {
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
    a.Name = '2168 AccountCustomer1';
    a.BillingCountry = 'India';
    a.BillingStreet = 'Test Street';
    a.BillingCity = 'Test City';
    insert a;
    
    Account acc = new Account();
    acc.Name = 'test Enduser';
    acc.BillingCountry = 'India';
    acc.BillingStreet = 'Test Street';
    acc.BillingCity = 'Test City';
    insert acc;
  
    Opportunity o = new Opportunity();
    o.AccountId = a.id;
    //o.RecordtypeId = rg.id;
    //o.End_User_Project__c = 'Testct';
    o.Name = 'ES-Acciona, S.A-Test';
    o.StageName = 'Opportunity Pursuit';
    o.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    o.Specific_Opportunity_Info__c ='Test';
    o.Confidence_Level__c ='No Delay Expected';
    //o.Probability_Verification__c = '';
    //o.ABB_Location__c ='Test';
    o.CloseDate = date.today();
    //o.Opportunity_Value__c = 10;
    //o.Technical_Amount_USD = ''
    o.Industry_Usage__c = 'BLD.10.1';
    o.Channel_Class_Level1__c = 'DEU';
    o.Customer_Buying_Path__c = 'Awareness';
    o.Opportunity_Winner__c = acc.id;
    insert o;
    
    Competitor__c comp = new Competitor__c();
    comp.Opportunity__c = o.id;
    comp.Competitor__c = acc.id;
    comp.Winning_Company__c = True;
    comp.Percentage__c = '20';
    insert comp;
    
    Competitor__c compt = [Select Id,Estimated_Sale_Price__c from Competitor__c where id =:comp.id];
    Opportunity Oppty = [Select Id,Name,Opportunity_Winner__c,Winners_Price__c from Opportunity where id =:o.id];
    System.assertEquals(Oppty.Opportunity_Winner__c,acc.Id);
    System.assertEquals(Oppty.Winners_Price__c ,compt.Estimated_Sale_Price__c );
    
    Test.StartTest();
    o.Opportunity_Value__c = 10;
    update o;   
    Test.StopTest();
    
    System.assertEquals(Oppty.Winners_Price__c ,compt.Estimated_Sale_Price__c );
    }
    }
 }