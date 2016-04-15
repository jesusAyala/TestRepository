/*************************************************************
@Name: APTS_LineItemTrigger
@Author: Axaykumar Varu
@CreateDate: 10.Dec.2015
@Description: 
@UsedBy: Trigger APTS_LineItemTrigger
***************************************************************/
trigger APTS_LineItemTrigger on Apttus_Config2__LineItem__c (before delete) {
    
    APTS_LineTriggerHandler lineItemTriggerHandler = new APTS_LineTriggerHandler();
    
    if(Trigger.isBefore && Trigger.isDelete){
        
        lineItemTriggerHandler.onBeforeDelete(Trigger.old);
    }
}