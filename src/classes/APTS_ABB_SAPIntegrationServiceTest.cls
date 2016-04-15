@isTest(SeeAllData = false)
public class APTS_ABB_SAPIntegrationServiceTest {
    
    @testSetup static void setupTestData() {
    
        User user = APTS_LP_TestUtility.getUser();
        APTS_LP_TestUtility.getDiscountConfig();
        APTS_LP_TestUtility.getCommonConfigSetting();
        Account acc =  APTS_LP_TestUtility.getNewAccount('Test-Account', 'Spain');
        insert acc;
        
        Apttus_Config2__PriceList__c testPriceList = APTS_LP_TestUtility.getPriceList(acc,'Spain');
        insert testPriceList;
        
        APTS_Agreement_SAP_Setting__c sapSetting = new APTS_Agreement_SAP_Setting__c();
        sapSetting.APTS_Country__c = 'Spain';
        insert sapSetting;
        
        APTS_LP_TestUtility.getIntegrationParameters();
        
        Apttus__APTS_Agreement__c  agr1 = new Apttus__APTS_Agreement__c();
        agr1 = APTS_LP_TestUtility.getAgreement('TestAgreement');
        agr1.APTS_LP_AccountCustomer__c = acc.id;
        agr1.APTS_Country__c = 'Spain';          
        agr1.APTS_Integration_Status__c = 'Empty';
        agr1.Apttus__Workflow_Trigger_Created_From_Clone__c = false;
        agr1.Apttus__Status__c = 'Draft';
        agr1.Apttus_CMConfig__PriceListId__c = testPriceList.Id;         
        Date startdate = System.today();
        Date enddate = startdate.addMonths(3);         
        agr1.Apttus__Contract_Start_Date__c = startdate;
        agr1.Apttus__Contract_End_Date__c = enddate; 
        insert agr1;
        
        APTS_LP_TestUtility.getIntegrationParameters();
        APTS_LP_TestUtility.getSAPIntegrationTokens();
        APTS_LP_TestUtility.getCommonConfigSetting();
        APTS_LP_TestUtility.getLODConfigSetting();
        
        Product2 product2 = APTS_LP_TestUtility.getProduct();
        product2.APTS_LP_Is_Hierarchy__c = false;
        insert product2;
        
        List<Apttus__AgreementLineItem__c> listAgreementLineItem = APTS_LP_TestUtility.getAgreementLineItemList(agr1.id,2);
        
        for(Apttus__AgreementLineItem__c agrLineItem : listAgreementLineItem){
            
            agrLineItem.Apttus_CMConfig__BasePrice__c = 10;
            agrLineItem.Apttus__ProductId__r = product2;
            agrLineItem.Apttus__Quantity__c = 5;
            agrLineItem.APTS_Discount_Type__c = 'Substitute Discount' ;
            
        }
        
        insert listAgreementLineItem;
            
    }
    
    static testmethod void testCallInvoke_NoAgreement(){
        
        Test.startTest();
        APTS_ABB_SAPIntegrationServiceBaseImpl obj = new APTS_ABB_SAPIntegrationServiceBaseImpl();
        Boolean isSucscess = obj.invoke('abc', '');
        System.assertEquals(false, isSucscess);
        Test.stopTest();
    }
    
    static testmethod void testCallInvoke_NOToken(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new APTPS_SAPCalloutMockTest());
        Apttus__APTS_Agreement__c agreement = [SELECT Id from Apttus__APTS_Agreement__c WHERE Id != null];
        APTS_ABB_SAPIntegrationServiceBaseImpl obj = new APTS_ABB_SAPIntegrationServiceBaseImpl();
        Boolean isSucscess = obj.invoke(agreement.Id, 'false');
        Test.stopTest();
    }
    
    
    static testmethod void testCallInvoke_WithToken(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new APTPS_SAPCalloutMockTest());
        
        Apttus__APTS_Agreement__c agreement = [SELECT Id from Apttus__APTS_Agreement__c WHERE Id != null];
        APTS_ABB_SAPIntegrationServiceBaseImpl obj = new APTS_ABB_SAPIntegrationServiceBaseImpl();
        Boolean isSucscess = obj.invoke(agreement.Id, 'false');
        Test.stopTest();
    }
    
    static testmethod void testCallInvoke_WithBlock(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new APTPS_SAPCalloutMockTest());
        
        Apttus__APTS_Agreement__c agreement = [SELECT Id from Apttus__APTS_Agreement__c WHERE Id != null];
        APTS_ABB_SAPIntegrationServiceBaseImpl obj = new APTS_ABB_SAPIntegrationServiceBaseImpl();
        Boolean isSucscess = obj.invoke(agreement.Id, 'true');
        Test.stopTest();
    }
    
    static testmethod void testCallInvoke_WithErr(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new APTPS_SAPCalloutMockTest('502'));
        
        Apttus__APTS_Agreement__c agreement = [SELECT Id from Apttus__APTS_Agreement__c WHERE Id != null];
        APTS_ABB_SAPIntegrationServiceBaseImpl obj = new APTS_ABB_SAPIntegrationServiceBaseImpl();
        Boolean isSucscess = obj.invoke(agreement.Id, 'true');
        Test.stopTest();
    }
}