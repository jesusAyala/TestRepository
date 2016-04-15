@isTest
public class APTS_AgreementTriggerTest {
    
    private static Apttus_Config2__PriceList__c testPriceList;
    private static User user;
    private static Account acc ;
    private static Apttus__APTS_Agreement__c agr;
    private static final String QUOTE_RECORD_TYPE = 'LP'; 
    
    static APTS_Capture_LSO_Input_Config_Settings__c oLODConfigSetting = APTS_LP_TestUtility.getLODConfigSetting(); 
    
    
    // Test-Case for Account-Customer && PriceList for Spain Region
    // PriceList should be automated based on Account-Customer 
    public static testMethod void automatePriceListBasedOnCustomerAccount(){
        System.runAs(APTS_LP_TestUtility.getUser()) {
            Test.startTest();
            
            List < APTS_Discounts_Config__c > listDisConfig = APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCommonConfigSetting();
            acc =  APTS_LP_TestUtility.getNewAccount('Test-Account', 'Spain');
            insert acc;
            
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
            
            agr.APTS_LP_Sales_Person__c = UserInfo.getUserId();
            agr.APTS_LP_AccountCustomer__c = acc.id;
            
            update agr;
            Map < Id, Apttus__APTS_Agreement__c > mapAgreement = new Map < Id, Apttus__APTS_Agreement__c >();
            mapAgreement.put(agr.id,agr);
            APTS_AgreementTriggerHelper.automatePriceList(mapAgreement);
            APTS_AgreementTriggerHelper.getDiscountsConfig(listDisConfig,agr);
            Test.stopTest();
        }
    }
    
    // Test-Case for SalesPerson && PriceList for Spain Region
    // PriceList should be automated based on SalesUser
    public static testMethod void automatePriceListBasedOnSalesAccount(){
        System.runAs(APTS_LP_TestUtility.getUser()) {
            test.startTest();
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCommonConfigSetting();
            user =  APTS_LP_TestUtility.getUser('Spain');
            acc =  APTS_LP_TestUtility.getNewAccount('Test-Account', 'Spain');
            insert acc;
            testPriceList = APTS_LP_TestUtility.getPriceList(acc,'Spain');
            insert testPriceList;
            agr = APTS_LP_TestUtility.getAgreement('TestAgreement');
            agr.Apttus_CMConfig__PriceListId__c = testPriceList.Id;//axay
            insert agr;
            agr.APTS_LP_Sales_Person__c = user.id;
            update agr;
            Map < Id, Apttus__APTS_Agreement__c > mapAgreement = new Map < Id, Apttus__APTS_Agreement__c >();
            mapAgreement.put(agr.id,agr);
            APTS_AgreementTriggerHelper.automatePriceList(mapAgreement);
            test.stopTest();
        }
    }
    
    
    // Test method when no priceList is avialable for either Customer-Account and SalesPerson
    public static testMethod void automateAgreementwithNoPriceList(){
        System.runAs(APTS_LP_TestUtility.getUser()) {
            test.startTest();
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCommonConfigSetting();
            user =  APTS_LP_TestUtility.getUser('India');
            acc =  APTS_LP_TestUtility.getNewAccount('Test-Account', 'India');
            insert acc;
            testPriceList = APTS_LP_TestUtility.getPriceList(acc,'Spain');
            insert testPriceList;
            agr = APTS_LP_TestUtility.getAgreement('TestAgreement');
            agr.Apttus_CMConfig__PriceListId__c = testPriceList.Id;//axay
            insert agr;
            agr.APTS_LP_Sales_Person__c = user.id;
            update agr;
            test.stopTest();
        }
    }
    
    
    // Test method when MSPA Record-Type is different than LS-Spain
    public static testMethod void automateAgreementwithPriceList(){
        System.runAs(APTS_LP_TestUtility.getUser()) {
            test.startTest();
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCommonConfigSetting();
            user =  APTS_LP_TestUtility.getUser('India');
            acc =  APTS_LP_TestUtility.getNewAccount('Test-Account', 'India');
            insert acc;
            testPriceList = APTS_LP_TestUtility.getPriceList(acc,'Spain');
            insert testPriceList;
            agr = APTS_LP_TestUtility.getAgreement('TestAgreement');
            agr.Apttus_CMConfig__PriceListId__c = testPriceList.Id;//axay
            insert agr;
            agr.APTS_LP_Sales_Person__c = user.id;
            update agr;
            test.stopTest();
        }
    }
      

