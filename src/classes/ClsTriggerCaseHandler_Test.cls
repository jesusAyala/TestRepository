/**
*  This test class used to test class ClsTriggerCaseHandler.
*
@author Jinbo Shan
@created 2015-03-12
@version 1.0   
@since 30.0
*
@changelog
* coverage 88% 
* 
* 
2015-03-12 Jinbo Shan <jinbo.shan@itbconsult.com>
* - Created
*/
@isTest
private class ClsTriggerCaseHandler_Test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        RecordType rt = [select Id from RecordType where SObjectType = 'Case' limit 1];
        User u = [select Id from User where Id = : UserInfo.getUserId()];
        Validation_Override__c valiOver;
        for(Validation_Override__c vo : [select SetupOwnerId, Exclude__c from Validation_Override__c where SetupOwnerId = : u.Id and Name = 'Validation Override (User)']) {
            valiOver = vo;
        }
        if(valiOver == null) {
            valiOver = new Validation_Override__c();
            valiOver.SetupOwnerId = u.Id;
            valiOver.Exclude__c = true;
            valiOver.Name = 'Validation Override (User)';
            insert valiOver;
        }
        
        system.runAs(u){
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Name = 'sdosetsss';
            insert acc;
            
            AccountTeamMember am = new AccountTeamMember();
            am.UserId = UserInfo.getUserId();
            am.AccountId = acc.Id;
            am.TeamMemberRole = 'Account Manager';
            insert am;
            

            
            Contact con = ClsTestHelp.createTestContacts();
            con.LastName = 'ddsssdd';
            con.AccountId = acc.Id;
            con.Email_Opt_Out__c = false;
            con.Preferred_Contact_Method__c = 'Email';
            insert con;
            
          /* Case c = new Case();
            c.RecordTypeId = rt.Id;
            c.ContactId = con.Id;
            c.AccountId = acc.Id;
            insert c;*/
            
            
            Case c = new Case();
            C.subject = 'TestCase 1';
            C.status ='Open';
            C.type='Mechanical';
            C.reason='Installation';
            C.Business_unit__c ='EPCP - Control Products';
            C.contactid=con.id;
            C.RecordTypeId = rt.ID;
            C.Originating_Country__c = 'Bangladesh';
            c.Category_2__c ='Complaints';
            c.CCRP_Status__c =null;
            c.Description = 'sai213';
            C.SuppliedEmail='abc@abc.com';    
            C.accountid=acc.id;
            c.OwnerID =  u.id;
            Insert c;
            
          /*  Case c1 = new Case();
            c1.RecordTypeId = rt.Id;
            c1.ParentId = c.Id;
            c1.Status = 'Closed';   
            c1.ContactId = con.Id;
            insert c1;
            
            Case c2 = new Case();
            c2.RecordTypeId = rt.Id;
            c2.ParentId = c.Id;
            c2.Status = 'Closed';
            c2.ContactId = con.Id;
            c2.Originating_Country__c = 'Costa Rica';
            insert c2;*/

            Date sDate = Date.today();
            Date eDate = sDate.addDays(2);
            Entitlement e = new Entitlement();
            e.Name = 'Entitlement: P&G';
            e.StartDate = sDate;
            e.EndDate = eDate;
            e.AccountId = acc.Id;
            insert e;
            
           /* Case c3 = new Case();
            c3.RecordTypeId = rt.Id;
            c3.ParentId = c.Id;
            c3.Status = 'Closed';
            c3.ContactId = con.Id;
            c3.AccountId = acc.Id;
            insert c3;*/
            Case c3 = new Case();
            C3.subject = 'TestCase 1';
            C3.status ='Open';
            C3.type='Mechanical';
            C3.reason='Installation';
            C3.Business_unit__c ='EPCP - Control Products';
            C3.contactid=con.id;
            C3.RecordTypeId = rt.ID;
            C3.Originating_Country__c = 'Bangladesh';
            c3.Category_2__c ='Complaints';
            c3.CCRP_Status__c =null;
            c3.Description = 'sai213';
            C3.SuppliedEmail='abc@abc.com';    
            C3.accountid=acc.id;
            c3.OwnerID =  u.id;
            Insert c3;
        Test.startTest();    
            Account accc = ClsTestHelp.createTestAccounts();
            accc.Name = 'sxsxsssdosetsssss';
            insert accc;
            
            Contact conn = ClsTestHelp.createTestContacts();
            conn.LastName = 'xsssxddsssdd';
            conn.AccountId = accc.Id;
            conn.Email_Opt_Out__c = false;
            conn.Preferred_Contact_Method__c = 'Email';
            insert conn;
            
            Entitlement ee = new Entitlement();
            ee.Name = 'xEntitlement: P&Gx';
            ee.StartDate = sDate;
            ee.EndDate = eDate;
            ee.AccountId = accc.Id;
            insert ee;
            
            EntitlementContact ecc = new EntitlementContact();
            ecc.ContactId = conn.Id;
            ecc.EntitlementId = ee.Id;
            insert ecc;
            
            
            /*Case c4 = new Case();
            c4.RecordTypeId = rt.Id;
            c4.ParentId = c.Id;
            c4.Status = 'Closed';
            c4.ContactId = conn.Id;
            c4.AccountId = accc.Id;
            insert c4;*/
            
            Case c4 = new Case();
            C4.subject = 'TestCase 1';
            C4.status ='Open';
            C4.type='Mechanical';
            C4.reason='Installation';
            C4.Business_unit__c ='EPCP - Control Products';
            C4.contactid=con.id;
            C4.RecordTypeId = rt.ID;
            C4.Originating_Country__c = 'Bangladesh';
            c4.Category_2__c ='Complaints';
            c4.CCRP_Status__c =null;
            c4.Description = 'sai213';
            C4.SuppliedEmail='abc@abc.com';    
            C4.accountid=acc.id;
            c4.OwnerID =  u.id;
            Insert c4;
            
            //c.Status = 'Closed';
           // update c;
            Test.stopTest();
        }
    }
    
    static testMethod void myUnitTest1() {
        // TO DO: implement unit test
        
        RecordType rt = [select Id from RecordType where SObjectType = 'Case' limit 1];
        Id EXtNonBuyingID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('External Non-Buying Account').getRecordTypeId();
    Test.startTest();    
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Name = 'jintestssssdds';
        acc.RecordTypeId = EXtNonBuyingID;
        insert acc;
        
        Contact con = ClsTestHelp.createTestContacts();
        con.LastName = 'ddsssdd';
        con.AccountId = acc.Id;
        con.Email_Opt_Out__c = false;
        con.Preferred_Contact_Method__c = 'Email';
        insert con;
        
        User u = ClsTestHelp.createTestUsers();
        u.Username = 'jinbo.shan@itbconsultds.comssdftest';
        insert u;
        
        AccountTeamMember atm = new AccountTeamMember();
        atm.AccountId = acc.Id;
        atm.UserId = u.Id;
        insert atm;
        
        Account acc1 = ClsTestHelp.createTestAccounts();
        acc1.Name = 'jinbotestsdds';
        insert acc1;
        
        AccountTeamMember atm1 = new AccountTeamMember();
        atm1.AccountId = acc1.Id;
        atm1.UserId = u.Id;
        insert atm1;
        
            Case c = new Case();
            C.subject = 'TestCase 1';
            C.status ='Open';
            C.type='Mechanical';
            C.reason='Installation';
            C.Business_unit__c ='EPCP - Control Products';
            C.contactid=con.id;
            C.RecordTypeId = rt.ID;
            C.Originating_Country__c = 'Bangladesh';
            c.Category_2__c ='Complaints';
            c.CCRP_Status__c =null;
            c.Description = 'sai213';
            C.SuppliedEmail='abc@abc.com';    
            C.accountid=acc.id;
            c.OwnerID =  u.id;
            Insert c;            
            
            Case c3 = new Case();
            c3.parentId = c.Id;
            C3.subject = 'TestCase 1';
            C3.status ='Open';
            C3.type='Mechanical';
            C3.reason='Installation';
            C3.Business_unit__c ='EPCP - Control Products';
            C3.contactid=con.id;
            C3.RecordTypeId = rt.ID;
            C3.Originating_Country__c = 'Bangladesh';
            c3.Category_2__c ='Complaints';
            c3.CCRP_Status__c =null;
            c3.Description = 'sai213';
            C3.SuppliedEmail='abc@abc.com';    
            C3.accountid=acc.id;
            //c3.OwnerID =  u.id;
            Insert c3;
            
        Test.stopTest();
    }
 
}