/**
*   This test class for 1. ClsTriggerAccountHandler.
*                        2. ClsTriggerEndUserProjectHandler
*                        3. ClsTriggerCaptureTeamMemberHandler
*                        4. AddCaptureTeamMemberClass 
*                        5. NewCaptureTeamController 
*
@author Rajesh Kaliyaperumal
@created 2015-10-9
*
*/
@istest(seealldata=true)
public class ClsTriggerCaptureTeamSharingControl_TEST{
    public static Account createTestAccounts() {
        Account acc = new Account();    
        acc.Name = 'Test1';    
        acc.Primary_Account_Manager__c = 'mtester@company.com';   
        acc.BillingStreet = 'dajie';
        acc.BillingCity = 'berlin';
        acc.BillingState = 'Berlin';
        acc.BillingPostalCode = '20012';
        acc.BillingCountry = 'Germany';
        return acc;
    }
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
        u.ProfileId = [Select Id from Profile Where Name = 'ABB Sales Standard Profile' limit 1].Id;
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
        u.Alias = 'mtst3';
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
    public static Contact createTestContacts() {
        Contact contact = new Contact();
        contact.LastName = 'Test';
        contact.MailingStreet = 'dada';
        contact.MailingCity = 'berlin';
        contact.MailingState = 'Berlin';
        contact.MailingPostalCode = '1792';
        contact.MailingCountry = 'Germany'; 
        return contact;
    }
    public static End_User_Project__c createTestEndUserProject() {
        Account acc = createTestAccounts();
        insert acc;
        End_User_Project__c EUP = new End_User_Project__c();
        EUP.Account_End_User__c = acc.id;
        EUP.Name = 'TEST End User Project';
        EUP.End_User_Project_Status__c = 'Open';
        EUP.Capture_Team_Count__c=3;
        
        return EUP;
    }
   
