/**
*  This test class used to test the method 
*  setLSORefDatafromAccount
*  in class ClsTriggerOpportunityHandler.
*
@author Shankar Anand
@created 2015-10-06
@version 1.0   

* coverage 70% 
*/

@istest
public class clsTriggerOpportunityHandlerLSO_Test{

static testMethod void  methodTest(){
 
    RecordType enb = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Account' and DeveloperName = 'External_Non_Buying_Account'];  
    RecordType ga = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Account' and DeveloperName = 'GIS_Approved'];
 
    Account ac = new Account();
    ac.Name = '2168 AccountCustomer1';
    ac.BillingCountry = 'India';
    ac.BillingStreet = 'Test Street';
    ac.BillingCity = 'Test City';
    ac.RecordtypeId = ga.id;   
    //insert ac;
    
    Account ac1 = new Account();
    ac1.Name = '2168 AccountCustomer1';
    ac1.BillingCountry = 'India';
    ac1.BillingStreet = 'Test Street';
    ac1.BillingCity = 'Test City';
    ac1.RecordtypeId = ga.id;   
    //insert ac1;
    
    Account eu = new Account();
    eu.Name = '2168 AccountEndUser1';
    eu.BillingCountry = 'India';
    eu.BillingStreet = 'Test Street';
    eu.BillingCity = 'Test City';
    eu.RecordtypeId = enb.id;
    //insert eu;
    
    Account pac = new Account();
    pac.Name = '2168 PrimaryPartnerAccount';
    pac.BillingCountry = 'India';
    pac.BillingStreet = 'Test Street';
    pac.BillingCity = 'Test City';
    pac.RecordtypeId = enb.id;
    //insert pac;
    
    Account tac = new Account();
    tac.Name = '2168 PartnerAccount';
    tac.BillingCountry = 'India';
    tac.BillingStreet = 'Test Street';
    tac.BillingCity = 'Test City';
    tac.RecordtypeId = enb.id;
   // insert tac;
     
    List<Account> acc = new List<Account>();
    acc.add(ac);
    acc.add(ac1);
    acc.add(eu);
    acc.add(pac);
    acc.add(tac);
    insert acc;
          
    ERP_Reference_Data__c LSOac1 = new ERP_Reference_Data__c();        
    LSOac1.Account__c = ac.id;
    LSOac1.Country__c = 'Italy';                       
    LSOac1.LSO_ERP_Mapping_Value__c = 'LSO-LSO Description';
    LSOac1.LSO__c = 'LSOac1'; 
    LSOac1.LBU__c = 'LBUac1';  
    //insert LSOac1;
    
    ERP_Reference_Data__c LSOac2 = new ERP_Reference_Data__c();        
    LSOac2.Account__c = ac1.id;
    LSOac2.Country__c = 'Spain';                       
    LSOac2.LSO_ERP_Mapping_Value__c = 'LSO-LSO Description';
    LSOac2.LSO__c = 'LSOac2'; 
    LSOac2.LBU__c = 'LBUac2';
    //insert LSOac2;
  
    
    ERP_Reference_Data__c LSOeu1 = new ERP_Reference_Data__c();        
    LSOeu1.Account__c = eu.id;
    LSOeu1.Country__c = 'Italy';                       
    LSOeu1.LSO_ERP_Mapping_Value__c = 'LSO-LSO Description';
    LSOeu1.LSO__c = 'LSOac1'; 
    LSOeu1.LBU__c = 'LBUac1';
    //insert LSOeu1;
    
    ERP_Reference_Data__c LSOeu2 = new ERP_Reference_Data__c();        
    LSOeu2.Account__c = eu.id;
    LSOeu2.Country__c = 'Spain';                       
    LSOeu2.LSO_ERP_Mapping_Value__c = 'LSO-LSO Description';
    LSOeu2.LSO__c = 'LSOeu2'; 
    LSOeu2.LBU__c = 'LBUeu2';
    //insert LSOeu2;
    
    
    ERP_Reference_Data__c ERPpac1 = new ERP_Reference_Data__c();        
    ERPpac1.Account__c = pac.id;
    ERPpac1.Country__c = 'Italy';                       
    ERPpac1.LSO_ERP_Mapping_Value__c = 'LSO-LSO Description';
    ERPpac1.LSO__c = 'LSOac1'; 
    ERPpac1.LBU__c = 'LBUac1';
    //insert ERPpac1;
    
    ERP_Reference_Data__c ERPpac2 = new ERP_Reference_Data__c();        
    ERPpac2.Account__c = pac.id;
    ERPpac2.Country__c = 'Italy';                       
    ERPpac2.LSO_ERP_Mapping_Value__c = 'LSO-LSO Description';
    ERPpac2.LSO__c = 'LSOERPpac2'; 
    ERPpac2.LBU__c = 'LBUERPpac2';
   // insert ERPpac2;
    
    
    
    ERP_Reference_Data__c ERPtac1 = new ERP_Reference_Data__c();        
    ERPtac1.Account__c = tac.id;
    ERPtac1.Country__c = 'Spain';                       
    ERPtac1.LSO_ERP_Mapping_Value__c = 'LSO-LSO Description';
    ERPtac1.LSO__c = 'LSOERPtac1'; 
    ERPtac1.LBU__c = 'LBUERPtac1';
    //insert ERPtac1;
    
    ERP_Reference_Data__c ERPtac2 = new ERP_Reference_Data__c();        
    ERPtac2.Account__c = tac.id;
    ERPtac2.Country__c = 'Spain';                       
    ERPtac2.LSO_ERP_Mapping_Value__c = 'LSO-LSO Description';
    ERPtac2.LSO__c = 'LSOERPtac2'; 
    ERPtac2.LBU__c = 'LBUERPtac2';
    //insert ERPtac2;
    
    List<ERP_Reference_Data__c> erp = new List<ERP_Reference_Data__c>();
    erp.add(LSOac1); 
    erp.add(LSOac2);
    erp.add(LSOeu1);
    erp.add(LSOeu2);
    erp.add(ERPpac1);
    erp.add(ERPpac2);
    erp.add(ERPtac1);
    erp.add(ERPtac2);
    insert erp;
 
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
    o1.Account_End_User__c = eu.id; 
    o1.Customer_Buying_Path__c = 'Awareness';
    o1.name = '2168 Oppty1';
    o1.Specific_Opportunity_Info__c = '2168TestAuto';
    o1.StageName = 'Prospecting';
    o1.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    o1.CloseDate = date.Today();
    insert o1;
    
    Opportunity vOppty = [Select Id,Name,Account_Customer_LSO_Reference_Data__c,End_User_LSO_Reference_Data__c,Primary_Partner_LSO_Reference_Data__c from Opportunity where Specific_Opportunity_Info__c = '2168TestAuto' Limit 1];
    
    System.assertEquals(vOppty.Account_Customer_LSO_Reference_Data__c,LSOac1.Id);
    System.assertEquals(vOppty.End_User_LSO_Reference_Data__c,LSOeu1.Id);
  
}

static testMethod void  methodTest1(){
    Test.StartTest();
    RecordType enb = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Account' and DeveloperName = 'External_Non_Buying_Account'];  
    RecordType ga = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Account' and DeveloperName = 'GIS_Approved'];
 
    Account ac = new Account();
    ac.Name = '2168 AccountCustomer1';
    ac.BillingCountry = 'India';
    ac.BillingStreet = 'Test Street';
    ac.BillingCity = 'Test City';
    ac.RecordtypeId = ga.id;   
    //insert ac;
    
    Account ac1 = new Account();
    ac1.Name = '2168 AccountCustomer1';
    ac1.BillingCountry = 'India';
    ac1.BillingStreet = 'Test Street';
    ac1.BillingCity = 'Test City';
    ac1.RecordtypeId = ga.id;   
    //insert ac1;
    
    Account eu = new Account();
    eu.Name = '2168 AccountEndUser1';
    eu.BillingCountry = 'India';
    eu.BillingStreet = 'Test Street';
    eu.BillingCity = 'Test City';
    eu.RecordtypeId = ga.id;
    //insert eu;
    
    Account pac = new Account();
    pac.Name = '2168 PrimaryPartnerAccount';
    pac.BillingCountry = 'India';
    pac.BillingStreet = 'Test Street';
    pac.BillingCity = 'Test City';
    pac.RecordtypeId = enb.id;
    //insert pac;
    
    Account tac = new Account();
    tac.Name = '2168 PartnerAccount';
    tac.BillingCountry = 'India';
    tac.BillingStreet = 'Test Street';
    tac.BillingCity = 'Test City';
    tac.RecordtypeId = enb.id;
    //insert tac;
    
    List<Account> Acc = new List<Account>();
    acc.add(ac);
    acc.add(ac1);
    acc.add(eu);
    acc.add(pac);
    acc.add(tac);
    insert acc;
    
    ERP_Reference_Data__c LSOac1 = new ERP_Reference_Data__c();        
    LSOac1.Account__c = ac.id;
    LSOac1.Country__c = 'Italy';                       
    LSOac1.LSO_ERP_Mapping_Value__c = 'LSO-LSO Description';
    LSOac1.LSO__c = 'LSOac1'; 
    LSOac1.LBU__c = 'LBUac1';  
    //insert LSOac1;
    
    ERP_Reference_Data__c LSOac2 = new ERP_Reference_Data__c();        
    LSOac2.Account__c = ac1.id;
    LSOac2.Country__c = 'Spain';                       
    LSOac2.LSO_ERP_Mapping_Value__c = 'LSO-LSO Description';
    LSOac2.LSO__c = 'LSOac2'; 
    LSOac2.LBU__c = 'LBUac2';
    //insert LSOac2;
  
    ERP_Reference_Data__c LSOeu1 = new ERP_Reference_Data__c();        
    LSOeu1.Account__c = eu.id;
    LSOeu1.Country__c = 'Italy';                       
    LSOeu1.LSO_ERP_Mapping_Value__c = 'LSO-LSO Description';
    LSOeu1.LSO__c = 'LSOac1';
    LSOeu1.LBU__c = 'LBUac1'; 
    //insert LSOeu1;
    
    ERP_Reference_Data__c LSOeu2 = new ERP_Reference_Data__c();        
    LSOeu2.Account__c = eu.id;
    LSOeu2.Country__c = 'Spain';                       
    LSOeu2.LSO_ERP_Mapping_Value__c = 'LSO-LSO Description';
    LSOeu2.LSO__c = 'LSOeu2'; 
    LSOeu2.LBU__c = 'LBUeu2';
    //insert LSOeu2;
   
    ERP_Reference_Data__c ERPpac1 = new ERP_Reference_Data__c();        
    ERPpac1.Account__c = pac.id;
    ERPpac1.Country__c = 'Italy';                       
    ERPpac1.LSO_ERP_Mapping_Value__c = 'LSO-LSO Description';
    ERPpac1.LSO__c = 'LSOac1'; 
    ERPpac1.LBU__c = 'LBUac1';
    //insert ERPpac1;
    
    ERP_Reference_Data__c ERPpac2 = new ERP_Reference_Data__c();        
    ERPpac2.Account__c = pac.id;
    ERPpac2.Country__c = 'Italy';                       
    ERPpac2.LSO_ERP_Mapping_Value__c = 'LSO-LSO Description';
    ERPpac2.LSO__c = 'LSOERPpac2'; 
    ERPpac2.LBU__c = 'LBUERPpac2';
    //insert ERPpac2;
   
    ERP_Reference_Data__c ERPtac1 = new ERP_Reference_Data__c();        
    ERPtac1.Account__c = tac.id;
    ERPtac1.Country__c = 'Spain';                       
    ERPtac1.LSO_ERP_Mapping_Value__c = 'LSO-LSO Description';
    ERPtac1.LSO__c = 'LSOERPtac1'; 
    ERPtac1.LBU__c = 'LBUERPtac1';
    //insert ERPtac1;
    
    List<ERP_Reference_Data__c> erp = new List<ERP_Reference_Data__c>();
    erp.add(LSOac1);
    erp.add(LSOac2);
    erp.add(LSOeu1);
    erp.add(LSOeu2);
    erp.add(ERPpac1);
    erp.add(ERPpac2);
    erp.add(ERPtac1);
    insert erp;
   
    ABB_Location__c abb = new ABB_Location__c();
    abb.name = 'TestABB';
    abb.CurrencyIsoCode = 'USD';
    abb.BU__c = 'abcd';
    abb.DIV__c = 'LP-Low Voltage Products';
    insert abb;
    
    Profile up = [Select Id, Name from Profile where profile.name = 'ABB Sales Standard Profile' Limit 1];
    User u = new User();
    u.firstname = '2168';
    u.lastname = 'Test user2168';
    u.Username ='testABBBBB1231234@xyzdgABB1231231.com';
    u.Alias = 'tester';
    u.CommunityNickname = 'tester';
    u.TimeZoneSidKey ='Europe/London';
    u.LocaleSidKey ='en_US';
    u.EmailEncodingKey ='ISO-8859-1';
    u.LanguageLocaleKey ='en_US';
    u.email = 'abc@xyz.com';
    u.profileid = up.id;
    u.isActive = true;
    u.Default_LSO__c ='LSOac1';
    u.Default_BU__c ='LBUac1'; 
    //insert u;
    
    User u1 = new User();
    u1.firstname = '2168LSO';
    u1.lastname = 'Test user2168LSO';
    u1.Username ='xyzABBB1231231@abcABB12312313.com';
    u1.Alias = 'test';
    u1.CommunityNickname = 'test';
    u1.TimeZoneSidKey ='Europe/London';
    u1.LocaleSidKey ='en_US';
    u1.EmailEncodingKey ='ISO-8859-1';
    u1.LanguageLocaleKey ='en_US';
    u1.email = 'abc@xyz.com';
    u1.profileid = up.id;
    u1.isActive = true;
    u1.Default_LSO__c ='LSOac1';
    u1.Default_BU__c ='LBUac1'; 
    //insert u1;
    
    List<User> user = new List<User>();
    user.add(u);
    user.add(u1);
    insert user ;
    
    Opportunity o1 = new Opportunity();
    o1.ownerid = u.id;
    o1.accountId = ac.id;
    o1.Account_End_User__c = eu.id; 
    o1.Customer_Buying_Path__c = 'Awareness';
    o1.name = '2168 Oppty1';
    o1.Specific_Opportunity_Info__c = '2168TestAuto';
    o1.StageName = 'Prospecting';
    o1.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    o1.CloseDate = date.Today();
    insert o1;
    o1.ownerid = u1.id;
    o1.accountId = eu.id;
    o1.Account_End_User__c = ac.id;
    o1.Channel_Class__c = 'ABBINT';
    o1.Industry_Usage__c = 'IND.6';
    o1.ABB_Location__c = abb.id;
    o1.Opportunity_Value__c = 100.00;
    update o1;
    
    
    
    //Opportunity vOppty = [Select Id,Name,Channel_Class__c,Account_Customer_LSO_Reference_Data__c,End_User_LSO_Reference_Data__c,Primary_Partner_LSO_Reference_Data__c from Opportunity where Specific_Opportunity_Info__c = '2168TestAuto' Limit 1];
   // System.assertEquals(vOppty.Account_Customer_LSO_Reference_Data__c,LSOeu1.Id);
    //System.assertEquals(vOppty.End_User_LSO_Reference_Data__c,LSOac1.Id);
    
    Partner op1 = new Partner();
    op1.accountToId = pac.id;
    op1.opportunityId = o1.id;
    op1.role = 'Consultant';
    op1.isPrimary = true;
    //insert op1;
    
    Partner op2 = new Partner();
    op2.accountToId = tac.id;
    op2.opportunityId = o1.id;
    op2.role = 'Investor';
    op2.isPrimary = false;
    //insert op2;
    
    List<Partner> Pat = new List<Partner>();
    pat.add(op1);
    pat.add(op2);
    insert pat;
    
    update o1;
    
    //Opportunity vOppty2 = [Select Id,Name,Account_Customer_LSO_Reference_Data__c,End_User_LSO_Reference_Data__c,Primary_Partner_LSO_Reference_Data__c from Opportunity where Specific_Opportunity_Info__c = '2168TestAuto' Limit 1];
    //System.assertEquals(ERPpac1.Id,vOppty2.Primary_Partner_LSO_Reference_Data__c);
    
    ERPpac1.LBU__c = null;
    update ERPpac1;
    u1.Default_BU__c = null;
    update u1;
    
    //Opportunity vOppty3 = [Select Id,Name,Account_Customer_LSO_Reference_Data__c,End_User_LSO_Reference_Data__c,Primary_Partner_LSO_Reference_Data__c from Opportunity where Specific_Opportunity_Info__c = '2168TestAuto' Limit 1];
    //System.assertEquals(ERPpac1.Id,vOppty3.Primary_Partner_LSO_Reference_Data__c);
    Test.StopTest();
  
}
}