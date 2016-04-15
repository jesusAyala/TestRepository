/*************************************************************
@Name: APTS_ProductConfigurationTrigger
@Author: Hardik Shah
@CreateDate: 02/09/2015
@Description: Trigger on ProductConfiguration Object.
@UsedBy: NA
******************************************************************
@ModifiedBy: Nishi Kushwaha
@ModifiedDate: 02/09/2015
@ChangeDescription: OnBeforeUpdate Method Call 
**** PS: @ModifiedBy and @ChangeDescription can be repeated multiple time, based on number of changes made to the original process.
******************************************************************/

trigger APTS_ProductConfigurationTrigger on Apttus_Config2__ProductConfiguration__c(after update) {
    // Instance of ProductConfiguration Trigger Handler Class
    APTS_ProductConfigurationTriggerHandler oProductConfiguration = new APTS_ProductConfigurationTriggerHandler();
    // Before Update Event
    /*if (Trigger.isBefore && Trigger.isUpdate) {
        oProductConfiguration.OnBeforeUpdate(Trigger.newMap, Trigger.oldMap);
    }*/
    
    if (Trigger.isAfter && Trigger.isUpdate) {
        oProductConfiguration.OnBeforeUpdate(Trigger.newMap, Trigger.oldMap);
    }

}