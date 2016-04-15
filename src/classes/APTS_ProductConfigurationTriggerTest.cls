/*************************************************************
@Name: APTS_ProductConfigurationTriggerTest
@Author: Hardik Shah
@CreateDate: 01/09/2015
@Description: This class tests following Trigger : APTS_ProductConfigurationTrigger
@UsedBy: NA
**************************************************************/


@isTest
public class APTS_ProductConfigurationTriggerTest {
    
    private static User user;
    private static List<Apttus__APTS_Agreement__c> testAgreement;
    private static APTS_Capture_LSO_Input_Config_Settings__c lodConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();
    
    // This method fetches those Product Configuration whose status is not finalized     
    public static testMethod void fetchProductConfiguration() {
        
        user = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
            
            APTS_LP_TestUtility.getCommonConfigSetting();
            Apttus__APTS_Agreement__c agreement =  APTS_LP_TestUtility.getAgreement('Test Agreement');
            Apttus_Config2__ProductConfiguration__c productConfig = APTS_LP_TestUtility.getProductConfiguration('TestProductConfiguration');
            
            test.startTest();
            
            APTS_LP_TestUtility.getDiscountConfig();
            insert agreement;
            productConfig.Apttus_CMConfig__AgreementId__c = agreement.id;
            insert productConfig;
            productConfig.Apttus_Config2__Status__c = 'Saturated';
            update productConfig;
            
            test.stopTest();
            
            testAgreement = [SELECT APTS_LP_GTV_Level__c FROM Apttus__APTS_Agreement__c WHERE id =: agreement.id LIMIT 1];
            System.assertEquals(null, testAgreement[0].APTS_LP_GTV_Level__c);
        }
    }
    
    // This method fetches those Product Configuration whose status is finalized, but has no LineItem
    public static testMethod void fetchProductConfigurationwithNoLineItem() {
        
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {  
            
            APTS_LP_TestUtility.getCommonConfigSetting();
            Apttus__APTS_Agreement__c agreement =  APTS_LP_TestUtility.getAgreement('Test Agreement');
            Apttus_Config2__ProductConfiguration__c productConfig = APTS_LP_TestUtility.getProductConfiguration('TestProductConfiguration');
            
            test.startTest();
            
            APTS_LP_TestUtility.getDiscountConfig();
            insert agreement;
            productConfig.Apttus_CMConfig__AgreementId__c = agreement.id;
            insert productConfig;
            productConfig.Apttus_Config2__Status__c = 'Finalized';
            update productConfig;
            
            test.stopTest();
            
            testAgreement  =  [SELECT APTS_LP_GTV_Level__c FROM Apttus__APTS_Agreement__c WHERE id =: agreement.id LIMIT 1];
            System.assertEquals(null, testAgreement[0].APTS_LP_GTV_Level__c);
        }
    }
    
    // This method fetches those Product Configuration whose status is finalized, and has one LineItem
    public static testMethod void fetchProductConfigurationwithOneLineItem() {
        
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {  
            
            APTS_LP_TestUtility.getCommonConfigSetting();
            Apttus__APTS_Agreement__c agreement =  APTS_LP_TestUtility.getAgreement('Test Agreement');
            
            test.startTest();
            
            Product2 prod =  APTS_LP_TestUtility.getProduct();
            insert prod;
            Product2 hierachyProd =  APTS_LP_TestUtility.getHierarchyProduct();
            hierachyProd.APTS_Hierarchy_Level_3_Code__c = null;
            insert hierachyProd;
            
            APTS_LP_TestUtility.addPricebookAndEntries(prod);
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getApproalRuleMatrix();
            insert agreement;
            
            Apttus_Config2__ProductConfiguration__c productConfig = APTS_LP_TestUtility.getProductConfiguration('TestProductConfiguration');
            productConfig.Apttus_CMConfig__AgreementId__c = agreement.id;
            insert productConfig;
            Apttus_Config2__ProductConfiguration__c hierarchyProductConfig = APTS_LP_TestUtility.getProductConfiguration('TestProductConfiguration');
            hierarchyProductConfig.Apttus_CMConfig__AgreementId__c = agreement.id;
            insert hierarchyProductConfig;
            
            List<Apttus_Config2__LineItem__c> lineItemList = APTS_LP_TestUtility.getLineItemListWithDiscount(productConfig.ID, 1, prod,5);
            lineItemList.addAll(APTS_LP_TestUtility.getLineItemListWithDiscount(hierarchyProductConfig.ID, 1, hierachyProd,5));
            insert lineItemList;
            
            agreement.APTS_MSPA_From_Quote__c = 'With Changes';
            agreement.APTS_isClone__c = TRUE;
            update agreement;
            productConfig.Apttus_Config2__Status__c = 'Finalized';
            update productConfig;
            
            agreement.APTS_MSPA_From_Quote__c = 'Without Changes';
            update agreement;
            hierarchyProductConfig.Apttus_Config2__Status__c = 'Finalized';
            update hierarchyProductConfig;
            
            test.stopTest();
            
            testAgreement  =  [SELECT APTS_LP_GTV_Level__c FROM Apttus__APTS_Agreement__c WHERE id =: agreement.id LIMIT 1];
        }
    }
    
    // This method fetches those Product Configuration whose status is finalized, and has multiple LineItem with Positive Adjustment-Amount,NetAdjustMentPercent
    public static testMethod void fetchProductConfigurationwithMulipleLineItem() {
        
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {  
            
            APTS_LP_TestUtility.getCommonConfigSetting();
            List<Product2> productList =  APTS_LP_TestUtility.getProductList(3);
            Apttus__APTS_Agreement__c agreement = APTS_LP_TestUtility.getAgreement('Test Agreement');
            
            test.startTest();
            
            insert productList;
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getApproalRuleMatrix();
            insert agreement;
            Apttus_Config2__ProductConfiguration__c productConfig = APTS_LP_TestUtility.getProductConfiguration('TestProductConfiguration');
            productConfig.Apttus_CMConfig__AgreementId__c = agreement.id;
            insert productConfig;
            
            Apttus_Config2__ProductConfiguration__c hierarchyProductConfig = APTS_LP_TestUtility.getProductConfiguration('TestHierarchyProductConfiguration');
            hierarchyProductConfig.Apttus_CMConfig__AgreementId__c = agreement.id;
            insert hierarchyProductConfig;
            
            List<Apttus_Config2__LineItem__c> listLineItem = new List<Apttus_Config2__LineItem__c>();
            listLineItem.addAll(APTS_LP_TestUtility.getLineItemListWithDiscount(productConfig.ID, 2, productList[0],5));
            listLineItem.addAll(APTS_LP_TestUtility.getLineItemListWithDiscount(productConfig.ID, 5, productList[1],9));
            listLineItem.addAll(APTS_LP_TestUtility.getLineItemListWithPriceOveride(productConfig.ID, 5, productList[2],10));
            listLineItem.addAll(APTS_LP_TestUtility.getLineItemListWithPriceOveride(productConfig.ID, 5, productList[3],10));
            (listLineItem.get(listLineItem.size() - 1)).APTS_Discount_Percentage__c = 70.00;
            listLineItem.addAll(APTS_LP_TestUtility.getLineItemListWithDiscount(hierarchyProductConfig.ID, 2, productList[3],5));
            listLineItem.addAll(APTS_LP_TestUtility.getLineItemListWithDiscount(hierarchyProductConfig.ID, 5, productList[4],9));
            listLineItem.addAll(APTS_LP_TestUtility.getLineItemListWithPriceOveride(hierarchyProductConfig.ID, 5, productList[5],10));
            (listLineItem.get(listLineItem.size() - 1)).APTS_Discount_Percentage__c = 70.00;
            insert listLineItem;
            
            productConfig.Apttus_Config2__Status__c = 'Finalized';
            update productConfig;
            hierarchyProductConfig.Apttus_Config2__Status__c = 'Finalized';
            update hierarchyProductConfig;
            
            test.stopTest();
            
            testAgreement  =  [Select APTS_LP_GTV_Level__c,APTS_LP_MaximumSubstituteDiscount__c from Apttus__APTS_Agreement__c where id =: agreement.id limit 1];
        }
    }
    
    // This method fetches those Product Configuration whose status is finalized, and has multiple LineItem with Negative Adjustment-Amount,NetAdjustMentPercent
    public static testMethod void fetchProductConfigurationwithMulipleLineItemNegativeValues() {
        
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {  
            
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
            
            List<Product2> productList =  APTS_LP_TestUtility.getProductList(3);
            Apttus__APTS_Agreement__c agreement =  APTS_LP_TestUtility.getAgreement('Test Agreement');
            
            test.startTest();
            
            insert productList;
            APTS_LP_TestUtility.getDiscountConfig();
            
            APTS_LP_TestUtility.getApproalRuleMatrix();
            insert agreement;
            
            Apttus_Config2__ProductConfiguration__c productConfig = APTS_LP_TestUtility.getProductConfiguration('TestProductConfiguration');
            productConfig.Apttus_CMConfig__AgreementId__c = agreement.id;
            insert productConfig;
            Apttus_Config2__ProductConfiguration__c hierarchyProductConfig = APTS_LP_TestUtility.getProductConfiguration('TestHierarchyProductConfiguration');
            hierarchyProductConfig.Apttus_CMConfig__AgreementId__c = agreement.id;
            insert hierarchyProductConfig;
            
            List<Apttus_Config2__LineItem__c> listLineItem = new List<Apttus_Config2__LineItem__c>();
            // Get the LineItemList
            List<Apttus_Config2__LineItem__c> lineItemWithListPrice1 = APTS_LP_TestUtility.getLineItemListWithDiscount(productConfig.ID, 2, productList[0],5);
            lineItemWithListPrice1.addAll(APTS_LP_TestUtility.getLineItemListWithDiscount(hierarchyProductConfig.ID, 2, productList[3],5));
            for(Apttus_Config2__LineItem__c lineItemWithListPrice : lineItemWithListPrice1) {
                lineItemWithListPrice.Apttus_Config2__AdjustmentType__c = APTS_Constants.DISCOUNT;
                lineItemWithListPrice.Apttus_Config2__AdjustmentAmount__c = 1000;
            }
            listLineItem.addAll(lineItemWithListPrice1);
            
            // Get the LineItemList
            List<Apttus_Config2__LineItem__c> lineItemWithListPrice2 = APTS_LP_TestUtility.getLineItemListWithDiscount(productConfig.ID, 5, productList[1],9);
            lineItemWithListPrice2.addAll(APTS_LP_TestUtility.getLineItemListWithDiscount(hierarchyProductConfig.ID, 5, productList[4],9));
            for(Apttus_Config2__LineItem__c lineItemWithListPrice : lineItemWithListPrice2) {
                lineItemWithListPrice.Apttus_Config2__AdjustmentType__c = APTS_Constants.PRICEOVERIDE;
                lineItemWithListPrice.Apttus_Config2__NetAdjustmentPercent__c = 1000;
            }
            listLineItem.addAll(lineItemWithListPrice2);
            
            // Get the LineItemList
            listLineItem.addAll(APTS_LP_TestUtility.getLineItemListWithPriceOveride(productConfig.ID, 5, productList[2],-10));
            listLineItem.addAll(APTS_LP_TestUtility.getLineItemListWithPriceOveride(hierarchyProductConfig.ID, 5, productList[5],-10));
            insert listLineItem;
            
            productConfig.Apttus_Config2__Status__c = 'Finalized';
            update productConfig;
            hierarchyProductConfig.Apttus_Config2__Status__c = 'Finalized';
            update hierarchyProductConfig;
            
            test.stopTest();
            
            testAgreement  =  [SELECT APTS_LP_GTV_Level__c, APTS_LP_MaximumSubstituteDiscount__c FROM Apttus__APTS_Agreement__c WHERE id =: agreement.id LIMIT 1];
        }
    }

	// This method fetches those Product Configuration whose status is not finalized     
    public static testMethod void fetchProductConfigurationForProposal() {
        
        user = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
            
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
            Apttus_Proposal__Proposal__c proposal= APTS_LP_TestUtility.getProposal('Test Proposal');
            Apttus_Config2__ProductConfiguration__c productConfig = APTS_LP_TestUtility.getProductConfiguration('TestProductConfiguration');
            Account acc = APTS_LP_TestUtility.getNewAccount('Test-Account', 'Spain');
            
            test.startTest();
            
            APTS_LP_TestUtility.getDiscountConfig();
            
            insert acc;
            proposal.APTS_LP_AccountCustomer__c = acc.id;
            insert proposal;
            
            productConfig.Apttus_QPConfig__Proposald__c = proposal.id;
            insert productConfig;
            productConfig.Apttus_Config2__Status__c = 'Saturated';
            update productConfig;
            
            test.stopTest();
        }
    }
    
    // This method fetches Product Configuration that has No LineItem for Proposal
    public static testMethod void fetchProductConfigurationwithNoLineItemForProposal() {
        
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
            Test.startTest();
            
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
            Account acc = APTS_LP_TestUtility.getNewAccount('Test-Account', 'Spain');
            insert acc;
            
            APTS_LP_TestUtility.getDiscountConfig();
            
            Apttus_Proposal__Proposal__c proposal= APTS_LP_TestUtility.getProposal('Test Proposal');
            proposal.APTS_LP_AccountCustomer__c = acc.id;
            insert proposal;
            
            Apttus_Config2__ProductConfiguration__c productConfig = APTS_LP_TestUtility.getProductConfiguration('TestProductConfiguration');
            productConfig.Apttus_QPConfig__Proposald__c = proposal.id;
            insert productConfig;
            
            productConfig.Apttus_Config2__Status__c = 'Finalized';
            update productConfig;
            
            Test.stopTest();
            
            List<Apttus_Proposal__Proposal__c> proposalList = [SELECT APTS_LP_GTV_Level__c FROM Apttus_Proposal__Proposal__c WHERE id =: proposal.id LIMIT 1];
            System.assertEquals(null, proposalList[0].APTS_LP_GTV_Level__c);
        }
    }
    
    // This method fetches those Product Configuration that has lineitem for Proposal Object
    public static testMethod void fetchProductConfigurationwithOneLineItemForProposal() {
        
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user){
            
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
            Account acc = APTS_LP_TestUtility.getNewAccount('Test-Account', 'Spain');
            Apttus_Proposal__Proposal__c proposal= APTS_LP_TestUtility.getProposal('Test Proposal');
            
            test.startTest();
            
            insert acc;
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getApproalRuleMatrix();
            proposal.APTS_LP_AccountCustomer__c = acc.id;
            insert proposal;
            
            Product2 prod =  APTS_LP_TestUtility.getProduct();
            insert prod;
            Product2 hierachyProd =  APTS_LP_TestUtility.getHierarchyProduct();
            hierachyProd.APTS_Hierarchy_Level_3_Code__c = null;
            insert hierachyProd;
            
            Apttus_Config2__ProductConfiguration__c productConfig = APTS_LP_TestUtility.getProductConfiguration('TestProductConfiguration');
            productConfig.Apttus_QPConfig__Proposald__c = proposal.id;
            insert productConfig;
            Apttus_Config2__ProductConfiguration__c hierarchyProductConfig = APTS_LP_TestUtility.getProductConfiguration('TestProductConfiguration');
            hierarchyProductConfig.Apttus_QPConfig__Proposald__c = proposal.id;
            insert hierarchyProductConfig;
            
            List<Apttus_Config2__LineItem__c> listLineItem = new List<Apttus_Config2__LineItem__c>();
            listLineItem.addAll(APTS_LP_TestUtility.getLineItemListWithDiscount(productConfig.ID, 1, prod, 5));
            listLineItem.addAll(APTS_LP_TestUtility.getLineItemListWithDiscount(hierarchyProductConfig.ID, 1, hierachyProd, 5));
            
            productConfig.Apttus_Config2__Status__c = 'Finalized';
            update productConfig;
            hierarchyProductConfig.Apttus_Config2__Status__c = 'Finalized';
            update hierarchyProductConfig;
            
            test.stopTest();
            
            List<Apttus_Proposal__Proposal__c> proposalList = [SELECT APTS_LP_GTV_Level__c FROM Apttus_Proposal__Proposal__c WHERE id =: proposal.id LIMIT 1];
        }
    }
    
    // This method fetches those Product Configuration whose status is finalized, and has multiple
    // LineItem with Positive Adjustment-Amount,NetAdjustMentPercent
    public static testMethod void fetchProductConfigurationwithMulipleLineItemForProposal() {
        
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {  
            
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
            List<Product2> productList =  APTS_LP_TestUtility.getProductList(3);
            Apttus_Proposal__Proposal__c proposal = APTS_LP_TestUtility.getProposal('Test Proposal');
            Account acc = APTS_LP_TestUtility.getNewAccount('Test-Account', 'Spain');
            
            test.startTest();
            
            insert productList;
            APTS_LP_TestUtility.getDiscountConfig();
            
            APTS_LP_TestUtility.getApproalRuleMatrix();
            insert acc;
            proposal.APTS_LP_AccountCustomer__c = acc.id;
            insert proposal;
            Apttus_Config2__ProductConfiguration__c productConfig = APTS_LP_TestUtility.getProductConfiguration('TestProductConfiguration');
            productConfig.Apttus_QPConfig__Proposald__c = proposal.id;
            insert productConfig;
            
            Apttus_Config2__ProductConfiguration__c hierarchyProductConfig = APTS_LP_TestUtility.getProductConfiguration('TestHierarchyProductConfiguration');
            hierarchyProductConfig.Apttus_QPConfig__Proposald__c = proposal.id;
            insert hierarchyProductConfig;
            
            List<Apttus_Config2__LineItem__c> listLineItem = new List<Apttus_Config2__LineItem__c>();
            listLineItem.addAll(APTS_LP_TestUtility.getLineItemListWithDiscount(productConfig.ID, 2, productList[0],5));
            listLineItem.addAll(APTS_LP_TestUtility.getLineItemListWithDiscount(productConfig.ID, 5, productList[1],9));
            listLineItem.addAll(APTS_LP_TestUtility.getLineItemListWithPriceOveride(productConfig.ID, 5, productList[2],10));
            listLineItem.addAll(APTS_LP_TestUtility.getLineItemListWithPriceOveride(productConfig.ID, 5, productList[3],10));
            (listLineItem.get(listLineItem.size() - 1)).APTS_Discount_Percentage__c = 70.00;
            listLineItem.addAll(APTS_LP_TestUtility.getLineItemListWithDiscount(hierarchyProductConfig.ID, 2, productList[3],5));
            listLineItem.addAll(APTS_LP_TestUtility.getLineItemListWithDiscount(hierarchyProductConfig.ID, 5, productList[4],9));
            listLineItem.addAll(APTS_LP_TestUtility.getLineItemListWithPriceOveride(hierarchyProductConfig.ID, 5, productList[5],10));
            (listLineItem.get(listLineItem.size() - 1)).APTS_Discount_Percentage__c = 70.00;
            insert listLineItem;
            
            productConfig.Apttus_Config2__Status__c = 'Finalized';
            update productConfig;
            hierarchyProductConfig.Apttus_Config2__Status__c = 'Finalized';
            update hierarchyProductConfig;
            
            test.stopTest();
        }
    }
    
    
    // This method fetches those Product Configuration whose status is finalized, and has multiple LineItem with Negative Adjustment-Amount,NetAdjustMentPercent
    public static testMethod void fetchProductConfigurationwithMulipleLineItemNegativeValuesForProposal() {
        
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {  
            
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
            List<Product2> productList =  APTS_LP_TestUtility.getProductList(3);
            Apttus_Proposal__Proposal__c proposal = APTS_LP_TestUtility.getProposal('Test Proposal');
            Account acc = APTS_LP_TestUtility.getNewAccount('Test-Account', 'Spain');
            
            test.startTest();
            
            insert productList;
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getApproalRuleMatrix();
            
            insert acc;
            proposal.APTS_LP_AccountCustomer__c = acc.id;
            insert proposal;
            
            Apttus_Config2__ProductConfiguration__c productConfig = APTS_LP_TestUtility.getProductConfiguration('TestProductConfiguration');
            productConfig.Apttus_QPConfig__Proposald__c = proposal.id;
            insert productConfig;
            Apttus_Config2__ProductConfiguration__c hierarchyProductConfig = APTS_LP_TestUtility.getProductConfiguration('TestHierarchyProductConfiguration');
            hierarchyProductConfig.Apttus_QPConfig__Proposald__c = proposal.id;
            insert hierarchyProductConfig;
            
            List<Apttus_Config2__LineItem__c> listLineItem = new List<Apttus_Config2__LineItem__c>();
            // Get the LineItemList
            List<Apttus_Config2__LineItem__c> lineItemWithListPrice1 = APTS_LP_TestUtility.getLineItemListWithDiscount(productConfig.ID, 2, productList[0],5);
            lineItemWithListPrice1.addAll(APTS_LP_TestUtility.getLineItemListWithDiscount(hierarchyProductConfig.ID, 2, productList[3],5));
            for(Apttus_Config2__LineItem__c lineItemWithListPrice : lineItemWithListPrice1) {
                lineItemWithListPrice.Apttus_Config2__AdjustmentType__c = APTS_Constants.DISCOUNT;
                lineItemWithListPrice.Apttus_Config2__AdjustmentAmount__c = 1000;
            }
            listLineItem.addAll(lineItemWithListPrice1);
            
            // Get the LineItemList
            List<Apttus_Config2__LineItem__c> lineItemWithListPrice2 = APTS_LP_TestUtility.getLineItemListWithDiscount(productConfig.ID, 5, productList[1],9);
            lineItemWithListPrice2.addAll(APTS_LP_TestUtility.getLineItemListWithDiscount(hierarchyProductConfig.ID, 5, productList[4],9));
            for(Apttus_Config2__LineItem__c lineItemWithListPrice : lineItemWithListPrice2) {
                lineItemWithListPrice.Apttus_Config2__AdjustmentType__c = APTS_Constants.PRICEOVERIDE;
                lineItemWithListPrice.Apttus_Config2__NetAdjustmentPercent__c = 1000;
            }
            listLineItem.addAll(lineItemWithListPrice2);
            
            // Get the LineItemList
            listLineItem.addAll(APTS_LP_TestUtility.getLineItemListWithPriceOveride(productConfig.ID, 5, productList[2],-10));
            listLineItem.addAll(APTS_LP_TestUtility.getLineItemListWithPriceOveride(hierarchyProductConfig.ID, 5, productList[5],-10));
            insert listLineItem;
            
            productConfig.Apttus_Config2__Status__c = 'Finalized';
            update productConfig;
            hierarchyProductConfig.Apttus_Config2__Status__c = 'Finalized';
            update hierarchyProductConfig;
            
            test.stopTest();
        }
    }
}