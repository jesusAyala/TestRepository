/**
*  This test class used to test the batch class 
*  ClsBatch_LSOUpdateOnCase 
*
@author Shankar Anand
@created 2015-10-16
@version 1.0   

* coverage 90% 
*/


@istest(SeeAllData = False)
public class ClsBatch_LSOUpdateOnCase_Test{

static testMethod void  methodTest(){
 
    RecordType enb = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Account' and DeveloperName = 'External_Non_Buying_Account'];  
    RecordType ga = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Account' and DeveloperName = 'GIS_Approved'];
 
       
    Account eu = new Account();
    eu.Name = '2168 AccountCase1';
    eu.BillingCountry = 'India';
    eu.BillingStreet = 'TestStreet123';
    eu.BillingCity = 'Chennai';
    //eu.RecordtypeId = enb.id;
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
    
    ERP_Reference_Data__c LSOeu2 = new ERP_Reference_Data__c();        
    LSOeu2.Account__c = eu.id;
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
    o1.AccountId = eu.id;
    o1.Subject = 'TESTLSOAutomation';
    o1.Originating_Country__c = 'Albania';
    o1.Division__c = 'PS';
    o1.Description = 'Testing';
    o1.Category__c = 'Pre Sales';
    o1.Status= 'New';
    o1.contactId = con.id;
    insert o1;
    
    Test.startTest();
        ClsBatch_LSOUpdateOnCase b = new ClsBatch_LSOUpdateOnCase();
        database.executeBatch(b);
    Test.stopTest();
    
    Case cs = [Select Id,Account_LSO_Case__c from Case where Subject = 'TESTLSOAutomation' Limit 1];
    System.assertEquals(LSOeu1.Id,cs.Account_LSO_Case__c);
    
}

static testMethod void  methodTest1(){
 
    RecordType enb = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Account' and DeveloperName = 'External_Non_Buying_Account'];  
    RecordType ga = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Account' and DeveloperName = 'GIS_Approved'];
    
    Account eu2 = new Account();
    eu2.Name = '2168 AccountCase2';
    eu2.BillingCountry = 'India';
    eu2.BillingStreet = 'Street1234';
    eu2.BillingCity = 'Kolkata';
    //eu2.RecordtypeId = enb.id;
    insert eu2;
    
    Contact con = new Contact();
    con.firstname = 'John';
    con.lastname = 'Doe';
    con.email = 'abcd@xyz.com';
    con.accountId = eu2.Id;
    con.Type__c = 'External';
    con.Preferred_Language__c = 'English';
    insert con;
    
    ERP_Reference_Data__c LSOeu3 = new ERP_Reference_Data__c();        
    LSOeu3.Account__c = eu2.id;
    LSOeu3.Country__c = 'Spain';                       
    LSOeu3.LSO_ERP_Mapping_Value__c = 'LSO-LSO Description';
    LSOeu3.LSO__c = 'LSOac1'; 
    insert LSOeu3;
  
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
    u.Default_LSO__c ='LSOac1';
    insert u;
    
    Case o1 = new Case();
    o1.ownerid = u.id;
    o1.AccountId = eu2.id;
    o1.Subject = 'TESTLSOAutomation';
    o1.Originating_Country__c = 'Albania';
    o1.Division__c = 'PS';
    o1.Description = 'Testing';
    o1.Category__c = 'Pre Sales';
    o1.Status= 'New';
    o1.contactId = con.id;
    insert o1;
    
    
    
    Test.startTest();
        ClsBatch_LSOUpdateOnCase b2 = new ClsBatch_LSOUpdateOnCase();
        database.executeBatch(b2);
    Test.stopTest();
    
    Case cs2 = [Select Id,Account_LSO_Case__c from Case where Subject = 'TESTLSOAutomation' Limit 1];
    System.assertEquals(LSOeu3.Id,cs2.Account_LSO_Case__c); 
}
}