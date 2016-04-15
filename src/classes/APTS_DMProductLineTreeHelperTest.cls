/*************************************************************
@Name: APTS_DMProductLineTreeHelperTest
@Author: Hardik Shah
@CreateDate: 16/11/2015
@Description: This class tests following Classes : APTS_DMProductLineTreeHelper
@UsedBy: NA
******************************************************************/
@isTest
public class APTS_DMProductLineTreeHelperTest {

    private static User user;
    private static APTS_Capture_LSO_Input_Config_Settings__c lodConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();
   
    // Test Method to Validate ProductLineTree Stage Object
    public static testMethod void validateStageProductLineTree(){
        APTS_Stage_Data_Validation_Rules_Setting__c validateUser = new APTS_Stage_Data_Validation_Rules_Setting__c();
        validateUser.name = 'DataMigration';
        validateUser.APTS_Validate_SFDC_User__c = FALSE ;        
        insert validateUser; 
            
     	user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) { 
            List<APTS_Stage_Product_Line_Tree__c> listStageProductLineTree  = APTS_LP_TestUtility.getStageProductLineTreeList(5);
            test.startTest();
            APTS_DMProductLineTreeHelper.validateProductLineTree(listStageProductLineTree);
            test.stopTest();
          }
     }
     
      // Test Method to Copy ProductLineTree Stage Object
    public static testMethod void copyStageProductLineTree(){
        APTS_Stage_Data_Validation_Rules_Setting__c validateUser = new APTS_Stage_Data_Validation_Rules_Setting__c();
        validateUser.name = 'DataMigration';
        validateUser.APTS_Validate_SFDC_User__c = FALSE ;        
        insert validateUser; 
            
     	user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) { 
            List<APTS_Stage_Product_Line_Tree__c> listStageProductLineTree  = APTS_LP_TestUtility.getStageProductLineTreeList(5);
            test.startTest();
            APTS_DMProductLineTreeHelper.copyProductLineTree(listStageProductLineTree);
            test.stopTest();
          }
     }
     
     // Test Method to Validate ProductLineTree Stage Object
    public static testMethod void validateStageProductLineTreeNegative(){
        APTS_Stage_Data_Validation_Rules_Setting__c validateUser = new APTS_Stage_Data_Validation_Rules_Setting__c();
        validateUser.name = 'DataMigration';
        validateUser.APTS_Validate_SFDC_User__c = FALSE ;        
        insert validateUser; 
            
     	user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) { 
          
            List<APTS_Stage_Product_Line_Tree__c> listStageProductLineTree  = APTS_LP_TestUtility.getStageProductLineTreeList(2);
            for(APTS_Stage_Product_Line_Tree__c stageProductLineTree : listStageProductLineTree){
                stageProductLineTree.APTS_Division__c  = null;
                stageProductLineTree.APTS_Owner__c = null;
            }
        
            test.startTest();
            APTS_LP_TestUtility.getProductLineTreeCustomSettings();
            APTS_DMProductLineTreeHelper.validateProductLineTree(listStageProductLineTree);
            test.stopTest();
          }
     }
     
       // Test Method to Copy ProductLineTree Stage Object
    public static testMethod void copyStageProductLineTreeNegative(){
        APTS_Stage_Data_Validation_Rules_Setting__c validateUser = new APTS_Stage_Data_Validation_Rules_Setting__c();
        validateUser.name = 'DataMigration';
        validateUser.APTS_Validate_SFDC_User__c = FALSE ;        
        insert validateUser; 
            
     	user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) { 
            List<APTS_Stage_Product_Line_Tree__c> listStageProductLineTree  = APTS_LP_TestUtility.getStageProductLineTreeList(5);
            
             for(APTS_Stage_Product_Line_Tree__c stageProductLineTree : listStageProductLineTree){
                stageProductLineTree.APTS_External_ID__c  = '1';
                
            }
            
            test.startTest();
            APTS_DMProductLineTreeHelper.copyProductLineTree(listStageProductLineTree);
            test.stopTest();
          }
     }

}