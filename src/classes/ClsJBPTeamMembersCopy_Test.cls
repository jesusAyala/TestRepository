/**
 * ApexClass -  Test class ClsJBPTeamMembersCopy_Test
 * Release R5
 * @author  Indhu Ramalingam (Accenture)
 * @created 2016-03-22
 * @version 1.0
 * Description: Test class for ClsJBPTeamMembersCopy
 * Created
  */
@isTest
private class ClsJBPTeamMembersCopy_Test{

    public static User createTestUser1() {
        User u = new User();
        u.FirstName ='haobo';
        u.LastName = 'song';
        u.Username = 'test123ABB1237@test123ABB1237.com';
        u.Alias = 'mtst4';
        u.Email = 'mtester1@company.com';
        u.CommunityNickname = u.Alias;
        u.ProfileId = [Select Id from Profile Where Name = 'ABB Sales Standard Profile' limit 1].Id;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.ManagerId = UserInfo.getUserId();
        return u;
    }
    public static User createTestUser2() {
        User u = new User();
        u.FirstName ='haobo';
        u.LastName = 'song';
        u.Username = 'test1234awsedr@test1234.com';
        u.Alias = 'mtst2';
        u.Email = 'mtester2ABB1236@companyABB1236.com';
        u.CommunityNickname = u.Alias;
        u.ProfileId = [Select Id from Profile Where Name = 'System Administrator' limit 1].Id;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.ManagerId = UserInfo.getUserId();
        return u;
    }
    public static User createTestUser3() {
        User u = new User();
        u.FirstName ='haobo';
        u.LastName = 'song';
        u.Username = 'test12345ABB1235@test12345ABB1235.com';
        u.Alias = 'mtst3';
        u.Email = 'mtester3@company.com';
        u.CommunityNickname = u.Alias;
        u.ProfileId = [Select Id from Profile Where Name = 'ABB Sales Standard Profile' limit 1].Id;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.ManagerId = UserInfo.getUserId();
        return u;
    }
    public static User createTestUser4() {
        User u = new User();
        u.FirstName ='haobo';
        u.LastName = 'song';
        u.Username = 'test12345ABB1234@test12345ABB1234.com';
        u.Alias = 'mtst31';
        u.Email = 'mtester3@company.com';
        u.CommunityNickname = u.Alias;
        u.ProfileId = [Select Id from Profile Where Name = 'Standard User' limit 1].Id;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.ManagerId = UserInfo.getUserId();
        return u;
    }
    
    public static Account createAccount1(){
        Account a = new Account();
        a.Name = 'test';
        a.BillingStreet = 'street'; 
        a.BillingCity = 'city';
        a.BillingCountry = 'Germany';
        a.GUID__c = '1234sghf';
        return a;
    }
    public static Channel_Market_Coverage__c createChannelMarkCov(){
        Channel_Market_Coverage__c mc = new Channel_Market_Coverage__c ();
        mc.Name = 'Test Market Coverage'; 
        mc.Division__c = 'PA';
        mc.Primary_Channel_Class__c ='Installer (INST)';
        mc.Focussed_Industry1__c = 'Building - Residential Buildings;Industry - Petrochemicals;Industry - Textile';  
        return mc;
    }   
     public static Joint_Business_Plan__c createJointBussPlan(){
        Joint_Business_Plan__c jbp = new Joint_Business_Plan__c();
        jbp.Name = 'Test Joint Business Plan'; 
        jbp.Start_Date__c = Date.valueOf(system.now());
        jbp.End_Date__c = Date.valueOf(system.now());
        jbp.Status__c='Active';        
        return jbp;
    }
      public static Joint_Business_Team__c createJointBussPlanTeam1(){
        Joint_Business_Team__c jbpt1 = new Joint_Business_Team__c();
        jbpt1.Access__c= 'Read/Write';
        jbpt1.Team_Role__c='GAM/SAM Account Manager';
        return jbpt1;
    }
    
     public static Joint_Business_Team__c createJointBussPlanTeam2(){
        Joint_Business_Team__c jbpt2 = new Joint_Business_Team__c();
        jbpt2.Access__c= 'Read/Write';
        jbpt2.Team_Role__c='Account Manager';
        return jbpt2;
    }
    public static AccountTeamMember createAccountTeamMember1(){
        AccountTeamMember atm = new AccountTeamMember();        
        return atm;
    }
       static testMethod void jointBusinessPlanMethod1(){
        Test.StartTest();
        User u1 = createTestUser1();
            insert u1;
        User u2 = createTestUser2();
            insert u2;
        User u3 = createTestUser3();
            insert u3;        
        Account a = createAccount1();
            insert a;
        AccountTeamMember atm1 =  createAccountTeamMember1();
            atm1.AccountId=a.Id;
            atm1.UserId=u1.Id;
            insert atm1; 
        AccountTeamMember atm2 =  createAccountTeamMember1();
            atm2.AccountId=a.Id;
            atm2.UserId=u2.Id;
            insert atm2;
        AccountTeamMember atm3 =  createAccountTeamMember1();
            atm3.AccountId=a.Id;
            atm3.UserId=u3.Id;
            insert atm3;
        Channel_Market_Coverage__c cmc1 = createChannelMarkCov();
            cmc1.Account__c = a.id;
            insert cmc1; 
        Id devRecordTypeId = Schema.SObjectType.Joint_Business_Plan__c.getRecordTypeInfosByName().get('4. Technical Channel as Partner').getRecordTypeId();                      
        Joint_Business_Plan__c jbp1 = createJointBussPlan();
            jbp1.Account__c = a.id;
            jbp1.Channel_Market_Coverage__c = cmc1.id;            
            insert jbp1; 
            jbp1.Start_Date__c = Date.valueOf(system.now());
            Update jbp1;  
        Joint_Business_Team__c jbpt1 = createJointBussPlanTeam1();
            jbpt1.Joint_Business_Plan__c = jbp1.id;
            jbpt1.User__c = u1.id;
            jbpt1.Access__c = 'Read/Write'; 
            insert jbpt1;
        
         // Code coverage for Apex Class - ClsJBPTeamMembersCopy     
            apexpages.currentpage().getparameters().put('Id', jbp1.Id);
            ApexPages.StandardController stdCtrller = new ApexPages.StandardController(jbp1);  
            ClsJBPTeamMembersCopy jbpTeamCopy  =  new ClsJBPTeamMembersCopy();                  
            jbpTeamCopy  =  new ClsJBPTeamMembersCopy(stdCtrller);    
            jbpTeamCopy.copyAccountTeamMember();   
            jbpTeamCopy.GoBack();
            ApexPages.currentPage().getParameters().put('/',jbp1.id);
 

        Test.stopTest();
    }
}