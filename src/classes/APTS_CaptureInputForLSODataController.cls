/*************************************************************
@Name: APTS_CaptureInputForLSODataController
@Author: Shalin Shah
@CreateDate: 15th Sept 2015
@Description: Class to read URL parameters and capture user provided input data to fetch relevant Apttus LSO data on Quote/MSPA.
@UsedBy: Page - APTS_CaptureInputForLSOData
******************************************************************/

public class APTS_CaptureInputForLSODataController {
    
    // URL parameters
    public String sBaseObjectId {get; set;}
    public String sBaseObject {get; set;}
    public String sBaseObjectName {get; set;}
    public String sAccountType {get; set;}
    public String sTargetObject {get; set;}
    public String sBaseAccountObjectId;
    // User based parameters
    public String sUserCountry {get; set;}
    public String sUserCountryCode {get; set;}
    public String sUserDivision {get; set;}
    public String sTargetObjectRecordTypeId {get; set;}
    public string sRecordTypeName {get; set;}
    
    // Parameters for value selection on page
    public String sDistributionChannel {get; set;}
    public String sSAPDivision {get; set;}
    public String sSalesOrganization {get; set;}
    public String sAdditionalLSOData {get; set;}
    
    // Parameters to control visibility of sections
    public Boolean bIsInputDataSectionVisible {get; set;}
    public Boolean bIsLSODataSectionVisible {get; set;}
    public Boolean bIsNextButtonVisible {get; set;}
    
    public List<APTS_LP_Local_Customer_Reference_Data__c> lsoDataList {get; set;}
    public map<string,APTS_LP_Local_Customer_Reference_Data__c> mapLSODataList;
    public map<integer,APTS_WrapperLOD> mapLODWrapList;
    public Map<String, String> mapDataForProcessor;
    private APTS_CaptureInputForLSODataProcessor processor = new APTS_CaptureInputForLSODataProcessor(this);
    public boolean isLSOForAccount;
    public List<APTS_WrapperLOD> lstwapperLSOLIst {get; set;}
    public boolean bIsSectionForNonBuyingAccount  {get; set;}

    private String sQuotationForOptions = null;
    public String sQuotationFor {get; set;}
    public boolean bIsQuotationForVisible {get; set;}
    public String sSelectedAccount {get;set;}
    public String sSalesOffice {get;set;}
    public String lbu {get;set;}
    
    public List<ERP_Reference_Data__c> lrdList {get;set;}
    
    public Account oAccountSO{get; private set;}
    public String sAccountCusForOppty {get; private set;}
    public APTS_LP_Local_Customer_Reference_Data__c oSelectedLOD {get; private set;}
    public APTS_WrapperLOD oSelectedWrapperLOD {get; private set;}
    
