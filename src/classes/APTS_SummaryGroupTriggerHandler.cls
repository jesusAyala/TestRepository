/*
@Name: APTS_SummaryGroupTriggerHandler
@Author: Chetan Patel
@CreateDate: 07 Dec, 2015
@Description: Handler class for trigger for records of Apttus_Config2__SummaryGroup__c.
@UsedBy: Trigger - APTS_SummaryGroupTrigger 
*/

public class APTS_SummaryGroupTriggerHandler {

    
    //Method to execute logic/operations when trigger is invoked before insert.
    public void onBeforeInsert(List<Apttus_Config2__SummaryGroup__c> newSummaryGroupList) {
        APTS_SummaryGroupTriggerHelper helper = new APTS_SummaryGroupTriggerHelper();
        helper.setSummaryGrouTotals(newSummaryGroupList);
    }
    
    //Method to execute logic/operations when trigger is invoked before update.
    public void onBeforeUpdate(List<Apttus_Config2__SummaryGroup__c> newSummaryGroupList,List<Apttus_Config2__SummaryGroup__c> oldSummaryGroupList) {
        APTS_SummaryGroupTriggerHelper helper = new APTS_SummaryGroupTriggerHelper();
        helper.setSummaryGrouTotals(newSummaryGroupList);
    }
    
    //Method to execute logic/operations when trigger is invoked after insert.
    public void onAfterInsert(List<Apttus_Config2__SummaryGroup__c> newSummaryGroupList) {
        APTS_SummaryGroupTriggerHelper helper = new APTS_SummaryGroupTriggerHelper();
        helper.setSummaryGrouTotalsAfterInsert(newSummaryGroupList);
    }
}