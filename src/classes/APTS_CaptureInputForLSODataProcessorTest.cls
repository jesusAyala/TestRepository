@isTest
private class APTS_CaptureInputForLSODataProcessorTest {

    private static Account acc = createNewAccount();
    private static ERP_Reference_Data__c erpRefData  = createERPReferenceData();
    private static Opportunity opp1 = createFirstOpportunity();
    private static Opportunity opp2 = createSecondOpportunity();
    private static APTS_Capture_LSO_Input_Config_Settings__c lodConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();
    private static APTS_LP_Local_Customer_Reference_Data__c ref  = createApttusLSOData();
    private static APTS_Master_Picklist_Table__c masterPicklistTable = createMaterPicklistTable();
    
    private static testMethod void processorTestMethod1() {
        
       
       Test.startTest();
        System.runAs(APTS_LP_TestUtility.getUser()){

            ApexPages.currentPage().getParameters().put('lsoid', ref.id);
            ApexPages.currentPage().getParameters().put('targetObject','Quotation');
            ApexPages.currentPage().getParameters().put('id', opp1.id);
            ApexPages.currentPage().getParameters().put('baseObject', 'Opportunity');
            ApexPages.currentPage().getParameters().put('name', opp1.name);
            ApexPages.currentPage().getParameters().put('type', 'GIS Approved');
            
            APTS_LP_TestUtility.getCommonConfigSetting();
            APTS_CaptureInputForLSODataController controller = new APTS_CaptureInputForLSODataController();
            controller.sQuotationFor= 'Account Customer';
            PageReference pageRef = Page.APTS_CaptureInputForLSOData;
            Test.setCurrentPage(pageRef);
            controller.onPageLoad();
            
            APTS_CaptureInputForLSODataProcessor processor = new APTS_CaptureInputForLSODataProcessor(controller);
            
            String sTargetObjectRecordTypeId  = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(lodConfigSetting.APTS_Quotation_Record_Type__c).getRecordTypeId();
            Map<String, String> dataMap = new Map<String, String>();
            dataMap.put('1','test');
            dataMap.put('baseObjectId', opp1.id);
            dataMap.put('baseObject', 'Opportunity');
            dataMap.put('baseObjectName', opp1.name);
            dataMap.put('accountType', 'GIS Approved');
            dataMap.put('targetObject', 'Quotation');
            dataMap.put('distributionChannel', 'BT');
            dataMap.put('sapDivision', 'ZZ');
            dataMap.put('salesOrganization', 'ABB');            
            dataMap.put('userCountry', 'Spain');
            dataMap.put('userCountryCode', 'ES');
            dataMap.put('targetObjectRecordTypeId', sTargetObjectRecordTypeId);
            dataMap.put('quotationFor', 'Account Customer');
            
            processor.beginToProcessData(dataMap);
            
            processor.createRecordAndGeneratePageReferenceLink(dataMap);
            
            PageReference pg = processor.getEditRecordPageReference();
            processor.getAdditionalLSOOptionsMap();
            processor.isExactlyOneApttusLSOSelected();
            processor.getDescriptionForLSOCode('code', 'codeUsedFor');
            processor.getMasterPickListCodeDesc('code', 'codeUsedFor');
            
        }
      Test.stopTest();
    }
    
    private static testMethod void processorTestMethod1a() {
        
        Test.startTest();
        System.runAs(APTS_LP_TestUtility.getUser()){

            ApexPages.currentPage().getParameters().put('lsoid', ref.id);
            ApexPages.currentPage().getParameters().put('targetObject','Quotation');
            ApexPages.currentPage().getParameters().put('id', opp1.id);
            ApexPages.currentPage().getParameters().put('baseObject', 'Opportunity');
            ApexPages.currentPage().getParameters().put('name', opp1.name);
            ApexPages.currentPage().getParameters().put('type', 'External Non-Buying Account');
            
            APTS_LP_TestUtility.getCommonConfigSetting();
            APTS_CaptureInputForLSODataController controller = new APTS_CaptureInputForLSODataController();
            controller.sQuotationFor= 'Account Customer';
            PageReference pageRef = Page.APTS_CaptureInputForLSOData;
            Test.setCurrentPage(pageRef);
            controller.onPageLoad();
            
            APTS_CaptureInputForLSODataProcessor processor = new APTS_CaptureInputForLSODataProcessor(controller);
            
            String sTargetObjectRecordTypeId  = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(lodConfigSetting.APTS_Quotation_Record_Type__c).getRecordTypeId();
            Map<String, String> dataMap = new Map<String, String>();
            dataMap.put('1','test');
            dataMap.put('baseObjectId', opp1.id);
            dataMap.put('baseObject', 'Opportunity');
            dataMap.put('baseObjectName', opp1.name);
            dataMap.put('accountType', 'External Non-Buying Account');
            dataMap.put('targetObject', 'Quotation');
            dataMap.put('distributionChannel', 'BT');
            dataMap.put('sapDivision', 'ZZ');
            dataMap.put('salesOrganization', 'ABB');            
            dataMap.put('userCountry', 'Spain');
            dataMap.put('userCountryCode', 'ES');
            dataMap.put('targetObjectRecordTypeId', sTargetObjectRecordTypeId);
            dataMap.put('quotationFor', 'Account Customer');
            
            processor.beginToProcessData(dataMap);
            
            processor.createRecordAndGeneratePageReferenceLink(dataMap);
            
            PageReference pg = processor.getEditRecordPageReference();
            processor.getAdditionalLSOOptionsMap();
            processor.isExactlyOneApttusLSOSelected();
            processor.getDescriptionForLSOCode('code', 'codeUsedFor');
            processor.getMasterPickListCodeDesc('code', 'codeUsedFor');
            
        }
       Test.stopTest();
    }
    
