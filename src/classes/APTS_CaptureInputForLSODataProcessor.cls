/*************************************************************
@Name: APTS_CaptureInputForLSODataProcessor
@Author: Shalin Shah
@CreateDate: 17th Sept 2015
@Description: Class to process URL parameters and input data provided by user to create new Quote/MSPA record, fetch and set relevant Apttus LSO data in it and open in edit mode.
@UsedBy: Class - APTS_CaptureInputForLSODataController
******************************************************************/

public class APTS_CaptureInputForLSODataProcessor {
    
    public List<APTS_LP_Local_Customer_Reference_Data__c> listLODData {get; private set;}
    public List<APTS_WrapperLOD> listWrapperLOD {get; private set;}
    
    // String objects to hold values passed from controller
    private ID baseObjectId {get; set;}
    private String baseObject {get; set;}
    private String baseObjectName {get; set;}
    private String accountType {get; set;}
    private String targetObject {get; set;}
    private String distributionChannel {get; set;}
    private String sapDivision {get; set;}
    private String salesOrganization {get; set;}
    private String userCountry {get; set;}
    private String userCountryCode {get; set;}
    private String targetObjectRecordTypeId {get; set;}
    private String additionalLSOData {get; set;}
    private String quotationFor {get; set;}
    private string customerID {get; set;}
    
    private String accountId {get; set;}
    private String primaryPartnetId {get;set;}
    private String endUserAccountId {get;set;}
    private String opportunityLSOId {get; set;}
    private String selectedAccountName {get;set;}
    private String sSalesOffice {get;set;}
    
    private Boolean isLSOReferenceFoundForOpportunity = true;
    private Map<String, String> lsoDataMap = new Map<String, String>();
    private Boolean isExactlyOneApttusLSOSelected = false;
    private Map<String, Set<String>> additionalLSOOptionsMap = new Map<String, Set<String>>();
    private Map<String, Map<String, String>> lsoCodeDescriptionMap = new Map<String, Map<String, String>>();
    private Map<String, Map<String, String>> lsoCodeDescriptionIdMap = new Map<String, Map<String, String>>();
    
    private PageReference pageReferenceLink {get; set;}
    private APTS_CaptureInputForLSODataController controller;
    
    /**
     * Constructor to initialize the object.
     */
    public APTS_CaptureInputForLSODataProcessor(APTS_CaptureInputForLSODataController controller) {
        this.controller = controller;
    }
    
    /**
     * Method to begin processing of captured input for LSO data and URL parameters received via parameter MAP.
     */
    public void beginToProcessData(Map<String, String> dataMap) {
        // LRD Reference Data
        ERP_Reference_Data__c oLRDRefData;
        
        try{
            // Populate data from MAP
            setVariablesFromDataMap(dataMap);
            
            // If the base object is opportunity, first fetch details and set in map.
            if (APTS_CaptureInputForLSODataConstants.OPPORTUNITY.equals(baseObject)) {
                system.debug('**************** Opportunity View ******************');
                oLRDRefData = fetchAndSetDetailsFromOpportunity();
            }
            
            // Else if base object is account, set account id to base object id.
            else if (APTS_CaptureInputForLSODataConstants.ACCOUNT.equals(baseObject)) {
                accountId = baseObjectId;
            }
            
            // Check that Discount Config data is availabel.
            if(validateDiscountConfig()){
                System.debug('<<<< JS - GET LSO Data >>>>');
                // Fetch LSO Data
                List<APTS_LP_Local_Customer_Reference_Data__c> lsoDataList = fetchApttusLSODataList(oLRDRefData);
                listLODData = lsoDataList;
                if(listLODData != null && listLODData.size() > 0){
                    // Fetch description for LSO codes
                    setLSOCodeDescriptionMapFromLSODataList(listLODData);
                    
                    // Process LSO Data
                    processLSODataList(listLODData);           
                    
                }
            }
        }
        catch(Exception e){
            System.debug('Error:\t'+e.getMessage());
        }
    }
    
    /**
     * Method to set the values of variables from the data map.
     */
    private void setVariablesFromDataMap(Map<String, String> dataMap) {
        
        baseObjectId = dataMap.get('baseObjectId');
        baseObject = dataMap.get('baseObject');
        baseObjectName = dataMap.get('baseObjectName');
        accountType = dataMap.get('accountType');
        targetObject = dataMap.get('targetObject');
        distributionChannel = dataMap.get('distributionChannel');
        sapDivision = dataMap.get('sapDivision');
        salesOrganization = dataMap.get('salesOrganization');
        userCountry = dataMap.get('userCountry');
        userCountryCode = dataMap.get('userCountryCode');
        targetObjectRecordTypeId = dataMap.get('targetObjectRecordTypeId');
        additionalLSOData = dataMap.get('additionalLSOData');
        quotationFor = dataMap.get('quotationFor');
       
    }
    
    /**
     * Method to fetch details required from Opportunity and set them.
     * Details are like, account id, sales organization, distribution channel and SAP division.
     * 
     * Code in method will fetch details from Account Customer LSO Reference object (buying customer), if it is present.
     * Otherwise from Primary Partner LSO Reference object (non buying customer), if it is present and target object is Quotation.
     * If both LSO objects are empty, method will throw error.
     */
    private ERP_Reference_Data__c fetchAndSetDetailsFromOpportunity() {
        
        Opportunity oOpportunity;
        ERP_Reference_Data__c referenceObject;
        isLSOReferenceFoundForOpportunity = false;
        try {
            oOpportunity = [SELECT Account.ID, Account.Name, Account.RecordType.Name, Account_End_User__c, Account_End_User__r.Name, Account_Customer_LSO_Reference_Data__c, Primary_Partner_LSO_Reference_Data__c, End_User_LSO_Reference_Data__c 
                            FROM  Opportunity  
                            WHERE id = :baseObjectId
                            LIMIT 1
                           ];
        } catch (Exception ex) {
            System.debug('Exception occured while fetching Opportunity related information.\nException : ' + ex);
            controller.addErrorMessage('Exception occured while getting Opportunity related information. Please try again after sometime.');
        }
        
        if(oOpportunity != null) {
            endUserAccountId = oOpportunity.Account_End_User__c;
             
            if(quotationFor == null || quotationFor == ''){
                initialiseQuotationFor(oOpportunity);
            }
            
            // Check that Opportunity has valid LRD
            isOpportunityHasLSO(oOpportunity);
            
            setQuotationForOptionsForOpportunity(oOpportunity);
            
            if(opportunityLSOId != null){
                isLSOReferenceFoundForOpportunity = true;
                system.debug('<<<< Getting LRD Data >>>>');
                referenceObject = fetchAndSetDetailsFromERPReferenceData(opportunityLSOId);
            }
        }
        
        return referenceObject;
    }
    
    public void setQuotationForOptionsForOpportunity(Opportunity oOpportunity) {
        
        String sOptions = '';
        
        try{
            if((oOpportunity.Account.Name != null)
                 && (!oOpportunity.Account.Name.equalsIgnoreCase(Label.APTS_Unknown_Account))) {
                sOptions = APTS_CaptureInputForLSODataConstants.ACCOUNT_CUSTOMER + APTS_CaptureInputForLSODataConstants.VALUE_SEPARATOR;
            }
            
            
            String sOppotyId = oOpportunity.Id;
            String sQuery = 'SELECT AccountToId FROM OpportunityPartner  WHERE IsPrimary = TRUE  AND OpportunityId = :sOppotyId';
            List<OpportunityPartner> listOpptyPartner = Database.query(sQuery);
            
            if(!listOpptyPartner.isEmpty()) {
                primaryPartnetId = listOpptyPartner[0].AccountToId;
                sOptions += APTS_CaptureInputForLSODataConstants.PRIMARY_PARTNER + APTS_CaptureInputForLSODataConstants.VALUE_SEPARATOR;
            }
            
            
            if(oOpportunity.Account_End_User__c != null) {
                sOptions += APTS_CaptureInputForLSODataConstants.ACCOUNT_END_USER;
            }
            
            controller.setQuotationForOptions(sOptions);
        }
        catch(Exception e){
            System.debug('Error:\t'+e.getMessage());
        }
    }
    
