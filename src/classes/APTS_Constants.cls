/*************************************************************
@Name: APTS_Constants
@Author: Hardik Shah
@CreateDate: 05 Sep 2015.
@Description: This class contains constants used in apex code developed by Apttus
@UsedBy: Many Classes and Triggers
******************************************************************
@ModifiedBy: Author who modified this process.
@ModifiedDate: Date the process was modified.
@ChangeDescription: A brief description of what was modified. */

public class APTS_Constants {
    // Agreement Type
    // Modified by chetan to take values from Custom settings as change for LP R3.1 -date : 14/12/2015
    public static String MSPA_TYPE {
        get{
            if(APTS_Agreement_Record_Type__c.getOrgDefaults() != null && APTS_Agreement_Record_Type__c.getOrgDefaults().APTS_Default_Record_Type__c != null){
                return APTS_Agreement_Record_Type__c.getOrgDefaults().APTS_Default_Record_Type__c;
            }else{
                return 'MSPA';
            }
        }
    }
    
    //Axay - Agreement Trigger Helper Constants
    public static final String ADMIN_PROFILE = 'System Administrator';
    public static final String MSPA_STATUS_APPROVED = 'Approved';
    public static final String MSPA_STATUS_REJECTED = 'Rejected';
    public static final String MSPA_STATUS_FAILED_TO_LOAD_SAP = 'Approved but failed to load on SAP';
    public static final String MSPA_STATUS_APPROVAL_IN_PROGRESS = 'Approval In Progress';
    public static final String MSPA_STATUS_EXPIRED = 'Expired';
    public static final String MSPA_STATUS_GENERATED = 'Generated';
    public static final String MSPA_STATUS_PRESENTED = 'Presented';
    public static final String MSPA_STATUS_RECALLED =  'Recalled';
    public static final String MSPA_STATUS_IN_SIGNATURES = 'In Signatures';
    public static final String MSPA_STATUS_READY_SIGNATURES = 'Ready for Signatures';
    public static final String MSPA_STATUS_CATEGORY_REQUEST = 'Request';
    public static final String MSPA_SUBTYPE_PROJECT = 'Project';
    public static final String MSPA_SUBTYPE_DEFAULT = 'Default';
    
    
    // Change ends
    public static final String  MSPA_TYPE_READ_ONLY = 'LP Spain - Project MSPA RO';
    public static final String LP_SPAIN_CONFIG_SETTINGS = 'LP-Spain Config Settings';
    
    //Record Type
    public static final String Global_Record_Type = APTS_Common_Config_Settings__c.getvalues('Global_Record_Type').APTS_Value__c;
    
    // Proposal Type
    // Modified by chetan to take values from Custom settings as change for LP R3.1 -date : 14/12/2015
    public static String PROPOSAL_TYPE {
        get{
            if(APTS_Proposal_Record_Type__c.getOrgDefaults() != null && APTS_Proposal_Record_Type__c.getOrgDefaults().APTS_Default_Record_Type__c != null){
                return APTS_Proposal_Record_Type__c.getOrgDefaults().APTS_Default_Record_Type__c;
            }else{
                return 'LP';
            }
        }
    }
    // Chnage Ends
    
    public static final String PROPOSAL_TYPE_READ_ONLY =  'LP Spain - Proposal RO';
    //Check added by Shahid to avoid test classes from being failed
    public static String QUOTATION_RECORD_TYPE {
        get{
            if(APTS_Capture_LSO_Input_Config_Settings__c.getValues(LP_SPAIN_CONFIG_SETTINGS) != null && APTS_Capture_LSO_Input_Config_Settings__c.getValues(LP_SPAIN_CONFIG_SETTINGS).APTS_Quotation_Record_Type__c != null){
                return APTS_Capture_LSO_Input_Config_Settings__c.getValues(LP_SPAIN_CONFIG_SETTINGS).APTS_Quotation_Record_Type__c;
            }else{
                return 'LP';
            }
        }
    }

    public static final String PROPERTY_ADVANCE_APPROVAL = 'useAdvancedApproval';
    public static final String PROPERTY_DEAL_OPTIMIZER = 'useDealOptimizer';
    public static final string QUOTATION_STATUS_CLOSED = 'Closed';
        
    // Agreement (MSPA) Status
    public static final String MSPA_DEACTIVATED =  'DeActivated';
    public static final String MSPA_BLOCKED =  'Blocked';
    