    private static testMethod void processorTestMethod2() {
        
        Test.startTest();
        System.runAs(APTS_LP_TestUtility.getUser()){

            ApexPages.currentPage().getParameters().put('lsoid', ref.id);
            ApexPages.currentPage().getParameters().put('id', acc.id);
            ApexPages.currentPage().getParameters().put('baseObject', 'Account');
            ApexPages.currentPage().getParameters().put('name', acc.name);
            ApexPages.currentPage().getParameters().put('type', 'GIS Approved');
            ApexPages.currentPage().getParameters().put('targetObject', 'MSPA'); 
            
            APTS_LP_TestUtility.getCommonConfigSetting();
            APTS_CaptureInputForLSODataController controller = new APTS_CaptureInputForLSODataController();
            controller.sQuotationFor= 'Account Customer';
            PageReference pageRef = Page.APTS_CaptureInputForLSOData;
            Test.setCurrentPage(pageRef);
            controller.onPageLoad();
            
            APTS_CaptureInputForLSODataProcessor processor = new APTS_CaptureInputForLSODataProcessor(controller);
            
            String sTargetObjectRecordTypeId  = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get(lodConfigSetting.APTS_MSPA_Record_Type__c).getRecordTypeId();
            Map<String, String> dataMap = new Map<String, String>();
            dataMap.put('baseObjectId', acc.id);
            dataMap.put('baseObject', 'Account');
            dataMap.put('baseObjectName', acc.name);
            dataMap.put('accountType', 'GIS Approved');
            dataMap.put('targetObject', 'MSPA');
            dataMap.put('distributionChannel', 'BT');
            dataMap.put('sapDivision', 'ZZ');
            dataMap.put('salesOrganization', 'ABB');            
            dataMap.put('userCountry', 'Spain');
            dataMap.put('userCountryCode', 'ES');
            dataMap.put('targetObjectRecordTypeId', sTargetObjectRecordTypeId);
            dataMap.put('quotationFor', 'Account Customer');
            
            processor.beginToProcessData(dataMap);
            
            processor.createRecordAndGeneratePageReferenceLink(dataMap);
            
            PageReference pg = processor.getEditRecordPageReference();
            processor.getAdditionalLSOOptionsMap();
            processor.isExactlyOneApttusLSOSelected();
            processor.getDescriptionForLSOCode('code', 'codeUsedFor');
            processor.getMasterPickListCodeDesc('code', 'codeUsedFor');
            
        }
       Test.stopTest();
    }
    