    /**
     * Method Find the chosen Account’s LSO from Opportunity.
     */
    private void isOpportunityHasLSO(Opportunity oOppty){
        system.debug('quotationFor: >>>> '+ quotationFor);
        
        if(oOppty.Account_Customer_LSO_Reference_Data__c != null){
            opportunityLSOId = oOppty.Account_Customer_LSO_Reference_Data__c;
            accountId = oOppty.Account.ID;
            controller.sSelectedAccount = oOppty.Account.Name;
            //controller.setIsBuyingAccount(true);
        }else if(oOppty.Primary_Partner_LSO_Reference_Data__c != null){
            opportunityLSOId = oOppty.Primary_Partner_LSO_Reference_Data__c;
            accountId = oOppty.Account_End_User__c;
            controller.sSelectedAccount = oOppty.Account_End_User__r.Name;
            //controller.setIsBuyingAccount(false);
        }else if(oOppty.End_User_LSO_Reference_Data__c != null){
            opportunityLSOId = oOppty.End_User_LSO_Reference_Data__c;
            controller.sSelectedAccount = '';
            //controller.setIsBuyingAccount(false);
        } 
        
        system.debug(' Test Data: >>> '+ oOppty.Account.ID + '-' + oOppty.Account.Name + '-' + oOppty.Account_Customer_LSO_Reference_Data__c+'----'+primaryPartnetId + '-----' +oOppty.Account_End_User__c);
        system.debug('<<<< END USER LSO >>>>'+oOppty.End_User_LSO_Reference_Data__c);
        
        if(oOppty.Account.ID != null && !oOppty.Account.Name.equalsIgnoreCase(Label.APTS_Unknown_Account) && oOppty.Account_Customer_LSO_Reference_Data__c == null && quotationFor.equals('Account Customer')){
            //controller.addErrorMessage(Label.APTS_NoLSOForAccCust);
            controller.addWarningMessage(Label.APTS_NoLSOForAccCust);
        }else if(primaryPartnetId != null && (oOppty.Primary_Partner_LSO_Reference_Data__c == null) && quotationFor.equals(APTS_CaptureInputForLSODataConstants.PRIMARY_PARTNER)){
            controller.addWarningMessage(Label.APTS_NoLSOForPartnerAcc);
        }else if(oOppty.Account_End_User__c != null && (oOppty.End_User_LSO_Reference_Data__c == null && quotationFor.equals('Account End User'))){
            controller.addWarningMessage(Label.APTS_NoLSOForAccEndUser);
        }
    }
    
    
    /**
     * Method to initialise the QuotationFor value on page load
    */
    private void initialiseQuotationFor(Opportunity objOpp){
        //String sQuotationForOptions = null;
        
        if(objOpp.Account.Id != null){
            quotationFor = APTS_CaptureInputForLSODataConstants.ACCOUNT_CUSTOMER;
            endUserAccountId = objOpp.Account.Id;
        }else if(objOpp.Account_End_User__c != null){
            quotationFor = APTS_CaptureInputForLSODataConstants.ACCOUNT_END_USER;
            endUserAccountId = objOpp.Account_End_User__c;
        }else if(primaryPartnetId != null){
            // Need to check primary partner
            quotationFor = APTS_CaptureInputForLSODataConstants.PRIMARY_PARTNER;
        }
    } 
    
    /**
     * Method to fetch and set the details, like account id, sales organization, distribution channel and
     * SAP division from ERP (Local) Reference Data.
     */
    private ERP_Reference_Data__c fetchAndSetDetailsFromERPReferenceData(String referenceId) {
        
        ERP_Reference_Data__c referenceObject;
        
        try {
            referenceObject = [SELECT Account__c, Sales_Office_Text__c ,SAP_Sales_Organization__c, SAP_Distribution_Channel__c, SAP_Division__c,Local_Customer_ID__c  FROM  ERP_Reference_Data__c  WHERE id = :referenceId LIMIT 1];
        } catch (Exception ex) {
            System.debug('Exception occured while fetching ERP Reference Data from Opportunity.\nException : ' + ex);
            controller.addErrorMessage('Exception occured while fetching ERP Reference Data from Opportunity. Please try again after sometime.');
        }
        
        if(referenceObject != null) {
            accountId = referenceObject.Account__c;
            salesOrganization = referenceObject.SAP_Sales_Organization__c;
            distributionChannel = referenceObject.SAP_Distribution_Channel__c;
            sapDivision = referenceObject.SAP_Division__c;
            customerID = referenceObject.Local_Customer_ID__c;
            sSalesOffice = referenceObject.Sales_Office_Text__c;
            controller.sSalesOffice = referenceObject.Sales_Office_Text__c;
        }
        else{
            system.debug('<<<< Added Message >>>>');
            controller.addWarningMessage('No Operation data found. Please add LSO data manually.');
        }
        
        return referenceObject;
    }
    
    /*
    * @Owner: Jignesh Shekhaliya
    * @Description: Method to Filter ERP Reference Data for Account
    * @Date: 30-Oct-2015
    */
    /*private List<ERP_Reference_Data__c> fetchERPReferenceDataForAccount(){
        String sAccLSOKey;
        String sUserLSO;
        String sUserLSO1;
        String sUserDefaultBU;
        List<ERP_Reference_Data__c> listFilteredLRD = new List<ERP_Reference_Data__c>();
        try{
            system.debug('ERP Ref Data - Account ID >>>>> :' + accountId);
            if(!String.isEmpty(accountId)){
                
                // Get User Details
                User loggedInUser = [SELECT Id, Default_Country_ISO_Code__c, Default_BU__c, Default_LSO__c FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
                if(loggedInUser == null){
                    controller.addErrorMessage('User information not found.');
                }else if(String.isEmpty(loggedInUser.Default_LSO__c)){
                    controller.addErrorMessage('Default LSO for User is not found.');
                }else{
                    // Create User LSO Key
                    if(!String.isEmpty(loggedInUser.Default_BU__c)){
                        sUserDefaultBU = loggedInUser.Default_BU__c;
                        sUserLSO = loggedInUser.Default_LSO__c + loggedInUser.Default_BU__c;
                    }else{
                        sUserLSO = loggedInUser.Default_LSO__c;
                    }
                }
                System.debug('User Profile Data >>>>: '+sUserDefaultBU +'-'+sUserLSO);
                // Get Account Specific ERP Local Reference Data Records
                List<ERP_Reference_Data__c> listERPRefData = [  SELECT Id, Local_Customer_ID__c, Sales_Office_Text__c, SAP_Sales_Organization__c, SAP_Distribution_Channel__c, LSO__c, LBU__c 
                                                                FROM ERP_Reference_Data__c 
                                                                WHERE Account__c =: accountId 
                                                                LIMIT 1000
                                                             ];
                
                // Process ERP Local Reference Data and Filter the records.
                if(!listERPRefData.isEmpty()){
                    for(ERP_Reference_Data__c lrd:listERPRefData){
                        sAccLSOKey = String.valueof(lrd.LSO__c)+String.valueof(lrd.LBU__c);
                        system.debug('Acc LSO Key>>>> : '+ sAccLSOKey);
                        if(sUserDefaultBU!=null && lrd.LBU__c!= null && sUserLSO!=null && sUserLSO.equalsIgnoreCase(sAccLSOKey)){
                            listFilteredLRD.add(lrd);
                        }
                        else if(sUserDefaultBU==null &&  lrd.LBU__c == null && sUserLSO!=null && sUserLSO.equalsIgnoreCase(String.valueof(lrd.LSO__c))){
                            listFilteredLRD.add(lrd);
                        }
                    }
                }
            }
        } catch (Exception ex){
            controller.addErrorMessage('Error while fetching ERP LSO Data. Please check if data is existing. If not, please create one and try again.');
            System.debug('Exception occured while fetching ERP LSO Data.\nException : ' + ex);
        }
        
        return listFilteredLRD;
    } */
    
