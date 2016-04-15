@isTest
public class APTS_DMCopyStagingDataTest {

 public static testMethod void copyStageProductLineTrePositive(){
         
        PageReference pageRef = Page.APTS_DMValidateData;
        Test.setCurrentPage(pageRef);
        APTS_LP_TestUtility.getLODConfigSetting();
     	APTS_LP_TestUtility.createContact();
     
        APTS_Stage_Data_Validation_Rules_Setting__c oTemp1 = new APTS_Stage_Data_Validation_Rules_Setting__c();
        oTemp1.name = 'DataMigration';
        oTemp1.APTS_Category_Sequence__c = 'Series de empotrar;Envolventes;Service BT;Interruptores de Potencia B.T;Thomas and Betts;KNX-EIB;Aparamenta Modular;Entrelec;Control y Automatizacion';        
        insert oTemp1;    	
        
         // Test-Case for StageProductLineTree Object- Start
        List<APTS_Stage_Product_Line_Tree__c> listStageProductLineTree =  APTS_LP_TestUtility.getStageProductLineTreeList(5);
        
        for( APTS_Stage_Product_Line_Tree__c stageProduct : listStageProductLineTree){
            stageProduct.APTS_RowStatus__c  = APTS_DMConstants.INITIAL_LOAD_STATUS;
        }
        insert listStageProductLineTree;
        
        APTS_DMValidateDataController validateDataController = new APTS_DMValidateDataController();
        validateDataController.selectedObject = 'APTS_Stage_Product_Line_Tree__c';
        String query = APTS_DMHelper.getQuery(validateDataController.selectedObject,APTS_DMConstants.INITIAL_LOAD_STATUS,5);
        APTS_DMCopyStagingData validateData = new APTS_DMCopyStagingData(query, validateDataController.selectedObject);
       
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
        validateData = new APTS_DMCopyStagingData(query, validateDataController.selectedObject);
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
        validateData = new APTS_DMCopyStagingData(query, validateDataController.selectedObject);
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
        validateData = new APTS_DMCopyStagingData(query, validateDataController.selectedObject);
        Database.executeBatch(validateData,5);
        
         // Test-Case for MSPA LineItem - Start
        List<APTS_Stage_MSPA_LineItems__c> listStageMSPALineItems =  APTS_LP_TestUtility.getStageMSPALineItems(5);
    
       for( APTS_Stage_MSPA_LineItems__c stageMSPALineItems : listStageMSPALineItems){
            stageMSPALineItems.APTS_RowStatus__c  = APTS_DMConstants.INITIAL_LOAD_STATUS;
        }
        
        insert listStageMSPALineItems;
        
        validateDataController.selectedObject = 'APTS_Stage_MSPA_LineItems__c';
        query = APTS_DMHelper.getQuery(validateDataController.selectedObject,APTS_DMConstants.INITIAL_LOAD_STATUS,5);
        validateData = new APTS_DMCopyStagingData(query, validateDataController.selectedObject);
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
        //aptStgAprvl.APTS_SPA_Line_Item__c = 1;
        listStageMSPAApprovals.add(aptStgAprvl);
        insert listStageMSPAApprovals;
        
        validateDataController.selectedObject = 'APTS_Stage_MSPA_Approvals__c';
        query = APTS_DMHelper.getQuery(validateDataController.selectedObject,APTS_DMConstants.INITIAL_LOAD_STATUS,5);
        validateData = new APTS_DMCopyStagingData(query, validateDataController.selectedObject);
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
        validateData = new APTS_DMCopyStagingData(query, validateDataController.selectedObject);
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
        validateData = new APTS_DMCopyStagingData(query, validateDataController.selectedObject);
        Database.executeBatch(validateData,5);
        // Test-Case for Stage-MSPA  Data - End
    
         // Test-Case for stageLocal-Hierachy Rule Matrix - END
       
        try{    
        // Test-Case for Local Hierachy - Start
        
        Apttus_Config2__ClassificationName__c clsfcName = new Apttus_Config2__ClassificationName__c();
        clsfcName.Name = 'LP Spain';
        clsfcName.Apttus_Config2__Active__c = true;
        clsfcName.Apttus_Config2__HierarchyLabel__c = 'Test';
        clsfcName.Apttus_Config2__Type__c = 'Offering';
        insert clsfcName;


        Apttus_Config2__ClassificationHierarchy__c clsfHrchy = new Apttus_Config2__ClassificationHierarchy__c();
        clsfHrchy.Name = 'LP Spain';
        clsfHrchy.Apttus_Config2__HierarchyId__c =clsfcName.id;
        clsfHrchy.Apttus_Config2__Label__c = 'Test';
        insert clsfHrchy;
        
        Apttus_Config2__ClassificationHierarchy__c clsfHrchy1 = new Apttus_Config2__ClassificationHierarchy__c();
        clsfHrchy1.Name = '2';
        clsfHrchy1.Apttus_Config2__Level__c = 1;
        clsfHrchy1.Apttus_Config2__HierarchyId__c =clsfcName.id;
        clsfHrchy1.Apttus_Config2__Label__c = 'Test';
        clsfHrchy1.APTS_LP_Code__c = '2';
        insert clsfHrchy1;
       
       List<APTS_Stage_Local_Hierarchy__c> listStageLocalHierachy = APTS_LP_TestUtility.getLocalHierachyList(2);
    
       for( APTS_Stage_Local_Hierarchy__c stageLocalHierachy : listStageLocalHierachy){
            stageLocalHierachy.APTS_RowStatus__c  = APTS_DMConstants.INITIAL_LOAD_STATUS;
            stageLocalHierachy.APTS_Active__c = 'True';
            stageLocalHierachy.APTS_Level2_Code__c = '2';
            stageLocalHierachy.APTS_Level2_Name__c = '2';
            stageLocalHierachy.APTS_Level3_Name__c = '3';
        }
        
        insert listStageLocalHierachy;
        
        validateDataController.selectedObject = 'APTS_Stage_Local_Hierarchy__c';
        query = APTS_DMHelper.getQuery(validateDataController.selectedObject,APTS_DMConstants.INITIAL_LOAD_STATUS,5);
        validateData = new APTS_DMCopyStagingData(query, validateDataController.selectedObject);
        Database.executeBatch(validateData,5);
        // Test-Case for Local Hierachy - END 
        
        }catch(Exception ex){
            
        }
        
        // Test-Class for local Operational Data - Start
        List<APTS_Stage_Local_Operational_Data__c> listStageLocalHierachy = APTS_LP_TestUtility.getStageLocalOperationData();
        for( APTS_Stage_Local_Operational_Data__c stageLocalOperationalData : listStageLocalHierachy){
            stageLocalOperationalData.APTS_RowStatus__c  = APTS_DMConstants.INITIAL_LOAD_STATUS;
        }
        
        insert listStageLocalHierachy;
        
        validateDataController.selectedObject = 'APTS_Stage_Local_Operational_Data__c';
        query = APTS_DMHelper.getQuery(validateDataController.selectedObject,APTS_DMConstants.INITIAL_LOAD_STATUS,5);
        validateData = new APTS_DMCopyStagingData(query, validateDataController.selectedObject);
        Database.executeBatch(validateData,5);
        // Test-Class for local Operational Data - END
        
     }
     
     
     
}