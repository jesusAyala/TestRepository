/*************************************************************
@Name: APTS_LocalCustRefDataTriggerHelper
@Author: Shalin Shah
@CreateDate: 5th October, 2015
@Description: Helper class to perform operations for trigger for records of Apttus Local Customer Reference Data.
@UsedBy: Class - APTS_LocalCustRefDataTriggerHandler
******************************************************************/

public class APTS_LocalCustRefDataTriggerHelper {
    
    private static String DEFAULT_SAP_DIVISION = 'ZZ';
	
    /**
     * Method to set the defaulut values in the provided list of new Apttus LSO records.
     */
    public void setDefaultValues(List<APTS_LP_Local_Customer_Reference_Data__c> newApttusLSODataList) {
        
        for(APTS_LP_Local_Customer_Reference_Data__c lsoData : newApttusLSODataList) {
            if(lsoData.APTS_SAP_Division__c == null || lsoData.APTS_SAP_Division__c.length() == 0) {
                lsoData.APTS_SAP_Division__c = DEFAULT_SAP_DIVISION;
            }
        }
    }
}