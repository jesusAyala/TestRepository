/**
*  This test class used to test class ClsBatch_calcAPLPreviousForecast.
*
@author MohanRaj
@created 2014-11-26
*
@changelog
* coverage  79%
*  
2014-11-26 Mohanraj
* - Created
*
*/
@isTest
private class ClsAccountUtil_Test {
    
    static testMethod void MyTestclsUtil() {
   
    Id GISApprovedID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('GIS Approved').getRecordTypeId();
    Id DefaultID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Default').getRecordTypeId();
    Id EXtNonBuyingID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('External Non-Buying Account').getRecordTypeId();
    
    list<ReAssigning_Related_Records__c> list_ReAssigningCustoms = new list<ReAssigning_Related_Records__c>();        
    
    ReAssigning_Related_Records__c setting1 = new ReAssigning_Related_Records__c();
    setting1.Name = 'Contact';
    setting1.Parent_API__c = 'AccountId';
    setting1.isClone__c = false;
    setting1.IsDuplicate__c = true;
    setting1.IsOutBusiness__c = true;
    setting1.IsDuplicate_Copy__c = false;
    setting1.IsOutBusiness_Copy__c = false;
    list_ReAssigningCustoms.add(setting1);  
    
    ReAssigning_Related_Records__c setting2 = new ReAssigning_Related_Records__c();
    setting2.Name = 'AccountContactRole';
    setting2.Parent_API__c = 'AccountId';
    setting2.Require_Field__c = 'ContactId,Role';
    setting2.isClone__c = true;
    setting2.IsDuplicate__c = true;
    setting2.IsOutBusiness__c = true;
    setting2.IsDuplicate_Copy__c = false;
    setting2.IsOutBusiness_Copy__c = false;
    list_ReAssigningCustoms.add(setting2);
    
    insert list_ReAssigningCustoms;
        
        
    List<Account> lstAccount = new List<Account>();
    
    Account acc=new Account();
    acc.RecordTypeId=DefaultID;
    acc.Active__c=true;
    acc.Name = 'AMP Foundries Inc1';
    acc.BillingStreet = 'Teststr. 1';
    acc.BillingCountry = 'China';
    acc.BillingCity = 'Musterstadt';        
    acc.ShippingCountry = 'China';
    acc.ShippingStreet  = 'Teststr. 1';
    acc.ShippingCity = 'Musterstadt';
    acc.Company_Status__c='Open';        
    lstAccount.add(acc);
    
    Account acc2 =new Account();
    acc2.RecordTypeId=DefaultID;
    acc2.Active__c=true;
    acc2.Name = 'AMP Foundries Inc';
    acc2.BillingStreet = 'Teststr. 1';
    acc2.BillingCountry = 'China';
    acc2.BillingCity = 'Musterstadt';        
    acc2.ShippingCountry = 'China';
    acc2.ShippingStreet  = 'Teststr. 1';
    acc2.ShippingCity = 'Musterstadt';
    acc2.Company_Status__c='Open';        
    lstAccount.add(acc2);   
    
    insert lstAccount; 
    
    
    Contact con = ClsTestHelp.createTestContacts();
    con.LastName = 'TestContact';
    con.AccountId = acc.Id;
    con.Email_Opt_Out__c = false;
    con.Preferred_Contact_Method__c = 'Email';
    insert con;
     
    Product_Group__c pg = new Product_Group__c();
    pg.Business_Unit__c = 'Test';
    pg.Name = 'TestName';
    pg.Division__c = 'DZ';
    insert pg;
        
    Safe_Island_Assessments__c sia = new Safe_Island_Assessments__c();
    sia.PG__c = pg.Id;
    sia.Country__c = 'Sweden';
    sia.Credit_Assessment__c ='Weak (Credit rating 1 - 2)';
    sia.AccountCustomer__c = lstAccount[0].Id;
    insert sia; 
    
    lstAccount[0].Successor_Company__c = acc2.Id; 
    lstAccount[0].Reason_for_Deactivation__c = 'Duplicate';
    lstAccount[0].Active__c=true;
    //update lstAccount[0];
    
    map<String, String> map_accId_successorCompany = new map<String, String>(); 
    map<string,string> map_accId_successorCompany_Out=new map<String, String>();
    
    map_accId_successorCompany.put(lstAccount[0].Id, lstAccount[0].Successor_Company__c);
    map_accId_successorCompany_Out.put(lstAccount[0].Id, lstAccount[0].Successor_Company__c);

    Set<Id> SafeIsland = new Set<Id>();
    SafeIsland.add(sia.Id);
    
    Set <Id> Setcmpid =new Set<Id>();
    if(map_accId_successorCompany.size()>0)
    {for(String acid:map_accId_successorCompany.keySet())
    {
        Setcmpid.add(acid);    
    }}
    
    Set <Id> SetSuccid =new Set<Id>();
   
    if(map_accId_successorCompany_Out.size()>0)
    {for(String acid:map_accId_successorCompany_Out.keySet())
    {
        SetSuccid.add(acid);   
    }}
    
    Test.startTest();    
    ClsAccountUtil.isUpdate = false;    
    String str = ClsAccountUtil.setSuccessorCompany_InactiveCheck(map_accId_successorCompany, map_accId_successorCompany_Out);                 
    Test.stopTest();
        
    }
    
    
    
