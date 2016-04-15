/*
*  This test class used to test class AddVisitReportTeamMemberClass.
   This test class used to test class ClsTriggerVisitReportTeamMemberHandler.
   
*
@author Aswini Arasu
@created 2015-12-31
@version 1.0  
*/
@istest(SeeAllData = False)
private class AddVisitReportTeamMemberClassTest{
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
        Visit_Report__c vr = new Visit_Report__c();
        vr.Account__c = a.id;
        vr.Name = 'test';
        vr.Date_of_Visit__c = System.today();
        vr.Reason__c = 'testnhduhugugfua';
        insert vr;
        
        Visit_Report_Team_Member__c vteam = new Visit_Report_Team_Member__c();
        
        vteam.Access_Level__c = 'Read/Write';
        vteam.User__c = u1.id;
        vteam.Team_Role__c = 'Business Support';
        vteam.Visit_Report__c = vr.id ;
        insert vteam;
        
        Visit_Report_Team_Member__c vteam1 = new Visit_Report_Team_Member__c();
        vteam1.Access_Level__c = 'Read/Write';
        vteam1.User__c = u2.id;
        vteam1.Team_Role__c = 'Business Support';
        vteam1.Visit_Report__c = vr.id ;
        insert vteam1;
        
        Visit_Report_Team_Member__c vteam2 = new Visit_Report_Team_Member__c();
        vteam2.Access_Level__c = 'Read/Write';
        vteam2.User__c = u3.id;
        vteam2.Team_Role__c = 'Business Support';
        vteam2.Visit_Report__c = vr.id ;
        insert vteam2;
        
        vteam1.User__c = u3.id;
        vteam1.Access_Level__c = 'Read/Write';
        vteam1.Team_Role__c = 'Technical Advisor';
        update vteam1;
        vteam2.Access_Level__c = 'Read/Write';
        update vteam2;
        Delete vteam;
        
        vteam1.User__c = u3.id;
        update vteam1;
        
        String testLbl = Label.CL00100;
        system.debug(logginglevel.error,testLbl);
        
        String testLbl1 = Label.CL00019;
        system.debug(logginglevel.error,testLbl1);
        
        
        System.runAs(u){
        
        PageReference pageRef = Page.AddVisitReportTeamMember; 
        pageRef.getParameters().put('id', String.valueOf(vr.Id));
        Test.setCurrentPage(pageRef);
        
        Visit_Report_Team_Member__c stdVT = new  Visit_Report_Team_Member__c();
        ApexPages.StandardController sc = new ApexPages.StandardController(stdVT);
        AddVisitReportTeamMemberClass objVT = new AddVisitReportTeamMemberClass(sc);
        objVT.visitTeamMember1.User__c = u1.id;
        objVT.visitTeamMember2.User__c = u2.id;
        objVT.visitTeamMember3.User__c = u3.id;
        objVT.visitTeamMember4.User__c = u4.id;
        objVT.visitTeamMember5.User__c = u5.id;
        objVT.saveRecords();
        objVT.cancel();
        
        AddVisitReportTeamMemberClass objVT1 = new AddVisitReportTeamMemberClass(sc);
        objVT1.visitTeamMember1.User__c = u1.id;
        objVT1.visitTeamMember2.User__c = u2.id;
        objVT1.visitTeamMember3.User__c = u3.id;
        objVT1.visitTeamMember4.User__c = u4.id;
        objVT1.visitTeamMember5.User__c = u5.id;
        objVT1.saveMoreRecords();
        objVT1.cancel();
        Test.StopTest();  
        }
        }
  //return null
        }