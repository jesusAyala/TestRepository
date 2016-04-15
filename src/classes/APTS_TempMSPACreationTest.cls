@isTest(seeAllData=False)
private class APTS_TempMSPACreationTest {

    //private static APTS_Capture_LSO_Input_Config_Settings__c lodConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();
    private static User user;
    
    public static testMethod void copyMSPA(){
        
        APTS_Common_Config_Settings__c common1 = new APTS_Common_Config_Settings__c(name = 'Global_Record_Type', APTS_Value__c = 'Global Products');
        APTS_Common_Config_Settings__c common2 = new APTS_Common_Config_Settings__c(name = 'LP_USER_DIVISION', APTS_Value__c = 'LP');
        APTS_Common_Config_Settings__c common3 = new APTS_Common_Config_Settings__c(name = 'DEFAULT_SAP_DIVISION', APTS_Value__c = 'ZZ');
        APTS_Common_Config_Settings__c common4 = new APTS_Common_Config_Settings__c(name = 'SPAIN_LOCALE', APTS_Value__c = 'es_ES');
        APTS_Common_Config_Settings__c common5 = new APTS_Common_Config_Settings__c(name = 'DIVISION', APTS_Value__c = 'LP');
        APTS_Common_Config_Settings__c common6 = new APTS_Common_Config_Settings__c(name = 'APPROVAL_COUNTRY', APTS_Value__c = 'Spain');
        insert new List<APTS_Common_Config_Settings__c>{common1, common2, common3, common4, common5, common6};
        
        APTS_Stage_Data_Validation_Rules_Setting__c set1 = new APTS_Stage_Data_Validation_Rules_Setting__c();
        set1.name = 'DataMigration';
        set1.APTS_Validate_SFDC_User__c = true;
        insert set1;
        
        APTS_Custom_Cart_Settings__c useAdvancedApproval = new APTS_Custom_Cart_Settings__c(); 
        useAdvancedApproval.name = 'useAdvancedApproval'; 
        useAdvancedApproval.APTS_Value__c = TRUE ;        
        insert useAdvancedApproval;
        
        APTS_Custom_Cart_Settings__c useDealOptimizer = new APTS_Custom_Cart_Settings__c(); 
        useDealOptimizer.name = 'useDealOptimizer'; 
        useDealOptimizer.APTS_Value__c = TRUE ;        
        insert useDealOptimizer;
        
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
           Account acct1 =  APTS_LP_TestUtility.getNewAccount('Acct-1','US');
           insert acct1;
         Account acct = [select ID, Primary_Address_Country__c,Main_Local_City__c,Main_Local_Street__c,BillingCity,BillingStreet,BillingCountry,GUID__c 
                         from Account where GUID__c = 'G01413815' limit 1];

            List<APTS_Stage_MSPA__c> listStageMSPA =  APTS_LP_TestUtility.getStageMSPA(2);
            for(APTS_Stage_MSPA__c stageMspa : listStageMSPA){
                stageMspa.APTS_Owner__c = 'Testing';
                stageMspa.APTS_SAP_Customer_ID__c = 'Testing';
                stageMspa.APTS_Incoterms_methods_Code__c = 'Testing';
                stageMspa.APTS_Payment_Terms_SPA__c = 'Testing'; 
                stageMspa.APTS_Sales_Office_SPA__c = 'Z111';
                stageMspa.APTS_RowStatus__c = APTS_DMConstants.VALIDATION_STATUS;
                stageMspa.APTS_SPA_Identifier_SPA__c = 1;
            }
            
            insert listStageMSPA;
            
            APTS_LP_TestUtility.getSalesOffice();
            APTS_LP_TestUtility.getDistributionChannel();

            APTS_LP_Local_Customer_Reference_Data__c lcrd = new APTS_LP_Local_Customer_Reference_Data__c();
            lcrd.APTS_LP_SAP_Customer_ID__c = 'Testing';
           // lcrd.Name = 'Testing';
           lcrd.APTS_External_ID__c = 'Testing';
            lcrd.APTS_LP_Account__c = acct.id;

            insert lcrd;

            Apttus_Config2__PriceList__c prcielst = APTS_LP_TestUtility.getPriceList(acct, 'Spain');
            prcielst.Apttus_Config2__Active__c = true;
            insert prcielst;
            
            List<Product2> productList =  APTS_LP_TestUtility.getProductList(16);
            insert productList;
            
            Integer i = 1;
            List<APTS_Stage_MSPA_LineItems__c> listStageMSPALineItems =  APTS_LP_TestUtility.getStageMSPALineItems(15);
            for(APTS_Stage_MSPA_LineItems__c mspaLineItem: listStageMSPALineItems) {
                mspaLineItem.APTS_RowStatus__c = APTS_DMConstants.VALIDATION_STATUS;
                mspaLineItem.APTS_Quantity__c = 1;
                mspaLineItem.APTS_Discount_Type__c = 'Net Price Discount';
                mspaLineItem.APTS_Product_Code__c = 'P123' + i;
                mspaLineItem.APTS_Product_Level_3__c = '00M02';
                mspaLineItem.APTS_Discount__c = 77.34;
                mspaLineItem.APTS_Net_Price__c = 4.29;
                mspaLineItem.APTS_Price_1_Gross_Price__c = 28.44;
                mspaLineItem.APTS_Price_Unit__c = 1;
                mspaLineItem.APTS_Price__c = 7.57;
                mspaLineItem.APTS_SPA_Line_Item__c = i;
                mspaLineItem.APTS_SPA_Identifier__c = 1;
                i++;
                
            }
            insert listStageMSPALineItems;

            test.startTest();
            
           APTS_TempMSPACreation.createMSPA(1);
           APTS_TempMSPACreation.repriceCart('1');
           APTS_TempMSPACreation.finalizeCart('1');
           //APTS_TempMSPACreation.countRepriceCart(1);
            test.stopTest();  
       }
   }
    

    



      /* public static testMethod void repriceAndFinalize(){
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {

            List<APTS_Stage_Product__c> listLocalProduct  = APTS_LP_TestUtility.getProductList(5,APTS_DMConstants.LOCAL_PRODUCTS); 
            insert listLocalProduct;

            List<APTS_Stage_MSPA_LineItems__c> listStageMSPALineItems =  APTS_LP_TestUtility.getStageMSPALineItems(5);
            insert listStageMSPALineItems;

            List<Product2> prds = APTS_LP_TestUtility.getProductList(4);
            Integer i = 0;
            for(Product2 prd: prds){
                prd.APTS_Product_ID__c = 'Product-Code' + i;
                i++;
            }

            insert prds;

            Apttus__APTS_Agreement__c agreement = APTS_LP_TestUtility.getAgreement('Testing');
            agreement.APTS_SPA_Identifier__c = 0;
            APTS_LP_TestUtility.getDiscountConfig();
            insert agreement;

            APTS_LP_TestUtility.getCustomSetting();


            Account acct =  APTS_LP_TestUtility.getNewAccount('Acct-1','US');
            insert acct;

            List<APTS_Stage_MSPA__c> listStageMSPA =  APTS_LP_TestUtility.getStageMSPA(5);
            for(APTS_Stage_MSPA__c stageMspa : listStageMSPA){
                stageMspa.APTS_Owner__c = 'Testing';
                stageMspa.APTS_SAP_Customer_ID__c = 'Testing';
                stageMspa.APTS_Incoterms_methods_Code__c = 'Testing';
                stageMspa.APTS_Payment_Terms_SPA__c = 'Testing';
            }
            APTS_LP_TestUtility.getSalesOffice();
            APTS_LP_TestUtility.getMasterPicklistTableData();
 
            APTS_LP_Local_Customer_Reference_Data__c lcrd = new APTS_LP_Local_Customer_Reference_Data__c();
            lcrd.APTS_LP_SAP_Customer_ID__c = 'Testing';
            lcrd.Name = 'Testing';
            lcrd.APTS_LP_Account__c = acct.id;

            insert lcrd;

            Apttus_Config2__PriceList__c prcielst = APTS_LP_TestUtility.getPriceList(acct, 'Spain');
            prcielst.Apttus_Config2__Active__c = true;
            insert prcielst;

            test.startTest();
            insert acct;
           APTS_CopyDataWrapper oCopyWrapper= APTS_DMMSPAHelper.repriceAndFinalize(listStageMSPALineItems);
            test.stopTest();  
       }*/
}