    // Test method when Product Configuration Checkbox is Checked while updating records
    public static testMethod void changeProductConfigToTrue(){
        System.runAs(APTS_LP_TestUtility.getUser()) {
            test.startTest();
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCommonConfigSetting();
            APTS_LP_TestUtility.getCustomSetting();
            agr = APTS_LP_TestUtility.getAgreement('TestAgreement');
            insert agr;
            
            agr.APTS_LP_Product_Config__c = TRUE;
            update agr;
            test.stopTest();
        }
    }
    
    // Test method when Product Configuration Checkbox is Checked while updating records
    public static testMethod void testCreateMSPAInSAP(){
        System.runAs(APTS_LP_TestUtility.getUser()) {
            Test.startTest();
            APTS_LP_TestUtility.getDiscountConfig();
            //APTS_LP_TestUtility.getCommonConfigSetting();
            //APTS_LP_TestUtility.getCustomSetting();
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
            APTS_Agreement_SAP_Setting__c sapSetting = new APTS_Agreement_SAP_Setting__c();
            sapSetting.APTS_Country__c = 'Spain';
            sapSetting.APTS_Auto_Create_MSPA_In_SAP_On_Approval__c = FALSE;
            insert sapSetting;
            
            Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
            priceList.APTS_Country__c = 'Spain';
            insert priceList;
            
            Apttus_Proposal__Proposal__c proposal = APTS_LP_TestUtility.getProposal('TestProposal');
            proposal.Apttus_Proposal__Approval_Stage__c = 'Approved';
            insert proposal;
            
            agr = APTS_LP_TestUtility.getAgreement('TestAgreement');
            agr.Apttus_QPComply__RelatedProposalId__c = proposal.Id;
            agr.Apttus_CMConfig__PriceListId__c = priceList.Id;//axay
            insert agr;
            
            agr.Apttus__Status_Category__c = 'In Signatures';
            agr.Apttus__Status__c = 'Ready for Signatures';
            agr.APTS_LP_Sales_Person__c = UserInfo.getUserId();
            update agr;
            
            proposal.Apttus_Proposal__Approval_Stage__c = 'Approved';
            proposal.Apttus_QPConfig__PriceListId__c = priceList.Id;//axay
            update proposal;
            
            agr.Apttus__Status__c = APTS_Constants.STATUS_APPROVED_ACTION_REQ;
            agr.APTS_Integration_Status__c = 'Sent';
            update agr;
            
            test.stopTest();
        }
    }
    
    //Test method when other fields are changed during update
    public static testMethod void changeOtherFields(){
        System.runAs(APTS_LP_TestUtility.getUser()) {
            test.startTest();
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCommonConfigSetting();
            agr = APTS_LP_TestUtility.getAgreement('TestAgreement');       
            insert agr;
            
            agr.APTS_LP_Max_Order_Amount__c = 234;
            agr.APTS_LP_MSPA_title__c = 'Test';
            update agr;
            test.stopTest();
        }
    }
    
    // Added By Kruti Shah for Req# 30
    // Test-Case for Get Available Discounts        
    public static testMethod void getAvailableDiscounts_Test(){
        System.runAs(APTS_LP_TestUtility.getUser()) {
            test.startTest();
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCommonConfigSetting();
            user =  APTS_LP_TestUtility.getUser('Spain');
            acc =  APTS_LP_TestUtility.getNewAccount('Test-Account', 'Spain');
            insert acc;
            
            APTS_Agreement_SAP_Setting__c sapSetting = new APTS_Agreement_SAP_Setting__c();
            sapSetting.APTS_Country__c = 'Spain';
            insert sapSetting;
            
            testPriceList = APTS_LP_TestUtility.getPriceList(acc,'Spain');
            insert testPriceList;
            
            agr = APTS_LP_TestUtility.getAgreement('TestAgreement');
            agr.APTS_LP_AccountCustomer__c = acc.id;
            agr.APTS_Country__c = 'Spain';          
            insert agr;  
            agr.APTS_Hierarchy_level__c = '3';
            update agr;
            
            APTS_Master_PickList_Table__c mpt = new APTS_Master_PickList_Table__c();
            mpt.name = 'BT - AP-Baja Tensi¢n';
            mpt.APTS_Code__c = 'BT';
            mpt.APTS_Code_Description__c = 'AP-Baja Tensi¢n';
            mpt.APTS_Locale__c = 'es_ES';
            mpt.APTS_Code_Used_For__c='Local Channel';
            insert mpt;
            
            //APTS_Discounts_Config__c DiscBackup = APTS_LP_TestUtility.getDiscountsBackup('Test');  
            APTS_Discounts_Config__c DiscBackup = new APTS_Discounts_Config__c();
            //DiscBackup.name = 'Test';
            DiscBackup.APTS_Country__c = 'Spain';
            DiscBackup.APTS_Record_Type__c = 'MSPA';
            DiscBackup.APTS_Local_Channel__c = mpt.id;
            DiscBackup.APTS_Net_Discount__c = true;
            DiscBackup.APTS_Substitute_Discount__c =true;
            DiscBackup.APTS_Additional_Discount__c = true;
            DiscBackup.APTS_Hierarchy_Level__c = '3';
            DiscBackup.APTS_Substitutional_Discounts_Hierarchy__c = true;
            DiscBackup.APTS_Additional_Discounts_Hierarchy__c = true;
            DiscBackup.APTS_Net_Discount_Hierarchy__c = true;
            DiscBackup.APTS_Hierarchy_Level_MS__c = '1,2,3,4';
            DiscBackup.APTS_IsActive__c = True;
            insert DiscBackup;
            
            test.stopTest();
        }
    }
    
