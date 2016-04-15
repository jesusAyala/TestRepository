/*************************************************************
@Name: APTS_DMValidateData
@Author: Shabbir Lahori
@CreateDate: 12th November 2015
@Description: Batch-Class to validate data of Object selected by User from VF Page.  This has been borrowed from APTS_ValidateData and being structured to have relevant helper classes instead of just 1 helper class
@UsedBy: APTS_ValidateDataController.cls
******************************************************************/

global class APTS_DMValidateData implements Database.Batchable<sObject>{
  
   // Query Parameter
   global final String sQuery;
   // API-Name of Selected Object
   global final String sObjectName;
   
   // Constructor
   global APTS_DMValidateData(String query, String ObjectName){
        sQuery = query;
        sObjectName = ObjectName;
    }
    
   // Start Method of Constructor     
   global Database.QueryLocator start(Database.BatchableContext BC){
     return Database.getQueryLocator(sQuery);
   }
    
   // Execute Method of batch Class. 
   // Based on the Selected Object by user, it callls corresponding Validation Methods
   global void execute(Database.BatchableContext BC, List<sObject> scope){
    
    system.debug('HS--> Inside Execute' + sObjectName);
    
    // Validation for ProductLineTree Object
    if(sObjectName.equals('APTS_Stage_Product_Line_Tree__c')){
        
        List<APTS_Stage_Product_Line_Tree__c>  listStageProductLineTree = (List<APTS_Stage_Product_Line_Tree__c> ) scope;
        system.debug('HS--> IF Inside Execute of ProductLineTree');
        APTS_DMProductLineTreeHelper.validateProductLineTree(listStageProductLineTree);
        
    }
    // Validation for Product (Record-Type Global Products) Object
    else if(sObjectName.equals('APTS_Stage_Product__c')){
        
        List<APTS_Stage_Product__c>  listGlobalProducts = (List<APTS_Stage_Product__c> ) scope;
        system.debug('HS--> IF Inside Execute of Product2' + listGlobalProducts.size() );
        APTS_DMProductHelper.validateGlobalProducts(listGlobalProducts);
        
    }
    // Validation for Product (Record-Type Local Products) Object
    else if(sObjectName.equals('APTS_Stage_Product__c_local')){
        
        List<APTS_Stage_Product__c>  listLocalProducts = (List<APTS_Stage_Product__c> ) scope;
        system.debug('HS--> IF Inside Execute of local Products' + listLocalProducts.size() );
        APTS_DMLocalProductHelper.validateLocalProducts(listLocalProducts);
    }
     // Validation for Stage Approval Rule Matrix Object 
    else if(sObjectName.equals('APTS_Stage_Approval_Rule_Matrix__c')){
        
        List<APTS_Stage_Approval_Rule_Matrix__c>  listApprovalMatrix = (List<APTS_Stage_Approval_Rule_Matrix__c> ) scope;
        system.debug('HS--> IF Inside Execute of listApprovalMatrix ' + listApprovalMatrix.size() );
        APTS_DMApprovalRuleMatrixHelper.validateApprovalMatrix(listApprovalMatrix);
    }
    else if(sObjectName.equals('APTS_Stage_Local_Hierarchy__c')){
        List<APTS_Stage_Local_Hierarchy__c>  listLocalHierachy = (List<APTS_Stage_Local_Hierarchy__c> ) scope;
        system.debug('HS--> IF Inside Execute of local Products' + listLocalHierachy.size() );
        APTS_DMLocalHierarchyHelper.validateLocalHierachy(listLocalHierachy);
        
    }else if(sObjectName.equals('APTS_Stage_MSPA__c')){
        List<APTS_Stage_MSPA__c>  listStageMSPA = (List<APTS_Stage_MSPA__c> ) scope;
        system.debug('HS--> IF Inside Execute of Stage MSPA' + listStageMSPA.size() );
        APTS_DMMSPAHelper.validateStageMSPA(listStageMSPA);
        
    }else if(sObjectName.equals('APTS_Stage_MSPA_LineItems__c')){
        List<APTS_Stage_MSPA_LineItems__c>  listMSPALineItems = (List<APTS_Stage_MSPA_LineItems__c> ) scope;
        system.debug('HS--> IF Inside Execute of Stage MSPA LineItems' + listMSPALineItems.size() );
        APTS_DMMSPALineItemHelper.validateStageMSPALineItems(listMSPALineItems);
        
    }
    else if(sObjectName.equals('APTS_Stage_MSPA_Approvals__c')){
        List<APTS_Stage_MSPA_Approvals__c>  listStageMSPAApproval = (List<APTS_Stage_MSPA_Approvals__c> ) scope;
        system.debug('HS--> IF Inside Execute of Stage MSPA LineItems' + listStageMSPAApproval.size() );
        //TODO:  This needs to be moved to a seperate file as other items
        APTS_DMStageMSPAApprovalHelper.validateStageMSPAApprovals(listStageMSPAApproval);
        
    }
    else if(sObjectName.equals('APTS_Stage_Local_Operational_Data__c')){
        List<APTS_Stage_Local_Operational_Data__c>  listStageLOD = (List<APTS_Stage_Local_Operational_Data__c> ) scope;
        system.debug('HS--> IF Inside Execute of Stage MSPA LineItems' + listStageLOD.size() );
        APTS_DMLODHelper.validateLocalOperationalData(listStageLOD);
        
    }
    else if(sObjectName.equals('APTS_Stage_Master_Picklist__c')){
        List<APTS_Stage_Master_Picklist__c>  listStageMasterPick = (List<APTS_Stage_Master_Picklist__c> ) scope;
        system.debug('HS--> IF Inside Execute of Stage Master Pick List' + listStageMasterPick.size() );
        APTS_DMMasterPicklistTableHelper.validateStageMasterPickList(listStageMasterPick);
         
    }
 
    
  } 
  
   // finish method of Batch-Class
   // This method fetches report-id based on corresponding object.
   global void finish(Database.BatchableContext BC){
        
        String sReportId = '';
       	String sValidationReportId = '';
        String sObjectName1 = '';
        try{
             if(APTS_Capture_LSO_Input_Config_Settings__c.getValues('LP-Spain Config Settings') != null && 
                APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration') != null) {
                    
                     // Get the Report-Id for Stage-ProductLineTree Object
                    if(sObjectName.equals('APTS_Stage_Product_Line_Tree__c')){
                        sReportId = APTS_Capture_LSO_Input_Config_Settings__c.getValues('LP-Spain Config Settings').APTS_ProductLineTreeReport__c;
                        sValidationReportId = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_ProductLineTree_Validation__c;
                        sObjectName1 = 'Product Line Tree';
                        
                    }
                    // Get the Report-Id for Stage-Product (RecordType Global Product) Object
                    else if(sObjectName.equals('APTS_Stage_Product__c')){
                         sReportId = APTS_Capture_LSO_Input_Config_Settings__c.getValues('LP-Spain Config Settings').APTS_GlobalProductReport__c;
                         sValidationReportId = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_GlobalProduct_Validation__c;
                         sObjectName1 = 'Global Products';
                        
                    }
                    // Get the Report-Id for Stage-Product (RecordType LocalProduct) Object
                    else if(sObjectName.equals('APTS_Stage_Product__c_local')){
                        sReportId = APTS_Capture_LSO_Input_Config_Settings__c.getValues('LP-Spain Config Settings').APTS_LocalProductReport__c;
                        sValidationReportId = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_LocalProduct_Validation__c;
                        sObjectName1 = 'Local Products';
                         
                    }
                    // Get the Report-Id for Stage Approval Matrix  Object
                    else if(sObjectName.equals('APTS_Stage_Approval_Rule_Matrix__c')){
                         sReportId = APTS_Capture_LSO_Input_Config_Settings__c.getValues('LP-Spain Config Settings').APTS_Staging_Approval_Matrix__c;
                         sValidationReportId = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_ApprovalMatrix_Validation__c;
                         sObjectName1 = 'Approval Rule Matrix';
                    }
                    // Get the Report-Id for Stage Local Hierachy
                    else if(sObjectName.equals('APTS_Stage_Local_Hierarchy__c')){
                         sReportId = APTS_Capture_LSO_Input_Config_Settings__c.getValues('LP-Spain Config Settings').APTS_Local_Hierachy_Report__c;
                         sValidationReportId = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_LocalHierachy_Validation__c;
                         sObjectName1 = 'Local Hierarchy';
                    }
                    // Get the Report-Id for Stage MSPA
                    else if(sObjectName.equals('APTS_Stage_MSPA__c')){
                         sReportId = APTS_Capture_LSO_Input_Config_Settings__c.getValues('LP-Spain Config Settings').APTS_Stage_MSPA__c;
                         sValidationReportId = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_MSPA_Validation__c;
                         sObjectName1 = 'MSPA';
                    }
                    // Get the Report-Id for Stage MSPA LineItems 
                    else if(sObjectName.equals('APTS_Stage_MSPA_LineItems__c')){
                         sReportId = APTS_Capture_LSO_Input_Config_Settings__c.getValues('LP-Spain Config Settings').APTS_Stage_MSPA_LineItems__c;
                         sValidationReportId = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_MSPA_LineItems_Validation__c;
                         sObjectName1 = 'MSPA LineItems';
                    }
                    else if(sObjectName.equals('Stage_MSPA_Approvals__c')){
                         sReportId = APTS_Capture_LSO_Input_Config_Settings__c.getValues('LP-Spain Config Settings').APTS_Stage_MSPA_Approval__c;
                         sValidationReportId = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_MSPAApproval_Validation__c;
                         sObjectName1 = 'MSPA Approvals';
                    }
                    else if(sObjectName.equals('Stage_Master_Picklist__c')){
                         sReportId = APTS_Capture_LSO_Input_Config_Settings__c.getValues('LP-Spain Config Settings').APTS_Staging_Master_Pick_List__c;
                         sValidationReportId = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_MasterPickList_Validation__c;
                         sObjectName1 = 'Master PickList';
                    }else if(sObjectName.equals('APTS_Stage_Local_Operational_Data__c')){
                         sReportId = APTS_Capture_LSO_Input_Config_Settings__c.getValues('LP-Spain Config Settings').APTS_Stage_Local_Operational_Data__c;
                         sValidationReportId = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_LocalOperationalData_Validation__c;
                         sObjectName1 = 'Local Operational Data';
                    }
                    
                    system.debug('HS--> Report Ids for:' + sObjectName1 + ':' +  sReportId + ',' + sValidationReportId);
               }
        }
        
        catch(Exception ex){
            system.debug('Error while Fetching CustomSettings' +ex.getMessage());
        }
        
        AsyncApexJob a = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, CreatedBy.Email
	                    FROM AsyncApexJob WHERE Id = :BC.getJobId()];
        
        String sBody = ' Hi <br/><br/> Batch Job to validate ' + sObjectName1 + ' data has completed, ' +
                        '<br/><br/> Please refer to details Below. <br/><br/> Job-ID: '+ a.ID+ '<br/><br/> Job-Status: '+ a.Status+ '<br/><br/> Total Job Items: '+
                        a.TotalJobItems+ '<br/><br/> Job Items Processed: '+ a.JobItemsProcessed+ '<br/><br/> Error Report: ' +sReportId + 
            			'<br/> Validation Report: '+sValidationReportId;
        APTS_EmailUtility.sendEmail(sBody,sObjectName1 + ' Validation Report');
        
       
   }
}