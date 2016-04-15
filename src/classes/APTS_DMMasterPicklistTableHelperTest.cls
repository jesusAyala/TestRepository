/*************************************************************
@Name: APTS_DMMasterPicklistTableHelper
@Author: Hardik Shah
@CreateDate: 16/11/2015
@Description: This class tests following Classes : APTS_DMMasterPicklistTableHelper
@UsedBy: NA
******************************************************************/


@isTest
public class APTS_DMMasterPicklistTableHelperTest {
    
    private static User user;
    private static APTS_Capture_LSO_Input_Config_Settings__c lodConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();
    
    // Test Method to Copy Master-Pick List
    public static testMethod void validateMasterPickList(){
        
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) { 
        List<APTS_Stage_Master_Picklist__c> listStageMasterPickList  = APTS_LP_TestUtility.getStageMasterPicklistTableData(5);
        test.startTest();
        APTS_DMMasterPicklistTableHelper.validateStageMasterPickList(listStageMasterPickList);
        test.stopTest();
        }
    }
    
     // Test Method to Copy Master-Pick List
     public static testMethod void copyMasterPickList(){
        Integer testSize = 5;
        String testCountry = 'testcountry';
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) { 
        List<APTS_Stage_Master_Picklist__c> listStageMasterPickList  = APTS_LP_TestUtility.getStageMasterPicklistTableData(testSize);
        Integer i=1;
        for(APTS_Stage_Master_Picklist__c stg: listStageMasterPickList) {
            stg.name = 'P'+ i + ' - Local Channel';
            stg.APTS_Country__c = testCountry;
            stg.APTS_Code__c = 'P'+ i;
            stg.APTS_External_ID__c = 'P'+ i++;
        }
        test.startTest();
        APTS_DMMasterPicklistTableHelper.copyMasterPickList(listStageMasterPickList);
        List < APTS_Master_Picklist_Table__c > listCountry = [select id from APTS_Master_Picklist_Table__c where APTS_Country__c = :testCountry];
        system.assert(listCountry.size() == testSize*2);
        test.stopTest();
        }
    }


}