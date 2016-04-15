@isTest
private class APTS_DMStageMSPAApprovalHelperTest {
    
    private static APTS_Capture_LSO_Input_Config_Settings__c lodConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();
    
    @isTest static void positive() {
        User usr = APTS_LP_TestUtility.getUser();
        System.runAs(usr) {
            
            Test.startTest();
            
            APTS_Stage_Data_Validation_Rules_Setting__c validateUser = new APTS_Stage_Data_Validation_Rules_Setting__c();
            validateUser.name = 'DataMigration';
            validateUser.APTS_Validate_SFDC_User__c = TRUE ;        
            insert validateUser; 
            
            List<APTS_Stage_MSPA_Approvals__c > listStageMSPAApprovals = new List<APTS_Stage_MSPA_Approvals__c>();
            
            APTS_Stage_MSPA_Approvals__c aptStgAprvl = new APTS_Stage_MSPA_Approvals__c();
            aptStgAprvl.APTS_SPA_Reference__c  = 'Krunal Pala';
            aptStgAprvl.APTS_Approver__c = 'Krunal Pala';
            aptStgAprvl.APTS_Delegate_Approver__c = 'Krunal Pala';
            aptStgAprvl.APTS_Actual_Approver__c='Krunal Pala';
            aptStgAprvl.APTS_Created_By__c = 'Krunal Pala';
            aptStgAprvl.APTS_Created_On__c = System.today();
            aptStgAprvl.APTS_Comments__c = 'Test Comments';
            aptStgAprvl.APTS_Notes__c = 'Test Notes';
            aptStgAprvl.APTS_Approval_History_Step__c = 'New';
            listStageMSPAApprovals.add(aptStgAprvl);
            
            APTS_DMStageMSPAApprovalHelper.validateStageMSPAApprovals(listStageMSPAApprovals);
            
            Test.stopTest();
        }
    }
    
    @isTest static void negative() {
        User usr = APTS_LP_TestUtility.getUser();
        System.runAs(usr) {
            
            Test.startTest();
            
            APTS_Stage_Data_Validation_Rules_Setting__c validateUser = new APTS_Stage_Data_Validation_Rules_Setting__c();
            validateUser.name = 'DataMigration';
            validateUser.APTS_Validate_SFDC_User__c = FALSE ;        
            insert validateUser; 
            
            List<APTS_Stage_MSPA_Approvals__c > listStageMSPAApprovals = new List<APTS_Stage_MSPA_Approvals__c>();
            
            APTS_Stage_MSPA_Approvals__c aptStgAprvl = new APTS_Stage_MSPA_Approvals__c();
            listStageMSPAApprovals.add(aptStgAprvl);
            
            APTS_DMStageMSPAApprovalHelper.validateStageMSPAApprovals(listStageMSPAApprovals);
            
            Test.stopTest();
        }
    }
    