    private static testMethod void processorTestMethod3() {
        Test.startTest();
        System.runAs(APTS_LP_TestUtility.getUser()){

            ApexPages.currentPage().getParameters().put('id', acc.id);
            ApexPages.currentPage().getParameters().put('baseObject', 'Account');
            ApexPages.currentPage().getParameters().put('name', acc.name);
            ApexPages.currentPage().getParameters().put('type', 'GIS Approved');
            ApexPages.currentPage().getParameters().put('lsoid', ref.id);
            ApexPages.currentPage().getParameters().put('targetObject', 'Quotation'); 
            
            APTS_LP_TestUtility.getCommonConfigSetting();
            APTS_CaptureInputForLSODataController controller = new APTS_CaptureInputForLSODataController();
            controller.sQuotationFor= 'Account Customer';
            PageReference pageRef = Page.APTS_CaptureInputForLSOData;
            Test.setCurrentPage(pageRef);
            controller.onPageLoad();
            
            APTS_CaptureInputForLSODataProcessor processor = new APTS_CaptureInputForLSODataProcessor(controller);
            
            String sTargetObjectRecordTypeId  = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(lodConfigSetting.APTS_Quotation_Record_Type__c).getRecordTypeId();
            Map<String, String> dataMap = new Map<String, String>();
            dataMap.put('baseObjectId', acc.id);
            dataMap.put('baseObject', 'Account');
            dataMap.put('baseObjectName', acc.name);
            dataMap.put('accountType', 'GIS Approved');
            dataMap.put('targetObject', 'Quotation');
            dataMap.put('distributionChannel', 'BT');
            dataMap.put('sapDivision', 'ZZ');
            dataMap.put('salesOrganization', 'ABB');            
            dataMap.put('userCountry', 'Spain');
            dataMap.put('userCountryCode', 'ES');
            dataMap.put('targetObjectRecordTypeId', sTargetObjectRecordTypeId);
            dataMap.put('quotationFor', 'Account Customer');
            
            processor.beginToProcessData(dataMap);
            
            processor.createRecordAndGeneratePageReferenceLink(dataMap);
            
            PageReference pg = processor.getEditRecordPageReference();
            processor.getAdditionalLSOOptionsMap();
            processor.isExactlyOneApttusLSOSelected();
            processor.getDescriptionForLSOCode('code', 'codeUsedFor');
            processor.getMasterPickListCodeDesc('code', 'codeUsedFor');
            
        }
       Test.stopTest();
    }
    
    private static testMethod void processorTestMethod3a() {
        Test.startTest();
        System.runAs(APTS_LP_TestUtility.getUser()){

            ApexPages.currentPage().getParameters().put('id', acc.id);
            ApexPages.currentPage().getParameters().put('baseObject', 'Account');
            ApexPages.currentPage().getParameters().put('name', acc.name);
            ApexPages.currentPage().getParameters().put('type', 'External Non-Buying Account');
            ApexPages.currentPage().getParameters().put('lsoid', ref.id);
            ApexPages.currentPage().getParameters().put('targetObject', 'Quotation'); 
            
            APTS_LP_TestUtility.getCommonConfigSetting();
            APTS_CaptureInputForLSODataController controller = new APTS_CaptureInputForLSODataController();
            controller.sQuotationFor= 'Account Customer';
            PageReference pageRef = Page.APTS_CaptureInputForLSOData;
            Test.setCurrentPage(pageRef);
            controller.onPageLoad();
            
            APTS_CaptureInputForLSODataProcessor processor = new APTS_CaptureInputForLSODataProcessor(controller);
            
            String sTargetObjectRecordTypeId  = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(lodConfigSetting.APTS_Quotation_Record_Type__c).getRecordTypeId();
            Map<String, String> dataMap = new Map<String, String>();
            dataMap.put('baseObjectId', acc.id);
            dataMap.put('baseObject', 'Account');
            dataMap.put('baseObjectName', acc.name);
            dataMap.put('accountType', 'External Non-Buying Account');
            dataMap.put('targetObject', 'Quotation');
            dataMap.put('distributionChannel', 'BT');
            dataMap.put('sapDivision', 'ZZ');
            dataMap.put('salesOrganization', 'ABB');            
            dataMap.put('userCountry', 'Spain');
            dataMap.put('userCountryCode', 'ES');
            dataMap.put('targetObjectRecordTypeId', sTargetObjectRecordTypeId);
            dataMap.put('quotationFor', 'Account Customer');
            
            processor.beginToProcessData(dataMap);
            
            processor.createRecordAndGeneratePageReferenceLink(dataMap);
            
            PageReference pg = processor.getEditRecordPageReference();
            processor.getAdditionalLSOOptionsMap();
            processor.isExactlyOneApttusLSOSelected();
            processor.getDescriptionForLSOCode('code', 'codeUsedFor');
            processor.getMasterPickListCodeDesc('code', 'codeUsedFor');
            
        }
        Test.stopTest();
    }
    private static testMethod void processorTestMethod4() {
        Test.startTest();
        System.runAs(APTS_LP_TestUtility.getUser()){

            ApexPages.currentPage().getParameters().put('lsoid', ref.id);
            ApexPages.currentPage().getParameters().put('targetObject','Quotation');
            ApexPages.currentPage().getParameters().put('id', opp2.id);
            ApexPages.currentPage().getParameters().put('baseObject', 'Opportunity');
            ApexPages.currentPage().getParameters().put('name', opp2.name);
            ApexPages.currentPage().getParameters().put('type', 'GIS Approved');
            
            APTS_LP_TestUtility.getCommonConfigSetting();
            APTS_CaptureInputForLSODataController controller = new APTS_CaptureInputForLSODataController();
            controller.sQuotationFor= 'Account Customer';
            PageReference pageRef = Page.APTS_CaptureInputForLSOData;
            Test.setCurrentPage(pageRef);
            controller.onPageLoad();
            
            APTS_CaptureInputForLSODataProcessor processor = new APTS_CaptureInputForLSODataProcessor(controller);
            
            String sTargetObjectRecordTypeId  = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(lodConfigSetting.APTS_Quotation_Record_Type__c).getRecordTypeId();
            Map<String, String> dataMap = new Map<String, String>();
            dataMap.put('1','test');
            dataMap.put('baseObjectId', opp2.id);
            dataMap.put('baseObject', 'Opportunity');
            dataMap.put('baseObjectName', opp2.name);
            dataMap.put('accountType', 'GIS Approved');
            dataMap.put('targetObject', 'Quotation');
            dataMap.put('distributionChannel', 'BT');
            dataMap.put('sapDivision', 'ZZ');
            dataMap.put('salesOrganization', 'ABB');            
            dataMap.put('userCountry', 'Spain');
            dataMap.put('userCountryCode', 'ES');
            dataMap.put('targetObjectRecordTypeId', sTargetObjectRecordTypeId);
            dataMap.put('quotationFor', '');
            
            processor.beginToProcessData(dataMap);
            
            processor.createRecordAndGeneratePageReferenceLink(dataMap);
            
            PageReference pg = processor.getEditRecordPageReference();
            processor.getAdditionalLSOOptionsMap();
            processor.isExactlyOneApttusLSOSelected();
            processor.getDescriptionForLSOCode('code', 'codeUsedFor');
            processor.getMasterPickListCodeDesc('code', 'codeUsedFor');
            
        }
        Test.stopTest();
    }
    
