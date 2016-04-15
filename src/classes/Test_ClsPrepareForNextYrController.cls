/**
 * ApexClass -  Test_ClsPrepareForNextYrController 
 * Release R5
 * @author  Vasanthi (Accenture)
 * @created 2016-03-15
 * @version 1.0
 * Description: 
  This class will cover the ClsPrepareForNextYrController - 79%
 * Created
 
  */
@isTest
private class Test_ClsPrepareForNextYrController {

    static testMethod void myTest() {
        
        Test.startTest();
        
        Account a = new Account(
            Name = 'test',
            BillingStreet = 'street', 
            BillingCity = 'city', 
            BillingCountry = 'Germany', GUID__c = '1234sghf');
        insert a;
        
        Channel_Market_Coverage__c mc = new Channel_Market_Coverage__c ( Account__c = a.Id, Name = 'Test Market Coverage', Division__c = 'PA', Primary_Channel_Class__c ='Installer (INST)');
        insert mc;
        
        Joint_Business_Plan__c jbp = new Joint_Business_Plan__c( Account__c = a.Id, Channel_Market_Coverage__c = mc.Id, Name = 'Test Joint Business Plan', 
            Start_Date__c = Date.Today(), End_Date__c = Date.Today(), Status__c='Active', CurrencyISOCode = 'USD');
        insert jbp;
        
        Joint_Business_Plan_Product_Lines__c productLines = new Joint_Business_Plan_Product_Lines__c( 
            Starting_Year__c = String.ValueOf(Date.Today().Year()), Joint_Business_Plan__c = jbp.Id,
            Current_Year_Currency__c = 145, Second_Year_Currency__c = 200, Previous_Year_Currency__c = 200, 
            Third_Year_Currency__c = 200, Current_Ongoing_Year__c = 200,
            Forecast_Ongoing_Year__c = 200, Starting_Year_Product__c = 'Test Product', CurrencyISOCode = 'USD', Actual_Year_to_Date_Changed_on__c = Date.Today());
        insert productLines;
        
        ApexPages.StandardController controller = new ApexPages.StandardController(productLines);
        ClsPrepareForNextYrController clsPrepareIns = new ClsPrepareForNextYrController(controller);
        clsPrepareIns.cloneRecord();
        clsPrepareIns.back();
        Test.stopTest();
    }
    
}