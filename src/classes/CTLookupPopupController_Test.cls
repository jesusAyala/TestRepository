/**************************************************************************
Author      :  Sajila Kadayaprath
Description :  Test class for CTLookupPopupController 
Created Date : 03/15/2016
*****************************************************************************/
@isTest
private class CTLookupPopupController_Test{
    
    public static Account createAccount() {
        Account a = new Account();
        a.Name = 'Test Account';
        a.BillingStreet = 'Test Street'; 
        a.BillingCity = 'Test City';
        a.BillingCountry = 'Germany';
        a.GUID__c = 'Test123';
        return a;
    }
    
    private static testMethod void TestCTLookupPopup(){   
        
        Test.startTest();
        
        PageReference pageRef = Page.CTLookupPopup;
        Test.setCurrentPage(pageRef);       
        CTLookupPopupController c=new CTLookupPopupController();  
        Account a = createAccount();
        insert a;  
        c.query='Account'; 
        Pagereference p=c.runQuery();   
        
        c.query='New'; 
        Pagereference p1=c.runQuery();
             
        Test.stopTest();
    }
}