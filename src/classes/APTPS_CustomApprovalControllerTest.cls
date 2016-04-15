/*************************************************************
@Name: APTPS_CustomApprovalControllerTest
@Author: Tirth Mathuria
@CreateDate: 17th Nov 2015
@Description: This class is to test the APTPS_CustomApprovalController
@UsedBy: NA
******************************************************************/
@isTest
private class APTPS_CustomApprovalControllerTest {
    
    private static User user;
    private static APTS_Capture_LSO_Input_Config_Settings__c lodConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();

	private static testMethod void test() {
	    
	     user  = APTS_LP_TestUtility.getUser();
         System.runAs(user) {
             
             APTS_LP_TestUtility.getDiscountConfig(); 
            
             
             test.startTest();
              APTPS_CustomApprovalController obj = new APTPS_CustomApprovalController();
              obj.RequestID='1234';
              obj.proposalName= 'Test';
              obj.currCode='$';
             obj.GetlstPropLI();
             obj.GetPropURL();
             test.stopTest();
         }

	}

}