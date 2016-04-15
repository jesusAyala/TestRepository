/*
@Name: APTS_LSOFieldEntriesTriggerHelper
@Author: Jignesh Shekhaliya
@CreateDate: 28-Nov-2015
@Description: Helper Class to Perform operations on LSO Field Entries Object
@UsedBy: APTS_LSOFieldEntriesTriggerHandler
******************************************************************
*/
public with sharing class APTS_LSOFieldEntriesTriggerHelper {

    /*
    @Method to Sync Master Picklist Table Data with LSO Field Entries Table
    @param: List of created / modified LSO Field Entries
    */
    
    public static void syncMasterPicklistTable(List<LSO_Field_Entries__c> listLSOFieldEntries){
        
        string currentUserLocale = [select LocaleSidKey from User where id=:userInfo.getUserId()].LocaleSidKey;
    
        list<APTS_Master_Picklist_Table__c> listMasterPicklistTable = new list<APTS_Master_Picklist_Table__c>();

        for( LSO_Field_Entries__c oLSOFieldEntry : listLSOFieldEntries ){
        
            APTS_Master_Picklist_Table__c oMasterPicklist = new APTS_Master_Picklist_Table__c();
            oMasterPicklist.APTS_External_Id__c = APTS_Constants.MASTER_PICKLIST_TABLE_IDENTIFIER + oLSOFieldEntry.Id;
            oMasterPicklist.APTS_Code__c = oLSOFieldEntry.PickList_Code__c;
            oMasterPicklist.APTS_Code_Description__c = oLSOFieldEntry.PickList_Description__c;
            oMasterPicklist.APTS_Country__c = oLSOFieldEntry.Country__c;
            oMasterPicklist.APTS_Code_Used_For__c = APTS_Constants.MASTER_PICKLIST_TABLE_IDENTIFIER;
            oMasterPicklist.Name = oMasterPicklist.APTS_Code__c + ' - ' + oMasterPicklist.APTS_Code_Description__c;
            oMasterPicklist.APTS_Reference_Id__c = oLSOFieldEntry.Id;
            oMasterPicklist.APTS_Locale__c = currentUserLocale;
            listMasterPicklistTable.add(oMasterPicklist);
        }
        
        if( !listMasterPicklistTable.isEmpty() )
            Database.upsert(listMasterPicklistTable, APTS_Master_Picklist_Table__c.APTS_External_Id__c.getDescribe().getSObjectField(), false);
        
    }    

    /*
    @Method to Delete Master Picklist Table Data when corresponding LSO Field Entries
    @param: Set of deleted LSO Field Entries Id
    */    
    public static void syncDeleteMasterPicklist(Set<String> setLSOFieldEntriesId){
    
        list<APTS_Master_Picklist_Table__c> listDeleteMasterPicklist = new list<APTS_Master_Picklist_Table__c>();
        
        for( APTS_Master_Picklist_Table__c oMasterPicklist : [ Select Id, APTS_Code_Used_For__c, 
                                                                      APTS_Country__c, APTS_Code__c
                                                                      from APTS_Master_Picklist_Table__c
                                                                      where APTS_Code_Used_For__c = :APTS_Constants.MASTER_PICKLIST_TABLE_IDENTIFIER
                                                                      AND APTS_Reference_Id__c IN :setLSOFieldEntriesId ]) {
                                                                      
            listDeleteMasterPicklist.add(oMasterPicklist);
        
        }
        
        if( !listDeleteMasterPicklist.isEmpty() )
            Database.delete(listDeleteMasterPicklist);
    }
    
    public static string getRecordTypeId(){
        
        String recordId='';
        List<RecordType> listRecordType = [Select Id, Name From RecordType Where SobjectType = 'LSO_Field_Entries__c' AND Name = 'LSO ERP Picklist Entries'];
        if(listRecordType != null){
        recordId = listRecordType[0].Id;
        
        }
        return recordId;
    }
}