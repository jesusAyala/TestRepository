/*************************************************************
@Name: APTS_DMValidateDataControllerTest
@Author: Rajiv Bhatt,Hardik Shah
@CreateDate: 09/11/2015
@Description: This class tests following Classes : APTS_DMValidateDataController
@UsedBy: NA
******************************************************************/

@isTest 
private class APTS_DMValidateDataControllerTest{

    //private static APTS_Capture_LSO_Input_Config_Settings__c lodConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();
    private static boolean createdCustomSetting = false;
    
    public static testMethod void  validateDataTest() {
        if(!createdCustomSetting) {
            createCustomSettings();
        }

        PageReference pageRef = Page.APTS_DMValidateData;
        Test.setCurrentPage(pageRef);
        APTS_LP_TestUtility.getLODConfigSetting();
        
        APTS_DMValidateDataController validateDataController = new APTS_DMValidateDataController();
       
        // insert Product
        APTS_Stage_Product__c stageProductSo  = New APTS_Stage_Product__c();
      
        stageProductSo.APTS_Distribution_Channel__c= 'BT';
        stageProductSo.APTS_Sales_Organization__c= 'ABB';
        stageProductSo.APTS_Country_Code__c= 'ES';
        stageProductSo.APTS_LP_Product_Hierarchy__c= '0000900E0200001652';
        stageProductSo.APTS_Product_ID__c= 'ZN6000';
        stageProductSo.APTS_RecordType__c = 'Global Products';
        
        insert stageProductSo;
        
        validateDataController.selectedObject= null;
        PageReference p12 = validateDataController.test();
        										
        validateDataController.selectedObject= 'APTS_Stage_Product__c_local';
        PageReference p10 = validateDataController.test();
        
        validateDataController.selectedObject= 'APTS_Stage_Product__c';
        PageReference p11 = validateDataController.test();
        
        validateDataController.selectedObject='APTS_Stage_Product_Line_Tree__c';
        PageReference p1 = validateDataController.test();
        
        validateDataController.selectedObject='APTS_Stage_Product_Line_Tree__c';
        p1 = validateDataController.test();
        
        validateDataController.selectedObject='APTS_Stage_Local_Hierarchy__c';
        PageReference p2 = validateDataController.test();
               
        validateDataController.selectedObject='APTS_Stage_MSPA__c';
        PageReference p3 = validateDataController.test();
               
        validateDataController.selectedObject='APTS_Stage_MSPA_LineItems__c';
        PageReference p4 = validateDataController.test();
        
        validateDataController.selectedObject='APTS_Stage_Master_Picklist__c';
        PageReference p5 = validateDataController.test();
       
        validateDataController.selectedObject='APTS_Stage_MSPA_Approvals__c';
        PageReference p6 = validateDataController.test(); 
     }
        
    public static testMethod void  validateLoadTest() {
        if(!createdCustomSetting) {
            createCustomSettings();
        }
        
        PageReference pageRef = Page.APTS_DMValidateData;
        Test.setCurrentPage(pageRef);
        APTS_DMValidateDataController validateDataController = new APTS_DMValidateDataController();
        validateDataController.getItems();
        validateDataController.selectedObject='APTS_Stage_Product__c';
        APTS_LP_TestUtility.getLODConfigSetting();
        // insert Product
        APTS_Stage_Product__c stageProductSo  = New APTS_Stage_Product__c();
        stageProductSo.APTS_RecordType__c= 'Global Products';
        stageProductSo.APTS_Distribution_Channel__c= 'BT';
        stageProductSo.APTS_Sales_Organization__c= 'ABB';
        stageProductSo.APTS_Country_Code__c= 'ES';
        stageProductSo.APTS_LP_Product_Hierarchy__c= '0000900E0200001652';
        stageProductSo.APTS_Product_ID__c= 'ZN6000';
        insert stageProductSo;
        
        validateDataController.selectedObject= null;
        PageReference p12 = validateDataController.load();
        
        validateDataController.selectedObject= 'APTS_Stage_Product__c_local';
        PageReference p10 = validateDataController.load();
        
        validateDataController.selectedObject= 'APTS_Stage_Product__c';
        PageReference p11 = validateDataController.load();
        
        validateDataController.selectedObject='APTS_Stage_Product_Line_Tree__c';
        PageReference x1 = validateDataController.load();
        
        validateDataController.selectedObject='APTS_Stage_Local_Hierarchy__c';
        PageReference x2 = validateDataController.load();
        
        validateDataController.selectedObject='APTS_Stage_MSPA__c';
        PageReference x3 = validateDataController.load();
       
        validateDataController.selectedObject='APTS_Stage_MSPA_LineItems__c';
        PageReference x4 = validateDataController.load();
        
        validateDataController.selectedObject='APTS_Stage_Master_Picklist__c';
        PageReference x5 = validateDataController.load();
        
        validateDataController.selectedObject='APTS_Stage_MSPA_Approvals__c';
        PageReference x6 = validateDataController.load();
       
    }
    
