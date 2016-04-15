/*************************************************************
@Name: APTS_DMConstants
@Author: Nishi Kushwaha
@CreateDate: 24 Nov 2015.
@Description: This class contains Data Migration constants used in apex code developed by Apttus
@UsedBy: All Data Migration Classes and Triggers
******************************************************************
@ModifiedBy: Author who modified this process.
@ModifiedDate: Date the process was modified.
@ChangeDescription: A brief description of what was modified. */


public class APTS_DMConstants {
    
    // Constants are used in Data-Migration-App
    // Added by Hardik Shah
    // Start
    public static final String VALIDATION_STATUS = 'Validation Passed';
    public static final String INITIAL_LOAD_STATUS= 'Initial Load';
    public static final String LOAD_STATUS = 'Load Complete';
    public static final String LOAD_FAIL = 'Load Failure';
    public static final String ERROR_STATUS = 'Error';
    
    public static final String ABB_TaskRecordType = 'ABB Standard';
    public static final String GLOBAL_PRODUCTS = 'Global Products';
    public static final String LOCAL_PRODUCTS = 'Local Products';
    public static final String LOCAL_HIERACHY = 'Local Hierarchy';
    public static final String APPROVAL_COUNTRY = 'Spain';
    public static final String APPROVAL_ORGANIZATION = 'ABB';
    public static final String MASTER_PICKLIST_COUNTRY = 'Country';
    public static final String MASTER_PICKLIST_DISTRIBUTION_CHANNEL = 'Distribution Channel';
    public static final String MASTER_PICKLIST_SALES_OFFICE = 'Sales Office';
    public static final String MASTER_PICKLIST_LOCAL_CHANNEL = 'Local Channel';
    public static final String MASTER_PICKLIST_INCOTERM = 'Incoterm';
    public static final String MASTER_PICKLIST_PAYMENT_TERM = 'Payment Term';
    public static final String MASTER_PICKLIST_SAP_DIVISION = 'SAP Division';
    public static final String MASTER_PICKLIST_SAP_SALES_ORGANIZATION = 'SAP Sales Organization';
    public static final String PROPERTY_ADVANCE_APPROVAL = 'useAdvancedApproval';
    public static final String PROPERTY_DEAL_OPTIMIZER = 'useDealOptimizer';
    
    public static final String SPAIN_DIVISION = 'LP';
    public static final String SPAIN_DIVISION_NEW = 'EP';
    
    // End
    public static final  String SPAIN_CURRENCY = 'EUR';
    public static final  String CATEGORY_NAME = 'LP Spain';
    public static final  String CATEGORY_LABEL = 'Low Voltage Products';
    
    public static final String READY_FOR_SIGNATURES='Ready for Signatures';
    
    public static final integer LEVEL_2_CAT = 2;
    public static final integer LEVEL_3_CAT = 3;
    public static final String SPAIN_LOCALE = 'es_ES';
    
    public static final Integer SELECT_SOQL_LIMIT = 45000;

}