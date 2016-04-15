@isTest
public class APTS_SAPConnectorForMSPACreationTest {
    private static User user;
    public static Apttus__APTS_Agreement__c agreement;
    static APTS_Capture_LSO_Input_Config_Settings__c oLODConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();
    
    public static void createTestData()
    {        
        
        APTS_LP_TestUtility.getDiscountConfig();
        APTS_LP_TestUtility.getCommonConfigSetting();
        List<APTS_SAP_Integration_Tokens__c> tokenList = new List<APTS_SAP_Integration_Tokens__c>();
        
        APTS_SAP_Integration_Tokens__c SAPMSPACreationTokens = new APTS_SAP_Integration_Tokens__c();
        SAPMSPACreationTokens.Name = 'SAP MSPA Creation Tokens';
        SAPMSPACreationTokens.APTS_Base_Address__c = 'https://abberpgatewaydev.servicebus.windows.net/';
        SAPMSPACreationTokens.APTS_Bau_Code__c = 'ES1';
        SAPMSPACreationTokens.APTS_Key__c = 'Sd6tRl5wj9ieNgE6q7Q9Y/wkYoD24aqERudvHvB9Ow8=';
        SAPMSPACreationTokens.APTS_Key_Name__c = 'FaceServiceBusServices';
        SAPMSPACreationTokens.APTS_End_Point__c = 'https://abberpgatewaydev.servicebus.windows.net/api/products/quotationpricelistsearch';
        SAPMSPACreationTokens.APTS_ERP_Response_Culture__c = 'es-ES';
        SAPMSPACreationTokens.APTS_Http_Header_Key__c = 'Authorization';
        tokenList.add(SAPMSPACreationTokens);
        
        APTS_SAP_Integration_Tokens__c OAuthToken = new APTS_SAP_Integration_Tokens__c();
        OAuthToken.Name = 'SAP oAuth Tokens';
        OauthToken.APTS_Base_Address__c = 'https://abberpgatewaydev.servicebus.windows.net/';
        OauthToken.APTS_Key__c = 'hj7nmmYxSZbtVsyeyqAJ';
        OauthToken.APTS_Http_Header_Key__c = 'Authorization';
        OauthToken.APTS_oAuth_Token__c = 'ErpGateway:nU2+tOVFCK81+/wuuSx61QgOyySMcS9z//go4Lpej6k=';
        OauthToken.APTS_Key_Name__c = 'FaceErpGateway_ServiceBus';
        OauthToken.APTS_End_Point__c = 'https://applications.it.abb.com/abbaccountstest/issue/oauth2/token';
        tokenList.add(OauthToken);
        
        APTS_SAP_Integration_Tokens__c PricingToken = new APTS_SAP_Integration_Tokens__c();
        PricingToken.Name = 'PricingToken';
        PricingToken.APTS_Base_Address__c = 'https://abberpgatewaydev.servicebus.windows.net/';
        PricingToken.APTS_Bau_Code__c = 'ES1';
        PricingToken.APTS_Key__c = 'Sd6tRl5wj9ieNgE6q7Q9Y/wkYoD24aqERudvHvB9Ow8=';
        PricingToken.APTS_Key_Name__c = 'FaceServiceBusServices';
        PricingToken.APTS_End_Point__c = 'https://abberpgatewaydev.servicebus.windows.net/api/products/quotationpricelistsearch';
        PricingToken.APTS_ERP_Response_Culture__c = 'es-ES';
        PricingToken.APTS_Http_Header_Key__c = 'Authorization';
        tokenList.add(PricingToken);
        
        insert tokenList;
        
        Account acc = new Account();
        acc = APTS_LP_TestUtility.getNewAccount('Test Account', 'Spain');
        insert acc;
        
        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c(Apttus_Config2__AccountId__c = acc.id, Name='Test - Price List');
        priceList.APTS_Country__c = 'Spain';
        insert priceList;
        
        List<Apttus__APTS_Agreement__c> agreementList = new List<Apttus__APTS_Agreement__c>();
        
        Apttus__APTS_Agreement__c  agr1 = new Apttus__APTS_Agreement__c();
        agr1 = APTS_LP_TestUtility.getAgreement('TestAgreement');
        agr1.APTS_LP_AccountCustomer__c = acc.id;       
        agr1.APTS_Country__c = 'Spain';          
        agr1.APTS_Integration_Status__c = 'Empty';
        agr1.Apttus__Workflow_Trigger_Created_From_Clone__c = false;
        agr1.Apttus__Status__c = 'Draft';
        agr1.Apttus_CMConfig__PriceListId__c = priceList.Id;
        agreementList.add(agr1);  
        
        agreement = APTS_LP_TestUtility.getAgreement('Test Agreement');
        agreement.Apttus_CMConfig__PriceListId__c = priceList.Id;
        agreement.Apttus__Contract_Start_Date__c = date.today();
        agreement.Apttus__Contract_End_Date__c = date.today()+30;
        agreementList.add(agreement);
        
        insert agreementList;
        
        agr1.Apttus__Status__c = 'Approved but Action Required';
        update agr1;
        
        Product2 testPrd = new Product2();
        testPrd.name = 'Test Prod';
        testPrd.APTS_Country_Code__c = 'EN';
        testPrd.APTS_GTV_Level__c = 'TestGTV';
        testPrd.Description = 'Test Desc';
        testPrd.RecordTypeId = APTS_LP_TestUtility.getRecordId();
        testPrd.IsActive = true;                
        testPrd.APTS_Product_ID__c = '1SAJ230000R1005';
        testPrd.APTS_LP_Is_Hierarchy__c = true;
        insert testPrd;
        
        Apttus_Config2__PriceListItem__c PLI = new Apttus_Config2__PriceListItem__c();
        PLI.Apttus_Config2__PriceListId__c = priceList.Id;
        PLI.Apttus_Config2__Active__c =true;
        PLI.Apttus_Config2__ProductId__c = testPrd.Id;
        insert PLI;
        
        Apttus_Config2__ProductConfiguration__c productConfig = new Apttus_Config2__ProductConfiguration__c();
        productConfig = APTS_LP_TestUtility.getProductConfiguration('TestProductConfiguration');
        productConfig.Apttus_CMConfig__AgreementId__c = agreement.Id;
        Insert productConfig;
        
        List<Apttus_Config2__LineItem__c> listLineItem = new List<Apttus_Config2__LineItem__c>(); 
        
        Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c(); 
        lineItem.Apttus_Config2__Quantity__c = 2;
        lineitem.CurrencyIsoCode = 'EUR';
        lineItem.Apttus_Config2__LineNumber__c = 1;
        lineItem.Apttus_Config2__PrimaryLineNumber__c =1;
        lineItem.Apttus_Config2__ListPrice__c = 0;
        lineItem.Apttus_Config2__ItemSequence__c = 1;
        lineItem.Apttus_Config2__ProductId__c = testprd.id;
        lineitem.Apttus_Config2__PriceListId__c = priceList.Id;
        lineitem.Apttus_Config2__PriceListItemId__c = PLI.Id;
        lineitem.Apttus_Config2__ConfigurationId__c = productConfig.Id;
        listLineItem.add(lineItem);
        
        Apttus_Config2__LineItem__c lineItem2 = new Apttus_Config2__LineItem__c(); 
        lineItem2.Apttus_Config2__Quantity__c = 2;
        lineitem2.CurrencyIsoCode = 'EUR';
        lineItem2.Apttus_Config2__LineNumber__c = 1;
        lineItem2.Apttus_Config2__PrimaryLineNumber__c =1;
        lineItem2.Apttus_Config2__ListPrice__c = 0;
        lineItem2.Apttus_Config2__ItemSequence__c = 2;
        lineItem2.Apttus_Config2__ProductId__c = testprd.id;
        lineitem2.Apttus_Config2__PriceListId__c = priceList.Id;
        lineitem2.Apttus_Config2__PriceListItemId__c = PLI.Id;
        lineitem2.Apttus_Config2__ConfigurationId__c = productConfig.Id;
        listLineItem.add(lineItem2);
        
        insert listLineItem;
        listLineItem = APTS_LP_TestUtility.getLineItemListWithDiscount(productConfig.Id, 2, testPrd, 0);
        
        List<Apttus__AgreementLineItem__c> agrLineItemList = new List<Apttus__AgreementLineItem__c>();
        
        Apttus__AgreementLineItem__c AgreeLineItem = new Apttus__AgreementLineItem__c();
        AgreeLineItem.Apttus__AgreementId__c = agreement.Id;
        AgreeLineItem.Apttus_CMConfig__DerivedFromId__c = lineItem.Id;
        AgreeLineItem.Apttus__Quantity__c = 2;
        AgreeLineItem.Apttus_CMConfig__BasePrice__c=200;     
        AgreeLineItem.APTS_Discount_Type__c = 'Additional Discount';              
        AgreeLineItem.APTS_Discount_Percentage__c = 10;        
        agrLineItemList.add(AgreeLineItem);
        
        Apttus__AgreementLineItem__c AgreeLineItem2 = new Apttus__AgreementLineItem__c();
        AgreeLineItem2.Apttus__AgreementId__c = agreement.Id;
        AgreeLineItem2.Apttus_CMConfig__DerivedFromId__c = lineItem2.Id;
        AgreeLineItem2.Apttus__Quantity__c = 2;
        AgreeLineItem2.Apttus_CMConfig__BasePrice__c=200;
        AgreeLineItem2.APTS_Discount_Type__c = 'Substitute Discount';              
        AgreeLineItem2.APTS_Discount_Percentage__c = 10;        
        agrLineItemList.add(AgreeLineItem2);
        
        Apttus__AgreementLineItem__c AgreeLineItem3 = new Apttus__AgreementLineItem__c();
        AgreeLineItem3.Apttus__AgreementId__c = agreement.Id;
        AgreeLineItem3.Apttus_CMConfig__DerivedFromId__c = lineItem2.Id;
        AgreeLineItem3.Apttus__Quantity__c = 2;
        AgreeLineItem3.Apttus_CMConfig__BasePrice__c=200;
        AgreeLineItem3.APTS_Discount_Type__c = 'Net Price Discount';              
        AgreeLineItem3.APTS_Discount_Percentage__c = 10;        
        agrLineItemList.add(AgreeLineItem3);
        
        insert agrLineItemList;
    }
    public static testMethod void SAPConnectorForMSPACreation() 
    {
        User usr = APTS_LP_TestUtility.getUser();
        System.runAs(usr) {
            Test.startTest();
            createTestData();
            ApexPages.StandardController stdController = new ApexPages.StandardController(agreement);
            APTS_SAPConnectorForMSPACreation obj = new APTS_SAPConnectorForMSPACreation(stdController);
            Test.setMock(HttpCalloutMock.class, new APTPS_CalloutMockTest());
            PageReference ref = obj.CreateMSPAviaButton();
            Test.stopTest();
        }
    }
    
    public static testMethod void testCreateMSPA() 
    {
        User usr = APTS_LP_TestUtility.getUser();
        System.runAs(usr) {
            Test.startTest();
                createTestData();
            	Set<Id> agrIds = new Set<Id>();
            	agrIds.add(agreement.Id);
				APTS_SAPConnectorForMSPACreation.CreateMSPA(agrIds,'True');
            Test.stopTest();
        }
    }
}