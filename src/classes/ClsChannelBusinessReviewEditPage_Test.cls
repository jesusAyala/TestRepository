/**
 * Apex Test Class for -   ClsChannelBusinessReviewEditPage
 * Controller for Vf page - ChannelBusinessReviewEditPage
 * Release R5
 * @author  Ayiravalli Arasu (Accenture)
 * @created 2016-3-11
 */
 @isTest
 Public Class ClsChannelBusinessReviewEditPage_Test{
 
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
        ms.Primary_Channel_Class__c='Distributor (DIS)';
        ms.Division__c='DM';
        ms.CurrencyIsoCode='USD';
        ms.Focussed_Industry1__c= 'Industry - Chemical;Industry - Petrochemicals';
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
    
    public static Joint_Business_Plan_Actions__c createJBPAct(){
        Date sDate = Date.today();
        Date eDate = sDate.addDays(2);
        Joint_Business_Plan_Actions__c jbpAct = new Joint_Business_Plan_Actions__c();
        jbpAct.Name = 'testAction1';
        jbpAct.Registered__c = sDate;
        jbpAct.Deadline__c = eDate;
        jbpAct.Status__c ='In progress';
        return jbpAct;
    }
    
    public static Joint_Business_Plan_Actions__c createJBPAct2(){
        Date sDate = Date.today();
        Date eDate = sDate.addDays(4);
        Joint_Business_Plan_Actions__c jbpAct2 = new Joint_Business_Plan_Actions__c();
        jbpAct2.Name = 'testAction2';
        jbpAct2.Registered__c = sDate;
        jbpAct2.Deadline__c = eDate;
        jbpAct2.Status__c ='Completed';
        return jbpAct2;
    }
    
    public static Joint_Business_Plan_Actions__c createJBPAct3(){
        Date sDate = Date.today();
        Date eDate = sDate.addDays(1);
        Joint_Business_Plan_Actions__c jbpAct3 = new Joint_Business_Plan_Actions__c();
        jbpAct3.Name = 'testAction3';
        jbpAct3.Registered__c = sDate;
        jbpAct3.Deadline__c = eDate;
        jbpAct3.Status__c ='Failed';
        return jbpAct3;
    }
    
    
    //ClsChannelBusinessReviewEditPage
    Static testMethod void methodTest1(){
        Test.StartTest();
        ID GA = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GIS Approved').getRecordTypeId();
        Account a = createAccount1();
        a.RecordtypeId = GA;
        insert a; 
        
        Channel_Market_Coverage__c cms = createCMS();
        cms.Account__c = a.Id;
        insert cms;
        
        ID DP = Schema.SObjectType.Joint_Business_Plan__c.getRecordTypeInfosByName().get('1. Distributor as Partner').getRecordTypeId();
        Joint_Business_Plan__c jbp = createJBP();
        jbp.RecordtypeId = DP;
        jbp.Channel_Market_Coverage__c = cms.Id;
        insert jbp;
        
        ID EP = Schema.SObjectType.Channel_Business_Review__c.getRecordTypeInfosByName().get('End-Period Business Review Detail').getRecordTypeId();
        Channel_Business_Review__c CBR = createCBR();
        CBR.Account__c=a.Id;
        CBR.Joint_Business_Plan__c=jbp.Id; 
        CBR.RecordtypeId =  EP;
        insert CBR;
        
        ID MP = Schema.SObjectType.Channel_Business_Review__c.getRecordTypeInfosByName().get('Mid-Period Business Review Detail').getRecordTypeId();
        Channel_Business_Review__c CBR2 = createCBR();
        CBR2.Account__c=a.Id;
        CBR2.Joint_Business_Plan__c=jbp.Id; 
        CBR2.RecordtypeId =  MP;
        insert CBR2;
       
        apexpages.currentpage().getparameters().put('Id', CBR.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(CBR);
        ClsChannelBusinessReviewEditPage CBRedit = new ClsChannelBusinessReviewEditPage();
        CBRedit.editPageChange();        

        apexpages.currentpage().getparameters().put('Id', CBR2.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(CBR2);
        ClsChannelBusinessReviewEditPage CBRedit2 = new ClsChannelBusinessReviewEditPage();
        CBRedit2.editPageChange();
        Test.StopTest(); 
     }
     
     //ClsChannelBusinessReviewMarketTrend
     Static testMethod void methodTest2(){
        Test.StartTest();
        ID GA = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GIS Approved').getRecordTypeId();
        Account a = createAccount1();
        a.RecordtypeId = GA;
        insert a;
        
        Channel_Market_Coverage__c cms = createCMS();
        cms.Account__c = a.Id;
        insert cms;
        cms.Focussed_Industry1__c= 'Industry - Chemical;Building - Industrial Buildings';
        update cms;
        
        ID DP = Schema.SObjectType.Joint_Business_Plan__c.getRecordTypeInfosByName().get('1. Distributor as Partner').getRecordTypeId();
        Joint_Business_Plan__c jbp = createJBP();
        jbp.RecordtypeId = DP;
        jbp.Channel_Market_Coverage__c = cms.Id;
        insert jbp;
        
        ID EP = Schema.SObjectType.Channel_Business_Review__c.getRecordTypeInfosByName().get('End-Period Business Review Detail').getRecordTypeId();
        Channel_Business_Review__c CBR = createCBR();
        CBR.Account__c=a.Id;
        CBR.Joint_Business_Plan__c=jbp.Id; 
        CBR.RecordtypeId =  EP;
        insert CBR;
        apexpages.currentpage().getparameters().put('Id', CBR.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(CBR);
        ClsChannelBusinessReviewMarketTrend mt = new ClsChannelBusinessReviewMarketTrend(sc);
        mt.createChannelBusinessReviewMarketTrend(); 
        mt.GoBack();
        Test.StopTest();
      }
      
      //ClsTriggerChannelBusinessReview
     Static testMethod void methodTest3(){
        Test.StartTest();
        ID GA = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GIS Approved').getRecordTypeId();
        Account a = createAccount1();
        a.RecordtypeId = GA;
        insert a;
        
        Channel_Market_Coverage__c cms = createCMS();
        cms.Account__c = a.Id;
        insert cms;
        
        ID DP = Schema.SObjectType.Joint_Business_Plan__c.getRecordTypeInfosByName().get('1. Distributor as Partner').getRecordTypeId();
        Joint_Business_Plan__c jbp = createJBP();
        jbp.RecordtypeId = DP;
        jbp.Channel_Market_Coverage__c = cms.Id;
        insert jbp;
        
        ID SALES = Schema.SObjectType.Joint_Business_Plan_Actions__c.getRecordTypeInfosByName().get('1.Sales').getRecordTypeId();
        Joint_Business_Plan_Actions__c ja1=createJBPAct();
        ja1.RecordtypeId =SALES;
        ja1.Joint_Business_Plan__c=jbp.Id; 
        insert ja1;
        
        Joint_Business_Plan_Actions__c ja2=createJBPAct2();
        ja2.RecordtypeId =SALES;
        ja2.Joint_Business_Plan__c=jbp.Id; 
        insert ja2;
        
        Joint_Business_Plan_Actions__c ja3=createJBPAct3();
        ja3.RecordtypeId =SALES;
        ja3.Joint_Business_Plan__c=jbp.Id; 
        insert ja3;
        
        ID EP = Schema.SObjectType.Channel_Business_Review__c.getRecordTypeInfosByName().get('End-Period Business Review Detail').getRecordTypeId();
        Channel_Business_Review__c CBR = createCBR();
        CBR.Account__c=a.Id;
        CBR.Joint_Business_Plan__c=jbp.Id; 
        CBR.RecordtypeId =  EP;
        insert CBR;
        ClsTriggerChannelBusinessReview cr =new ClsTriggerChannelBusinessReview ();
        Test.StopTest();
      }
 }