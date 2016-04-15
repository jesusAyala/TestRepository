/*************************************************************
@Name: ATPS_UserTrigger
@Author: Chetan Patel
@CreateDate: 30th October, 2015
@Description: Trigger for populating Locale for user in custom field APTS_Locale__c
@UsedBy: Used in Master Pick List Table lookup fields as lookup filter
******************************************************************/

trigger ATPS_UserTrigger on User (before insert, before update) {
    
    // Code block to execute Before Insert

    if(!(ClsAccountUtil.isAccMergeFlag) && Trigger.isBefore) {
        
        if(Trigger.isInsert){
            APTS_UserTriggerHandler handler = new APTS_UserTriggerHandler();
            handler.onBeforeInsert(Trigger.New);
        }
        if(Trigger.isUpdate){
            APTS_UserTriggerHandler handler = new APTS_UserTriggerHandler();
            handler.onBeforeUpdate(Trigger.New, Trigger.Old);
        }
        
    }

}