    public List<SelectOption> lstOptions {get; private set;}
    public APTS_CaptureInputForLSODataController(){
        // Read URL Parameters
        sBaseObjectId = ApexPages.currentPage().getParameters().get('id');
        sBaseObject = ApexPages.currentPage().getParameters().get('baseObject');
        sBaseObjectName = ApexPages.currentPage().getParameters().get('name');
        sAccountType = ApexPages.currentPage().getParameters().get('type');
        sTargetObject = ApexPages.currentPage().getParameters().get('targetObject');
        isLSOForAccount = false;
        bIsSectionForNonBuyingAccount = false;
         
        
        sSalesOrganization = 'ABB';
        sSAPDivision = 'ZZ';
        
        if(APTS_CaptureInputForLSODataConstants.ACCOUNT.equals(sBaseObject)) {
                
            if(APTS_CaptureInputForLSODataConstants.BUYING.equals(sAccountType)) {
                setQuotationForOptions(APTS_CaptureInputForLSODataConstants.ACCOUNT_CUSTOMER);
            } else if (APTS_CaptureInputForLSODataConstants.NON_BUYING.equals(sAccountType)) {
                setQuotationForOptions(APTS_CaptureInputForLSODataConstants.PRIMARY_PARTNER
                                       + APTS_CaptureInputForLSODataConstants.VALUE_SEPARATOR
                                       + APTS_CaptureInputForLSODataConstants.ACCOUNT_END_USER);
            } else{
                setQuotationForOptions(APTS_CaptureInputForLSODataConstants.ACCOUNT_CUSTOMER);
            }
            
                
        }else if(APTS_CaptureInputForLSODataConstants.OPPORTUNITY.equals(sBaseObject)){
            opportunity oppty = [SELECT Id, Account.Name, AccountId, Account_End_User__c, Account_End_User__r.Name,
            Account_Customer_LSO_Reference_Data__c ,Primary_Partner_LSO_Reference_Data__c 
                                    FROM opportunity
                                    WHERE Id = :sBaseObjectId
                                    LIMIT 1
                                ];
                            
            processor.setQuotationForOptionsForOpportunity(oppty);
        }
        
        system.debug('<<<< IN on load >>>>'+sQuotationForOptions);
        this.lstOptions = this.FindQuotationForOptionList();
        setAccountDetails();
        
    }
    /**
     * Method to be executed on page loading to read URL parameters.
     */ 
    public PageReference onPageLoad() {
        
        try{
            // Fetching user details.
            fetchAndSetLoggedInUserDetails();
          
            // Do not proceed if user does not belong to LP Division.
            if(!isValidUserDivision()) {
                
                addErrorMessage('Permission Denied - User does not belong to LP Divison.');
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Please click on Back button to return to Previous Page.'));
                
                bIsNextButtonVisible = false;
                
                return null;
            }
             
            // Else begin to populate LSO data.
            else {
                
                
                if(APTS_CaptureInputForLSODataConstants.QUOTATION.equals(sTargetObject)) {
                    bIsQuotationForVisible = true;
                }
                
                
                // Fetch and set record type of target object
                setTargetObjectRecordTypeId();
                
                // Begin to fetch LSO data and execute further process
                processor.beginToProcessData(getDataMapForProcessorClass());
                lsoDataList = processor.listLODData;
                system.debug('<<<< LOD Data from Processor >>>>'+ lsoDataList);
                //lsoDataList = findApttusLSODataList();
                populateMapLSODataList(lsoDataList);
                this.lstwapperLSOLIst = processor.listWrapperLOD;
                prepareMapOfWrapperLOD();
                //prepareWrapperForLSOList(lsoDataList);
                
                // Return to the actual page if there are errors.
                if (ApexPages.hasMessages(ApexPages.severity.ERROR)) {
                    
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Please click on Back button to return to Previous Page.'));
                    bIsNextButtonVisible = false;
                    
                    return null;
                }
                
                // Proceed for created Quote/MSPA if it is created with one LSO record
                else if(processor.isExactlyOneApttusLSOSelected()) {
                    return processor.getEditRecordPageReference();
                }
                
                // If there are more LSO records found
                else {
                    bIsNextButtonVisible = true;
                    
                    // control visibility of sections on page
                    if(APTS_CaptureInputForLSODataConstants.OPPORTUNITY.equals(sBaseObject)) {
                        //setPageBlockSectionVisibility(false, true);
                        bIsSectionForNonBuyingAccount = true;
                        bIsLSODataSectionVisible = true;
                        bIsInputDataSectionVisible = false;
                    }else if(APTS_CaptureInputForLSODataConstants.ACCOUNT.equals(sBaseObject)) {
                        
                        bIsSectionForNonBuyingAccount = true;
                        bIsLSODataSectionVisible = true;
                        bIsInputDataSectionVisible = false;
                    }
                   
                    //Axay: if list size is greather than zero set first row as default;
                    system.debug('<<<< Wrapper List >>>>: '+ lstwapperLSOLIst);
                    
                    if(lstwapperLSOLIst.size() > 0){
                        system.debug('****'+lstwapperLSOLIst[0].iRecordId);
                        ApexPages.currentPage().getParameters().put('lsoid', string.valueof(lstwapperLSOLIst[0].iRecordId));
                        isLSOForAccount = true;
                        String selectedValue = '';
                        // Get Select LOD record details + JS - 12-Dec-2015
                        //APTS_WrapperLOD tmpLODData = new APTS_WrapperLOD();
                        oSelectedWrapperLOD  = mapLODWrapList.get(lstwapperLSOLIst[0].iRecordId);
                        if(oSelectedWrapperLOD != null){
                            this.oSelectedLOD = oSelectedWrapperLOD.LSOData;
                            
                            selectedValue = selectedValue + oSelectedWrapperLOD.LSOData.APTS_LP_SAP_Customer_ID__c + ' #& ';
                            selectedValue = selectedValue + oSelectedWrapperLOD.LSOData.APTS_LP_Incoterms__c + ' #& ';
                            selectedValue = selectedValue + oSelectedWrapperLOD.LSOData.APTS_Payment_Terms__c + ' #& ';
                            selectedValue = selectedValue + oSelectedWrapperLOD.LSOData.APTS_LP_Local_Channel__c + ' #& ';
                            this.sSalesOffice = oSelectedWrapperLOD.salesOffice;
                            system.debug('<<<< Controller Sales Office >>>>: '+ this.sSalesOffice);
                            sAdditionalLSOData = selectedValue;
                            sDistributionChannel = oSelectedWrapperLOD.LSOData.APTS_LP_Distribution_Channel__c;
                            
                            system.debug('@@ sAdditionalLSOData'+ sAdditionalLSOData);
                            mapDataForProcessor = getDataMapForProcessorClass();
                        }
                        
                    }
            
                    return null;
                }
            }
        }
        catch(Exception e){
            System.debug('Error:\t'+e.getMessage());
        }
        return null;
    }
    
