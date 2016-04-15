/*
 * ApexClass -  Test class ChannelPreQualification_Test
 * Release R5
 * @author  Indhu Ramalingam (Accenture)
 * @created 2016-03-18
 * @version 1.0
 * Description: Test class 
 * Created
 * This is the Test class for 1.ClsAddChannelPreQualTeam
                              2.ClsTriggerChannelQualificationTeam
                              3.ClsChannelPreQualTeamMembersCopy
                              4.ClsTriggerChannelQualifications
                              5.ClsChannelQualEditPage 
                              6.ClsTriggerVisitReport
 */
    @isTest
    private class ChannelPreQualification_Test{

    public static User createTestUser1() {
        User u = new User();
        u.FirstName ='haobo';
        u.LastName = 'song';
        u.Username = 'test123ABB1237@test123ABB1237.com';
        u.Alias = 'mtst1';
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
    
    public static Account createAccount1() {
        Account a = new Account();
        a.Name = 'test';
        a.BillingStreet = 'street'; 
        a.BillingCity = 'city';
        a.BillingCountry = 'Germany';
        a.GUID__c = '1234sghf';
        return a;
    }    
   
     public static Channel_Market_Coverage__c createChannelPartMarScope() {
        Channel_Market_Coverage__c cms = new Channel_Market_Coverage__c();
        cms.Name = 'Test Market Scope';
        cms.Primary_Channel_Class__c = 'Distributor (DIS)';
        cms.Division__c = 'DM';
        cms.Focussed_Industry1__c = 'Building - Residential Buildings';
        cms.Relationship_Status__c = 'Channel';
        cms.Targeted_Key_Strategic__c = TRUE;
        return cms;
    }
    
    public static Channel_Qualifications__c createChannelPreQual() {
        Channel_Qualifications__c cpq = new Channel_Qualifications__c();
        cpq.Name = 'Test Channel Pre-Qual';
        cpq.Status__c = 'Closed';
        cpq.Organization_Answer_1__c ='6';
        cpq.Organization_Answer_2__c ='5';
        cpq.Organization_Answer_3__c ='1';
        cpq.Organization_Answer_4__c ='4';
        cpq.Organization_Answer_5__c ='5';
        cpq.Organization_Answer_6__c ='2';
        cpq.Organization_Answer_7__c ='3';
        cpq.Organization_Answer_8__c ='4';
        cpq.Organization_Answer_9__c ='6';
        cpq.Organization_Answer_10__c ='5';
        cpq.Organization_Answer_11__c ='6';     
        return cpq;
    } 
   
    public static Channel_Pre_Qualification_Team__c createPreQualTeam() {
        Channel_Pre_Qualification_Team__c cpqTeam = new Channel_Pre_Qualification_Team__c();
        return cpqTeam;
    }
    
    public static Visit_Report__c createVisitReport(){
          Visit_Report__c vr=new Visit_Report__c();
          vr.Name= 'Test Report1';
          vr.Date_of_Visit__c= date.today();
          vr.Reason__c = 'Test Reason';
          return vr;
    }
      
    static testMethod void channelPreQualMethod(){
        Test.StartTest();
        User u1 = createTestUser1();
            insert u1;
        User u2 = createTestUser2();
            insert u2; 
        User u3 = createTestUser3();
            insert u3;
        User u4 = createTestUser4();
            insert u4;
        Account a = createAccount1();
            insert a;                 
        Channel_Market_Coverage__c cms = createChannelPartMarScope();
            cms.Account__c = a.id;
            insert cms;
            
        ID CPQRecord = Schema.SObjectType.Channel_Qualifications__c.getRecordTypeInfosByName().get('Channel Qualification Detail Page').getRecordTypeId();
        Channel_Qualifications__c cpq = createChannelPreQual();
            cpq.Account__c = a.id;
            cpq.Channel_Market_Coverage__c = cms.id;
            cpq.RecordtypeId =  CPQRecord;
            insert cpq;         
                
        Channel_Pre_Qualification_Team__c cpqTeam = createPreQualTeam();
            cpqTeam.User__c = u1.id;
            cpqTeam.Channel_Pre_Qualification__c = cpq.id;
            insert cpqTeam;
            cpqTeam.User__c = u2.id;
            cpqTeam.Access__c = 'Read/Write';
            try {
            update cpqTeam;
            } catch(exception e) {}
            system.runAs(u1){
            try {
                delete cpqTeam;
            } catch(exception e){}  
            }
            
            try {
                cpqTeam.Access__c = null;
                update cpqTeam;
            } catch(exception e){}
            
        system.runAs(u3){  
        Channel_Pre_Qualification_Team__c cpqTeam1 = createPreQualTeam();
            cpqTeam1.User__c = u3.id;
            cpqTeam1.Channel_Pre_Qualification__c = cpq.id;            
            try {
            insert cpqTeam1;    
            } catch(exception e) {}  
        }
        Channel_Pre_Qualification_Team__c cpqTeam2 = createPreQualTeam();
            cpqTeam2.User__c = u4.id;
            cpqTeam2.Channel_Pre_Qualification__c = cpq.id;
            insert cpqTeam2;    
            delete cpqTeam2;
         
        AccountTeamMember aTM = new AccountTeamMember(
            UserId = u3.id,
            TeamMemberRole = 'Manager', 
            AccountId = a.id);
            insert aTM;
        
        AccountTeamMember aTM1 = new AccountTeamMember(
            UserId = u2.id,
            TeamMemberRole = 'Manager', 
            AccountId = a.id);
            insert aTM1;  
        
        // Code coverage for Apex Class - ClsAddChannelPreQualTeam                               
        Channel_Pre_Qualification_Team__c  stdCT = new Channel_Pre_Qualification_Team__c ();
            ApexPages.StandardController sc = new ApexPages.StandardController(stdCT);
        ClsAddChannelPreQualTeam objCT = new ClsAddChannelPreQualTeam(sc);
            objCT.channelPreQualTeam1.User__c = u1.id;
            objCT.channelPreQualTeam2.User__c = u1.id;
            objCT.channelPreQualTeam3.User__c = u1.id;
            objCT.channelPreQualTeam4.User__c = u1.id;
            objCT.channelPreQualTeam5.User__c = u1.id;
            objCT.saveRecord();
            objCT.saveMoreRecord();
            objCT.cancel();  
            objCT.GoBack();
            
        // Code coverage for Apex Class - ClsChannelPreQualTeamMembersCopy     
        System.Runas(u3){ 
        apexpages.currentpage().getparameters().put('Id', cpq.Id);
        ApexPages.StandardController stdCtrller = new ApexPages.StandardController(cpq);  
        ClsChannelPreQualTeamMembersCopy chanPreQualTeamCopy  =  new ClsChannelPreQualTeamMembersCopy();                  
        chanPreQualTeamCopy  =  new ClsChannelPreQualTeamMembersCopy(stdCtrller);    
        chanPreQualTeamCopy.copyAccountTeamMember();   
        chanPreQualTeamCopy.GoBack();
        ApexPages.currentPage().getParameters().put('/',cpq.id);
        }   
        
         // Code coverage for Apex Class - ClsChannelQualEditPage
        apexpages.currentpage().getparameters().put('Id', cpq.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(cpq);
        ClsChannelQualEditPage channelEdit = new ClsChannelQualEditPage();
        channelEdit = new ClsChannelQualEditPage(sc1);
        channelEdit.editPageChange(); 
        
                   
        Test.stopTest();        
    } 
    
}