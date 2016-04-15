/*************************************************************
@Name: APTS_MSPAWithoutChangesControllerTest
@Author: Nishi Kushwaha
@CreateDate: 26/09/2015
@Description: This class tests following Classes : APTS_MSPAWithoutChangesController
@UsedBy: NA
******************************************************************/

@isTest
private class APTS_MSPAWithoutChangesControllerTest {
    
    private static APTS_Capture_LSO_Input_Config_Settings__c oLODConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();

    //Test method when flag is true in the query string
	private static testMethod void testWhenFlagIsTrue() {
        
        System.runAs(APTS_LP_TestUtility.getUser()){
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCommonConfigSetting();
            Apttus_Proposal__Proposal__c proposal = getQuoteProposal();
            PageReference pref = Page.APTS_MSPAWithoutChangesPage;
            Test.setCurrentPage(pref);
            ApexPages.currentPage().getParameters().put('Id', proposal.Id);
            ApexPages.currentPage().getParameters().put('Flag', 'true');
            
            APTS_MSPAWithoutChangesController obj = new APTS_MSPAWithoutChangesController();       
            Test.startTest();
            obj.createMSPAWithoutChanges();       
            Test.stopTest();
        }
	}
    
     //Test method when flag is false in the query string
    private static testMethod void testWhenFlagIsFalse() {
        
        System.runAs(APTS_LP_TestUtility.getUser()){
        	APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCommonConfigSetting();
            Apttus_Proposal__Proposal__c proposal = getQuoteProposal();
            PageReference pref = Page.APTS_MSPAWithoutChangesPage;
            Test.setCurrentPage(pref);
            ApexPages.currentPage().getParameters().put('Id', proposal.Id);
            ApexPages.currentPage().getParameters().put('Flag', 'false');        
            
            APTS_MSPAWithoutChangesController obj = new APTS_MSPAWithoutChangesController();
    
            Test.startTest();
            obj.createMSPAWithoutChanges();        
            Test.stopTest();
    	}
	}

    //Get newly inserted Proposal
     public static Apttus_Proposal__Proposal__c getQuoteProposal(){
        APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
       	User user =  APTS_LP_TestUtility.getUser('Spain');
       	Account  acc =  APTS_LP_TestUtility.getNewAccount('Test-Account', 'Spain');
       	insert acc;
        Apttus_Config2__PriceList__c  testPriceList = APTS_LP_TestUtility.getPriceList(acc,'Spain');
        insert testPriceList;
        Apttus_Proposal__Proposal__c  proposal = APTS_LP_TestUtility.getProposal('TestProposal');
        proposal.Apttus_QPConfig__PriceListId__c = testPriceList.Id;
        insert proposal;
        return proposal;
    }
}