    @isTest static void testCopyData() {
        User usr  = APTS_LP_TestUtility.getUser();
        System.runAs(usr) {
            
            Test.startTest();
            APTS_LP_TestUtility.getCommonConfigSetting();
            APTS_Stage_Data_Validation_Rules_Setting__c validateUser = new APTS_Stage_Data_Validation_Rules_Setting__c();
            validateUser.name = 'DataMigration';
            validateUser.APTS_Validate_SFDC_User__c = FALSE ;   
            validateUser.APTS_Create_Audit_Fields__c = FALSE;
            insert validateUser;
            
            APTS_LP_TestUtility.getDiscountConfig();
            
            APTS_Agreement_SAP_Setting__c agrSetting = new APTS_Agreement_SAP_Setting__c(APTS_Auto_Create_MSPA_In_SAP_On_Approval__c=true,APTS_Country__c='Spain');
            insert agrSetting;
            Apttus__APTS_Agreement__c agreement = APTS_LP_TestUtility.getAgreement('Test');
            agreement.APTS_SPA_Identifier__c = 0;
            agreement.APTS_SAP_Reference_No__c = 'KrunalPala';
            agreement.APTS_Locale__c = 'es_ES';
            agreement.APTS_Legacy_MSPA__c = TRUE;
            agreement.APTS_Country__c = 'Spain';
            insert agreement;
            
            List<APTS_Stage_MSPA_Approvals__c > listStageMSPAApprovals = new List<APTS_Stage_MSPA_Approvals__c>();
            
            APTS_Stage_MSPA_Approvals__c aptStgAprvl = new APTS_Stage_MSPA_Approvals__c();
            aptStgAprvl.APTS_SPA_Reference__c  = agreement.APTS_SAP_Reference_No__c;
            aptStgAprvl.APTS_Approver__c = 'Test User';
            aptStgAprvl.APTS_Delegate_Approver__c = 'Test User';
            aptStgAprvl.APTS_Actual_Approver__c='Test User';
            aptStgAprvl.APTS_Created_By__c = 'Test User';
            aptStgAprvl.APTS_Created_On__c = System.today();
            aptStgAprvl.APTS_Approval_Action_Date__c = System.today();
            aptStgAprvl.APTS_Comments__c = 'Test Comments';
            aptStgAprvl.APTS_Notes__c = 'Test Notes';
            aptStgAprvl.APTS_Approval_History_Step__c = 'New';
            aptStgAprvl.APTS_External_Id__c = 'KrunalPala';
            listStageMSPAApprovals.add(aptStgAprvl);
            
            insert listStageMSPAApprovals;
            
            APTS_DMStageMSPAApprovalHelper.copyStageMSPAApprovals(listStageMSPAApprovals);
            List<Task> taskList = [select type, ownerID, recordType.name, whoID from Task];
            system.assert(taskList.size()>0);
            system.debug('taskList::' + taskList);
            system.assert(taskList[0].type == 'MSPA Approval');
            system.assert(taskList[0].ownerID == UserInfo.getUserId());
            system.assert(taskList[0].recordType.name == 'ABB Standard');
            system.assert(taskList[0].whoID == null);
            
        	User oUser = new User(alias = 'testxyz', email='testxyz+invalid@apttus.com', emailencodingkey='UTF-8',
                              firstname='Approval', lastname='History', languagelocalekey='en_US', localesidkey='es_ES',
                              profileid = APTS_LP_TestUtility.getAdminProfile().Id, country = 'Spain', countryCode = 'ES', 
                              City = 'Barcelona', Sales_Territory_Name__c = 'BT/Niessen Barcelona',
                              Division = 'LP', Division_DIV__c = 'LP', timezonesidkey='America/Los_Angeles',
                              Default_LSO__c = 'ES_LP', Default_BU__c = 'ESABB-LPBS',IsActive = true,
                              username = 'testxyz+invalid@apttus.com');     
            insert oUser;			
            system.debug('oUser.id::' + oUser.id);
            
            aptStgAprvl.APTS_Approver__c = oUser.firstname + ' ' + oUser.lastname;
            APTS_DMStageMSPAApprovalHelper.copyStageMSPAApprovals(listStageMSPAApprovals);
            List<Task> taskList1 = [select type, ownerID, recordType.name, whoID from Task where ownerID = :oUser.ID];
            system.assert(taskList1.size()>0);
            system.debug('taskList1::' + taskList1);
            system.assert(taskList1[0].type == 'MSPA Approval');
            system.assert(taskList1[0].ownerID == oUser.ID);
            system.assert(taskList1[0].recordType.name == 'ABB Standard');
            system.assert(taskList1[0].whoID == null);
            
            Test.stopTest();
        }
    }
    
    @isTest static void testCopyData2() {
        User usr  = APTS_LP_TestUtility.getUser();
        System.runAs(usr) {
            
            Test.startTest();
            APTS_LP_TestUtility.getCommonConfigSetting();
            APTS_Stage_Data_Validation_Rules_Setting__c validateUser = new APTS_Stage_Data_Validation_Rules_Setting__c();
            validateUser.name = 'DataMigration';
            validateUser.APTS_Validate_SFDC_User__c = FALSE ;   
            validateUser.APTS_Create_Audit_Fields__c = FALSE;
            insert validateUser;
            
            List<Contact> dummyCon = [select id from Contact where Name = 'ABB DM' limit 1];
            if(dummyCon == null || dummyCon.size() == 0){
                APTS_LP_TestUtility.createContact();
            }
            
            APTS_LP_TestUtility.getDiscountConfig();
            
            APTS_Agreement_SAP_Setting__c agrSetting = new APTS_Agreement_SAP_Setting__c(APTS_Auto_Create_MSPA_In_SAP_On_Approval__c=true,APTS_Country__c='Spain');
            insert agrSetting;            
            Apttus__APTS_Agreement__c agreement = APTS_LP_TestUtility.getAgreement('Test');
            agreement.APTS_SAP_Reference_No__c = 'KrunalPala';
            agreement.APTS_Locale__c = 'es_ES';
            agreement.APTS_Legacy_MSPA__c = TRUE;
            agreement.APTS_Country__c = 'Spain';
            insert agreement;
            
            List<APTS_Stage_MSPA_Approvals__c > listStageMSPAApprovals = new List<APTS_Stage_MSPA_Approvals__c>();
            
            APTS_Stage_MSPA_Approvals__c aptStgAprvl = new APTS_Stage_MSPA_Approvals__c();
            aptStgAprvl.APTS_SPA_Reference__c  = agreement.APTS_SAP_Reference_No__c;
            aptStgAprvl.APTS_Approver__c = 'Krunal Pala';
            aptStgAprvl.APTS_Delegate_Approver__c = 'Krunal Pala';
            aptStgAprvl.APTS_Approval_Action_Date__c = System.today();
            aptStgAprvl.APTS_Actual_Approver__c='Krunal Pala';
            aptStgAprvl.APTS_Created_By__c = 'Krunal Pala';
            aptStgAprvl.APTS_Created_On__c = System.today();
            aptStgAprvl.APTS_Approval_History_Step__c = 'New';
            listStageMSPAApprovals.add(aptStgAprvl);
            
            APTS_DMStageMSPAApprovalHelper.copyStageMSPAApprovals(listStageMSPAApprovals);
            
            Test.stopTest();
        }
    }
}