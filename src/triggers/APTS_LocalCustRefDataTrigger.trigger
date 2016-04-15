/*************************************************************
@Name: APTS_LocalCustRefDataTrigger
@Author: Shalin Shah
@CreateDate: 5th October, 2015
@Description: Trigger for records of Apttus Local Customer Reference Data.
@UsedBy: Custom Object - APTS_LP_Local_Customer_Reference_Data__c
******************************************************************/

trigger APTS_LocalCustRefDataTrigger on APTS_LP_Local_Customer_Reference_Data__c (before insert, before update) {

    // Code block to execute Before Insert
    if(Trigger.isBefore && Trigger.isInsert) {
        APTS_LocalCustRefDataTriggerHandler handler = new APTS_LocalCustRefDataTriggerHandler();
        handler.onBeforeInsert(Trigger.New);
    }
    
    // Code block to execute Before Update
    if(Trigger.isBefore && Trigger.isUpdate) {
        
    }
}