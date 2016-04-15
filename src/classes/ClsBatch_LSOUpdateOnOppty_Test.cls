/**
*  This test class used to test the Batch class 
*  ClsBatch_LSOUpdateOnOppty
*
@author Shankar Anand
@created 2015-10-16
@version 1.0   

* coverage 92% 
*/

@istest(SeeAllData = False)
public class ClsBatch_LSOUpdateOnOppty_Test{

static testMethod void  methodTest(){
 
    RecordType enb = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Account' and DeveloperName = 'External_Non_Buying_Account'];  
    RecordType ga = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Account' and DeveloperName = 'GIS_Approved'];
     
    Account ac = new Account();
    ac.Name = '2168 AccountCustomer1';
    ac.BillingCountry = 'India';
    ac.BillingStreet = 'Street09';
    ac.BillingCity = 'Mumbai';
    //ac.RecordtypeId = ga.id;   
    insert ac;
    
    Account ac1 = new Account();
    ac1.Name = '2168 AccountCustomer122';
    ac1.BillingCountry = 'Spain';
    ac1.BillingStreet = 'TestStreet123';
    ac1.BillingCity = 'Barcelona';
    //ac1.RecordtypeId = ga.id;   
    insert ac1;
          
    ERP_Reference_Data__c LSOac1 = new ERP_Reference_Data__c();        
    LSOac1.Account__c = ac.id;
    LSOac1.Country__c = 'Italy';                       
    LSOac1.LSO_ERP_Mapping_Value__c = 'LSO-LSO Description';
    LSOac1.LSO__c = 'LSOac1'; 
    LSOac1.LBU__c = 'LBUac1';  
    insert LSOac1;
    
    ERP_Reference_Data__c LSOac2 = new ERP_Reference_Data__c();        
    LSOac2.Account__c = ac1.id;
    LSOac2.Country__c = 'Spain';                       
    LSOac2.LSO_ERP_Mapping_Value__c = 'LSO-LSO Description';
    LSOac2.LSO__c = 'LSOac2'; 
    LSOac2.LBU__c = 'LBUac2';
    insert LSOac2;
    
    Test.startTest();        
    Account eu = new Account();
    eu.Name = '2168 AccountEndUser123';
    eu.BillingCountry = 'Germany';
    eu.BillingStreet = 'TestSt5345';
    eu.BillingCity = 'Munich';
    //eu.RecordtypeId = enb.id;
    insert eu;
    
    ERP_Reference_Data__c LSOeu1 = new ERP_Reference_Data__c();        
    LSOeu1.Account__c = eu.id;
    LSOeu1.Country__c = 'Italy';                       
    LSOeu1.LSO_ERP_Mapping_Value__c = 'LSO-LSO Description';
    LSOeu1.LSO__c = 'LSOac1'; 
    LSOeu1.LBU__c = 'LBUac1';
    insert LSOeu1;
    
    ERP_Reference_Data__c LSOeu2 = new ERP_Reference_Data__c();        
    LSOeu2.Account__c = eu.id;
    LSOeu2.Country__c = 'Spain';                       
    LSOeu2.LSO_ERP_Mapping_Value__c = 'LSO-LSO Description';
    LSOeu2.LSO__c = 'LSOeu2'; 
    LSOeu2.LBU__c = 'LBUeu2';
    insert LSOeu2;
    
    Account pac = new Account();
    pac.Name = '2168 PrimaryPartnerAccount';
    pac.BillingCountry = 'Italy';
    pac.BillingStreet = 'VinciSt';
    pac.BillingCity = 'Milan';
    //pac.RecordtypeId = enb.id;
    insert pac;
    
    ERP_Reference_Data__c ERPpac1 = new ERP_Reference_Data__c();        
    ERPpac1.Account__c = pac.id;
    ERPpac1.Country__c = 'Italy';                       
    ERPpac1.LSO_ERP_Mapping_Value__c = 'LSO-LSO Description';
    ERPpac1.LSO__c = 'LSOac1'; 
    ERPpac1.LBU__c = 'LBUac1';
    insert ERPpac1;
    
    ERP_Reference_Data__c ERPpac2 = new ERP_Reference_Data__c();        
    ERPpac2.Account__c = pac.id;
    ERPpac2.Country__c = 'Italy';                       
    ERPpac2.LSO_ERP_Mapping_Value__c = 'LSO-LSO Description';
    ERPpac2.LSO__c = 'LSOERPpac2'; 
    ERPpac2.LBU__c = 'LBUERPpac2';
    insert ERPpac2;
    
    
    Account tac = new Account();
    tac.Name = '2168 PartnerAccount';
    tac.BillingCountry = 'Poland';
    tac.BillingStreet = 'PolStreet343';
    tac.BillingCity = 'TestCity';
    //tac.RecordtypeId = enb.id;
    insert tac;
    
    ERP_Reference_Data__c ERPtac1 = new ERP_Reference_Data__c();        
    ERPtac1.Account__c = tac.id;
    ERPtac1.Country__c = 'Spain';                       
    ERPtac1.LSO_ERP_Mapping_Value__c = 'LSO-LSO Description';
    ERPtac1.LSO__c = 'LSOERPtac1'; 
    ERPtac1.LBU__c = 'LBUERPtac1';
    insert ERPtac1;
    
    ERP_Reference_Data__c ERPtac2 = new ERP_Reference_Data__c();        
    ERPtac2.Account__c = tac.id;
    ERPtac2.Country__c = 'Spain';                       
    ERPtac2.LSO_ERP_Mapping_Value__c = 'LSO-LSO Description';
    ERPtac2.LSO__c = 'LSOERPtac2'; 
    ERPtac2.LBU__c = 'LBUERPtac2';
    insert ERPtac2;
  
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
    
    Product_Group__c pg = new Product_Group__c();
    pg.Business_Unit__c = 'tdsd';
    pg.Name = 'jinboetdspro';
    pg.Division__c = '10';
    insert pg;
    
    Partner op1 = new Partner();
    op1.accountToId = pac.id;
    op1.opportunityId = o1.id;
    op1.role = 'Consultant';
    op1.isPrimary = false;
    insert op1;
    
    Partner op2 = new Partner();
    op2.accountToId = tac.id;
    op2.opportunityId = o1.id;
    op2.role = 'Investor';
    op2.isPrimary = false;
    insert op2;
    Test.stopTest();
   
        ClsBatch_LSOUpdateOnOppty b = new ClsBatch_LSOUpdateOnOppty();
        database.executeBatch(b);
    
  
    Opportunity vOppty = [Select Id,Name,Account_Customer_LSO_Reference_Data__c,End_User_LSO_Reference_Data__c,Primary_Partner_LSO_Reference_Data__c from Opportunity where Specific_Opportunity_Info__c = '2168TestAuto' Limit 1];
    
    System.assertEquals(vOppty.Account_Customer_LSO_Reference_Data__c,LSOac1.Id);
    System.assertEquals(vOppty.End_User_LSO_Reference_Data__c,LSOeu1.Id);
    System.assertEquals(null,vOppty.Primary_Partner_LSO_Reference_Data__c);
    
}
}