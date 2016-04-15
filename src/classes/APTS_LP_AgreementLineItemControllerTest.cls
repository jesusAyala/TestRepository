/*************************************************************
@Name: APTS_LP_AgreementLineItemControllerTest
@Author: Hardik Shah
@CreateDate: 23/08/2015
@Description: This class tests following Classes : APTS_LP_AgreementLineItemController
@UsedBy: NA
******************************************************************
@ModifiedBy: NA
@ModifiedDate: NA
@ChangeDescription: A brief description of what was modified.
**** PS: @ModifiedBy and @ChangeDescription can be repeated multiple time, based on number of changes made to the original process.
******************************************************************/

@isTest
public class APTS_LP_AgreementLineItemControllerTest {

    // User Variable for System Admin Profile
    private static User user;
    // User Variable for Sales-User Profile
    private static User salesUser;
    // Apttus Agreement Object
    private static Apttus__APTS_Agreement__c agreement;
    // Instance of Controller Object.
    private static APTS_LP_AgreementLineItemController controller;
    // Size of Agreement and AgreementLineItems
    private static Integer count = 0;
    // Boolean value to check Existence of AgreementLineItem
    private static boolean value = false;
    
    private static APTS_Capture_LSO_Input_Config_Settings__c oLODConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();
    
    // Test-Case: To Test the code when No Agrement Exists
    public static testMethod void fetchNonExistsAgreement(){
        // Test-Case with System-Admin User
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCommonConfigSetting();
		    agreement = APTS_LP_TestUtility.getAgreement('TestAgreement');
        	controller = new APTS_LP_AgreementLineItemController();
            test.startTest();
       		controller.agreementId = agreement.id;
            List<Apttus__APTS_Agreement__c> agreementList = controller.getAgreements();
            test.stopTest();
        	system.assertEquals(null,agreementList);
           }
    	}
    
    /*
    // Test-Case: To Test the code when 1 Agrement Exists
    public static testMethod void fetchExistsAgreement(){
        
        // Test-Case with System-Admin User
		user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
            APTS_LP_TestUtility.getDiscountConfig();
          	agreement = APTS_LP_TestUtility.getAgreement('TestAgreement');
        	controller = new APTS_LP_AgreementLineItemController();
            test.startTest();
            insert agreement;
        	controller.agreementId = agreement.id;
            count = controller.getAgreements().size();
            test.stopTest();
        	//system.assertEquals(1,count );
        }
        
     } */
    
    
     // Test-Case: To Test the code when No Agrement-Line Item Exists
    public static testMethod void fetchNonExistsAgreementLineItem(){
    
        // Test-Case with System-Admin User
        	user  = APTS_LP_TestUtility.getUser();
        		System.runAs(user) {
        		APTS_LP_TestUtility.getDiscountConfig();
                APTS_LP_TestUtility.getCommonConfigSetting();
        		agreement = APTS_LP_TestUtility.getAgreement('TestAgreement');
           		controller = new APTS_LP_AgreementLineItemController();
        		test.startTest();
            	insert agreement;
        		controller.agreementId = agreement.id;
            	List<Apttus__AgreementLineItem__c> lineItem =  controller.getAgreementLineItems();
            	test.stopTest();
        		system.assertEquals(null,lineItem);
        }
        
    }
    
    // Test-Case: To Test the code when 1 Agrement-Line Item Exists
    public static testMethod void fetchExistsAgreementLineItem(){
    
        // Test-Case with System-Admin User
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCommonConfigSetting();
			agreement = APTS_LP_TestUtility.getAgreement('TestAgreement');
            test.startTest();
        	insert agreement;
        	Apttus__AgreementLineItem__c agrlineItem = APTS_LP_TestUtility.getAgreementLineItem(agreement.id);
        	insert agrlineItem;
        	controller = new APTS_LP_AgreementLineItemController();
        	controller.agreementId = agreement.id;
            value = controller.gethasLine();
            count = controller.getAgreementLineItems().size();
            test.stopTest();
            system.assertEquals(1,count);
			system.assertEquals(True,value);        	
        }
         
    }
    
    
    // Test-Case: To Test the code when 5 Agrement-Line Item Exists
    public static testMethod void fetchExistsAgreementLineItemList(){
     	
        // Test-Case with System-Admin User
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCommonConfigSetting();
        	agreement = APTS_LP_TestUtility.getAgreement('TestAgreement');
            test.startTest();
        	insert agreement;
       		List<Apttus__AgreementLineItem__c>  agrlineItemList = APTS_LP_TestUtility.getAgreementLineItemList(agreement.id,5);
        	insert agrlineItemList;
        	controller = new APTS_LP_AgreementLineItemController();
        	controller.agreementId = agreement.id;
            value = controller.gethasLine();
        	count = controller.getAgreementLineItems().size();
            test.stopTest();
            system.assertEquals(5,count);
			system.assertEquals(True,value); 
        }
      
    } 
    
}