/*************************************************************
@Name: APTS_BulkUploadProductsControllerTest
@Author: Tirth Mathuria
@CreateDate: 17th Nov 2015
@Description: This class is to test the APTS_BulkUploadProductsController
@UsedBy: NA
******************************************************************/
@isTest(SeeAllData=false)
private class APTS_BulkUploadProductsControllerTest {
    
    private static User user;
    private static APTS_Capture_LSO_Input_Config_Settings__c lodConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();

    private static testMethod void testProposal() {
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
            
            Test.startTest();
            
            APTS_LP_TestUtility.getDiscountConfig(); 
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
            Apttus_Proposal__Proposal__c proposal = APTS_LP_TestUtility.getProposal('Test Proposal');
            insert proposal;
            
            Apttus_Config2__ProductConfiguration__c prodConfig =APTS_LP_TestUtility.getProductConfiguration('Test Cofig');
            prodConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
            prodConfig.Apttus_QPConfig__Proposald__c = proposal.id;
            insert prodConfig;
            
            Apttus_Config2__TempObject__c tempObj =new Apttus_Config2__TempObject__c();
            insert tempObj;
            
            List<Product2> productList = new List<Product2>();
            
            Product2 prod1 = APTS_LP_TestUtility.getProduct();
            prod1.ProductCode = '1SCA101661R1001';
            prod1.APTS_Hierarchy_Level_4_Code__c = null;
            prod1.APTS_LP_Distribution_Channel__c = proposal.APTS_LP_Distribution_Channel__c;
            prod1.APTS_LP_Sales_Organization__c = proposal.APTS_LP_Sales_Organization__c;
            prod1.IsActive = TRUE;
            prod1.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(APTS_Constants.LOCAL_PRODUCTS).getRecordTypeId();
            productList.add(prod1);
            
            Product2 prod2 = APTS_LP_TestUtility.getProduct();
            prod2.ProductCode = '00S02';
            prod2.APTS_Hierarchy_Level_3_Code__c = '00S02';
            prod2.APTS_Hierarchy_level__c = 3;
            prod2.APTS_LP_Is_Hierarchy__c = TRUE;
            prod2.IsActive = TRUE;
            prod2.APTS_Hierarchy_Level_4_Code__c = NULL;
            prod2.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(APTS_Constants.LOCAL_HIERACHY).getRecordTypeId();
            productList.add(prod2);
            
            insert productList;
            
            PageReference pageRef = Page.APTS_BulkUploadProducts;
            pageRef.getParameters().put('id', prodConfig.id);
            pageRef.getParameters().put('configRequestId', tempObj.id);
            pageRef.getParameters().put('flow', 'LP_SPAIN');
            Test.setCurrentPage(pageRef);
            
            APTS_BulkUploadProductsController obj = new APTS_BulkUploadProductsController();
            
            obj.csvBody = Blob.valueOf('Product Hierarchy,Product,Quantity,Discount Type,% Discount,Net Price\n,1SCA101661R1001,1,N,,40\n00S02,,1,S,36.8,');
            obj.fileName = 'easySample';
            
            obj.uploadCSv();
            obj.loadCartLines(); 
            obj.goBack();
            obj.backToCatalog();
            obj.downloadSampleCSV();
            obj.goToCatalog();
            obj.doAbandon();
            obj.redirectToPricing();
            obj.reRenderPanel();
            
            Test.stopTest();
        }
    }
    
    private static testMethod void testAgreement() {
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
            
            Test.startTest();
            
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCommonConfigSetting();
            Apttus__APTS_Agreement__c agreement = APTS_LP_TestUtility.getAgreement('Test Agreement');
            insert agreement;
            
            Apttus_Config2__ProductConfiguration__c prodConfig =APTS_LP_TestUtility.getProductConfiguration('Test Cofig');
            prodConfig.Apttus_Config2__BusinessObjectType__c='Agreement';
            prodConfig.Apttus_CMConfig__AgreementId__c = agreement.Id;
            insert prodConfig;
            
            Apttus_Config2__TempObject__c tempObj =new Apttus_Config2__TempObject__c();
            insert tempObj;
            
            Product2 prod1 = APTS_LP_TestUtility.getProduct();
            prod1.ProductCode = '1SCA101661R1001';
            prod1.APTS_Hierarchy_Level_4_Code__c = null;
            prod1.APTS_LP_Distribution_Channel__c = agreement.APTS_LP_Distribution_Channel__c;
            prod1.APTS_LP_Sales_Organization__c = agreement.APTS_LP_Sales_Organization__c;
            prod1.IsActive = TRUE;
            prod1.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(APTS_Constants.LOCAL_PRODUCTS).getRecordTypeId();
            insert prod1;
            
            PageReference pageRef = Page.APTS_BulkUploadProducts;
            pageRef.getParameters().put('id', prodConfig.id);
            pageRef.getParameters().put('configRequestId', tempObj.id);
            pageRef.getParameters().put('flow', 'LP_SPAIN');
            Test.setCurrentPage(pageRef);
            
            APTS_BulkUploadProductsController obj = new APTS_BulkUploadProductsController();
            
            obj.csvBody = Blob.valueOf('Product Hierarchy,Product,Quantity,Discount Type,% Discount,Net Price\n,1SCA101661R1001,1,N,,40');
            obj.fileName = 'SampleDemo';
            
            obj.uploadCSv();
            obj.goBack();
            obj.backToCatalog();
            obj.downloadSampleCSV();
            obj.goToCatalog();
            obj.redirectToPricing();
            obj.reRenderPanel();
            obj.loadCartLines();
            obj.doAbandon();
			            
            Test.stopTest();
        }
    }
    
    private static testMethod void testOther() {
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
            
            Test.startTest();
            
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
            Apttus_Config2__ProductConfiguration__c prodConfig =APTS_LP_TestUtility.getProductConfiguration('Test Cofig');
            prodConfig.Apttus_Config2__BusinessObjectType__c = 'LineItem';
            insert prodConfig;
            
            Apttus_Config2__TempObject__c tempObj =new Apttus_Config2__TempObject__c();
            insert tempObj;
            
            Apttus_Proposal__Proposal__c proposal = APTS_LP_TestUtility.getProposal('Test Proposal');
            insert proposal;
            
            Product2 prod1 = APTS_LP_TestUtility.getProduct();
            prod1.ProductCode = '1SCA101661R1001';
            prod1.APTS_Hierarchy_Level_4_Code__c = null;
            prod1.APTS_LP_Distribution_Channel__c = proposal.APTS_LP_Distribution_Channel__c;
            prod1.APTS_LP_Sales_Organization__c = proposal.APTS_LP_Sales_Organization__c;
            prod1.IsActive = TRUE;
            prod1.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(APTS_Constants.LOCAL_PRODUCTS).getRecordTypeId();
            insert prod1;
            
            Product2 prod2 = APTS_LP_TestUtility.getProduct();
            prod2.ProductCode = '00S02';
            prod2.APTS_Hierarchy_Level_3_Code__c = '00S02';
            prod2.APTS_Hierarchy_level__c = 3;
            prod2.APTS_LP_Is_Hierarchy__c = TRUE;
            prod2.IsActive = TRUE;
            prod2.APTS_Hierarchy_Level_4_Code__c = NULL;
            prod2.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(APTS_Constants.LOCAL_HIERACHY).getRecordTypeId();
            insert prod2;
            
            PageReference pageRef = Page.APTS_BulkUploadProducts;
            pageRef.getParameters().put('id', prodConfig.id);
            pageRef.getParameters().put('configRequestId', tempObj.id);
            pageRef.getParameters().put('flow', 'LP_SPAIN');
            Test.setCurrentPage(pageRef);
            
            APTS_BulkUploadProductsController obj = new APTS_BulkUploadProductsController();
            
            obj.csvBody = Blob.valueOf('Product Hierarchy,Product,Quantity,Discount Type,% Discount,Net Price\n,1SCA101661R1001,1,N,,40\n00S02,,1,S,36.8,');
            obj.fileName = 'SampleDemo';
            
            obj.uploadCSv();
            //obj.parseString(',",ABC', 1);
            obj.goBack();
            obj.backToCatalog();
            obj.downloadSampleCSV();
            obj.goToCatalog();
            obj.doAbandon();
            obj.redirectToPricing();
            obj.reRenderPanel();
            obj.loadCartLines();
            obj.uploadCSv();
            
            // No file to upload
            obj.csvBody = Blob.valueOf('Product Hierarchy,Product,Quantity,Discount Type,% Discount,Net Price,');
            obj.uploadCSv();
            
            // files with various delimiter
            obj.csvBody = Blob.valueOf('Product Hierarchy;Product;Quantity;Discount Type;% Discount;Net Price\n;1SCA101661R1001;1;N;10;40\n00S02;;1;S;36.8;');
            obj.uploadCSv();
            
            obj.csvBody = Blob.valueOf('Product Hierarchy:Product:Quantity:Discount Type:% Discount:Net Price\n:1SCA101661R1001:1:N:10:40\n00S02::1:S:36.8:');
            obj.uploadCSv();
            
            obj.csvBody = Blob.valueOf('Product Hierarchy   Product   Quantity   Discount Type   % Discount   Net Price\n   1SCA101661R1001   1   N   10   40\n00S02      1   S   36.8   ');
            obj.uploadCSv();
            
            obj.csvBody = Blob.valueOf('Product Hierarchy#Product#Quantity#Discount Type#% Discount#Net Price\n#1SCA101661R1001#1#N#10#40\n00S02##1#S#36.8#');
            obj.uploadCSv();
            
            Test.stopTest();
        }
    }
}