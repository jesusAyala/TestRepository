/*************************************************************
@Name: APTS_DMValidateDataController
@Author: Hardik Shah  
@CreateDate: 27th October 2015
@Description: Controller Class to validate/load data of object selected by User from VF Page
@UsedBy: VF Page : APTS_DMValidateData
******************************************************************/

public class APTS_DMValidateDataController {

	public String selectedObject {
		get;
		set;
	}

    public String reportObjectSelection {get; set;}
    
	public Boolean isDisabled {
		get;
		set;
	}
    private String reportURL;
	// map is used while validating data 
	// map  contains Object-API name as key and list of Fields that needs to be queried as value

	private static Map < String, List < String >> mapQueryField;
	// map is used while copying data from staging object to standard object
	// map contains Object-API name as key and list of Fields that needs to be queried as value
	private static Map < String, List < String >> mapQueryFieldToCopy;
	// Default Batch-Job Size
	private static Integer iBatchJobSize = 200;

	public APTS_DMValidateDataController() {
		isDisabled = false;
	}

	/**
	 * 
	 * Pre-Initialize Maps and Custom-Settings
	 * 
	 * */
	static {
		// fetch the batch-Job Size
		iBatchJobSize = getBatchSize();

	}

	public PageReference checkSelectedObject() {
		if (selectedObject.equals('APTS_Stage_MSPA_LineItems__c')) {
			isDisabled = true;
		} else {
			isDisabled = false; 
		}
		return null;
	}
	
