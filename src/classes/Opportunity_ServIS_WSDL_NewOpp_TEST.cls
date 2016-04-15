/**
*  This test class used to test class Opportunity_ServIS_WSDL_NewOpp.
*    
@author Rajesh K    
@created 2016-03-22
@version 1.0 
* 
*/
@isTest(seeAlldata = true)
private class Opportunity_ServIS_WSDL_NewOpp_TEST {
  
    static testMethod void myUnitTest() {
            Profile p = [SELECT id FROM profile WHERE name = 'System Administrator'];
            User u1 = new User(alias = 'chfree01',
                               email = 'testuser101@testorg.com',
                               emailencodingkey = 'UTF-8',
                               lastname = 'Testing',
                               companyname = 'testorg',
                               languagelocalekey = 'en_US',
                               localesidkey = 'en_US',
                               profileId = p.Id,
                               timezonesidkey = 'America/Los_Angeles',
                               username = 'testuser101@testorg.com');
            insert u1;
        
            Test.startTest();
            Account acc = ClsTestHelp.createTestAccounts();
            acc.GUID__c = '9ABB3040';
            acc.Name = 'Test Account12';
            insert acc;
        
            Account acc1 = ClsTestHelp.createTestAccounts();
            acc1.GUID__c = '9BBB3040';
            acc1.Name = 'Test Account12';
            insert acc1;
            Test.stopTest();
            
            Opportunity_ServIS_WSDL_NewOpp.createOpp('Test Opportunity', System.today(), '9ABB3040', '9BBB3040', 'testuser101@testorg.com','BLD', 'BLD.8', 'BLD.9.1', 'USD', True);        
    }
}