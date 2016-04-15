@isTest
public class APTS_DMApprovalRuleMatrixHelperTest {
    
    private static User user;
    private static APTS_Capture_LSO_Input_Config_Settings__c lodConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();
    
    // Test method to validate Stage Approval-Rule-Matrix Object
    public static testMethod void validateStageApprovalRuleMatrix(){
        APTS_Stage_Data_Validation_Rules_Setting__c validateUser = new APTS_Stage_Data_Validation_Rules_Setting__c();
        validateUser.name = 'DataMigration';
        validateUser.APTS_Validate_SFDC_User__c = FALSE ;        
        insert validateUser; 
            
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
            List<APTS_Stage_Approval_Rule_Matrix__c> listApprovalRuleMatrix  = APTS_LP_TestUtility.getStageApprovalRuleMatrix(3);
            APTS_LP_TestUtility.getCommonConfigSetting();
            for(APTS_Stage_Approval_Rule_Matrix__c stageApproval :listApprovalRuleMatrix ){
                stageApproval.APTS_Sales_Office__c = APTS_LP_TestUtility.getSalesOffice().id;
            }
            listApprovalRuleMatrix.get(0).APTS_Owner__c = '';
            
            Product2 prod = new Product2();
            prod.APTS_Hierarchy_Level__c = 3;
            prod.name = 'Test Prod';
            prod.APTS_Country_Code__c = 'ES';
            prod.APTS_LP_Is_Hierarchy__c = TRUE;
            prod.APTS_Hierarchy_Level__c = 3;
            prod.APTS_Hierarchy_Level_3_Code__c = '00996';
            prod.Description = 'Test Desc';
            prod.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(APTS_DMConstants.LOCAL_HIERACHY).getRecordTypeId();
            prod.IsActive = true;
            prod.APTS_Product_ID__c = 'P123';
            
            Test.startTest();
            insert prod;
            APTS_DMApprovalRuleMatrixHelper.validateApprovalMatrix(listApprovalRuleMatrix); 
            Test.stopTest();
        }
    }
    
    // Test method to validate Stage Approval-Rule-Matrix Object
    public static testMethod void copyStageApprovalRuleMatrix(){
        APTS_Stage_Data_Validation_Rules_Setting__c validateUser = new APTS_Stage_Data_Validation_Rules_Setting__c();
        validateUser.name = 'DataMigration';
        validateUser.APTS_Validate_SFDC_User__c = FALSE ;        
        insert validateUser; 
            
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
            List<APTS_Stage_Approval_Rule_Matrix__c> listApprovalRuleMatrix  = APTS_LP_TestUtility.getStageApprovalRuleMatrix(3);
            APTS_LP_TestUtility.getCommonConfigSetting();
            for(APTS_Stage_Approval_Rule_Matrix__c stageApproval :listApprovalRuleMatrix ){
                stageApproval.APTS_Sales_Office__c = APTS_LP_TestUtility.getSalesOffice().id;
                stageApproval.APTS_Approval_Level__c = 2;
            }
            listApprovalRuleMatrix.get(0).APTS_Owner__c = '';
            
            Test.startTest();
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_DMApprovalRuleMatrixHelper.copyApprovalMatrix(listApprovalRuleMatrix); 
            Test.stopTest();
        }
    }
}