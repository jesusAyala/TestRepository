@isTest
public class APTS_MSPACreatorInSAPControllerTest {

    private static Apttus_Config2__PriceList__c testPriceList;
    private static User user;
    private static Account acc ;
    private static Apttus__APTS_Agreement__c agr;
    private static final String QUOTE_RECORD_TYPE = 'LP'; 

    public static testMethod void APTS_MSPACreatorInSAPControllerTest1() {
    
        Test.startTest();
            
        List < APTS_Discounts_Config__c > listDisConfig = APTS_LP_TestUtility.getDiscountConfig();
        APTS_LP_TestUtility.getCommonConfigSetting();
        acc =  APTS_LP_TestUtility.getNewAccount('Test-Account', 'Spain');
        insert acc;
        
        Product2 product2 = APTS_LP_TestUtility.getProduct();
        product2.APTS_LP_Is_Hierarchy__c = false;
        insert product2;
        
        Opportunity opp = APTS_LP_TestUtility.getOpportunity('Test Oppty');
        insert opp;
        
        Partner part = APTS_LP_TestUtility.getPartner(opp.Id, acc.Id);
        insert part;
        
        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
        priceList.APTS_Country__c = 'Spain';
        insert priceList;
        
        agr = APTS_LP_TestUtility.getAgreement('TestAgreement');
        agr.Apttus__Related_Opportunity__c = opp.Id;
        insert agr;
        
        Apttus__AgreementLineItem__c objAgreementLineItem = APTS_LP_TestUtility.getAgreementLineItem(agr.ID);
        objAgreementLineItem.Apttus_CMConfig__BasePrice__c = 10;
        objAgreementLineItem.Apttus__ProductId__r = product2;
        objAgreementLineItem.Apttus__Quantity__c = 5;
        objAgreementLineItem.APTS_Discount_Type__c = 'Substitute Discount' ;
        insert objAgreementLineItem;
        
        Set<Id> AggrementIds = new Set<Id>();
        AggrementIds.add(agr.ID);
        
        APTS_Agreement_SAP_Setting__c sapSetting = new APTS_Agreement_SAP_Setting__c();
        sapSetting.APTS_Country__c = agr.APTS_Country__c;
        insert sapSetting;
        
        APTS_LP_TestUtility.getIntegrationParameters();
        
        agr.Apttus__Status__c = 'Approved but Action Required';
        update agr;
        
        Boolean BlockParam = True;
    
        Apexpages.currentpage().getparameters().put('BlockParam','BlockParam');
 
        ApexPages.StandardController sc = new ApexPages.StandardController(agr);
        APTS_MSPACreatorInSAPController objAPTS_MSPACreatorInSAPController = new APTS_MSPACreatorInSAPController(sc);
        objAPTS_MSPACreatorInSAPController.backToMSPA();
        objAPTS_MSPACreatorInSAPController.createMSPAviaButton();
       // APTS_MSPACreatorInSAPController.createOrBlockMSPA(AggrementIds,'True');
        APTS_MSPACreatorInSAPController.createMSPA(AggrementIds,'True');
        
        Test.stopTest();
    
    }
    
