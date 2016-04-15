/*************************************************************
@Name: APTS_SubmitPrsApprovalControllerTest
@Author: Hardik Shah
@CreateDate: 09/09/2015
@Description: This class tests following Classes : APTS_SubmitProposalApprovalController
@UsedBy: NA
******************************************************************/

@isTest
public class APTS_SubmitPrsApprovalControllerTest {

     // Instance Variable of APTS_SubmitProposalApprovalController
    private static APTS_SubmitProposalApprovalController submitProposalController;
    // User Variable for System Admin Profile
    private static User user;
    // Apttus proposal Object
    private static Apttus_Proposal__Proposal__c proposal;
    // Account Object
    private static Account account = null;
    private static APTS_Capture_LSO_Input_Config_Settings__c lodConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();
    
	public static testMethod void fetchNonExistsProposals() {
        // Test-Case with System-Admin User
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
            Test.startTest();
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
            proposal = APTS_LP_TestUtility.getProposal('Test-Proposal');
            insert proposal;
            ApexPages.StandardController stdController = new ApexPages.StandardController(proposal);
            submitProposalController = new APTS_SubmitProposalApprovalController(stdController);
            submitProposalController.proposal = APTS_LP_TestUtility.getProposal('Test-Proposal');
            PageReference ref = submitProposalController.onload();
            submitProposalController.proposal.APTS_LP_No_Approval_Rule_Matched__c = TRUE;
            ref = submitProposalController.onload();
            Test.stopTest();
        }
    }
    
     // Test-Method When Proposals & Approval Fields are not avialable
    public static testMethod void fetchAgreementWithNoAprovalFields(){
       
        // Test-Case with System-Admin User
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
             APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
             proposal = APTS_LP_TestUtility.getProposal('Test-Proposal');
             account = APTS_LP_TestUtility.getNewAccount('Test-Acc','Spain');
             test.startTest();
             insert account;
             proposal.APTS_LP_AccountCustomer__c = account.id;
             insert proposal;
             ApexPages.StandardController stdController = new ApexPages.StandardController(proposal); 
             submitProposalController = new APTS_SubmitProposalApprovalController(stdController);
             PageReference ref = submitProposalController.onload();
             test.stopTest();
             
          }
             
    }
    
     // Test-Method When Proposals is and Some Approval Fields are not  avialable
    public static testMethod void fetchAgreementWithSomeAprovalFields(){
         // Test-Case with System-Admin User
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
             APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
             proposal = APTS_LP_TestUtility.getProposal('Test-Proposal');
             account = APTS_LP_TestUtility.getNewAccount('Test-Acc','Spain');
             proposal.OwnerId = user.id;
             proposal.APTS_LP_Local_Channel__c = 'P5';
             test.startTest();
             insert account;
             proposal.APTS_LP_AccountCustomer__c = account.id;
             insert proposal;
             Apttus_Proposal__Proposal__c  testProposal = [Select APTS_LP_GTV_Level__c,APTS_LP_Local_Channel__c from Apttus_Proposal__Proposal__c where id =: proposal.id limit 1];
             ApexPages.StandardController stdController = new ApexPages.StandardController(testProposal); 
             submitProposalController = new APTS_SubmitProposalApprovalController(stdController);
             PageReference ref = submitProposalController.onload();
             test.stopTest();
             
          }
             
    }
    
      // Test-Method When Proposals and its Corresponding group-level fields are avialable
    public static testMethod void fetchAgreementWithAprovalFields(){
         // Test-Case with System-Admin User
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
             APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
             proposal = APTS_LP_TestUtility.getProposal('Test-Proposal');
             account = APTS_LP_TestUtility.getNewAccount('Test-Acc','Spain');
             proposal.OwnerId = user.id;
             proposal.APTS_LP_Local_Channel__c = 'OEMS';
             proposal.APTS_LP_GTV_Level__c = 'Industrial';             
             test.startTest();
             insert account;
             proposal.APTS_LP_AccountCustomer__c = account.id;
             insert proposal;             
             Apttus_Proposal__Proposal__c  testProposal= [Select ID, APTS_LP_GTV_Level__c,APTS_LP_Local_Channel__c from Apttus_Proposal__Proposal__c where id =: proposal.id limit 1];
             update testProposal;
             ApexPages.StandardController stdController = new ApexPages.StandardController(testProposal);
             submitProposalController = new APTS_SubmitProposalApprovalController(stdController);
             PageReference ref = submitProposalController.onload();
             test.stopTest();
             
          }
    }
        
     // Test-Method When Proposals and its Corresponding group-level fields are not avialable
    public static testMethod void fetchAgreementWithNoAprovalFieldsinDB(){
         // Test-Case with System-Admin User
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
             APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
             account = APTS_LP_TestUtility.getNewAccount('Test-Acc','Spain');
             proposal = APTS_LP_TestUtility.getProposal('Test-Proposal');
             proposal.OwnerId = user.id;
             proposal.APTS_LP_Local_Channel__c = 'OEMS1';
             proposal.APTS_LP_GTV_Level__c = 'Industrial';             
             test.startTest();
             insert account;
             proposal.APTS_LP_AccountCustomer__c = account.id;
             insert proposal;             
             Apttus_Proposal__Proposal__c  testProposal = [Select ID, APTS_LP_GTV_Level__c,APTS_LP_Local_Channel__c from Apttus_Proposal__Proposal__c where id =: proposal.id limit 1];
             update testProposal;
             ApexPages.StandardController stdController = new ApexPages.StandardController(testProposal);
             submitProposalController = new APTS_SubmitProposalApprovalController(stdController);
             PageReference ref = submitProposalController.onload();
             test.stopTest();
             
          }
             
    }
    
    
    // Test-Method To Fetch Proposals Values from List of Approval Group
    public static testMethod void fetchAgreementWithListOfAprovalFields(){
         // Test-Case with System-Admin User
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
             APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
             account = APTS_LP_TestUtility.getNewAccount('Test-Acc','Spain');
             proposal = APTS_LP_TestUtility.getProposal('Test-Proposal');
             proposal.OwnerId = user.id;
             proposal.APTS_LP_GTV_Level__c = 'Industrial49';
             proposal.APTS_LP_Sales_Organization__c  = 'ABB';
             
             APTS_Approval_Rule_Matrix__c oApprovalRuleMatrix = new APTS_Approval_Rule_Matrix__c();
             oApprovalRuleMatrix.APTS_Country__c = 'Spain';
             oApprovalRuleMatrix.APTS_Sales_Organisation__c  = 'ABB';
             oApprovalRuleMatrix.APTS_LP_Local_Channel__c = APTS_LP_TestUtility.getLocalChannel().id;
             oApprovalRuleMatrix.APTS_Sales_Office__c = APTS_LP_TestUtility.getSalesOffice().id;
             oApprovalRuleMatrix.APTS_GTV_Level_Code__c  = 'GTV-Code';
             oApprovalRuleMatrix.APTS_Is_Active__c = true;
             
             Apttus__APTS_Admin__c admin = new Apttus__APTS_Admin__c();
             admin.name = 'APTS_MaxApprovalRuleMatrixLevels';
             admin.Apttus__Value__c = '2';
             
             
             test.startTest();
             insert account;
             proposal.APTS_LP_AccountCustomer__c = account.id;
             insert proposal; 
             insert oApprovalRuleMatrix;
             insert admin;
             
             Apttus_Proposal__Proposal__c  testProposal = [Select ID, APTS_LP_GTV_Level__c,APTS_LP_Local_Channel__c from Apttus_Proposal__Proposal__c where id =: proposal.id limit 1];
             update testProposal;
             ApexPages.StandardController stdController = new ApexPages.StandardController(testProposal);
             submitProposalController = new APTS_SubmitProposalApprovalController(stdController);
             PageReference ref = submitProposalController.onload();
             test.stopTest();
             
      }
             
    }
    
    
      // Test-method To Fetch Agreement Values from List of Approval Group
    public static testMethod void validProposal(){
         // Test-Case with System-Admin User
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
             APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
             proposal = APTS_LP_TestUtility.getProposal('Test-Proposal');
             proposal.OwnerId = user.id;
             proposal.APTS_LP_GTV_Level__c = 'Industrial49';
             proposal.APTS_LP_Sales_Organization__c  = 'ABB';
             
             APTS_Approval_Rule_Matrix__c oApprovalRuleMatrix = new APTS_Approval_Rule_Matrix__c();
             oApprovalRuleMatrix.APTS_Country__c = 'Spain';
             oApprovalRuleMatrix.APTS_Sales_Organisation__c  = 'ABB';
             oApprovalRuleMatrix.APTS_LP_Local_Channel__c = APTS_LP_TestUtility.getLocalChannel().id;
             oApprovalRuleMatrix.APTS_Sales_Office__c = APTS_LP_TestUtility.getSalesOffice().id;
             oApprovalRuleMatrix.APTS_GTV_Level_Code__c  = 'GTV-Code';
             oApprovalRuleMatrix.APTS_Is_Active__c = true;
             
             test.startTest();
             insert proposal;
             insert oApprovalRuleMatrix;
             
             Apttus_Proposal__Proposal__c  testProposal = [Select ID, APTS_LP_GTV_Level__c,APTS_LP_Local_Channel__c from Apttus_Proposal__Proposal__c where id =: proposal.id limit 1];
             update testProposal;
             ApexPages.StandardController stdController = new ApexPages.StandardController(testProposal);
             submitProposalController = new APTS_SubmitProposalApprovalController(stdController);
             PageReference ref = submitProposalController.onload();
             test.stopTest();
             
          }
             
    }
}