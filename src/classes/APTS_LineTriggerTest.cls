@isTest
private class APTS_LineTriggerTest {
    

    static APTS_Capture_LSO_Input_Config_Settings__c oLODConfigSetting = APTS_LP_TestUtility.getLODConfigSetting(); 

	//Test Case for APTS_LineItemTrigger, APTS_LineTriggerHandler, APTS_LineItemTriggerHelper
	public static testMethod void testLineitemTriggerClasses() {
	    
	    System.runAs(APTS_LP_TestUtility.getUser()) {
            APTS_LP_TestUtility.getCommonConfigSetting();
	        Apttus__APTS_Agreement__c agreement = APTS_LP_TestUtility.getAgreement('Test Agreement');
            Test.startTest();
            
            APTS_LP_TestUtility.getDiscountConfig();
            insert agreement;
             
            Apttus_Config2__ProductConfiguration__c currentConfiguration = APTS_LP_TestUtility.getProductConfiguration('testConfig');
            currentConfiguration.Apttus_CMConfig__AgreementId__c = agreement.id;
            insert currentConfiguration;
            
            Apttus_Config2__LineItem__c li = APTS_LP_TestUtility.getLineItem(currentConfiguration.id);
            li.Apttus_Config2__PrimaryLineNumber__c=1;
              insert li;
            
             try
            {
               Delete li;
            }
           catch(Exception e) 
            {
            
            }
            Test.stopTest();
	    }

	}

}