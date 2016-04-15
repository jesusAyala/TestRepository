/*************************************************************
@Name: APTS_LocalCustRefDataTriggerTest
@Author: Shalin Shah
@CreateDate: 5th October, 2015
@Description: Test class for Trigger for records of Apttus Local Customer Reference Data.
@UsedBy: Test Class For Trigger - APTS_LocalCustRefDataTrigger
******************************************************************/

@isTest
public class APTS_LocalCustRefDataTriggerTest {
    
    private static String DEFAULT_SAP_DIVISION = 'ZZ';
    private static APTS_Capture_LSO_Input_Config_Settings__c oLODConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();
    
	/**
	 * Method to test the setting of default values.
	 */
    public static testMethod void testSetDefaultValues() {
        
        Account acc = createNewAccount();
        
        List<APTS_LP_Local_Customer_Reference_Data__c> lsoDataList = new List<APTS_LP_Local_Customer_Reference_Data__c>();
        lsoDataList.add(getApttusLSOData(acc));
        lsoDataList.add(getApttusLSOData(acc));
        
        insert lsoDataList;
        
        List<ID> idList = new List<ID>();
        for(APTS_LP_Local_Customer_Reference_Data__c lsoData : lsoDataList) {
            idList.add(lsoData.id);
        }
        
        lsoDataList = [SELECT APTS_SAP_Division__c FROM APTS_LP_Local_Customer_Reference_Data__c WHERE ID in :idList];
        
        System.assertEquals(DEFAULT_SAP_DIVISION, lsoDataList.get(0).APTS_SAP_Division__c, 'Default SAP division is incorrect.');
        System.assertEquals(DEFAULT_SAP_DIVISION, lsoDataList.get(1).APTS_SAP_Division__c, 'Default SAP division is incorrect.');
    }
    
    /**
     * Method to create dummy Apttus LSO Data.
     */
    private static APTS_LP_Local_Customer_Reference_Data__c getApttusLSOData(Account acc) {
        
        APTS_LP_Local_Customer_Reference_Data__c apttusLSOData = new APTS_LP_Local_Customer_Reference_Data__c();
        
        apttusLSOData.APTS_LP_Account__c = acc.id;
        apttusLSOData.APTS_External_ID__c = 'ABBBT1234567';
        apttusLSOData.APTS_Country__c = 'ES';
        apttusLSOData.APTS_LP_Distribution_Channel__c = 'BT';
        apttusLSOData.APTS_LP_Incoterms__c = 'CPT';
        apttusLSOData.APTS_LP_Local_Channel__c = 'P4';
        apttusLSOData.APTS_Payment_Terms__c = 'Z100';
        apttusLSOData.APTS_LP_Sales_Organisation__c = 'ABB';
        apttusLSOData.APTS_LP_SAP_Customer_ID__c = '1234567';
        
        return apttusLSOData;
    }
    
    /**
     * Method to create New dummy Account.
     */
    private static Account createNewAccount() {
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.BillingCity = 'Barcelona';
        acc.BillingStreet = 'Some street in Barcelona';
        acc.BillingCountry = 'Spain';
        acc.BillingState = 'Barcelona';
        acc.BillingPostalCode = 'BRX12344';
        
        insert acc;
        
        return acc;
    }
}