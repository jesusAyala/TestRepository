@isTest
private class APTS_LocalCountryAdminConsoleCntrlrTest {
	
	@isTest static void test_method_one() {
		APTS_LocalCountryAdminConsoleController lCntryAdminCntrlr = new APTS_LocalCountryAdminConsoleController();
		System.assertNotEquals(lCntryAdminCntrlr.discountsConfigKeyPrefix,null);
		System.assertNotEquals(lCntryAdminCntrlr.delegateApproverURL,null);
		System.assertNotEquals(lCntryAdminCntrlr.templateURL,null);
		System.assertNotEquals(lCntryAdminCntrlr.masterPicklistTableURL,null);
		System.assertNotEquals(lCntryAdminCntrlr.approvalRuleMatrixURL,null);
		System.assertNotEquals(lCntryAdminCntrlr.agreementSAPSettingURL,null);
	}
	
	
	
}