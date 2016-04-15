/*************************************************************
@Name: APTS_LineTriggerHandler
@Author: Axaykumar Varu
@CreateDate: 10.Dec.2015
@Description: 
@UsedBy: Trigger APTS_LineItemTrigger
***************************************************************/
public with sharing class APTS_LineTriggerHandler {
    
    public APTS_LineTriggerHandler() {}
    
    public void onBeforeDelete(List<Apttus_Config2__LineItem__c> deletedLineItems){
        
        APTS_LineItemTriggerHelper.onDeleteValidation(deletedLineItems);
    }
}