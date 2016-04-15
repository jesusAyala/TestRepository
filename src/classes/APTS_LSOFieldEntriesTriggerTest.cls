@isTest
public class APTS_LSOFieldEntriesTriggerTest {

    // Test Sync Master Picklist Table data when LSO Field Entry is created / modified / deleted
    public static testMethod void syncLSOFieldEntryWithMasterPicklist(){

        System.runAs(APTS_LP_TestUtility.getUser()){
            Test.startTest();
            APTS_LP_TestUtility.getCommonConfigSetting();
            LSO_Field_Entries__c oLSOFieldEntry = new LSO_Field_Entries__c();
            oLSOFieldEntry.PickList_Description__c = 'Test/Code Description';
            oLSOFieldEntry.PickList_Code__c = 'Test/Code Description';
            oLSOFieldEntry.Country__c = 'Spain';
            oLSOFieldEntry.LSO_Pick_List_Value_Name__c = 'LSO Reference Data. Sales Office';
            insert oLSOFieldEntry;
            
            oLSOFieldEntry.Country__c = 'Austria';
            Update oLSOFieldEntry;
            
            delete oLSOFieldEntry;
            
            Test.stopTest(); 
    	}
    }
}