    /**
     * Method to fetch the LSO Data based on user country, account ID, SAP division, Distribution Channel and Sales Organization.
     * Method will capture the fetched data in MAP.
     */
    public List<APTS_LP_Local_Customer_Reference_Data__c> fetchApttusLSODataList(ERP_Reference_Data__c oLRDRefData) {
        List<APTS_LP_Local_Customer_Reference_Data__c> listLSOData = new List<APTS_LP_Local_Customer_Reference_Data__c>();
        try {
            // Quotation from Opportunity
            accountId = controller.oAccountSO.Id;
            
            if(APTS_CaptureInputForLSODataConstants.OPPORTUNITY.equals(baseObject) && APTS_CaptureInputForLSODataConstants.QUOTATION.equals(targetObject)) {
                
                // Removing this if condition due to addition of task creation and mail alert for Missing LOd for - R3.1
                //if(isLSOReferenceFoundForOpportunity){
                    
                    system.debug('Account Id: >>> '+accountId);
                    
                    /* Commented by JS on 12-Dec-2015
                    // Prepare External Key from ERP LSO (SAP ID + Sales organisation + Distribution Channel.)
                    String sExternalID =  customerID + salesOrganization + distributionChannel;
                    
                    system.debug('sExternalID ===>'+sExternalID);
                    
                    String query = 'SELECT APTS_LP_SAP_Customer_ID__c, APTS_LP_Sales_Organisation__c, APTS_LP_Distribution_Channel__c,';
                    query += ' APTS_Payment_Terms__c, APTS_LP_Incoterms__c, APTS_LP_Local_Channel__c, APTS_SAP_Division__c';
                    query += ' FROM  APTS_LP_Local_Customer_Reference_Data__c WHERE APTS_LP_Account__c = :accountId AND';
                    query += ' APTS_Country__c = :userCountryCode AND APTS_External_ID__c = :sExternalID AND APTS_LP_SAP_Customer_ID__c =:customerID'; 
                    query += ' AND APTS_LP_Distribution_Channel__c =:distributionChannel';
                    
                    listLSOData = Database.query(query);
                    */
                    
                    this.listWrapperLOD = APTS_LRDLODUtility.findMatchingLODRecords(accountId, controller, userCountryCode);
                    
                    if(listWrapperLOD != null && listWrapperLOD.size() > 0){
                        for(APTS_WrapperLOD oWapperLOD :listWrapperLOD){
                            listLSOData.add(oWapperLOD.LSOData);
                        }
                    }
                    
                    // Setting default SAP Customer ID for Non Buying Account
                    if(!listLSOData.isEmpty()){
                            setDefaultSAPCustomerIDForNonBuying(listLSOData);
                    }else{
                        // Show Warning Message if no LOD Records found
                        controller.addWarningMessage(Label.APTS_LODWarnning);
                    }
                //}
            }
            
            system.debug('Base Object Type: >>>>' + baseObject);
            
            // Agreement from Opportunity
            if(APTS_CaptureInputForLSODataConstants.OPPORTUNITY.equals(baseObject) && APTS_CaptureInputForLSODataConstants.MSPA.equals(targetObject)){
                //listLSOData = APTS_LRDLODUtility.GetLODForAgrrementFromOpportunity(controller, accountId, userCountryCode, oLRDRefData);
                system.debug('@@  accountId >>> OPty : '+ accountId);
                this.listWrapperLOD = APTS_LRDLODUtility.findMatchingLODRecords(accountId, controller, userCountryCode);
                
                if(listWrapperLOD != null && listWrapperLOD.size() > 0){
                    for(APTS_WrapperLOD oWapperLOD :listWrapperLOD){
                        listLSOData.add(oWapperLOD.LSOData);
                    }
                    
                }
                
                // Setting default SAP Customer ID for Non Buying Account
                if(listLSOData.isEmpty()){
                    system.debug('<<<< Agree - Oppty No LSO Data Found >>>>');
                    // Show Warning Message if no LOD Records found
                    controller.addErrorMessage(Label.APTS_NoLODAgrToAcc);
                }
            }
            
            // Quotation from Account
            if(APTS_CaptureInputForLSODataConstants.ACCOUNT.equals(baseObject) && APTS_CaptureInputForLSODataConstants.QUOTATION.equals(targetObject)){
                System.debug('<<<< IN Account To Quotation >>>>' + quotationFor);
                
                //listLSOData = APTS_LRDLODUtility.GetLODForQuotationorAgreementFromAccount(controller, accountId, userCountryCode);
                this.listWrapperLOD = APTS_LRDLODUtility.findMatchingLODRecords(accountId, controller, userCountryCode);
                if(listWrapperLOD != null && listWrapperLOD.size() > 0){
                    for(APTS_WrapperLOD oWapperLOD :listWrapperLOD){
                        listLSOData.add(oWapperLOD.LSOData);
                    }
                    
                }
                // Setting default SAP Customer ID for Non Buying Account
                if(!listLSOData.isEmpty()){
                        setDefaultSAPCustomerIDForNonBuying(listLSOData);
                }
                
                // Setting default SAP Customer ID for Non Buying Account
                if(listLSOData.isEmpty()){
                    // Show Warning Message if no LOD Records found
                    controller.addWarningMessage(Label.APTS_LODWarnning);
                }
            }
            
            // Agreement from Account
            if(APTS_CaptureInputForLSODataConstants.ACCOUNT.equals(baseObject) && APTS_CaptureInputForLSODataConstants.MSPA.equals(targetObject)){
             
                //listLSOData = APTS_LRDLODUtility.GetLODForQuotationorAgreementFromAccount(controller, accountId, userCountryCode);
                this.listWrapperLOD = APTS_LRDLODUtility.findMatchingLODRecords(accountId, controller, userCountryCode);
                if(listWrapperLOD != null && listWrapperLOD.size() > 0){
                    for(APTS_WrapperLOD oWapperLOD :listWrapperLOD){
                        listLSOData.add(oWapperLOD.LSOData);
                    }
                    
                }
                
                // Setting default SAP Customer ID for Non Buying Account
                if(listLSOData.isEmpty()){
                    // Show Warning Message if no LOD Records found
                    controller.addErrorMessage(Label.APTS_NoLODAgrToAcc);
                }
            }
            
        }catch(Exception ex) {
            
            controller.addErrorMessage('Quote From Opportunity - Error while fetching Apttus LSO Data. Please check if data is existing. If not, please create one and try again.');
            System.debug('Exception occured while fetching Apttus LSO Data.\nException : ' + ex);
        }
        return listLSOData;
    }
    
