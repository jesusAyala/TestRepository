@isTest
private class APTPS_AgreementApprovalCntlrTest {

	 // Instance Variable of APTS_AgreementStatusController
    private static APTPS_AgreementApprovalController agreementAprvlCntrlr;
    // User Variable for System Admin Profile
    private static User user;
    // Apttus Agreement Object
    private static Apttus__APTS_Agreement__c agreement;
    private static APTS_Capture_LSO_Input_Config_Settings__c lodConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();
    
	
	@isTest static void test_method_one() {

		user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
            APTS_LP_TestUtility.getCommonConfigSetting();
		     agreement = APTS_LP_TestUtility.getAgreement('TestAgreement');
             
           	 agreementAprvlCntrlr = new APTPS_AgreementApprovalController();
           	 System.assertEquals(agreementAprvlCntrlr.percentage, '%');


           	 Apttus_Proposal__ProposalSystemProperties__c proposalSystemProperties = new Apttus_Proposal__ProposalSystemProperties__c();
           	 proposalSystemProperties.name = 'System Properties';
           	 proposalSystemProperties.Apttus_Proposal__InstanceUrl__c='https://abb--sf1rapt.cs17.my.salesforce.com';
           	 insert proposalSystemProperties;

             test.startTest();
       	     String url = agreementAprvlCntrlr.GetAgrURL();
       	     System.assertNotEquals(url,null);
             test.stopTest();
        	 
          }
	}
	
	@isTest static void test_method_two() {

		user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
            APTS_LP_TestUtility.getCommonConfigSetting();
		       agreement = APTS_LP_TestUtility.getAgreement('TestAgreement');
		       APTS_LP_TestUtility.getDiscountConfig();
		       insert agreement;

		       List<Apttus__AgreementLineItem__c>  agreementLineItemsLst = APTS_LP_TestUtility.getAgreementLineItemList(agreement.id,5);
		       insert agreementLineItemsLst;

		       agreementAprvlCntrlr = new APTPS_AgreementApprovalController();
		       agreementAprvlCntrlr.agrmntId = agreement.id;
               agreementAprvlCntrlr.agrmntName = 'Test Agreement Name';
               agreementAprvlCntrlr.requestID = '12345';
               agreementAprvlCntrlr.currCode = 'EUR';
           	   test.startTest();
       	    	List<Apttus__AgreementLineItem__c>  agreementLineItemsLstReturn = agreementAprvlCntrlr.GetlstAgrLI();
       	    	System.assertEquals(agreementLineItemsLstReturn.size(),5);
            	System.assertEquals(agreementAprvlCntrlr.agrmntName,'Test Agreement Name');
            	System.assertEquals(agreementAprvlCntrlr.requestID,'12345');
            	System.assertEquals(agreementAprvlCntrlr.currCode,'EUR');
             test.stopTest();
        	 
          }
	}
	
}