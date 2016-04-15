/**
*  This test class used to test the batch class 
*  ClsBatch_LSOUpdateOnEndUserProject 
*
@author Shankar Anand
@created 2015-10-16
@version 1.0   

* coverage 90% 
*/

@istest(SeeAllData = False)
public class ClsBatch_LSOUpdateOnEndUserProject_Test{

static testMethod void  methodTest(){
 
    RecordType enb = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Account' and DeveloperName = 'External_Non_Buying_Account'];  
    RecordType ga = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Account' and DeveloperName = 'GIS_Approved'];
 
       
    Account eu = new Account();
    eu.Name = '2168 AccountEndUser1';
    eu.BillingCountry = 'India';
    eu.BillingStreet = 'Street9087';
    eu.BillingCity = 'Chennai';
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
    
    Test.startTest();
        ClsBatch_LSOUpdateOnEndUserProject b = new ClsBatch_LSOUpdateOnEndUserProject();
        database.executeBatch(b);
    Test.stopTest();
    
    End_User_Project__c eup = [Select Id,Name,Account_LSO_Reference_Data__c from End_User_Project__c where name = '2168 EUP1' Limit 1];
    System.assertEquals(LSOeu1.Id,eup.Account_LSO_Reference_Data__c);
    
}

static testMethod void  methodTest1(){
 
    RecordType enb = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Account' and DeveloperName = 'External_Non_Buying_Account'];  
    RecordType ga = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Account' and DeveloperName = 'GIS_Approved'];
 
    
    Account eu2 = new Account();
    eu2.Name = '2168 AccountEndUser2';
    eu2.BillingCountry = 'India';
    eu2.BillingStreet = 'TestStreet1234';
    eu2.BillingCity = 'Delhi';
    //eu2.RecordtypeId = enb.id;
    insert eu2;
    
    ERP_Reference_Data__c LSOeu3 = new ERP_Reference_Data__c();        
    LSOeu3.Account__c = eu2.id;
    LSOeu3.Country__c = 'Italy';                       
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
    
    End_User_Project__c o1 = new End_User_Project__c();
    o1.ownerid = u.id;
    o1.Account_End_User__c = eu2.id; 
    o1.End_User_Project_Status__c= 'Open';
    o1.name = '2168 EUP1';
    insert o1;
    
    
    
    Test.startTest();
        ClsBatch_LSOUpdateOnEndUserProject b2 = new ClsBatch_LSOUpdateOnEndUserProject();
        database.executeBatch(b2);
    Test.stopTest();
    
    End_User_Project__c eup2 = [Select Id,Name,Account_LSO_Reference_Data__c from End_User_Project__c where name = '2168 EUP1' Limit 1]; 
    System.assertEquals(LSOeu3.Id,eup2.Account_LSO_Reference_Data__c);
    
}
}