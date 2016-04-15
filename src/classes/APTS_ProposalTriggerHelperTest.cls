@isTest
private class APTS_ProposalTriggerHelperTest {
    
    private static User user;
    private static final String QUOTATION = 'Quotation';
    private static final String QUOTE_RECORD_TYPE = 'LP'; 
    private static APTS_Master_Picklist_Table__c localChannel = null;
    

    private static testMethod void testProposal() {
        
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
            Account acc=APTS_LP_TestUtility.getNewAccount('Apttus Inc','Spain');
            insert acc;
            APTS_Capture_LSO_Input_Config_Settings__c LSOInputSetting = APTS_LP_TestUtility.getLODConfigSetting();
            APTS_Master_PickList_Table__c mpt = APTS_LP_TestUtility.getMasterPickListTableLocalChannelWithInsert();
            
           
            Apttus_Config2__PriceList__c pl = new Apttus_Config2__PriceList__c();
            pl.APTS_Country__c='Spain';
            insert pl;
            
            APTS_LP_TestUtility.getDiscountConfig();
            
            List<Apttus_Proposal__Proposal__c> listProposal = new List<Apttus_Proposal__Proposal__c>();
            
            Apttus_Proposal__Proposal__c propSO = APTS_LP_TestUtility.getProposal('Test Proposal');
            
            propSO.APTS_LP_AccountCustomer__c = acc.id;
            propSO.APTS_LP_Sales_Person__c = user.id;
            propSO.APTS_Product_Configuration__c=false;
            propSO.RecordTypeID = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(QUOTE_RECORD_TYPE).getRecordTypeId();
            listProposal.add(propSO);
            
            
            Apttus_Proposal__Proposal__c propSO1 = APTS_LP_TestUtility.getProposal('Test Proposal1');
            propSO1.APTS_Product_Configuration__c=true;
            propSO1.APTS_SAP_Reference_No__c='Test';
            propSO1.RecordTypeID = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(QUOTE_RECORD_TYPE).getRecordTypeId();
            listProposal.add(propSO1);
            
            insert listProposal;
            System.Debug('@@@@@@@@@'+propSO1.APTS_QuotationType__c);
            Map<Id,Apttus_Proposal__Proposal__c> mapOldProposal = new Map<Id,Apttus_Proposal__Proposal__c>();
            mapOldProposal.put(propSO.ID,propSO);
       
            
            Map<Id,Apttus_Proposal__Proposal__c> mapNewProposal = new Map<Id,Apttus_Proposal__Proposal__c>();
      
            mapNewProposal.put(propSO1.ID,propSO1);
            Test.startTest();
            APTS_ProposalTriggerHelper.automatePriceListonProposal(listProposal);
            APTS_ProposalTriggerHelper.populateAccountCustomerAndExpirationDate(listProposal);
            Test.stopTest();
         }
    }


     private static testMethod void testgetAvailableDiscounts() {
        
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
            
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
        	Account acc=APTS_LP_TestUtility.getNewAccount('Apttus Inc','Spain');
            insert acc;
            APTS_Capture_LSO_Input_Config_Settings__c LSOInputSetting = APTS_LP_TestUtility.getLODConfigSetting();
            APTS_Master_PickList_Table__c mpt = APTS_LP_TestUtility.getMasterPickListTableLocalChannelWithInsert();
            
            Apttus_Config2__PriceList__c pl = new Apttus_Config2__PriceList__c();
            pl.APTS_Country__c='Spain';
            insert pl;
            
            APTS_LP_TestUtility.getDiscountConfig();
      
            List<Apttus_Proposal__Proposal__c> listProposal = new List<Apttus_Proposal__Proposal__c>();
            Apttus_Proposal__Proposal__c propSO = APTS_LP_TestUtility.getProposal('Test Proposal');
           
            propSO.APTS_LP_AccountCustomer__c = acc.id;
            propSO.APTS_LP_Sales_Person__c = user.id;
            propSO.APTS_Product_Configuration__c=false;
            propSO.RecordTypeID = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(QUOTE_RECORD_TYPE).getRecordTypeId();
            listProposal.add(propSO);
            
            Apttus_Proposal__Proposal__c propSO1 = APTS_LP_TestUtility.getProposal('Test Proposal1');
            propSO1.APTS_Product_Configuration__c=true;
            propSO1.APTS_SAP_Reference_No__c='Test';
            propSO1.RecordTypeID = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(QUOTE_RECORD_TYPE).getRecordTypeId();
            listProposal.add(propSO1);
            insert listProposal;
            
            System.Debug('@@@@@@@@@'+propSO1.APTS_QuotationType__c);
            Map<Id,Apttus_Proposal__Proposal__c> mapOldProposal = new Map<Id,Apttus_Proposal__Proposal__c>();
            mapOldProposal.put(propSO.ID,propSO);
    
        
           Map<Id,Apttus_Proposal__Proposal__c> mapNewProposal = new Map<Id,Apttus_Proposal__Proposal__c>();
   
           Test.startTest();
           APTS_ProposalTriggerHelper.getAvailableDiscounts(mapOldProposal);
        
            APTS_ProposalTriggerHelper.getAvailableDiscounts(mapNewProposal);
            Test.stopTest();
         }
    }
    
     private static testMethod void updateMSPARefNumber() {
        
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
        APTS_LP_TestUtility.getDiscountConfig();  
        APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
        Account acc=APTS_LP_TestUtility.getNewAccount('Apttus Inc','Spain');
        insert acc;
        APTS_Capture_LSO_Input_Config_Settings__c LSOInputSetting = APTS_LP_TestUtility.getLODConfigSetting();
        APTS_Master_PickList_Table__c mpt = APTS_LP_TestUtility.getMasterPickListTableLocalChannelWithInsert();
     
        Apttus_Config2__PriceList__c pl = new Apttus_Config2__PriceList__c();
        pl.APTS_Country__c='Spain';
        insert pl;
      
        List<Apttus_Proposal__Proposal__c> listProposal = new List<Apttus_Proposal__Proposal__c>();
       
        Map<Id,Apttus_Proposal__Proposal__c> mapNewProposal = new Map<Id,Apttus_Proposal__Proposal__c>();
        
        Apttus_Proposal__Proposal__c propSO = APTS_LP_TestUtility.getProposal('Test Proposal');
        propSO.APTS_LP_Sales_Person__c = user.id;
        propSO.APTS_Product_Configuration__c=false;
        propSO.APTS_SAP_Reference_No__c='Test';
        
        insert propSo;
        
        Apttus_Proposal__Proposal__c prop1 = [Select id,APTS_SAP_Reference_No__c,APTS_QuotationType__c 
                                                    from Apttus_Proposal__Proposal__c where Id =: propSo.id];
        
        System.Debug('@@@@@@@@@'+prop1.APTS_QuotationType__c);
        
        APTS_MSPA_Ref_Number__c mspaRefNo = new APTS_MSPA_Ref_Number__c();
        mspaRefNo.APTS_Is_Used__c = FALSE;
        mspaRefNo.APTS_MSPA_Ref_ID__c = prop1.APTS_SAP_Reference_No__c;
               
        Test.startTest();
        
        insert mspaRefNo;
        mapNewProposal.put(prop1.ID,prop1);
    
        //APTS_ProposalTriggerHelper.updateMSPARefNumber(mapNewProposal);
        
        Test.stopTest();
         }
    }
    
    
    private static testMethod void deleteMSPARefNumber() {
        
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
        APTS_LP_TestUtility.getDiscountConfig();  
        APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
        Account acc=APTS_LP_TestUtility.getNewAccount('Apttus Inc','Spain');
        insert acc;
        APTS_Capture_LSO_Input_Config_Settings__c LSOInputSetting = APTS_LP_TestUtility.getLODConfigSetting();
        APTS_Master_PickList_Table__c mpt = APTS_LP_TestUtility.getMasterPickListTableLocalChannelWithInsert();
     
        Apttus_Config2__PriceList__c pl = new Apttus_Config2__PriceList__c();
        pl.APTS_Country__c='Spain';
        insert pl;
      
        List<Apttus_Proposal__Proposal__c> listProposal = new List<Apttus_Proposal__Proposal__c>();
        Map<Id,Apttus_Proposal__Proposal__c> mapNewProposal = new Map<Id,Apttus_Proposal__Proposal__c>();
        
        Apttus_Proposal__Proposal__c propSO = APTS_LP_TestUtility.getProposal('Test Proposal');
        propSO.APTS_LP_Sales_Person__c = user.id;
        propSO.APTS_Product_Configuration__c=false;
        propSO.APTS_SAP_Reference_No__c='Test';
        
        insert propSo;
        
        Apttus_Proposal__Proposal__c prop1 = [Select id,APTS_SAP_Reference_No__c,APTS_QuotationType__c 
                                                    from Apttus_Proposal__Proposal__c where Id =: propSo.id];
        
        APTS_MSPA_Ref_Number__c mspaRefNo = new APTS_MSPA_Ref_Number__c();
        mspaRefNo.APTS_Is_Used__c = FALSE;
        mspaRefNo.APTS_MSPA_Ref_ID__c = prop1.APTS_SAP_Reference_No__c;
        Test.startTest();
        
        insert mspaRefNo;
        mapNewProposal.put(prop1.ID,prop1);
    
       // APTS_ProposalTriggerHelper.deleteMSPARefNumber(mapNewProposal);
        
        Test.stopTest();
         }
    }
   
    
     private static testMethod void createEmptyCart() {
        
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
        
        APTS_LP_TestUtility.getDiscountConfig();
        APTS_Capture_LSO_Input_Config_Settings__c LSOInputSetting = APTS_LP_TestUtility.getLODConfigSetting();
        Account acc=APTS_LP_TestUtility.getNewAccount('Apttus Inc','Spain');
        APTS_LP_TestUtility.getCustomSetting();
        APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
        Test.startTest();
        insert acc;
        
        Apttus_Config2__PriceList__c pl = new Apttus_Config2__PriceList__c();
        pl.APTS_Country__c='Spain';
        pl.CurrencyIsoCode='EUR';    
        insert pl;
            
        Apttus_Proposal__Proposal__c propSO = APTS_LP_TestUtility.getProposal('Test Proposal');
        propSO.APTS_Product_Configuration__c = False;
        propSO.APTS_LP_AccountCustomer__c = acc.id;
        propSO.APTS_LP_Sales_Person__c = user.id;
        insert propSO;
        
        Apttus_Proposal__Proposal__c prop1 = [Select id,APTS_SAP_Reference_No__c,APTS_QuotationType__c 
                                              from Apttus_Proposal__Proposal__c where Id =: propSo.id];
        prop1.APTS_LP_AccountCustomer__c = acc.id;
        prop1.APTS_LP_Sales_Person__c = user.id;
        prop1.APTS_Product_Configuration__c = True;
        
        update prop1;
    
        Test.stopTest();
    }
}
    
    
    public static  testMethod void setSAPIdOnChangeInQuoteFields(){
            
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
            Test.startTest();
            
            APTS_LP_TestUtility.getDiscountConfig(); 
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
            Account acc=APTS_LP_TestUtility.getNewAccount('Apttus Inc','Spain');
            insert acc;
            APTS_Capture_LSO_Input_Config_Settings__c LSOInputSetting = APTS_LP_TestUtility.getLODConfigSetting();
            APTS_Master_PickList_Table__c mpt = APTS_LP_TestUtility.getMasterPickListTableLocalChannelWithInsert();
            
            Apttus_Config2__PriceList__c pl = new Apttus_Config2__PriceList__c();
            pl.APTS_Country__c='Spain';
            insert pl;
            
            Map<Id,Apttus_Proposal__Proposal__c> mapNewProposal = new Map<Id,Apttus_Proposal__Proposal__c>();
            
            Apttus_Proposal__Proposal__c propSO = APTS_LP_TestUtility.getProposal('Test Proposal');
            propSO.APTS_LP_Sales_Person__c = user.id;
            propSO.APTS_Product_Configuration__c=false;
            propSO.APTS_SAP_Reference_No__c='Test';
            propSO.APTS_LP_AccountCustomer__c = acc.id;
            insert propSo;
            
            Apttus_Proposal__Proposal__c prop1 = [Select id,APTS_SAP_Reference_No__c,APTS_QuotationType__c,APTS_Distribution_Channel__r.APTS_Code__c 
                                                  from Apttus_Proposal__Proposal__c where Id =: propSo.id];
                                                  
            System.Debug('@@@@@@@@@'+prop1);
            
            prop1.Apttus_Proposal__Proposal_Name__c = 'Test';
            prop1.APTS_LP_Distribution_Channel__c = 'NI';
            prop1.APTS_Distribution_Channel__c = getDistributionChannel().Id;
            prop1.APTS_Local_Channel__c = getLocalChannel().Id;
            prop1.APTS_Incoterms__c = getIncoterm().Id;
            prop1.APTS_Payment_Terms__c = getPaymentTerm().Id;
            prop1.APTS_Locale__c = 'es_ES';
            prop1.RecordTypeId = getRecordType(QUOTATION).id;
            prop1.APTS_Sales_Office__c = getSalesOffice().Id;
            prop1.APTS_Country__c = 'Spain';
            prop1.APTS_LP_Sales_Organization__c = 'ABB';
            prop1.APTS_LP_No_Approval_Rule_Matched__c = FAlSE;
            prop1.APTS_GTV_Code__c = 'GTV-Code';
            prop1.APTS_Account_Type__c = 'Account Customer';
           
            getDiscountConfig();
           
            APTS_LP_Local_Customer_Reference_Data__c ref = new APTS_LP_Local_Customer_Reference_Data__c();
            ref.APTS_LP_Account__c = acc.id;
            ref.APTS_Country__c = 'Spain';
            ref.APTS_LP_Distribution_Channel__c = APTS_LP_TestUtility.getDistributionChannel().APTS_Code__c;
            ref.APTS_LP_Incoterms__c  = APTS_LP_TestUtility.getIncoterm().APTS_Code__c;
            ref.APTS_LP_Local_Channel__c = APTS_LP_TestUtility.getLocalChannel().APTS_Code__c;
            ref.APTS_External_ID__c = '1';
            ref.APTS_Payment_Terms__c = APTS_LP_TestUtility.getPaymentTerm().APTS_Code__c;
            insert ref;
            
            update prop1;
            
            system.debug('DC11***' + prop1);
            
            Apttus_Proposal__Proposal__c prop2 = [Select id,APTS_SAP_Reference_No__c,APTS_QuotationType__c,APTS_Distribution_Channel__r.APTS_Code__c 
                                                  from Apttus_Proposal__Proposal__c 
                                                  where Id =: prop1.id];
            
            prop2.Apttus_Proposal__Proposal_Name__c = 'Test1';
            
            update prop2;
            
            system.debug('DC111***' + prop2.APTS_Distribution_Channel__r.APTS_Code__c);
           
            Test.stopTest();
        } 
        
    }
    
    
     public static  testMethod void setSAPIdOnChangeInQuoteFields2(){
            
        user  = APTS_LP_TestUtility.getUser();
       
        System.runAs(user) {
            
        Test.startTest();
        
        APTS_Capture_LSO_Input_Config_Settings__c LSOInputSetting = APTS_LP_TestUtility.getLODConfigSetting();
        APTS_LP_TestUtility.getDiscountConfig();
        APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
        Account acc=APTS_LP_TestUtility.getNewAccount('Apttus Inc','Spain');
        insert acc;
        
        APTS_LP_Local_Customer_Reference_Data__c ref = new APTS_LP_Local_Customer_Reference_Data__c();
        ref.APTS_LP_Account__c = acc.id;
        ref.APTS_Country__c = 'Spain';
        ref.APTS_LP_Distribution_Channel__c = APTS_LP_TestUtility.getDistributionChannel().APTS_Code__c;
        ref.APTS_LP_Incoterms__c  = APTS_LP_TestUtility.getIncoterm().APTS_Code__c;
        ref.APTS_LP_Local_Channel__c = APTS_LP_TestUtility.getLocalChannel().APTS_Code__c;
        ref.APTS_External_ID__c = '1';
        ref.APTS_Payment_Terms__c = APTS_LP_TestUtility.getPaymentTerm().APTS_Code__c;
        insert ref;
        
        Apttus_Config2__PriceList__c pl = new Apttus_Config2__PriceList__c();
        pl.APTS_Country__c='Spain';
        insert pl;
        
        Apttus_Proposal__Proposal__c propSO = APTS_LP_TestUtility.getProposal('Test Proposal');
        propSO.APTS_LP_Sales_Person__c = user.id;
        propSO.APTS_LP_AccountCustomer__c = acc.id;
        insert propSo;
        
        Apttus_Proposal__Proposal__c prop1 = [Select id,APTS_SAP_Reference_No__c,APTS_QuotationType__c 
                                              from Apttus_Proposal__Proposal__c where Id =: propSo.id];
                                              
        prop1.APTS_Product_Configuration__c=false;
        prop1.APTS_SAP_Reference_No__c='Test';
        prop1.APTS_GTV_Code__c = 'GTV-Code';
        prop1.APTS_Account_Type__c = 'Account Customer';
        
        update prop1;
       
        Test.stopTest();
        } 
        
    }
    
    
     private static  Apttus_Proposal__Proposal__c getProposal(string sName){
        Apttus_Proposal__Proposal__c oProposal = new Apttus_Proposal__Proposal__c();
        oProposal.Apttus_Proposal__Proposal_Name__c = sName;
        oProposal.APTS_LP_Distribution_Channel__c = 'NI';
        oProposal.APTS_Distribution_Channel__c = getDistributionChannel().Id;
        oProposal.APTS_Local_Channel__c = getLocalChannel().Id;
        oProposal.APTS_Incoterms__c = getIncoterm().Id;
        oProposal.APTS_Payment_Terms__c = getPaymentTerm().Id;
        oProposal.APTS_Locale__c = 'es_ES';
        oProposal.RecordTypeId = getRecordType(QUOTATION).id;
        oProposal.APTS_Sales_Office__c = getSalesOffice().Id;
        oProposal.APTS_Country__c = 'Spain';
        oProposal.APTS_LP_Sales_Organization__c = 'ABB';
        oProposal.APTS_LP_No_Approval_Rule_Matched__c = FAlSE;
        oProposal.APTS_GTV_Code__c = 'GTV-Code';
        oProposal.APTS_Account_Type__c = 'Account Customer';
        return oProposal;
    }  
    
    
     private static LSO_Field_Entries__c getSalesOffice() {
         
        LSO_Field_Entries__c salesOffice = new LSO_Field_Entries__c();
        salesOffice.Active__c = TRUE;
        salesOffice.PickList_Code__c = 'Z112';
        salesOffice.PickList_Description__c = 'BT/Niessen Barcelona';
        salesOffice.Controlling_Field__c = 'LSO Reference Data.Country';
        salesOffice.Value__c = 'Spain';
        salesOffice.Country__c = 'Spain';
        salesOffice.LSO_Pick_List_Value_Name__c = 'LSO Reference Data. Sales Office';
        
        insert salesOffice;
        return salesOffice;
    }
    
     private static APTS_Master_Picklist_Table__c getDistributionChannel() {
         
        APTS_Master_Picklist_Table__c distributionChannel = new APTS_Master_Picklist_Table__c();
        distributionChannel.name = 'NI';
        distributionChannel.APTS_Locale__c = 'es_ES';
        distributionChannel.APTS_Code__c = 'NI';
        distributionChannel.APTS_Code_Used_For__c = 'Distribution Channel';
        
        insert distributionChannel;
        return distributionChannel;
    }
    
    public static APTS_Master_Picklist_Table__c getLocalChannel() {
        
        if(localChannel == null){
            localChannel = new APTS_Master_Picklist_Table__c();
            localChannel = new APTS_Master_Picklist_Table__c();
            localChannel.Name = 'P4 - OEMS';
            localChannel.APTS_Code__c = 'P4';
            localChannel.APTS_Code_Description__c = 'OEMS';
            localChannel.APTS_Code_Used_For__c = 'Local Channel';
            localChannel.APTS_Locale__c = 'es_ES';
            insert localChannel;
        }
        
        return localChannel;
    }
    
    public static APTS_Master_Picklist_Table__c getIncoterm() {
        
        APTS_Master_Picklist_Table__c incoterm = new APTS_Master_Picklist_Table__c();
        incoterm.Name = 'EXW - Ex-Works';
        incoterm.APTS_Code__c = 'EXW';
        incoterm.APTS_Code_Description__c = 'Ex-Works';
        incoterm.APTS_Code_Used_For__c = 'Incoterm';
        incoterm.APTS_Locale__c = 'es_ES';
        
        insert incoterm;
        return incoterm;
    }
    
    public static APTS_Master_Picklist_Table__c getPaymentTerm() {
        
        APTS_Master_Picklist_Table__c paymentTerm = new APTS_Master_Picklist_Table__c();
        paymentTerm.Name = 'Z006 - Cobro a 60 d¡as';
        paymentTerm.APTS_Code__c = 'Z006';
        paymentTerm.APTS_Code_Description__c = 'Cobro a 60 d¡as';
        paymentTerm.APTS_Locale__c = 'es_ES';
        paymentTerm.APTS_Code_Used_For__c = 'Payment Term';
       
        insert paymentTerm;
        
        return paymentTerm;
    }
    
    private static RecordType getRecordType(String recordTypeFor) {
        String recordTypeName = null;
        String objectType = null;
        
        if(QUOTATION.equals(recordTypeFor)) {
            recordTypeName = QUOTE_RECORD_TYPE;
            objectType = 'Apttus_Proposal__Proposal__c';
        } else if('OPPORTUNITY'.equals(recordTypeFor)){
            recordTypeName = 'Initial';
            objectType = 'Opportunity';
        }
        
        RecordType rt = [SELECT id, name FROM RecordType WHERE name = :recordTypeName AND sObjectType = :objectType];
        return rt;
    }
    
     public static List<APTS_Discounts_Config__c> getDiscountConfig() {
        List<APTS_Discounts_Config__c> listDiscountConfig = new List<APTS_Discounts_Config__c>();
        
        APTS_Discounts_Config__c quoteConfig = new APTS_Discounts_Config__c();
        //quoteConfig.name = 'Spain/Quotation-LP/P5/LP';
        quoteConfig.APTS_Country__c = 'Spain';
        quoteConfig.APTS_Quote_Record_Type__c = QUOTE_RECORD_TYPE;
        quoteConfig.APTS_Division__c = 'LP';
        quoteConfig.APTS_Hierarchy_Level_MS__c = '3';
        quoteConfig.APTS_IsActive__c = TRUE;
        quoteConfig.APTS_Additional_Discount__c = TRUE;
        quoteConfig.APTS_Substitute_Discount__c = TRUE;
        quoteConfig.APTS_Additional_Discounts_Hierarchy__c = TRUE;
        quoteConfig.APTS_Net_Discount_Hierarchy__c = TRUE;
        quoteConfig.APTS_Substitutional_Discounts_Hierarchy__c = TRUE;
        quoteConfig.APTS_Net_Discount__c = TRUE;
        quoteConfig.APTS_Local_Channel__c = getLocalChannel().id;
        listDiscountConfig.add(quoteConfig);
       
        
        insert listDiscountConfig;
        
        return listDiscountConfig;
    }
    
    
    public static testMethod void testpopulateFieldsOnQuote(){
        
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
        APTS_LP_TestUtility.getDiscountConfig();  
        APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
        Account acc=APTS_LP_TestUtility.getNewAccount('Apttus Inc','Spain');
        insert acc;
        APTS_Capture_LSO_Input_Config_Settings__c LSOInputSetting = APTS_LP_TestUtility.getLODConfigSetting();
        
     
        Apttus_Config2__PriceList__c pl = new Apttus_Config2__PriceList__c();
        pl.APTS_Country__c='Spain';
        insert pl;
      
        List<Apttus_Proposal__Proposal__c> listProposal = new List<Apttus_Proposal__Proposal__c>();
        
        Apttus_Proposal__Proposal__c propSO = APTS_LP_TestUtility.getProposal('Test Proposal');
        insert propSO;
        
        Apttus_Proposal__Proposal__c prop1 = [Select id,APTS_SAP_Reference_No__c,APTS_QuotationType__c 
                                                    from Apttus_Proposal__Proposal__c where Id =: propSO.id];
        
        System.Debug('@@@@@@@@@'+prop1.APTS_QuotationType__c);
        
        prop1.APTS_LP_Sales_Person__c = user.id;
        prop1.APTS_Product_Configuration__c = false;
        prop1.APTS_SAP_Reference_No__c='Test';
        prop1.APTS_Local_Channel__c = null;
        prop1.APTS_Distribution_Channel__c = null;
        prop1.APTS_Incoterms__c = null;
        
        listProposal.add(prop1);
        
        Test.startTest();
        
        APTS_ProposalTriggerHelper.autoPopulateDefaultValues(listProposal);
        
        Test.stopTest();
        } 
    }
    
    private static testMethod void testShareAccesswithTeammember() {
        
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
            
            Opportunity opp = APTS_LP_TestUtility.getOpportunity('Test Oppty');
            insert opp;
            
            OpportunityTeammember oppteammember = new OpportunityTeammember();
            
            oppteammember.UserId = APTS_LP_TestUtility.getSalesUser().id;
            //oppteammember.OpportunityAccessLevel = 'Edit';
            oppteammember.OpportunityId = opp.id;
            insert oppteammember;
            
            Account acc=APTS_LP_TestUtility.getNewAccount('Apttus Inc','Spain');
            insert acc;
            APTS_Capture_LSO_Input_Config_Settings__c LSOInputSetting = APTS_LP_TestUtility.getLODConfigSetting();
            APTS_Master_PickList_Table__c mpt = APTS_LP_TestUtility.getMasterPickListTableLocalChannelWithInsert();
            
           
            Apttus_Config2__PriceList__c pl = new Apttus_Config2__PriceList__c();
            pl.APTS_Country__c='Spain';
            insert pl;
            
            APTS_LP_TestUtility.getDiscountConfig();
            
            List<Apttus_Proposal__Proposal__c> listProposal = new List<Apttus_Proposal__Proposal__c>();
            
            Apttus_Proposal__Proposal__c propSO = APTS_LP_TestUtility.getProposal('Test Proposal');
            
            propSO.APTS_LP_AccountCustomer__c = acc.id;
            propSO.APTS_LP_Sales_Person__c = user.id;
            propSO.APTS_Product_Configuration__c=false;
            propSO.RecordTypeID = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(QUOTE_RECORD_TYPE).getRecordTypeId();
            propSO.Apttus_Proposal__Opportunity__c = opp.id;
            propSO.APTS_Is_Placeholder_Quote__c = true;
            listProposal.add(propSO);
            
            insert listProposal;
            
            Test.startTest();
            APTS_ProposalTriggerHelper.shareAccesswithOpportunityTeam(listProposal);
            Test.stopTest();
         }
    }

    /*
    public static  testMethod void autoPopulatePrimaryCustomer(){
        
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
            APTS_LP_TestUtility.getDiscountConfig();
            test.startTest();
            Account acc=APTS_LP_TestUtility.getNewAccount('Apttus Inc','Spain');
            insert acc;
            
            Account acc1 = APTS_LP_TestUtility.getNewAccount('Apttus India','Spain');
            acc1.Main_Local_Street__c = 'XYZ1ccc';
            acc1.BillingCity = 'Madrids';
            acc1.BillingStreet = 'ABCsdsdf';
            acc1.BillingCountry = 'Spain';
            acc1.GUID__c = 'G14138157';
            acc1.Migration_ID__c = '800000009';
            insert acc1;
            
            Opportunity opp = new Opportunity();
            opp.Name = 'TestOpp';
            opp.accountId  = acc.id;
            opp.StageName = 'Prospecting';
            opp.CloseDate = Date.newInstance(2016,5,6);
            insert opp;
            
            Partner  partner = new Partner();
            partner.OpportunityId  = opp.id;
            partner.IsPrimary  = TRUE;
            partner.AccountToId  = acc1.id;
            partner.Role = 'Broker';
            insert partner;
            
            Apttus_Proposal__Proposal__c propSO = APTS_LP_TestUtility.getProposal('Test Proposal');
            propSo.Apttus_Proposal__Opportunity__c = opp.id;
            insert propSO;
            
            propSO.APTS_SAP_Reference_No__c = 'SAP1';
            update propSO;
            test.stopTest();
            
            OpportunityPartner oppPartner = [SELECT Id, IsPrimary, AccountToId, OpportunityId
                                             FROM OpportunityPartner];
            system.debug('HS::' + oppPartner);
            
        }
    } */
}