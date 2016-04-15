/*************************************************************
@Name: APTS_DMProductHelperTest
@Author: Hardik Shah
@CreateDate: 16/11/2015
@Description: This class tests following Classes : APTS_DMProductHelper
@UsedBy: NA
******************************************************************/
@isTest

public class APTS_DMProductHelperTest {

    private static User user;
    private static APTS_Capture_LSO_Input_Config_Settings__c lodConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();

    // Test Method to Validate Global-Product (Stage Product)Object
     public static testMethod void validateGlobalProducts(){
        APTS_Stage_Data_Validation_Rules_Setting__c validateUser = new APTS_Stage_Data_Validation_Rules_Setting__c(); 
        validateUser.name = 'DataMigration'; 
        validateUser.APTS_Validate_SFDC_User__c = FALSE ;        
        insert validateUser;
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) { 
            List<APTS_Stage_Product_Line_Tree__c> listStageProductLineTree  = APTS_LP_TestUtility.getStageProductLineTreeList(5);
            test.startTest();
            insert listStageProductLineTree;
            List<APTS_Stage_Product__c> listGlobalProduct  = APTS_LP_TestUtility.getProductList(5,APTS_DMConstants.GLOBAL_PRODUCTS); 
            listGlobalProduct[0].APTS_Product_Line_ID__c='32001';
            insert listGlobalProduct;
            APTS_DMProductHelper.isValidProductId('123456');
            Set<Decimal> setProductLineIDForStageProduct = new Set<Decimal>();
            setProductLineIDForStageProduct.add(listStageProductLineTree[0].APTS_Product_Line_1_ID__c);
            setProductLineIDForStageProduct.add(listStageProductLineTree[1].APTS_Product_Line_2_ID__c);
            
            List<APTS_Product_Line_Tree__c> getProductLineTreeList=APTS_LP_TestUtility.getProductLineTreeList();
            insert getProductLineTreeList;
           
           
                    
            APTS_DMProductHelper.validateGlobalProducts(listGlobalProduct);
            test.stopTest();
      }   
    }
    
     // Test Method to Validate Global-Product (Stage Product)Object
     public static testMethod void copyGlobalProducts(){
        APTS_Stage_Data_Validation_Rules_Setting__c validateUser = new APTS_Stage_Data_Validation_Rules_Setting__c(); 
        validateUser.name = 'DataMigration'; 
        validateUser.APTS_Validate_SFDC_User__c = FALSE ;        
        insert validateUser;
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) { 
         List<APTS_Stage_Product_Line_Tree__c> listStageProductLineTree;    
         listStageProductLineTree  = APTS_LP_TestUtility.getStageProductLineTreeList(5);
         insert listStageProductLineTree;

        test.startTest();    
        List<APTS_Stage_Product__c> listGlobalProduct  = APTS_LP_TestUtility.getProductList(1,APTS_DMConstants.GLOBAL_PRODUCTS); 
        listGlobalProduct[0].APTS_Product_Line_ID__c='32002';
        insert listGlobalProduct;
        List<APTS_Product_Line_Tree__c> getProductLineTreeList=APTS_LP_TestUtility.getProductLineTreeList();
        insert getProductLineTreeList; 
      
      
        
        APTS_DMProductHelper.isValidProductId('123456');
        Set<Decimal> setProductLineIDForStageProduct = new Set<Decimal>();
        setProductLineIDForStageProduct.add(listStageProductLineTree[0].APTS_Product_Line_1_ID__c);
        setProductLineIDForStageProduct.add(listStageProductLineTree[1].APTS_Product_Line_2_ID__c);
        
             
        
        
        APTS_DMProductHelper.copyProduct(listGlobalProduct);
        test.stopTest();
      }   
    } 

}