    private static testMethod void processorTestMethod5() {
        Test.startTest();
        System.runAs(APTS_LP_TestUtility.getUser()){

            ApexPages.currentPage().getParameters().put('lsoid', ref.id);
            ApexPages.currentPage().getParameters().put('targetObject','MSPA');
            ApexPages.currentPage().getParameters().put('id', opp1.id);
            ApexPages.currentPage().getParameters().put('baseObject', 'Opportunity');
            ApexPages.currentPage().getParameters().put('name', opp1.name);
            ApexPages.currentPage().getParameters().put('type', 'GIS Approved');
            
            APTS_LP_TestUtility.getCommonConfigSetting();
            APTS_CaptureInputForLSODataController controller = new APTS_CaptureInputForLSODataController();
            controller.sQuotationFor= 'Account Customer';
            PageReference pageRef = Page.APTS_CaptureInputForLSOData;
            Test.setCurrentPage(pageRef);
            controller.onPageLoad();
            
            APTS_CaptureInputForLSODataProcessor processor = new APTS_CaptureInputForLSODataProcessor(controller);
            
            String sTargetObjectRecordTypeId  = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get(lodConfigSetting.APTS_MSPA_Record_Type__c).getRecordTypeId();
            Map<String, String> dataMap = new Map<String, String>();
            dataMap.put('1','test');
            dataMap.put('baseObjectId', opp1.id);
            dataMap.put('baseObject', 'Opportunity');
            dataMap.put('baseObjectName', opp1.name);
            dataMap.put('accountType', 'GIS Approved');
            dataMap.put('targetObject', 'MSPA');
            dataMap.put('distributionChannel', 'BT');
            dataMap.put('sapDivision', 'ZZ');
            dataMap.put('salesOrganization', 'ABB');            
            dataMap.put('userCountry', 'Spain');
            dataMap.put('userCountryCode', 'ES');
            dataMap.put('targetObjectRecordTypeId', sTargetObjectRecordTypeId);
            dataMap.put('quotationFor', '');
            
            processor.beginToProcessData(dataMap);
            
            processor.createRecordAndGeneratePageReferenceLink(dataMap);
            
            PageReference pg = processor.getEditRecordPageReference();
            processor.getAdditionalLSOOptionsMap();
            processor.isExactlyOneApttusLSOSelected();
            
        }
        Test.stopTest();
    }
    
