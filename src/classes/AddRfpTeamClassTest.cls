/*
*  This test class used to test class AddfpTeamClass.
   This test class used to test class ClsTriggerRfpTeamHandler.
   
*
@author Aswini Arasu
@created 2016-03-18
@version 1.0  
*/
@istest(SeeAllData = False)
private class AddRfpTeamClassTest{
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
        
        Profile up = [Select Id, Name from Profile where profile.name = 'ABB Sales Standard Profile' Limit 1];
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
  
        User u1 = new User();
        u1.FirstName ='haobo';
        u1.LastName = 'song';
        u1.Username = 'test123ABB1237@test123ABB1237.com';
        u1.Alias = 'mtst1';
        u1.Email = 'mtester1@company.com';
        u1.CommunityNickname = u1.Alias;
        u1.ProfileId = [Select Id from Profile Where Name = 'ABB Sales Standard Profile' limit 1].Id;
        u1.TimeZoneSidKey = 'America/Chicago';
        u1.LocaleSidKey = 'en_US';
        u1.EmailEncodingKey = 'UTF-8';
        u1.LanguageLocaleKey = 'en_US';
        u1.ManagerId = UserInfo.getUserId();
        insert u1;
        
        User u2 = new User();
        u2.FirstName ='haobooo';
        u2.LastName = 'songooo';
        u2.Username = 'test1234awsedr@test1234.com';
        u2.Alias = 'mtst2';
        u2.Email = 'mtester2ABB1236@companyABB1236.com';
        u2.CommunityNickname = u2.Alias;
        u2.ProfileId = [Select Id from Profile Where Name = 'ABB Sales Standard Profile' limit 1].Id;
        u2.TimeZoneSidKey = 'America/Chicago';
        u2.LocaleSidKey = 'en_US';
        u2.EmailEncodingKey = 'UTF-8';
        u2.LanguageLocaleKey = 'en_US';
        u2.ManagerId = UserInfo.getUserId();
        insert u2;
        
        User u3 = new User();
        u3.FirstName ='haobot';
        u3.LastName = 'songf';
        u3.Username = 'test12345awsedr@test12345.com';
        u3.Alias = 'mtst3';
        u3.Email = 'mtester2ABB1236@companyABB1236.com';
        u3.CommunityNickname = u3.Alias;
        u3.ProfileId = [Select Id from Profile Where Name = 'ABB Sales Standard Profile' limit 1].Id;
        u3.TimeZoneSidKey = 'America/Chicago';
        u3.LocaleSidKey = 'en_US';
        u3.EmailEncodingKey = 'UTF-8';
        u3.LanguageLocaleKey = 'en_US';
        u3.ManagerId = UserInfo.getUserId();
        insert u3;
        
        User u4 = new User();
        u4.FirstName ='haoboahgg';
        u4.LastName = 'songloo';
        u4.Username = 'test12344awsedr@test12346.com';
        u4.Alias = 'mtst4';
        u4.Email = 'mtester2ABB1236@companyABB1236.com';
        u4.CommunityNickname = u4.Alias;
        u4.ProfileId = [Select Id from Profile Where Name = 'ABB Sales Standard Profile' limit 1].Id;
        u4.TimeZoneSidKey = 'America/Chicago';
        u4.LocaleSidKey = 'en_US';
        u4.EmailEncodingKey = 'UTF-8';
        u4.LanguageLocaleKey = 'en_US';
        u4.ManagerId = UserInfo.getUserId();
        insert u4;
        
        User u5 = new User();
        u5.FirstName ='haobokjug';
        u5.LastName = 'songugyufvyf';
        u5.Username = 'test1234567awsedr@test1234.com';
        u5.Alias = 'mtst5';
        u5.Email = 'mtester2ABB1236@companyABB1236.com';
        u5.CommunityNickname = u5.Alias;
        u5.ProfileId = [Select Id from Profile Where Name = 'ABB Sales Standard Profile' limit 1].Id;
        u5.TimeZoneSidKey = 'America/Chicago';
        u5.LocaleSidKey = 'en_US';
        u5.EmailEncodingKey = 'UTF-8';
        u5.LanguageLocaleKey = 'en_US';
        u5.ManagerId = UserInfo.getUserId();
        insert u5;
        
        Test.StartTest();
         
   
    
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
    
      RFP_Team__c rfpTeam = new RFP_Team__c();
        
      rfpTeam.Access_Level__c = 'Read/Write';
      rfpTeam.User__c = u1.id;
      rfpTeam.Team_Role__c = 'Business Support';
      rfpTeam.RFP__c= rfp.id ;
      insert rfpTeam;
        
        RFP_Team__c  rfpTeam1 = new RFP_Team__c ();
        rfpTeam1.Access_Level__c = 'Read/Write';
        rfpTeam1.User__c = u2.id;
        rfpTeam1.Team_Role__c = 'Business Support';
        rfpTeam1.RFP__c = rfp.id ;
        insert rfpTeam1;
        
        RFP_Team__c  rfpTeam2 = new RFP_Team__c ();
        rfpTeam2.Access_Level__c = 'Read/Write';
        rfpTeam2.User__c = u3.id;
        rfpTeam2.Team_Role__c = 'Business Support';
        rfpTeam2.RFP__c = rfp.id ;
        insert rfpTeam2;
        
        rfpTeam1.User__c = u3.id;
        rfpTeam1.Access_Level__c = 'Read/Write';
        rfpTeam1.Team_Role__c = 'Technical Advisor';
        update rfpTeam1;
        rfpTeam2.Access_Level__c = 'Read/Write';
        update rfpTeam2;
        Delete rfpTeam ;
        
        rfpTeam1.User__c = u3.id;
        update rfpTeam1;
        
        String testLbl = Label.CL00100;
        system.debug(logginglevel.error,testLbl);
        
        String testLbl1 = Label.CL00019;
        system.debug(logginglevel.error,testLbl1);
        
        
        System.runAs(u){
        
        PageReference pageRef = Page.AddRfpTeam; 
        pageRef.getParameters().put('id', String.valueOf(rfp.Id));
        Test.setCurrentPage(pageRef);
        
        RFP_Team__c  stdRFP = new  RFP_Team__c ();
        ApexPages.StandardController sc = new ApexPages.StandardController(stdRFP);
        AddRfpTeamClass objRFP = new AddRfpTeamClass(sc);
        objRFP.rfpTeamMember1.User__c = u1.id;
        objRFP.rfpTeamMember2.User__c = u2.id;
        objRFP.rfpTeamMember3.User__c = u3.id;
        objRFP.rfpTeamMember4.User__c = u4.id;
        objRFP.rfpTeamMember5.User__c = u5.id;
        objRFP.saveRecords();
        objRFP.cancel();
        
        AddRfpTeamClass objRFP1 = new AddRfpTeamClass(sc);
        objRFP1.rfpTeamMember1.User__c = u1.id;
        objRFP1.rfpTeamMember2.User__c = u2.id;
        objRFP1.rfpTeamMember3.User__c = u3.id;
        objRFP1.rfpTeamMember4.User__c = u4.id;
        objRFP1.rfpTeamMember5.User__c = u5.id;
        objRFP1.saveMoreRecords();
        objRFP1.cancel();
        Test.StopTest();  
        }
        }
  //return null
        }