/**
 * ApexClass -  Test_ClsTriggerVisitReport  
 * Release R5
 * @author  Vasanthi (Accenture)
 * @created 2016-03-22
 * @version 1.0
 * Description: 
  This class will cover the ClsTriggerVisitReport 
 * Created
 
  */
@isTest
private class Test_ClsTriggerVisitReport   {

    static testMethod void Test_ClsTriggerVisitReport () {
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
        
        Joint_Business_Plan__c[] jbpList = new Joint_Business_Plan__c[] {
            new Joint_Business_Plan__c (Account__c = accs[0].id, Channel_Market_Coverage__c = cmcList[0].id, 
                Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(3), Status__c = 'Draft')
        };
        insert jbpList;
        
        ID MP = Schema.SObjectType.Channel_Business_Review__c.getRecordTypeInfosByName().get('Mid-Period Business Review Detail').getRecordTypeId();
        Channel_Business_Review__c[] CBRList = new Channel_Business_Review__c[] { 
            new Channel_Business_Review__c (Account__c = accs[0].id, Joint_Business_Plan__c = jbpList[0].Id, RecordtypeId = MP, Status__c = 'Draft')
        };
        insert CBRList ;
        
        ID CPQRecord = Schema.SObjectType.Channel_Qualifications__c.getRecordTypeInfosByName().get('Channel Qualification Detail Page').getRecordTypeId();
        Channel_Qualifications__c[] cpqList = new Channel_Qualifications__c[] {
            new Channel_Qualifications__c ( Account__c = accs[0].id, Channel_Market_Coverage__c = cmcList[0].id, Status__c = 'Draft', REcordTypeId = CPQRecord )
        };
        insert cpqList ;   
        
        Visit_Report__c[] reportList = new Visit_Report__c[] {
            new Visit_Report__c(Account__c = accs[0].id, Account_Plan__c = accPlanList[0].Id, OwnerID = userList[0].ID),
            new Visit_Report__c(Account__c = accs[0].id, Joint_Business_Plan__c = jbpList[0].Id,  OwnerID = userList[0].ID),
            new Visit_Report__c(Account__c = accs[0].id, Channel_Pre_Qualification__c = cpqList[0].Id, OwnerID = userList[0].ID),
            new Visit_Report__c(Account__c = accs[0].id, Channel_Review__c = CBRList[0].Id, OwnerID = userList[0].ID)
        }; 
        
        insert reportList;
        /*
        Visit_Report_Team_Member__c[] teamList = new Visit_Report_Team_Member__c[] {
            new Visit_Report_Team_Member__c(User__c = userList[0].ID, Visit_Report__c = reportList[0].Id, Access_Level__c = 'Read/Write', Team_Role__c = 'Business Support'),
            new Visit_Report_Team_Member__c(User__c = userList[0].ID, Visit_Report__c = reportList[1].Id, Access_Level__c = 'Read/Write', Team_Role__c = 'Business Support'),
            new Visit_Report_Team_Member__c(User__c = userList[0].ID, Visit_Report__c = reportList[2].Id, Access_Level__c = 'Read/Write', Team_Role__c = 'Business Support'),
            new Visit_Report_Team_Member__c(User__c = userList[0].ID, Visit_Report__c = reportList[3].Id, Access_Level__c = 'Read/Write', Team_Role__c = 'Business Support')
        };
        insert teamList;*/
        
        accPlanList[0].Status__c = 'Closed';
        update accPlanList;
        
        jbpList[0].Status__c = 'Obsolete';
        update jbpList;
        
        CBRList[0].Status__c = 'Obsolete';
        update CBRList;
        
        cpqList[0].Status__c = 'Obsolete';
        update cpqList;
        system.runAs(userList[0]) {
            try {
                delete reportList;
            } Catch(DMLEXception e) {
            
            }
        }
        
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