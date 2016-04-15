/*************************************************************
@Name: APTS_ProposalTriggerHelper
@Author: Hardik Shah
@CreateDate: 05/09/2015
@Description: Helper Class to Perform operations on Proposal
@UsedBy: APTS_ProposalTriggerHandler
******************************************************************
@ModifiedBy: Kruti Shah 
@ModifiedDate: 10/09/2015
@ChangeDescription: Added another function GetAvailableDiscounts for req# 83
******************************************************************
@ModifiedBy: Nishi Kushwaha
@ModifiedDate: 14/09/2015
@ChangeDescription: Added function CreateEmptyCart when Product Configuration checkbox is checked.
******************************************************************
@ModifiedBy: Nishi Kushwaha
@ModifiedDate: 19/09/2015
@ChangeDescription: Added function CreateEmptyCart when Product Configuration checkbox is checked.
******************************************************************
@ModifiedBy: Hardik Shah
@ModifiedDate: 26-09-2015
@ChangeDescription: Updated the MSPA Ref number code to incude Read-only Proposal

@ModifiedBy: Chetan Patel
@ModifiedDate: 10/11/2015
@ChangeDescription: replaced APTS_Channel__c with APTS_Local_Channel__c of Discounts Config object

******************************************************************/

public class APTS_ProposalTriggerHelper {
    
    public static void readOnlyQuotationValidation(Map<Id, Apttus_Proposal__Proposal__c > mapOldProposal, Map<Id, Apttus_Proposal__Proposal__c > mapNewProposal){
        
        try{
            
            String sysAdminProfileId = null;
            List<Profile> profileList = [SELECT Id FROM Profile WHERE Name = :APTS_Constants.ADMIN_PROFILE LIMIT 1];
            if(profileList != null && !profileList.isempty()){
                sysAdminProfileId = profileList[0].Id;
            }
            
            for(Apttus_Proposal__Proposal__c newProposal : mapNewProposal.values()){
                    
                    if((sysAdminProfileId == null || UserInfo.getProfileId() != sysAdminProfileId) && 
                       (mapOldProposal.get(newProposal.Id).Apttus_Proposal__Valid_Until_Date__c != newProposal.Apttus_Proposal__Valid_Until_Date__c ||
                        mapOldProposal.get(newProposal.Id).Apttus_Proposal__ExpectedStartDate__c != newProposal.Apttus_Proposal__ExpectedStartDate__c)
                        &&
                        (newProposal.Apttus_Proposal__Approval_Stage__c == APTS_Constants.MSPA_STATUS_APPROVED ||
                         newProposal.Apttus_Proposal__Approval_Stage__c == APTS_Constants.MSPA_STATUS_REJECTED ||
                          newProposal.Apttus_Proposal__Approval_Stage__c == APTS_Constants.MSPA_STATUS_APPROVAL_IN_PROGRESS || //Commented as this was giving an error on recall of cloned quotations. - Shahid
                           newProposal.Apttus_Proposal__Approval_Stage__c == APTS_Constants.MSPA_STATUS_EXPIRED || 
                            newProposal.Apttus_Proposal__Approval_Stage__c == APTS_Constants.MSPA_STATUS_GENERATED ||
                             newProposal.Apttus_Proposal__Approval_Stage__c == APTS_Constants.MSPA_STATUS_PRESENTED)){
                        
                        newProposal.addError(System.Label.APTS_Quotation_Read_Only_Validation_Error);
                    }
            }
        }
        catch(Exception e){
            System.debug('Error:\t'+e.getMessage());
        }
    }
    