    public static testMethod void  validateReportButtonsTest() {
        if(!createdCustomSetting) {
            createCustomSettings();
        }
 		PageReference reportPage = new PageReference('testing');
        PageReference pageRef = Page.APTS_DMValidateData;
        Test.setCurrentPage(pageRef);
        APTS_DMValidateDataController validateDataController = new APTS_DMValidateDataController();
        validateDataController.getItems();
     
        validateDataController.selectedObject= null;
        PageReference p1 = validateDataController.findValidateReport();
        system.assertEquals(null, p1);
        PageReference q1 = validateDataController.findValidateErrorReport();
        system.assertEquals(null, q1);
        PageReference r1 = validateDataController.findReconciliationReport();
        system.assertEquals(null, r1);
        
        validateDataController.selectedObject= 'APTS_Stage_Product__c_local';
        PageReference p2 = validateDataController.findValidateReport();
        system.assertEquals(reportPage.getUrl(), p2.getUrl());
        PageReference q2 = validateDataController.findValidateErrorReport();
        system.assertEquals(reportPage.getUrl(), q2.getUrl());
        PageReference r2 = validateDataController.findReconciliationReport();
        system.assertEquals(reportPage.getUrl(), r2.getUrl());        
        
        validateDataController.selectedObject= 'APTS_Stage_Product__c';
        PageReference p3 = validateDataController.findValidateReport();
        system.assertEquals(reportPage.getUrl(), p3.getUrl());
        PageReference q3 = validateDataController.findValidateErrorReport();
        system.assertEquals(reportPage.getUrl(), q3.getUrl());
        PageReference r3 = validateDataController.findReconciliationReport();
        system.assertEquals(reportPage.getUrl(), r3.getUrl());
        
        validateDataController.selectedObject='APTS_Stage_Product_Line_Tree__c';
        PageReference p4 = validateDataController.findValidateReport();
        system.assertEquals(reportPage.getUrl(), p4.getUrl());
        PageReference q4 = validateDataController.findValidateErrorReport();
        system.assertEquals(reportPage.getUrl(), q4.getUrl());
        PageReference r4 = validateDataController.findReconciliationReport();
        system.assertEquals(reportPage.getUrl(), r4.getUrl());
        
        validateDataController.selectedObject='APTS_Stage_Local_Hierarchy__c';
        PageReference p5 = validateDataController.findValidateReport();
        system.assertEquals(reportPage.getUrl(), p5.getUrl());
        PageReference q5 = validateDataController.findValidateErrorReport();
        system.assertEquals(reportPage.getUrl(), q5.getUrl());
        PageReference r5 = validateDataController.findReconciliationReport();
        system.assertEquals(reportPage.getUrl(), r5.getUrl());
        
        validateDataController.selectedObject='APTS_Stage_MSPA__c';
        PageReference p6 = validateDataController.findValidateReport();
        system.assertEquals(reportPage.getUrl(), p6.getUrl());
        PageReference q6 = validateDataController.findValidateErrorReport();
        system.assertEquals(reportPage.getUrl(), q6.getUrl());
        PageReference r6 = validateDataController.findReconciliationReport();
        system.assertEquals(reportPage.getUrl(), r6.getUrl());
        
        validateDataController.selectedObject='APTS_Stage_MSPA_LineItems__c';
        PageReference p7 = validateDataController.findValidateReport();
        system.assertEquals(reportPage.getUrl(), p7.getUrl());
        PageReference q7 = validateDataController.findValidateErrorReport();
        system.assertEquals(reportPage.getUrl(), q7.getUrl());
        PageReference r7 = validateDataController.findReconciliationReport();
        system.assertEquals(reportPage.getUrl(), r7.getUrl());
        
        validateDataController.selectedObject='APTS_Stage_Master_Picklist__c';
        PageReference p8 = validateDataController.findValidateReport();
        system.assertEquals(reportPage.getUrl(), p8.getUrl());
        PageReference q8 = validateDataController.findValidateErrorReport();
        system.assertEquals(reportPage.getUrl(), q8.getUrl());
        PageReference r8 = validateDataController.findReconciliationReport();
        system.assertEquals(reportPage.getUrl(), r8.getUrl());
        
        validateDataController.selectedObject='APTS_Stage_MSPA_Approvals__c';
        PageReference p9 = validateDataController.findValidateReport();
        system.assertEquals(reportPage.getUrl(), p9.getUrl());
        PageReference q9 = validateDataController.findValidateErrorReport();
        system.assertEquals(reportPage.getUrl(), q9.getUrl());
        PageReference r9 = validateDataController.findReconciliationReport();
        system.assertEquals(reportPage.getUrl(), r9.getUrl());
        
        validateDataController.selectedObject='APTS_Stage_Local_Operational_Data__c';
        PageReference p10 = validateDataController.findValidateReport();
        system.assertEquals(reportPage.getUrl(), p10.getUrl());
        PageReference q10 = validateDataController.findValidateErrorReport();
        system.assertEquals(reportPage.getUrl(), q10.getUrl()); 
        PageReference r10 = validateDataController.findReconciliationReport();
        system.assertEquals(reportPage.getUrl(), r10.getUrl());
    }
    