    /**
     * Method to fetch and Set the logged in user details.
     */
    private void fetchAndSetLoggedInUserDetails() {
        
        User oLoggedInUser = null;
        
        // Fetching user details
        try {
            oLoggedInUser = [SELECT Country, CountryCode, Division_DIV__c FROM User WHERE id = :UserInfo.getUserId() LIMIT 1];
        } catch (Exception ex) {
            System.debug('Exception generated while fetching user details.\nException : ' + ex);
            addErrorMessage('Error generated while fetching logged in user. Please try after some time.');
        }
        
        // Setting user details.
        if(oLoggedInUser != null) {
            sUserCountry = oLoggedInUser.Country;
            sUserCountryCode = oLoggedInUser.CountryCode;
            sUserDivision = oLoggedInUser.Division_DIV__c;
        }
    }
    
    /**
     * Method to validate the user division. Logged in user must be of LP division.
     */
    private Boolean isValidUserDivision() {
        
        if(sUserDivision == null || !sUserDivision.equals(APTS_CaptureInputForLSODataConstants.LP_DIVISION)) {
            return false;
        } else {
            return true;
        }
    }
    
    /**
     * Method to get the data map to pass the parameters to processor class.
     */
    private Map<String, String> getDataMapForProcessorClass() {
        
        
        mapDataForProcessor = new Map<String, String>();
        
        mapDataForProcessor.put('baseObjectId', sBaseObjectId);
        mapDataForProcessor.put('baseObject', sBaseObject);
        mapDataForProcessor.put('baseObjectName', sBaseObjectName);
        mapDataForProcessor.put('accountType', sAccountType);
        mapDataForProcessor.put('targetObject', sTargetObject);
        mapDataForProcessor.put('distributionChannel', sDistributionChannel);
        mapDataForProcessor.put('sapDivision', sSAPDivision);
        mapDataForProcessor.put('salesOrganization', sSalesOrganization);
        mapDataForProcessor.put('userCountry', sUserCountry);
        mapDataForProcessor.put('userCountryCode', sUserCountryCode);
        mapDataForProcessor.put('targetObjectRecordTypeId', sTargetObjectRecordTypeId);
        mapDataForProcessor.put('additionalLSOData', sAdditionalLSOData);
        mapDataForProcessor.put('quotationFor', sQuotationFor);
        
        return mapDataForProcessor;
    }
    
    /**
     * Method to set the visibility of the page block sections on the page.
     */
    public void setPageBlockSectionVisibility (Boolean bIsInputDataSectionVisible, Boolean bIsLSODataSectionVisible) {
        try{
            this.bIsInputDataSectionVisible = bIsInputDataSectionVisible && !bIsSectionForNonBuyingAccount;
            this.bIsLSODataSectionVisible = bIsLSODataSectionVisible && !bIsSectionForNonBuyingAccount;
        }
        catch(Exception e){
            System.debug('Error:\t'+e.getMessage());
        }
    }
    
