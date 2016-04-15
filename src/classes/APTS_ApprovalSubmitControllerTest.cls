/*************************************************************
@Name: APTS_ApprovalSubmitControllerTest
@Author: Hardik Shah
@CreateDate: 09/09/2015
@Description: This class tests following Classes : APTS_ApprovalSubmitController
@UsedBy: NA
******************************************************************
@ModifiedBy: NA
@ModifiedDate: NA
@ChangeDescription: A brief description of what was modified.
**** PS: @ModifiedBy and @ChangeDescription can be repeated multiple time, based on number of changes made to the original process.
******************************************************************/


@isTest
public class APTS_ApprovalSubmitControllerTest {
    
    // Instance Variable of APTS_AgreementStatusController
    private static APTS_ApprovalSubmitController submitController;
    // User Variable for System Admin Profile
    private static User user;
    // Apttus Agreement Object
    private static Apttus__APTS_Agreement__c agreement;
    
    private static APTS_Capture_LSO_Input_Config_Settings__c lodConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();
 
    
     // Test-method When Agrement & Approval Fields are not avialable
    public static testMethod void fetchAgreementWithNoAprovalFields(){
       
        // Test-Case with System-Admin User
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
             APTS_LP_TestUtility.getDiscountConfig();
             APTS_LP_TestUtility.getCommonConfigSetting();
             agreement = APTS_LP_TestUtility.getAgreement('TestAgreement');
             agreement.APTS_GTV_Code__c = null;
             test.startTest();
             insert agreement;
             ApexPages.StandardController stdController = new ApexPages.StandardController(agreement); 
             submitController = new APTS_ApprovalSubmitController(stdController);
             PageReference ref = submitController.onload();
             test.stopTest();
             
          }
             
    }
    
     // Test-method When Agrement is and Some Approval Fields are not  avialable
    public static testMethod void fetchAgreementWithSomeAprovalFields(){
         // Test-Case with System-Admin User
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
             APTS_LP_TestUtility.getDiscountConfig();
             APTS_LP_TestUtility.getCommonConfigSetting();
             agreement = APTS_LP_TestUtility.getAgreement('TestAgreement');
             agreement.OwnerId = user.id;
             test.startTest();
             insert agreement;
             Apttus__APTS_Agreement__c  testAgreement = [Select APTS_LP_Sales_Office__c,APTS_LP_GTV_Level__c /*APTS_LP_Local_Channel__c*/ from Apttus__APTS_Agreement__c where id =: agreement.id limit 1];
             ApexPages.StandardController stdController = new ApexPages.StandardController(testAgreement); 
             submitController = new APTS_ApprovalSubmitController(stdController);
             PageReference ref = submitController.onload();
             test.stopTest();
             
          }
             
    }
    
      // Test-method When Agrement and its Corresponding group-level fields are avialable
    public static testMethod void fetchAgreementWithAprovalFields(){
         // Test-Case with System-Admin User
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
             APTS_LP_TestUtility.getDiscountConfig();
             APTS_LP_TestUtility.getCommonConfigSetting();
             agreement = APTS_LP_TestUtility.getAgreement('TestAgreement');
             agreement.OwnerId = user.id;
             agreement.APTS_LP_GTV_Level__c = 'Industrial';             
             test.startTest();
             insert agreement;             
             Apttus__APTS_Agreement__c  testAgreement = [Select ID, APTS_LP_Sales_Office__c,APTS_LP_GTV_Level__c /*,APTS_LP_Local_Channel__c*/ from Apttus__APTS_Agreement__c where id =: agreement.id limit 1];
             update testAgreement;
             ApexPages.StandardController stdController = new ApexPages.StandardController(testAgreement);
             submitController = new APTS_ApprovalSubmitController(stdController);
             PageReference ref = submitController.onload();
             test.stopTest();
          }
    }
        
     // Test-method When Agrement and its Corresponding group-level fields are not avialable
    public static testMethod void fetchAgreementWithNoAprovalFieldsinDB(){
         // Test-Case with System-Admin User
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
             APTS_LP_TestUtility.getDiscountConfig();
             APTS_LP_TestUtility.getCommonConfigSetting();
             agreement = APTS_LP_TestUtility.getAgreement('TestAgreement');
             agreement.OwnerId = user.id;
             agreement.APTS_LP_GTV_Level__c = 'Industrial';             
             test.startTest();
             insert agreement;             
             Apttus__APTS_Agreement__c  testAgreement = [Select ID, APTS_LP_Sales_Office__c,APTS_LP_GTV_Level__c /*,APTS_LP_Local_Channel__c*/ from Apttus__APTS_Agreement__c where id =: agreement.id limit 1];
             update testAgreement;
             ApexPages.StandardController stdController = new ApexPages.StandardController(testAgreement);
             submitController = new APTS_ApprovalSubmitController(stdController);
             PageReference ref = submitController.onload();
             test.stopTest();
            
          }
             
    }
    
    
    // Test-method To Fetch Agreement Values from List of Approval Group
    public static testMethod void fetchAgreementWithListOfAprovalFields(){
         // Test-Case with System-Admin User
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
             APTS_LP_TestUtility.getDiscountConfig();
             APTS_LP_TestUtility.getCommonConfigSetting();
             agreement = APTS_LP_TestUtility.getAgreement('TestAgreement');
             agreement.OwnerId = user.id;
             agreement.APTS_LP_GTV_Level__c = 'Industrial49'; 
             agreement.APTS_LP_Sales_Organization__c = 'ABB';
             
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
             insert agreement;
             insert oApprovalRuleMatrix;
             insert admin;
             
             Apttus__APTS_Agreement__c  testAgreement = [Select ID, APTS_LP_Sales_Office__c,APTS_LP_GTV_Level__c,APTS_CH_AQ__c 
                                                         from Apttus__APTS_Agreement__c where id =: agreement.id limit 1];
                                                         
             List<APTS_Approval_Rule_Matrix__c>  lstApprovalRuleMatrix = [select id,APTS_Approval_Level__c,APTS_CHF__c from APTS_Approval_Rule_Matrix__c 
                                                                          where APTS_Is_Active__c =true and APTS_CHF__c = :testAgreement.APTS_CH_AQ__c];
                                                         
                                                         
             system.debug('HS->' + testAgreement);
             system.debug('HS->' + lstApprovalRuleMatrix);
             
             update testAgreement;
             ApexPages.StandardController stdController = new ApexPages.StandardController(testAgreement);
             submitController = new APTS_ApprovalSubmitController(stdController);
             PageReference ref = submitController.onload();
             test.stopTest();
             
          }
             
    }
    
    
      // Test-method To Fetch Agreement Values from List of Approval Group
    public static testMethod void validAgreement(){
         // Test-Case with System-Admin User
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
             APTS_LP_TestUtility.getDiscountConfig();
             APTS_LP_TestUtility.getCommonConfigSetting();
             agreement = APTS_LP_TestUtility.getAgreement('TestAgreement');
             agreement.OwnerId = user.id;
             agreement.APTS_LP_GTV_Level__c = 'Industrial49'; 
             agreement.APTS_LP_Sales_Organization__c = 'ABB';
             
             APTS_Approval_Rule_Matrix__c oApprovalRuleMatrix = new APTS_Approval_Rule_Matrix__c();
             oApprovalRuleMatrix.APTS_Country__c = 'Spain';
             oApprovalRuleMatrix.APTS_Sales_Organisation__c  = 'ABB';
             oApprovalRuleMatrix.APTS_LP_Local_Channel__c = APTS_LP_TestUtility.getLocalChannel().id;
             oApprovalRuleMatrix.APTS_Sales_Office__c = APTS_LP_TestUtility.getSalesOffice().id;
             oApprovalRuleMatrix.APTS_GTV_Level_Code__c  = 'GTV-Code';
             oApprovalRuleMatrix.APTS_Is_Active__c = true;
             
             test.startTest();
             insert agreement;
             insert oApprovalRuleMatrix;
             
             
             Apttus__APTS_Agreement__c  testAgreement = [Select ID, APTS_LP_Sales_Office__c,APTS_LP_GTV_Level__c,APTS_CH_AQ__c 
                                                         from Apttus__APTS_Agreement__c where id =: agreement.id limit 1];
                                                         
             List<APTS_Approval_Rule_Matrix__c>  lstApprovalRuleMatrix = [select id,APTS_Approval_Level__c,APTS_CHF__c from APTS_Approval_Rule_Matrix__c 
                                                                          where APTS_Is_Active__c =true and APTS_CHF__c = :testAgreement.APTS_CH_AQ__c];
                                                         
                                                         
             system.debug('HS->' + testAgreement);
             system.debug('HS->' + lstApprovalRuleMatrix);
             
             update testAgreement;
             ApexPages.StandardController stdController = new ApexPages.StandardController(testAgreement);
             submitController = new APTS_ApprovalSubmitController(stdController);
             PageReference ref = submitController.onload();
             test.stopTest();
             
          }
             
    }
    
    
   
       
}