    // Automates PriceList when Proposal/Quote is Created.
    // Written by Hardik Shah
    public static void automatePriceListonProposal(List < Apttus_Proposal__Proposal__c > listProposals) {

        // Map of PriceList, Country is Key and Price-Id is value    
        Map < String, Id > mapPriceCountry = new Map < String, Id > ();
        // Map of PriceList, Pricelist currency is Key and Price-Id is value    
        Map < String, Id > mapPriceListCurrency = new Map < String, Id > ();
        // Map of PriceList, Pricelist id is key and pricelist currency is value    
        Map < Id, String > mapPriceListIdCurrency = new Map < Id, String > ();
        // Set of Account-CustomerId on AgreementRecord 
        Set < String > setProposalCustomerId = new Set < String > ();
        // Set of SalesPersonId on AgreementRecord
        Set < String > setProposalSalesPersonId = new Set < String > ();
        // Boolean flag to check whether CustomerAccount has country field
        Boolean bCustomerAccountExists = false;
        // List of Proposals that needs to be updated
        List < Apttus_Proposal__Proposal__c > listUpdatedProposal = new List < Apttus_Proposal__Proposal__c > ();
        // Fetch PriceList
        List < Apttus_Config2__PriceList__c > listPrice = APTS_LP_QueryUtility.getPriceList();
        //Set of opportunity
        Set < Id > setOpportunityId = new Set < Id > ();
        //List of Opportunity
        List<Opportunity> lstOpportunity = new List<Opportunity> ();
        //Opportunity Map
        Map <id, opportunity> mapOpportunity = new Map <id, opportunity> ();
        
        // Map of PriceList, Country is Key and Price-Id is value
        for (Apttus_Config2__PriceList__c price: listPrice) {
            mapPriceCountry.put(price.APTS_Country__c, price.id);
            mapPriceListCurrency.put(price.CurrencyISOCode, price.id);
            mapPriceListIdCurrency.put(price.id,price.CurrencyISOCode);
        }
            
        if(mapPriceCountry.size()>0){    
            
            for (Apttus_Proposal__Proposal__c oproposal: listProposals) {
                if(oProposal != null && oProposal.Apttus_Proposal__Opportunity__c != null 
                    && Label.APTS_SetPriceListUsingCurrency == 'true' && mapPriceListCurrency.size()>0){
                        System.debug('Inside if of APTS_SetPriceListUsingCurrency == true condition');
                    setOpportunityId.add(oProposal.Apttus_Proposal__Opportunity__c);
                }
                
            }
            
            if(setOpportunityId.size() > 0){
                lstOpportunity = [select id,CurrencyIsoCode from Opportunity where id in : setOpportunityId];
                for(Opportunity oppty : lstOpportunity){
                    mapOpportunity.put(oppty.id, oppty);
                }
            }
            
            for (Apttus_Proposal__Proposal__c oproposal: listProposals) {
                if(oProposal != null && oProposal.Apttus_Proposal__Opportunity__c != null 
                    && Label.APTS_SetPriceListUsingCurrency == 'true' && mapPriceListCurrency.size()>0 && mapOpportunity.size() > 0){
                        System.debug('Inside if of APTS_SetPriceListUsingCurrency == true condition');
                    
                        setPricelistusingOpportunityCurrency(oproposal, mapOpportunity.get(oProposal.Apttus_Proposal__Opportunity__c), mapPriceListCurrency);
                        
                        if(oProposal.Apttus_QPConfig__PriceListId__c != null){
                            System.debug('Price List currenct got :: ' + mapPriceListIdCurrency.get(oproposal.Apttus_QPConfig__PriceListId__c));
                            oproposal.CurrencyISOCode = mapPriceListIdCurrency.get(oproposal.Apttus_QPConfig__PriceListId__c);
                        }else{
                            System.debug('Valid Price List Not found !! ');
                            oproposal.addError(Label.APTS_ValidPriceListNotFound);
                        }
                        
                        
                }else{
                    System.debug('Inside else of APTS_SetPriceListUsingCurrency == true means false condition or opportunity is null from account');
                    if (oproposal.APTS_QuotationType__c != null && String.isNotBlank(oproposal.APTS_QuotationType__c) && APTS_Constants.PROPOSAL_TYPE.equals(oproposal.APTS_QuotationType__c)) {
                        setProposalCustomerId.add(oproposal.APTS_LP_AccountCustomer__c);
                        setProposalSalesPersonId.add(oproposal.APTS_LP_Sales_Person__c);
                        listUpdatedProposal.add(oproposal);
                    }else{
                        //valid proposal is not found.
                        System.debug('Valid proposal not found');
                    }
                }   
            }
            
            if (listUpdatedProposal.size() > 0) {
    
                // Map of Account Object,based on Set of Account-CustomerId
                map < id, Account > mapCustomerAccount = APTS_LP_QueryUtility.getAccount(setProposalCustomerId);
                // Map of User Object,based on Set of SalesUserId
                map < id, User > mapSalesAccount = APTS_LP_QueryUtility.getUser(setProposalSalesPersonId);
                // Loop over the agreement to retriev Customer-Account country if exists
                for (Apttus_Proposal__Proposal__c proposal: listUpdatedProposal) {
                    bCustomerAccountExists = false;
                    if (mapCustomerAccount != null && mapCustomerAccount.containsKey(proposal.APTS_LP_AccountCustomer__c)) {
                        Account acct = mapCustomerAccount.get((proposal.APTS_LP_AccountCustomer__c));
                        if (acct != null && acct.Primary_Address_Country__c != null && mapPriceCountry.containsKey(acct.Primary_Address_Country__c)) {
                            Id priceID = mapPriceCountry.get(acct.Primary_Address_Country__c);
                            proposal.Apttus_QPConfig__PriceListId__c = priceId;
                            bCustomerAccountExists = true;
                        }
                    }
                    if (mapSalesAccount != null && mapSalesAccount.containsKey(proposal.APTS_LP_Sales_Person__c) && !bCustomerAccountExists) {
                        User salesAcct = mapSalesAccount.get((proposal.APTS_LP_Sales_Person__c));
                        if (salesAcct != null && salesAcct.Country != null && mapPriceCountry.containsKey(salesAcct.Country)) {
                            Id priceID = mapPriceCountry.get(salesAcct.Country);
                            proposal.Apttus_QPConfig__PriceListId__c = priceId;

                        }
                    }
                    
                    
                    if(proposal.Apttus_QPConfig__PriceListId__c != null){
                        System.debug('Price List currenct got :: ' + mapPriceListIdCurrency.get(proposal.Apttus_QPConfig__PriceListId__c));
                        proposal.CurrencyISOCode = mapPriceListIdCurrency.get(proposal.Apttus_QPConfig__PriceListId__c);
                    }else{
                        System.debug('Valid Price List Not found ! ');
                        proposal.addError(Label.APTS_ValidPriceListNotFound);
                    }
                    
                } // End of for loop
            } // End of If (Price Country) loop
            
            
            
            else{
                //valid proposal is not found.
                System.debug('Valid proposal not found');
            }
        }else{
            //price list not found.
            System.debug('Valid price list not found');
        }   
    }

    /*
    @Addedby:Mohit Patel
    @Method to set price list according to currency of opportunity
    @param:Quotation, Opportunity, pricelistmap
    */
    private static void setPricelistusingOpportunityCurrency(Apttus_Proposal__Proposal__c oProposal, Opportunity oppty , Map < String, Id > mapPriceListCurrency){
        
        System.debug('@@Got the opportunity : '+ oppty);
        if(oppty != null && oppty.CurrencyIsoCode != null){
            System.debug('@@Got the opportunity currency code: '+ oppty.CurrencyIsoCode);
            Id priceID = mapPriceListCurrency.get(oppty.CurrencyIsoCode);
            oProposal.Apttus_QPConfig__PriceListId__c = priceID;
            
        }
    }
    
