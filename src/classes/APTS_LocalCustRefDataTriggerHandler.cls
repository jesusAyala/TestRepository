/*************************************************************
@Name: APTS_LocalCustRefDataTriggerHandler
@Author: Shalin Shah
@CreateDate: 5th October, 2015
@Description: Handler class for trigger for records of Apttus Local Customer Reference Data.
@UsedBy: Trigger - APTS_LocalCustRefDataTrigger
******************************************************************/

public class APTS_LocalCustRefDataTriggerHandler {

    /**
     * Method to execute logic/operations when trigger is invoked before insert.
     */
    public void onBeforeInsert(List<APTS_LP_Local_Customer_Reference_Data__c> newApttusLSODataList) {
        APTS_LocalCustRefDataTriggerHelper helper = new APTS_LocalCustRefDataTriggerHelper();
        helper.setDefaultValues(newApttusLSODataList);
    }
}