    /**
     * Method to fetch the description for codes in LSO data list from Master Picklist Table object and set them in map.
    */
    private void setLSOCodeDescriptionMapFromLSODataList(List<APTS_LP_Local_Customer_Reference_Data__c> lsoDataList) {
        
        if(APTS_CaptureInputForLSODataConstants.OPPORTUNITY.equals(baseObject) && !isLSOReferenceFoundForOpportunity) {
            return;
        }
        
        Set<String> lsoCodeSet = new Set<String>();
        
        for(APTS_LP_Local_Customer_Reference_Data__c lsoData : lsoDataList) {
            lsoCodeSet.add(lsoData.APTS_Payment_Terms__c);
            lsoCodeSet.add(lsoData.APTS_LP_Incoterms__c);
            lsoCodeSet.add(lsoData.APTS_LP_Local_Channel__c);
            lsoCodeSet.add(lsoData.APTS_LP_Distribution_Channel__c);
        }
        
        List<APTS_Master_Picklist_Table__c> masterDataList = null;
        
        try {
            masterDataList = [SELECT ID, APTS_Code__c, APTS_Code_Description__c, APTS_Code_Used_For__c  FROM APTS_Master_Picklist_Table__c  WHERE APTS_Code__c IN :lsoCodeSet  AND APTS_Locale__c = :[SELECT LocaleSidKey  FROM User  WHERE id = :UserInfo.getUserId()].LocaleSidKey];
        } catch (Exception ex) {
            System.debug('Error while fetching the master data list from Master Data Table.\nException : ' + ex);
        }
        
        for(APTS_Master_Picklist_Table__c masterData : masterDataList) {
            
            if(lsoCodeDescriptionMap.get(masterData.APTS_Code_Used_For__c) == null) {
                lsoCodeDescriptionMap.put(masterData.APTS_Code_Used_For__c, new Map<String, String>());
            }
            
            if(lsoCodeDescriptionIdMap.get(masterData.APTS_Code_Used_For__c) == null) {
                lsoCodeDescriptionIdMap.put(masterData.APTS_Code_Used_For__c, new Map<String, String>());
            }
            
            lsoCodeDescriptionMap.get(masterData.APTS_Code_Used_For__c).put(masterData.APTS_Code__c, masterData.APTS_Code_Description__c);
            
            lsoCodeDescriptionIdMap.get(masterData.APTS_Code_Used_For__c).put(masterData.APTS_Code__c, masterData.ID);
        }
    }
    
    /**
     * Method to process the list of fetched Apttus LSO data.
     */
    private void processLSODataList(List<APTS_LP_Local_Customer_Reference_Data__c> lsoDataList) {
        
        if(APTS_CaptureInputForLSODataConstants.OPPORTUNITY.equals(baseObject) && !isLSOReferenceFoundForOpportunity) {
            return;
        }
        
        // Only one LSO record fetched
        if(lsoDataList != null && lsoDataList.size() == 1) {
            
            APTS_LP_Local_Customer_Reference_Data__c lsoData = lsoDataList.get(0);
            
            lsoDataMap.put('salesOrganization', lsoData.APTS_LP_Sales_Organisation__c);
            lsoDataMap.put('distributionChannel', lsoData.APTS_LP_Distribution_Channel__c);
            lsoDataMap.put('sapDivision', lsoData.APTS_SAP_Division__c);
            lsoDataMap.put('sapCustomerId', lsoData.APTS_LP_SAP_Customer_ID__c);
            lsoDataMap.put('incoterms', lsoData.APTS_LP_Incoterms__c);
            lsoDataMap.put('paymentTerms', lsoData.APTS_Payment_Terms__c);
            lsoDataMap.put('localChannel', lsoData.APTS_LP_Local_Channel__c);
            lsoDataMap.put('incotermDescription', getDescriptionForLSOCode(lsoData.APTS_LP_Incoterms__c, APTS_CaptureInputForLSODataConstants.INCOTERM));
            lsoDataMap.put('paymentTermDescription', getDescriptionForLSOCode(lsoData.APTS_Payment_Terms__c, APTS_CaptureInputForLSODataConstants.PAYMENT_TERM));
            lsoDataMap.put('localChannelDescription', getDescriptionForLSOCode(lsoData.APTS_LP_Local_Channel__c, APTS_CaptureInputForLSODataConstants.LOCAL_CHANNEL));
            
            lsoDataMap.put('distributionChannelCodeDescriptionId', getCodeDescriptionIdForLSOCode(lsoData.APTS_LP_Distribution_Channel__c, APTS_CaptureInputForLSODataConstants.DISTRIBUTION_CHANNEL));
            lsoDataMap.put('incotermCodeDescriptionId', getCodeDescriptionIdForLSOCode(lsoData.APTS_LP_Incoterms__c, APTS_CaptureInputForLSODataConstants.INCOTERM));
            lsoDataMap.put('paymentTermCodeDescriptionId', getCodeDescriptionIdForLSOCode(lsoData.APTS_Payment_Terms__c, APTS_CaptureInputForLSODataConstants.PAYMENT_TERM));
            lsoDataMap.put('localChannelCodeDescriptionId', getCodeDescriptionIdForLSOCode(lsoData.APTS_LP_Local_Channel__c, APTS_CaptureInputForLSODataConstants.LOCAL_CHANNEL));
            
            //isExactlyOneApttusLSOSelected = true;
            
            if(APTS_CaptureInputForLSODataConstants.QUOTATION.equals(targetObject)) {
                isExactlyOneApttusLSOSelected = false;
                createOptionMapFromApttusLSOList(lsoDataList);
            }
        }
        
        // If fetched LSO records are >1
        else if (lsoDataList != null && lsoDataList.size() > 1) {
            
            isExactlyOneApttusLSOSelected = false;
            createOptionMapFromApttusLSOList(lsoDataList);
        }
        
        // If no LSO record is existing
        else {
            
            String errorMessage = 'No Financial and Shipping information found for Customer for country : ' + userCountry;
            
            if(APTS_CaptureInputForLSODataConstants.OPPORTUNITY.equals(baseObject)) {
                errorMessage = errorMessage + ', distribution channel : ' + distributionChannel + ', sales organization : ' + salesOrganization + ' and SAP division : ' + sapDivision;
            }
            
            if(APTS_CaptureInputForLSODataConstants.ACCOUNT.equals(baseObject)
                 && APTS_CaptureInputForLSODataConstants.QUOTATION.equals(targetObject)) {
                controller.addWarningMessage('Dp- Operational Data not available. Click on Next button to create Quote and manually select Operational Data there to proceed further.');
            } else {
                controller.addErrorMessage(errorMessage);
            }
        }
    }
        
    /**
     * Method to create map from the apttus lso data list.
     * Format of key in map - "salesOganization-distributionChannel-sapDivision"
     * Format of value in map - set of "sapCustomerId ^^ incoterms ^^ paymentTerms ^^ localChannel"
     */
    private void createOptionMapFromApttusLSOList(List<APTS_LP_Local_Customer_Reference_Data__c> lsoDataList) {
        
        for(APTS_LP_Local_Customer_Reference_Data__c lsoData : lsoDataList) {
            
            String key = lsoData.APTS_LP_Sales_Organisation__c + APTS_CaptureInputForLSODataConstants.VALUE_SEPARATOR
                + lsoData.APTS_LP_Distribution_Channel__c + APTS_CaptureInputForLSODataConstants.VALUE_SEPARATOR
                + lsoData.APTS_SAP_Division__c;
            
            String value = lsoData.APTS_LP_SAP_Customer_ID__c + APTS_CaptureInputForLSODataConstants.VALUE_SEPARATOR
                + lsoData.APTS_LP_Incoterms__c + APTS_CaptureInputForLSODataConstants.VALUE_SEPARATOR
                + lsoData.APTS_Payment_Terms__c + APTS_CaptureInputForLSODataConstants.VALUE_SEPARATOR 
                + lsoData.APTS_LP_Local_Channel__c;
            
            if(additionalLSOOptionsMap.get(key) == null) {
                additionalLSOOptionsMap.put(key, new Set<String>());
            }
            
            additionalLSOOptionsMap.get(key).add(value);
        }
    }
    
    /**
     * Method to create new record and page reference link from there when record
     * has be created after selecting other inputs in page.
     */
    public void createRecordAndGeneratePageReferenceLink(Map<String, String> dataMap) {
        
        try{
            // Set the new values of variable from the data map to create record.
            if(dataMap != null) {
                if(APTS_CaptureInputForLSODataConstants.ACCOUNT.equals(baseObject)) {
                    salesOrganization = dataMap.get('salesOrganization');
                    distributionChannel = dataMap.get('distributionChannel');
                    sapDivision = dataMap.get('sapDivision');
                    quotationFor = dataMap.get('quotationFor');
                }
                else if(APTS_CaptureInputForLSODataConstants.OPPORTUNITY.equals(baseObject)){
                    
                    system.debug('** Inside CreateRecord==========>'+dataMap);  
                }
                additionalLSOData = dataMap.get('additionalLSOData');
                
                // Create LSO data map from data map.
                setLSODataMapFromDataMap(dataMap);
            }
            
            // Create new record and its page reference link.
            ID newRecordId = createRecordAndSetLSOData();
            
            if(newRecordId != null) {
                createPageReferenceLink(newRecordId);
            }
        }
        catch(Exception e){
            System.debug('Error:\t'+e.getMessage());

        }
    }
    
