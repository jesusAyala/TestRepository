/**
 * ApexClass -  Test class Test_ClsTriggerCompetitors
 * Release R5
 * @author  Ayiravalli Arasu (Accenture)
 * @created 2016-03-22
 * @version 1.0
 * Description: Test class for - ClsTriggerCompetitors
 * Created 
 */
 
 @isTest
private class ClsTriggerCompetitors_Test{
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
      
      public static Competitors__c createComp(){
          Competitors__c c = new Competitors__c();
          c.Strengths__c ='Test';
          return c;
      }
      
      public static AccountTeamMember createAccTeam1(){
         AccountTeamMember atm=new AccountTeamMember();
         atm.TeamMemberRole= 'Sales Support';
         return atm;
    } 
      
      static testMethod void Method1(){
          Test.StartTest();
          User u1 = createTestUser1();
            insert u1;
          Account a = createAccount1();
            insert a; 
            
           AccountTeamMember atm1 = createAccTeam1();
            atm1.UserId = u1.Id;
            atm1.AccountId = a.Id;
            insert atm1; 
          Channel_Market_Coverage__c cmc1 = createChannelMarkCov();
            cmc1.Account__c = a.id;
            insert cmc1;           
          Joint_Business_Plan__c jbp1 = createJointBussPlan();
            jbp1.Account__c = a.id;
            jbp1.Channel_Market_Coverage__c = cmc1.id;            
            insert jbp1; 
            jbp1.Start_Date__c = Date.valueOf(system.now());
            Update jbp1;
          Joint_Business_Team__c JBPT1 = createJointBussPlanTeam1();
            JBPT1.Joint_Business_Plan__c = jbp1.id;
            JBPT1.User__c = u1.id; 
            insert JBPT1;
          Competitors__c c1= createComp();
            c1.Joint_Business_Plan__c = jbp1.Id;
            insert c1;
            jbp1.Status__c ='Closed';
            system.runAs(u1){    
            try{
                update jbp1;
                delete c1;
            }Catch(exception e){}
            }
              
          Test.StopTest();
      }
         

}