/*************************************************************
@Name: APTS_AgreementTriggerHelper
@Author: Nishi Kushwaha
@CreateDate: 29/08/2015
@Description: This class acts as a helper for various events on Agreement Object
@UsedBy: Trigger APTS_AgreementTrigger
******************************************************************
@ModifiedBy: Nishi Kushwaha,Hardik Shah
@ModifiedDate: 02/09/2015
@ChangeDescription: Created a method "OnBeforeUpdate()" which calls API to create Empty cart when Product Configuration Checkbox = True
@ChangeDescription: Created a method "OnBeforeUpdate()" which automates PriceList based on account customer
@ChangeDescription: Created a method autopopulateMSPARefNumber,updateMSPARefNumber which is  pre-populated in Agreement-Header
PS: @ModifiedBy and @ChangeDescription can be repeated multiple time, based on number of changes made to the original process.

@ModifiedBy: Chetan Patel
@ModifiedDate: 10/11/2015
@ChangeDescription: replaced APTS_Channel__c with APTS_Local_Channel__c of Discounts Config object

@ModifiedBy: Shahid Ali
@ModifiedDate: 30/12/2015
@ChangeDescription: Added method updateLODForNonBuyingAgreement

******************************************************************/

public with sharing class APTS_AgreementTriggerHelper {
    
    /*
    * Axay: Validation to restrict user to edit MSPA at certain stage of Agreement
    */
    public static void readOnlyMSPAValidation(Map<Id, Apttus__APTS_Agreement__c > mapOldAgreement, Map<Id, Apttus__APTS_Agreement__c > mapNewAgreement){
        
        String sysAdminProfileId = null;
        List<Profile> profileList = [SELECT Id FROM Profile WHERE Name = :APTS_Constants.ADMIN_PROFILE LIMIT 1];
        
        if(profileList != null && !profileList.isempty()){
            sysAdminProfileId = profileList[0].Id;
        }
        
        for(Apttus__APTS_Agreement__c newAgreement : mapNewAgreement.values()){
                
                Boolean fireValidation = newAgreement.Apttus__Status__c == mapOldAgreement.get(newAgreement.Id).Apttus__Status__c ? true : false;
                
                if((sysAdminProfileId == null || UserInfo.getProfileId() != sysAdminProfileId) && fireValidation && 
                    (mapOldAgreement.get(newAgreement.Id).Apttus__Contract_Start_Date__c != newAgreement.Apttus__Contract_Start_Date__c ||
                    newAgreement.Apttus__Contract_End_Date__c != mapOldAgreement.get(newAgreement.Id).Apttus__Contract_End_Date__c)
                    && (newAgreement.Apttus__Status__c == APTS_Constants.MSPA_STATUS_APPROVED || 
                        newAgreement.Apttus__Status__c == APTS_Constants.MSPA_STATUS_REJECTED ||
                        newAgreement.Apttus__Status__c == APTS_Constants.MSPA_STATUS_FAILED_TO_LOAD_SAP ||
                        newAgreement.Apttus__Status__c == APTS_Constants.STATUS_APPROVED_ACTION_REQ ||
                        newAgreement.Apttus__Status__c == APTS_Constants.MSPA_STATUS_EXPIRED ||
                        newAgreement.Apttus__Status__c == APTS_Constants.MSPA_BLOCKED ||
                        newAgreement.Apttus__Status__c == APTS_Constants.MSPA_STATUS_APPROVAL_IN_PROGRESS ||
                        newAgreement.Apttus__Status__c == APTS_Constants.MSPA_STATUS_GENERATED ||
                        newAgreement.Apttus__Status__c == APTS_Constants.MSPA_STATUS_PRESENTED ||
                        newAgreement.Apttus__Status__c == APTS_Constants.MSPA_STATUS_RECALLED)){
                    
                    //System.debug('Validation Rule fired.');    
                    newAgreement.addError(System.Label.APTS_MSPA_Read_Only_Validation_Error);
                }
        }
    }
    /*
    * Added By: Axay
    * set the Status/Status Category to 'Request' / 'Generated' after Generate of Agreement
    * 
    */
    public static void changeAgreementStatusAfterGenerate(Map<Id, Apttus__APTS_Agreement__c > mapOldAgreement, Map<Id, Apttus__APTS_Agreement__c > mapNewAgreement){
        
        for(Apttus__APTS_Agreement__c newAgreement : mapNewAgreement.values()){
            
            if(newAgreement.Apttus__Status_Category__c == APTS_Constants.MSPA_STATUS_IN_SIGNATURES && newAgreement.Apttus__Status_Category__c != mapOldAgreement.get(newAgreement.Id).Apttus__Status_Category__c &&
                newAgreement.Apttus__Status__c == APTS_Constants.MSPA_STATUS_READY_SIGNATURES && newAgreement.Apttus__Status__c != mapOldAgreement.get(newAgreement.Id).Apttus__Status__c){
                
                newAgreement.Apttus__Status__c = APTS_Constants.MSPA_STATUS_GENERATED;
                newAgreement.Apttus__Status_Category__c = APTS_Constants.MSPA_STATUS_CATEGORY_REQUEST;
            }
        }
    }
    
    /*
    @Addedby:Ganga Vemula,req#30
    @Method to get available to discounts for each line
    @param:Agreement/MSPA
    */
    public static void getAvailableDiscounts(Map < Id, Apttus__APTS_Agreement__c > mapNewAgreement) {

        if (mapNewAgreement.values().size() == 0) {
            return;
        }

        //store multiple values of Channel,Country,RecordType to get compare with Proposal Data
        Set < String > setChannel = new Set < String > ();
        Set < String > setCountry = new Set < String > ();
        Set < String > setRecordType = new Set < String > ();

        for (Apttus__APTS_Agreement__c oNewagreement: mapNewAgreement.values()) {
            setChannel.add(oNewagreement.APTS_Local_Channel__c);
            setCountry.add(oNewagreement.APTS_Country__c);
            setRecordType.add(oNewagreement.APTS_LP_MSPA_Type__c);
        }
        
        // Get Discount Config Records
        map<Id, APTS_Discounts_Config__c> mapDiscountConfig = APTS_LP_QueryUtility.getAgreementDiscountConfig(APTS_Constants.MSPA_TYPE);
        
        try {
            for (Apttus__APTS_Agreement__c oNewAgreement: mapNewAgreement.values()) {
                System.debug('*****AXAY1: '+oNewAgreement.APTS_Local_Channel__c);
                //APTS_Discounts_Config__c oDiscountConfig = getDiscountsConfig(listDiscountBackupSobj, oNewAgreement);
                APTS_Discounts_Config__c oDiscountConfig = APTS_LP_QueryUtility.getDiscountConfigRecord(oNewAgreement.APTS_Local_Channel__c, mapDiscountConfig);
                System.debug('****AXAY1:DiscountConfig: '+oDiscountConfig);
                if(oDiscountConfig == null){
                    System.debug('*****AXAY1: disocount config null');
                    oNewAgreement.addError(Label.APTS_NoDiscConfig);
                }
                string sProductDiscounttypes = '';
                string sHierarchyDiscounttypes = '';
                //system.debug('KS--> Inside Function');
                //get config admin object data based on country,channel and record type on MSPA


                if (oDiscountConfig != null) {

                    //check if additional Discount is available for product                                          
                    if (oDiscountConfig.APTS_Additional_Discount__c) {
                        sProductDiscounttypes = 'A';
                    }
                    //check if Net Discount is available for product
                    if (oDiscountConfig.APTS_Net_Discount__c) {
                        sProductDiscounttypes += 'N';
                    }
                    //check if Substitute Discount is available for product
                    if (oDiscountConfig.APTS_Substitute_Discount__c) {
                        sProductDiscounttypes += 'S';
                    }

                    //get available discounts for hierarchy products
                    if (oDiscountConfig.APTS_Additional_Discounts_Hierarchy__c) {
                        sHierarchyDiscounttypes = 'A';
                    }
                    //check if Net Discount is available for Hierarchy
                    if (oDiscountConfig.APTS_Net_Discount_Hierarchy__c) {
                        sHierarchyDiscounttypes += 'N';
                    }
                    //check if Substitute Discount is available for hierarchy
                    if (oDiscountConfig.APTS_Substitutional_Discounts_Hierarchy__c) {
                        sHierarchyDiscounttypes += 'S';
                    }

                    //system.debug('discounts available ***' + sProductDiscounttypes);
                    //assign product discounts to agreement
                    oNewAgreement.APTS_Product_Discounts__c = sProductDiscounttypes;
                    //assign hierarchy discounts for agreement
                    oNewAgreement.APTS_Hierarchy_Discounts__c = sHierarchyDiscounttypes;
                    oNewAgreement.APTS_Hierarchy_level__c = oDiscountConfig.APTS_Hierarchy_Level_MS__c;

                    //system.debug('agreement discs***' + oNewAgreement.APTS_Product_Discounts__c);

                }

            }
        } catch (exception e) {
            system.debug('There is some exception exist');
        }

    }

    public static APTS_Discounts_Config__c getDiscountsConfig(List < APTS_Discounts_Config__c > listDisConfig, Apttus__APTS_Agreement__c oAgreement) {
        for (APTS_Discounts_Config__c oDiscConfig: listDisConfig) {
            if (oDiscConfig.APTS_Local_Channel__c == oAgreement.APTS_Local_Channel__c && oDiscConfig.APTS_Country__c == oAgreement.APTS_Country__c && oDiscConfig.APTS_Record_Type__c == oAgreement.APTS_LP_MSPA_Type__c) {
                //system.debug('KS--> Discounts Backup Object' + oDiscConfig);
                return oDiscConfig;
            }
        }
        return null;
    }

    /*
    @Addedby:Hardik Shah
    @Method to automate priceList when new Agreement is created
    @param:Agreement/MSPA
    */
    public static void automatePriceList(Map < Id, Apttus__APTS_Agreement__c > mapAgreement) {

        // Map of PriceList, Country is Key and Price-Id is value    
        Map < String, Id > mapPriceCountry = new Map < String, Id > ();
        // Map of PriceList, Pricelist currency is Key and Price-Id is value    
        Map < String, Id > mapPriceListCurrency = new Map < String, Id > ();
        // Map of PriceList, Pricelist id is key and pricelist currency is value    
        Map < Id, String > mapPriceListIdCurrency = new Map < Id, String > ();
        // Set of Account-CustomerId on AgreementRecord 
        Set < String > setAgreementCustomerId = new Set < String > ();
        // Set of SalesPersonId on AgreementRecord
        Set < String > setAgreementSalesPersonId = new Set < String > ();
        // Boolean flag to check whether CustomerAccount has country field
        Boolean bCustomerAccountExists = false;
        List < Apttus__APTS_Agreement__c > listAgreementToBeUpdated = new List < Apttus__APTS_Agreement__c > ();
        // Fetch PriceList
        List < Apttus_Config2__PriceList__c > listPrice = APTS_LP_QueryUtility.getPriceList();
        //Set of opportunity
        Set < Id > setOpportunityId = new Set < Id > ();
        //List of Opportunity
        List<Opportunity> lstOpportunity = new List<Opportunity> ();
        //Opportunity Map
        Map <id, opportunity> mapOpportunity = new Map <id, opportunity> ();


        for (Apttus_Config2__PriceList__c price: listPrice) {
            //system.debug('<<<< Price List >>>>'+ price);
            mapPriceCountry.put(price.APTS_Country__c, price.id);
            mapPriceListCurrency.put(price.CurrencyISOCode, price.id);
            mapPriceListIdCurrency.put(price.id,price.CurrencyISOCode);
        }
        // Perform the required operation if PriceList exists        
        if (mapPriceCountry.size() > 0) {


            for (Apttus__APTS_Agreement__c oAgreement: mapAgreement.values()) {
                if(oAgreement != null && oAgreement.Apttus__Related_Opportunity__c != null 
                    && Label.APTS_SetPriceListUsingCurrency == 'true' && mapPriceListCurrency.size()>0){
                        System.debug('Inside if of APTS_SetPriceListUsingCurrency == true condition');
                    setOpportunityId.add(oAgreement.Apttus__Related_Opportunity__c);
                }
                
            }
            
            if(setOpportunityId.size() > 0){
                lstOpportunity = [select id,CurrencyIsoCode from Opportunity where id in : setOpportunityId];
                for(Opportunity oppty : lstOpportunity){
                    mapOpportunity.put(oppty.id, oppty);
                }
            }
            
            // Loop over the agreement to fetch Account-CustomerId and SalesPersonId
            for (Apttus__APTS_Agreement__c oAgreement: mapAgreement.values()) {
                if(oAgreement != null && oAgreement.Apttus__Related_Opportunity__c != null 
                    && Label.APTS_SetPriceListUsingCurrency == 'true' && mapPriceListCurrency.size()>0 && mapOpportunity.size() > 0){
                        System.debug('Inside if of APTS_SetPriceListUsingCurrency == true condition');
                        
                        setPricelistusingOpportunityCurrency(oAgreement, mapOpportunity.get(oAgreement.Apttus__Related_Opportunity__c), mapPriceListCurrency);
                        
                        if(oAgreement.Apttus_CMConfig__PriceListId__c != null){
                            System.debug('Price List currency got :: ' + mapPriceListIdCurrency.get(oAgreement.Apttus_CMConfig__PriceListId__c));
                            oAgreement.CurrencyISOCode = mapPriceListIdCurrency.get(oAgreement.Apttus_CMConfig__PriceListId__c);
                        }else{
                            System.debug('Valid Price List Not found ! ');
                            oAgreement.addError(Label.APTS_ValidPriceListNotFound);
                        }
                        
                }else{
                    System.debug('Inside else of APTS_SetPriceListUsingCurrency == true means false condition or opportunity is null from account');
                    // Only Agreement that have Record-Type as MSPA   
                    if (oAgreement.APTS_LP_MSPA_Type__c != null && String.isNotBlank(oAgreement.APTS_LP_MSPA_Type__c) && oAgreement.APTS_LP_MSPA_Type__c.equals(APTS_Constants.MSPA_TYPE)) {
                        setAgreementCustomerId.add(oAgreement.APTS_LP_AccountCustomer__c);
                        setAgreementSalesPersonId.add(oAgreement.APTS_LP_Sales_Person__c);
                        listAgreementToBeUpdated.add(oAgreement);
                    }else{
                        //valid proposal is not found.
                        System.debug('Valid MSPA Agreement not found');
                    }
                }
            }
            
            if (listAgreementToBeUpdated.size() > 0) {
                // Map of Account Object,based on Set of Account-CustomerId
                map < id, Account > mapCustomerAccount = APTS_LP_QueryUtility.getAccount(setAgreementCustomerId);
                // Map of User Object,based on Set of SalesUserId
                map < id, User > mapSalesAccount = APTS_LP_QueryUtility.getUser(setAgreementSalesPersonId);
                // Loop over the agreement to retriev Customer-Account country if exists
                for (Apttus__APTS_Agreement__c agreement: listAgreementToBeUpdated) {
                    bCustomerAccountExists = false;
                    if (mapCustomerAccount != null && mapCustomerAccount.containsKey(agreement.APTS_LP_AccountCustomer__c)) {
                        Account acct = mapCustomerAccount.get((agreement.APTS_LP_AccountCustomer__c));
                        if (acct != null && acct.Primary_Address_Country__c != null && mapPriceCountry.containsKey(acct.Primary_Address_Country__c)) {
                            Id priceID = mapPriceCountry.get(acct.Primary_Address_Country__c);
                            agreement.Apttus_CMConfig__PriceListId__c = priceID;
                            bCustomerAccountExists = true;
                        }
                    }
                    if (mapSalesAccount != null && mapSalesAccount.containsKey(agreement.APTS_LP_Sales_Person__c) && !bCustomerAccountExists) {
                        User salesAcct = mapSalesAccount.get((agreement.APTS_LP_Sales_Person__c));
                        if (salesAcct != null && salesAcct.Country != null && mapPriceCountry.containsKey(salesAcct.Country)) {
                            Id priceID = mapPriceCountry.get(salesAcct.Country);
                            agreement.Apttus_CMConfig__PriceListId__c = priceID;
                        }
                    }
                    
                    if(agreement.Apttus_CMConfig__PriceListId__c != null){
                        System.debug('Price List currency got :: ' + mapPriceListIdCurrency.get(agreement.Apttus_CMConfig__PriceListId__c));
                        agreement.CurrencyISOCode = mapPriceListIdCurrency.get(agreement.Apttus_CMConfig__PriceListId__c);
                    }else{
                        System.debug('Valid Price List Not found ! ');
                        agreement.addError(Label.APTS_ValidPriceListNotFound);
                    }
                    
                } // End of Loop
            } // End of If Condition
            
        } // End of PriceList If condition
    }

    /*
    @Addedby:Mohit Patel
    @Method to set price list according to currency of opportunity
    @param:Quotation, Opportunity, pricelistmap
    */
    private static void setPricelistusingOpportunityCurrency(Apttus__APTS_Agreement__c oAgreement, Opportunity oppty , Map < String, Id > mapPriceListCurrency){
        
        System.debug('@@Got the opportunity : '+ oppty);
        if(oppty != null && oppty.CurrencyIsoCode != null){
            System.debug('@@Got the opportunity currency code: '+ oppty.CurrencyIsoCode);
            Id priceID = mapPriceListCurrency.get(oppty.CurrencyIsoCode);
            oAgreement.Apttus_CMConfig__PriceListId__c = priceID;
            
        }
    }
    
    /*AXay: modified the logic for whole method
    @Addedby:Hardik Shah
    @Method to Auto-Populate SAP-Ref No.
    @param:Agreement/MSPA
    */
    public static void autopopulateMSPARefNumber(List < Apttus__APTS_Agreement__c > listAgreement) {
        // Get Quotation Id from Page Parameter
        String sQuoteId = '';
        String sPageURL = '';
        
        
        system.debug('ApexPages.currentPage()' + ApexPages.currentPage());
        if(ApexPages.currentPage() != null) {
            if(ApexPages.currentPage().getParameters().get('id') != null){
                sQuoteId = ApexPages.currentPage().getParameters().get('id');              
            }
            
            if(ApexPages.currentPage().getUrl() != null){
                sPageURL = ApexPages.currentPage().getUrl();              
            }      
        }
        system.debug('<<<< Quote Id in Agreement >>>>: '+ sQuoteId);
        
        Organization orgDetails = [SELECT Id, LanguageLocaleKey, DefaultLocaleSidKey  
                                   FROM Organization WHERE Id = :UserInfo.getOrganizationId() LIMIT :APTS_Constants.SELECT_SOQL_LIMIT];
        
        List<APTS_MSPA_Ref_Number__c> lstAgreementRefNo = new List<APTS_MSPA_Ref_Number__c>();
                   
        for(Apttus__APTS_Agreement__c oagreement: listAgreement){
            
            // Set Quote Id to relate Agreement and Quotation - +JS: 11-Feb-2016(#2221)
            if (sPageURL !='') {
                Boolean result = sPageURL.contains('ProposalAgreementNew?');
                if(result == true && !String.isBlank(sQuoteId)){
                    if ( oagreement.Apttus_QPComply__RelatedProposalId__c == null  ) {
                        oagreement.Apttus_QPComply__RelatedProposalId__c = sQuoteId;
                    } 
                }
            }
            
            // All the new agreement should have Status field as 'Draft'
            //system.debug('<<<< Status >>>>: '+ oagreement.Apttus__Status__c);
            if(!oagreement.APTS_Legacy_MSPA__c){
                oagreement.Apttus__Status__c = APTS_Constants.AGREEMENT_STATUS_DRAFT;
                oagreement.Apttus_Approval__Approval_Status__c = APTS_Constants.QUOTE_APPROVAL_STATUS_NOT_SUBMITTED;
                oagreement.APTS_Approval_Required__c = False;
            }
                     
            if(!oagreement.APTS_Legacy_MSPA__c && String.isBlank(oagreement.APTS_Quotation_Id__c) && APTS_Constants.MSPA_TYPE.equals(oagreement.APTS_LP_MSPA_Type__c)){
                lstAgreementRefNo.add(new APTS_MSPA_Ref_Number__c(APTS_Is_Used__c = true));
            }
            
            //Axay: added logic to auto-populate Locale
            if(UserInfo.getLocale() != null){
                oagreement.APTS_Locale__c = UserInfo.getLocale();
            }else{
                oagreement.APTS_Locale__c = orgDetails.DefaultLocaleSidKey;
            }
            
            if(oagreement.APTS_Quotation_Id__c == null){//If Agreement directly created from Account
                oagreement.Apttus__Contract_Start_Date__c = System.today();
                oagreement.Apttus__Contract_End_Date__c = System.today().addMonths(3);
            }
            
            oagreement.Apttus__Subtype__c = oAgreement.APTS_LP_MSPA_Type__c == APTS_Constants.MSPA_TYPE ? APTS_Constants.MSPA_SUBTYPE_PROJECT : APTS_Constants.MSPA_SUBTYPE_DEFAULT;//defaulted to Project for Spain
            //oagreement.Apttus__AllowableOutputFormats__c = 'Pdf; Doc; Docx';
            //end of the code of Axay
        }
        
        if(lstAgreementRefNo.size() > 0){
            
            insert lstAgreementRefNo;
            
            lstAgreementRefNo = [SELECT Id, APTS_Reference_Number__c 
                                FROM APTS_MSPA_Ref_Number__c
                                WHERE ID IN :lstAgreementRefNo LIMIT :APTS_Constants.SELECT_SOQL_LIMIT];
                                
           Integer index = 0;
           Integer offsetNum = 0;
           
           APTS_MSPA_Ref_Offset__c offsetObj = APTS_MSPA_Ref_Offset__c.getValues('MSPA Offset');
           
           if(offsetObj != null){
               offsetNum = offsetObj.APTS_Offset_Value__c != null ? Integer.valueOf(offsetObj.APTS_Offset_Value__c) : 0;
           }
           //system.debug('******offset value'+offsetNum );
           
            for(Apttus__APTS_Agreement__c agreement : listAgreement){
               
               if(String.isBlank(agreement.APTS_Quotation_Id__c) && APTS_Constants.MSPA_TYPE.equals(agreement.APTS_LP_MSPA_Type__c)){
                    offsetNum = offsetNum + Integer.valueOf(lstAgreementRefNo[index++].APTS_Reference_Number__c);
                    agreement.APTS_SAP_Reference_No__c = String.valueOf(offsetNum);//offsetNum + lstAgreementRefNo[index++].APTS_Reference_Number__c;
                    //System.debug('**setting sap ref#: '+agreement.APTS_SAP_Reference_No__c);
                }
           }
           
           delete lstAgreementRefNo;
        }
    }

    /*
    @Addedby: Nishi Kushwaha
    @Method: to Auoto Populate Primary Partner Customer related to Opportunity
    @param:MSPA
    */
    public static void autopopulatePrimaryPartnerCustomer(List < Apttus__APTS_Agreement__c > listAgreements) {

        Set < Id > setOpportunityId = new Set < Id > ();
        Map < Id, Id > mapOppAccount = new Map < Id, Id > ();
        Set<String> setMPLSalesOfficeCode = new set<String>();
        
        // Get ALl Sales Office records from Master PickList
        map<Id,APTS_Master_Picklist_Table__c> mapMPLSalesOffice = APTS_LP_CommonUtil.getMPLSalesOffice();
        
        //System.debug('##Jignesh '+mapMPLSalesOffice);
                
         // Prepare map of Sales Office Code
            if(mapMPLSalesOffice != null && mapMPLSalesOffice.size() > 0){
                for(Apttus__APTS_Agreement__c oAgreement : listAgreements){
                
                    if(null != mapMPLSalesOffice.get(oAgreement.APTS_Sales_Office_LP__c)){
                    
                        setMPLSalesOfficeCode.add(mapMPLSalesOffice.get(oagreement.APTS_Sales_Office_LP__c).APTS_Code__c);
                        
                    }    
                }
            }
            
        // Get Sales Office Data from LSO Field Entry object
        map<String, LSO_Field_Entries__c> mapLSOSalesOffice = APTS_LP_CommonUtil.getMapOfSalesOfficeFromLSO(setMPLSalesOfficeCode);
        
        for (Apttus__APTS_Agreement__c oAgreement: listAgreements) {

            setOpportunityId.add(oAgreement.Apttus__Related_Opportunity__c);
            
            // Set LSO field entry lookup
                
                if(null != mapMPLSalesOffice.get(oAgreement.APTS_Sales_Office_LP__c)){
                
                    //system.debug('<<<< Sales Office >>>> '+mapMPLSalesOffice.get(oAgreement.APTS_Sales_Office_LP__c).APTS_Code__c+'========'+oAgreement.APTS_Country__c);
                    LSO_Field_Entries__c oSalesOfficeLSO = APTS_LP_CommonUtil.getLSOSalesOffice(mapLSOSalesOffice, mapMPLSalesOffice.get(oAgreement.APTS_Sales_Office_LP__c).APTS_Code__c, oAgreement.APTS_Country__c);
                    //System.debug('<<<< LSO Sales Office >>>>: '+ oSalesOfficeLSO);
                    if(oSalesOfficeLSO != null){
                        oAgreement.APTS_Sales_Office__c = oSalesOfficeLSO.Id;
                    }else{
                        oAgreement.APTS_Sales_Office__c = null;
                    //oProposal.addError(Label.APTS_InValidSalesOffice);
                    }
                
                }
            
            
        }
        //Get Primary Partner Information from Oportunity Partner
        //List<OpportunityPartner> listOppPartner = [SELECT Id, IsPrimary,AccountToId,OpportunityId FROM OpportunityPartner WHERE IsPrimary = TRUE AND OpportunityId IN: setOpportunityId];

        for (OpportunityPartner oOppPartner: [SELECT Id, IsPrimary, AccountToId, OpportunityId
        FROM OpportunityPartner WHERE IsPrimary = TRUE AND OpportunityId IN: setOpportunityId]) {

            mapOppAccount.put(oOppPartner.OpportunityId, oOppPartner.AccountToId);
        }
        for (Apttus__APTS_Agreement__c oAgreement: listAgreements) {
            //Check whether Record Type belongs to LP Spain and Opp Account Map is not empty
            if (APTS_Constants.MSPA_TYPE.equals(oAgreement.APTS_LP_MSPA_Type__c) && mapOppAccount.isEmpty() != True) {

                if (mapOppAccount.containsKey(oAgreement.Apttus__Related_Opportunity__c)) {

                    oAgreement.APTS_LP_Account_End_User__c = mapOppAccount.get(oAgreement.Apttus__Related_Opportunity__c);

                }
            }
        }
    }

    /**
     * Method to populate the selected Account Customer in Account (OOB) field.
     * This method will be called before insert and before update.
     * 
     * @owner : Shalin Shah <sshah@apttus.com>
     * @param : List<Apttus__APTS_Agreement__c> - new Agreement list.
     */
    public static void populateAccountCustomerInAccount(List < Apttus__APTS_Agreement__c > listNewAgreement) {
        // Get Agreement SAP settings
        //APTS_Agreement_SAP_Setting__c oAgrSAPSetting = APTS_LP_QueryUtility.getAgreementSAPSetting
        map<Id, APTS_Agreement_SAP_Setting__c> mapAgrSAPSetting = APTS_LP_QueryUtility.getAgreementSAPSetting();
        //system.debug('<<<< AGR SAP Settings >>>>'+ mapAgrSAPSetting);
        // Get Discount Config Records
        map<Id, APTS_Discounts_Config__c> mapDiscountConfig = APTS_LP_QueryUtility.getAgreementDiscountConfig(APTS_Constants.MSPA_TYPE);
        
        for (Apttus__APTS_Agreement__c oAgreement: listNewAgreement) {
            APTS_Agreement_SAP_Setting__c oAgrSAPSetting = APTS_LP_QueryUtility.findAgreementSAPSetting(mapAgrSAPSetting, oAgreement.APTS_Country__c);
            //system.debug('<<<< Find SAP >>>>'+ oAgrSAPSetting +'========='+ oAgreement.APTS_Country__c);
            
            if(oAgrSAPSetting != null){
                // Set field if need to hide Block MSPA button
                oAgreement.APTS_Need_To_Block_MSPA__c = oAgrSAPSetting.APTS_Block_MSPA_Creation_In_SAP__c;
            }
            
            oAgreement.Apttus__Account__c = oAgreement.APTS_LP_AccountCustomer__c;
            if(!string.isBlank(oAgreement.APTS_Local_Channel__c)){
                system.debug('<<<< Agreement Local Channel >>>>' + oAgreement.APTS_Local_Channel__c);
                APTS_Discounts_Config__c oDiscountConfig = APTS_LP_QueryUtility.getDiscountConfigRecord(oAgreement.APTS_Local_Channel__c, mapDiscountConfig);
                system.debug('<<<< Discount config >>>> : '+ oDiscountConfig);
                
                if(oDiscountConfig == null){
                    System.debug('*****AXAY2: disocount config null');
                    oAgreement.addError(Label.APTS_NoDiscConfig);
                }
            }
            
        }
    }

    /*
     * Added by: Ganga Vemula
     * Method to call MSPA creation in SAP
     * Return type: void
     * Param: trigger.newmap, trigger.oldmap
     */

    public static void CreateMSPAInSAP(Map < Id, Apttus__APTS_Agreement__c > oldAgreementMap, Map < Id, Apttus__APTS_Agreement__c > newAgreementMap) {

        set < Id > agrmtIds = new set < Id > ();
        Set < id > uniqueNames = new Set < id > ();
        set<string> countryNames=new set<string>();
        map<string,boolean> countryMap=new map<string,boolean>();
        list<Apttus__APTS_Agreement__c> agreementsTobeUpdated=new list<Apttus__APTS_Agreement__c>();
        
        //get the set of country names from agreements
        for (Apttus__APTS_Agreement__c agreement: newAgreementMap.values()) {
            countryNames.add(agreement.APTS_Country__c);
        }
        
        //get Agreement SAP setting(custom object) data from system
        //assumption: There will be only one record exist for each country
        list<APTS_Agreement_SAP_Setting__c> SAPSettings=[select Id,name,APTS_Auto_Create_MSPA_In_SAP_On_Approval__c,APTS_Country__c from APTS_Agreement_SAP_Setting__c where APTS_Country__c IN:countryNames LIMIT :APTS_Constants.SELECT_SOQL_LIMIT];
        
        //store it in a map
        for(APTS_Agreement_SAP_Setting__c SAPData :  SAPSettings){
            
           countryMap.put(SAPData.APTS_Country__c,SAPData.APTS_Auto_Create_MSPA_In_SAP_On_Approval__c);
        }
        
        if (!APTS_ProcessorControl.inFutureContext) { //condition to handle recursiveness
            List<Apttus__APTS_Agreement__c> agreement1 = newAgreementMap.values();

            for (Apttus__APTS_Agreement__c agreement: newAgreementMap.values()) {
            
                uniqueNames.add(agreement.Id);
                //get all agreements with status as 'Approved but action required'
                Apttus__APTS_Agreement__c oldagrmt = oldAgreementMap.get(agreement.Id);
               
                if (agreement.Apttus__Status__c == APTS_Constants.STATUS_APPROVED_ACTION_REQ && agreement.APTS_Integration_Status__c != 'Success' 
                && !agreement.Apttus__Workflow_Trigger_Created_From_Clone__c  && countryMap.get(agreement.APTS_Country__c) !=null && countryMap.get(agreement.APTS_Country__c)==true) {
               
                    //system.debug('entered in if**' + agreement);
                    agrmtIds.add(agreement.Id);
                }else if(!countryMap.get(agreement.APTS_Country__c)){// if auto creation of MSPA is OFF in sap setting data, stop trigger to fire and enable the button on MSPA layout
                    agreement.APTS_Manually_Create_MSPA_in_SAP__c=true;
                    agreementsTobeUpdated.add(agreement);
                    
                }
            }

            //call MSPA creation controller and pass required parameters
            if (!uniqueNames.isEmpty() && !agrmtIds.isEmpty()) {
                //System.debug('Calling SAP Service in furture context');
                APTS_ProcessorControl.inFutureContext = true;
                APTS_MSPACreatorInSAPController.CreateMSPA(agrmtIds, '');
            }
        }
    }
    
    /*
    @Addedby:Shahid Ali,req#452 in JIRA
    @Method to update LOD data on agreement in case it is created from non account buying quote
    @param:Agreement/MSPA
    */
    public static void updateLODForNonBuyingAgreement(List<Apttus__APTS_Agreement__c> listNewAgreement){
        //System.Debug('## Param quote: '+ ApexPages.currentPage().getParameters().get('Id'));
        if(ApexPages.currentPage() != null){
            String quoteId = ApexPages.currentPage().getParameters().get('Id');
            if(String.isNotBlank(quoteId)){
                    List<APTS_Quotation_Refreshed_LOD_Temp__c> tempObjList = [SELECT Id, APTS_Quotation_ID__c, APTS_Account__c, APTS_Account_End_User__c, APTS_Distribution_Channel__c,
                                                                                 APTS_Incoterms__c, APTS_Local_Channel__c, APTS_Payment_Terms__c, APTS_Primary_Partner_Account__c, 
                                                                                 APTS_LP_Sales_Organization__c, APTS_SAP_Customer_ID__c, APTS_Sales_Office__c, APTS_Sales_Office_LP__c 
                                                                          FROM APTS_Quotation_Refreshed_LOD_Temp__c
                                                                          WHERE APTS_Quotation_ID__c =: quoteId
                                                                          ORDER BY CreatedDate DESC];
                if(tempObjList != NULL && !tempObjList.isEmpty()){
                    APTS_Quotation_Refreshed_LOD_Temp__c tempObj = tempObjList[0];
                    for(Apttus__APTS_Agreement__c agreement: listNewAgreement){
                        //set the fields from temp object
                        agreement.Apttus__Account__c            = tempObj.APTS_Account__c;
                        agreement.APTS_LP_AccountCustomer__c    = tempObj.APTS_Account__c;
                        //agreement.APTS_Quotation_Account_Type__c = APTS_CaptureInputForLSODataConstants.ACCOUNT_CUSTOMER;
                        System.Debug('## tempObj.APTS_Account_End_User__c'+tempObj.APTS_Account_End_User__c);
                        System.Debug('## tempObj.APTS_Primary_Partner_Account__c'+tempObj.APTS_Primary_Partner_Account__c);
                        agreement.APTS_Account_End_User__c      = tempObj.APTS_Account_End_User__c;
                        agreement.APTS_LP_Account_End_User__c   = tempObj.APTS_Primary_Partner_Account__c;
                        agreement.APTS_SAP_Customer_ID__c       = tempObj.APTS_SAP_Customer_ID__c;
                        agreement.APTS_Distribution_Channel__c  = tempObj.APTS_Distribution_Channel__c;
                        agreement.APTS_LP_Sales_Organization__c = tempObj.APTS_LP_Sales_Organization__c;
                        agreement.APTS_Payment_Terms__c         = tempObj.APTS_Payment_Terms__c;
                        agreement.APTS_Local_Channel__c         = tempObj.APTS_Local_Channel__c;
                        agreement.APTS_Incoterms__c             = tempObj.APTS_Incoterms__c; 
                        agreement.APTS_Sales_Office__c          = tempObj.APTS_Sales_Office__c;
                        agreement.APTS_Sales_Office_LP__c       = tempObj.APTS_Sales_Office_LP__c;
                    }
                    //Delete the list of temp object
                    try{
                        delete tempObjList;
                    }catch(Exception ex){
                        
                    }
                }
            }
        }
    }
}