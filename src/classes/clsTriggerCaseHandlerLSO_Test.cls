/**
*  This test class used to test the methods 
*  setLSORefDatafromAccountOnInsert 
*  and 
*  setLSOrefDataFromAccountOnUpdate 
*  in class ClsTriggerCaseHandler.
*
@author Shankar Anand
@created 2015-10-06
@version 1.0   

* coverage 78% 
*/


@istest(SeeAllData = False)
public class clsTriggerCaseHandlerLSO_Test{

static testMethod void  methodTest(){
 
    RecordType enb = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Account' and DeveloperName = 'External_Non_Buying_Account'];  
    RecordType ga = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Account' and DeveloperName = 'GIS_Approved'];
 
       
    Account eu = new Account();
    eu.Name = '2168 AccountCase1';
    eu.BillingCountry = 'India';
    eu.BillingStreet = 'Test Street';
    eu.BillingCity = 'Test City';
    eu.RecordtypeId = enb.id;
    insert eu;
    
    Contact con = new Contact();
    con.firstname = 'John';
    con.lastname = 'Doe';
    con.email = 'abcd@xyz.com';
    con.accountId = eu.Id;
    con.Type__c = 'External';
    con.Preferred_Language__c = 'English';
    insert con;
   
    
    ERP_Reference_Data__c LSOeu1 = new ERP_Reference_Data__c();        
    LSOeu1.Account__c = eu.id;
    LSOeu1.Country__c = 'Italy';                       
    LSOeu1.LSO_ERP_Mapping_Value__c = 'LSO-LSO Description';
    LSOeu1.LSO__c = 'LSOac1'; 
    LSOeu1.LBU__c = 'LBUac1';
    insert LSOeu1;
   
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
    
    Case o1 = new Case();
    o1.ownerid = u.id;
    o1.AccountId = eu.id;
    o1.Subject = 'TESTLSOAutomation';
    o1.Originating_Country__c = 'Albania';
    o1.Division__c = 'DM';
    o1.Description = 'Testing';
    o1.Category__c = 'Pre Sales';
    o1.Status= 'New';
    o1.contactId = con.id;
    insert o1;
    
    Case cs = [Select Id,Account_LSO_Case__c from Case where Subject = 'TESTLSOAutomation' Limit 1];
    System.assertEquals(LSOeu1.Id,cs.Account_LSO_Case__c);
  
   
}

static testMethod void  methodTest1(){
 
    RecordType enb = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Account' and DeveloperName = 'External_Non_Buying_Account'];  
    RecordType ga = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Account' and DeveloperName = 'GIS_Approved'];
    
    Account eu1 = new Account();
    eu1.Name = '2168 AccountCase2';
    eu1.BillingCountry = 'India';
    eu1.BillingStreet = 'Test Street';
    eu1.BillingCity = 'Test City';
    eu1.RecordtypeId = enb.id;
    insert eu1;
    
    Contact con = new Contact();
    con.firstname = 'John';
    con.lastname = 'Doe';
    con.email = 'abcd@xyz.com';
    con.accountId = eu1.Id;
    con.Type__c = 'External';
    con.Preferred_Language__c = 'English';
    insert con;
    
    ERP_Reference_Data__c LSOeu2 = new ERP_Reference_Data__c();        
    LSOeu2.Account__c = eu1.id;
    LSOeu2.Country__c = 'Spain';                       
    LSOeu2.LSO_ERP_Mapping_Value__c = 'LSO-LSO Description';
    LSOeu2.LSO__c = 'LSOeu2'; 
    LSOeu2.LBU__c = 'LBUeu2';
    insert LSOeu2;
  
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
    
    Case o1 = new Case();
    o1.ownerid = u.id;
    o1.AccountId = eu1.id;
    o1.Subject = 'TESTLSOAutomation';
    o1.Originating_Country__c = 'Albania';
    o1.Division__c = 'DM';
    o1.Description = 'Testing';
    o1.Category__c = 'Pre Sales';
    o1.Status= 'New';
    o1.contactId = con.id;
    insert o1;
    
    Case cs1 = [Select Id,Account_LSO_Case__c from case where Subject = 'TESTLSOAutomation' Limit 1];
    System.assertEquals(null,cs1.Account_LSO_Case__c);
    
}
}