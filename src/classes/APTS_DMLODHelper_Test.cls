@isTest
public class APTS_DMLODHelper_Test{
    private static APTS_Capture_LSO_Input_Config_Settings__c lodConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();
    static testMethod void validateLocalOperationalDataTest() {
        List<APTS_Stage_Local_Operational_Data__c> listAptsStgLocalOpsData = new List<APTS_Stage_Local_Operational_Data__c>();
        APTS_Stage_Local_Operational_Data__c stageLocalOpData = new APTS_Stage_Local_Operational_Data__c(APTS_LP_Account_GUID__c='test',APTS_LP_Local_Channel__c= 'Local Channel',
                                                                           APTS_LP_Distribution_Channel__c= 'Distribution Channel',APTS_LP_Incoterms__c='Incoterm',
                                                                           APTS_Payment_Terms__c='Payment Term',
                                                                           APTS_SAP_Division__c= 'SAP Division');
        listAptsStgLocalOpsData.add(stageLocalOpData ); 
        Test.startTest();                          
        APTS_DMLODHelper.validateLocalOperationalData(listAptsStgLocalOpsData );
        Test.stopTest();
    }
    
    static testMethod void copyLocalOperationalDataTest() {
        List<APTS_Stage_Local_Operational_Data__c> listAptsStgLocalOpsData = new List<APTS_Stage_Local_Operational_Data__c>();
        APTS_Stage_Local_Operational_Data__c stageLocalOpData = new APTS_Stage_Local_Operational_Data__c(APTS_LP_Account_GUID__c='test',APTS_LP_Local_Channel__c= 'Local Channel',
                                                                           APTS_LP_Distribution_Channel__c= 'Distribution Channel',APTS_LP_Incoterms__c='Incoterm',
                                                                           APTS_Payment_Terms__c='Payment Term',
                                                                           APTS_SAP_Division__c= 'SAP Division');
        listAptsStgLocalOpsData .add(stageLocalOpData );                                                                   
        Test.startTest();
        APTS_DMLODHelper.copyLocalOperationalData(listAptsStgLocalOpsData );
        Test.stopTest();
    }
     static testMethod void validateLocalOperationalDataTesting() {
        
        List<APTS_Stage_Local_Operational_Data__c> listAptsStgLocalOpsData = new List<APTS_Stage_Local_Operational_Data__c>();
        APTS_Stage_Local_Operational_Data__c stageLocalOpData = new APTS_Stage_Local_Operational_Data__c(APTS_LP_Account_GUID__c='test',APTS_LP_Local_Channel__c= 'Local Channel',
                                                                           APTS_LP_Distribution_Channel__c= 'Distribution Channel',APTS_LP_Incoterms__c='Incoterm',
                                                                           APTS_Payment_Terms__c='Payment Term',
                                                                           APTS_SAP_Division__c= 'SAP Division');
        listAptsStgLocalOpsData.add(stageLocalOpData );    
        List<APTS_Master_Picklist_Table__c> listMasterPicklistTable = new List<APTS_Master_Picklist_Table__c>();
        APTS_Master_Picklist_Table__c masterPicklistRec1 = new APTS_Master_Picklist_Table__c(Name='Distribution Channel',APTS_Code__c='Distribution Channel',APTS_Code_Used_For__c='Distribution Channel',APTS_Locale__c='es_ES');
        APTS_Master_Picklist_Table__c masterPicklistRec2 = new APTS_Master_Picklist_Table__c(Name='Local Channel',APTS_Code__c='Local Channel',APTS_Code_Used_For__c='Local Channel',APTS_Locale__c='es_ES');
        APTS_Master_Picklist_Table__c masterPicklistRec3 = new APTS_Master_Picklist_Table__c(Name='Incoterm',APTS_Code__c='Incoterm',APTS_Code_Used_For__c='Incoterm',APTS_Locale__c='es_ES');
        APTS_Master_Picklist_Table__c masterPicklistRec4 = new APTS_Master_Picklist_Table__c(Name='SAP Division',APTS_Code__c='SAP Division',APTS_Code_Used_For__c='SAP Division',APTS_Locale__c='es_ES');
        listMasterPicklistTable.add(masterPicklistRec1 );
        listMasterPicklistTable.add(masterPicklistRec2);
        listMasterPicklistTable.add(masterPicklistRec3 );
        listMasterPicklistTable.add(masterPicklistRec4 ); 
        Test.startTest();  
        insert  listMasterPicklistTable;
        APTS_DMLODHelper.validateLocalOperationalData(listAptsStgLocalOpsData );
        Test.stopTest();
    }

}