    /**
     * Method to create LSO data map from the input data map.
     */
    private void setLSODataMapFromDataMap(Map<String, String> dataMap) {
        
        String[] additionalLSODataValues = new List<String> {null, null, null, null} ;
        String sapCustomerId = '';
        String incoterms = '';
        String paymentTerms = '';
        String localChannel = '';
        
        if(!String.isBlank(dataMap.get('additionalLSOData'))) {
            additionalLSODataValues = dataMap.get('additionalLSOData').split(APTS_CaptureInputForLSODataConstants.VALUE_SEPARATOR);
            sapCustomerId = additionalLSODataValues[0];
            incoterms = additionalLSODataValues[1];
            paymentTerms = additionalLSODataValues[2];
            localChannel = additionalLSODataValues[3];
        }
        
        lsoDataMap.put('salesOrganization', dataMap.get('salesOrganization'));
        lsoDataMap.put('distributionChannel', dataMap.get('distributionChannel'));
        lsoDataMap.put('sapDivision', dataMap.get('sapDivision'));
        lsoDataMap.put('sapCustomerId', sapCustomerId);
        lsoDataMap.put('incoterms', incoterms);
        lsoDataMap.put('paymentTerms', paymentTerms);
        lsoDataMap.put('localChannel', localChannel);
        lsoDataMap.put('incotermDescription', getDescriptionForLSOCode(incoterms, APTS_CaptureInputForLSODataConstants.INCOTERM));
        lsoDataMap.put('paymentTermDescription', getDescriptionForLSOCode(paymentTerms, APTS_CaptureInputForLSODataConstants.PAYMENT_TERM));
        lsoDataMap.put('localChannelDescription', getDescriptionForLSOCode(localChannel, APTS_CaptureInputForLSODataConstants.LOCAL_CHANNEL));
        
        lsoDataMap.put('distributionChannelCodeDescriptionId', getCodeDescriptionIdForLSOCode(dataMap.get('distributionChannel'), APTS_CaptureInputForLSODataConstants.DISTRIBUTION_CHANNEL));
        lsoDataMap.put('incotermCodeDescriptionId', getCodeDescriptionIdForLSOCode(incoterms, APTS_CaptureInputForLSODataConstants.INCOTERM));
        lsoDataMap.put('paymentTermCodeDescriptionId', getCodeDescriptionIdForLSOCode(paymentTerms, APTS_CaptureInputForLSODataConstants.PAYMENT_TERM));
        lsoDataMap.put('localChannelCodeDescriptionId', getCodeDescriptionIdForLSOCode(localChannel, APTS_CaptureInputForLSODataConstants.LOCAL_CHANNEL));
        
        lsoDataMap.put('localChannelCode', localChannel);
        lsoDataMap.put('paymentTermsCode', paymentTerms);
        lsoDataMap.put('incotermsCode', incoterms);
    }
    
    /**
     * Method to create record and return its id.
     */
    private ID createRecordAndSetLSOData() {
        
        // Do not set sales office for Account End User and Primary Partner - JS - 12-Nov-2015
        if(!controller.sQuotationFor.equals(APTS_CaptureInputForLSODataConstants.ACCOUNT_CUSTOMER)){
            controller.sSalesOffice = '';
        }
        system.debug('<<<< Target Object >>>>'+ targetObject);
        // Create new MSPA Record
        if(APTS_CaptureInputForLSODataConstants.MSPA.equals(targetObject)) {
            
            Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c();
            
            agreement.Name = 'MSPA - ' + baseObjectName;
            agreement.APTS_Terms_of_Payment__c = lsoDataMap.get('paymentTerms');
            agreement.APTS_LP_Sales_Organization__c = lsoDataMap.get('salesOrganization');
            agreement.APTS_SAP_Customer_ID__c = lsoDataMap.get('sapCustomerId');
            agreement.APTS_Incoterm_Description__c = lsoDataMap.get('incotermDescription');
            agreement.APTS_Payment_Term_Description__c = lsoDataMap.get('paymentTermDescription');
            agreement.APTS_Local_Channel_Description__c = lsoDataMap.get('localChannelDescription');
            agreement.APTS_LP_Sales_Person__c = UserInfo.getUserId();
            
            // Set LSO data - JS on 10-Nov-2015
            /*agreement.APTS_Distribution_Channel__c = getMPLRecordIDForLOD(lsoDataMap.get('distributionChannel'),'Distribution Channel');
            agreement.APTS_Local_Channel__c = getMPLRecordIDForLOD(lsoDataMap.get('localChannel'),'Local Channel');
            agreement.APTS_Incoterms__c = getMPLRecordIDForLOD(lsoDataMap.get('incoterms'),'Incoterm');
            agreement.APTS_Payment_Terms__c = getMPLRecordIDForLOD(lsoDataMap.get('paymentTerms'),'Payment Term');
            */
            if(controller.oSelectedWrapperLOD != null){
                agreement.APTS_Distribution_Channel__c = controller.oSelectedWrapperLOD.sDistributionChannelId;
                agreement.APTS_Local_Channel__c = controller.oSelectedWrapperLOD.sLocalChannelId;
                agreement.APTS_Incoterms__c = controller.oSelectedWrapperLOD.sIncotermId;
                agreement.APTS_Payment_Terms__c = controller.oSelectedWrapperLOD.sPaymentTermId;
            }
            // LSO Data set end here
            
            if(!String.isEmpty(controller.sSalesOffice)){
                // Get Sales Office Information
                User oCurrentUser = [select Sales_Territory_Name__c,LocaleSidKey, Country from User where id=:UserInfo.getUserId() LIMIT 1];
                String sSalesOfficeId = APTS_LP_CommonUtil.getSalesOfficeExistInLSOFields(controller.sSalesOffice,oCurrentUser.Country);
                agreement.APTS_Sales_Office__c = sSalesOfficeId;
                
                // Set Sales Office details from Master PickList Table
                APTS_Master_Picklist_Table__c oMPLSalesOffice = APTS_LP_CommonUtil.getMPLSalesOffice(controller.sSalesOffice,oCurrentUser.Country);
                if(oMPLSalesOffice != null){
                    agreement.APTS_Sales_Office_LP__c = oMPLSalesOffice.Id;
                }
            }
            system.debug('<<<< In Agreement >>>>: ' + baseObject + '------' +accountId + '----' + endUserAccountId);
            if(APTS_CaptureInputForLSODataConstants.OPPORTUNITY.equals(baseObject)) {
                agreement.Apttus__Related_Opportunity__c = baseObjectId;
                agreement.APTS_LP_AccountCustomer__c = accountId;
                agreement.APTS_Account_End_User__c = endUserAccountId;
                agreement.APTS_LP_Account_End_User__c = primaryPartnetId;
            } else if(APTS_CaptureInputForLSODataConstants.ACCOUNT.equals(baseObject)) {
                system.debug('<<<< Account >>>>'+ accountType + '==='+baseObjectId +'========'+ APTS_CaptureInputForLSODataConstants.BUYING);
                
                if(APTS_CaptureInputForLSODataConstants.BUYING.equals(accountType)) {
                    agreement.APTS_LP_AccountCustomer__c = baseObjectId;
                } else if(APTS_CaptureInputForLSODataConstants.NON_BUYING.equals(accountType)) {
                    agreement.APTS_LP_Account_End_User__c = baseObjectId;
                }
            }
            
            if(targetObjectRecordTypeId != null) {
                agreement.RecordTypeId = targetObjectRecordTypeId;
            }
            
            agreement.RecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get(APTS_Agreement_Record_Type__c.getOrgDefaults().APTS_Default_Record_Type__c).getRecordTypeId();
            
            return insertRecord (agreement);
        }
        
        // Create new QUOTATION Record
        else if (APTS_CaptureInputForLSODataConstants.QUOTATION.equals(targetObject)) {
                  
            return CreateQuotation();      
        }
        
        
         
                  
        
        return null;
    }
    