    /*
    @Addedby:Kruti Shah,req# 83
    @Method to get available to discounts for each line
    @param:Quotations
    */
    public static void getAvailableDiscounts(Map < Id, Apttus_Proposal__Proposal__c > mapNewProposal) {
        try {
            if (mapNewProposal.values().size() == 0) {
                return;
            }

            //store multiple values of Channel,Country,RecordType to get compare with Proposal Data
            Set < String > setChannel = new Set < String > ();
            Set < String > setCountry = new Set < String > ();
            Set < String > setRecordType = new Set < String > ();

            for (Apttus_Proposal__Proposal__c oNewProposal: mapNewProposal.values()) {
                setChannel.add(oNewProposal.APTS_Local_Channel__c);
                setCountry.add(oNewProposal.APTS_Country__c);
                setRecordType.add(oNewProposal.APTS_Record_Type_Name__c);
            }
            
            List < APTS_Discounts_Config__c > listDiscountConfig = [select Id, name, APTS_Additional_Discount__c, APTS_Net_Discount__c, APTS_Hierarchy_Level_MS__c,
                                                                        APTS_Substitute_Discount__c, APTS_Additional_Discounts_Hierarchy__c, APTS_Net_Discount_Hierarchy__c, 
                                                                        APTS_Substitutional_Discounts_Hierarchy__c, APTS_Local_Channel__c,APTS_Local_Channel__r.APTS_Code__c, APTS_Country__c, APTS_Quote_Record_Type__c
                                                                    from APTS_Discounts_Config__c                                                                        
                                                                    where APTS_Local_Channel__c in : setChannel
                                                                        and APTS_Country__c in : setCountry
                                                                        and APTS_Quote_Record_Type__c in : setRecordType
                                                                        and APTS_IsActive__c = TRUE
                                                                   ];


            //system.debug('KS--> In Main function Discount Backup Object' + listDiscountConfig);
            if (listDiscountConfig.size() == 0) {
                //system.debug('KS--> listConfig is empty');
                return;
            }


            for (Apttus_Proposal__Proposal__c oNewProposal: mapNewProposal.values()) {
                APTS_Discounts_Config__c oDiscountConfig = getDiscountBackup(listDiscountConfig, oNewProposal);
                //system.debug('KS--> DiscountConfig' +oDiscountConfig );
                string sProductDiscounttypes = '';
                string sHierarchyDiscounttypes = '';
                //system.debug('KS--> Inside Function');
                //get backup admin object data based on country,channel and record type on MSPA

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
                    oNewProposal.APTS_Product_Discounts__c = sProductDiscounttypes;
                    //assign hierarchy discounts for agreement
                    oNewProposal.APTS_Hierarchy_Discounts__c = sHierarchyDiscounttypes;
                    oNewProposal.APTS_Hierarchy_level__c = oDiscountConfig.APTS_Hierarchy_Level_MS__c;

                    //system.debug('Proposal discs***' + oNewProposal.APTS_Product_Discounts__c);
                }
            }
        } catch (exception e) {
            system.debug('Exception while fetching Discount:' + e.getMessage());
        }
    }

    private static APTS_Discounts_Config__c getDiscountBackup(List < APTS_Discounts_Config__c > listDisConfig, Apttus_Proposal__Proposal__c oProposal) {
        for (APTS_Discounts_Config__c oDiscConfig: listDisConfig) {
            if (oDiscConfig.APTS_Local_Channel__r.APTS_Code__c == oProposal.APTS_Local_Channel_Code__c && oDiscConfig.APTS_Country__c == oProposal.APTS_Country__c && oDiscConfig.APTS_Quote_Record_Type__c == oProposal.APTS_Record_Type_Name__c) {
                //system.debug('KS--> Discounts Backup Object' + oDiscConfig);
                return oDiscConfig;
            } else {
                return null;
            }
        }
        return null;
    }
    
    public static void getRefrencedata(list<Apttus_Proposal__Proposal__c> oProposallist){   
        list<Apttus_Proposal__Proposal__c> ProposalstoUpdate=new list<Apttus_Proposal__Proposal__c>();
    
        Set<Id> oppIdSet = New Set<Id>();
        
        try{
            for(Apttus_Proposal__Proposal__c proposal : oProposallist){
                oppIdSet.add(proposal.Apttus_Proposal__Opportunity__c);
            }
        
            Map<Id,opportunity> oppSoMap = New Map<Id,Opportunity>();
            if(oppIdSet.size() > 0)
            {
                oppSoMap=New Map<Id,Opportunity>([select Id, name, AccountId from opportunity where Id in :oppIdSet]);
            }
        
            list<Apttus_Proposal__Proposal__c> proplist=[select Id,APTS_Local_Channel__c ,Apttus_Proposal__Opportunity__c ,APTS_LP_AccountCustomer__c ,APTS_Distribution_Channel__c  from Apttus_Proposal__Proposal__c where Id IN :oProposallist];
        
            for(Apttus_Proposal__Proposal__c proposal : proplist){
                if(oppSoMap.containsKey(proposal.Apttus_Proposal__Opportunity__c))
                {
                    proposal.APTS_LP_AccountCustomer__c = oppSoMap.get(proposal.Apttus_Proposal__Opportunity__c).accountId;
                }
                ProposalstoUpdate.add(proposal);
            }
            update ProposalstoUpdate;
        }
        catch(Exception e){
            System.debug('Error:\t'+e.getMessage());
        }
    }

    /*
    @Addedby:Axay - As per Rangan - autopopulate SAP Ref# from a separate object
    @Method to Auto-Populate SAP-Ref No.
    @param:Proposals
    */

    public static void autopopulateMSPARefNumber(List < Apttus_Proposal__Proposal__c > listProposals) {
        
        List<APTS_MSPA_Ref_Number__c> lstProposalRefNo = new List<APTS_MSPA_Ref_Number__c>();
        
        try{
            for(Apttus_Proposal__Proposal__c propsoal : listProposals){
                
                if(APTS_Constants.PROPOSAL_TYPE.equals(propsoal.APTS_QuotationType__c)){
                    lstProposalRefNo.add(new APTS_MSPA_Ref_Number__c(APTS_Is_Used__c = true));
                }
            }
            
            if(lstProposalRefNo.size() > 0){
                
                insert lstProposalRefNo;
                
                lstProposalRefNo = [SELECT Id, APTS_Reference_Number__c 
                                    FROM APTS_MSPA_Ref_Number__c
                                    WHERE ID IN :lstProposalRefNo];
                                    
               Integer index = 0, offsetNum = 0;
               APTS_MSPA_Ref_Offset__c offsetObj = APTS_MSPA_Ref_Offset__c.getValues('MSPA Offset');
               
               if(offsetObj != null){
                   offsetNum = offsetObj.APTS_Quotation_Offset_Value__c != null ? Integer.valueOf(offsetObj.APTS_Quotation_Offset_Value__c) : 0;
               }
           
               for(Apttus_Proposal__Proposal__c proposal : listProposals){
                   
                   if(APTS_Constants.PROPOSAL_TYPE.equals(proposal.APTS_QuotationType__c)){
                       offsetNum = offsetNum + Integer.valueOf(lstProposalRefNo[index++].APTS_Reference_Number__c);
                        proposal.APTS_SAP_Reference_No__c = String.valueOf(offsetNum);
                    }
               }
               
               delete lstProposalRefNo;
            }
        }
        catch(Exception e){
            System.debug('Error:\t'+e.getMessage());
        }
    }

    /*
    @Addedby: Nishi Kushwaha
    @Method: to Auoto Populate Primary Partner Customer related to Opportunity
    @param:Quotations
    */
    public static void autopopulatePrimaryPartnerCustomer(List < Apttus_Proposal__Proposal__c > listProposals) {

        Set < Id > setOpportunityId = new Set < Id > ();
        Map < Id, Id > mapOppAccount = new Map < Id, Id > ();

        try{
            for (Apttus_Proposal__Proposal__c oProposal: listProposals) {
                if (APTS_Constants.PROPOSAL_TYPE.equals(oProposal.APTS_QuotationType__c)) {
                    oProposal.Apttus_Proposal__Primary_Contact__c = oProposal.APTS_Primary_Contact__c;
                }
                setOpportunityId.add(oProposal.Apttus_Proposal__Opportunity__c);
            }
            //Get Primary Partner Information from Oportunity Partner
            //List<OpportunityPartner> listOppPartner = [SELECT Id, IsPrimary,AccountToId,OpportunityId FROM OpportunityPartner WHERE IsPrimary = TRUE AND OpportunityId IN: setOpportunityId];
    
            for (OpportunityPartner oOppPartner: [SELECT Id, IsPrimary, AccountToId, OpportunityId
            FROM OpportunityPartner WHERE IsPrimary = TRUE AND OpportunityId IN: setOpportunityId]) {
    
                mapOppAccount.put(oOppPartner.OpportunityId, oOppPartner.AccountToId);
            }
    
            for (Apttus_Proposal__Proposal__c oProposal: listProposals) {
                //Check whether 
                if (APTS_Constants.PROPOSAL_TYPE.equals(oProposal.APTS_QuotationType__c) && mapOppAccount.isEmpty() != True) {
    
                    try {
                        if (mapOppAccount.containsKey(oProposal.Apttus_Proposal__Opportunity__c)) {
                            oProposal.APTS_LP_Account_End_User__c = mapOppAccount.get(oProposal.Apttus_Proposal__Opportunity__c);
                        }
                    } catch (exception e) {
                        System.debug('error' + e+' --> Line#: '+e.getLineNumber());
                    }
    
                }
            }
        }
        catch(Exception e){
            System.debug('Error:\t'+e.getMessage()+' --> Line#: '+e.getLineNumber());
        }
    }

    /**
     * Method to populate Account Customer on Account (OOB) field and Proposal Expiration Date on Valid Until Date.
     * 
     * @owner : Shalin Shah
     * @param : List<Apttus_Proposal__Proposal__c> - new Proposal List
     */
    public static void populateAccountCustomerAndExpirationDate(List < Apttus_Proposal__Proposal__c > listNewProposal) {
        for (Apttus_Proposal__Proposal__c oProposal: listNewProposal) {
            // Set only if proposal type is for LP
            if (APTS_Constants.PROPOSAL_TYPE.equals(oProposal.APTS_QuotationType__c)) {
                //oProposal.Apttus_Proposal__Account__c = oProposal.APTS_LP_AccountCustomer__c;
                oProposal.Apttus_Proposal__Valid_Until_Date__c = oProposal.Apttus_Proposal__Proposal_Expiration_Date__c;
            }
        }
    }

    /**
     * Method to Sales Office code based on user's locale using user's sales territory name.
     * 
     * @owner : Shalin Shah
     * @param : List<Apttus_Proposal__Proposal__c> - new Proposal List
     */
    public static void setSalesOfficeCode(List < Apttus_Proposal__Proposal__c > listNewProposal) {
        String sUserSalesOfficeCode = APTS_LP_QueryUtility.getUserSalesOfficeCode();
        for (Apttus_Proposal__Proposal__c oProposal: listNewProposal) {
            // Set only if proposal type is for LP
            if (APTS_Constants.PROPOSAL_TYPE.equals(oProposal.APTS_QuotationType__c)) {
                oProposal.APTS_Sales_Office_Code__c = sUserSalesOfficeCode;
            }
        }
    }

    /**
     * Method to populate MAx Order Amount when Amount field has values in it.
     * Max order amount on quotations need to be a copy Amount (Roll up Summary of Proposal Line Item: Total Quote Price) Field 
     * @owner : Nishi Kushwaha
     * @param : Quotations
    
    <!-- Commented By AXAY for ABBLP-308 - as per subbu's suggestion - it will manually added by user 
    public static void autoPopulateMaxOrderAmount(Map < Id, Apttus_Proposal__Proposal__c > mapOldProposal, Map < Id, Apttus_Proposal__Proposal__c > mapNewProposal) {

        for (Apttus_Proposal__Proposal__c oProposal: mapNewProposal.values()) {

            Apttus_Proposal__Proposal__c oldProposal = mapOldProposal.get(oProposal.Id);

            if (APTS_Constants.PROPOSAL_TYPE.equals(oProposal.APTS_QuotationType__c) && oldProposal.APTS_Total_Amount_of_the_quotation__c != oProposal.APTS_Total_Amount_of_the_quotation__c) {

                try {
                    oProposal.APTS_LP_Max_Order_Amount__c = oProposal.APTS_Total_Amount_of_the_quotation__c;
                } catch (exception e) {
                    System.debug('error' + e);
                }
            }
        }

    }*/
    
    /**
     * Method to populate default value while quotes get created.
     * Locale field will be populated based on User's locale if avialable other it will pick Organization's DefaultLocaleSidKey
     * @owner : Hardik Shah
     * @param : Quotations
     */
    public static void autoPopulateDefaultValues(List < Apttus_Proposal__Proposal__c > listNewProposal){
        System.Debug('## In AutoPopulateDefaultValues');
        // Get Defaul Local Channel
        String sDefaultLC = APTS_LP_QueryUtility.getDefaultLocalChannel();
        // Get Defaul Distributionb Channel
        String sDefaultDC = APTS_LP_QueryUtility.getDefaultDistributionChannel();
        System.Debug('## In AutoPopulateDefaultValues - 2');
        
        
        // Code for setting default currency for quote as part of R3.1
        // Added by chetan Date : 18-01-2016
        /*set<String> setPriceListIds = new set<String>();
        for (Apttus_Proposal__Proposal__c oProposal: listNewProposal) {
            setPriceListIds.add(oProposal.Apttus_QPConfig__PriceListId__c);
        }
        
        System.Debug('## In AutoPopulateDefaultValues got setPriceListIds : ' + setPriceListIds);
        map<id,Apttus_Config2__PriceList__c> mapPriceList= new map<id, Apttus_Config2__PriceList__c>([select id,CurrencyISOCode from Apttus_Config2__PriceList__c where id in:setPriceListIds]);
        
        */
        // Code for setting default currencyends here
        
        //System.Debug('## request URL ');        
        //system.debug('HS--> autoPoPulateLocaleMap');
        Organization orgDetails = [SELECT Id, LanguageLocaleKey,DefaultLocaleSidKey  
                                        FROM Organization WHERE Id = :UserInfo.getOrganizationId() LIMIT 1];
        // Get Discount Config Value
        map<Id, APTS_Discounts_Config__c> mapDiscountConfig = APTS_LP_QueryUtility.getValidateDiscountConfig(APTS_Proposal_Record_Type__c.getOrgDefaults().APTS_Default_Record_Type__c);
        
        for (Apttus_Proposal__Proposal__c oProposal: listNewProposal) {
           system.debug('<<<< Quotation Type >>>>' + APTS_Constants.PROPOSAL_TYPE + '------' + oProposal.APTS_QuotationType__c + '----'  + APTS_Constants.PROPOSAL_TYPE.equals(oProposal.APTS_QuotationType__c)); 
           if (APTS_Constants.PROPOSAL_TYPE.equals(oProposal.APTS_QuotationType__c)) {
                //system.debug('HS--> inside If');
                try {
                    if(UserInfo.getLocale() != null && String.isNotBlank(UserInfo.getLocale())){
                         system.debug('HS-->'+UserInfo.getLocale());
                         oProposal.APTS_Locale__c = UserInfo.getLocale();
                    }else{
                        system.debug('HS-->'+orgDetails.DefaultLocaleSidKey);
                         oProposal.APTS_Locale__c  = orgDetails.DefaultLocaleSidKey ;
                    }
                    // Set default value to False when new Quotation is created.
                    oProposal.APTS_Approval_Required__c = false;
                    // Set defaul value for Approval Status as Draft. + JS 21-Nov-2015
                    // setting Apttus_QPApprov__Approval_Status__c to Not Submitted instead of Draft 
                    // in order to see preview page on submit for approval  
                    // added by  chetan 28-11-2015
                    //oProposal.Apttus_QPApprov__Approval_Status__c = APTS_Constants.QUOTE_APPROVAL_STATUS_DRAFT;
                    oProposal.Apttus_QPApprov__Approval_Status__c = APTS_Constants.QUOTE_APPROVAL_STATUS_NOT_SUBMITTED;
                    
                    // Set Quotation Type
                    setQuotationType(oProposal);
                    
                    String sPlaceHolderQuote = ApexPages.currentPage().getParameters().get('is_placeholder_quote');
                    system.debug('##sPlaceHolderQuote='+sPlaceHolderQuote);
                    if(sPlaceHolderQuote == 'true'){
                        oProposal.APTS_Is_Placeholder_Quote__c = true;
                    }
                    
                    if(String.isBlank(oProposal.APTS_Local_Channel__c)){
                        oProposal.APTS_Local_Channel__c = sDefaultLC;
                    }
                    
                    if(String.isBlank(oProposal.APTS_Distribution_Channel__c)){
                        oProposal.APTS_Distribution_Channel__c = sDefaultDC;
                    }
                    
                    // Validate that Discount Config is available
                    if(!APTS_LP_QueryUtility.validateQuotationData(oProposal.APTS_Local_Channel__c, mapDiscountConfig)){
                        oProposal.addError(Label.APTS_NoDiscConfig);
                    }
                    
                    /*
                    system.debug('Price List Id >>>> '+ oProposal.Apttus_QPConfig__PriceListId__c);
                    // Code for setting default currency for quote as part of R3.1
                    // Added by chetan Date : 18-01-2016
                    if(oProposal.Apttus_QPConfig__PriceListId__c != null){
                        oProposal.CurrencyISOCode = mapPriceList.get(oProposal.Apttus_QPConfig__PriceListId__c).CurrencyISOCode;
                    }
                    // Code for setting default currency for quote ends here
                    */
                } catch (exception e) {
                    System.debug(Label.APTS_ERROR_WHILE_POPULATING_DEFAULTS + e.getMessage()+' --> Line#: '+e.getLineNumber());
                }
            }
       }
    
    }
    
    /*
        Method to populate field on Quotation before Update
        @owner: Jignesh Shekhaliya
        @param : Quotations
    */
    public static void populateFieldsOnQuote(Map<Id,Apttus_Proposal__Proposal__c> mapNewProposal){    

        try{
            
            // Get Discount Config Value
            map<Id, APTS_Discounts_Config__c> mapDiscountConfig = APTS_LP_QueryUtility.getValidateDiscountConfig(APTS_Proposal_Record_Type__c.getOrgDefaults().APTS_Default_Record_Type__c);
            
            set<String> setMPLSalesOfficeCode = new set<String>();
            
            // Get ALl Sales Office records from Master PickList
            map<Id,APTS_Master_Picklist_Table__c> mapMPLSalesOffice = APTS_LP_CommonUtil.getMPLSalesOffice();
            
            // Prepare map of Sales Office Code
            if(mapMPLSalesOffice != null && mapMPLSalesOffice.size() > 0){
                for(Apttus_Proposal__Proposal__c oProposal: mapNewProposal.values()){
                    if(oProposal.APTS_Sales_Office_LP__c != null){
                        setMPLSalesOfficeCode.add(mapMPLSalesOffice.get(oProposal.APTS_Sales_Office_LP__c).APTS_Code__c);    
                    }
                    
                }
            }
            
            // Get Sales Office Data from LSO Field Entry object
            map<String, LSO_Field_Entries__c> mapLSOSalesOffice = APTS_LP_CommonUtil.getMapOfSalesOfficeFromLSO(setMPLSalesOfficeCode);
            
            //system.debug('##mapNewProposal='+mapNewProposal);
            for(Apttus_Proposal__Proposal__c oProposal: mapNewProposal.values()){
                
                // Set LSO field entry lookup
                if(oProposal.APTS_Sales_Office_LP__c != null){
                
                    LSO_Field_Entries__c oSalesOfficeLSO = APTS_LP_CommonUtil.getLSOSalesOffice(mapLSOSalesOffice, mapMPLSalesOffice.get(oProposal.APTS_Sales_Office_LP__c).APTS_Code__c, oProposal.APTS_Country__c);
                    if(oSalesOfficeLSO != null){
                        oProposal.APTS_Sales_Office__c = oSalesOfficeLSO.Id;
                    }else{
                        oProposal.APTS_Sales_Office__c = null;
                        //oProposal.addError(Label.APTS_InValidSalesOffice);
                    }
                }
                
                if(!String.isBlank(oProposal.APTS_Local_Channel__c)){
                    if(!APTS_LP_QueryUtility.validateQuotationData(oProposal.APTS_Local_Channel__c, mapDiscountConfig)){
                        oProposal.addError(Label.APTS_NoDiscConfig);
                    }
                }
                
                
                String sPlaceHolderQuote = ApexPages.currentPage().getParameters().get('is_placeholder_quote');
                //system.debug('##sPlaceHolderQuote='+sPlaceHolderQuote);
                if(sPlaceHolderQuote == 'true'){
                    oProposal.APTS_Is_Placeholder_Quote__c = true;
                }
                
                // Set Quotation Type
                //setQuotationType(oProposal); //Commented by Vamsi to resolve the issue with Quote Type
                if(!String.isBlank(oProposal.APTS_Quotation_Account_Type__c)){
                    if(oProposal.APTS_Quotation_Account_Type__c == APTS_Constants.ACCOUNTTYPE_ACCEND){
                        if(String.isBlank(oProposal.APTS_Account_End_User__c)){
                            oProposal.addError('Please select Account End User.');
                        }else{
                            oProposal.Apttus_Proposal__Account__c = oProposal.APTS_Account_End_User__c;
                        }
                        // Set Primary Partner Account as null.
                        //oProposal.APTS_LP_Account_End_User__c = null;
                    }else if(oProposal.APTS_Quotation_Account_Type__c== APTS_Constants.ACCOUNTTYPE_PARTNER){
                        // Show error message if Primary Partner Account is not selected or Cosider it as a standard account field for Proposal
                        if(String.isBlank(oProposal.APTS_LP_Account_End_User__c)){
                            oProposal.addError('Please select Primary Partner Account.');
                        }else{
                            oProposal.Apttus_Proposal__Account__c = oProposal.APTS_LP_Account_End_User__c;
                        }                        
                        // Set Account End User as null
                        //oProposal.APTS_Account_End_User__c = null;
                    }
                }
                else{
                    //oProposal.APTS_LP_Account_End_User__c = null;
                    //oProposal.APTS_Account_End_User__c = null;
                }
                
                // Update Quotation Open Status to Blank if User set Quotation status = "Closed"
                if(oProposal.APTS_Quotation_Category__c == APTS_Constants.QUOTATION_STATUS_CLOSED){
                    oProposal.Apttus_Proposal__Approval_Stage__c = null;
                }
            }
        }
        catch(Exception ex){
            System.debug('exception while populating fiels on Quotation' + ex.getMessage()+ ' --> '+ex.getLineNumber()+ ' --> ');
        }
    }
    
    public static void setSAPIdOnChangeInQuoteFields(Map < Id, Apttus_Proposal__Proposal__c > mapOldProposal, Map < Id, Apttus_Proposal__Proposal__c > mapNewProposal){
        
        List < Apttus_Proposal__Proposal__c > listProposal = new List < Apttus_Proposal__Proposal__c > ();
        Map<Id,List<APTS_LP_Local_Customer_Reference_Data__c>> mapLocalCustomerRefData = new Map<Id, List<APTS_LP_Local_Customer_Reference_Data__c>>();
        Set <Id> setAccountId = new Set<Id>();
        Set <Id> setMasterPickListValueId = new Set<Id>();        
        Boolean bSAPIdFlag = false;
        
        for (Apttus_Proposal__Proposal__c oProposal: mapNewProposal.values()) {

            Apttus_Proposal__Proposal__c oOldProposal = mapOldProposal.get(oProposal.Id);

            if (APTS_Constants.PROPOSAL_TYPE.equals(oProposal.APTS_QuotationType__c) && 
                    (oOldProposal.APTS_Distribution_Channel__c != oProposal.APTS_Distribution_Channel__c ||
                     oOldProposal.APTS_Incoterms__c != oProposal.APTS_Incoterms__c ||
                     oOldProposal.APTS_Local_Channel__c != oProposal.APTS_Local_Channel__c ||
                     oOldProposal.APTS_Payment_Terms__c != oProposal.APTS_Payment_Terms__c)) {
                
                setAccountId.add(oProposal.APTS_LP_AccountCustomer__c);
                listProposal.add(oProposal);
                setMasterPickListValueId.add(oProposal.APTS_Distribution_Channel__c);
                setMasterPickListValueId.add(oProposal.APTS_Incoterms__c);
                setMasterPickListValueId.add(oProposal.APTS_Local_Channel__c);
                setMasterPickListValueId.add(oProposal.APTS_Payment_Terms__c);
            }
        }
        for (APTS_LP_Local_Customer_Reference_Data__c oLocalCustomerRefData: [SELECT Id, Name,APTS_LP_Account__c,APTS_LP_SAP_Customer_ID__c,APTS_SAP_Division__c,APTS_LP_Distribution_Channel__c,APTS_LP_Incoterms__c,APTS_LP_Local_Channel__c,APTS_Payment_Terms__c 
                                                                              FROM APTS_LP_Local_Customer_Reference_Data__c WHERE  APTS_LP_Account__c IN: setAccountId]) {

            List<APTS_LP_Local_Customer_Reference_Data__c> listLocalCustomerRefData = mapLocalCustomerRefData.get(oLocalCustomerRefData.APTS_LP_Account__c);
            if (listLocalCustomerRefData == null) {
                listLocalCustomerRefData = new List<APTS_LP_Local_Customer_Reference_Data__c>();
                mapLocalCustomerRefData.put(oLocalCustomerRefData.APTS_LP_Account__c, listLocalCustomerRefData);
            }
            listLocalCustomerRefData.add(oLocalCustomerRefData);
        }
        //System.debug('mapLocalCustomerRefData'+ mapLocalCustomerRefData);
        
        for (Apttus_Proposal__Proposal__c oProposal: listProposal) {
            
            if (APTS_Constants.PROPOSAL_TYPE.equals(oProposal.APTS_QuotationType__c) && mapLocalCustomerRefData.isEmpty() != True) {

                try {
                    if (mapLocalCustomerRefData.containsKey(oProposal.APTS_LP_AccountCustomer__c)) {
                        List<APTS_LP_Local_Customer_Reference_Data__c> listLocalCustomerRefData = mapLocalCustomerRefData.get(oProposal.APTS_LP_AccountCustomer__c);
                        //System.debug('listLocalCustomerRefData'+ listLocalCustomerRefData);
                        for(APTS_LP_Local_Customer_Reference_Data__c oLocalCustomerRefData:listLocalCustomerRefData) {
                            
                            //System.debug('DC ****'+ oLocalCustomerRefData.APTS_LP_Distribution_Channel__c +'Proposal ***'+oProposal.APTS_Distribution_Channel__r.APTS_Code__c);
                            
                            if(oLocalCustomerRefData.APTS_LP_Distribution_Channel__c == oProposal.APTS_Distribution_Channel__r.APTS_Code__c &&
                               oLocalCustomerRefData.APTS_LP_Incoterms__c == oProposal.APTS_Incoterms__r.APTS_Code__c &&
                               oLocalCustomerRefData.APTS_LP_Local_Channel__c == oProposal.APTS_Local_Channel__r.APTS_Code__c &&
                               oLocalCustomerRefData.APTS_Payment_Terms__c == oProposal.APTS_Payment_Terms__r.APTS_Code__c) {
                                   
                                  oProposal.APTS_SAP_Customer_ID__c =  oLocalCustomerRefData.APTS_LP_SAP_Customer_ID__c;
                                  oProposal.APTS_Manually_Edited__c = false;
                                  bSAPIdFlag = true;
                                  //System.debug('Done Through LSO Data****');
                               }
                        }
                        if(bSAPIdFlag == false){                            
                            oProposal.APTS_Manually_Edited__c = true;
                        }
                    }
                } catch (exception e) {
                    System.debug('error' + e+' --> Line#: '+e.getLineNumber());
                }
            }
        }

    }
    
    /*
        @Description: Set Quotation Type based on Quotation For. (HPALM Task # 2234)
        @Owner: Jignesh Shekhaliya
        @Date: 04-Dec-2015
    */
    public static void setQuotationType(Apttus_Proposal__Proposal__c oProposal){
        try{
            if(APTS_CaptureInputForLSODataConstants.ACCOUNT_CUSTOMER.equals(oProposal.APTS_Quotation_Account_Type__c)){
                oProposal.APTS_Quotation_Type__c = APTS_Constants.QUOTE_TYPE_BINDING;   
            }else{
                oProposal.APTS_Quotation_Type__c = APTS_Constants.QUOTE_TYPE_NONBINDING;
            }
            
        }
        catch(Exception ex){
            System.debug('exception while populating Quotation Type.' + ex.getMessage()+' --> Line#: '+ex.getLineNumber());
        }
        
    }
    
    /*
        @Description: Share the read/write access with opportunity team users to access local products
        @Owner: Mohit Patel
        @Date: 20-Jan-2015
    */
    public static void shareAccesswithOpportunityTeam(List < Apttus_Proposal__Proposal__c > listNewProposal){
        try{
            
            System.debug('Entering method shareAccesswithOpportunityTeam with proposals : ' + listNewProposal);
            Map<String,String> mapOppIdPlaceHolderQuoteId = new Map <String,String> ();
            
            //Iterating through Proposals to identify and make list of place holder quote along with its opportunity data
            for (Apttus_Proposal__Proposal__c oProposal: listNewProposal) {
                
                System.debug('Inside for loop and got Proposal : ' + oProposal);
                if(oProposal.APTS_Is_Placeholder_Quote__c == true && oProposal.Apttus_Proposal__Opportunity__c != null){
                    mapOppIdPlaceHolderQuoteId.put(oProposal.Apttus_Proposal__Opportunity__c, oProposal.id);
                }
            }
            
            System.debug(' ## mapOppIdPlaceHolderQuoteId : ' + mapOppIdPlaceHolderQuoteId);
            
            //Fetching Opportunity team member details to give the appropriate sharing access
            List<OpportunityTeamMember> lstOpportunityTeamMember = new List <OpportunityTeamMember> ();
            //lstOpportunityTeamMember = [Select Id,UserId,OpportunityAccessLevel,OpportunityId from OpportunityTeamMember where OpportunityId in: mapOppIdPlaceHolderQuoteId.keySet() and OpportunityAccessLevel='Edit'];
            lstOpportunityTeamMember = [Select Id,UserId,OpportunityAccessLevel,OpportunityId from OpportunityTeamMember where OpportunityId in: mapOppIdPlaceHolderQuoteId.keySet()];
            
            System.debug(' ## lstOpportunityTeamMember : ' + lstOpportunityTeamMember);
            
            List<Apttus_Proposal__Proposal__Share > proposalSharesLst = new List<Apttus_Proposal__Proposal__Share >();
            
            //Iterate through all team members and prepare Proposal share object for each member and give the same access as Opportunity 
            if(lstOpportunityTeamMember != null && lstOpportunityTeamMember.size()>0){
                for(OpportunityTeamMember oOpportunityTeamMember : lstOpportunityTeamMember){
                    Apttus_Proposal__Proposal__Share proposalForShare = new Apttus_Proposal__Proposal__Share ();
                    proposalForShare.ParentId = mapOppIdPlaceHolderQuoteId.get(oOpportunityTeamMember.OpportunityId);
                    proposalForShare.UserOrGroupId = oOpportunityTeamMember.UserId;
                    //proposalForShare.AccessLevel = 'Edit';
                    proposalForShare.AccessLevel = oOpportunityTeamMember.OpportunityAccessLevel;
                    proposalForShare.RowCause = Schema.Apttus_Proposal__Proposal__Share.RowCause.APTS_EnableAccessToOpportunityTeam__c;
                    proposalSharesLst.add(proposalForShare);
                }
            }
            System.debug(' ## proposalSharesLst : ' + proposalSharesLst);
            
            //If proper valida records are prepared for proposal sharing then insert the records
            if(proposalSharesLst.size() > 0) {
                // Insert all of the newly created Share records
                insert proposalSharesLst;
            }
        
        }
        catch(Exception ex){
            System.debug('exception while sharing access to opportunity team for place holder Quotation.' + ex.getMessage()+' --> Line#: '+ex.getLineNumber());
        }
        
    }
}