    public static final Decimal MAXIMUM_ADJUSTMENT_AMOUNT = -999999999;
    public static final Decimal MAXIMUM_NET_ADJUSTMENT_PERCENT = -999999999; 
    public static final String  LP_USER_DIVISION = APTS_Common_Config_Settings__c.getvalues('LP_USER_DIVISION').APTS_Value__c;
    public static final String  DISCOUNT =  '% Discount';
    public static final String  PRICEOVERIDE =  'Price Override';
    public static final String  AGREEMENT_STATUS = 'Pending Approval';
    public static final String STATUS_APPROVED_ACTION_REQ = 'Approved but Action Required';
    
    public static final String NET_DISCOUNT = 'Net Price Discount';
    public static final String SUB_DISCOUNT = 'Substitute Discount';
    public static final string ADD_DISCOUNT = 'Additional Discount';
    
    public static final String SALES_OFFICE = 'Sales Office';
    public static final String DEFAULT_SAP_DIVISION = APTS_Common_Config_Settings__c.getvalues('DEFAULT_SAP_DIVISION').APTS_Value__c;
    public static final String SPAIN_LOCALE = APTS_Common_Config_Settings__c.getvalues('SPAIN_LOCALE').APTS_Value__c;
    
    public static final string ACCOUNTTYPE_ACCEND = 'Account End User';
    public static final string ACCOUNTTYPE_PARTNER = 'Primary Partner';
    public static final string QUOTE_APPROVAL_STATUS_DRAFT='Draft';
    // added by chetan 28-11-2015 we need to set this status in order to preview submit for approval
    public static final string QUOTE_APPROVAL_STATUS_NOT_SUBMITTED='Not Submitted';
    public static final string AGREEMENT_APPROVAL_STATUS_NOT_SUBMITTED = 'Not Submitted';
    public static final string AGREEMENT_STATUS_DRAFT = 'Draft';
    
    // Constants are used in Data-Migration-App
    // Added by Hardik Shah
    public static final String INITIAL_LOAD_STATUS= 'Initial Load';
    public static final String VALIDATION_STATUS = 'Validation Passed';
    public static final String LOCAL_PRODUCTS = 'Local Products';
    
    public static final String GLOBAL_PRODUCTS = 'Global Products';
    public static final String APPROVAL_ORGANIZATION = 'ABB';
    public static final integer LEVEL_2_CAT = 2;
    public static final integer LEVEL_3_CAT = 3;
    
    public static final  String SPAIN_CURRENCY = 'EUR';
    public static final  String CATEGORY_NAME = 'LP Spain';
    public static final String LOCAL_HIERACHY = 'Local Hierarchy';
    public static final String READY_FOR_SIGNATURES='Ready for Signatures';
    
    /*
    public static final String LOAD_STATUS = 'Load Complete';
    public static final String ERROR_STATUS = 'Error';
    public static final String OBJECT_NAME = 'APTS_Stage_Product_Line_Tree';
    public static final String GLOBAL_PRODUCTS = 'Global Products';
    
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
    
    public static final String DIVISION = 'LP';
    
    public static final  String SPAIN_CURRENCY = 'EUR';
    public static final  String CATEGORY_NAME = 'LP Spain';
    
    public static final String READY_FOR_SIGNATURES='Ready for Signatures';
    
    public static final integer LEVEL_2_CAT = 2;
    public static final integer LEVEL_3_CAT = 3;
    */
    public static final Integer SELECT_SOQL_LIMIT = 45000;
    
    public APTS_Constants(){
        if(APTS_Capture_LSO_Input_Config_Settings__c.getValues(LP_SPAIN_CONFIG_SETTINGS) != null && APTS_Capture_LSO_Input_Config_Settings__c.getValues(LP_SPAIN_CONFIG_SETTINGS).APTS_Quotation_Record_Type__c != null){
            QUOTATION_RECORD_TYPE = APTS_Capture_LSO_Input_Config_Settings__c.getValues(LP_SPAIN_CONFIG_SETTINGS).APTS_Quotation_Record_Type__c;
        }else{
            QUOTATION_RECORD_TYPE = 'LP';
        }
    }
    
    public static final String MASTER_PICKLIST_LOCAL_CHANNEL = 'Local Channel';
    public static final String DIVISION = APTS_Common_Config_Settings__c.getvalues('DIVISION').APTS_Value__c;
    public static final String ERROR_STATUS = 'Error';
    public static final String MASTER_PICKLIST_COUNTRY = 'Country';
    public static final String MASTER_PICKLIST_DISTRIBUTION_CHANNEL = 'Distribution Channel';
    public static final String MASTER_PICKLIST_SALES_OFFICE = 'Sales Office';
    public static final String MASTER_PICKLIST_INCOTERM = 'Incoterm';
    public static final String MASTER_PICKLIST_PAYMENT_TERM = 'Payment Term';
    public static final String APPROVAL_COUNTRY = APTS_Common_Config_Settings__c.getvalues('APPROVAL_COUNTRY').APTS_Value__c;
    