    /**
     * Action to be performed when Next button is clicked on the page.
     */
    public PageReference performNextAction() {
        
        ApexPages.getMessages().clear();
        
        try{
            // Perform further actions only if the user division is valid.
            if(isValidUserDivision()) {
                
                // If base object is account, check if addition LSO data selection section is to be shown. If it is, return.
                // If not, assign that additional data to its field to put in map.
                
                if(APTS_CaptureInputForLSODataConstants.ACCOUNT.equals(sBaseObject) && bIsInputDataSectionVisible) {
                    
                    String sKey = sSalesOrganization + APTS_CaptureInputForLSODataConstants.VALUE_SEPARATOR
                        + sDistributionChannel + APTS_CaptureInputForLSODataConstants.VALUE_SEPARATOR
                        + sSAPDivision;
                    
                    Set<String> setAdditionalLSODataValue = processor.getAdditionalLSOOptionsMap().get(sKey);
                    
                    if(setAdditionalLSODataValue.size() == 1) {
                        for(String sAdditionalData : setAdditionalLSODataValue) {
                            sAdditionalLSOData = sAdditionalData;
                        }
                    } else {
                        setPageBlockSectionVisibility(false, true);
                        return null;
                    }
                    
                }else{
                    system.debug('@@ in else part isLSOForAccount @@ :'+ isLSOForAccount);
                    // Proceed to create record and generate reference link for it.
                    if(isLSOForAccount)
                        processor.createRecordAndGeneratePageReferenceLink(mapDataForProcessor);
                    else
                        processor.createRecordAndGeneratePageReferenceLink(getDataMapForProcessorClass());
                }
                
            } else {
                addErrorMessage('Permission Denied - User does not belong to LP Divison.');
            }
            
            // Return to the actual page if there are errors.
            if (ApexPages.hasMessages(ApexPages.severity.ERROR)) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Please click on Back button to return to Previous Page.'));
                return null;
            }
            
            // Proceed to edit Quote/MSPA if there are no errors.
            else {
                return processor.getEditRecordPageReference();
            }
        }
        catch(Exception e){
            System.debug('Error:\t'+e.getMessage());
        }
        return null;
        
    }
    
    /**
     * Method to set id of target object record type fetched from custom setting.
     */
    private void setTargetObjectRecordTypeId() {
        
        // Config setting can not be fetched if user country or division is blank or null
        if(sUserCountry == null || sUserCountry.length() == 0 || sUserDivision == null || sUserDivision.length() == 0) {
            return;
        }
        
        // Fetch country and division specific config settings and get record type.
        APTS_Capture_LSO_Input_Config_Settings__c oConfigSetting = APTS_Capture_LSO_Input_Config_Settings__c.getInstance(sUserDivision + '-' + sUserCountry + ' Config Settings');
            
        if(oConfigSetting == null) {
            return;
        }
        
        //String sRecordTypeName;
        
        // Fetch record type name and id based on the target object type.
        if(APTS_CaptureInputForLSODataConstants.QUOTATION.equals(sTargetObject)) {
            sRecordTypeName = oConfigSetting.APTS_Quotation_Record_Type__c;
            sTargetObjectRecordTypeId  = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(sRecordTypeName).getRecordTypeId();
        } else if (APTS_CaptureInputForLSODataConstants.MSPA.equals(sTargetObject)) {
            sRecordTypeName = oConfigSetting.APTS_MSPA_Record_Type__c;
            sTargetObjectRecordTypeId  = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get(sRecordTypeName).getRecordTypeId();
        }
        if(String.isBlank(sTargetObjectRecordTypeId)){
            addErrorMessage('Error while fetching Record Type of ' + sTargetObject + '. Please contact Administrator.');
        }        
    }
    
    /**
     * Method to navigate to previous page on click on Back button on the page.
     */
    public PageReference navigateToPreviousPage() {
        try{
            PageReference previousPage = new PageReference('/' + sBaseObjectId);
            previousPage.setRedirect(true);
            
            return previousPage;
        }
        catch(Exception e){
            System.debug('Error:\t'+e.getMessage());
        }
        return null;
    }
    
    /**
     * Method to add error message to the list of error messages.
     */
    public void addErrorMessage(String sErrorMessage) {
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, sErrorMessage));
    }
    
    /**
     * Method to add error message to the list of error messages.
     */
    public void addWarningMessage(String sWarningMessage) {
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, sWarningMessage));
        
    }
    
    /**
     * Method to initialize picklist values for Sales Organization from custom settings.
     */
    public List<SelectOption> getSalesOrganizationList() {
        
        List<SelectOption> listSalesOrganization = new List<SelectOption> ();
        
        try{
            if(processor.getAdditionalLSOOptionsMap() == null || processor.getAdditionalLSOOptionsMap().size() == 0) {
                return listSalesOrganization;
            }
            
            Set<String> setSalesOrganizationValue = new Set<String>();
            
            for(String sKey : processor.getAdditionalLSOOptionsMap().keySet()) {
                setSalesOrganizationValue.add(sKey.split(APTS_CaptureInputForLSODataConstants.VALUE_SEPARATOR)[0]);
            }
            
            for(String sValue : setSalesOrganizationValue) {
                listSalesOrganization.add(new SelectOption(sValue, sValue));
            }
            
            return listSalesOrganization;
       }
        catch(Exception e){
            System.debug('Error:\t'+e.getMessage());
        }
        return null;
    } 
    
    /**
     * Method to initialize picklist values for Distribution Channel from custom settings.
     */
    public List<SelectOption> getDistributionChannelList() {
        
        List<SelectOption> listDistributionChannel = new List<SelectOption> ();
        
        try{
            if(processor.getAdditionalLSOOptionsMap() == null || processor.getAdditionalLSOOptionsMap().size() == 0) {
                return listDistributionChannel;
            }
            
            Set<String> setDistributionChannelValue = new Set<String>();
            
            for(String sKey : processor.getAdditionalLSOOptionsMap().keySet()) {
                setDistributionChannelValue.add(sKey.split(APTS_CaptureInputForLSODataConstants.VALUE_SEPARATOR)[1]);
            }
            
            for(String sValue : setDistributionChannelValue) {
                listDistributionChannel.add(new SelectOption(sValue, sValue));
            }
            
            return listDistributionChannel;
        }
        catch(Exception e){
            System.debug('Error:\t'+e.getMessage());
        }
        return null;
    }
    
    /**
     * Method to initialize picklist values for SAP Division from custom settings.
     */
    public List<SelectOption> getSAPDivisionList() {
        List<SelectOption> listSAPDivision = new List<SelectOption> ();
        
        try{
            if(processor.getAdditionalLSOOptionsMap() == null || processor.getAdditionalLSOOptionsMap().size() == 0) {
                return listSAPDivision;
            }
            
            Set<String> setSAPDivisionValue = new Set<String>();
            
            for(String key : processor.getAdditionalLSOOptionsMap().keySet()) {
                setSAPDivisionValue.add(key.split(APTS_CaptureInputForLSODataConstants.VALUE_SEPARATOR)[2]);
            }
            
            for(String sValue : setSAPDivisionValue) {
                listSAPDivision.add(new SelectOption(sValue, sValue));
            }
            
            return listSAPDivision;
         }
        catch(Exception e){
            System.debug('Error:\t'+e.getMessage());
        }
        return null;
    }
    
    /**
     * Method to show the addition LSO data to select like Incoterms, Payment Terms and Local Channel.
     */
    public List<SelectOption> getAdditionalLSODataList() {
        try{
            List<SelectOption> listAdditionalLSOData = new List<SelectOption> ();
            
            if(processor.getAdditionalLSOOptionsMap() == null || processor.getAdditionalLSOOptionsMap().size() == 0) {
                return listAdditionalLSOData;
            }
            
            Set<String> setAdditionalLSODataValue = null;
            
            if(APTS_CaptureInputForLSODataConstants.OPPORTUNITY.equals(sBaseObject)) {
                for(String sKey : processor.getAdditionalLSOOptionsMap().keySet()) {
                    setAdditionalLSODataValue = processor.getAdditionalLSOOptionsMap().get(sKey);
                }
            } else if(APTS_CaptureInputForLSODataConstants.ACCOUNT.equals(sBaseObject)) {
                String sKey = sSalesOrganization + APTS_CaptureInputForLSODataConstants.VALUE_SEPARATOR
                    + sDistributionChannel + APTS_CaptureInputForLSODataConstants.VALUE_SEPARATOR
                    + sSAPDivision;
                setAdditionalLSODataValue = processor.getAdditionalLSOOptionsMap().get(sKey);
            }
            
            for(String sValue : setAdditionalLSODataValue) {
                String[] listOptionLabelValues = sValue.split(APTS_CaptureInputForLSODataConstants.VALUE_SEPARATOR);
                String sOptionLabel = 'Incoterm : ' + processor.getDescriptionForLSOCode(listOptionLabelValues[1], APTS_CaptureInputForLSODataConstants.INCOTERM)
                    + ' --- Payment Terms : ' + processor.getDescriptionForLSOCode(listOptionLabelValues[2], APTS_CaptureInputForLSODataConstants.PAYMENT_TERM)
                    + ' --- Local Channel : ' + processor.getDescriptionForLSOCode(listOptionLabelValues[3], APTS_CaptureInputForLSODataConstants.LOCAL_CHANNEL);
                
                listAdditionalLSOData.add(new SelectOption(sValue, sOptionLabel)); 
            }
            
            return listAdditionalLSOData;
         }
        catch(Exception e){
            System.debug('Error:\t'+e.getMessage());
        }
        return null;
    }
    
    private void populateMapLSODataList(List<APTS_LP_Local_Customer_Reference_Data__c> lsoDataList){
        
        if(lsoDataList != null && lsoDataList.size()>0){
            mapLSODataList = new map<string,APTS_LP_Local_Customer_Reference_Data__c>();
            for(APTS_LP_Local_Customer_Reference_Data__c lso : lsoDataList)
                mapLSODataList.put(lso.id,lso);
        }
        
    }
    
    private void prepareMapOfWrapperLOD(){
        mapLODWrapList = new map<integer,APTS_WrapperLOD>();
        for(APTS_WrapperLOD owapperLSOLIst:this.lstwapperLSOLIst){
            mapLODWrapList.put(owapperLSOLIst.iRecordId, owapperLSOLIst);
        }
    }
    
    
    public void selectLSO(){
        try{
            String selectLSOId = System.currentPagereference().getParameters().get('lsoid');
            system.debug('<<<< All LOD Records >>>>'+ mapLODWrapList);
            system.debug('<<<< selectLSOId >>>>: '+ selectLSOId);
            String selectedValue = '';
            isLSOForAccount = true;
            if(selectLSOId !=null && selectLSOId !=''){
                //system.debug('<<<< Wrap LOD Records ID >>>>'+ Integer.ValueOf(selectLSOId));
                
                // Get Select LOD record details + JS - 12-Dec-2015
                this.oSelectedWrapperLOD = mapLODWrapList.get(Integer.ValueOf(selectLSOId));
                if(oSelectedWrapperLOD != null){
                    this.oSelectedLOD = oSelectedWrapperLOD.LSOData;
                    
                    selectedValue = selectedValue + oSelectedWrapperLOD.LSOData.APTS_LP_SAP_Customer_ID__c + ' #& ';
                    selectedValue = selectedValue + oSelectedWrapperLOD.LSOData.APTS_LP_Incoterms__c + ' #& ';
                    selectedValue = selectedValue + oSelectedWrapperLOD.LSOData.APTS_Payment_Terms__c + ' #& ';
                    selectedValue = selectedValue + oSelectedWrapperLOD.LSOData.APTS_LP_Local_Channel__c + ' #& ';
                    this.sSalesOffice = oSelectedWrapperLOD.salesOffice;
                    system.debug('<<<< Controller Sales Office >>>>: '+ this.sSalesOffice);
                    sAdditionalLSOData = selectedValue;
                    sDistributionChannel = oSelectedWrapperLOD.LSOData.APTS_LP_Distribution_Channel__c;
                    
                    system.debug('@@ sAdditionalLSOData'+ sAdditionalLSOData);
                    mapDataForProcessor = getDataMapForProcessorClass();
                }
            }
        }
        catch(Exception e){
            System.debug('Error:\t'+e.getMessage());
        }
    }
    
    public void setQuotationForOptions(String sQuotationForOptions) {
        this.sQuotationForOptions = sQuotationForOptions;
    }
    
    public String getQuotationForOptions() {
        return this.sQuotationForOptions;
    }
    
    /**
     * Method to initialize picklist values for Quotation For option list.
     */
     
    private List<SelectOption> FindQuotationForOptionList() {
        
        if(String.isBlank(getQuotationForOptions())) {
            return new List<SelectOption>();
        }
        
        String[] sOptions = getQuotationForOptions().split(APTS_CaptureInputForLSODataConstants.VALUE_SEPARATOR);
        
        List<SelectOption> optionList = new List<SelectOption>();
        for(String option : sOptions) {
            optionList.add(new SelectOption(option, option));
        }
        sQuotationFor = optionList[0].getValue();
        // Set Account information on Page.
        system.debug(' Jig- quotation for: '+ sQuotationFor);
        
        
        return optionList;
    }
    
    // When customer change Quotation For picklist value
    public void validateLSO(){
        system.debug('sQuotationFor ===>'+sQuotationFor);
    }
    
    public void setAccountDetails(){
        
        try{
            System.debug('<<<< Find Account - 0 >>>> ' + sBaseObject);  
            if(sBaseObject != null && sBaseObject.toLowerCase().equals('account')){
                this.oAccountSO = [SELECT Id, Name FROM Account WHERE Id = :sBaseObjectId LIMIT 1];
            }else if(sBaseObject != null && sBaseObject.equals(APTS_CaptureInputForLSODataConstants.OPPORTUNITY)){
                opportunity oppty = [SELECT Id, Account.Name, AccountId, Account_End_User__c, Account_End_User__r.Name
                                        FROM opportunity
                                        WHERE Id = :sBaseObjectId
                                        LIMIT 1
                                    ];
                System.debug('<<<< Find Account >>>> ' + sQuotationFor);                
                List<OpportunityPartner> lstPartners = [SELECT Id, AccountToId from OpportunityPartner where OpportunityId = :oppty.Id and IsPrimary = true];
                
                if(String.isEmpty(sQuotationFor)){
                    sQuotationFor = 'Account Customer';
                }
                
                if(sQuotationFor.equals('Account Customer')){
                    System.debug('<<<<  Account Cus >>>> '+ (Account)oppty.getSObject('Account'));
                    this.oAccountSO = (Account)oppty.getSObject('Account');
                    this.sAccountCusForOppty = this.oAccountSO.Id;
                    
                    system.debug('<<<< Unknown Name >>>>: '+ this.oAccountSO.Name);
                    if(this.oAccountSO.Name.equals('Unknown ES')){
                        this.addErrorMessage('You can not create Agreement from Unlnown ES Account.');
                    }
                }
                if(sQuotationFor.equals('Account End User')){
                    this.oAccountSO = (Account)oppty.getSObject('Account_End_User__r');
                    System.debug('<<<<  Account End >>>> '+ this.oAccountSO );
                }
                if(sQuotationFor.equals('Primary Partner')){
                    //this.oAccountSO = (Account)lstPartners[0].getSObject('AccountToId');
                    Account oAccount = [SELECT Id, Name FROM Account WHERE Id =: lstPartners[0].AccountToId LIMIT 1];
                    this.oAccountSO = oAccount;
                    System.debug('<<<<  Pri Cus >>>> '+ this.oAccountSO );
                }
                
                
            }else{
                //todo: throw an error
            }
            
            if(this.oAccountSO !=null){
                
                sBaseObjectName = this.oAccountSO.Name;
                sBaseAccountObjectId = this.oAccountSO.id;
            }
            
        }
        catch(Exception e){
            System.debug('Error:\t'+e.getMessage());
        }
    }
    
    /*
        @Description: Refresh LRD & LOD data when changed in Quotation For
        @Owner: Jignesh Shekhaliya
    */
    public void onChangeQuotationFor(){
        
        try{
            system.debug('Called Method from Dropdown.>>>>' + sQuotationFor);
            
            // Clear LOD Selection
            this.oSelectedLOD = null;
            sAdditionalLSOData = '';
            mapDataForProcessor = getDataMapForProcessorClass();
            
            // Set Account information on Page.
            setAccountDetails();
            
            // Begin to fetch LSO data and execute further process
            processor.beginToProcessData(getDataMapForProcessorClass());
            lsoDataList = processor.listLODData;
            //lsoDataList = findApttusLSODataList();
            populateMapLSODataList(lsoDataList);
            this.lstwapperLSOLIst = processor.listWrapperLOD;
            prepareMapOfWrapperLOD();
            //prepareWrapperForLSOList(lsoDataList);
        }
        catch(Exception e){
            System.debug('Error:\t'+e.getMessage());
        }
    }
    
    
    
    
}