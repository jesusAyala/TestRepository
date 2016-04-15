/**
*  This test class used to test the method 
*  setLSORefDatafromAccount 
*  in class ClsTriggerEndUserProjectHandler.
*
@author Shankar Anand
@created 2015-10-06
@version 1.0   

* coverage 84% 
*/

@istest(SeeAllData = False)
public class clsTriggerEUPHandlerLSO_Test{

static testMethod void  methodTest(){
 
    RecordType enb = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Account' and DeveloperName = 'External_Non_Buying_Account'];  
    RecordType ga = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Account' and DeveloperName = 'GIS_Approved'];
 
       
    Account eu = new Account();
    eu.Name = '2168 AccountEndUser1';
    eu.BillingCountry = 'India';
    eu.BillingStreet = 'Test Street';
    eu.BillingCity = 'Test City';
    eu.RecordtypeId = enb.id;
    insert eu;
    
    
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
    
    End_User_Project__c o1 = new End_User_Project__c();
    o1.ownerid = u.id;
    o1.Account_End_User__c = eu.id; 
    o1.End_User_Project_Status__c= 'Open';
    o1.name = '2168 EUP1';
    insert o1;
    
    End_User_Project__c eup = [Select Id,Name,Account_LSO_Reference_Data__c from End_User_Project__c where name = '2168 EUP1' Limit 1];
    System.assertEquals(LSOeu1.Id,eup.Account_LSO_Reference_Data__c);
    
    
}

static testMethod void  methodTest1(){
 
    RecordType enb = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Account' and DeveloperName = 'External_Non_Buying_Account'];  
    RecordType ga = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Account' and DeveloperName = 'GIS_Approved'];
 
    
    Account eu1 = new Account();
    eu1.Name = '2168 AccountEndUser2';
    eu1.BillingCountry = 'India';
    eu1.BillingStreet = 'Test Street';
    eu1.BillingCity = 'Test City';
    eu1.RecordtypeId = enb.id;
    insert eu1;

    ERP_Reference_Data__c LSOeu1 = new ERP_Reference_Data__c();        
    LSOeu1.Account__c = eu1.id;
    LSOeu1.Country__c = 'Italy';                       
    LSOeu1.LSO_ERP_Mapping_Value__c = 'LSO-LSO Description';
    LSOeu1.LSO__c = 'LSOac'; 
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
    
    End_User_Project__c o1 = new End_User_Project__c();
    o1.ownerid = u.id;
    o1.Account_End_User__c = eu1.id; 
    o1.End_User_Project_Status__c= 'Open';
    o1.name = '2168 EUP1';
    insert o1;
    
    End_User_Project__c eup1 = [Select Id,Name,Account_LSO_Reference_Data__c from End_User_Project__c where name = '2168 EUP1' Limit 1];
    System.assertEquals(null,eup1.Account_LSO_Reference_Data__c);
    
    eu1.BillingCountry = 'Spain';
    update eu1;
    End_User_Project__c eup2 = [Select Id,Name,Account_LSO_Reference_Data__c from End_User_Project__c where name = '2168 EUP1' Limit 1];
    System.assertEquals(null,eup2.Account_LSO_Reference_Data__c);
    
}
}