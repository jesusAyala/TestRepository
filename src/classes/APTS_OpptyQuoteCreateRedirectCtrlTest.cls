/*************************************************************
@Name: APTS_OpptyQuoteCreateRedirectCtrlTest
@Author: Tirth Mathuria
@CreateDate: 17th Nov 2015
@Description: This class is to test the APTS_OpptyQuoteCreateRedirectController
@UsedBy: NA
******************************************************************/
@isTest
private class APTS_OpptyQuoteCreateRedirectCtrlTest {
    
    private static User user;
    private static APTS_Capture_LSO_Input_Config_Settings__c lodConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();

	private static testMethod void test() {
	    
	     user  = APTS_LP_TestUtility.getUser();
         System.runAs(user) {
             
             APTS_LP_TestUtility.getDiscountConfig(); 
            
             
             test.startTest();
              ApexPages.StandardController stdController = new ApexPages.StandardController(new Opportunity()); 
              APTS_OpptyQuoteCreateRedirectController obj = new APTS_OpptyQuoteCreateRedirectController(stdController);
              obj.redirectToQuoteCreatePage();
             
             test.stopTest();
         }

	}

}