    public static testMethod void APTS_MSPACreatorInSAPControllerTestBlockMSPA() {
    
        Test.startTest();
            
        List < APTS_Discounts_Config__c > listDisConfig = APTS_LP_TestUtility.getDiscountConfig();
        APTS_LP_TestUtility.getCommonConfigSetting();
        acc =  APTS_LP_TestUtility.getNewAccount('Test-Account', 'Spain');
        insert acc;
        
        Product2 product2 = APTS_LP_TestUtility.getProduct();
        product2.APTS_LP_Is_Hierarchy__c = false;
        insert product2;
        
        Opportunity opp = APTS_LP_TestUtility.getOpportunity('Test Oppty');
        insert opp;
        
        Partner part = APTS_LP_TestUtility.getPartner(opp.Id, acc.Id);
        insert part;
        
        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
        priceList.APTS_Country__c = 'Spain';
        insert priceList;
        
        agr = APTS_LP_TestUtility.getAgreement('TestAgreement');
        agr.Apttus__Related_Opportunity__c = opp.Id;
        insert agr;
        
        Apttus__AgreementLineItem__c objAgreementLineItem = APTS_LP_TestUtility.getAgreementLineItem(agr.ID);
        objAgreementLineItem.Apttus_CMConfig__BasePrice__c = 10;
        objAgreementLineItem.Apttus__ProductId__r = product2;
        objAgreementLineItem.Apttus__Quantity__c = 5;
        objAgreementLineItem.APTS_Discount_Type__c = 'Substitute Discount' ;
        insert objAgreementLineItem;
        
        Set<Id> AggrementIds = new Set<Id>();
        AggrementIds.add(agr.ID);
        
        APTS_Agreement_SAP_Setting__c sapSetting = new APTS_Agreement_SAP_Setting__c();
        sapSetting.APTS_Country__c = agr.APTS_Country__c;
        insert sapSetting;
        
        APTS_LP_TestUtility.getIntegrationParameters();
        
        agr.Apttus__Status__c = 'Approved but Action Required';
        update agr;
        
        Boolean BlockParam = True;
    
        Apexpages.currentpage().getparameters().put('BlockParam','BlockParam');
 
        ApexPages.StandardController sc = new ApexPages.StandardController(agr);
        APTS_MSPACreatorInSAPController objAPTS_MSPACreatorInSAPController = new APTS_MSPACreatorInSAPController(sc);
        APTS_MSPACreatorInSAPController.createOrBlockMSPA(AggrementIds,'True');
        
        Test.stopTest();
    
    }
    
    
    public static testMethod void APTS_MSPACreatorInSAPControllerTest3() {
            
        APTS_LP_TestUtility.getDiscountConfig();
        APTS_LP_TestUtility.getCommonConfigSetting();
        acc =  APTS_LP_TestUtility.getNewAccount('Test-Account', 'Spain');
        insert acc;
        
        testPriceList = APTS_LP_TestUtility.getPriceList(acc,'Spain');
        insert testPriceList;
        
        Opportunity opp = APTS_LP_TestUtility.getOpportunity('Test Oppty');
        insert opp;
        
        APTS_Agreement_SAP_Setting__c sapSetting = new APTS_Agreement_SAP_Setting__c();
        sapSetting.APTS_Country__c = 'Spain';
        insert sapSetting;
        
        APTS_ProcessorControl.inFutureContext = false;
        
        APTS_LP_TestUtility.getIntegrationParameters();
        
        agr = APTS_LP_TestUtility.getAgreement('TestAgreement');
        agr.Apttus__Related_Opportunity__c = opp.Id;
        insert agr;
        
        Set<Id> AggrementIds = new Set<Id>();
        AggrementIds.add(agr.ID);
        
        APTS_LP_TestUtility.getIntegrationParameters();
        APTS_LP_TestUtility.getSAPIntegrationTokens();
        
        Product2 product2 = APTS_LP_TestUtility.getProduct();
        product2.APTS_LP_Is_Hierarchy__c = false;
        insert product2;
        
        List<Apttus__AgreementLineItem__c> listAgreementLineItem = APTS_LP_TestUtility.getAgreementLineItemList(agr.id,2);
        
        for(Apttus__AgreementLineItem__c agrLineItem: listAgreementLineItem){
            
            agrLineItem.Apttus_CMConfig__BasePrice__c = 10;
            agrLineItem.Apttus__ProductId__r = product2;
            agrLineItem.Apttus__Quantity__c = 5;
            agrLineItem.APTS_Discount_Type__c = 'Substitute Discount' ;
            
        }
        insert listAgreementLineItem;
        
        agr.Apttus__Status__c = 'Approved but Action Required';
        
        update agr;
        
        Test.setMock(HttpCalloutMock.class, new APTPS_SAPCalloutMockTest());
        
        test.startTest();
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(agr); 
        APTS_MSPACreatorInSAPController obj = new APTS_MSPACreatorInSAPController(stdController);        
        APTS_MSPACreatorInSAPController.createOrBlockMSPA(AggrementIds,'True');
        
        test.stopTest();
           
    }
    
    public static testMethod void APTS_MSPACreatorInSAPControllerTest2() {
    
        Test.startTest();
            
        List < APTS_Discounts_Config__c > listDisConfig = APTS_LP_TestUtility.getDiscountConfig();
        APTS_LP_TestUtility.getCommonConfigSetting();
        acc =  APTS_LP_TestUtility.getNewAccount('Test-Account', 'Spain');
        insert acc;
        
        Product2 product2 = APTS_LP_TestUtility.getProduct();
        product2.APTS_LP_Is_Hierarchy__c = false;
        insert product2;
        
        Opportunity opp = APTS_LP_TestUtility.getOpportunity('Test Oppty');
        insert opp;
        
        Partner part = APTS_LP_TestUtility.getPartner(opp.Id, acc.Id);
        insert part;
        
        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
        priceList.APTS_Country__c = 'Spain';
        insert priceList;
        
        agr = APTS_LP_TestUtility.getAgreement('TestAgreement');
        agr.Apttus__Related_Opportunity__c = opp.Id;
        insert agr;
        
        Apttus__AgreementLineItem__c objAgreementLineItem = APTS_LP_TestUtility.getAgreementLineItem(agr.ID);
        objAgreementLineItem.Apttus_CMConfig__BasePrice__c = 10;
        objAgreementLineItem.Apttus__ProductId__r = product2;
        objAgreementLineItem.Apttus__Quantity__c = 5;
        objAgreementLineItem.APTS_Discount_Type__c = 'Substitute Discount' ;
        insert objAgreementLineItem;
        
        Set<Id> AggrementIds = new Set<Id>();
        AggrementIds.add(agr.ID);
        
        APTS_Agreement_SAP_Setting__c sapSetting = new APTS_Agreement_SAP_Setting__c();
        sapSetting.APTS_Country__c = agr.APTS_Country__c;
        insert sapSetting;
        
        APTS_LP_TestUtility.getIntegrationParameters();
        
        Boolean BlockParam = True;
    
        Apexpages.currentpage().getparameters().put('BlockParam','BlockParam');

        ApexPages.StandardController sc = new ApexPages.StandardController(agr);
        APTS_MSPACreatorInSAPController objAPTS_MSPACreatorInSAPController = new APTS_MSPACreatorInSAPController(sc);
        APTS_MSPACreatorInSAPController.createMSPA(AggrementIds,'True');
        
        Test.stopTest();
    
    }
    

}