    static testMethod void CaptureTeamsharingControlTEST1(){
        Test.StartTest();
        User u1 = createTestUser1();
        insert u1;
        User u2 = createTestUser2();
        insert u2; 
        User u3 = createTestUser3();
        insert u3;          
        Account acc = new Account();    
        acc.Name = 'TestAccount';    
        acc.Primary_Account_Manager__c = 'mtester@company.com';   
        acc.BillingStreet = 'dajie';
        acc.BillingCity = 'berlin';
        acc.BillingState = 'Berlin';
        acc.BillingPostalCode = '20012';
        acc.BillingCountry = 'Germany';
        insert acc;
        
        /*Account acc1 = new Account();    
        acc1.Name = 'TestAccount1';    
        acc1.Primary_Account_Manager__c = 'mtester1@company.com';   
        acc1.BillingStreet = 'dajie';
        acc1.BillingCity = 'berlin';
        acc1.BillingState = 'Berlin';
        acc1.BillingPostalCode = '20012';
        acc1.BillingCountry = 'Germany';
        acc1.Active__c=True;
        acc1.recordTypeId=[select id,Name from RecordType where SobjectType='Account' and Name='Default' Limit 1].Id;
        insert acc1;*/
        
        End_User_Project__c EUP = new End_User_Project__c();
        EUP.Account_End_User__c = acc.id;
        EUP.Name = 'TEST End User Project';
        EUP.End_User_Project_Status__c = 'Open';
        insert EUP;
        /*End_User_Project__c EUP1 = new End_User_Project__c();
        EUP1.Account_End_User__c = acc.id;
        EUP1.Name = 'TEST End User Project1';
        EUP1.End_User_Project_Status__c = 'Open';
        insert EUP1;
        End_User_Project__c EUP2 = new End_User_Project__c();
        EUP2.Account_End_User__c = acc1.id;
        EUP2.Name = 'TEST End User Project2';
        EUP2.End_User_Project_Status__c = 'Open';
        insert EUP2;*/
        
        ABB_Location__c loc=new ABB_Location__c();
        loc.Name='TLoc';
        loc.BU__c='PGHV - High Voltage Products';
        loc.DIV__c='PA-Process Automation';
        insert loc;       
        
        /*ABB_Location__c loc1=new ABB_Location__c();
        loc1.Name='testLoc';
        loc1.BU__c='PPHV-High Voltage Products';
        loc1.DIV__c='PP-Power Products';
        insert loc1;*/
        
        /*Product_Group__c pg1=new Product_Group__c();
        pg1.Name='testtt';
        pg1.Business_Unit__c='t01';
        pg1.Division__c='D01';
        insert pg1;*/
        
        Product_Group__c pg=new Product_Group__c();
        pg.Name='abbProd';
        pg.Business_Unit__c='t02';
        pg.Division__c='D02';
        insert pg;
        
        /*Opportunity op1=new Opportunity();
        op1.Technical_Amount_USD__c = 5000004;
        op1.Target__c = TRUE;
        op1.Account_End_User__c=acc1.id;
        op1.Accountid=acc1.id;
        op1.Specific_Opportunity_Info__c='testOppInfo';
        op1.Sales_Pursuit_Progress__c='Opportunity Is Captured';
        op1.Customer_Buying_Path__c='Awareness';
        op1.StageName='Prospecting';
        op1.ABB_Location__c=loc1.id;
        op1.CloseDate=date.today();
        op1.Product_Group__c=pg1.id;
        op1.Name='TestOpp';
        op1.Target__c=True;
        op1.Opportunity_Value__c=5000004;
        op1.End_User_Project__c=EUP1.id;       
        insert op1;
        
        Opportunity op2=new Opportunity();
        op2.Technical_Amount_USD__c = 15000004;
        op2.Target__c = TRUE;
        op2.Account_End_User__c=acc1.id;
        op2.Accountid=acc1.id;
        op2.Specific_Opportunity_Info__c='testOppInfo';
        op2.Sales_Pursuit_Progress__c='Opportunity Is Captured';
        op2.Customer_Buying_Path__c='Awareness';
        op2.StageName='Prospecting';
        op2.ABB_Location__c=loc1.id;
        op2.CloseDate=date.today();
        op2.Product_Group__c=pg.id;
        op2.Name='TestOpp1';
        op2.Opportunity_Value__c=15000004;
        op2.End_User_Project__c=EUP1.id;
        op2.Target__c=True;
        insert op2;*/
        
        Opportunity op3=new Opportunity();
        op3.Technical_Amount_USD__c = 15000004;
        op3.Target__c = TRUE;
        op3.Account_End_User__c=acc.id;
        op3.Accountid=acc.id;
        op3.Specific_Opportunity_Info__c='testOppInfo1';
        op3.Sales_Pursuit_Progress__c='Opportunity Is Captured';
        op3.Customer_Buying_Path__c='Awareness';
        op3.StageName='Prospecting';
        op3.ABB_Location__c=loc.id;
        op3.CloseDate=date.today();
        op3.Product_Group__c=pg.id;
        op3.Name='TestOpp21';
        op3.Opportunity_Value__c=15000004;
        op3.End_User_Project__c=EUP.id;
        op3.Target__c=True;
        insert op3;
        
        
        Capture_Team__c CT = new Capture_Team__c();
        CT.End_User_Project__c = EUP.id;        
        insert CT;
        
        Capture_Team__c CT1 = new Capture_Team__c();
        CT1.End_User_Project__c = EUP.id;        
        insert CT1;        
        
        delete CT1;
        
        Capture_Team__c CT2 = new Capture_Team__c();
        CT2.End_User_Project__c = EUP.id;        
        insert CT2;
        Test.StopTest();
        
        Capture_Team_Member__c CTM = new Capture_Team_Member__c();
        CTM.User__c = u1.id;
        CTM.Capture_Team__c = CT.id;
        insert CTM;
        
        Capture_Team_Member__c CTM2 = new Capture_Team_Member__c();
        CTM2.User__c = u2.id;
        CTM2.Capture_Team__c = CT.id;
        insert CTM2;
        
        Capture_Team_Member__c CTM3 = new Capture_Team_Member__c();
        CTM3.User__c = u3.id;
        CTM3.Capture_Team__c = CT.id;
        insert CTM3;
        
        acc.Primary_Account_Manager__c = 'mtester1@company.com';
        update acc;
        acc.Primary_Account_Manager__c = 'mtester2@company.com';
        update acc;
        
        CTM2.User__c = u3.id;
        CTM2.Access_Level__c = 'Read Only';
        update CTM2;
        CTM3.Access_Level__c = 'Read/Write';
        update CTM3;
        Delete CTM;        
       
        Account accn = new Account();    
        accn.Name = 'TestAccount1';    
        accn.Primary_Account_Manager__c = 'mtester1@company.com';   
        accn.BillingStreet = 'dajie';
        accn.BillingCity = 'berlin';
        accn.BillingState = 'Berlin';
        accn.BillingPostalCode = '20012';
        accn.BillingCountry = 'Germany';
        insert accn;
        
        End_User_Project__c EUPn = new End_User_Project__c();
        EUPn.Account_End_User__c = accn.id;
        EUPn.Name = 'TEST End User Project';
        EUPn.End_User_Project_Status__c = 'Open';
        insert EUPn;
        System.Runas(u1){     
            
            NewCaptureTeamController objCTController = new NewCaptureTeamController();
            Apexpages.Currentpage().getParameters().put('id',EUPn.id);
            objCTController.redirect();
          
        }    
        
       
        Capture_Team_Member__c stdCT = new Capture_Team_Member__c();
        ApexPages.StandardController sc = new ApexPages.StandardController(stdCT);
        AddCaptureTeamMemberClass objCT = new AddCaptureTeamMemberClass(sc);
        objCT.capTeamMember1.User__c = u1.id;
        objCT.capTeamMember2.User__c = u1.id;
        objCT.capTeamMember3.User__c = u1.id;
        objCT.capTeamMember4.User__c = u1.id;
        objCT.capTeamMember5.User__c = u1.id;
        objCT.saveRecord();
        objCT.saveMoreRecord();
        objCT.cancel();  
        
    }
    static testMethod void CaptureTeamsharingControlTEST2(){
        Account accn = new Account();    
        accn.Name = 'TestAccount1';    
        accn.Primary_Account_Manager__c = 'mtester1@company.com';   
        accn.BillingStreet = 'dajie';
        accn.BillingCity = 'berlin';
        accn.BillingState = 'Berlin';
        accn.BillingPostalCode = '20012';
        accn.BillingCountry = 'Germany';
        insert accn;
        
        End_User_Project__c EUPn = new End_User_Project__c();
        EUPn.Account_End_User__c = accn.id;
        EUPn.Name = 'TEST End User Project';
        EUPn.End_User_Project_Status__c = 'Open';
        insert EUPn;
        
        User u4 = createTestUser4();
        insert u4;
        System.Runas(u4){  
            Test.StartTest();   
            NewCaptureTeamController objCTController = new NewCaptureTeamController();
            Apexpages.Currentpage().getParameters().put('id',EUPn.id);
            objCTController.redirect();
            Test.StopTest();
        }
    }
    
}