    private static void createCustomSettings() {
        createdCustomSetting = true;
        
        APTS_Stage_Data_Validation_Rules_Setting__c cusSetting1 = new APTS_Stage_Data_Validation_Rules_Setting__c(); 
        cusSetting1.name = 'DataMigration'; 
        cusSetting1.APTS_Validate_SFDC_User__c = FALSE ;  
        cusSetting1.APTS_LocalHierachy_Validation__c = 'testing';
        cusSetting1.APTS_ProductLineTree_Validation__c = 'testing';
        cusSetting1.APTS_GlobalProduct_Validation__c = 'testing';
        cusSetting1.APTS_LocalProduct_Validation__c = 'testing';
        cusSetting1.APTS_ApprovalMatrix_Validation__c = 'testing';
        cusSetting1.APTS_MSPA_Validation__c = 'testing';
        cusSetting1.APTS_MSPA_LineItems_Validation__c = 'testing';
        cusSetting1.APTS_MSPAApproval_Validation__c = 'testing';
        cusSetting1.APTS_MasterPickList_Validation__c = 'testing';
        cusSetting1.APTS_LocalOperationalData_Validation__c = 'testing';
        cusSetting1.APTS_LocalHierachy_Reconciliation__c = 'testing';
        cusSetting1.APTS_ProductLineTree_Reconciliation__c = 'testing';
        cusSetting1.APTS_GlobalProduct_Reconciliation__c = 'testing';
        cusSetting1.APTS_LocalProduct_Reconciliation__c = 'testing';
        cusSetting1.APTS_ApprovalMatrix_Reconciliation__c = 'testing';
        cusSetting1.APTS_MSPA_Reconciliation__c = 'testing';
        cusSetting1.APTS_MSPA_LineItems_Reconciliation__c = 'testing';
        cusSetting1.APTS_MSPAApproval_Reconciliation__c = 'testing';
        cusSetting1.APTS_MasterPickList_Reconciliation__c = 'testing';
        cusSetting1.APTS_LocalOperationalData_Reconciliation__c = 'testing';
        insert cusSetting1;

        APTS_Capture_LSO_Input_Config_Settings__c cusSetting2 = new APTS_Capture_LSO_Input_Config_Settings__c(); 
        cusSetting2.name = 'LP-Spain Config Settings';
        cusSetting2.APTS_Distribution_Channel_Values__c ='BT, NI';
        cusSetting2.APTS_MSPA_Record_Type__c ='MSPA';
        cusSetting2.APTS_Quotation_Record_Type__c ='LP';
        cusSetting2.APTS_Sales_Organization_Values__c ='ABB';
        cusSetting2.APTS_SAP_Division_Values__c = 'ZZ';
        cusSetting2.APTS_Default_SAP_Customer_ID__c = '80006275';
        cusSetting2.APTS_ProductLineTreeReport__c = 'testing'; 
        cusSetting2.APTS_GlobalProductReport__c = 'testing';
        cusSetting2.APTS_LocalProductReport__c = 'testing';
        cusSetting2.APTS_Staging_Approval_Matrix__c = 'testing';
        cusSetting2.APTS_Local_Hierachy_Report__c = 'testing';
        cusSetting2.APTS_Stage_MSPA__c = 'testing';
        cusSetting2.APTS_Stage_MSPA_LineItems__c = 'testing';
        cusSetting2.APTS_Stage_MSPA_Approval__c = 'testing';
        cusSetting2.APTS_Staging_Master_Pick_List__c = 'testing';
        cusSetting2.APTS_Stage_Local_Operational_Data__c = 'testing';
        insert cusSetting2;
    }
    
}