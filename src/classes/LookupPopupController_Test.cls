/**************************************************************************
Author      :  Sajila Kadayaprath
Description :  Test class for LookupPopupController 
Created Date : 03/15/2016
*****************************************************************************/
@isTest
private class LookupPopupController_Test{
    
    public static Account createAccount() {
        Account a = new Account();
        a.Name = 'Test Account';
        a.BillingStreet = 'Test Street'; 
        a.BillingCity = 'Test City';
        a.BillingCountry = 'Germany';
        a.GUID__c = 'Test123';
        return a;
    }
    
    private static testMethod void TestLookupPopup(){   
        
        Test.startTest();
        
        PageReference pageRef = Page.CTLookupPopup;
        Test.setCurrentPage(pageRef);       
        LookupPopupController c=new LookupPopupController();  
        Account a = createAccount();
        insert a;  
        c.query='Account'; 
        Pagereference p=c.runQuery();   
             
        Test.stopTest();
    }
}