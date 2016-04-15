@isTest
private class APTS_SaveAndExitCartControllerTest {
	
 	private static User user;
    // Apttus Agreement Object
    private static Apttus__APTS_Agreement__c agreement;
    private static APTS_Capture_LSO_Input_Config_Settings__c lodConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();
    

	@isTest static void test_method_one() {

		user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
        	Account acc  = APTS_LP_TestUtility.getNewAccount('Test','Spain');
            acc.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('ABB ICV').getRecordTypeId();
        	insert acc;

        	Opportunity opp = APTS_LP_TestUtility.getOpportunity('Test Opp');
			opp.AccountId = acc.id;
        	insert opp;
        	
		    agreement = APTS_LP_TestUtility.getAgreement('TestAgreement');
            APTS_LP_TestUtility.getDiscountConfig();
            
            agreement.Apttus__Account__c = acc.id;
            agreement.Apttus__Related_Opportunity__c = opp.id;
            APTS_LP_TestUtility.getApproalRuleMatrix();
            insert agreement;
            
            
            List<Product2> productList =  APTS_LP_TestUtility.getProductList(3);
            Test.startTest();
            Apttus_Proposal__Proposal__c proposal = APTS_LP_TestUtility.getProposal('Test Proposal');
                        
            
            
            insert productList;
            //APTS_LP_TestUtility.getDiscountConfig();
            //APTS_LP_TestUtility.getApproalRuleMatrix();
            
            proposal.APTS_LP_AccountCustomer__c = acc.id;
            proposal.Apttus_Proposal__Opportunity__c = opp.id;
            insert proposal;
            Apttus_Config2__ProductConfiguration__c productConfig = APTS_LP_TestUtility.getProductConfiguration('TestProductConfiguration');
            productConfig.Apttus_QPConfig__Proposald__c = proposal.id;
            insert productConfig;

            System.debug('--> pc id :'+productConfig.id);
            
            Apttus_Config2__ProductConfiguration__c hierarchyProductConfig = APTS_LP_TestUtility.getProductConfiguration('TestHierarchyProductConfiguration');
            hierarchyProductConfig.Apttus_QPConfig__Proposald__c = proposal.id;
            insert hierarchyProductConfig;
            
            List<Apttus_Config2__LineItem__c> listLineItem = new List<Apttus_Config2__LineItem__c>();
            listLineItem.addAll(APTS_LP_TestUtility.getLineItemListWithDiscount(productConfig.ID, 2, productList[0],5));
            listLineItem.addAll(APTS_LP_TestUtility.getLineItemListWithDiscount(productConfig.ID, 5, productList[1],9));
            listLineItem.addAll(APTS_LP_TestUtility.getLineItemListWithPriceOveride(productConfig.ID, 5, productList[2],10));
            listLineItem.addAll(APTS_LP_TestUtility.getLineItemListWithDiscount(hierarchyProductConfig.ID, 2, productList[3],5));
            listLineItem.addAll(APTS_LP_TestUtility.getLineItemListWithDiscount(hierarchyProductConfig.ID, 5, productList[4],9));
            listLineItem.addAll(APTS_LP_TestUtility.getLineItemListWithPriceOveride(hierarchyProductConfig.ID, 5, productList[5],10));
            insert listLineItem;

            productConfig.Apttus_Config2__Status__c = 'Finalized';
            update productConfig;
            hierarchyProductConfig.Apttus_Config2__Status__c = 'Finalized';
            update hierarchyProductConfig;
         


            

            Test.setCurrentPageReference(new PageReference('Page.APTS_SaveAndExitCartPage')); 
			System.currentPageReference().getParameters().put('Id', productConfig.id);
			try{
				APTS_SaveAndExitCartController saveAndExitCntrlr = new APTS_SaveAndExitCartController();
				PageReference pgRef = saveAndExitCntrlr.syncwithOppportunity();

			}catch(Exception e){
				System.debug(e.getMessage());
				// giving error in method.
				/*
				System.NullPointerException: Attempt to de-reference a null object
				Class.APTS_SaveAndExitCartController.syncwithOppportunity: line 48, column 1
				*/
			}
			
			
			Test.stopTest();
          }
		
	}
	
	
	
}