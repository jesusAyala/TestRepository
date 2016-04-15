/**
 * Apex Test Class for -   ClsMarketTrendList
 * Controller for VF page - MarketTrendList
 * Release R5
 * @author  Indhu Ramalingam (Accenture)
 * @created 2016-3-22
 */
 @isTest
 Public Class ClsMarketTrendList_Test{
 
    public static Account createAccount1() {
        Account a = new Account();
        a.Name = 'test';
        a.BillingStreet = 'street'; 
        a.BillingCity = 'city';
        a.BillingCountry = 'Germany';
        a.GUID__c = '1234sghf';
        return a;
    }
    
    public static Channel_Market_Coverage__c createCMS() {
        Channel_Market_Coverage__c ms = new Channel_Market_Coverage__c();
        ms.Name = 'TestMarketScope1';
        ms.Primary_Channel_Class__c = 'Distributor (DIS)';
        ms.Division__c = 'DM';
        ms.CurrencyIsoCode = 'USD';
        ms.Focussed_Industry1__c = 'Industry - Chemical;Industry - Petrochemicals';
        return ms;
    }
    
    public static Joint_Business_Plan__c createJBP() {
        Date sDate = Date.today();
        Date eDate = sDate.addDays(2);
        Joint_Business_Plan__c jbp = new Joint_Business_Plan__c();
        jbp.Name = 'JBP Test1';
        jbp.Start_Date__c = sDate;
        jbp.End_Date__c= eDate;
        jbp.CurrencyIsoCode= 'USD';      //'USD-U.S. Dollar';
        jbp.Status__c= 'Draft';
        return jbp;
    }
    
    public static Channel_Business_Review__c createCBR() {
        Channel_Business_Review__c CBR = new Channel_Business_Review__c();
        CBR.Name='TestReview1';
        return CBR;
    }
    
    public static Channel_Business_Review_Market_Trend__c createMarkTrend() {
        Channel_Business_Review_Market_Trend__c marketTrend = new Channel_Business_Review_Market_Trend__c();
        return marketTrend;
    }
    
    public static Channel_Business_Review_Market_Trend__c createMarkTrend1() {
        Channel_Business_Review_Market_Trend__c marketTrend1 = new Channel_Business_Review_Market_Trend__c();
        return marketTrend1;
    }
    
    static testMethod void marketTrendMethod() {
        Test.startTest();
        Account a = createAccount1();        
        insert a; 
        
        Channel_Market_Coverage__c cms = createCMS();
        cms.Account__c = a.Id;
        insert cms;
        
        Joint_Business_Plan__c jbp = createJBP();
        jbp.Channel_Market_Coverage__c = cms.Id;
        insert jbp;
        
        Channel_Business_Review__c CBR = createCBR();
        CBR.Account__c=a.Id;
        CBR.Joint_Business_Plan__c=jbp.Id; 
        insert CBR;
        
        Channel_Business_Review_Market_Trend__c marketTrend = createMarkTrend();
        marketTrend.Channel_Business_Review__c = CBR.Id;
        marketTrend.Focussed_Industry__c = cms.Focussed_Industry1__c;
        insert marketTrend;
        
        Channel_Business_Review_Market_Trend__c marketTrend1 = createMarkTrend1();
        marketTrend1.Channel_Business_Review__c = CBR.Id;
        marketTrend1.Focussed_Industry__c = cms.Focussed_Industry1__c;
        insert marketTrend1;
        
        //Code for Apex Class - ClsMarketTrendList  
        apexpages.currentpage().getparameters().put('Id', CBR.Id);
        ApexPages.StandardController stdCtrllerList = new ApexPages.StandardController(CBR);        
        ClsMarketTrendList markTrendList = new ClsMarketTrendList(stdCtrllerList);       
        markTrendList.save();
        markTrendList.cancel();     
        
        Test.stopTest();
    }
}