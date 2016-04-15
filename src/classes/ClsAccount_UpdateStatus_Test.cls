@isTest
public class ClsAccount_UpdateStatus_Test {
 static Profile p = [SELECT Id FROM Profile WHERE Name='ABB GIS Integration']; 
        static User u = new User(Alias = 'gistest', Email='ishita_bhardwaj@infosys.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='gistest@infosys.com');
        


    static testMethod void DefaultStatusTest()
    {Validation_Override__c vc = new Validation_Override__c();
    vc.Exclude__c = true;
insert vc;
        Id GISApprovedID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('GIS Approved').getRecordTypeId();
        Id DefaultID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Default').getRecordTypeId();
        Id EXtNonBuyingID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('External Non-Buying Account').getRecordTypeId();
 

        System.runAs(u) {
        List<Account> lstAccount = new List<Account>();
        
        Account acc=new Account();
        acc.RecordTypeId=EXtNonBuyingID;
        acc.Active__c=true;
        acc.Name = 'AMP Foundries Inc';
        acc.BillingStreet = 'Teststr. 1';
        acc.BillingCountry = 'China';
        acc.BillingCity = 'Musterstadt';        
        acc.ShippingCountry = 'China';
        acc.ShippingStreet  = 'Teststr. 1';
        acc.ShippingCity = 'Musterstadt';
        acc.Company_Status__c='Duplicate';
        //insert acc;
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
        acc2.Company_Status__c='Duplicate';
        //insert acc2;
        lstAccount.add(acc2);
        
        Account acc3 =new Account();
        acc3.RecordTypeId=EXtNonBuyingID;
        acc3.Active__c=true;
        acc3.Name = 'AMP Foundries Inc';
        acc3.BillingStreet = 'Teststr. 1';
        acc3.BillingCountry = 'China';
        acc3.BillingCity = 'Musterstadt';        
        acc3.ShippingCountry = 'China';
        acc3.ShippingStreet  = 'Teststr. 1';
        acc3.ShippingCity = 'Musterstadt';
        acc3.Company_Status__c='Duplicate';
        //insert acc3;
        lstAccount.add(acc3);
        
        Account acc4 =new Account();
        acc4.RecordTypeId=GISApprovedID;
        acc4.Active__c=true;
        acc4.Name = 'AMP Foundries Inc';
        acc4.BillingStreet = 'Teststr. 1';
        acc4.BillingCountry = 'China';
        acc4.BillingCity = 'Musterstadt';        
        acc4.ShippingCountry = 'China';
        acc4.ShippingStreet  = 'Teststr. 1';
        acc4.ShippingCity = 'Musterstadt';
        acc4.Company_Status__c='Duplicate';
        //insert acc4;
        lstAccount.add(acc4);
        
        insert lstAccount; 
         
        test.startTest();
        
        
        lstAccount[0].Active__c=false;
        update lstAccount[0];
      
        lstAccount[0].Successor_Company__c = acc2.Id; 
        lstAccount[0].Reason_for_Deactivation__c = 'Duplicate';
        lstAccount[0].Active__c=true;
        update lstAccount[0];
        
        lstAccount[0].Successor_Company__c = acc3.Id; 
        lstAccount[0].Reason_for_Deactivation__c = 'Duplicate';
        lstAccount[0].Active__c=true;
        update lstAccount[0];
        
        lstAccount[0].Successor_Company__c = acc4.Id; 
        lstAccount[0].Reason_for_Deactivation__c = 'Duplicate';
        lstAccount[0].Active__c=true;
        update lstAccount[0];
        
        lstAccount[1].Successor_Company__c = acc3.Id; 
        lstAccount[1].Reason_for_Deactivation__c = 'Duplicate';
        lstAccount[1].Active__c=true;
        update lstAccount[1];
        
        lstAccount[1].Successor_Company__c = acc4.Id; 
        lstAccount[1].Reason_for_Deactivation__c = 'Duplicate';
        lstAccount[1].Active__c=true;
        update lstAccount[1];
        
        
       Account acc1=[Select  Company_Status__c,RecordTypeId from account where id=: acc.id ];
       //System.assert(acc1.Company_Status__c=='Open' && acc1.RecordTypeId==DefaultID);
      }
    }
    
        static testMethod void GisStatusTest()
    {
    Validation_Override__c vc = new Validation_Override__c();
    vc.Exclude__c = true;
insert vc;
        Id GISApprovedID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('GIS Approved').getRecordTypeId();
        Id DefaultID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Default').getRecordTypeId();
 System.runAs(u) {
        Account acc=new Account();
        acc.RecordTypeId=GISApprovedID;
        acc.Active__c=true;
        acc.Name = 'AMP Foundries Inc';
        acc.BillingStreet = 'Teststr. 1';
        acc.BillingCountry = 'China';
        acc.BillingCity = 'Musterstadt';
        
        acc.ShippingCountry = 'China';
        acc.ShippingStreet  = 'Teststr. 1';
        acc.ShippingCity = 'Musterstadt';
        acc.Company_Status__c='Approved';
        acc.GUID__c='12343';
        insert acc;
        
        Account acc2 =new Account();
        acc2.RecordTypeId=GISApprovedID;
        acc2.Active__c=true;
        acc2.Name = 'AMP Foundries Inc';
        acc2.BillingStreet = 'Teststr. 1';
        acc2.BillingCountry = 'China';
        acc2.BillingCity = 'Musterstadt';
        
        acc2.ShippingCountry = 'China';
        acc2.ShippingStreet  = 'Teststr. 1';
        acc2.ShippingCity = 'Musterstadt';
        acc2.Company_Status__c='Approved';
        insert acc2;        
        
        test.startTest();
        
        //acc.Active__c=false;
        //update acc;
        Account acc4=[Select  Company_Status__c,RecordTypeId from account where id=: acc.id ];
        acc4.Active__c=true;
        acc4.Successor_Company__c = acc2.Id; 
        acc4.Reason_for_Deactivation__c = 'Duplicate';
        update acc4;
        Account acc1=[Select  Company_Status__c,RecordTypeId from account where id=: acc.id ];
        System.assert(acc1.Company_Status__c=='Changed' && acc1.RecordTypeId==GISApprovedID);
        
        test.stopTest();}
    }
    
    static testMethod void resetStatus()
    {

        Validation_Override__c vc = new Validation_Override__c();
        vc.Exclude__c = true;
        insert vc;
        
        Id GISApprovedID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('GIS Approved').getRecordTypeId();
        Id DefaultID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Default').getRecordTypeId();
        Id EXtNonBuyingID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('External Non-Buying Account').getRecordTypeId(); 

        System.runAs(u) {
        List<Account> lstAccount = new List<Account>();
        
        Account acc=new Account();
        acc.RecordTypeId=EXtNonBuyingID;
        acc.Active__c=true;
        acc.Name = 'AMP Foundries Inc';
        acc.BillingStreet = 'Teststr. 1';
        acc.BillingCountry = 'China';
        acc.BillingCity = 'Musterstadt';        
        acc.ShippingCountry = 'China';
        acc.ShippingStreet  = 'Teststr. 1';
        acc.ShippingCity = 'Musterstadt';
        acc.Company_Status__c='Duplicate';      

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
        acc2.Company_Status__c='Duplicate';
       
        lstAccount.add(acc2);
        
        Account acc3 =new Account();
        acc3.RecordTypeId=GISApprovedID;
        acc3.Active__c=true;
        acc3.Name = 'AMP Foundries Inc';
        acc3.BillingStreet = 'Teststr. 1';
        acc3.BillingCountry = 'China';
        acc3.BillingCity = 'Musterstadt';        
        acc3.ShippingCountry = 'China';
        acc3.ShippingStreet  = 'Teststr. 1';
        acc3.ShippingCity = 'Musterstadt';
        acc3.Company_Status__c='Duplicate';
        
        lstAccount.add(acc3);
        
        insert lstAccount;
        
        test.startTest();
        
        List<Account> lstAccountupd = new List<Account>();
        acc.Active__c = false;
        acc2.Active__c = false;
        acc3.Active__c = false;
        
        lstAccountupd.add(acc);
        lstAccountupd.add(acc2);
        lstAccountupd.add(acc3);
        
        update lstAccountupd;
        
        List<Account> lstAccountupdate = new List<Account>();
        acc.Active__c = true;
        acc2.Active__c = true;
        acc3.Active__c = true;
        
        lstAccountupdate.add(acc);
        lstAccountupdate.add(acc2);
        lstAccountupdate.add(acc3);
        
        update lstAccountupdate;
        
        test.stopTest();
        
        }
        
    }
    
    
    
    
    
    
}