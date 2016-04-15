/**
 * ApexClass -  Test class Test_AddProductQualificationTeam
 * Release R5
 * @author  Vasanthi (Accenture)
 * @created 2016-03-21
 * @version 1.0
 * Description: 
 * This is the Test class for the AddProductQualificationTeam
  */
@isTest
private class Test_AddProductQualificationTeam {

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
        userList.add(createTestUser(abbID, 'TestABB3'));
        userList.add(createTestUser(abbID, 'TestABB4'));
        userList.add(createTestUser(abbID, 'TestABB5'));
        insert userList;
        
        AccountTeamMember[] accTeamList = new AccountTeamMember[] {
            new AccountTeamMember(AccountId = accs[0].Id, UserID = userList[0].ID),
            new AccountTeamMember(AccountId = accs[0].Id, UserID = userList[1].ID),
            new AccountTeamMember(AccountId = accs[0].Id, UserID = userList[2].ID)
        };
        
        insert accTeamList;
        
        Product_Qualification__c[] productQulList = new Product_Qualification__c[] {
            new Product_Qualification__c(Account__c = accs[0].Id, Initiative_Status__c = 'Open', Comments__c = 'Test Comments', Startdate__c = Date.Today(), Target_End_Date__c = Date.Today().addDays(3)),
            new Product_Qualification__c(Account__c = accs[0].Id, OwnerId = userList[1].ID, Initiative_Status__c = 'Closed Not Qualified', Comments__c = 'Test Comments', Startdate__c = Date.Today().addDays(1), Target_End_Date__c = Date.Today().addDays(3)),
            new Product_Qualification__c(Account__c = accs[0].Id, Comments__c = 'Test Comments', Startdate__c = Date.Today().addDays(1), Target_End_Date__c = Date.Today().addDays(3))
        };
        
        insert productQulList;
        
        ApexPages.StandardController ctrl = new ApexPages.StandardController(productQulList[2]); 
        Apexpages.currentPage().getParameters().put('Id', productQulList[2].Id);
        AddProductQualificationTeam addTeam = new AddProductQualificationTeam(ctrl);
        addTeam.prodQualTeam1 = new Product_Qualification_Team_Role__c(Product_Qualification__c = productQulList[2].Id, Access__c = 'Read/Write', User__c = userList[0].ID);
        addTeam.prodQualTeam2 = new Product_Qualification_Team_Role__c(Product_Qualification__c = productQulList[2].Id, Access__c = 'Read/Write', User__c = userList[1].ID);
        addTeam.prodQualTeam3 = new Product_Qualification_Team_Role__c(Product_Qualification__c = productQulList[2].Id, Access__c = 'Read/Write', User__c = userList[3].ID);
        addTeam.prodQualTeam4 = new Product_Qualification_Team_Role__c(Product_Qualification__c = productQulList[2].Id, Access__c = 'Read/Write', User__c = userList[4].ID);
        addTeam.prodQualTeam5 = new Product_Qualification_Team_Role__c(Product_Qualification__c = productQulList[2].Id, Access__c = 'Read/Write', User__c = userList[5].ID);
        addTeam.saveRecord();
        addteam.saveMoreRecord();
        addTeam.prodQualTeam5 = new Product_Qualification_Team_Role__c(Product_Qualification__c = productQulList[2].Id, Access__c = 'Read/Write', User__c = userList[5].ID);
        addTeam.saveRecord();
        addTeam.cancel();
        addTeam.GoBack();
        
        ApexPages.StandardController ctrl2 = new ApexPages.StandardController(productQulList[0]); 
        Apexpages.currentPage().getParameters().put('Id', productQulList[0].Id);
        AddProductQualificationTeam addTeam2 = new AddProductQualificationTeam(ctrl2);
        addTeam2.prodQualTeam1 = new Product_Qualification_Team_Role__c(Product_Qualification__c = productQulList[0].Id, Access__c = 'Read/Write', User__c = userList[0].ID);
        addTeam2.prodQualTeam2 = new Product_Qualification_Team_Role__c(Product_Qualification__c = productQulList[0].Id, Access__c = 'Read/Write', User__c = userList[1].ID);
        addTeam2.prodQualTeam3 = new Product_Qualification_Team_Role__c(Product_Qualification__c = productQulList[0].Id, Access__c = 'Read/Write', User__c = userList[3].ID);
        addTeam2.prodQualTeam4 = new Product_Qualification_Team_Role__c(Product_Qualification__c = productQulList[0].Id, Access__c = 'Read/Write', User__c = userList[4].ID);
        addTeam2.prodQualTeam5 = new Product_Qualification_Team_Role__c(Product_Qualification__c = productQulList[0].Id, Access__c = 'Read/Write', User__c = userList[5].ID);
        addTeam2.saveMoreRecord();
        addTeam2.saveMoreRecord();
        addTeam2.saveMoreRecord();
        
        
        ApexPages.StandardController ctrl3 = new ApexPages.StandardController(productQulList[1]); 
        Apexpages.currentPage().getParameters().put('Id', productQulList[1].Id);
        AddProductQualificationTeam addTeam3 = new AddProductQualificationTeam(ctrl3);
     
    }
    
    public static User createTestUser(Id profileId, String LastNameVal) {
        User u = new User( FirstName ='haobo', LastName = LastNameVal, Username = 'test123ABB1237'+LastNameVal+'@test123ABB1237.com', Alias = LastNameVal,
            Email = 'mtester1'+LastNameVal+'@company.com', CommunityNickname = LastNameVal,
            ProfileId = profileId, TimeZoneSidKey = 'America/Chicago', LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US', ManagerId = UserInfo.getUserId());
        return u;
    }

}