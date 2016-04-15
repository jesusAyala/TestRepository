/**
 * ApexClass -  Test class Test_ClsNewProductQualification  
 * Release R5
 * @author  Vasanthi (Accenture)
 * @created 2016-03-21
 * @version 1.0
 * Description: 
 * This is the Test class for ClsNewProductQualification (81%)
  */
@isTest
private class Test_ClsNewProductQualification  {

    static testMethod void testClsNewProductQualification() {
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
       
        insert userList;
        
        AccountTeamMember[] accTeamList = new AccountTeamMember[] {
            new AccountTeamMember(AccountId = accs[0].Id, UserID = userList[0].ID)
        };
        
        insert accTeamList;
        
        Product_Qualification__c[] productQulList = new Product_Qualification__c[] {
            new Product_Qualification__c(Account__c = accs[0].Id, Initiative_Status__c = 'Open', Comments__c = 'Test Comments', Startdate__c = Date.Today(), Target_End_Date__c = Date.Today().addDays(3))
        };
        
        insert productQulList;
        
       
        ApexPages.StandardController ctrl = new ApexPages.StandardController(productQulList[0]); 
        Apexpages.currentPage().getParameters().put('Id', productQulList[0].Id);
        ClsNewProductQualification addTeam = new ClsNewProductQualification(ctrl);
        addTeam.savePQRecord();
        addTeam.cancelPQRecord();
    }
    
    public static User createTestUser(Id profileId, String LastNameVal) {
        User u = new User( FirstName ='haobo', LastName = LastNameVal, Username = 'test123ABB1237'+LastNameVal+'@test123ABB1237.com', Alias = LastNameVal,
            Email = 'mtester1'+LastNameVal+'@company.com', CommunityNickname = LastNameVal,
            ProfileId = profileId, TimeZoneSidKey = 'America/Chicago', LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US', ManagerId = UserInfo.getUserId());
        return u;
    }

}