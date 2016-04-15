/*************************************************************
@Name: APTS_LP_TestUtilityTest
@Author: Prabhat Rai
@CreateDate: 26/09/2015
@Description: This class tests following Classes : APTS_LP_TestUtility
@UsedBy: NA
******************************************************************/

@isTest
public class APTS_LP_TestUtilityTest {
    
    static Apttus_Approval__ApprovalsSystemProperties__c approvalSystemProperty = APTS_LP_TestUtility.getApprovalSystemProperty();
    static APTS_Capture_LSO_Input_Config_Settings__c lodConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();
    
	// Test all the methods in APTS_LP_TestUtility Class
	private static testMethod void LPUtilityMethodsTest() {
            
        System.runAs(APTS_LP_TestUtility.getUser()){
        	Test.startTest();
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCommonConfigSetting();
            System.assert(approvalSystemProperty.id != null);
            System.assert(lodConfigSetting.id != null);
            APTS_LP_TestUtility.getUser();
            APTS_LP_TestUtility.createContact();
            Apttus__APTS_Agreement__c agr = APTS_LP_TestUtility.getAgreement('testAgreement');
            insert agr;
            Account currentAccount = APTS_LP_TestUtility.getNewAccount('accntName','Spain');
            currentAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ABB ICV').getRecordTypeId();
            insert currentAccount;
            Opportunity currentOpp = APTS_LP_TestUtility.getOpportunity('testOpp');
            currentOpp.AccountId = currentAccount.Id;
            currentOpp.CloseDate = date.parse('06/07/2016');
            insert currentOpp;
            Partner  currentPartner = APTS_LP_TestUtility.getPartner(currentOpp.Id,currentAccount.Id);     
            Apttus_Proposal__Proposal__c  currentProposal = APTS_LP_TestUtility.getProposal('tespProposal');
            //insert currentProposal;
            APTS_LP_TestUtility.getAgreementLineItem(agr.Id);
            APTS_LP_TestUtility.getAgreementLineItemList(agr.Id, 2);
            Apttus_Config2__ProductConfiguration__c currentConfiguration = APTS_LP_TestUtility.getProductConfiguration('testConfig');
            APTS_LP_TestUtility.getConfigurationFromAgreement(agr.Id);
            Product2 currentProd = APTS_LP_TestUtility.getProduct();
            insert currentProd;
            APTS_LP_TestUtility.getLineItemListWithPriceOveride(currentConfiguration.Id,2,currentProd,200);
            APTS_LP_TestUtility.getProductList(2);
            APTS_LP_TestUtility.getLineItemListWithDiscount(currentConfiguration.Id,2,currentProd,200);
            APTS_LP_TestUtility.getLineItem(currentConfiguration.Id);
            User currentUser = APTS_LP_TestUtility.getUser('Spain');
            Apttus_Config2__PriceList__c  plst = APTS_LP_TestUtility.getPriceList(currentAccount,'Spain');
            insert plst;
            APTS_LP_TestUtility.getAdminProfile();
            Profile salesProfile = APTS_LP_TestUtility.getSalesProfile();        
            APTS_LP_TestUtility.getRecordId();
            APTS_LP_TestUtility.getCustomUser(salesProfile,'test@apttus.com');
            APTS_LP_TestUtility.getCustomUser(salesProfile);        
            APTS_LP_TestUtility.addPricebookAndEntries(currentProd);
            APTS_LP_TestUtility.getDiscountsBackup('testDBName');
            APTS_LP_TestUtility.getMSPARefNumber('refId123');
            APTS_LP_TestUtility.getCustomSetting();
            Product2 hierarchyProduct = APTS_LP_TestUtility.getHierarchyProduct();
            System.assert(hierarchyProduct.name.equals('Test Hierarchy Prod'));
            APTS_LP_TestUtility.getStageProductLineTreeList(5);
            APTS_LP_TestUtility.getProductList(5, 'Local Hierarchy');
            APTS_LP_TestUtility.getLocalHierachyList(5);
            APTS_LP_TestUtility.getStageMSPA(5);
            APTS_LP_TestUtility.getStageMSPALineItems(5);
            APTS_LP_TestUtility.getStageApprovalRuleMatrix(5);
            APTS_LP_TestUtility.getStageMasterPicklistTableData();
            APTS_LP_TestUtility.getStageMasterPicklistTableData(5);
            APTS_LP_TestUtility.getApproalRuleMatrix();
            APTS_LP_TestUtility.getDelegateApprovalCustomSettings();
            APTS_LP_TestUtility.getProductLineTreeList();
            APTS_LP_TestUtility.getStageLocalOperationData();
            APTS_LP_TestUtility.getProductLineTreeCustomSettings();
            APTS_LP_TestUtility.getIntegrationParameters();
            APTS_LP_TestUtility.getSAPIntegrationTokens();
            APTS_LP_TestUtility.getSalesUser();
            APTS_LP_TestUtility.getProductLineTreeCustomSettings();
            Test.stopTest();
    	}
    }
    
}