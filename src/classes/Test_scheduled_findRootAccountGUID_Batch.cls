/**
 * ApexClass -  Test_scheduled_findRootAccountGUID_Batch 
 * Release R5
 * @author  Vasanthi (Accenture)
 * @created 2016-2-8
 * @version 1.0
 * Description: As per Req #2737(KAD-00821) To find root account GUID. 
  This class will cover the scheduled_findRootAccountGUID_Batch (Scheduler Class)- 100%, findRootAccountGUID_Batch (Batch Class) - 98(%), FindRootAccountClass (80%)
 * Created
 
  */
@isTest
private class Test_scheduled_findRootAccountGUID_Batch {

    static testMethod void myTest() {
        Test.startTest();
        
        profile[] profileList = [ Select Id, Name FROM Profile Where Name IN ('ABB Sales Standard Profile', 'System Administrator')];
        
        ID adminId = (!profileList.IsEmpty() && profileList[0].Name == 'System Administrator') ? profileList[0].Id : profileList[1].Id;
        ID abbID = (!profileList.IsEmpty() && profileList[0].Name == 'ABB Sales Standard Profile') ? profileList[0].Id :  profileList[1].Id;
        
        List<User> userList = new List<User>();
        userList.add(createTestUser(abbID, 'TestABB1'));
        insert userList;
        
        System.runAs(userList[0]) {
        
        //ClsAccountUtil.isAccTriggerFlag = TRUE;
        ClsAccountUtil.isUpdate = false;
        
         Id GISApprovedID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('GIS Approved').getRecordTypeId();
        Account a = new Account(
            Name = 'test',
            BillingStreet = 'street', 
            BillingCity = 'city', 
            BillingCountry = 'Germany', GUID__c = '1234sghf', RecordTypeID = GISApprovedID );
        insert a;
        
        Account[] childs = new List<Account> {
            new Account ( Name = 'test1',
                BillingStreet = 'street', 
                BillingCity = 'city', 
                BillingCountry = 'Germany', ParentID = a.ID,RecordTypeID = GISApprovedID),
            new Account ( Name = 'test2',
                BillingStreet = 'street', 
                BillingCity = 'city', 
                BillingCountry = 'Germany', ParentID = a.ID, RecordTypeID = GISApprovedID)};
                
        insert childs;  
        
        Account[] childs1 = new List<Account> {
            new Account ( Name = 'test11',
                BillingStreet = 'street', 
                BillingCity = 'city', 
                BillingCountry = 'Germany', ParentID = childs[0].ID,RecordTypeID = GISApprovedID),
            new Account ( Name = 'test12',
                BillingStreet = 'street', 
                BillingCity = 'city', 
                BillingCountry = 'Germany', ParentID = childs[0].ID,RecordTypeID = GISApprovedID)};
                
        insert childs1;  
        
        Account[] childs2 = new List<Account> {
            new Account ( Name = 'test21',
                BillingStreet = 'street', 
                BillingCity = 'city', 
                BillingCountry = 'Germany', ParentID = childs1[0].ID, RecordTypeID = GISApprovedID),
            new Account ( Name = 'test22',
                BillingStreet = 'street', 
                BillingCity = 'city', 
                BillingCountry = 'Germany', ParentID = childs1[0].ID, RecordTypeID = GISApprovedID)};
                
        insert childs2;   
        
        Account[] childs3 = new List<Account> {
            new Account ( Name = 'test23',
                BillingStreet = 'street', 
                BillingCity = 'city', 
                BillingCountry = 'Germany', ParentID = childs2[0].ID, RecordTypeID = GISApprovedID),
            new Account ( Name = 'test24',
                BillingStreet = 'street', 
                BillingCity = 'city', 
                BillingCountry = 'Germany', ParentID = childs2[0].ID,RecordTypeID = GISApprovedID)};
                
        insert childs3;   
        
        
        Account[] childs4 = new List<Account> {
            new Account ( Name = 'test25',
                BillingStreet = 'street', 
                BillingCity = 'city', 
                BillingCountry = 'Germany', ParentID = childs3[0].ID, RecordTypeID = GISApprovedID),
            new Account ( Name = 'test26',
                BillingStreet = 'street', 
                BillingCity = 'city', 
                BillingCountry = 'Germany', ParentID = childs3[0].ID, RecordTypeID = GISApprovedID)};
                
        insert childs4;  
        
         Account[] childs5= new List<Account> {
            new Account ( Name = 'test27',
                BillingStreet = 'street', 
                BillingCity = 'city', 
                BillingCountry = 'Germany', ParentID = childs4[0].ID, RecordTypeID = GISApprovedID),
            new Account ( Name = 'test28',
                BillingStreet = 'street', 
                BillingCity = 'city', 
                BillingCountry = 'Germany', ParentID = childs4[0].ID,RecordTypeID = GISApprovedID)};
                
        insert childs5;      
        }
        String CRON_EXP = '0 0 0 15 3 ?';

        scheduled_findRootAccountGUID_Batch sc = new scheduled_findRootAccountGUID_Batch();
        String jobId = system.schedule('Find Root Account GUID', CRON_EXP, sc );
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, ct.CronExpression);
        
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