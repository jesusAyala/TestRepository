/*
@Name: APTS_LSOFieldEntriesTriggerHandler
@Author: Jignesh Shekhaliya
@CreateDate: 28-Nov-2015
@Description: Handler Class to invoke appropriate methods from Helper Class
@UsedBy: APTS_LSOFieldEntriesTrigger
******************************************************************
*/
public with sharing class APTS_LSOFieldEntriesTriggerHandler {

    list<LSO_Field_Entries__c> listLSOEntries = new list<LSO_Field_Entries__c>();
    String recordTypeId='';
    
    public APTS_LSOFieldEntriesTriggerHandler(){
        
        recordTypeId = APTS_LSOFieldEntriesTriggerHelper.getRecordTypeId();
        
    }
    
    
    public void OnAfterInsert(list<LSO_Field_Entries__c> listNewLSOFieldEntries) {
    
        for( LSO_Field_Entries__c oLSOFieldEntry : listNewLSOFieldEntries ){
        
            if( oLSOFieldEntry.PickList_Code__c != null && oLSOFieldEntry.PickList_Description_Code__c != null && 
                oLSOFieldEntry.Country__c != null && oLSOFieldEntry.LSO_Pick_List_Value_Name__c.Contains(APTS_Constants.LSO_FIELD_ENTRY_IDENTIFIER) &&
                oLSOFieldEntry.RecordTypeId ==recordTypeId){
            
                listLSOEntries.add(oLSOFieldEntry);
            }                        
        }
    
        if( !listLSOEntries.isEmpty() ){
        
            APTS_LSOFieldEntriesTriggerHelper.syncMasterPicklistTable(listLSOEntries);
        }
    }
    
    public void OnAfterUpdate(Map<Id, LSO_Field_Entries__c> mapNewLSOFieldEntries, Map<Id, LSO_Field_Entries__c> mapOldLSOFieldEntries) {
    
        for( LSO_Field_Entries__c oLSOFieldEntry : mapNewLSOFieldEntries.Values() ){
        
            if( oLSOFieldEntry.PickList_Code__c != null && oLSOFieldEntry.PickList_Description_Code__c != null && 
                oLSOFieldEntry.Country__c != null && oLSOFieldEntry.LSO_Pick_List_Value_Name__c.Contains(APTS_Constants.LSO_FIELD_ENTRY_IDENTIFIER) &&
                oLSOFieldEntry.RecordTypeId ==recordTypeId){
            
                listLSOEntries.add(oLSOFieldEntry);
            } 
/*            
            if( oLSOFieldEntry.LSO_Pick_List_Value_Name__c.Contains('LSO Reference Data. Sales Office') &&
                ((oLSOFieldEntry.PickList_Code__c != null && oLSOFieldEntry.PickList_Code__c != mapOldLSOFieldEntries.get(oLSOFieldEntry.Id).PickList_Code__c) ||
                 (oLSOFieldEntry.PickList_Description_Code__c != null && oLSOFieldEntry.PickList_Description_Code__c != mapOldLSOFieldEntries.get(oLSOFieldEntry.Id).PickList_Code__c) ||
                 (oLSOFieldEntry.Country__c != null && oLSOFieldEntry.Country__c != mapOldLSOFieldEntries.get(oLSOFieldEntry.Id).PickList_Code__c)) ){
            
                listLSOEntries.add(oLSOFieldEntry);
            }                      */  
        }
    
        if( !listLSOEntries.isEmpty() ){
        
            APTS_LSOFieldEntriesTriggerHelper.syncMasterPicklistTable(listLSOEntries);
        }
    
    }

    public void OnAfterDelete(Map<Id, LSO_Field_Entries__c> mapOldLSOFieldEntries) {
    
        Set<String> setLSOFieldEntriesId = new Set<String>();
    
        for( LSO_Field_Entries__c oLSOFieldEntry : mapOldLSOFieldEntries.Values() ){
        
            if( oLSOFieldEntry.LSO_Pick_List_Value_Name__c.Contains(APTS_Constants.LSO_FIELD_ENTRY_IDENTIFIER) &&
                oLSOFieldEntry.RecordTypeId ==recordTypeId){
            
                setLSOFieldEntriesId.add(oLSOFieldEntry.Id);
            }
        }
        
        if( !setLSOFieldEntriesId.isEmpty() ){
        
            APTS_LSOFieldEntriesTriggerHelper.syncDeleteMasterPicklist(setLSOFieldEntriesId);
        }        
    }
    
    
}