    /*
     * @Description: Create New Quotation
    */
    Private Id CreateQuotation(){
        Apttus_Proposal__Proposal__c oProposal = new Apttus_Proposal__Proposal__c();
            
        oProposal.Apttus_Proposal__Proposal_Name__c = 'Quotation - ' + baseObjectName;
        oProposal.APTS_LP_Incoterms__c = lsoDataMap.get('incoterms');
        oProposal.APTS_LP_Local_Channel__c = lsoDataMap.get('localChannel');
        oProposal.APTS_Terms_of_Payment__c = lsoDataMap.get('paymentTerms');
        oProposal.APTS_LP_Distribution_Channel__c = lsoDataMap.get('distributionChannel');
        oProposal.APTS_LP_Sales_Organization__c = lsoDataMap.get('salesOrganization');
        
        if(!String.isBlank(lsoDataMap.get('sapCustomerId')) && lsoDataMap.get('sapCustomerId')!= 'null'){
            oProposal.APTS_SAP_Customer_ID__c = lsoDataMap.get('sapCustomerId');
        }
        
        oProposal.APTS_Incoterm_Description__c = lsoDataMap.get('incotermDescription');
        oProposal.APTS_Payment_Term_Description__c = lsoDataMap.get('paymentTermDescription');
        oProposal.APTS_Local_Channel_Description__c = lsoDataMap.get('localChannelDescription');
        
        /*
        oProposal.APTS_Incoterms__c = lsoDataMap.get('incotermCodeDescriptionId');
        oProposal.APTS_Payment_Terms__c = lsoDataMap.get('paymentTermCodeDescriptionId');
        oProposal.APTS_Local_Channel__c = lsoDataMap.get('localChannelCodeDescriptionId');
        oProposal.APTS_Distribution_Channel__c = lsoDataMap.get('distributionChannelCodeDescriptionId');
        */
        system.debug('<<< Selected LOD >>>> '+controller.oSelectedWrapperLOD);
        if(controller.oSelectedWrapperLOD != null){
            oProposal.APTS_Incoterms__c = controller.oSelectedWrapperLOD.sIncotermId;
            oProposal.APTS_Payment_Terms__c = controller.oSelectedWrapperLOD.sPaymentTermId;
            oProposal.APTS_Local_Channel__c = controller.oSelectedWrapperLOD.sLocalChannelId;
            oProposal.APTS_Distribution_Channel__c = controller.oSelectedWrapperLOD.sDistributionChannelId;
        }
        system.debug('<<<< Sales Office From Controller >>>>'+ controller.sSalesOffice);
        if(!String.isEmpty(controller.sSalesOffice)){
            User oCurrentUser = [select Sales_Territory_Name__c,LocaleSidKey, Country from User where id=:UserInfo.getUserId()];
            
            String sSalesOfficeId = APTS_LP_CommonUtil.getSalesOfficeExistInLSOFields(controller.sSalesOffice,oCurrentUser.Country);
            
            system.debug('@@ salesOfficeId: '+ sSalesOfficeId);
            oProposal.APTS_Sales_Office__c = sSalesOfficeId;
            
            // Set Sales Office details from Master PickList Table
            APTS_Master_Picklist_Table__c oMPLSalesOffice = APTS_LP_CommonUtil.getMPLSalesOffice(controller.sSalesOffice,oCurrentUser.Country);
            if(oMPLSalesOffice != null){
                oProposal.APTS_Sales_Office_LP__c = oMPLSalesOffice.Id;
            }
        }
        // Added to set default value by Chetan Patel // replaces "Quotation Layout Default" process builder functionality
        
        oProposal.APTS_LP_Sales_Person__c = UserInfo.getUserId();
        oProposal.Apttus_Proposal__ExpectedStartDate__c = system.today();
        oProposal.Apttus_Proposal__ExpectedEndDate__c = System.today().addMonths(3);
        oProposal.Apttus_Proposal__Proposal_Expiration_Date__c = System.today().addMonths(3);
        oProposal.Apttus_QPApprov__Approval_Status__c = 'Not Submitted';
        oProposal.Apttus_Proposal__Approval_Stage__c = 'Draft';
            
        // setting default values ends    
        system.debug('<<<< Oppertunity Id >>>>: ' +baseObjectId+'-----'+baseObject);
        if(APTS_CaptureInputForLSODataConstants.OPPORTUNITY.equals(baseObject)) {
            oProposal.Apttus_Proposal__Opportunity__c = baseObjectId;
            accountId = controller.sAccountCusForOppty;
            /* List<Opportunity> lstOppty  = new List<Opportunity>();
            lstOppty = [select AccountId from Opportunity where id=:baseObjectId];
            if(!lstOppty.isEmpty())
                oProposal.APTS_LP_AccountCustomer__c = lstOppty[0].AccountId; */
        } else if(APTS_CaptureInputForLSODataConstants.ACCOUNT.equals(baseObject)) {
            
            //Set standard account field with account selected by user
            oProposal.Apttus_Proposal__Account__c = baseObjectId;
            
            if(APTS_CaptureInputForLSODataConstants.BUYING.equals(accountType)) {
                oProposal.APTS_LP_AccountCustomer__c = baseObjectId;
            } else if(APTS_CaptureInputForLSODataConstants.NON_BUYING.equals(accountType)) {
                string sUnknownAcc = Label.APTS_Unknown_Account;                    
                // Get Unknown Account details and set Account Customer as Unknown ES Account                    
                List<Account> listUnknownAcc = [SELECT Id, NAME FROM Account WHERE Name =: sUnknownAcc LIMIT 1];
                if(!listUnknownAcc.isEmpty()){
                    oProposal.APTS_LP_AccountCustomer__c = listUnknownAcc[0].Id;
                    accountId = listUnknownAcc[0].Id;
                }
                
                if(controller.sQuotationFor.equals(APTS_CaptureInputForLSODataConstants.ACCOUNT_END_USER)){
                    endUserAccountId = controller.oAccountSO.Id;
                }
                if(controller.sQuotationFor.equals(APTS_CaptureInputForLSODataConstants.PRIMARY_PARTNER)){
                    primaryPartnetId = controller.oAccountSO.Id;
                }
            }
        }
        
        system.debug('<<<< Primary Partner Account >>>> '+ primaryPartnetId);
        quotationFor = controller.sQuotationFor;
        system.debug('Proposal- Quotation For >>>>: '+ quotationFor);
        oProposal.APTS_Quotation_Account_Type__c = quotationFor;
        
        
        if(!String.isEmpty(accountId)){
            oProposal.APTS_LP_AccountCustomer__c = accountId;
        }
        if(!String.isEmpty(endUserAccountId)){
            oProposal.APTS_Account_End_User__c = endUserAccountId;
        }
        if(!String.isEmpty(primaryPartnetId)){
            oProposal.APTS_LP_Account_End_User__c = primaryPartnetId;
        }
        
        
        //Re-Org changes - setting up record type
        oProposal.RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(APTS_Proposal_Record_Type__c.getOrgDefaults().APTS_Default_Record_Type__c).getRecordTypeId();
        
        
        //oProposal.APTS_Sales_Office__c = APTS_LP_CommonUtil.getSalesOfficeExistInLSOFields(sSalesOffice,userCountry);
        system.debug('<<<< Proposal - Primary Partner >>>>' + oProposal.APTS_LP_Account_End_User__c);
        system.debug('<<<< Local Channel >>>>: '+ oProposal.APTS_Local_Channel__c);
        return insertRecord (oProposal);
    }
    