    public PageReference findValidateReport() {
        if (selectedObject != null && String.isNotBlank(selectedObject)) {
            try{
             if(APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration') != null) {            
                    if(selectedObject.equals('APTS_Stage_Product_Line_Tree__c')) {
                        reportURL = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_ProductLineTree_Validation__c;
                    } else if(selectedObject.equals('APTS_Stage_Product__c')) {
                        reportURL = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_GlobalProduct_Validation__c;
                    } else if(selectedObject.equals('APTS_Stage_Product__c_local')) {
                        reportURL = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_LocalProduct_Validation__c;
                    } else if(selectedObject.equals('APTS_Stage_Approval_Rule_Matrix__c')) {
                        reportURL = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_ApprovalMatrix_Validation__c;
                    } else if(selectedObject.equals('APTS_Stage_Local_Hierarchy__c')) {
                        reportURL = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_LocalHierachy_Validation__c;
                    } else if(selectedObject.equals('APTS_Stage_MSPA__c')) {
                        reportURL = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_MSPA_Validation__c;
                    } else if(selectedObject.equals('APTS_Stage_MSPA_LineItems__c')) {
                        reportURL = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_MSPA_LineItems_Validation__c;
                    } else if(selectedObject.equals('APTS_Stage_MSPA_Approvals__c')) {
                        reportURL = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_MSPAApproval_Validation__c;
                    } else if(selectedObject.equals('APTS_Stage_Master_Picklist__c')) {
                        reportURL = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_MasterPickList_Validation__c;
                    } else if(selectedObject.equals('APTS_Stage_Local_Operational_Data__c')) {
                        reportURL = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_LocalOperationalData_Validation__c;
                    }
             }
            }
            catch(Exception ex){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Error while Fetching CustomSettings' +ex.getMessage() ));
        }            
            if(reportURL != null && reportURL.length()>0) {
              	PageReference reportPage = new PageReference(reportURL);
        		reportPage.setRedirect(true);
            	return reportPage;
            } else {
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Custom setting setup required for selected Object: ' + getlabel(selectedObject)));
            }
        }
        else {
			system.debug('HS--> Please select A Value');
			Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, selectedObject + ': ' + LABEL.APTS_Select_A_Valid_Object));  
        }       
        return null;
    }
    
    public PageReference findValidateErrorReport() {
        if (selectedObject != null && String.isNotBlank(selectedObject)) {
            try{
             if(APTS_Capture_LSO_Input_Config_Settings__c.getValues('LP-Spain Config Settings') != null) {
                    if(selectedObject.equals('APTS_Stage_Product_Line_Tree__c')) {
                        reportURL = APTS_Capture_LSO_Input_Config_Settings__c.getValues('LP-Spain Config Settings').APTS_ProductLineTreeReport__c;
                    } else if(selectedObject.equals('APTS_Stage_Product__c')) {
                        reportURL = APTS_Capture_LSO_Input_Config_Settings__c.getValues('LP-Spain Config Settings').APTS_GlobalProductReport__c;
                    } else if(selectedObject.equals('APTS_Stage_Product__c_local')) {
                        reportURL = APTS_Capture_LSO_Input_Config_Settings__c.getValues('LP-Spain Config Settings').APTS_LocalProductReport__c;
                    } else if(selectedObject.equals('APTS_Stage_Approval_Rule_Matrix__c')) {
                        reportURL = APTS_Capture_LSO_Input_Config_Settings__c.getValues('LP-Spain Config Settings').APTS_Staging_Approval_Matrix__c;
                    } else if(selectedObject.equals('APTS_Stage_Local_Hierarchy__c')) {
                        reportURL = APTS_Capture_LSO_Input_Config_Settings__c.getValues('LP-Spain Config Settings').APTS_Local_Hierachy_Report__c;
                    } else if(selectedObject.equals('APTS_Stage_MSPA__c')) {
                        reportURL = APTS_Capture_LSO_Input_Config_Settings__c.getValues('LP-Spain Config Settings').APTS_Stage_MSPA__c;
                    } else if(selectedObject.equals('APTS_Stage_MSPA_LineItems__c')) {
                        reportURL = APTS_Capture_LSO_Input_Config_Settings__c.getValues('LP-Spain Config Settings').APTS_Stage_MSPA_LineItems__c;
                    } else if(selectedObject.equals('APTS_Stage_MSPA_Approvals__c')) {
                        reportURL = APTS_Capture_LSO_Input_Config_Settings__c.getValues('LP-Spain Config Settings').APTS_Stage_MSPA_Approval__c;
                    } else if(selectedObject.equals('APTS_Stage_Master_Picklist__c')) {
                        reportURL = APTS_Capture_LSO_Input_Config_Settings__c.getValues('LP-Spain Config Settings').APTS_Staging_Master_Pick_List__c;
                    } else if(selectedObject.equals('APTS_Stage_Local_Operational_Data__c')) {
                        reportURL = APTS_Capture_LSO_Input_Config_Settings__c.getValues('LP-Spain Config Settings').APTS_Stage_Local_Operational_Data__c;
                    }
             }
            } 
            catch(Exception ex){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Error while Fetching CustomSettings' +ex.getMessage() ));
        }
            if(reportURL != null && reportURL.length()>0) {
              	PageReference reportPage = new PageReference(reportURL);
        		reportPage.setRedirect(true);
            	return reportPage;
            } else {
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Custom setting setup required for selected Object: ' + getlabel(selectedObject) ));
            }
        }
        else {
			system.debug('HS--> Please select A Value');
			Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, selectedObject + ': ' + LABEL.APTS_Select_A_Valid_Object));  
        }       
        return null;
    }
    
    public PageReference findReconciliationReport() {
        if (selectedObject != null && String.isNotBlank(selectedObject)) {
            try{
             if(APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration') != null) {
                    if(selectedObject.equals('APTS_Stage_Product_Line_Tree__c')) {
                        reportURL = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_ProductLineTree_Reconciliation__c;
                    } else if(selectedObject.equals('APTS_Stage_Product__c')) {
                        reportURL = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_GlobalProduct_Reconciliation__c;
                    } else if(selectedObject.equals('APTS_Stage_Product__c_local')) {
                        reportURL = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_LocalProduct_Reconciliation__c;
                    } else if(selectedObject.equals('APTS_Stage_Approval_Rule_Matrix__c')) {
                        reportURL = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_ApprovalMatrix_Reconciliation__c;
                    } else if(selectedObject.equals('APTS_Stage_Local_Hierarchy__c')) {
                        reportURL = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_LocalHierachy_Reconciliation__c;
                    } else if(selectedObject.equals('APTS_Stage_MSPA__c')) {
                        reportURL = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_MSPA_Reconciliation__c;
                    } else if(selectedObject.equals('APTS_Stage_MSPA_LineItems__c')) {
                        reportURL = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_MSPA_LineItems_Reconciliation__c;
                    } else if(selectedObject.equals('APTS_Stage_MSPA_Approvals__c')) {
                        reportURL = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_MSPAApproval_Reconciliation__c;
                    } else if(selectedObject.equals('APTS_Stage_Master_Picklist__c')) {
                        reportURL = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_MasterPickList_Reconciliation__c;
                    } else if(selectedObject.equals('APTS_Stage_Local_Operational_Data__c')) {
                        reportURL = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_LocalOperationalData_Reconciliation__c;
                    }
             }
            }
            catch(Exception ex){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Error while Fetching CustomSettings' +ex.getMessage() ));
        }
            if(reportURL != null && reportURL.length()>0) {
              	PageReference reportPage = new PageReference(reportURL);
        		reportPage.setRedirect(true);
            	return reportPage;
            } else {
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'Custom setting setup required for selected Object: ' + getlabel(selectedObject) ));
            }
		}
        else {
			system.debug('HS--> Please select A Value');
			Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, selectedObject + ': ' + LABEL.APTS_Select_A_Valid_Object));  
        }       
		return null;
	}
    
   /* public String getValidateReportURL() {
        return validateReportURL;
    } */
       
	/**
	 * This method is called when user clicks on Validate button on VF
	 * This method forms the query and initiates Batch Processing for Data-Validation
	 * 
	 * */
	public PageReference test() {

		if (selectedObject != null && String.isNotBlank(selectedObject)) {

			Boolean isLocalProductSelected = false;
			system.debug('HS--> Select ObjectName' + selectedObject);
			if (selectedObject == 'APTS_Stage_Product__c_local') {
				selectedObject = 'APTS_Stage_Product__c';
				isLocalProductSelected = true;
			}

			String query = APTS_DMHelper.getQuery(selectedObject, APTS_DMConstants.INITIAL_LOAD_STATUS, 0);
			if (selectedObject.equals('APTS_Stage_Product__c') && !isLocalProductSelected) {
				query = query + ' and APTS_RecordType__c= \'Global Products\'';
			} else if (isLocalProductSelected) {
				query = query + ' and APTS_RecordType__c= \'Local Products\'';
				selectedObject = 'APTS_Stage_Product__c_local';
			}

			system.debug('Apttus--> SelectedObject : ' + query);

			//Shabbir:  modified to use more structured classes.  If want to revert back change it to APTS_ValidateData
			APTS_DMValidateData validateData = new APTS_DMValidateData(query, selectedObject);
			APTS_ScheduledJobUtility scheduleJobUtility = new APTS_ScheduledJobUtility();

			if (scheduleJobUtility.scheduleBatchJob(validateData, iBatchJobSize)) {
				Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, getlabel(selectedObject) + ': ' + LABEL.APTS_Validate_Batch_Jobs));
			} else {
				Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, getlabel(selectedObject) + ': ' + LABEL.APTS_System_Overloaded));
			}
			selectedObject = null;

		} else {
			system.debug('HS--> Please select A Value');
			Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, getlabel(selectedObject) + ': ' + LABEL.APTS_Select_A_Valid_Object));
		}

		selectedObject = null;

		return null;
	}


	/**
	 * This method is called when user clicks on Load button on VF-Page
	 * This method forms the query for Object to be loaded and initiates Batch Processing
	 * 
	 * */

	public PageReference load() {


		Boolean isLocalProductSelected = false;
		if (selectedObject != null && String.isNotBlank(selectedObject)) {
			system.debug('HS--> Copy Select ObjectName' + selectedObject);
			if (selectedObject == 'APTS_Stage_Product__c_local') {
				selectedObject = 'APTS_Stage_Product__c';
				isLocalProductSelected = true;
			}

			String query = APTS_DMHelper.getQuery(selectedObject, APTS_DMConstants.VALIDATION_STATUS, 0);
			if (selectedObject.equals('APTS_Stage_Product__c') && !isLocalProductSelected) {
				query = query + ' and APTS_RecordType__c= \'Global Products\'';
			} else if (isLocalProductSelected) {
				query = query + ' and APTS_RecordType__c= \'Local Products\'';
				selectedObject = 'APTS_Stage_Product__c_local';
			} else if (selectedObject.equals('APTS_Stage_MSPA__c')) {
				query = query + ' and APTS_SPA_Status_SPA__c  = \'Approved\' and APTS_Date_Diff_Valid_From_And_To__c >= 0';
			}

			system.debug('Apttus--> Copy Selected Object : ' + query);

			//Shabbir:  modified to use more structured classes.  If want to revert back change it to APTS_CopyStagingData
			APTS_DMCopyStagingData copyData = new APTS_DMCopyStagingData(query, selectedObject);
			APTS_ScheduledJobUtility scheduleJobUtility = new APTS_ScheduledJobUtility();

			if (scheduleJobUtility.scheduleBatchJob(copyData, iBatchJobSize)) {
				Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, getlabel(selectedObject) + ': ' + LABEL.APTS_Copy_Batch_Jobs));
			} else {
				Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, getlabel(selectedObject) + ': ' + LABEL.APTS_System_Overloaded));
			}

			selectedObject = null;
		} else {
			system.debug('HS--> Please select a object');
			Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, LABEL.APTS_Select_A_Valid_Object));
		}
		return null;

	}

	/**
	 * This method returns a list of Items that are displayed in VF-Page
	 * 
	 **/
	public List < SelectOption > getItems() {

		List < SelectOption > options = new List < SelectOption > ();
		options.add(new SelectOption('APTS_Stage_Master_Picklist__c', 'Master Picklist Tables'));
		options.add(new SelectOption('APTS_Stage_Product_Line_Tree__c', 'Product Line Tree'));
		options.add(new SelectOption('APTS_Stage_Local_Hierarchy__c', 'Local Hierarchy'));
		options.add(new SelectOption('APTS_Stage_Product__c', 'Global Product'));
		options.add(new SelectOption('APTS_Stage_Product__c_local', 'Local Product'));
		options.add(new SelectOption('APTS_Stage_Approval_Rule_Matrix__c', 'Approval Rule Matrix'));
		options.add(new SelectOption('APTS_Stage_MSPA__c', 'MSPA'));
		options.add(new SelectOption('APTS_Stage_MSPA_LineItems__c', 'MSPA-LineItems'));
		options.add(new SelectOption('APTS_Stage_MSPA_Approvals__c', 'MSPA-Approvals'));
		options.add(new SelectOption('APTS_Stage_Local_Operational_Data__c', 'Local Operational Data'));

		return options;
	}

    public String getlabel(String selectedObject) {
        List < SelectOption > Options = getItems();
        for (SelectOption so : Options) {
            if (so.getValue() == selectedObject){
               return so.getLabel();
            }
        }
        return null;
    }
    
	/**
	 * This method will get the Batch Size from CustomSettings - APTS_DataValidationBatchSize__c
	 * 
	 */

	private static Integer getBatchSize() {

		// Default BatchJob Size
		Decimal dcBatchJobSize = 200;
		Integer iJobSize = 200;
		try {

			if (APTS_Capture_LSO_Input_Config_Settings__c.getValues('LP-Spain Config Settings') != null) {
				dcBatchJobSize = APTS_Capture_LSO_Input_Config_Settings__c.getValues('LP-Spain Config Settings').APTS_DataValidationBatchSize__c;
				iJobSize = dcBatchJobSize.intValue();
				system.debug('HS--> BatchJobSize ' + iJobSize);
			}
		} catch (Exception ex) {
			system.debug('Error while Fetching CustomSettings to fetch BatchJobSize' + ex.getMessage());
		}

		return iJobSize;
	}

}