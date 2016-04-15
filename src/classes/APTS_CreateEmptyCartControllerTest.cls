@isTest
private class APTS_CreateEmptyCartControllerTest {
    
    private static APTS_Capture_LSO_Input_Config_Settings__c lodConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();
    
    @isTest static void postiveTestCase() {
        System.runAs(APTS_LP_TestUtility.getUser()) {
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCustomSetting();
            APTS_LP_TestUtility.getCommonConfigSetting();
            Account acc = APTS_LP_TestUtility.getNewAccount('Test Acc','Spain');
            insert acc;
            
            Apttus_Config2__PriceList__c priceList = APTS_LP_TestUtility.getPriceList(acc,'Spain');
            insert priceList;
            
            Apttus__APTS_Agreement__c agreement = APTS_LP_TestUtility.getAgreement('Test Agr 1');
            agreement.Apttus_CMConfig__PriceListId__c = priceList.id;
            insert agreement;
            System.debug(agreement.id +'-- id --');
            
            
            Test.startTest();
            Test.setCurrentPageReference(new PageReference('Page.APTS_CreateEmptyCartPage'));
            System.currentPageReference().getParameters().put('id', agreement.id);
            System.currentPageReference().getParameters().put('sObject', 'agreement');
            
            
            APTS_CreateEmptyCartController emptyCartController = new APTS_CreateEmptyCartController();
            
            PageReference pageRef = emptyCartController.createEmptyCart();
            System.debug(pageRef.getUrl() + '--> url');
            System.assert(pageRef.getUrl().contains('Configuration') , true);
            Test.stopTest();
        }
        
    }
    
    @isTest static void exceptionTestCase() {
        System.runAs(APTS_LP_TestUtility.getUser()) {
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCustomSetting();
            APTS_LP_TestUtility.getCommonConfigSetting();
            Account acc = APTS_LP_TestUtility.getNewAccount('Test Acc','Spain');
            insert acc;
            
            Apttus_Config2__PriceList__c priceList = APTS_LP_TestUtility.getPriceList(acc,'Spain');
            insert priceList;
            
            Apttus__APTS_Agreement__c agreement = APTS_LP_TestUtility.getAgreement('Test Agr 1');
            agreement.Apttus_CMConfig__PriceListId__c = priceList.Id;
            insert agreement;
            System.debug(agreement.id +'-- id --');
            
            
            Test.startTest();
            Test.setCurrentPageReference(new PageReference('Page.APTS_CreateEmptyCartPage'));
            System.currentPageReference().getParameters().put('id', agreement.id);
            System.currentPageReference().getParameters().put('sObject', 'agreement');
            
            
            APTS_CreateEmptyCartController emptyCartController = new APTS_CreateEmptyCartController();
            
            PageReference pageRef = emptyCartController.createEmptyCart();
            
            //System.assertEquals(pageRef , null);
            Test.stopTest();
        }
        
    }
    
    @isTest static void goBackTestCase() {
        System.runAs(APTS_LP_TestUtility.getUser()) {
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCustomSetting();
            APTS_LP_TestUtility.getCommonConfigSetting();
            Account acc = APTS_LP_TestUtility.getNewAccount('Test Acc','Spain');
            insert acc;
            
            Apttus_Config2__PriceList__c priceList = APTS_LP_TestUtility.getPriceList(acc,'Spain');
            insert priceList;
            
            Apttus__APTS_Agreement__c agreement = APTS_LP_TestUtility.getAgreement('Test Agr 1');
            agreement.Apttus_CMConfig__PriceListId__c = priceList.Id;
            insert agreement;
            System.debug(agreement.id +'-- id --');
            Test.startTest();
            Test.setCurrentPageReference(new PageReference('Page.APTS_CreateEmptyCartPage'));
            System.currentPageReference().getParameters().put('id', agreement.id);
            System.currentPageReference().getParameters().put('sObject', 'agreement');
            
            APTS_CreateEmptyCartController emptyCartController = new APTS_CreateEmptyCartController();
            
            PageReference pageRef = emptyCartController.goBack();
            System.debug(pageRef.getUrl() + '--> url');
            System.assert(pageRef.getUrl().endsWithIgnoreCase(agreement.id) , true);
        }
    }
    
}