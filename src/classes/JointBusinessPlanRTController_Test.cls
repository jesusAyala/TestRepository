/**
 * ApexClass -  JointBusinessPlanRTController_Test
 * Release R5
 * @author  Vasanthi (Accenture)
 * @created 2016-03-23
 * @version 1.0
 * Description: 
  This class will cover the JointBusinessPlanRecordTypeController
 * Created
 
  */
@isTest
private class JointBusinessPlanRTController_Test{

    static testMethod void JointBusinessPlanRecordTypeController_Test() {
        
        Test.startTest();
        profile[] profileList = [ Select Id, Name FROM Profile Where Name IN ('ABB Sales Standard Profile', 'System Administrator')];
        
        ID adminId = (!profileList.IsEmpty() && profileList[0].Name == 'System Administrator') ? profileList[0].Id : profileList[1].Id;
        ID abbID = (!profileList.IsEmpty() && profileList[0].Name == 'ABB Sales Standard Profile') ? profileList[0].Id :  profileList[1].Id;
        
        Account[] accs = new List<Account> {
            new Account ( Name = 'test1',
                BillingStreet = 'street', 
                BillingCity = 'city', 
                BillingCountry = 'Germany', Company_Description__c  = 'tessssssssssssssssssssssssssssssssssssssssssttttttttttt'),
            new Account ( Name = 'test2',
                BillingStreet = 'street', 
                BillingCity = 'city', 
                BillingCountry = 'Germany')};
                
        insert accs;
        
        List<User> userList = new List<User>();
        userList.add(createTestUser(adminId, 'Admin1'));
        userList.add(createTestUser(abbID , 'ABB1'));
        insert userList;
        
        AccountTeamMember[] accTeamList = new AccountTeamMember[] {
            new AccountTeamMember(AccountId = accs[0].Id, UserID = userList[0].ID),
            new AccountTeamMember(AccountId = accs[0].Id, UserID = userList[1].ID)
        };
        
        insert accTeamList;
        
       
        Channel_Market_Coverage__c[] cmcList = new Channel_Market_Coverage__c[]{
            new Channel_Market_Coverage__c(Account__c = accs[0].Id, Primary_Channel_Class__c = 'Distributor (DIS)', Targeted_AVP__c = TRUE,  Division__c = 'EP;PA;'),
            new Channel_Market_Coverage__c(Account__c = accs[0].Id, Targeted_AVP__c = TRUE, Primary_Channel_Class__c='Engineering, Procurement and Construction (EPC)', Division__c = 'EP;PA;'),
            new Channel_Market_Coverage__c(Account__c = accs[0].Id, Targeted_AVP__c = FALSE, Primary_Channel_Class__c='Distributor (DIS)', Targeted_Key_Strategic__c = TRUE, Division__c = 'EP;PA;'),
            new Channel_Market_Coverage__c(Account__c = accs[0].Id, Targeted_AVP__c = FALSE, Primary_Channel_Class__c='Distributor (DIS)', Targeted_Key_Strategic__c = FALSE, Division__c = 'EP;PA;'),
            new Channel_Market_Coverage__c(Account__c = accs[0].Id, Targeted_AVP__c = FALSE, Primary_Channel_Class__c='Engineering, Procurement and Construction (EPC)', Division__c = 'EP;PA;', Targeted_Key_Strategic__c = TRUE),
            new Channel_Market_Coverage__c(Account__c = accs[0].Id, Targeted_AVP__c = FALSE, Primary_Channel_Class__c='Engineering, Procurement and Construction (EPC)', Division__c = 'EP;PA;', Targeted_Key_Strategic__c = FALSE)
        };
        
        insert cmcList;
        
        JointBusinessPlanRecordTypeController jbpCtrl = new JointBusinessPlanRecordTypeController();
        ApexPages.currentPage().getParameters().put('Id', cmcList[0].Id);
        System.currentPageReference().getParameters().put('Object', 'Joint_Business_Plan__c');
        System.currentPageReference().getParameters().put('ID_Account__c',accs[0].Id);
        jbpCtrl.redirect();
        
        JointBusinessPlanRecordTypeController jbpCtrl1 = new JointBusinessPlanRecordTypeController();
        ApexPages.currentPage().getParameters().put('Id', cmcList[1].Id);
        System.currentPageReference().getParameters().put('ID_Account__c',accs[0].Id);
        System.currentPageReference().getParameters().put('Object', 'Joint_Business_Plan__c');
        jbpCtrl1.redirect();
        
        JointBusinessPlanRecordTypeController jbpCtrl2 = new JointBusinessPlanRecordTypeController();
        ApexPages.currentPage().getParameters().put('Id', cmcList[2].Id);
        System.currentPageReference().getParameters().put('ID_Account__c',accs[0].Id);
        System.currentPageReference().getParameters().put('Object', 'Joint_Business_Plan__c');
        jbpCtrl2.redirect();
        
        JointBusinessPlanRecordTypeController jbpCtrl3 = new JointBusinessPlanRecordTypeController();
        ApexPages.currentPage().getParameters().put('Id', cmcList[3].Id);
        System.currentPageReference().getParameters().put('ID_Account__c',accs[0].Id);
        System.currentPageReference().getParameters().put('Object', 'Joint_Business_Plan__c');
        jbpCtrl3.redirect();
        
        JointBusinessPlanRecordTypeController jbpCtrl4 = new JointBusinessPlanRecordTypeController();
        ApexPages.currentPage().getParameters().put('Id', cmcList[4].Id);
        System.currentPageReference().getParameters().put('ID_Account__c',accs[0].Id);
        System.currentPageReference().getParameters().put('Object', 'Joint_Business_Plan__c');
        jbpCtrl4.redirect();
        
        JointBusinessPlanRecordTypeController jbpCtrl5 = new JointBusinessPlanRecordTypeController();
        ApexPages.currentPage().getParameters().put('Id', cmcList[5].Id);
        System.currentPageReference().getParameters().put('ID_Account__c',accs[0].Id);
        System.currentPageReference().getParameters().put('Object', 'Joint_Business_Plan__c');
        jbpCtrl5.redirect();
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