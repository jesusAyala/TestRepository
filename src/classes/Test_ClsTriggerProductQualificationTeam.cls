/**
 * ApexClass -  Test class Test_ClsTriggerProductQualificationTeam
 * Release R5
 * @author  Vasanthi (Accenture)
 * @created 2016-03-21
 * @version 1.0
 * Description: Test class for 
 * Created
 * This is the Test class for the ClsTriggerProductQualificationTeam trigger handler
  */
@isTest
private class Test_ClsTriggerProductQualificationTeam {

    static testMethod void myTest() {
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
        userList.add(createTestUser(adminId, 'Admin1'));
        insert userList;
        
        AccountTeamMember[] accTeamList = new AccountTeamMember[] {
            new AccountTeamMember(AccountId = accs[0].Id, UserID = userList[0].ID),
            new AccountTeamMember(AccountId = accs[0].Id, UserID = userList[1].ID),
            new AccountTeamMember(AccountId = accs[0].Id, UserID = userList[2].ID)
        };
        
        insert accTeamList;
        
        Product_Qualification__c[] productQulList = new Product_Qualification__c[] {
            new Product_Qualification__c(Account__c = accs[0].Id, OwnerId = userList[1].ID, Initiative_Status__c = 'Open', Comments__c = 'Test Comments', Startdate__c = Date.Today(), Target_End_Date__c = Date.Today().addDays(3)),
            new Product_Qualification__c(Account__c = accs[0].Id, Initiative_Status__c = 'Open', Comments__c = 'Test Comments', Startdate__c = Date.Today().addDays(1), Target_End_Date__c = Date.Today().addDays(3))
        };
        
        insert productQulList;
        
        
        system.runAs(userList[2]) {
            
            Product_Qualification_Team_Role__c[] teamRole = new Product_Qualification_Team_Role__c[] {
                new Product_Qualification_Team_Role__c(Product_Qualification__c = productQulList[1].Id, Access__c = 'Read/Write', User__c = userList[0].ID),
                new Product_Qualification_Team_Role__c(Product_Qualification__c = productQulList[1].Id, Access__c = 'Read/Write', User__c = userList[1].ID),
                new Product_Qualification_Team_Role__c(Product_Qualification__c = productQulList[0].Id, Access__c = 'Read/Write', User__c = userList[0].ID)
            };
            insert teamRole; //Success case
            
            delete teamRole[2];
            
            try {
                teamRole[0].User__c = userList[1].ID;
                update teamRole; //You cannot add an existing User to the Qualification Team.
            } Catch (DMLException e) {} 
            
            try {
                teamRole[1].User__c = userList[2].Id;  //Cannot add System Administrator as a User 
                update teamRole;
            } Catch (DMLException e) {} 
            
           
            try {
                Product_Qualification_Team_Role__c[] teamRole1 = new Product_Qualification_Team_Role__c[] {
                    new Product_Qualification_Team_Role__c(Product_Qualification__c = productQulList[0].Id, Access__c = 'Read/Write', User__c = userList[1].ID)
                };
                insert teamRole1; // Record Owner has access already
            } Catch (DMLException e) {} 
        }
    }
    
    public static User createTestUser(Id profileId, String LastNameVal) {
        User u = new User( FirstName ='haobo', LastName = LastNameVal, Username = 'test123ABB1237'+LastNameVal+'@test123ABB1237.com', Alias = LastNameVal,
            Email = 'mtester1'+LastNameVal+'@company.com', CommunityNickname = LastNameVal,
            ProfileId = profileId, TimeZoneSidKey = 'America/Chicago', LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US', ManagerId = UserInfo.getUserId());
        return u;
    }

}