    static testMethod void MyTestclsUtil2() {
    
    Profile p = [SELECT Id FROM Profile WHERE Name= 'ABB Sales Standard Profile']; 
    User u = new User(Alias = 'sysadmin', Email='SysAdmin@Accenture.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='admintest@accenture.com');   
    
    System.runAs(u) {
   
    Id GISApprovedID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('GIS Approved').getRecordTypeId();
    Id DefaultID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Default').getRecordTypeId();
    Id EXtNonBuyingID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('External Non-Buying Account').getRecordTypeId();
    
    list<ReAssigning_Related_Records__c> list_ReAssigningCustoms = new list<ReAssigning_Related_Records__c>();        
    
    ReAssigning_Related_Records__c setting1 = new ReAssigning_Related_Records__c();
    setting1.Name = 'Contact';
    setting1.Parent_API__c = 'AccountId';
    setting1.isClone__c = false;
    setting1.IsDuplicate__c = true;
    setting1.IsOutBusiness__c = true;
    setting1.IsDuplicate_Copy__c = false;
    setting1.IsOutBusiness_Copy__c = false;
    list_ReAssigningCustoms.add(setting1);  
    
    ReAssigning_Related_Records__c setting2 = new ReAssigning_Related_Records__c();
    setting2.Name = 'Safe_Island_Assessments__c';
    setting2.Parent_API__c = 'AccountCustomer__c';   
    setting2.isClone__c = false;
    setting2.IsDuplicate__c = true;
    setting2.IsOutBusiness__c = true;
    setting2.IsDuplicate_Copy__c = false;
    setting2.IsOutBusiness_Copy__c = false;
    list_ReAssigningCustoms.add(setting2);
    
    ReAssigning_Related_Records__c setting3 = new ReAssigning_Related_Records__c();
    setting3.Name = 'Attachment';
    setting3.Parent_API__c = 'ParentId';   
    setting3.Require_Field__c = 'Body, Name';
    setting3.isClone__c = true;
    setting3.IsDuplicate__c = true;
    setting3.IsOutBusiness__c = true;
    setting3.IsDuplicate_Copy__c = false;
    setting3.IsOutBusiness_Copy__c = false;
    list_ReAssigningCustoms.add(setting3);
    
    ReAssigning_Related_Records__c setting4 = new ReAssigning_Related_Records__c();
    setting4.Name = 'Note';
    setting4.Parent_API__c = 'ParentId';   
    setting4.Require_Field__c = 'Title, Body';
    setting4.isClone__c = true;
    setting4.IsDuplicate__c = true;
    setting4.IsOutBusiness__c = true;
    setting4.IsDuplicate_Copy__c = false;
    setting4.IsOutBusiness_Copy__c = false;
    list_ReAssigningCustoms.add(setting4);
    
    
    ReAssigning_Related_Records__c setting5 = new ReAssigning_Related_Records__c();
    setting5.Name = 'AccountTeamMember';
    setting5.Parent_API__c = 'AccountId';   
    setting5.Require_Field__c = 'UserId,TeamMemberRole';
    setting5.isClone__c = true;
    setting5.IsDuplicate__c = true;
    setting5.IsOutBusiness__c = true;
    setting5.IsDuplicate_Copy__c = false;
    setting5.IsOutBusiness_Copy__c = false;
    list_ReAssigningCustoms.add(setting5);
    
    ReAssigning_Related_Records__c setting6 = new ReAssigning_Related_Records__c();
    setting6.Name = 'AccountContactRole';
    setting6.Parent_API__c = 'AccountId';
    setting6.Require_Field__c = 'ContactId,Role';
    setting6.isClone__c = true;
    setting6.IsDuplicate__c = true;
    setting6.IsOutBusiness__c = true;
    setting6.IsDuplicate_Copy__c = false;
    setting6.IsOutBusiness_Copy__c = false;
    list_ReAssigningCustoms.add(setting6);
    
    insert list_ReAssigningCustoms;
        
            
    List<Account> lstAccount = new List<Account>();
    
    Account acc=new Account();
    acc.RecordTypeId=EXtNonBuyingID;
    acc.Active__c=true;
    acc.Name = 'AMP Foundries Inc1';
    acc.BillingStreet = 'Teststr. 1';
    acc.BillingCountry = 'China';
    acc.BillingCity = 'Musterstadt';        
    acc.ShippingCountry = 'China';
    acc.ShippingStreet  = 'Teststr. 1';
    acc.ShippingCity = 'Musterstadt';
    acc.Company_Status__c='Open';        
    lstAccount.add(acc);
    
    Account acc2 =new Account();
    acc2.RecordTypeId=EXtNonBuyingID;
    acc2.Active__c=true;
    acc2.Name = 'AMP Foundries Inc';
    acc2.BillingStreet = 'Teststr. 1';
    acc2.BillingCountry = 'China';
    acc2.BillingCity = 'Musterstadt';        
    acc2.ShippingCountry = 'China';
    acc2.ShippingStreet  = 'Teststr. 1';
    acc2.ShippingCity = 'Musterstadt';
    acc2.Company_Status__c='Open';        
    lstAccount.add(acc2);   
    
    insert lstAccount; 
    
    
    Contact con = ClsTestHelp.createTestContacts();
    con.LastName = 'TestContact';
    con.AccountId = acc.Id;
    con.Email_Opt_Out__c = false;
    con.Preferred_Contact_Method__c = 'Email';
    insert con;
    
    Note no = new Note();
    no.ParentId = acc.Id;
    no.Title = 'test';
    no.Body = 'test';
    insert no;

    Attachment att = new Attachment();
    att.ParentId = acc.Id;
    att.Name = 'test';
    att.Body = Blob.valueOf('test');
    insert att;
     
    Product_Group__c pg = new Product_Group__c();
    pg.Business_Unit__c = 'Test';
    pg.Name = 'TestName';
    pg.Division__c = 'DZ';
    insert pg;
        
    Safe_Island_Assessments__c sia = new Safe_Island_Assessments__c();
    sia.PG__c = pg.Id;
    sia.Country__c = 'Sweden';
    sia.Credit_Assessment__c ='Weak (Credit rating 1 - 2)';
    sia.AccountCustomer__c = lstAccount[0].Id;
    insert sia; 
           
        
    AccountTeamMember accteam = new AccountTeamMember();
    accteam.AccountId = acc.Id;
    accteam.UserId = u.Id;
    accteam.TeamMemberRole = 'Engineering';
    insert accteam;
    
    lstAccount[0].Successor_Company__c = acc2.Id; 
    lstAccount[0].Reason_for_Deactivation__c = 'Duplicate';
    lstAccount[0].Active__c=true;
    //update lstAccount[0];
    
    map<String, String> map_accId_successorCompany = new map<String, String>(); 
    map<string,string> map_accId_successorCompany_Out=new map<String, String>();
    
    map_accId_successorCompany.put(acc.Id, acc2.Id);
    map_accId_successorCompany_Out.put(acc.Id, acc2.Id);

    Set<Id> SafeIsland = new Set<Id>();
    SafeIsland.add(sia.Id);
    
    Test.startTest();        
    ClsAccountUtil.isUpdate = false;
    ClsAccountUtil.setSuccessorCompany(map_accId_successorCompany, map_accId_successorCompany_Out,SafeIsland);
    ClsAccountUtil.batchToReAssignAccount('Duplicate', SafeIsland);
    ClsAccountUtil.abortScheduledJobToReAssignAccount();
    
    
    map<String, String> map_objectAPI_Sql = new map<String, String>();
    map<String, String> map_objectAPI_parentAPI = new map<String, String>();
    map<String, Boolean> map_objectAPI_isClone = new map<String, Boolean>();
    map<String, Boolean> map_objectAPI_isCopy = new map<String, Boolean>();
    
    ClsAccountUtil.ReAssigningSettingInfos objres = new  ClsAccountUtil.ReAssigningSettingInfos(map_objectAPI_Sql, map_objectAPI_parentAPI,map_objectAPI_isClone, map_objectAPI_isCopy);
    
    Test.stopTest();
    }
        
        
    }
    
    
    
    public static LBU_Code__c createTestLBUCode() {
        
        LBU_Code__c lbu = new LBU_Code__c();
        lbu.Name = 'test';
        lbu.BU__c = 'test';
        lbu.Division__c = 'DM';       
        return lbu;
    }

}