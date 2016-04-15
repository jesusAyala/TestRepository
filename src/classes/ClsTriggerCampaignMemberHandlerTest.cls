/*  This test class used to test class CampaignMemberTrigger.
*
@author Nikhil Pimpale
@created 2016-04-08
@version 1.0  
*/
@istest
public class ClsTriggerCampaignMemberHandlerTest{

static testMethod void  preventCampaignMemberDeleteTest(){
       // Setup test data
      // This code runs as the system user
      Profile p = [SELECT Id FROM Profile WHERE Name='ABB Marketing Standard Profile'];
      User u = new User(Alias = 'standt', Email='marktuser@testorg.com', 
      ProfileId = p.Id,UserPermissionsMarketingUser = true,
      EmailEncodingKey='UTF-8', LastName='marktTesting', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US',TimeZoneSidKey='America/Los_Angeles', UserName='marktuser@markt.com');
      CampaignMember cmpMember = new CampaignMember();
  System.runAs(u){
  Account acc = new Account (
                Name = 'CampaignAccount1',
                BillingStreet = 'street', 
                BillingCity = 'city', 
                BillingCountry = 'Germany'
               );
        insert acc;
  Contact con = new Contact( 
                        LastNAme = 'CampaignContact1', Email = 'campaigncontact1@camp.com', AccountID = acc.ID, Active__c = TRUE
                        );
  insert con;
  Campaign cmp = new Campaign (Name = 'CampaignDeleteTest',Type = 'Survey',IsActive = true);
  insert cmp;
  cmpMember = new CampaignMember (CampaignId = cmp.Id,ContactId = con.Id,Status = 'Sent');
  insert cmpMember;
  }
  
  Test.startTest();
  try
  {
      Database.delete(cmpMember.Id);
  }
  catch(Exception e)
  {
      System.debug('Exception'+e);
  }
  Test.stopTest();
  
}
}