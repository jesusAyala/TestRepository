/**
 * ApexClass -  ClsTriggerJointBusinessTeam_Test
 * Release R5
 * @author  Vasanthi (Accenture)
 * @created 2016-03-23
 * @version 1.0
 * Description: 
  This class will cover the ClsTriggerJointBusinessTeam
 * Created
 
  */
@isTest
private class ClsTriggerJointBusinessTeam_Test   {

    static testMethod void ClsTriggerJointBusinessTeam_Test   () {
        
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
        userList.add(createTestUser(abbID, 'TestABB3'));
        userList.add(createTestUser(adminId, 'Admin1'));
        insert userList;
        
        AccountTeamMember[] accTeamList = new AccountTeamMember[] {
            new AccountTeamMember(AccountId = accs[0].Id, UserID = userList[0].ID),
            new AccountTeamMember(AccountId = accs[0].Id, UserID = userList[1].ID),
            new AccountTeamMember(AccountId = accs[0].Id, UserID = userList[3].ID)
        };
        
        insert accTeamList;
        
       
        Channel_Market_Coverage__c[] cmcList = new Channel_Market_Coverage__c[]{
            new Channel_Market_Coverage__c(Account__c = accs[0].Id, Primary_Channel_Class__c='Engineering, Procurement and Construction (EPC)', Division__c = 'EP;PA;')
        };
        
        insert cmcList;
        
        Joint_Business_Plan__c[] jbpList = new Joint_Business_Plan__c[] {
            new Joint_Business_Plan__c (Account__c = accs[0].id, Channel_Market_Coverage__c = cmcList[0].id, 
                Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(3), Status__c = 'Draft'),
            new Joint_Business_Plan__c (Account__c = accs[0].id, Channel_Market_Coverage__c = cmcList[0].id, 
                Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(4), Status__c = 'Draft', OwnerID = userList[0].Id)
        };
        insert jbpList;
        
        Joint_Business_Team__c[] teamList = new Joint_Business_Team__c[] {
            new Joint_Business_Team__c(Joint_Business_Plan__c = jbpList[0].Id, User__c= userList[0].ID, Access__c= 'Read/Write', Team_Role__c='GAM/SAM Account Manager'),
            new Joint_Business_Team__c(Joint_Business_Plan__c = jbpList[0].Id,  USer__c = userList[1].ID, Access__c= 'Read-Only', Team_Role__c='GAM/SAM Account Manager' ),
            new Joint_Business_Team__c(Joint_Business_Plan__c = jbpList[0].Id,  USer__c = userList[2].ID, Access__c= 'Read/Write', Team_Role__c='GAM/SAM Account Manager' ),
            new Joint_Business_Team__c(Joint_Business_Plan__c = jbpList[1].Id,  USer__c = userList[1].ID, Access__c= 'Read/Write', Team_Role__c='GAM/SAM Account Manager' )
        }; 
        
        insert teamList;
        
        teamList[0].Access__c = 'Read-Only';
        teamList[1].Access__c = 'Read/Write';
        update teamList;
        
        delete teamList[2];
        
        try {
                teamList[0].User__c = userList[1].ID;
                update teamList; //You cannot add an existing User to the Qualification Team.
        } Catch (DMLException e) {} 
            
        try {
            teamList[1].User__c = userList[3].Id;  //Cannot add System Administrator as a User 
            update teamList;
        } Catch (DMLException e) {} 
            
           
        try {
            Joint_Business_Team__c[] teamRole1 = new Joint_Business_Team__c[] {
                new Joint_Business_Team__c(Joint_Business_Plan__c = jbpList[1].Id, Access__c = 'Read/Write',  Team_Role__c='GAM/SAM Account Manager', User__c = userList[0].ID)
            };
            insert teamRole1; // Record Owner has access already
        } Catch (DMLException e) {} 
        
        try {
            Joint_Business_Team__c[] teamList1 = new Joint_Business_Team__c[] {
                new Joint_Business_Team__c(Joint_Business_Plan__c = jbpList[1].Id,  USer__c = userList[0].ID, Access__c= 'Read/Write', Team_Role__c='GAM/SAM Account Manager' )
            }; 
            
            insert teamList1;
        
        } Catch(DMLException e) {}
        
        system.runAs(userList[0]) {
          
            try {
                teamList[0].Access__c = 'Read/Write';
               
                update teamList;
            } Catch(DMLEXception e) {
            
            }
        }
        
        jbpList[1].Status__c = 'Obsolete';
        update jbpList;
        
        system.runAs(userList[0]) {
            try {
                delete teamList[3];
            } Catch(DMLEXception e) {
            
            }            
        }
        
        Test.stopTest();
        
     }
     
     
    public static User createTestUser(Id profileId, String LastNameVal) {
        User u = new User( FirstName ='haobo', LastName = LastNameVal, Username = 'test123ABB1237'+LastNameVal+'@test123ABB1237.com', Alias = LastNameVal,
            Email = 'mtester1'+LastNameVal+'@gmail.com', CommunityNickname = LastNameVal,
            ProfileId = profileId, TimeZoneSidKey = 'America/Chicago', LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US', ManagerId = UserInfo.getUserId());
        return u;
    }
}