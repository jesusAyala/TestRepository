/******************************************************************
* @Name: APTS_RefreshAccountCustomerInfoTest
* @Author: Shalin Shah
* @CreateDate: 18th Nov 2015
* @Description: Test class for APTS_RefreshAccountCustomerInfoCntrl, APTS_RefreshAccountCustomerProcessor
******************************************************************/

@isTest
public class APTS_RefreshAccountCustomerInfoTest {
    
    private static APTS_Capture_LSO_Input_Config_Settings__c lodConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();
    
    public static testMethod void test1() {
        User usr = APTS_LP_TestUtility.getUser();
        System.runAs(usr) {
            
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
            Account acc = APTS_LP_TestUtility.getNewAccount('Test Account', 'Spain');
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GIS Approved').getRecordTypeId();
            
            Apttus_Proposal__Proposal__c proposal = APTS_LP_TestUtility.getProposal('Test Proposal');
            
            Test.startTest();
            
            APTS_LP_TestUtility.getDiscountConfig();

            insert acc;
            proposal.APTS_LP_AccountCustomer__c = acc.id;
            proposal.Apttus_Proposal__Approval_Stage__c = 'Presented';
            insert proposal;
            
            createERPReferenceData(usr, acc);
            createLODData(usr, acc);
            
            PageReference pr = Page.APTS_RefreshAccountCustomerInfo;
            pr.getParameters().put('GUID', acc.GUID__c);
            pr.getParameters().put('baseObject', 'Account');
            pr.getParameters().put('name', acc.Name);
            pr.getParameters().put('typeId', acc.RecordTypeId);
            pr.getParameters().put('Id', proposal.Id);
            Test.setCurrentPage(pr);
            
            APTS_RefreshAccountCustomerInfoCntrl controller = new APTS_RefreshAccountCustomerInfoCntrl();    
            controller.onPageLoad();
            controller.lODDataList = getLODReferenceData(acc);
            controller.updateQuote();
            //controller.updateQuoteAndCreateAgreement();
            controller.FetchLodforSelectedAccount();            
            controller.back();
            controller.addErrorMessage('Test Error Message');
            controller.addWarningMessage('Test Warning Message');
            
            Test.stopTest();
        }
    }
    
    
    public static testMethod void test2() {
        User usr = APTS_LP_TestUtility.getUser();
        System.runAs(usr) {
            APTS_LP_TestUtility.getCommonConfigSetting();
            APTS_RefreshAccountCustomerProcessor processor = new APTS_RefreshAccountCustomerProcessor(new APTS_RefreshAccountCustomerInfoCntrl());
            processor.processDatatoSearchLOD(new Map<String, String>());
            processor.getCodeDescriptionIdForLSOCode(null, 'Local Channel');
            processor.getCodeDescriptionIdForLSOCode('P5', 'Local Channel');
            processor.getMasterPickListCodeDesc('P5', null);
        }
    }
    
    
    private static void createERPReferenceData(User usr, Account acc) {
        List<ERP_Reference_Data__c> listERPReferenceData = new List<ERP_Reference_Data__c>();
        
        ERP_Reference_Data__c refData1 = new ERP_Reference_Data__c();
        refData1.Local_Customer_ID__c = '12345678';
        refData1.SAP_Sales_Organization__c = 'ABB';
        refData1.SAP_Distribution_Channel__c = APTS_LP_TestUtility.getDistributionChannel().APTS_Code__c;
        refData1.LSO__c = usr.Default_LSO__c;
        refData1.LBU__c = usr.Default_BU__c;
        refData1.Account_GUID__c = acc.GUID__c;
        refData1.Account__c = acc.Id;
        refData1.Sales_Office_Text__c = 'BT';
        refData1.SAP_Division__c = 'ZZ';
        listERPReferenceData.add(refData1);       
        
        insert listERPReferenceData;
    }
    
    private static void createLODData(User usr, Account acc) {
        List<APTS_LP_Local_Customer_Reference_Data__c> listLODRecords = new List<APTS_LP_Local_Customer_Reference_Data__c>();        
        
        APTS_LP_Local_Customer_Reference_Data__c rec1 = new APTS_LP_Local_Customer_Reference_Data__c();
        rec1.APTS_LP_Account__c = acc.Id;
        rec1.APTS_LP_SAP_Customer_ID__c = '12345678';
        rec1.APTS_LP_Sales_Organisation__c = 'ABB';
        rec1.APTS_LP_Distribution_Channel__c = APTS_LP_TestUtility.getDistributionChannel().APTS_Code__c;
        rec1.APTS_Payment_Terms__c = APTS_LP_TestUtility.getPaymentTerm().APTS_Code__c;
        rec1.APTS_LP_Incoterms__c = APTS_LP_TestUtility.getIncoterm().APTS_Code__c;
        rec1.APTS_LP_Local_Channel__c = APTS_LP_TestUtility.getLocalChannel().APTS_Code__c;
        rec1.APTS_SAP_Division__c = 'ZZ';
        rec1.APTS_External_ID__c = '12345678ABB' + APTS_LP_TestUtility.getDistributionChannel().APTS_Code__c;
        rec1.APTS_Country__c = 'ES';
        
        listLODRecords.add(rec1);
        insert listLODRecords;
        
    }
    
    
    public static List<ERP_Reference_Data__c> getERPReferenceData (User usr, Account acc){
        List<ERP_Reference_Data__c> listERPReferenceData = new List<ERP_Reference_Data__c>();
        ERP_Reference_Data__c  refData1 = new ERP_Reference_Data__c();
        refData1.Local_Customer_ID__c = '12345678';
        refData1.SAP_Sales_Organization__c = 'ABB';
        refData1.SAP_Distribution_Channel__c = APTS_LP_TestUtility.getDistributionChannel().APTS_Code__c;
        refData1.LSO__c = usr.Default_LSO__c;
        refData1.LBU__c = usr.Default_BU__c;
        refData1.Account_GUID__c = acc.GUID__c;
        refData1.Account__c = acc.id;
        listERPReferenceData.add(refData1);
        
        insert listERPReferenceData;        
        return listERPReferenceData;
    }
    
    public static List<APTS_LP_Local_Customer_Reference_Data__c> getLODReferenceData (Account acc){
        List<APTS_LP_Local_Customer_Reference_Data__c> listLODRecords = new List<APTS_LP_Local_Customer_Reference_Data__c>();  
        APTS_LP_Local_Customer_Reference_Data__c  refData1 = new APTS_LP_Local_Customer_Reference_Data__c();
        refData1.APTS_LP_SAP_Customer_ID__c = '12345678';
        refData1.APTS_LP_Sales_Organisation__c = 'ABB';
        refData1.APTS_LP_Distribution_Channel__c = APTS_LP_TestUtility.getDistributionChannel().APTS_Code__c;
        refData1.APTS_LP_Account__c = acc.id;
        refData1.APTS_Country__c = 'Spain';
        refData1.APTS_External_ID__c = '12345678';
        refData1.APTS_Payment_Terms__c = 'Z300';
        refData1.APTS_LP_Incoterms__c = 'CPT';
        refData1.APTS_LP_Local_Channel__c = 'P5';
        listLODRecords.add(refData1);
        
        insert listLODRecords;   
        return listLODRecords;
    }
    
}