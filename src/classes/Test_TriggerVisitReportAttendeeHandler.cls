/**
 * ApexClass -  Test_TriggerVisitReportAttendeeHandler  
 * Release R5
 * @author  Vasanthi (Accenture)
 * @created 2016-04-05
 * @version 1.0
 * Description: 
  This class will cover the ClsTriggerVisitReportAttendeeHandler  
 * Created
 
  */
@isTest
private class Test_TriggerVisitReportAttendeeHandler  {

    static testMethod void Test_TriggerVisitReportAttendeeHandler  () {
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
            new Channel_Business_Review__c (Account__c = accs[0].id, Joint_Business_Plan__c = jbpList[0].Id, RecordtypeId = MP, Status__c = 'Draft'),
            new Channel_Business_Review__c (Account__c = accs[1].id, Joint_Business_Plan__c = jbpList[0].Id, RecordtypeId = MP, Status__c = 'Draft')
        };
        insert CBRList ;
        
        Contact con = new Contact(LastName = 'Test Contact', AccountID = accs[0].Id, Email = 'test@gmail.com', Active__c = TRUE);
        insert con;
       
        Visit_Report__c[] reportList = new Visit_Report__c[] {
            new Visit_Report__c(Account__c = accs[0].id, Channel_Review__c= CBRList [0].Id, OwnerID = userList[0].ID),
            new Visit_Report__c(Account__c = accs[0].id, Channel_Review__c= CBRList [1].Id, OwnerID = userList[0].ID)
        }; 
        
        insert reportList;
        
        Visit_Attendee__c[] attendeeList = new Visit_Attendee__c[] {
            new Visit_Attendee__c(Attendee__c = con.id, Visit_Report__c= reportList[0].Id),
            new Visit_Attendee__c(Attendee__c = con.id, Visit_Report__c= reportList[1].Id)
        }; 
        
        insert attendeeList;
        
        delete attendeeList;
       
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