    public static testMethod void autoPopulateMSPARefNumber(){
        System.runAs(APTS_LP_TestUtility.getUser()) {
            // Get MSPA Reference Number
            test.startTest();
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCommonConfigSetting();
            APTS_MSPA_Ref_Number__c refNumber801 = APTS_LP_TestUtility.getMSPARefNumber('0000000801');
            insert refNumber801;
            APTS_MSPA_Ref_Number__c refNumber802 = APTS_LP_TestUtility.getMSPARefNumber('0000000802');
            insert refNumber802;
            
            //Get Account 
            acc =  APTS_LP_TestUtility.getNewAccount('Test-Account', 'Spain');
            
            // Get Agreement
            agr = APTS_LP_TestUtility.getAgreement('TestAgreement');
            insert agr;
            
            //Update Agreement
            agr.APTS_LP_AccountCustomer__c = acc.id;
            agr.APTS_SAP_Reference_No__c = '0000000801';
            update agr;
            
            List<Apttus__APTS_Agreement__c> agreement1 = [SELECT APTS_SAP_Reference_No__c FROM Apttus__APTS_Agreement__c WHERE Id =:agr.Id];
            System.debug('MSPA Ref ID: ' + agreement1[0].APTS_SAP_Reference_No__c);
            
            //Positive Test Case : Expected value found.
            System.assertEquals(agreement1[0].APTS_SAP_Reference_No__c, refNumber801.APTS_MSPA_Ref_ID__c);
            
            //Negative Test Case : Expected value not found.
            System.assertNotEquals(agreement1[0].APTS_SAP_Reference_No__c, refNumber802.APTS_MSPA_Ref_ID__c);
            
            delete agr;
            test.stopTest();
        }
    } 
    
