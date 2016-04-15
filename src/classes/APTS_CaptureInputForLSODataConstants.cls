/*************************************************************
@Name: APTS_CaptureInputForLSODataConstants
@Author: Shalin Shah
@CreateDate: 23th Sept 2015
@Description: Class to hold constant values for Capture Input For LSO Data page.
@UsedBy: Class - APTS_CaptureInputForLSODataController, APTS_CaptureInputForLSODataProcessor
******************************************************************/

public class APTS_CaptureInputForLSODataConstants {

    public static final String QUOTATION = 'Quotation';
    public static final String MSPA = 'MSPA';
    public static final String OPPORTUNITY = 'Opportunity';
    public static final String ACCOUNT = 'Account';
    public static final String BUYING = APTS_Common_Config_Settings__c.getvalues('BUYING').APTS_Value__c; 
    public static final String NON_BUYING = APTS_Common_Config_Settings__c.getvalues('NON_BUYING').APTS_Value__c;
    public static final String LP_DIVISION = APTS_Common_Config_Settings__c.getvalues('LP_DIVISION').APTS_Value__c;
    public static final String VALUE_SEPARATOR = ' #& ';
    public static final String INCOTERM = 'Incoterm';
    public static final String PAYMENT_TERM = 'Payment Term';
    public static final String LOCAL_CHANNEL = 'Local Channel';
    public static final String DISTRIBUTION_CHANNEL = 'Distribution Channel';
    public static final String NO_DESC_AVAILABLE = 'NO DESCRIPTION AVAILABLE';
    public static final String UNKNOWN_ES = APTS_Common_Config_Settings__c.getvalues('UNKNOWN_ES').APTS_Value__c;
    public static final String LP_SPAIN = APTS_Common_Config_Settings__c.getvalues('LP_SPAIN').APTS_Value__c;
	public static final String ACCOUNT_CUSTOMER = 'Account Customer';
    public static final String PRIMARY_PARTNER = 'Primary Partner';
    public static final String ACCOUNT_END_USER = 'Account End User';    
}