    public static final String MASTER_PICKLIST_TABLE_IDENTIFIER = 'Sales Office';
    public static final String LSO_FIELD_ENTRY_IDENTIFIER = 'LSO Reference Data. Sales Office';
    public static final String PRODUCT_CONFIG_STATUS_FINALIZED = 'Finalized';
    
    
    public static final String CONFIG_LINE_ITEM_FIELD_APTS_Original_Created_By='APTS_Original_Created_By__c';
    public static final String CONFIG_LINE_ITEM_FIELD_APTS_Original_Created_On='APTS_Original_Created_On__c';
    public static final String CONFIG_LINE_ITEM_FIELD_APTS_Discount_Percentage='APTS_Discount_Percentage__c';
    public static final String CONFIG_LINE_ITEM_FIELD_APTS_Discount_Type='APTS_Discount_Type__c';
    public static final String CONFIG_LINE_ITEM_FIELD_APTS_External_Id='APTS_External_Id__c';
    public static final String CONFIG_LINE_ITEM_FIELD_Apttus_Config2_NetPrice='Apttus_Config2__NetPrice__c';
    public static final String CONFIG_LINE_ITEM_FIELD_APTS_Owner='APTS_Owner';
    public static final String CONFIG_LINE_ITEM_FIELD_APTS_Owner2='APTS_Owner__c';
    public static final String CONFIG_LINE_ITEM_FIELD_APTS_LP_Standard_Net='APTS_LP_Standard_Net__c';
    public static final String CONFIG_LINE_ITEM_FIELD_Apttus_Config2_BasePrice='Apttus_Config2__BasePrice__c';
    public static final String CONFIG_LINE_ITEM_FIELD_APTS_LP_Unit_Of_Price='APTS_LP_Unit_Of_Price__c';
    public static final String CONFIG_LINE_ITEM_FIELD_GTV_Level='GTV_Level__c';
    public static final String CONFIG_LINE_ITEM_FIELD_APTS_SPA_Line_Item_Number='APTS_SPA_Line_Item_Number__c';
    
    public static final String CLASSIFICATION_HIERARCHY_NAME='ES - Hierarchy';
    public static final String HTML_LINE_BREAK='<br/><br/>';
    public static final String CONFIGURATION_TYPE_STANDALONE='Standalone';
    public static final String CONFIGURATION_TYPE_OFFERING='Offering';
    public static final String PRICING_STATUS_PENDING='Pending';
    
    public static final String LINE_ITEM_FIELD_NET_PRICE_OVERRIDE='APTS_Net_Price_Override__c';
    public static final String LINE_ITEM_FIELD_DISCOUNT_PERCENTAGE='APTS_Discount_Percentage__c';
    public static final String LINE_ITEM_FIELD_DISCOUNT_TYPE='APTS_Discount_Type__c';
    
    public static final String HTTP_HEADER_CONTENT_TYPE='Content-Type';
    public static final String HTTP_HEADER_X_HTTP_METHOD='X-HTTP-Method';
    public static final String HTTP_CONTENT_TYPE_JSON='application/json';
    public static final String HTTP_METHOD_POST='POST';
    public static final String ENCODING_UTF_8='UTF-8';
    public static final String ENCRYPTION_ALGO_HMACSHA256='HmacSHA256';
    public static final String HTTP_HEADER_REFERER='Referer';
    
    public static final String QUOTE_TYPE_BINDING = 'Budgetary/Binding';
    public static final String QUOTE_TYPE_NONBINDING = 'Budgetary/Non-Binding';
    
    public static final String PARAM_COPY_LINEITEMS_WITH = 'CopyWith';
    public static final String PARAM_ACCOUNT_TYPE        = 'AccountType';
    public static final String PARAM_FLAG                = 'Flag';
    public static final String PARAM_VAL_FALSE           = 'False';
    public static final String PARAM_VAL_TRUE            = 'True';
    
    public static final String SOBJECT_TYPE_QUOTE        = 'Quotation';
    public static final String SOBJECT_TYPE_AGREEMENT    = 'Agreement';
    
}