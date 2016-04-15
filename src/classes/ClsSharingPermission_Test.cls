@isTest
private class ClsSharingPermission_Test {

     public static User createTestUser1() {
        User u = new User();
        u.FirstName ='haobo';
        u.LastName = 'song';
        u.Username = 'test123ABB1237@test123ABB1237.com';
        u.Alias = 'mtst4';
        u.Email = 'mtester1@company.com';
        u.CommunityNickname = u.Alias;
        u.ProfileId = [Select Id from Profile Where Name = 'ABB Sales Standard Profile' limit 1].Id;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.ManagerId = UserInfo.getUserId();
        return u;
    }
    public static User createTestUser2() {
        User u = new User();
        u.FirstName ='haobo';
        u.LastName = 'song';
        u.Username = 'test1234awsedr@test1234.com';
        u.Alias = 'mtst2';
        u.Email = 'mtester2ABB1236@companyABB1236.com';
        u.CommunityNickname = u.Alias;
        u.ProfileId = [Select Id from Profile Where Name = 'System Administrator' limit 1].Id;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.ManagerId = UserInfo.getUserId();
        return u;
    }
    public static User createTestUser3() {
        User u = new User();
        u.FirstName ='haobo';
        u.LastName = 'song';
        u.Username = 'test12345ABB1235@test12345ABB1235.com';
        u.Alias = 'mtst3';
        u.Email = 'mtester3@company.com';
        u.CommunityNickname = u.Alias;
        u.ProfileId = [Select Id from Profile Where Name = 'ABB Basic Admin' limit 1].Id;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.ManagerId = UserInfo.getUserId();
        return u;
    }
    
    public static Account createAccount1(){
        Account a = new Account();
        a.Name = 'test';
        a.BillingStreet = 'street'; 
        a.BillingCity = 'city';
        a.BillingCountry = 'Germany';
        a.GUID__c = '1234sghf';
        return a;
    }

    public static Customer_Segmentation__c createAccSegmentation(){
        Customer_Segmentation__c cs = new Customer_Segmentation__c();
        cs.Customer_Sales_Segmentation__c = 'A';
        cs.Growth_Potential_Year__c='1992';
        cs.DIV__c = 'DM';
        return cs;
    }
    
    static testMethod void myUnitTestTrue() {
        Test.StartTest();
        User u1 = createTestUser1();
            insert u1;
        User u2 = createTestUser2();
            insert u2;
        User u3 = createTestUser3();
            insert u3;      
        Account a = createAccount1();
            insert a;  
        AccountTeamMember aTM = new AccountTeamMember(
            UserId = u1.id,
            TeamMemberRole = 'Manager', 
            AccountId = a.id);
            insert aTM; 
        AccountTeamMember aTM1 = new AccountTeamMember(
            UserId = u2.id,
            TeamMemberRole = 'Sales Manager', 
            AccountId = a.id);
            insert aTM1; 
        AccountTeamMember aTM2 = new AccountTeamMember(
            UserId = u3.id,
            TeamMemberRole = 'Support Manager', 
            AccountId = a.id);
            insert aTM2; 
        Customer_Segmentation__c cs1 = createAccSegmentation();
            cs1.Account__c = a.id;
            insert cs1;
      
        // Code Coverage for ApexClass - ClsSharingPermission
        //system.runAs(u3){
          PageReference pageRef = Page.SharingPermission;         
    //    pageRef.getParameters().put('object', 'Customer_Segmentation__c');
          pageRef.getParameters().put('object', 'Account');
          pageRef.getparameters().put('Id', a.Id);
          pageRef.getParameters().put('allowRTS', 'true');

          Test.setCurrentPage(pageRef);
         
          ClsSharingPermission controller = new ClsSharingPermission();
          pageReference p = controller.accessPermission();
            
        Test.StopTest();
        //}
        
    }
    
    static testMethod void myUnitTestFalse() {
        User u1 = createTestUser1();
            insert u1;
        User u2 = createTestUser2();
            insert u2;
        User u3 = createTestUser3();
            insert u3;
        
      // Code Coverage for ApexClass - ClsSharingPermission  
      system.runAs(u2){
      PageReference pageRef = Page.SharingPermission;
      pageRef.getParameters().put('object', 'Channel_Market_Coverage__c');
      pageRef.getParameters().put('allowRTS', 'false');

      Test.setCurrentPage(pageRef);

      Test.StartTest();
      ClsSharingPermission controller = new ClsSharingPermission();
      pageReference p = controller.accessPermission();
        Test.StopTest();
     }
        
    }

}