    /**
     * Method to set the LSO data in the new record and insert it.
     * Method will return the ID of new record.
     */
    private ID insertRecord(sObject newRecord) {
        try {
            System.debug('Local Channel: '+newRecord.get('APTS_Local_Channel__c'));
            System.debug('Quotation Locale: '+newRecord.get('APTS_Locale__c'));
            insert newRecord;
            //call the method to perform reverse sync operation
            reverseSync(newRecord);
            return newRecord.id;
            
        } catch (Exception ex) {
            System.debug('Exception caught while inserting new ' + targetObject + ' record.\nException : ' + ex.getMessage());
            controller.addErrorMessage('Exception caught while inserting new ' + targetObject + ' record. Please try again after some time.');
            return null;
        }
    }
    
    
    /**
    @Method to create configuration and line items from opportunity line items.
    **/
    private void reverseSync(Sobject newRecord){
    
         string cartId;
         string opptyId;
         Id tempObjectId;
         
         Schema.SObjectType sobjectType = newRecord.id.getSObjectType();
         String sobjectName = sobjectType.getDescribe().getName();
         
         system.debug('entered***');
         //get opportunity Id based on sobject type
         if(sobjectName == 'Apttus_Proposal__Proposal__c'){
             opptyId= (String) newRecord.get('Apttus_Proposal__Opportunity__c');
         }else if(sobjectName == 'Apttus__APTS_Agreement__c'){
             opptyId=  (String) newRecord.get('Apttus__Related_Opportunity__c');
         }
         
         //fetch list of opportunity products from corresponding oppty
         List<OpportunityLineItem> opptyPrdList=[select id,priceBookEntry.product2.Id,priceBookEntry.product2.APTS_LP_Is_Hierarchy__c from OpportunityLineItem where opportunityId=:opptyId AND priceBookEntry.product2.APTS_LP_Is_Hierarchy__c=TRUE];
         
         if(!opptyPrdList.isEmpty()){
                 
               if(sobjectName == 'Apttus_Proposal__Proposal__c'){
                 
                     system.debug('entered2***'+sobjectName);
                     //API to create cart
                     Apttus_CPQApi.CPQ.CreateCartRequestDO request = new Apttus_CPQApi.CPQ.CreateCartRequestDO();
                    
                     request.QuoteId = newRecord.Id;
                     
                     Apttus_CPQApi.CPQ.CreateCartResponseDO response = Apttus_CPQApi.CPQWebService.createCart(request);
                     
                     cartId = response.CartId;
                 
               }else if(sobjectName == 'Apttus__APTS_Agreement__c'){
               
                     tempObjectId = Apttus_CMConfig.CMConfigWebService.createConfigurationRequest(newRecord.Id, null);
                     PageReference pageRef = Apttus_CMConfig.CMConfigWebService.startConfiguration(tempObjectId, null);
                     cartId = ID.valueOf(pageRef.getParameters().get('id'));
                     system.debug('mspa cart***'+cartId);
               } 
                
         
                     //API to insert multiple products from opportunity line items.
                     List <Apttus_CPQApi.CPQ.SelectedProductDO> selectedProdDOList = new List<Apttus_CPQApi.CPQ.SelectedProductDO>();
                              
                      for(OpportunityLineItem prd : opptyPrdList){
                          Apttus_CPQApi.CPQ.SelectedProductDO selProdDO = new Apttus_CPQApi.CPQ.SelectedProductDO();
                          selProdDO.ProductID = prd.priceBookEntry.product2.Id;
                          //set default quantity as 1
                          selProdDO.Quantity=1; 
                          selectedProdDOList.add(selProdDO);
                      }
                      system.debug('entered3***');
                      Apttus_CPQApi.CPQ.AddMultiProductRequestDO request2 = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO ();
                      request2.CartId= cartId;
                      request2.SelectedProducts = selectedProdDOList;
                      //API call to add multiple products to cart
                      Apttus_CPQApi.CPQ.AddMultiProductResponseDO response2 =Apttus_CPQApi.CPQWebService.addMultiProducts(request2);
                      
                      /*list<Decimal> linenumbers=new list<Decimal>();
                      //pricing API
                     for(Apttus_Config2__LineItem__c line: [select Id,Apttus_Config2__LineNumber__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c=:cartId])
                      {
                          linenumbers.add(line.Apttus_Config2__LineNumber__c);
                      }
                     for(Decimal line : linenumbers) {    
                           Apttus_CPQApi.CPQ.ComputeNetPriceRequestDO request = new Apttus_CPQApi.CPQ.ComputeNetPriceRequestDO();
                           request.CartId = cartId;
                           request.LineNumber = line;
                          
                           Apttus_CPQApi.CPQ.ComputeNetPriceResponseDO priceResponse = Apttus_CPQApi.CPQWebService.computeNetPriceForBundle(request);    
                     }*/
                          
                      if(sobjectName == 'Apttus__APTS_Agreement__c'){                  
                              
                        // create the finalize cart request
                        Apttus_CpqApi.CPQ.FinalizeCartRequestDO request = new Apttus_CpqApi.CPQ.FinalizeCartRequestDO();
                        // add request parameters
                        request.CartId = cartId;
            
                        // finalize the cart    
                        system.debug('##Invoking FinalizeCart API');
                        try {
            
                            Apttus_CpqApi.CPQ.FinalizeCartResponseDO response = Apttus_CpqApi.CPQWebService.finalizeCart(request);
                        } Catch(Exception ex) {
                            system.debug('##exception FinalizeCart API2');
                        }
                        
                        Apttus_CMConfig.CMConfigWebService.finalizeConfiguration(cartId);
                        system.debug('##Invoking FinalizeCart API3');
                        Apttus_CMConfig.CMConfigWebService.afterFinalizeConfiguration(cartId);
                        system.debug('##Invoking FinalizeCart API2');
                    
                      } else if(sobjectName == 'Apttus_Proposal__Proposal__c'){
                    
                         //webservice api call to finalize the cart
                         Apttus_CPQApi.CPQ.FinalizeCartRequestDO request = new Apttus_CPQApi.CPQ.FinalizeCartRequestDO();
                         request.CartId= cartId;
                         Apttus_CPQApi.CPQ.FinalizeCartResponseDO result = Apttus_CPQApi.CPQWebService.finalizeCart(request);
                         boolean success=result.IsSuccess;
                          
                         system.debug('quote finalize****');
                  }
             
         }
    }
    /**
     * Method to create page reference link to which page should be navigated if new record is created.
     */
    private void createPageReferenceLink(ID newRecordId) {
        
        String pageReferenceLinkStr = '';
        Map<String, String> parameterMap = new Map<String, String>();
        
        // Create URL when creating Quotation from Opportunity
        if(APTS_CaptureInputForLSODataConstants.OPPORTUNITY.equals(baseObject) && APTS_CaptureInputForLSODataConstants.QUOTATION.equals(targetObject)) {
            
            pageReferenceLinkStr = '/' + newRecordId + '/e';
            
            parameterMap.put('cancelURL', '/apex/apttus_proposal__cancelactioninterceptor?actionName=create_oppty_proposal&objectId=' + baseObjectId + '&opportunityId=' + baseObjectId + '&proposalId=' + newRecordId + '&rollbackId=' + newRecordId);
            parameterMap.put('retURL', '/'+ newRecordId);
        }
        
        // Create URL when creating MSPA from Opportunity
        else if (APTS_CaptureInputForLSODataConstants.OPPORTUNITY.equals(baseObject) && APTS_CaptureInputForLSODataConstants.MSPA.equals(targetObject)) {
            
            pageReferenceLinkStr = '/' + newRecordId + '/e';
            
            parameterMap.put('cancelURL', '/apex/apttus__cancelactioninterceptor?actionName=create_oppty_agreement&agreementId=' + newRecordId + '&objectId=' + baseObjectId + '&opportunityId=' + baseObjectId + '&rollbackId=' + newRecordId);
            parameterMap.put('retURL', '/'+ newRecordId);
            parameterMap.put('save_new_url', '/apex/apttus__opportunityagreementsavenew?agreementId=' + newRecordId);
            parameterMap.put('saveURL', '/apex/apttus__opportunityagreementsave?agreementId=' + newRecordId);
        }
        
        // Create URL when creating MSPA from Account
        else if(APTS_CaptureInputForLSODataConstants.ACCOUNT.equals(baseObject) && APTS_CaptureInputForLSODataConstants.MSPA.equals(targetObject)) {
            
            pageReferenceLinkStr = '/' + newRecordId + '/e';
            
            parameterMap.put('cancelURL', '/apex/apttus__cancelactioninterceptor?actionName=create_new_agreement&agreementId=' + newRecordId + '&objectId=' + baseObjectId + '&rollbackId=' + newRecordId);
            parameterMap.put('retURL', '/' + newRecordId);
        }
        
        // Create URL when creating Quotation from Account
        else if(APTS_CaptureInputForLSODataConstants.ACCOUNT.equals(baseObject) && APTS_CaptureInputForLSODataConstants.QUOTATION.equals(targetObject)) {
            
            pageReferenceLinkStr = '/' + newRecordId + '/e';
            
            parameterMap.put('cancelURL', '/apex/apttus_proposal__cancelactioninterceptor?actionName=create_new_proposal&proposalId=' + newRecordId + '&objectId=' + baseObjectId + '&rollbackId=' + newRecordId);
            parameterMap.put('retURL', '/' + newRecordId);
        }
        
        // Generating PageReference Link From URL
        if(pageReferenceLinkStr != null && pageReferenceLinkStr.length() > 0) {
            
            pageReferenceLink = new PageReference(pageReferenceLinkStr);
            pageReferenceLink.setRedirect(true);
            
            for(String key : parameterMap.keySet()) {
                pageReferenceLink.getParameters().put(key, parameterMap.get(key));
            }
        }
    }
    
