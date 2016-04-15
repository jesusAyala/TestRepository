/**
 * ApexClass -  Test_ClsTriggerOpportunityInformation  
 * Release R5
 * @author  Vasanthi (Accenture)
 * @created 2016-04-08
 * @version 1.0
 * Description: 
  This class will cover the ClsTriggerOpportunityInformation
 * Created
 
  */
@isTest
private class Test_ClsTriggerOpportunityInformation  {

    static testMethod void Test_ClsTriggerOpportunityInformation  () {
        
        Test.startTest();
       
        ClsAccountUtil.isUpdate = FALSE;
        
        Account a = new Account(
            Name = 'test',
            BillingStreet = 'street', 
            BillingCity = 'city', 
            BillingCountry = 'Germany', GUID__c = '1234', Primary_Address_Country__c = 'Germany', Root_Account_GUID__c = '1234');
        insert a;
        
       Channel_Market_Coverage__c[] cmcList = new Channel_Market_Coverage__c[]{
            new Channel_Market_Coverage__c(Account__c = a.Id, Primary_Channel_Class__c='Engineering, Procurement and Construction (EPC)', Division__c = 'EP;PA;')
        };
        
        insert cmcList;
        
        Joint_Business_Plan__c[] jbpList = new Joint_Business_Plan__c[] {
            new Joint_Business_Plan__c (Account__c = a.Id, Channel_Market_Coverage__c = cmcList[0].id, 
                Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(3), Status__c = 'Draft')
        };
        insert jbpList;
        
        ID MP = Schema.SObjectType.Channel_Business_Review__c.getRecordTypeInfosByName().get('Mid-Period Business Review Detail').getRecordTypeId();
        Channel_Business_Review__c[] CBRList = new Channel_Business_Review__c[] { 
            new Channel_Business_Review__c (Account__c = a.Id, Joint_Business_Plan__c = jbpList[0].Id, RecordtypeId = MP, Status__c = 'Draft')
        };
        insert CBRList ;
        
        
        Opportunity[] oppList = new Opportunity[] {
            new Opportunity (  Name = 'ES-Acciona, S.A-Test', AccountId = a.id, Sales_Pursuit_Progress__c = 'Opportunity is Captured', 
                StageName = 'Prospecting',  Customer_Buying_Path__c='Awareness', CloseDate = date.today().addDays(3), Industry_Usage__c = 'BLD.10.1'),
            
            new Opportunity (  Name = 'ES-Acciona, S.A-Test', AccountId = a.id, Sales_Pursuit_Progress__c = 'Opportunity is Captured', 
                StageName = 'Prospecting',  Customer_Buying_Path__c='Awareness', CloseDate = date.today().addDays(3), Industry_Usage__c = 'BLD.10.1'),
                
           new Opportunity (  Name = 'ES-Acciona, S.A-Test', AccountId =a.id, Sales_Pursuit_Progress__c = 'Opportunity is Captured', 
                StageName = 'Prospecting',  Customer_Buying_Path__c='Awareness', CloseDate = date.today().addDays(3), Industry_Usage__c = 'BLD.10.1'),
                
           new Opportunity (  Name = 'ES-Acciona, S.A-Test', AccountId = a.id, Sales_Pursuit_Progress__c = 'Opportunity is Captured', 
                StageName = 'Prospecting',  Customer_Buying_Path__c='Awareness', CloseDate = date.today().addDays(3), Industry_Usage__c = 'BLD.10.1')
            
            
        };
        
        insert oppList;
        Test.stopTest();
    }
    
    public static User createTestUser(Id profileId, String LastNameVal) {
        User u = new User( FirstName ='haobo', LastName = LastNameVal, Username = 'test123ABB1237'+LastNameVal+'@test123ABB1237.com', Alias = LastNameVal,
            Email = 'mtester1'+LastNameVal+'@company.com', CommunityNickname = LastNameVal,
            ProfileId = profileId, TimeZoneSidKey = 'America/Chicago', LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US', ManagerId = UserInfo.getUserId());
        return u;
    }
}