/*************************************************************
@Name: APTS_AgreementStatusControllerTest
@Author: Hardik Shah
@CreateDate: 09/09/2015
@Description: This class tests following Classes : APTS_AgreementStatusController
@UsedBy: NA
******************************************************************
@ModifiedBy: NA
@ModifiedDate: NA
@ChangeDescription: A brief description of what was modified.
**** PS: @ModifiedBy and @ChangeDescription can be repeated multiple time, based on number of changes made to the original process.
******************************************************************/


@isTest
public class APTS_AgreementStatusControllerTest {

    // Instance Variable of APTS_AgreementStatusController
    private static APTS_AgreementStatusController statusController;
    // User Variable for System Admin Profile
    private static User user;
    // Apttus Agreement Object
    private static Apttus__APTS_Agreement__c agreement;
    private static APTS_Capture_LSO_Input_Config_Settings__c lodConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();
    
    // Test-Class When Agrement is not avialable
    public static testMethod void fetchNonExistsAgreement(){
       
        // Test-Case with System-Admin User
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
             APTS_LP_TestUtility.getCommonConfigSetting();
		     agreement = APTS_LP_TestUtility.getAgreement('TestAgreement');
             ApexPages.StandardController stdController = new ApexPages.StandardController(agreement); 
           	 statusController = new APTS_AgreementStatusController(stdController);
             test.startTest();
       	     PageReference ref = statusController.onload();
             test.stopTest();
        	 system.assertEquals(null,ref);
          }
             
    }
    
     // Test-Class when Agrement is Avialable but Request Parameter doesn't exists
     public static testMethod void fetchExistsAgreement(){
       
        // Test-Case with System-Admin User
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
		     APTS_LP_TestUtility.getCommonConfigSetting();
             agreement = APTS_LP_TestUtility.getAgreement('TestAgreement');
             APTS_LP_TestUtility.getDiscountConfig();
             test.startTest();
             insert agreement;
             ApexPages.StandardController stdController = new ApexPages.StandardController(agreement); 
           	 statusController = new APTS_AgreementStatusController(stdController);
             PageReference ref = statusController.onload();
             test.stopTest();
        	 system.assertEquals(null,ref);
          }
      }
    
    // Test-Class when Agreement is Avialable and Request Parameter Exits
     public static testMethod void updateAgreementStatusToDeActivated(){
       
        // Test-Case with System-Admin User
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
             APTS_LP_TestUtility.getCommonConfigSetting();
		     agreement = APTS_LP_TestUtility.getAgreement('TestAgreement');
             Test.startTest();
             APTS_LP_TestUtility.getDiscountConfig();
             insert agreement;
             system.debug('agr1-->' + agreement);
             ApexPages.StandardController stdController = new ApexPages.StandardController(agreement);
             Test.setCurrentPageReference(new PageReference('Page.myPage')); 
			 System.currentPageReference().getParameters().put('requestParameter', 'DeActivated');
             statusController = new APTS_AgreementStatusController(stdController);
             PageReference ref = statusController.onload();
             Test.stopTest();
             
             List<Apttus__APTS_Agreement__c> testAgreement  =  [Select Apttus__Status__c from Apttus__APTS_Agreement__c where id =: agreement.id limit 1];
                        
             system.assertEquals('Deactivated',testAgreement[0].Apttus__Status__c);
             
          }
      }
    
    // Test-Class when Agreement is Avialable and Request Parameter Exits
     public static testMethod void updateAgreementStatusToBlocked(){
       
        // Test-Case with System-Admin User
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
             APTS_LP_TestUtility.getCommonConfigSetting();
		     agreement = APTS_LP_TestUtility.getAgreement('TestAgreement');
             APTS_LP_TestUtility.getDiscountConfig();
             test.startTest();
             insert agreement;
             ApexPages.StandardController stdController = new ApexPages.StandardController(agreement);
             Test.setCurrentPageReference(new PageReference('Page.myPage')); 
			 System.currentPageReference().getParameters().put('requestParameter', 'Blocked');
             statusController = new APTS_AgreementStatusController(stdController);
             PageReference ref = statusController.onload();
             test.stopTest();
             List<Apttus__APTS_Agreement__c> testAgreement  =  [Select Apttus__Status__c from Apttus__APTS_Agreement__c where id =: agreement.id limit 1];
             system.assertEquals('Blocked',testAgreement[0].Apttus__Status__c);
             
          }
      }
    
    // Test-Class when Agreement is Avialable and Request Parameter is Different
     public static testMethod void updateAgreementStatusToOtherStatus(){
       
        // Test-Case with System-Admin User
        user  = APTS_LP_TestUtility.getUser();
       System.runAs(user) {
             APTS_LP_TestUtility.getCommonConfigSetting();
		     agreement = APTS_LP_TestUtility.getAgreement('TestAgreement');
           	 agreement.Apttus__Status__c = APTS_Constants.AGREEMENT_STATUS;
             APTS_LP_TestUtility.getDiscountConfig();
             test.startTest();
             insert agreement;
             ApexPages.StandardController stdController = new ApexPages.StandardController(agreement);
             Test.setCurrentPageReference(new PageReference('Page.myPage')); 
			 System.currentPageReference().getParameters().put('requestParameter', 'Test');
             statusController = new APTS_AgreementStatusController(stdController);
             PageReference ref = statusController.onload();
             test.stopTest();
             List<Apttus__APTS_Agreement__c> testAgreement  =  [Select Apttus__Status__c from Apttus__APTS_Agreement__c where id =: agreement.id limit 1];
            // system.assertEquals('Draft',testAgreement[0].Apttus__Status__c);
             
          }
      }
      
       // Test-Class when Agreement is Avialable and Request Parameter is Different
     /*public static testMethod void updateAgreementStatusToOPendingApproval(){
       
        // Test-Case with System-Admin User
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
		     agreement = APTS_LP_TestUtility.getAgreement('TestAgreement');
             APTS_LP_TestUtility.getDiscountConfig();
		     agreement.Apttus__Status__c = 'Pending Approval';
             test.startTest();
             insert agreement;
             ApexPages.StandardController stdController = new ApexPages.StandardController(agreement);
             Test.setCurrentPageReference(new PageReference('Page.myPage')); 
			 System.currentPageReference().getParameters().put('requestParameter', 'Test');
             statusController = new APTS_AgreementStatusController(stdController);
             PageReference ref = statusController.onload();
             test.stopTest();
             List<Apttus__APTS_Agreement__c> testAgreement  =  [Select Apttus__Status__c from Apttus__APTS_Agreement__c where id =: agreement.id limit 1];
             system.assertEquals('Pending Approval',testAgreement[0].Apttus__Status__c);
             
          }
      }*/
    
    
}