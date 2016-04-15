/*************************************************************
@Name: APTS_DMMSPALineItemHelperTest
@Author: Hardik Shah
@CreateDate: 16/11/2015
@Description: This class tests following Classes : APTS_DMMSPALineItemHelper
@UsedBy: NA
******************************************************************/
@isTest(seeAllData = false)
public class APTS_DMMSPALineItemHelperTest {

    private static User user;
    //private static APTS_Capture_LSO_Input_Config_Settings__c lodConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();
   
    // Test Method to Validate Stage MSPA-Line Items
    public static testMethod void validateStageMSPALineItems(){
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
        List<APTS_Stage_Product__c> listLocalProduct  = APTS_LP_TestUtility.getProductList(5,APTS_DMConstants.LOCAL_PRODUCTS); 
        List<APTS_Stage_MSPA_LineItems__c> listStageMSPALineItems =  APTS_LP_TestUtility.getStageMSPALineItems(5);
        test.startTest();
        insert listLocalProduct;
        APTS_DMMSPALineItemHelper.validateStageMSPALineItems(listStageMSPALineItems);
        test.stopTest();  
       }
    } 
    
     // Test Method to Validate Stage MSPA-Line Items
    public static testMethod void copyStageMSPALineItemToLineItem1(){
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
        
        APTS_LP_TestUtility.getDiscountConfig();
        APTS_LP_TestUtility.getCustomSetting();
        APTS_LP_TestUtility.getCommonConfigSetting();
        //Account acc = APTS_LP_TestUtility.getNewAccount('Test Acc','Spain');
        Account acct1 =  APTS_LP_TestUtility.getNewAccount('Acct-1','US');
	    insert acct1;
        Account acc = [select ID, Primary_Address_Country__c,Main_Local_City__c,Main_Local_Street__c,BillingCity,BillingStreet,BillingCountry,GUID__c 
                         from Account where GUID__c = 'G01413815' limit 1];
        
        List<APTS_Stage_Product__c> listLocalProduct  = APTS_LP_TestUtility.getProductList(1,APTS_DMConstants.LOCAL_PRODUCTS);
       
       Product2 oProduct2 = APTS_LP_TestUtility.getProduct();
       oProduct2.APTS_Product_ID__c = 'Product-Code' + 0;
       
        List<APTS_Stage_MSPA_LineItems__c> listStageMSPALineItems =  APTS_LP_TestUtility.getStageMSPALineItems(5);
        
        Apttus__APTS_Agreement__c agreement = APTS_LP_TestUtility.getAgreement('Test');
        
        List<APTS_Stage_MSPA_LineItems__c> listMSPALineItems =  APTS_LP_TestUtility.getStageMSPALineItems(5);    
        
       
        agreement.APTS_SPA_Identifier__c = 0;
        test.startTest();
        
        insert oProduct2;
        //insert acc;
        
        Apttus_Config2__PriceList__c priceList = APTS_LP_TestUtility.getPriceList(acc,'Spain');
        insert priceList;
         
        agreement.Apttus_CMConfig__PriceListId__c = priceList.id;
        agreement.APTS_Locale__c = 'es_ES';
        
        insert listLocalProduct;
        upsert agreement;
        insert listStageMSPALineItems;
        
       
        APTS_DMMSPALineItemHelper.copyStageMSPALineItemToLineItem(listStageMSPALineItems);
        test.stopTest();  
       }
    } 


}