    private static testMethod void processorTestMethod6() {
        Test.startTest();
        System.runAs(APTS_LP_TestUtility.getUser()){

            APTS_LP_TestUtility.getCommonConfigSetting();
            APTS_CaptureInputForLSODataController controller = new APTS_CaptureInputForLSODataController();

            APTS_CaptureInputForLSODataProcessor processor = new APTS_CaptureInputForLSODataProcessor(controller);
            
            Map<String, String> dataMap = new Map<String, String>();
            dataMap.put('1','test');
            
            processor.beginToProcessData(dataMap);
            
            processor.createRecordAndGeneratePageReferenceLink(dataMap);
            
            PageReference pg = processor.getEditRecordPageReference();
            processor.getAdditionalLSOOptionsMap();
            processor.isExactlyOneApttusLSOSelected();
            
        }
          Test.stopTest();
    }
    /**
    * Method to create test account.
    */
    private static Account createNewAccount() {
        
        acc = new Account();
        acc.Name = 'Test Account';
        acc.BillingCity = 'Barcelona';
        acc.BillingStreet = 'Some street in Barcelona';
        acc.BillingCountry = 'Spain';
        acc.BillingState = 'Barcelona';
        acc.BillingPostalCode = 'BRX12344';
        acc.Channel_Class__c= ''; 
        
        insert acc;
        
        return acc;
    }
    
    /**
    * Method to create Apttus LSO Data for account.
    */
    private static APTS_LP_Local_Customer_Reference_Data__c createApttusLSOData() {
        
        List<APTS_LP_Local_Customer_Reference_Data__c> refList = new List<APTS_LP_Local_Customer_Reference_Data__c>();
        
        ref = new APTS_LP_Local_Customer_Reference_Data__c();
        ref.APTS_LP_Account__c = acc.Id;
        ref.APTS_Country__c = 'ES';
        ref.APTS_LP_Distribution_Channel__c = 'BT';
        ref.APTS_LP_Incoterms__c = 'FOB';
        ref.APTS_LP_Local_Channel__c = 'Test Channel';
        ref.APTS_Payment_Terms__c = 'Test Term';
        ref.APTS_LP_Sales_Organisation__c = 'ABB';
        ref.APTS_LP_SAP_Customer_ID__c = '1234';
        ref.APTS_SAP_Division__c = 'ZZ';
        ref.APTS_External_ID__c = '1234ABBBT';

        insert ref;
        return ref;
      
    }
    
    private static APTS_Master_Picklist_Table__c createMaterPicklistTable() {
        
        masterPicklistTable = new APTS_Master_Picklist_Table__c();
        
        masterPicklistTable.APTS_Code_Used_For__c = 'Incoterm';
        masterPicklistTable.APTS_Code_Description__c = 'Franco a bordo';
        masterPicklistTable.APTS_Code__c='FOB';
        masterPicklistTable.APTS_Locale__c = 'es_ES';
        masterPicklistTable.name= masterPicklistTable.APTS_Code__c + ' - ' + masterPicklistTable.APTS_Code_Description__c;
        insert masterPicklistTable;
        return masterPicklistTable;
    }
    /**
     * Method to create ERP Reference data
     * 
     */
     private static ERP_Reference_Data__c createERPReferenceData() {
        
        erpRefData = new ERP_Reference_Data__c();
        erpRefData.Account__c = acc.Id;
        erpRefData.Country__c  = 'Spain';
        erpRefData.SAP_Sales_Organization__c = 'ABB';
        erpRefData.SAP_Division__c = 'ZZ';
        erpRefData.SAP_Distribution_Channel__c = 'BT';
        erpRefData.Local_Customer_ID__c = '1234';
        erpRefData.LSO__c = 'ES_LP';
        erpRefData.LBU__c = 'test code';
        erpRefData.Sales_Office_Text__c = 'Testing';
        
        insert erpRefData;
        return erpRefData;
     }
    
    /**
    * Method to create test opportunity.
    */
    private static Opportunity createFirstOpportunity() {

        opp1 = new Opportunity();
        opp1.Name = 'Test Optty';
        opp1.Accountid = acc.id;
        opp1.Account_Customer_LSO_Reference_Data__c = erpRefData.id;
        opp1.StageName = 'Negotiation1';
        opp1.CloseDate = Date.today();
        opp1.Channel_Class__c = acc.Channel_Class__c;
        
        insert opp1;
        
        return opp1;
    }
    private static Opportunity createSecondOpportunity() {

        opp2 = new Opportunity();
        // We do not require to create 2 Opportunity - JS
        opp2 = opp1;
        //opp2.Name = 'Test Optty';
        //opp2.Accountid = acc.id;
        opp2.Primary_Partner_LSO_Reference_Data__c = erpRefData.id;
        opp2.StageName = 'Negotiation1';
        opp2.CloseDate = Date.today();
        opp2.Channel_Class__c = acc.Channel_Class__c;
        
        Update opp2;
        
        return opp2;
    }

}