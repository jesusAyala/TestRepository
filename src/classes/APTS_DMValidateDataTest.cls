@isTest
public class APTS_DMValidateDataTest {

     public static testMethod void validateStageProductLineTree(){
         
        PageReference pageRef = Page.APTS_DMValidateData;
        Test.setCurrentPage(pageRef);
        APTS_LP_TestUtility.getLODConfigSetting();
         
        APTS_Stage_Data_Validation_Rules_Setting__c validateUser = new APTS_Stage_Data_Validation_Rules_Setting__c(); 
        validateUser.name = 'DataMigration'; 
        validateUser.APTS_Validate_SFDC_User__c = FALSE ;        
        insert validateUser;
        
         // Test-Case for StageProductLineTree Object- Start
        List<APTS_Stage_Product_Line_Tree__c> listStageProductLineTree =  APTS_LP_TestUtility.getStageProductLineTreeList(5);
        
        for( APTS_Stage_Product_Line_Tree__c stageProduct : listStageProductLineTree){
            stageProduct.APTS_RowStatus__c  = APTS_DMConstants.INITIAL_LOAD_STATUS;
        }
        insert listStageProductLineTree;
         
        APTS_DMValidateDataController validateDataController = new APTS_DMValidateDataController();
        validateDataController.selectedObject = 'APTS_Stage_Product_Line_Tree__c';
        String query = APTS_DMHelper.getQuery(validateDataController.selectedObject,APTS_DMConstants.INITIAL_LOAD_STATUS,5);
        APTS_DMValidateData validateData = new APTS_DMValidateData(query, validateDataController.selectedObject);
       
        Database.executeBatch(validateData,5);
        
         // Test-Case for StageProductLineTree Object- Finish
        
        // Test-Case for Local-Product - Start
        List<APTS_Stage_Product__c> listLocalProduct  = APTS_LP_TestUtility.getProductList(5,APTS_DMConstants.LOCAL_PRODUCTS);
        for( APTS_Stage_Product__c localProduct : listLocalProduct){
            localProduct.APTS_RowStatus__c  = APTS_DMConstants.INITIAL_LOAD_STATUS;
        }
        insert listLocalProduct;
        
        validateDataController.selectedObject = 'APTS_Stage_Product__c';
        query = APTS_DMHelper.getQuery(validateDataController.selectedObject,APTS_DMConstants.INITIAL_LOAD_STATUS,5);
        validateDataController.selectedObject = 'APTS_Stage_Product__c_local';
        validateData = new APTS_DMValidateData(query, validateDataController.selectedObject);
        Database.executeBatch(validateData,5);
         // Test-Case for Local-Product - END
         
         // Test-Case for Global-Product - Start
        List<APTS_Stage_Product__c> listGlobalProduct  = APTS_LP_TestUtility.getProductList(5,APTS_DMConstants.GLOBAL_PRODUCTS);
        Integer i = 0;
        for( APTS_Stage_Product__c globalProduct : listGlobalProduct){
            i++;
            globalProduct.APTS_RowStatus__c  = APTS_DMConstants.INITIAL_LOAD_STATUS;
            globalProduct.name = 'XYZ' + i;
        }
        insert listGlobalProduct;
        
        validateDataController.selectedObject = 'APTS_Stage_Product__c';
        query = APTS_DMHelper.getQuery(validateDataController.selectedObject,APTS_DMConstants.INITIAL_LOAD_STATUS,5);
        validateData = new APTS_DMValidateData(query, validateDataController.selectedObject);
        Database.executeBatch(validateData,5);
         // Test-Case for Global-Product - END
    
         // Test-Case for Approval Rule Matrix - END
        List<APTS_Stage_Approval_Rule_Matrix__c> listApprovalRuleMatrix  = APTS_LP_TestUtility.getStageApprovalRuleMatrix(3);
        
        for( APTS_Stage_Approval_Rule_Matrix__c approvalRuleMatrix : listApprovalRuleMatrix){
            i++;
            approvalRuleMatrix.APTS_RowStatus__c  = APTS_DMConstants.INITIAL_LOAD_STATUS;
            
        }
        insert listApprovalRuleMatrix;
        
        validateDataController.selectedObject = 'APTS_Stage_Approval_Rule_Matrix__c';
        query = APTS_DMHelper.getQuery(validateDataController.selectedObject,APTS_DMConstants.INITIAL_LOAD_STATUS,5);
        validateData = new APTS_DMValidateData(query, validateDataController.selectedObject);
        Database.executeBatch(validateData,5);
        
         // Test-Case for Approval Rule Matrix - END
         
         
        // Test-Case for Local Hierachy - Start
       List<APTS_Stage_Local_Hierarchy__c> listStageLocalHierachy = APTS_LP_TestUtility.getLocalHierachyList(2);
    
       for( APTS_Stage_Local_Hierarchy__c stageLocalHierachy : listStageLocalHierachy){
            stageLocalHierachy.APTS_RowStatus__c  = APTS_DMConstants.INITIAL_LOAD_STATUS;
        }
        
        insert listStageLocalHierachy;
        
        validateDataController.selectedObject = 'APTS_Stage_Local_Hierarchy__c';
        query = APTS_DMHelper.getQuery(validateDataController.selectedObject,APTS_DMConstants.INITIAL_LOAD_STATUS,5);
        validateData = new APTS_DMValidateData(query, validateDataController.selectedObject);
        Database.executeBatch(validateData,5);
        // Test-Case for Local Hierachy - Start
        
         // Test-Case for MSPA LineItem - Start
        List<APTS_Stage_MSPA_LineItems__c> listStageMSPALineItems =  APTS_LP_TestUtility.getStageMSPALineItems(5);
    
       for( APTS_Stage_MSPA_LineItems__c stageMSPALineItems : listStageMSPALineItems){
            stageMSPALineItems.APTS_RowStatus__c  = APTS_DMConstants.INITIAL_LOAD_STATUS;
        }
        
        insert listStageMSPALineItems;
        
        validateDataController.selectedObject = 'APTS_Stage_MSPA_LineItems__c';
        query = APTS_DMHelper.getQuery(validateDataController.selectedObject,APTS_DMConstants.INITIAL_LOAD_STATUS,5);
        validateData = new APTS_DMValidateData(query, validateDataController.selectedObject);
        Database.executeBatch(validateData,5);
        // Test-Case for MSPA LineItem - END
        
        // Test-Case of Stage MSPA-Approvals
        List<APTS_Stage_MSPA_Approvals__c > listStageMSPAApprovals = new List<APTS_Stage_MSPA_Approvals__c>();

    APTS_Stage_MSPA_Approvals__c aptStgAprvl = new APTS_Stage_MSPA_Approvals__c();
    aptStgAprvl.APTS_SPA_Reference__c  = 'Krunal Pala';
    aptStgAprvl.APTS_Approver__c = 'Krunal Pala';
    aptStgAprvl.APTS_Delegate_Approver__c = 'Krunal Pala';
    aptStgAprvl.APTS_Actual_Approver__c='Krunal Pala';
    aptStgAprvl.APTS_Created_By__c = 'Krunal Pala';
    aptStgAprvl.APTS_Created_On__c = System.today();
    aptStgAprvl.APTS_Approval_History_Step__c = 'New';
    aptStgAprvl.APTS_RowStatus__c = APTS_DMConstants.INITIAL_LOAD_STATUS;
    
    listStageMSPAApprovals.add(aptStgAprvl);
    insert listStageMSPAApprovals;
        
        validateDataController.selectedObject = 'APTS_Stage_MSPA_Approvals__c';
        query = APTS_DMHelper.getQuery(validateDataController.selectedObject,APTS_DMConstants.INITIAL_LOAD_STATUS,5);
        validateData = new APTS_DMValidateData(query, validateDataController.selectedObject);
        Database.executeBatch(validateData,5);
         // Test-Case of Stage MSPA-Approvals-END
         
         
        // Test-Case for Master-PickList  Data - Start
       List<APTS_Stage_Master_Picklist__c> listStageMasterPickList  = APTS_LP_TestUtility.getStageMasterPicklistTableData(1);
    
       for( APTS_Stage_Master_Picklist__c stageMasterPickList : listStageMasterPickList){
            stageMasterPickList.APTS_RowStatus__c  = APTS_DMConstants.INITIAL_LOAD_STATUS;
        }
        
        insert listStageMasterPickList;
        
        validateDataController.selectedObject = 'APTS_Stage_Master_Picklist__c';
        query = APTS_DMHelper.getQuery(validateDataController.selectedObject,APTS_DMConstants.INITIAL_LOAD_STATUS,5);
        validateData = new APTS_DMValidateData(query, validateDataController.selectedObject);
        Database.executeBatch(validateData,5);
        // Test-Case for Master-PickList  Data - End
        
        // Test-Case for Stage-MSPA  Data - Start
       List<APTS_Stage_MSPA__c> listStageMSPA  = APTS_LP_TestUtility.getStageMSPA(5);
       
       i = 0;
    
       for( APTS_Stage_MSPA__c stageMSPA : listStageMSPA){
            i++;
            stageMSPA.APTS_RowStatus__c  = APTS_DMConstants.INITIAL_LOAD_STATUS;
            stageMSPA.name = 'Xyz' + i;
       }
        
        insert listStageMSPA;
        
        validateDataController.selectedObject = 'APTS_Stage_MSPA__c';
        query = APTS_DMHelper.getQuery(validateDataController.selectedObject,APTS_DMConstants.INITIAL_LOAD_STATUS,5);
        validateData = new APTS_DMValidateData(query, validateDataController.selectedObject);
        Database.executeBatch(validateData,5);
        // Test-Case for Stage-MSPA  Data - End
         
     }
     
     
}