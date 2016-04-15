@isTest
public class APTS_ProposalTriggerTest {
    
    static Apttus_Config2__PriceList__c testPriceList;
    static User user;
    static Account acc ;
    static Opportunity opp;
    static Apttus_Proposal__Proposal__c proposal;
    static Apttus__APTS_Agreement__c agreement;
    static Partner partner;
    
    static APTS_Capture_LSO_Input_Config_Settings__c oLODConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();
    
    // Test-Case for Account-Customer &&PriceList for Spain Region
    // PriceList should be automated based on Account-Customer 
    public static testMethod void automatePriceListBasedOnCustomerAccount(){
        test.startTest();
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) { 
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
            acc =  APTS_LP_TestUtility.getNewAccount('Test-Account', 'Spain');
            insert acc;
            testPriceList = APTS_LP_TestUtility.getPriceList(acc,'Spain');
            insert testPriceList;
            proposal = APTS_LP_TestUtility.getProposal('TestProposal');
            //proposal.RecordType = 'LP';
            insert proposal;
            proposal.APTS_LP_AccountCustomer__c = acc.id;        
            update proposal;
        }
        test.stopTest();
    }
    
    // Test-Case for SalesPerson && PriceList for Spain Region
    // PriceList should be automated based on SalesUser
    public static testMethod void automatePriceListBasedOnSalesAccount(){
        test.startTest();
        
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) { 
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
            acc =  APTS_LP_TestUtility.getNewAccount('Test-Account', 'Spain');
            insert acc;
            testPriceList = APTS_LP_TestUtility.getPriceList(acc,'Spain');
            insert testPriceList;
            proposal = APTS_LP_TestUtility.getProposal('TestProposal');
            //proposal.APTS_Local_Channel__c = APTS_LP_TestUtility.getLocalChannel().id;
            insert proposal;
            proposal.APTS_LP_Sales_Person__c = user.id;  
            
            update proposal;
        }
        test.stopTest();
    }
    
    
    // Test method when no priceList is avialable for either Customer-Account and SalesPerson
    public static testMethod void automateAgreementwithNoPriceList(){
        test.startTest();
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) { 
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
            acc =  APTS_LP_TestUtility.getNewAccount('Test-Account', 'India');
            insert acc;
            testPriceList = APTS_LP_TestUtility.getPriceList(acc,'Spain');
            insert testPriceList;
            proposal = APTS_LP_TestUtility.getProposal('TestProposal');
            insert proposal;
            proposal.APTS_LP_Sales_Person__c = user.id;
            update proposal;
        }
        test.stopTest();
    }
    
    //Start: Added By Kruti Shah (Test method for GetAvailableDiscounts)
    
    public static testMethod void GetAvailableDiscounts(){
        test.startTest();
        
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) { 
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
            acc =  APTS_LP_TestUtility.getNewAccount('Test-Account', 'Spain');
            insert acc;
            
            testPriceList = APTS_LP_TestUtility.getPriceList(acc,'Spain');
            insert testPriceList;
            
            APTS_Capture_LSO_Input_Config_Settings__c LSOInputSetting = APTS_LP_TestUtility.getLODConfigSetting();
            APTS_Master_PickList_Table__c mpt = APTS_LP_TestUtility.getMasterPickListTableLocalChannelWithInsert();
            
            //APTS_LP_TestUtility.getDiscountConfig();
            
            proposal = APTS_LP_TestUtility.getProposal('TestProposal');
            proposal.APTS_Hierarchy_level__c = '3';
            proposal.APTS_LP_AccountCustomer__c = acc.id;
            
            proposal.APTS_Country__c = 'Spain';
            
            insert proposal;
            proposal.APTS_Hierarchy_level__c = '3';
            update proposal;
            
        }
        
        test.stopTest();
    }
    //End: Added By Kruti Shah (Test method for GetAvailableDiscounts)
    
    public static testMethod void autoPopulateMSPARefNumber(){
        // Get MSPA Reference Number
        test.startTest();
        
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
            //APTS_Constants con = new APTS_Constants();
            //String quoteRecordType = APTS_Constants.QUOTATION_RECORD_TYPE;
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
            APTS_MSPA_Ref_Number__c refNumber801 = APTS_LP_TestUtility.getMSPARefNumber('0000000801');
            insert refNumber801;
            APTS_MSPA_Ref_Number__c refNumber802 = APTS_LP_TestUtility.getMSPARefNumber('0000000802');
            insert refNumber802;
            
            //Get Account 
            acc =  APTS_LP_TestUtility.getNewAccount('Test-Account', 'Spain');
            
            // Get Proposal
            proposal = APTS_LP_TestUtility.getProposal('TestProposal');
            insert proposal;
            
            //Update Proposal
            proposal.APTS_LP_AccountCustomer__c = acc.id;        
            proposal.APTS_SAP_Reference_No__c = '0000000801';
            update proposal;
            
            List<Apttus_Proposal__Proposal__c> proposal1 = [SELECT APTS_SAP_Reference_No__c FROM Apttus_Proposal__Proposal__c WHERE Id =:proposal.Id];
            
            //Positive Test Case : Expected value found.
            System.assertEquals(proposal1[0].APTS_SAP_Reference_No__c, refNumber801.APTS_MSPA_Ref_ID__c);
            
            //Negative Test Case : Expected value not found.
            System.assertNotEquals(proposal1[0].APTS_SAP_Reference_No__c, refNumber802.APTS_MSPA_Ref_ID__c);
            
            delete proposal;
        }
        test.stopTest();
    }
    
    // Test method when Product Configuration Checkbox is Checked while updating records
    public static testMethod void changeProductConfigToTrue(){
        test.startTest();
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) { 
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCustomSetting();
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
            proposal = APTS_LP_TestUtility.getProposal('TestProposal');
            insert proposal;
            
            proposal.APTS_Product_Configuration__c = True;
            update proposal;
        }
        test.stopTest();
    }
    
    //Test method to auto populate Primary Partner Customer
    public static testMethod void autopopulatePrimaryPartnerCuatomer(){
        
        
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) { 
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
            //Get Account 
            agreement =  APTS_LP_TestUtility.getAgreement('TestAgreement');
            insert agreement;
            
            acc =  APTS_LP_TestUtility.getNewAccount('Test-Account', 'Spain');
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ABB ICV').getRecordTypeId();
            insert acc;
            
            Account acc1 = new Account();
            acc1.name = 'Another Test Account';
            acc1.Primary_Address_Country__c = 'Spain';
            acc1.Main_Local_City__c = 'Barcelona';
            acc1.Main_Local_Street__c = 'ABC';
            acc1.BillingCity = 'Barcelona';
            acc1.BillingStreet = 'ABC';
            acc1.BillingCountry = 'Spain';
            acc1.GUID__c = 'G04791158';
            insert acc1;
            
            //Get Opportunity
            opp = APTS_LP_TestUtility.getOpportunity('TestOpp');
            opp.AccountId = acc.Id;
            opp.StageName = 'Prospecting';
            opp.CloseDate = date.parse('06/07/2016');
            insert opp;
            
            test.startTest();
          
            //Get Opportunity Partner
            partner = APTS_LP_TestUtility.getPartner(opp.Id,acc1.Id);
            insert partner;
            
            // Get Agreement
            proposal = APTS_LP_TestUtility.getProposal('TestProposal');
            proposal.Apttus_Proposal__Opportunity__c = opp.Id;
            insert proposal;
            
            test.stopTest();
        }
       
    }
    private static testMethod void myUnitTest() {
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
            
            Test.startTest();
            
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
            Account accnt = APTS_LP_TestUtility.getNewAccount('Test', 'Spain');
            insert accnt;
            
            Apttus_Proposal__Proposal__c propSo = APTS_LP_TestUtility.getProposal('Test Proposal');
            propSo.APTS_Quotation_Account_Type__c = APTS_Constants.ACCOUNTTYPE_ACCEND;
            propSo.APTS_Account_End_User__c = accnt.Id;
            insert propSo;
            
            Apttus_Proposal__Proposal__c propSo1 = APTS_LP_TestUtility.getProposal('Test Proposal');
            propSo1.APTS_Quotation_Account_Type__c = APTS_Constants.ACCOUNTTYPE_PARTNER;
            propSo1.APTS_LP_Account_End_User__c = accnt.Id;
            insert propSo1;
            
            propSo1.APTS_Quotation_Account_Type__c = 'Account Customer';
            propSo1.APTS_LP_AccountCustomer__c = accnt.Id;
            update propSo1;
            
            APTS_Master_Picklist_Table__c paymentTerm = new APTS_Master_Picklist_Table__c();
            paymentTerm.Name = 'Z114 - Cobro a 30 d¡as';
            paymentTerm.APTS_Code__c = 'Z114';
            paymentTerm.APTS_Code_Description__c = 'Cobro a 30 d¡as';
            paymentTerm.APTS_Code_Used_For__c = 'Payment Term';
            paymentTerm.APTS_Locale__c = 'es_ES';
            insert paymentTerm;
            
            APTS_LP_Local_Customer_Reference_Data__c refData = new APTS_LP_Local_Customer_Reference_Data__c();
            refData.APTS_LP_Account__c = accnt.Id;
            refData.APTS_LP_SAP_Customer_ID__c = '12345678';
            refData.APTS_SAP_Division__c = 'ZZ';
            refData.APTS_LP_Sales_Organisation__c = 'ABB';
            refData.APTS_LP_Distribution_Channel__c = 'BT';
            refData.APTS_LP_Incoterms__c = 'CPT';
            refData.APTS_LP_Local_Channel__c = 'P5';
            refData.APTS_Payment_Terms__c = 'Z114';
            refData.APTS_Country__c = 'ES';
            refData.APTS_External_ID__c = '12345678ABBBT';
            insert refData;
            
            propSo1.APTS_Payment_Terms__c = paymentTerm.Id;
            update propSo1;
            
            Apttus_Proposal__Proposal__c prop1 = [Select id,APTS_SAP_Reference_No__c,APTS_QuotationType__c from Apttus_Proposal__Proposal__c where Id =: propSo.id];
            delete prop1;
            
            Test.stopTest();
        }
    }
}