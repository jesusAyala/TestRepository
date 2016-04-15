/*************************************************************
@Name: APTS_ValidateLinesCallbackTest
@Author: Nishi Kushwaha
@CreateDate: 08/10/2015
@Description: This class tests following Controller : APTS_ValidateLinesCallback
@UsedBy: NA
******************************************************************/

@isTest
private class APTS_ValidateLinesCallbackTest {

    private static List<Apttus__APTS_Agreement__c> testAgreement;
    private static APTS_Capture_LSO_Input_Config_Settings__c LSOInputSetting = APTS_LP_TestUtility.getLODConfigSetting();
    
    // This method fetches those Product Configuration whose status is finalized, and has
    // multiple LineItem with Positive Adjustment-Amount,NetAdjustMentPercent
    public static testMethod void fetchProductConfigurationwithMulipleLineItem() {
        
        System.runAs(APTS_LP_TestUtility.getUser()) {  
            APTS_LP_TestUtility.getCommonConfigSetting();
            List<Product2> productList =  APTS_LP_TestUtility.getProductList(3);
            Apttus__APTS_Agreement__c agreement =  APTS_LP_TestUtility.getAgreement('Test Agreement');
     
            test.startTest();
            
            insert productList;
            APTS_LP_TestUtility.getDiscountConfig();
            insert agreement;
            
            Apttus_Config2__ProductConfiguration__c productConfig = APTS_LP_TestUtility.getProductConfiguration('TestProductConfiguration');
            productConfig.Apttus_CMConfig__AgreementId__c = agreement.id;
            insert productConfig;
            
            List<Apttus_Config2__LineItem__c> listLineItems = new List<Apttus_Config2__LineItem__c>();
            
            // Get the LineItemList
            listLineItems.addAll(APTS_LP_TestUtility.getLineItemListWithPriceOveride(productConfig.ID, 2, productList[0],5));
            
            List<Apttus_Config2__LineItem__c> lineItemWithListPrice3 = APTS_LP_TestUtility.getLineItemListWithDiscount(productConfig.ID, 1, productList[1],9);
            for(Apttus_Config2__LineItem__c lineItem: lineItemWithListPrice3) {
                lineItem.APTS_Discount_Percentage__c = 233;
            }
            listLineItems.addAll(lineItemWithListPrice3);
            
            List<Apttus_Config2__LineItem__c> lineItemwithNetAdjustmountAmount1 = APTS_LP_TestUtility.getLineItemListWithPriceOveride(productConfig.ID, 3, productList[2],10);
            for(Apttus_Config2__LineItem__c lineItem: lineItemwithNetAdjustmountAmount1) {
                lineItem.APTS_Discount_Percentage__c = 23;
            }
            listLineItems.addAll(lineItemwithNetAdjustmountAmount1);
            
            listLineItems.addAll(APTS_LP_TestUtility.getLineItemListWithDiscount(productConfig.ID, 5, productList[3],9));
            
            insert listLineItems;
            
            List<String> fields = getRequiredFields('Apttus_Config2__LineItem__c');
            String soql = String.join(fields, ', ');
            soql = 'SELECT Id, Name, ' + soql + ' FROM Apttus_Config2__LineItem__c WHERE Id != null';
            system.debug('&&&&&& SS : '+soql);
        
            List<Apttus_Config2__LineItem__c> lineItems = Database.query(soql);
            system.debug('&&&&&& SS : Size : ' + lineItems.size());
            
            PageReference pref = Page.Apttus_Config2__CartDetailView;
            Test.setCurrentPage(pref);
            
            try {
            	Apttus_Config2.CallbackTester.testValidationCallback(productConfig.ID, lineItems, null, new APTS_ValidateLinesCallback());
            } catch(Exception ex) {}
            
            test.stopTest();
        }
    }
    
    private static List<String> getRequiredFields(String objectName) {
        List<String> setFields = new List<String>();
        
        for(Schema.SObjectField objFields : Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().values()) {
            Schema.DescribeFieldResult fi = objFields.getDescribe();
            
            if(fi.isCustom()) {
                setFields.add(fi.getName());
            }
        }
        return setFields;
    }
}