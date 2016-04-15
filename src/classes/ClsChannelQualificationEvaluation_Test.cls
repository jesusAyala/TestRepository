/**
 * ApexClass -  ClsChannelQualificationEvaluation_Test   
 * Release R5
 * @author  Vasanthi (Accenture)
 * @created 2016-03-23
 * @version 1.0
 * Description: 
  This class will cover the ClsChannelQualificationEvaluation
 * Created
 
  */
@isTest
private class ClsChannelQualificationEvaluation_Test   {

    static testMethod void ClsChannelQualificationEvaluation_Test () {
    
        Test.startTest();
        
        profile[] profileList = [ Select Id, Name FROM Profile Where Name IN ('ABB Sales Standard Profile', 'System Administrator')];
        
        ID adminId = (!profileList.IsEmpty() && profileList[0].Name == 'System Administrator') ? profileList[0].Id : profileList[1].Id;
        ID abbID = (!profileList.IsEmpty() && profileList[0].Name == 'ABB Sales Standard Profile') ? profileList[0].Id :  profileList[1].Id;
        
        Account[] accs = new List<Account> {
            new Account ( Name = 'test1',
                BillingStreet = 'street', 
                BillingCity = 'city', 
                BillingCountry = 'Germany'),
            new Account ( Name = 'test2',
                BillingStreet = 'street', 
                BillingCity = 'city', 
                BillingCountry = 'Germany')};
                
        insert accs;
        
        List<User> userList = new List<User>();
        userList.add(createTestUser(abbID, 'TestABB1'));
        userList.add(createTestUser(abbID, 'TestABB2'));
        insert userList;
        
        AccountTeamMember[] accTeamList = new AccountTeamMember[] {
            new AccountTeamMember(AccountId = accs[0].Id, UserID = userList[0].ID),
            new AccountTeamMember(AccountId = accs[0].Id, UserID = userList[1].ID)
        };
        
        insert accTeamList;
       
        Account_Plan__c[] accPlanList = new Account_Plan__c[] {
            new Account_Plan__c (Name = 'Test Acc Plan1', Account__c = accs[0].Id, Status__c = 'Draft', Account_Plan_Year__c = String.valueOf(Date.Today().Year()))
        };
        
        insert accPlanList;
        
        Channel_Market_Coverage__c[] cmcList = new Channel_Market_Coverage__c[]{
            new Channel_Market_Coverage__c(Account__c = accs[0].Id, Primary_Channel_Class__c='Engineering, Procurement and Construction (EPC)', Division__c = 'EP;PA;')
        };
        
        insert cmcList;
        
       
        ID CPQRecord = Schema.SObjectType.Channel_Qualifications__c.getRecordTypeInfosByName().get('Channel Qualification Detail Page').getRecordTypeId();
        Channel_Qualifications__c[] cpqList = new Channel_Qualifications__c[] {
            new Channel_Qualifications__c ( Account__c = accs[0].id, Channel_Market_Coverage__c = cmcList[0].id, Status__c = 'Draft', REcordTypeId = CPQRecord,
                BP_Answer_1__c = '6',  BP_Answer_2__c = '6', BP_Answer_3__c = '6', BP_Answer_4__c = '6', Market_Answer_1__c = '6', Market_Answer_2__c = '6',
                Portfolio_Answer_1__c = '6', Portfolio_Answer_2__c = '6', Portfolio_Answer_3__c = '6', Portfolio_Answer_4__c = '6',
                Organization_Answer_10__c = '6', Organization_Answer_11__c = '6', Organization_Answer_1__c = '6', Organization_Answer_2__c = '6', Organization_Answer_3__c = '6', 
                Organization_Answer_4__c = '6', Organization_Answer_5__c = '6', Organization_Answer_6__c = '6', Organization_Answer_7__c = '6', Organization_Answer_8__c = '6',
                Organization_Answer_9__c = '6'),
                
            new Channel_Qualifications__c ( Account__c = accs[0].id, Channel_Market_Coverage__c = cmcList[0].id, Status__c = 'Draft', REcordTypeId = CPQRecord,
                BP_Answer_1__c = '4',  BP_Answer_2__c = '4', BP_Answer_3__c = '4', BP_Answer_4__c = '4', Market_Answer_1__c = '4', Market_Answer_2__c = '4',
                Portfolio_Answer_1__c = '4', Portfolio_Answer_2__c = '4', Portfolio_Answer_3__c = '4', Portfolio_Answer_4__c = '4',
                Organization_Answer_10__c = '4', Organization_Answer_11__c = '4', Organization_Answer_1__c = '4', Organization_Answer_2__c = '4', Organization_Answer_3__c = '4', 
                Organization_Answer_4__c = '4', Organization_Answer_5__c = '4', Organization_Answer_6__c = '4', Organization_Answer_7__c = '4', Organization_Answer_8__c = '4',
                Organization_Answer_9__c = '4'),
             new Channel_Qualifications__c ( Account__c = accs[0].id, Channel_Market_Coverage__c = cmcList[0].id, Status__c = 'Draft', REcordTypeId = CPQRecord,
                BP_Answer_1__c = '0',  BP_Answer_2__c = '0', BP_Answer_3__c = '0', BP_Answer_4__c = '0', Market_Answer_1__c = '0', Market_Answer_2__c = '0',
                Portfolio_Answer_1__c = '0', Portfolio_Answer_2__c = '0', Portfolio_Answer_3__c = '0', Portfolio_Answer_4__c = '0',
                Organization_Answer_10__c = '0', Organization_Answer_11__c = '0', Organization_Answer_1__c = '0', Organization_Answer_2__c = '0', Organization_Answer_3__c = '0', 
                Organization_Answer_4__c = '0', Organization_Answer_5__c = '0', Organization_Answer_6__c = '0', Organization_Answer_7__c = '0', Organization_Answer_8__c = '0',
                Organization_Answer_9__c = '0')
        };
            
        insert cpqList ;   
        
        ApexPages.StandardController ctrl = new ApexPages.StandardController(cpqList[0]);
        ClsChannelQualificationEvaluation channel = new ClsChannelQualificationEvaluation (ctrl);
        ClsChannelQualificationEvaluation.Item[] itemList = channel.data;
        String st = channel.fields;
        String st2 = channel.titles ;
        
        ApexPages.StandardController ctrl1 = new ApexPages.StandardController(cpqList[1]);
        ClsChannelQualificationEvaluation channel1 = new ClsChannelQualificationEvaluation (ctrl1);
        ClsChannelQualificationEvaluation.Item[] itemList1 = channel1.data;
        
        ApexPages.StandardController ctrl2 = new ApexPages.StandardController(cpqList[2]);
        ClsChannelQualificationEvaluation channel2 = new ClsChannelQualificationEvaluation (ctrl2);
        ClsChannelQualificationEvaluation.Item[] itemList2 = channel2.data;
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