    public static testMethod void CreateMSPAInSAPNegative(){
        System.runAs(APTS_LP_TestUtility.getUser()) {
            test.startTest();
            
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCommonConfigSetting();
            acc =  APTS_LP_TestUtility.getNewAccount('Test-Account', 'Spain');
            insert acc;
            
            testPriceList = APTS_LP_TestUtility.getPriceList(acc,'Spain');
            insert testPriceList;
            
            APTS_Agreement_SAP_Setting__c sapSetting = new APTS_Agreement_SAP_Setting__c();
            sapSetting.APTS_Country__c = 'Spain';
            insert sapSetting;
            
            APTS_ProcessorControl.inFutureContext = false;
            
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
            PricingToken.Name = 'PricingToken';
            PricingToken.APTS_Base_Address__c = 'https://abberpgatewaydev.servicebus.windows.net/';
            PricingToken.APTS_Bau_Code__c = 'ES1';
            PricingToken.APTS_Key__c = 'Sd6tRl5wj9ieNgE6q7Q9Y/wkYoD24aqERudvHvB9Ow8=';
            PricingToken.APTS_Key_Name__c = 'FaceServiceBusServices';
            //PricingToken.APTS_End_Point__c = 'https://abberpgatewaydev.servicebus.windows.net/api/products/quotationpricelistsearch';
            PricingToken.APTS_ERP_Response_Culture__c = 'es-ES';
            PricingToken.APTS_Http_Header_Key__c = 'Authorization';
            Insert PricingToken;
            
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
            // agr1.Apttus__Contract_Start_Date__c = System.today();
            // agr1.Apttus__Contract_End_Date__c = System.today(); 
            insert agr1;
            
            APTS_LP_TestUtility.getIntegrationParameters();
            APTS_LP_TestUtility.getSAPIntegrationTokens();
            
            Product2 product2 = APTS_LP_TestUtility.getProduct();
            product2.APTS_LP_Is_Hierarchy__c = false;
            insert product2;
            
            List<Apttus__AgreementLineItem__c> listAgreementLineItem = APTS_LP_TestUtility.getAgreementLineItemList(agr1.id,2);
            
            for(Apttus__AgreementLineItem__c agrLineItem: listAgreementLineItem){
                
                agrLineItem.Apttus_CMConfig__BasePrice__c = 10;
                agrLineItem.Apttus__ProductId__r = product2;
                agrLineItem.Apttus__Quantity__c = 5;
                agrLineItem.APTS_Discount_Type__c = 'Substitute Discount' ;
                
            }
            insert listAgreementLineItem;
            
            agr1.Apttus__Status__c = 'Approved but Action Required';
            update agr1;
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(agr1); 
            APTS_MSPACreatorInSAPController obj = new APTS_MSPACreatorInSAPController(stdController);        
            Test.setMock(HttpCalloutMock.class, new APTPS_CalloutMockTest());
            PageReference ref = obj.CreateMSPAviaButton();
            //END: For CreateMSPAInSAP
            
            test.stopTest();
        }
    }
    
    
    public static testMethod void CreateMSPAInSAP(){
        System.runAs(APTS_LP_TestUtility.getUser()) {
            test.startTest();
            
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCommonConfigSetting();
            acc =  APTS_LP_TestUtility.getNewAccount('Test-Account', 'Spain');
            insert acc;
            
            testPriceList = APTS_LP_TestUtility.getPriceList(acc,'Spain');
            insert testPriceList;
            
            APTS_Agreement_SAP_Setting__c sapSetting = new APTS_Agreement_SAP_Setting__c();
            sapSetting.APTS_Country__c = 'Spain';
            insert sapSetting;
            
            APTS_ProcessorControl.inFutureContext = false;
            
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
            PricingToken.Name = 'PricingToken';
            PricingToken.APTS_Base_Address__c = 'https://abberpgatewaydev.servicebus.windows.net/';
            PricingToken.APTS_Bau_Code__c = 'ES1';
            PricingToken.APTS_Key__c = 'Sd6tRl5wj9ieNgE6q7Q9Y/wkYoD24aqERudvHvB9Ow8=';
            PricingToken.APTS_Key_Name__c = 'FaceServiceBusServices';
            PricingToken.APTS_End_Point__c = 'https://abberpgatewaydev.servicebus.windows.net/api/products/quotationpricelistsearch';
            PricingToken.APTS_ERP_Response_Culture__c = 'es-ES';
            PricingToken.APTS_Http_Header_Key__c = 'Authorization';
            Insert PricingToken;
            
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
            
            Product2 product2 = APTS_LP_TestUtility.getProduct();
            product2.APTS_LP_Is_Hierarchy__c = false;
            insert product2;
            
            List<Apttus__AgreementLineItem__c> listAgreementLineItem = APTS_LP_TestUtility.getAgreementLineItemList(agr1.id,2);
            
            for(Apttus__AgreementLineItem__c agrLineItem: listAgreementLineItem){
                
                agrLineItem.Apttus_CMConfig__BasePrice__c = 10;
                agrLineItem.Apttus__ProductId__r = product2;
                agrLineItem.Apttus__Quantity__c = 5;
                agrLineItem.APTS_Discount_Type__c = 'Substitute Discount' ;
                
            }
            insert listAgreementLineItem;
            
            agr1.Apttus__Status__c = 'Approved but Action Required';
            
            update agr1;
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(agr1); 
            APTS_MSPACreatorInSAPController obj = new APTS_MSPACreatorInSAPController(stdController);        
            Test.setMock(HttpCalloutMock.class, new APTPS_CalloutMockTest());
            PageReference ref = obj.CreateMSPAviaButton();
            //END: For CreateMSPAInSAP
            
            test.stopTest();
            
        }  
    }
    
/*
public static testMethod void testreadOnlyMSPAValidation(){

System.runAs(APTS_LP_TestUtility.getSalesUser()) {

APTS_LP_TestUtility.getDiscountConfig();
                APTS_LP_TestUtility.getCommonConfigSetting();
Apttus__APTS_Agreement__c agreement = APTS_LP_TestUtility.getAgreement('Test Agreement');
agreement.Apttus__Status__c = APTS_Constants.MSPA_STATUS_APPROVED;
agreement.Apttus__Contract_Start_Date__c  = Date.newinstance(2060, 2, 17);
agreement.Apttus__Contract_End_Date__c = Date.newinstance(2062, 2, 17);
test.startTest();
insert agreement;

agreement.Apttus__Contract_Start_Date__c  = Date.newinstance(2070, 3, 12);
agreement.Apttus__Contract_End_Date__c = Date.newinstance(2072, 3, 12);
agreement.Apttus__Status__c = APTS_Constants.MSPA_STATUS_APPROVED;

update agreement;

test.stopTest();

}
}
*/    
}