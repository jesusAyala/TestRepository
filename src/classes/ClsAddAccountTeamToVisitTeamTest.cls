/*
*  This test class used to test class ClsAddAccountTeamToVisitTeam. 
*
@author Aswini Arasu
@created 2016-03-21
@version 1.0  
*/
@istest(SeeAllData = False)
private class ClsAddAccountTeamToVisitTeamTest{
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
        
        AccountTeamMember accTeam = new AccountTeamMember ();
        accTeam.UserId=u2.id;
        accTeam.TeamMemberRole= 'Sales Rep';
        //accTeam.AccountAccessLevel='Read';
        accTeam.AccountId = a.id;
        insert accTeam;

        System.runAs(u) {
        Test.startTest();
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
        PageReference pageRef = Page.AddAccountTeamToVisitTeamPage; 
        pageRef.getParameters().put('id', String.valueOf(vr.Id));
        Test.setCurrentPage(pageRef);
    
        ApexPages.StandardController stdVrp = new ApexPages.StandardController(vr);
        ClsAddAccountTeamToVisitTeam objController  =  new ClsAddAccountTeamToVisitTeam(stdVrp);    
        objController.updateVisitTeam();
        Test.StopTest();
    
    }
    }
    
    }