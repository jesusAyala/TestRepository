/**
 * ApexClass -  Test_ClsAccPlanBudgetOppyList  
 * Release R5
 * @author  Vasanthi (Accenture)
 * @created 2016-03-22
 * @version 1.0
 * Description: 
  This class will cover the ClsAccPlanBudgetOppyList
 * Created
 
  */
@isTest
private class Test_ClsAccPlanBudgetOppyList  {

    static testMethod void Test_ClsAccPlanBudgetOppyList  () {
        
       
        ClsAccountUtil.isUpdate = FALSE;
        
        Account a = new Account(
            Name = 'test',
            BillingStreet = 'street', 
            BillingCity = 'city', 
            BillingCountry = 'Germany', GUID__c = '1234', Primary_Address_Country__c = 'Germany', Root_Account_GUID__c = '1234');
        insert a;
        
       /* Account[] childs = new List<Account> {
            new Account ( Name = 'test1',
                BillingStreet = 'street', 
                BillingCity = 'city', 
                BillingCountry = 'Germany', ParentID = a.ID, Root_Account_GUID__c= '1234'),
            new Account ( Name = 'test2',
                BillingStreet = 'street', 
                BillingCity = 'city', 
                BillingCountry = 'Germany', ParentID = a.ID, Root_Account_GUID__c= '1234')};
                
        insert childs;  */
        
        Account_Plan__c[] accPlanList = new Account_Plan__c[] {
            new Account_Plan__c (Name = 'Test Acc Plan1', Account__c = a.Id, Status__c = 'Planning', Account_Plan_Year__c = String.valueOf(Date.Today().Year()))
        };
        
        insert accPlanList;
        
        
        Test.startTest();
        Opportunity[] oppList = new Opportunity[] {
            new Opportunity (  Name = 'ES-Acciona, S.A-Test', AccountId = a.id, Sales_Pursuit_Progress__c = 'Opportunity is Captured', 
                StageName = 'Prospecting',  Customer_Buying_Path__c='Awareness', CloseDate = date.today().addDays(3), Industry_Usage__c = 'BLD.10.1'),
            
            new Opportunity (  Name = 'ES-Acciona, S.A-Test', AccountId = a.id, Sales_Pursuit_Progress__c = 'Opportunity is Captured', 
                StageName = 'Prospecting',  Customer_Buying_Path__c='Awareness', CloseDate = date.today().addDays(3), Industry_Usage__c = 'BLD.10.1'),
                
           new Opportunity (  Name = 'ES-Acciona, S.A-Test', AccountId =a.id, Sales_Pursuit_Progress__c = 'Opportunity is Captured', 
                StageName = 'Prospecting',  Customer_Buying_Path__c='Awareness', CloseDate = date.today().addDays(3), Industry_Usage__c = 'BLD.10.1'),
                
           new Opportunity (  Name = 'ES-Acciona, S.A-Test', AccountId = a.id, Sales_Pursuit_Progress__c = 'Opportunity is Captured', 
                StageName = 'Prospecting',  Customer_Buying_Path__c='Awareness', CloseDate = date.today().addDays(3), Industry_Usage__c = 'BLD.10.1')
            
            
        };
        
        insert oppList;
        
        
        ApexPages.StandardSetController ctrl = new ApexPages.StandardSetController (accPlanList); 
        ApexPages.currentPage().getParameters().put('Id',accPlanList[0].Id );      
        ClsAccPlanBudgetOppyList accPlanBudget = new ClsAccPlanBudgetOppyList(ctrl);
        accPlanBudget.getOpportunities();
        accPlanBudget.getdisplayOpt();
        accPlanBudget.getDivItems();
        accPlanBudget.getBUitems();
        accPlanBudget.sortRecordsByColumn();
        accPlanBudget.goToAccPlan();
        accPlanBudget.selectedOpt = 'Selected';
        accPlanBudget.changeDisplayingRecords();
        accPlanBudget.selectedOpt = 'Unselected';
        accPlanBudget.changeDisplayingRecords();
        accPlanBudget.cancel();
        accPlanBudget.getHasPrevious();
        accPlanBudget.getHasNext();
        accPlanBudget.getPageNumber();
        accPlanBudget.getTotalPages();
        accPlanBudget.doNext();
        accPlanBudget.first();
        accPlanBudget.last();
        accPlanBudget.doPrevious();
        
        accPlanBudget.selectedOppId = oppList[0].ID+','+oppList[1].ID+','+oppList[2].ID;
        accPlanBudget.SaveBudget();
        accPlanBudget.opp1.StageName = 'Prospecting';
        accPlanBudget.SearchOppRecords();
        Test.stopTest();
    }
}