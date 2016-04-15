/*
*  This test class used to test class ClsAddOpportunityTeamToRfqTeam. 
*
@author Aswini Arasu
@created 2016-03-18
@version 1.0  
*/
@istest(SeeAllData = False)
private class ClsAddOpportunityTeamToRfqTeamTest{
 /*  Description of the purpose of the method. 
    *  @name methodTest
*/ 
  static testMethod void  methodTest(){
  
        Account a = new Account();
        a.Name = 'Acciona, S.A';
        a.BillingStreet = 'dajie';
        a.BillingCity = 'berlin';
        a.BillingState = 'Berlin';
        a.BillingPostalCode = '20012';
        a.BillingCountry = 'Germany';
        insert a;
        
        Profile up = [Select Id, Name from Profile where profile.name = 'System Administrator' Limit 1];
        User u = new User();
        u.firstname = '2503';
        u.lastname = 'TestUser';
        u.Username ='test2503@xyzdqg.com';
        u.Alias = 'tester';
        u.CommunityNickname = 'tester1';
        u.TimeZoneSidKey ='Europe/London';
        u.LocaleSidKey ='en_US';
        u.EmailEncodingKey ='ISO-8859-1';
        u.LanguageLocaleKey ='en_US';
        u.email = 'abc@wxyz.com';
        u.profileid = up.id;
        u.isActive = true;
        u.Division_DIV__c = 'DM';
        u.Default_BU__c = 'LBUac1';
        u.Default_LSO__c ='LSOac1';
        insert u;
        
        Profile up1 = [Select Id, Name from Profile where profile.name = 'ABB Sales Standard Profile' Limit 1];
        User u1 = new User();
        u1.firstname = '2504';
        u1.lastname = 'TestUser1';
        u1.Username ='test25031@xyzuiqg.com';
        u1.Alias = 'tester1';
        u1.CommunityNickname = 'tester2';
        u1.TimeZoneSidKey ='Europe/London';
        u1.LocaleSidKey ='en_US';
        u1.EmailEncodingKey ='ISO-8859-1';
        u1.LanguageLocaleKey ='en_US';
        u1.email = 'abcd@wxyz.com';
        u1.profileid = up1.id;
        u1.isActive = true;
        u1.Division_DIV__c = 'DM';
        u1.Default_BU__c = 'LBUac1';
        u1.Default_LSO__c ='LSOac1';
        insert u1;
        
        Profile up2 = [Select Id, Name from Profile where profile.name = 'ABB Sales Standard Profile' Limit 1];
        User u2 = new User();
        u2.firstname = '2505';
        u2.lastname = 'TestUser2';
        u2.Username ='test25051@xyzuiqg.com';
        u2.Alias = 'tester2';
        u2.CommunityNickname = 'tester3';
        u2.TimeZoneSidKey ='Europe/London';
        u2.LocaleSidKey ='en_US';
        u2.EmailEncodingKey ='ISO-8859-1';
        u2.LanguageLocaleKey ='en_US';
        u2.email = 'abcd@wxyzghe.com';
        u2.profileid = up2.id;
        u2.isActive = true;
        u2.Division_DIV__c = 'DM';
        u2.Default_BU__c = 'LBUac2';
        u2.Default_LSO__c ='LSOac2';
        insert u2;
 
 
       Opportunity o = new Opportunity();
       o.AccountId = a.id;
       o.Name = 'ES-Acciona, S.A-Test';
       o.StageName = 'Prospecting';
       o.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
       o.Specific_Opportunity_Info__c ='Test';
       o.Confidence_Level__c ='No Delay Expected';
       o.CloseDate = date.today();
       o.Industry_Usage__c = 'BLD.10.1';
       insert o;
       
      OpportunityTeamMember oppTeam = new OpportunityTeamMember ();
      oppTeam.UserId=u2.id;
      oppTeam.TeamMemberRole= 'Sales Rep';
      oppTeam.OpportunityAccessLevel='Read';
      oppTeam.OpportunityId = o.id;
      insert oppTeam;
     
      System.runAs(u) {
      Test.startTest();
      RFP__c rfp = new RFP__c();
      rfp.Name = 'Test';
      rfp.Rfp_Account_Manager__c = u.id;
      rfp.Rfp_Opportunity__c = o.id;
      rfp.Rfp_Account_Manager_Country__c = 'Germany';
      rfp.Rfp_Due_Date__c = System.today();
      rfp.Rfp_A4__c = 'Budgetary';
      rfp.Rfp_Commercial_Terms__c = 'Previously Negotiated Agreement ';
      rfp.CurrencyIsoCode = 'USD';
      insert rfp;
      
      RFP_Team__c rfpTeam = new RFP_Team__c();
      rfpTeam.Access_Level__c = 'Read/Write';
      rfpTeam.User__c = u1.id;
      rfpTeam.Team_Role__c = 'Business Support';
      rfpTeam.RFP__c= rfp.id ;
      insert rfpTeam;
      
      PageReference pageRef = Page.AddOpportunityTeamToRfqTeamPage; 
      pageRef.getParameters().put('id', String.valueOf(rfp.Id));
      Test.setCurrentPage(pageRef);
    
      ApexPages.StandardController stdRfp = new ApexPages.StandardController(rfp);
      ClsAddOpportunityTeamToRfqTeam objController  =  new ClsAddOpportunityTeamToRfqTeam(stdRfp);    
      objController.updateRfqTeam();
      Test.StopTest();
    
    }
    }
    
    }