    /**
     * Method to provide the page reference URL to which page should be navigated.
     */
    public PageReference getEditRecordPageReference() {
        return pageReferenceLink;
    }
    
    /**
     * Method to return map of options for input on the page.
     */
    public Map<String, Set<String>> getAdditionalLSOOptionsMap() {
        return additionalLSOOptionsMap;
    }
    
    /**
     * Method to identify if exactly one apttus LSO record is found.
     */
    public Boolean isExactlyOneApttusLSOSelected() {
        return isExactlyOneApttusLSOSelected;
    }
    
    /**
     * Method to get the description for the LSO code.
     */
     
    
    public String getDescriptionForLSOCode(String code, String codeUsedFor) {
        try{
            if(String.isBlank(code)) {
                return null;
            }
            
            if(lsoCodeDescriptionMap == null || lsoCodeDescriptionMap.get(codeUsedFor) == null) {
                return code + ' - ' + APTS_CaptureInputForLSODataConstants.NO_DESC_AVAILABLE;
            }
            
            String description = lsoCodeDescriptionMap.get(codeUsedFor).get(code);
            return code + ' - ' + ((description != null && description.length() > 0) ? description : APTS_CaptureInputForLSODataConstants.NO_DESC_AVAILABLE);
        }
        catch(Exception e){
            System.debug('Error:\t'+e.getMessage());
        }
        return null;
    }
    
    public String getCodeDescriptionIdForLSOCode(String code, String codeUsedFor) {
        
        try{
            if(String.isBlank(code)) {
                return null;
            }
            
            if(lsoCodeDescriptionIdMap == null || lsoCodeDescriptionIdMap.get(codeUsedFor) == null) {
                return null;
            }
            
            return lsoCodeDescriptionIdMap.get(codeUsedFor).get(code);
        }
        catch(Exception e){
            System.debug('Error:\t'+e.getMessage());
        }
        return null;
    }
    
    public String getMasterPickListCodeDesc(String code, String codeUsedFor){
        
        try{
            if(lsoCodeDescriptionMap == null || lsoCodeDescriptionMap.get(codeUsedFor) == null) {
                return APTS_CaptureInputForLSODataConstants.NO_DESC_AVAILABLE;
            }
            
            String description = lsoCodeDescriptionMap.get(codeUsedFor).get(code);
            return ((description != null && description.length() > 0) ? description : APTS_CaptureInputForLSODataConstants.NO_DESC_AVAILABLE);
        }
        catch(Exception e){
            System.debug('Error:\t'+e.getMessage());
        }
        return null;
        
        
    } 
    
    private void setDefaultSAPCustomerIDForNonBuying(List<APTS_LP_Local_Customer_Reference_Data__c> lsoDataList) {
        
        
        if(APTS_CaptureInputForLSODataConstants.ACCOUNT.equals(baseObject) && !APTS_CaptureInputForLSODataConstants.NON_BUYING.equals(accountType)) {
            return;
        }
        
        // Config setting can not be fetched if user country or division is blank or null
        if(userCountry == null || userCountry.length() == 0) {// || userDivision == null || userDivision.length() == 0) {
            return;
        }
        
        // Fetch country and division specific config settings and get record type.
        APTS_Capture_LSO_Input_Config_Settings__c oConfigSetting = APTS_Capture_LSO_Input_Config_Settings__c.getInstance('LP' + '-' + userCountry + ' Config Settings');
            
        if(oConfigSetting == null) {
            return;
        }
        
        // Setting default SAP Customer ID
        String sapCustomerID = oConfigSetting.APTS_Default_SAP_Customer_ID__c;
        
        if(sapCustomerID == null || sapCustomerID.length() == 0) {
            return;
        }
        
        /* Do not set default SAP Customer ID on LOD screen
        for(APTS_LP_Local_Customer_Reference_Data__c lsoData : lsoDataList) {
            if(lsoData.APTS_LP_SAP_Customer_ID__c == null || lsoData.APTS_LP_SAP_Customer_ID__c.length() == 0) {
                lsoData.APTS_LP_SAP_Customer_ID__c = sapCustomerID;
            }
        }*/
    }
    
    /*
        Method to get Master Picklist Record Id for LOD data.
        @owner: Jignesh Shekhaliya
    */
    private String getMPLRecordIDForLOD(string sCode, string sCodeFor){
        string sMPLRecordId;
        LIST<APTS_Master_Picklist_Table__c> listMPLRecord = [SELECT Id, APTS_Code__c, APTS_Code_Used_For__c FROM APTS_Master_Picklist_Table__c 
                                                                WHERE APTS_Code__c =: sCode 
                                                                AND APTS_Code_Used_For__c= : sCodeFor 
                                                                AND APTS_Locale__c =: UserInfo.getLocale()
                                                                LIMIT 1
                                                            ];
        if(!listMPLRecord.isEmpty()){
            sMPLRecordId = listMPLRecord[0].Id;
        }
        return sMPLRecordId;
    }
    /*
    private String getMPLRecordIDForLODByDesc(string sCodeDesc, string sCodeFor){
        string sMPLRecordId;
        system.debug('@@ sCodeDesc : '+ sCodeDesc);
        system.debug('@@ sCodeFor : '+ sCodeFor);
        system.debug('@@ locale : '+ UserInfo.getLocale());
        LIST<APTS_Master_Picklist_Table__c> listMPLRecord = [SELECT Id, APTS_Code__c, APTS_Code_Used_For__c FROM APTS_Master_Picklist_Table__c 
                                                                WHERE APTS_Code_Description__c =: sCodeDesc 
                                                                AND APTS_Code_Used_For__c= : sCodeFor 
                                                                AND APTS_Locale__c =: UserInfo.getLocale()
                                                                LIMIT 1
                                                            ];
        if(!listMPLRecord.isEmpty()){
            sMPLRecordId = listMPLRecord[0].Id;
        }
        return sMPLRecordId;
    }
    */
    /*
        @Description: Validate that atleast one Discount config should be found.
        @Owner: Jignesh Shekhaliya
     */
    private boolean validateDiscountConfig(){
        return true;
    }
    
}