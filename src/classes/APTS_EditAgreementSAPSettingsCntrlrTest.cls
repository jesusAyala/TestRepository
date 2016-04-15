@isTest
private class APTS_EditAgreementSAPSettingsCntrlrTest {
	
	@isTest static void test_method_one() {

		APTS_Agreement_SAP_Setting__c agrementSapSettings = new APTS_Agreement_SAP_Setting__c();
		agrementSapSettings.APTS_Auto_Create_MSPA_In_SAP_On_Approval__c = true;
		agrementSapSettings.APTS_Block_MSPA_Creation_In_SAP__c = true;
		agrementSapSettings.APTS_Country__c = 'Spain';
		insert agrementSapSettings;

		Test.startTest();
		ApexPages.StandardController stdController = new ApexPages.StandardController(agrementSapSettings);
        Test.setCurrentPageReference(new PageReference('Page.APTS_EditAgreementSAPSettings')); 
		
        APTS_EditAgreementSAPSettingsController editAgrementSAPCntroler = new APTS_EditAgreementSAPSettingsController(stdController);
        PageReference ref = editAgrementSAPCntroler.init();

       System.assertEquals(ref,null);

       Test.stopTest();
	}
	
	@isTest static void test_method_two() {

		APTS_Agreement_SAP_Setting__c agrementSapSettings = new APTS_Agreement_SAP_Setting__c();
		agrementSapSettings.APTS_Auto_Create_MSPA_In_SAP_On_Approval__c = true;
		agrementSapSettings.APTS_Block_MSPA_Creation_In_SAP__c = true;
		agrementSapSettings.APTS_Country__c = 'Spain';
		insert agrementSapSettings;

		Test.startTest();
		ApexPages.StandardController stdController = new ApexPages.StandardController(agrementSapSettings);
        Test.setCurrentPageReference(new PageReference('Page.APTS_EditAgreementSAPSettings')); 
		
        APTS_EditAgreementSAPSettingsController editAgrementSAPCntroler = new APTS_EditAgreementSAPSettingsController(stdController);
        PageReference ref = editAgrementSAPCntroler.save();

       System.assertNotEquals(ref,null);

       Test.stopTest();
	}
	
}