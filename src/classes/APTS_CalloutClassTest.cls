@isTest
public class APTS_CalloutClassTest {
    
    private static User user;
    private static Apttus__APTS_Agreement__c agreement;
    private static List<Apttus_Config2__LineItem__c> listLineItem;
    private static Apttus_Config2__ProductConfiguration__c productConfig;
    private static Apttus_Config2__ProductConfiguration__c productConfig1;
    private static APTS_Capture_LSO_Input_Config_Settings__c lodConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();
     
    
    private static testMethod void createTestData()
    {
          // Test-Case with System-Admin User
        user  = APTS_LP_TestUtility.getUser();
         System.runAs(user) {
        APTS_LP_TestUtility.getDiscountConfig(); 
        APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
        APTS_SAP_Integration_Tokens__c SAPMSPACreationTokens = new APTS_SAP_Integration_Tokens__c();
        SAPMSPACreationTokens.Name = 'SAP MSPA Creation Tokens';
        SAPMSPACreationTokens.APTS_Base_Address__c = 'https://abberpgatewaydev.servicebus.windows.net/';
        SAPMSPACreationTokens.APTS_Bau_Code__c = 'ES1';
        SAPMSPACreationTokens.APTS_Key__c = 'Sd6tRl5wj9ieNgE6q7Q9Y/wkYoD24aqERudvHvB9Ow8=';
        SAPMSPACreationTokens.APTS_Key_Name__c = 'FaceServiceBusServices';
        SAPMSPACreationTokens.APTS_End_Point__c = 'https://abberpgatewaydev.servicebus.windows.net/api/products/quotationpricelistsearch';
        SAPMSPACreationTokens.APTS_ERP_Response_Culture__c = 'es-ES';
        SAPMSPACreationTokens.APTS_Http_Header_Key__c = 'Authorization';
        Insert SAPMSPACreationTokens;
        
        APTS_SAP_Integration_Tokens__c OAuthToken = new APTS_SAP_Integration_Tokens__c();
        OAuthToken.Name = 'SAP oAuth Tokens';
        OauthToken.APTS_Base_Address__c = 'https://abberpgatewaydev.servicebus.windows.net/';
        OauthToken.APTS_Key__c = 'hj7nmmYxSZbtVsyeyqAJ';
        OauthToken.APTS_Http_Header_Key__c = 'Authorization';
        OauthToken.APTS_oAuth_Token__c = 'ErpGateway:nU2+tOVFCK81+/wuuSx61QgOyySMcS9z//go4Lpej6k=';
        OauthToken.APTS_Key_Name__c = 'FaceErpGateway_ServiceBus';
        OauthToken.APTS_End_Point__c = 'https://applications.it.abb.com/abbaccountstest/issue/oauth2/token';
        insert OauthToken;
        
        APTS_SAP_Integration_Tokens__c PricingToken = new APTS_SAP_Integration_Tokens__c();
        PricingToken.Name = 'SAP Pricing Tokens';
        PricingToken.APTS_Base_Address__c = 'https://abberpgatewaydev.servicebus.windows.net/';
        PricingToken.APTS_Bau_Code__c = 'ES1';
        PricingToken.APTS_Key__c = 'Sd6tRl5wj9ieNgE6q7Q9Y/wkYoD24aqERudvHvB9Ow8=';
        PricingToken.APTS_Key_Name__c = 'FaceServiceBusServices';
        PricingToken.APTS_End_Point__c = 'https://abberpgatewaydev.servicebus.windows.net/api/products/quotationpricelistsearch';
        PricingToken.APTS_ERP_Response_Culture__c = 'es-ES';
        PricingToken.APTS_Http_Header_Key__c = 'Authorization';
        Insert PricingToken;
        
        Account acc = new Account();
        acc = APTS_LP_TestUtility.getNewAccount('Test Account', 'Spain');
        insert acc;

        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c(Apttus_Config2__AccountId__c = acc.id
        ,Name='Test - Price List');
        priceList.APTS_Country__c = 'Spain';
        insert priceList;

        Pricebook2 stdPricebook = new Pricebook2(Id = Test.getStandardPricebookId());
        upsert stdPricebook;

        Product2 testPrd = new Product2();
        testPrd.name = 'Test Prod';
        testPrd.APTS_Country_Code__c = 'EN';
        testPrd.APTS_GTV_Level__c = 'TestGTV';
        testPrd.Description = 'Test Desc';
        testPrd.RecordTypeId = APTS_LP_TestUtility.getRecordId();
        testPrd.IsActive = true;                
        testPrd.APTS_Product_ID__c = '1SAJ230000R1005';
        testPrd.APTS_LP_Is_Hierarchy__c = true;
        testPrd.APTS_Hierarchy_Level__c=3;
        insert testPrd;
        
        Product2 testPrd1 = new Product2();
        testPrd1.name = 'Test Prod';
        testPrd1.APTS_Country_Code__c = 'EN';
        testPrd1.APTS_GTV_Level__c = 'TestGTV';
        testPrd1.Description = 'Test Desc';
        testPrd1.RecordTypeId = APTS_LP_TestUtility.getRecordId();
        testPrd1.IsActive = true;                
        testPrd1.APTS_Product_ID__c = '1SAJ230000R1005';
        insert testPrd1;

        Apttus_Config2__PriceListItem__c PLI = new Apttus_Config2__PriceListItem__c();
        PLI.Apttus_Config2__PriceListId__c = priceList.Id;
        PLI.Apttus_Config2__Active__c =true;
        PLI.Apttus_Config2__ProductId__c = testPrd.Id;
        insert PLI;
        
            Apttus_Config2__PriceListItem__c PLI1 = new Apttus_Config2__PriceListItem__c();
        PLI1.Apttus_Config2__PriceListId__c = priceList.Id;
        PLI1.Apttus_Config2__Active__c =true;
        PLI1.Apttus_Config2__ProductId__c = testPrd1.Id;
        insert PLI1;
        
        agreement = APTS_LP_TestUtility.getAgreement('Test Agreement');
        agreement.Apttus_CMConfig__PriceListId__c = priceList.Id;
        insert agreement;
        
        Apttus_Proposal__Proposal__c proposal = APTS_LP_TestUtility.getProposal('Test-Proposal');
        proposal.APTS_SAP_Customer_ID__c = null;
        insert proposal;
        productConfig = new Apttus_Config2__ProductConfiguration__c();
        productConfig = APTS_LP_TestUtility.getProductConfiguration('TestProductConfiguration');
        productConfig.Apttus_CMConfig__AgreementId__c = agreement.Id;
        productConfig.Apttus_QPConfig__Proposald__c = proposal.id;
        Insert productConfig;
        productConfig1 = new Apttus_Config2__ProductConfiguration__c();
        productConfig1 = APTS_LP_TestUtility.getProductConfiguration('TestProductConfiguration');
        productConfig1.Apttus_CMConfig__AgreementId__c = agreement.Id;
//      productConfig1.Apttus_QPConfig__Proposald__c = proposal.id;
        Insert productConfig1;

        Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c(); 
        lineItem.Apttus_Config2__Quantity__c = 200;
        lineitem.CurrencyIsoCode = 'EUR';
        lineItem.Apttus_Config2__LineNumber__c = 1;
        lineItem.Apttus_Config2__PrimaryLineNumber__c =1;
        lineItem.Apttus_Config2__ListPrice__c = 0;
        lineItem.Apttus_Config2__ItemSequence__c = 1;
        lineItem.Apttus_Config2__ProductId__c = testPrd.id;
        lineitem.Apttus_Config2__PriceListId__c = priceList.Id;
        lineitem.Apttus_Config2__PriceListItemId__c = PLI.Id;
        lineitem.Apttus_Config2__ConfigurationId__c = productConfig.Id;
        
        Apttus_Config2__LineItem__c lineItem1 = new Apttus_Config2__LineItem__c(); 
        lineItem1.Apttus_Config2__Quantity__c = 200;
        lineItem1.CurrencyIsoCode = 'EUR';
        lineItem1.Apttus_Config2__LineNumber__c = 2;
        lineItem1.Apttus_Config2__PrimaryLineNumber__c =2;
        lineItem1.Apttus_Config2__ListPrice__c = 900;
        lineItem1.Apttus_Config2__ItemSequence__c = 1;
        lineItem1.Apttus_Config2__ProductId__c = testPrd1.id;
        lineItem1.Apttus_Config2__PriceListId__c = priceList.Id;
        lineItem1.Apttus_Config2__PriceListItemId__c = PLI1.Id;
        lineItem1.Apttus_Config2__ConfigurationId__c = productConfig.Id;
        listLineItem = new List<Apttus_Config2__LineItem__c>(); 
        listLineItem.add(lineitem);
        listLineItem.add(lineitem1);
        insert listLineItem;       

        Apttus__AgreementLineItem__c AgreeLineItem = new Apttus__AgreementLineItem__c();
        AgreeLineItem.Apttus__AgreementId__c = agreement.Id;
        AgreeLineItem.Apttus_CMConfig__DerivedFromId__c = lineItem.Id;
        AgreeLineItem.Apttus_CMConfig__BasePrice__c=200;
        insert AgreeLineItem;
        
        APTS_Hierarchy_Pricing_Properties__c HierarchyPricingDataset=new APTS_Hierarchy_Pricing_Properties__c();
        HierarchyPricingDataset.APTS_Hierarchy_Pricing_ON__c = true;
        HierarchyPricingDataset.Name = 'Hierarchy Pricing Properties';
        insert HierarchyPricingDataset;
    }
    
}
    private static testMethod void SAPConnectorForMSPACreation() 
    {
          // Test-Case with System-Admin User
        user  = APTS_LP_TestUtility.getUser();
         System.runAs(user) {
        createTestData();
        test.startTest();
        APTS_LP_TestUtility.getCommonConfigSetting();
        Test.setMock(HttpCalloutMock.class, new APTS_MockHttpResponseGeneratorTest());
        String RefURL = ApexPages.currentPage().getHeaders().get('Referer');
        String ConfigRequestId = ApexPages.currentPage().getParameters().get('configRequestId');
        PageReference tpageRef = Page.APTS_SAPPricingIntegration;
        tpageRef.getParameters().put('id', productConfig.id);
        tpageRef.getParameters().put('Referer', RefURL);
        tpageRef.getParameters().put('configRequestId', ConfigRequestId);
        test.setCurrentPage(tpageRef);
        APTS_SAPPricingIntegrationController obj1 = new APTS_SAPPricingIntegrationController();
        System.debug('kushal'+productConfig.Id);
        obj1.init();
        obj1.BacktoCart();
        tpageRef.getParameters().put('id', productConfig.id);
        tpageRef.getParameters().put('Referer', RefURL);
        tpageRef.getParameters().put('configRequestId', ConfigRequestId);
        test.setCurrentPage(tpageRef);
        obj1.init();
        obj1.BacktoCart();
        APTS_SAPPricingIntegrationController.Product p =new APTS_SAPPricingIntegrationController.Product();
        p.ABBCode = 'sdf';
        p.UnitTransferPrice =90;
        p.Quantity =90;
        p.PricePurchaseOrder =90;
        p.PricingUnit ='90';
        p.ItemNumber =90;
        p.MinQuantity =90;
        p.DeliveryTime =90;
        p.CurrencyPurchaseOrder =90;
        p.Parent =90;
        p.Percentage1 =90;
        p.Percentage10 =90;
        p.Percentage2 =90;
        p.Percentage3 =90;
        p.Percentage4 =90;
        p.Percentage5 =90;
        p.Percentage6 =90;
        p.Percentage7 =90;
        p.Percentage8 =90;
        p.Percentage9 =90;
        p.Price1 =90;
        p.Price =90;
        p.Price10 =90;
        p.Price2 =90;
        p.Price3 =90;
        p.Price4 =90;
        p.Price5 =90;
        p.Price6 =90;
        p.Price7 =90;
        p.Price8 =90;
        p.Price9 =90;
        p.Code ='ds';
        p.CustomerCode ='ds';
        p.Description ='ds';
        p.EANCode ='ds';
        p.Hierarchy ='ds';
        p.HierarchyString ='ds';
        p.OldCode ='ds';
        p.PKWiUCode ='ds';
        p.PriceListCode ='ds';
        p.PricingUom ='ds';
        p.SpaNumber ='ds';
        p.UnitOfMeasure ='ds';
        APTS_SAPPricingIntegrationController.ExtraInfo info = new APTS_SAPPricingIntegrationController.ExtraInfo();
        info.Code = 'code';
        info.Message = 'msg';
        List<APTS_SAPPricingIntegrationController.ExtraInfo> inf = new List<APTS_SAPPricingIntegrationController.ExtraInfo>();
        inf.add(info);
        APTS_SAPPricingIntegrationController.Error err = new APTS_SAPPricingIntegrationController.Error();
        err.Code = 'test';
        err.ExtraInfos = inf;
        err.Message ='msg';
        test.stopTest();
    }
 }    
  /*  private static testMethod void SAPConnectorForMSPACreation1() 
    {
        
            APTS_SAP_Integration_Tokens__c SAPMSPACreationTokens = new APTS_SAP_Integration_Tokens__c();
        SAPMSPACreationTokens.Name = 'SAP MSPA Creation Tokens';
        SAPMSPACreationTokens.APTS_Base_Address__c = 'https://abberpgatewaydev.servicebus.windows.net/';
        SAPMSPACreationTokens.APTS_Bau_Code__c = 'ES1';
        SAPMSPACreationTokens.APTS_Key__c = 'Sd6tRl5wj9ieNgE6q7Q9Y/wkYoD24aqERudvHvB9Ow8=';
        SAPMSPACreationTokens.APTS_Key_Name__c = 'FaceServiceBusServices';
        SAPMSPACreationTokens.APTS_End_Point__c = 'https://abberpgatewaydev.servicebus.windows.net/api/products/quotationpricelistsearch';
        SAPMSPACreationTokens.APTS_ERP_Response_Culture__c = 'es-ES';
        SAPMSPACreationTokens.APTS_Http_Header_Key__c = 'Authorization';
        Insert SAPMSPACreationTokens;
        
        APTS_SAP_Integration_Tokens__c OAuthToken = new APTS_SAP_Integration_Tokens__c();
        OAuthToken.Name = 'SAP oAuth Tokens';
        OauthToken.APTS_Base_Address__c = 'https://abberpgatewaydev.servicebus.windows.net/';
        OauthToken.APTS_Key__c = 'hj7nmmYxSZbtVsyeyqAJ';
        OauthToken.APTS_Http_Header_Key__c = 'Authorization';
        OauthToken.APTS_oAuth_Token__c = 'ErpGateway:nU2+tOVFCK81+/wuuSx61QgOyySMcS9z//go4Lpej6k=';
        OauthToken.APTS_Key_Name__c = 'FaceErpGateway_ServiceBus';
        OauthToken.APTS_End_Point__c = 'https://applications.it.abb.com/abbaccountstest/issue/oauth2/token';
        insert OauthToken;
        
        APTS_SAP_Integration_Tokens__c PricingToken = new APTS_SAP_Integration_Tokens__c();
        PricingToken.Name = 'SAP Pricing Tokens';
        PricingToken.APTS_Base_Address__c = 'https://abberpgatewaydev.servicebus.windows.net/';
        PricingToken.APTS_Bau_Code__c = 'ES1';
        PricingToken.APTS_Key__c = 'Sd6tRl5wj9ieNgE6q7Q9Y/wkYoD24aqERudvHvB9Ow8=';
        PricingToken.APTS_Key_Name__c = 'FaceServiceBusServices';
        PricingToken.APTS_End_Point__c = 'https://abberpgatewaydev.servicebus.windows.net/api/products/quotationpricelistse';//'https://abberpgatewaydev.servicebus.windows.net/api/products/quotationpricelistsearch';
        PricingToken.APTS_ERP_Response_Culture__c = 'es-ES';
        PricingToken.APTS_Http_Header_Key__c = 'Authorization';
        Insert PricingToken;
        
        Account acc = new Account();
        acc = APTS_LP_TestUtility.getNewAccount('Test Account', 'Spain');
        insert acc;

        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c(Apttus_Config2__AccountId__c = acc.id
        ,Name='Test - Price List');
        priceList.APTS_Country__c = 'Spain';
        insert priceList;

        Product2 testPrd = new Product2();
        testPrd.name = 'Test Prod';
        testPrd.APTS_Country_Code__c = 'EN';
        testPrd.APTS_GTV_Level__c = 'TestGTV';
        testPrd.Description = 'Test Desc';
        testPrd.RecordTypeId = APTS_LP_TestUtility.getRecordId();
        testPrd.IsActive = true;                
        testPrd.APTS_Product_ID__c = '1SAJ230000R1005';
        insert testPrd;
        
        Product2 testPrd1 = new Product2();
        testPrd1.name = 'Test Prod';
        testPrd1.APTS_Country_Code__c = 'EN';
        testPrd1.APTS_GTV_Level__c = 'TestGTV';
        testPrd1.Description = 'Test Desc';
        testPrd1.RecordTypeId = APTS_LP_TestUtility.getRecordId();
        testPrd1.IsActive = true;                
        testPrd1.APTS_Product_ID__c = '1SAJ230000R1005';
        insert testPrd1;

        Apttus_Config2__PriceListItem__c PLI = new Apttus_Config2__PriceListItem__c();
        PLI.Apttus_Config2__PriceListId__c = priceList.Id;
        PLI.Apttus_Config2__Active__c =true;
        PLI.Apttus_Config2__ProductId__c = testPrd.Id;
        insert PLI;
        
            Apttus_Config2__PriceListItem__c PLI1 = new Apttus_Config2__PriceListItem__c();
        PLI1.Apttus_Config2__PriceListId__c = priceList.Id;
        PLI1.Apttus_Config2__Active__c =true;
        PLI1.Apttus_Config2__ProductId__c = testPrd1.Id;
        insert PLI1;

        agreement = new Apttus__APTS_Agreement__c();
        agreement.Name = 'Test Agreement';
        agreement.APTS_Country__c = 'Spain';
        agreement.APTS_LP_MSPA_title__c = 'Test Title';
        agreement.APTS_LP_Sales_Organization__c = 'ABB';
        agreement.Apttus__Status__c = 'Draft';
        agreement.Apttus_CMConfig__PriceListId__c = priceList.Id;
        insert agreement;

        productConfig = new Apttus_Config2__ProductConfiguration__c();
        productConfig = APTS_LP_TestUtility.getProductConfiguration('TestProductConfiguration');
        productConfig.Apttus_CMConfig__AgreementId__c = agreement.Id;
        Insert productConfig;

        Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c(); 
        lineItem.Apttus_Config2__Quantity__c = 200;
        lineitem.CurrencyIsoCode = 'EUR';
        lineItem.Apttus_Config2__LineNumber__c = 0;
        lineItem.Apttus_Config2__PrimaryLineNumber__c =0;
        lineItem.Apttus_Config2__ListPrice__c = 0;
        lineItem.Apttus_Config2__ItemSequence__c = 1;
        lineItem.Apttus_Config2__ProductId__c = testprd.id;
        lineitem.Apttus_Config2__PriceListId__c = priceList.Id;
        lineitem.Apttus_Config2__PriceListItemId__c = PLI.Id;
        lineitem.Apttus_Config2__ConfigurationId__c = productConfig.Id;
        
        Apttus_Config2__LineItem__c lineItem1 = new Apttus_Config2__LineItem__c(); 
        lineItem1.Apttus_Config2__Quantity__c = 200;
        lineItem1.CurrencyIsoCode = 'EUR';
        lineItem1.Apttus_Config2__LineNumber__c = 2;
        lineItem1.Apttus_Config2__PrimaryLineNumber__c =2;
        lineItem1.Apttus_Config2__ListPrice__c = 900;
        lineItem1.Apttus_Config2__ItemSequence__c = 1;
        lineItem1.Apttus_Config2__ProductId__c = testprd1.id;
        lineItem1.Apttus_Config2__PriceListId__c = priceList.Id;
        lineItem1.Apttus_Config2__PriceListItemId__c = PLI1.Id;
        lineItem1.Apttus_Config2__ConfigurationId__c = productConfig.Id;
        listLineItem = new List<Apttus_Config2__LineItem__c>();  
        listLineItem.add(lineitem);
        listLineItem.add(lineitem1);
        insert listLineItem;       

        Apttus__AgreementLineItem__c AgreeLineItem = new Apttus__AgreementLineItem__c();
        AgreeLineItem.Apttus__AgreementId__c = agreement.Id;
        AgreeLineItem.Apttus_CMConfig__DerivedFromId__c = lineItem.Id;
        AgreeLineItem.Apttus_CMConfig__BasePrice__c=200;
        insert AgreeLineItem;
        
        APTS_Hierarchy_Pricing_Properties__c HierarchyPricingDataset=new APTS_Hierarchy_Pricing_Properties__c();
        HierarchyPricingDataset.APTS_Hierarchy_Pricing_ON__c = true;
        HierarchyPricingDataset.Name = 'Hierarchy Pricing Properties';
        insert HierarchyPricingDataset;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new APTS_MockHttpResponseGenerator());
        PageReference tpageRef = Page.APTS_SAPPricingIntegration;
        tpageRef.getParameters().put('id', productConfig.id);
        test.setCurrentPage(tpageRef);
        APTS_SAPPricingIntegrationController obj1 = new APTS_SAPPricingIntegrationController();
        System.debug('kushal'+productConfig.Id);
        obj1.init();
        test.stopTest();
    }
   */
}