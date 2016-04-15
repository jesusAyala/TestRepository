/**
*  This test class used to test the method 
*  syncQTMWithOTM
*  in class ClsTriggerQuoteTeamMemberHandler
*
@author Shankaranarayanan V
@created 2015-10-06
@version 1.0

Code Coverage: 80%
**/

@isTest
public class ClsTriggerQuoteTeamMemberHandler_Test{

static testMethod void methodTest(){

//RecordType cqpRecordType = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Apttus_Proposal__Proposal__c' and DeveloperName = 'CQP']; 
RecordType defaultID = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Account' and DeveloperName = 'Default'];

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
u1.firstname = '25032';
u1.lastname = 'TestUser2';
u1.Username ='test25032@xyzdqg.com';
u1.Alias = 'tester2';
u1.CommunityNickname = 'tester';
u1.TimeZoneSidKey ='Europe/London';
u1.LocaleSidKey ='en_US';
u1.EmailEncodingKey ='ISO-8859-1';
u1.LanguageLocaleKey ='en_US';
u1.email = 'abc@vwxyz.com';
u1.profileid = up.id;
u1.isActive = true;
u1.Division_DIV__c = 'DM';
u1.Default_BU__c = 'LBUac1';
u1.Default_LSO__c ='LSOac1';
insert u1;

Account ac = new Account();
ac.Name = '2503Account1';
ac.BillingCountry = 'India';
ac.BillingStreet = 'TestStreet';
ac.BillingCity = 'TestCity';
ac.RecordtypeId = defaultID.id;   
insert ac;

Account ac1 = new Account();
ac1.Name = '2503Account2';
ac1.BillingCountry = 'Australia';
ac1.BillingStreet = 'TestStrt';
ac1.BillingCity = 'TestCy';
ac1.RecordtypeId = defaultID.id;   
insert ac1;


    APTS_Common_Config_Settings__c ap=new APTS_Common_Config_Settings__c();
    ap.Name='Global_Record_Type';
    ap.APTS_Value__c='Test';
    ap.APTS_Description__c='testdescr';
    insert ap;
    
    APTS_Common_Config_Settings__c ap1=new APTS_Common_Config_Settings__c();
    ap1.Name='LP_USER_DIVISION';
    ap1.APTS_Value__c='Test';
    ap1.APTS_Description__c='testdescr';
    insert ap1;
    
    APTS_Common_Config_Settings__c ap2=new APTS_Common_Config_Settings__c();
    ap2.Name='DEFAULT_SAP_DIVISION';
    ap2.APTS_Value__c='Test';
    ap2.APTS_Description__c='testdescr';
    insert ap2;
    
    APTS_Common_Config_Settings__c ap3=new APTS_Common_Config_Settings__c();
    ap3.Name='SPAIN_LOCALE';
    ap3.APTS_Value__c='Test';
    ap3.APTS_Description__c='testdescr';
    insert ap3;
    
    APTS_Common_Config_Settings__c ap4=new APTS_Common_Config_Settings__c();
    ap4.Name='DIVISION';
    ap4.APTS_Value__c='Test';
    ap4.APTS_Description__c='testdescr';
    insert ap4;
    
    APTS_Common_Config_Settings__c ap5=new APTS_Common_Config_Settings__c();
    ap5.Name='APPROVAL_COUNTRY';
    ap5.APTS_Value__c='Test';
    ap5.APTS_Description__c='testdescr';
    insert ap5;

Opportunity o1 = new Opportunity();
o1.ownerid = u.id;
o1.accountId = ac.id;
o1.Account_End_User__c = ac1.id; 
o1.Customer_Buying_Path__c = 'Awareness';
o1.name = '2503 Oppty1';
o1.Specific_Opportunity_Info__c = '2503TestAuto';
o1.StageName = 'Prospecting';
o1.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
o1.CloseDate = date.Today();
insert o1;

String oppId = o1.id;

System.runAs(u) {
Test.startTest();
Apttus_Proposal__Proposal__c apQuote= new Apttus_Proposal__Proposal__c();
apQuote.Apttus_Proposal__Proposal_Name__c = 'Test Quote';
apQuote.Apttus_Proposal__Opportunity__c = o1.id;
insert apQuote;

Quote_Team_Member__c qm = new Quote_Team_Member__c();
qm.Access_Level__c = 'Read/Write';
qm.Team_Role__c = 'Account Engineer';
qm.Quotation__c = apQuote.id;
qm.User__c = u1.id;
insert qm;

List<OpportunityTeamMember> oppTeamList = [SELECT Id, OpportunityId, OpportunityAccessLevel, TeamMemberRole, UserId FROM OpportunityTeamMember WHERE OpportunityId =: oppId];
                                            
    System.assertEquals(qm.User__c,oppTeamList[0].UserId);
    System.assertEquals(qm.Team_Role__c,oppTeamList[0].TeamMemberRole);

delete qm;

Test.stopTest();
List<OpportunityTeamMember> oppTeamDelList = [SELECT Id, OpportunityId, OpportunityAccessLevel, TeamMemberRole, UserId FROM OpportunityTeamMember WHERE OpportunityId =: oppId];
    
    System.assertEquals(oppTeamDelList.size(), 1);
}
}
}