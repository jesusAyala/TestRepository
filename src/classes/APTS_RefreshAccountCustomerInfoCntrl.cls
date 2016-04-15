/*************************************************************
@Name: APTS_RefreshAccountCustomerInfoCntrl
@Author: Niket Chandane
@CreateDate: 
@Description: Class to read URL parameters and "RefreshAccountCustomerInfo Information" on Quote.
@UsedBy: Page - APTS_RefreshAccountCustomerInfo
*************************************************************
@Modified By: Niket Chandane
@Modified Date: 23/12/2015 
@Description: Added method updateQuoteAndCreateAgreement
******************************************************************/
public with sharing class APTS_RefreshAccountCustomerInfoCntrl {

    private static final String USE_ADVANCED_APPROVAL = 'useAdvancedApproval';
    private static final String ID = 'Id';
    private static final String FLOW = 'flow';
    
    // Parameters for value selection on page
    public String sGUIDId {get; set;}
    public String sBaseObject {get; set;}
    public String sAccountName {get; set;}
    public String sAccountRecType {get; set;}
    public String srecordID {get; set;}
    public String sQuotationAccountType {get;set;}
    
    // User based parameters
    public String sUserCountry {get; set;}
    public String sUserCountryCode {get; set;}
    public String sUserDivision {get; set;}
    public String sDefaultLBU {get; set;}
    public String sDefaultLSO {get; set;}
    public String sLocale {get; set;}
    public Map<String, String> mapDataForProcessor;
    public String saccountId {get; set;}
    public string selectedLODId{get;set;}
    
    public Boolean bIsUnknownAccount {get; set;}
    public Apttus_Proposal__Proposal__c quote {get; set;} 
    public List<APTS_LP_Local_Customer_Reference_Data__c> lODDataList {get; set;}
    public Boolean bIsUpdatable{get;set;}
    
    //Variable to identify if account is non buying account
    public Boolean isNonBuyingAccount {get;set;}
    private String  paramCopyWith ;
    
    public Apttus__APTS_Agreement__c agreement  {get;set;} 
    public Boolean isForQuotation               {get;set;}
    public Boolean isForAgreement               {get;set;}
    
    private Map<Id,APTS_LP_Local_Customer_Reference_Data__c> maplODData{
        get{
                if(maplODData == null)
                    maplODData = new Map<Id,APTS_LP_Local_Customer_Reference_Data__c>();
                return maplODData;
        }set;
    }
    
    private Map<Integer,APTS_WrapperLOD> mapWrapperLODData{
        get{
                if(mapWrapperLODData == null)
                    mapWrapperLODData = new Map<Integer,APTS_WrapperLOD>();
                return mapWrapperLODData;
        }set;
    }
    
    public List<LODWrapperInfo> lstLODWrapperInfo{
        get{
            if(lstLODWrapperInfo == null)
                lstLODWrapperInfo = new List<LODWrapperInfo>();
            return lstLODWrapperInfo;   
        }set;
    }
    
    public List<APTS_WrapperLOD> listUniqWrapperLOD{
        get{
            if(listUniqWrapperLOD == null)
                listUniqWrapperLOD = new List<APTS_WrapperLOD>();
            return listUniqWrapperLOD;   
        }set;
    }
    
    private APTS_RefreshAccountCustomerProcessor processor = new APTS_RefreshAccountCustomerProcessor(this);
    
    /**
     * Method to be executed on page loading to read URL parameters.
     */ 
    public PageReference onPageLoad() {
        
        // Read URL Parameters
        sGUIDId = ApexPages.currentPage().getParameters().get('GUID');
        sBaseObject = ApexPages.currentPage().getParameters().get('baseObject');
        sAccountName = ApexPages.currentPage().getParameters().get('name');
        sAccountRecType = ApexPages.currentPage().getParameters().get('typeId');
        srecordId = ApexPages.currentPage().getParameters().get('Id');
        //Start: Added by Shahid on 24/12/2015 new params for non buying flow
        sQuotationAccountType   = ApexPages.currentPage().getParameters().get(APTS_Constants.PARAM_ACCOUNT_TYPE);
        paramCopyWith           = ApexPages.currentPage().getParameters().get(APTS_Constants.PARAM_COPY_LINEITEMS_WITH);
        //END
        bIsUpdatable = false;
        isNonBuyingAccount = false;    
        isForQuotation = false;
        isForAgreement = false;
        //check if account is unkown  
        //bIsUnknownAccount = validateUnknownAccount();
        
        // Get the quote information 
        if(String.isNotBlank(sBaseObject)){
            if(sBaseObject.equals(APTS_Constants.SOBJECT_TYPE_QUOTE)){
                quote = getQuoteById(srecordId);
                isForQuotation = true;
            }else if(sBaseObject.equals(APTS_Constants.SOBJECT_TYPE_AGREEMENT)){
                isForAgreement = true;
                agreement = getAgreementById(srecordId);
            }
        }
        
        
        if(quote != null) {
            // Set Quotation For value
            quote.APTS_Account_Type__c = (quote.APTS_Quotation_Account_Type__c != null && quote.APTS_Quotation_Account_Type__c != '') 
                    ? quote.APTS_Quotation_Account_Type__c : quote.APTS_Account_Type__c; 
                    
            saccountId = quote.APTS_LP_AccountCustomer__c;
        }else if(agreement != null){
            saccountId = agreement.APTS_LP_AccountCustomer__c;
        }
        
        //Check if the page if called by a quote from non buying account
        isNonBuyingAccount = String.isNotBlank(sQuotationAccountType) && (sQuotationAccountType.equalsignorecase(Label.ATPS_Primary_Partner) || sQuotationAccountType.equalsignorecase(Label.APTS_Account_End_User));
        
        //fetch user details 
        fetchAndSetLoggedInUserDetails();
        
        // get record Type name from Type Id
        sAccountRecType = getTypeById(sAccountRecType);
        
        // Fetching LOD
        lODDataList = fetchlODDataList();
        
        if(lODDataList.isEmpty()) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'No Load Available. Please create one and try again.'));    
        }else {
            bIsUpdatable = true;
            maplODData.putAll(lODDataList);
            for(APTS_WrapperLOD wrapper :listUniqWrapperLOD)
                mapWrapperLODData.put(wrapper.iRecordId,wrapper);
            // Setting values on wrapper information
            lstLODWrapperInfo = assignLODWrapperInfo(lODDataList);
        }
        
        return null;
    }
    
    private List<LODWrapperInfo> assignLODWrapperInfo(List<APTS_LP_Local_Customer_Reference_Data__c> lODDataList){
        
        List<LODWrapperInfo> lstLODWrapperInfo = new List<LODWrapperInfo>();
        
        for(APTS_LP_Local_Customer_Reference_Data__c objLOD : lODDataList){
            
            LODWrapperInfo objLODWrapperInfo = new LODWrapperInfo();
            objLODWrapperInfo.Lod = objLOD;
            objLODWrapperInfo.bIsSelected = (lODDataList.size() == 1) ? true : false;
            Integer sizeOfList = lODDataList.size();
            selectedLODId   = (lODDataList.size() >= 1) ? lODDataList[sizeOfList-1].Id : '';
            
            objLODWrapperInfo.descIncoterm  = processor.getMasterPickListCodeDesc(objLOD.APTS_LP_Incoterms__c, APTS_CaptureInputForLSODataConstants.INCOTERM);
            objLODWrapperInfo.descPaymentTerm  = processor.getMasterPickListCodeDesc(objLOD.APTS_Payment_Terms__c, APTS_CaptureInputForLSODataConstants.PAYMENT_TERM);
            objLODWrapperInfo.descLocalChannel  = processor.getMasterPickListCodeDesc(objLOD.APTS_LP_Local_Channel__c, APTS_CaptureInputForLSODataConstants.LOCAL_CHANNEL);
            lstLODWrapperInfo.add(objLODWrapperInfo);
        }
        
        if(listUniqWrapperLOD != null && listUniqWrapperLOD.size()>0){
            
            listUniqWrapperLOD[listUniqWrapperLOD.size()-1].bIsSelected = true;
            String iRecordId = String.valueOf(listUniqWrapperLOD[0].iRecordId);
            selectedLODId   = (listUniqWrapperLOD.size() >= 1) ?  iRecordId : '';
            
        
        }
        return lstLODWrapperInfo;
    }
    
    /**
     * Method fetch the LOD data from Account and user data
     */
    private List<APTS_LP_Local_Customer_Reference_Data__c> fetchlODDataList(){
        
        // Begin to fetch LSO data and execute further process
        return processor.processDatatoSearchLOD(getDataMapForProcessorClass());
    }
    
    
    /**
     * Method to check unknow Account
     */
    private Boolean validateUnknownAccount() {
        return (APTS_CaptureInputForLSODataConstants.UNKNOWN_ES.equalsignorecase(sAccountName)) ? true : false;
    }
    
    
    /**
     * Method to get Quote information from quote Id
     */
    private Apttus_Proposal__Proposal__c getQuoteById(String strQuoteId) {
        Apttus_Proposal__Proposal__c objQuote;
        
        try{
            
            objQuote = [Select 
                            id ,
                            APTS_LP_AccountCustomer__c,
                            APTS_Distribution_Channel__c ,
                            APTS_LP_Sales_Organization__c,
                            APTS_Incoterms__c,
                            APTS_Payment_Terms__c,
                            APTS_Local_Channel__c,
                            APTS_Account_Type__c,
                            APTS_LP_Account_End_User__c,
                            APTS_Account_End_User__c,
                            APTS_Sales_Office_LP__c,
                            APTS_Quotation_Account_Type__c,
                            Apttus_Proposal__Approval_Stage__c 
                                                // Added by chetan patel
                      from Apttus_Proposal__Proposal__c where Id =:strQuoteId];
        
        }catch (Exception ex) {
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'unable to find the quote.Please contact Administrator.'));
        }
        return objQuote;
    }
    
    /**
    * Method to get Agremeent information from agremeentyea Id
    */
    private Apttus__APTS_Agreement__c getAgreementById(String strAgreementID) {
        Apttus__APTS_Agreement__c objAgreement;
        
        try{
            
            objAgreement = [Select 
                            id ,
                            APTS_LP_AccountCustomer__c,
                            APTS_Distribution_Channel__c ,
                            APTS_LP_Sales_Organization__c,
                            APTS_Incoterms__c,
                            APTS_Payment_Terms__c,
                            APTS_Local_Channel__c,
                            APTS_LP_Account_End_User__c,
                            APTS_Account_End_User__c,
                            APTS_Sales_Office_LP__c,
                            Apttus_Approval__Approval_Status__c,
                            Apttus__Status__c,
                            Apttus__Status_Category__c
                            from Apttus__APTS_Agreement__c where Id =:strAgreementID];
        
        }catch (Exception ex) {
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Unable to find the Agreement. Please contact Administrator.'));
        }
        return objAgreement;
    }
    
    
    /**
     * Method to Set record Type name by Id
     */
    private String getTypeById(String strRecId){
        return Schema.SObjectType.Account.getRecordTypeInfosById().get(strRecId).getName();
    } 
    
    /**
     * Method to fetch and Set the logged in user details.
     */
    private void fetchAndSetLoggedInUserDetails() {
        
        User oLoggedInUser = null;
        
        // Fetching user details
        try {
            oLoggedInUser = [SELECT Default_BU__c,Default_LSO__c,APTS_Locale__c,Country, CountryCode, Division_DIV__c FROM User WHERE id = :UserInfo.getUserId()];
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Error generated while fetching logged in user. Please try after some time.'));
        }
        
        // Setting user details.
        if(oLoggedInUser != null) {
            sUserCountry = oLoggedInUser.Country;
            sUserCountryCode = oLoggedInUser.CountryCode;
            sUserDivision = oLoggedInUser.Division_DIV__c;
            sDefaultLBU = oLoggedInUser.Default_BU__c;
            sDefaultLSO = oLoggedInUser.Default_LSO__c;
            sLocale     = oLoggedInUser.APTS_Locale__c;
        }
    }
    
    /**
     * Method to get the data map to pass the parameters to processor class.
     */
    private Map<String, String> getDataMapForProcessorClass() {
        
        
        mapDataForProcessor = new Map<String, String>();
        
        mapDataForProcessor.put('guid', sGUIDId);
        mapDataForProcessor.put('baseObject', sBaseObject);
        mapDataForProcessor.put('name', sAccountName);
        if(sBaseObject.equals(APTS_Constants.SOBJECT_TYPE_QUOTE)){
            mapDataForProcessor.put('quoteId', srecordId);
        }else if(sBaseObject.equals(APTS_Constants.SOBJECT_TYPE_AGREEMENT)){
            mapDataForProcessor.put('agreementId', srecordId);
        }
        mapDataForProcessor.put('defaultLBU', sdefaultLBU);
        mapDataForProcessor.put('defaultLSO', sdefaultLSO);
        mapDataForProcessor.put('locale', slocale);
        mapDataForProcessor.put('accountId', saccountId);
        
        return mapDataForProcessor;
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
     * Method to add error message to the list of error messages.
     */
     public class LODWrapperInfo{
        public Boolean bIsSelected {get; set;}
        public APTS_LP_Local_Customer_Reference_Data__c Lod {get; set;}
        public String descIncoterm {get; set;}
        public String descPaymentTerm {get; set;}
        public String descLocalChannel {get; set;}
     }
     
     /**
        Method update LOD data on Quote record
     */
     public PageReference updateAgreement() {
        PageReference agreementPage = null;
        try{
            
            if(agreement != null && ((selectedLODId != null && mapWrapperLODData.get(Integer.valueOf(selectedLODId)) != null) || (lODDataList.size() == 1))){
                // added by Rangan 
                // When Quote is refreshed and it’s in one of the status’s of Approved/Recalled/Generated/Presented, the status should go back to Draft post 
                // before the quotation fields are updated, to make it Editable.
                /*if( quote.Apttus_Proposal__Approval_Stage__c  =='Approved' ||
                    quote.Apttus_Proposal__Approval_Stage__c =='Recalled'  ||
                    quote.Apttus_Proposal__Approval_Stage__c =='Generated' ||
                    quote.Apttus_Proposal__Approval_Stage__c =='Presented' ){
                        
                        quote.Apttus_Proposal__Approval_Stage__c = 'Draft';
                }
                
                quote.Apttus_QPApprov__Approval_Status__c = 'Not Submitted';
                //Update quote
                update quote;*/
                
                APTS_LP_Local_Customer_Reference_Data__c lODData = mapWrapperLODData.get(Integer.valueOf(selectedLODId)).LSOData;
                APTS_WrapperLOD selectedWrapperLOD = mapWrapperLODData.get(Integer.valueOf(selectedLODId));
                system.debug(selectedLODId+'========lODData ==>'+lODData+'=============='+lODDataList);
                
                //set the quote account and quottion for
                agreement.Apttus__Account__c = lODData.APTS_LP_Account__c;
                agreement.APTS_LP_AccountCustomer__c = lODData.APTS_LP_Account__c;
                //agreement.APTS_Quotation_Account_Type__c = APTS_CaptureInputForLSODataConstants.ACCOUNT_CUSTOMER;
                agreement.Name = 'MSPA_' + sAccountName;
                update agreement;
                
                agreement.APTS_SAP_Customer_ID__c     = lODData.APTS_LP_SAP_Customer_ID__c;
                agreement.APTS_Distribution_Channel__c = selectedWrapperLOD.sDistributionChannelId;     //processor.getCodeDescriptionIdForLSOCode(lODData.APTS_LP_Distribution_Channel__c, APTS_CaptureInputForLSODataConstants.DISTRIBUTION_CHANNEL);
                agreement.APTS_LP_Sales_Organization__c = lODData.APTS_LP_Sales_Organisation__c;
                agreement.APTS_Payment_Terms__c =   selectedWrapperLOD.sPaymentTermId;   //processor.getCodeDescriptionIdForLSOCode(lODData.APTS_Payment_Terms__c, APTS_CaptureInputForLSODataConstants.PAYMENT_TERM);
                //quote.APTS_Incoterms__c =     processor.getCodeDescriptionIdForLSOCode(lODData.APTS_LP_Incoterms__c, APTS_CaptureInputForLSODataConstants.INCOTERM);
                agreement.APTS_Local_Channel__c =   selectedWrapperLOD.sLocalChannelId;    //processor.getCodeDescriptionIdForLSOCode(lODData.APTS_LP_Local_Channel__c, APTS_CaptureInputForLSODataConstants.LOCAL_CHANNEL);
                
                agreement.APTS_Incoterms__c = selectedWrapperLOD.sIncotermId;  //processor.getCodeDescriptionIdForLSOCode(lODData.APTS_LP_Incoterms__c, APTS_CaptureInputForLSODataConstants.INCOTERM);
                
                system.debug('<<<< Sales Office From Controller >>>>'+ selectedWrapperLOD.salesOffice);
                if(!String.isEmpty(selectedWrapperLOD.salesOffice)){
                    User oCurrentUser = [select Sales_Territory_Name__c,LocaleSidKey, Country from User where id=:UserInfo.getUserId()];
                    
                    String sSalesOfficeId = APTS_LP_CommonUtil.getSalesOfficeExistInLSOFields(selectedWrapperLOD.salesOffice,oCurrentUser.Country);
                    
                    system.debug('@@ salesOfficeId: '+ sSalesOfficeId);
                    agreement.APTS_Sales_Office__c = sSalesOfficeId;
                    
                    // Set Sales Office details from Master PickList Table
                    APTS_Master_Picklist_Table__c oMPLSalesOffice = APTS_LP_CommonUtil.getMPLSalesOffice(selectedWrapperLOD.salesOffice,oCurrentUser.Country);
                    if(oMPLSalesOffice != null){
                        agreement.APTS_Sales_Office_LP__c = oMPLSalesOffice.Id;
                    }
                }
                
                
                //Update quote
                update agreement;

                // Create Activity History for Refresh Log
                createTask(Label.APTS_Refresh_Agreement_Sub, Label.APTS_Refresh_Agreement_Summary,agreement.Id);
                agreementPage = Page.Apttus_CMConfig__AgreementConfiguration;
                agreementPage.getParameters().put(ID, agreement.Id);
                agreementPage.getParameters().put(FLOW, APTS_CaptureInputForLSODataConstants.LP_SPAIN);
                agreementPage.getParameters().put(USE_ADVANCED_APPROVAL, 'true');
                agreementPage.setRedirect(true);
            }
        }catch(exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Error generated while updating Agreement.\n'+ex.getMessage()));
            return agreementPage;
        }
        return agreementPage;
     }
     
     /**
        Method update LOD data on Quote record
     */
     public PageReference updateQuote() {
        PageReference quotePage = null;
        try{
            
            if(quote != null && ((selectedLODId != null && mapWrapperLODData.get(Integer.valueOf(selectedLODId)) != null) || (lODDataList.size() == 1))){
                // added by Rangan 
                // When Quote is refreshed and it’s in one of the status’s of Approved/Recalled/Generated/Presented, the status should go back to Draft post 
                // before the quotation fields are updated, to make it Editable.
                if( quote.Apttus_Proposal__Approval_Stage__c  =='Approved' ||
                    quote.Apttus_Proposal__Approval_Stage__c =='Recalled'  ||
                    quote.Apttus_Proposal__Approval_Stage__c =='Generated' ||
                    quote.Apttus_Proposal__Approval_Stage__c =='Presented' ){
                        
                        quote.Apttus_Proposal__Approval_Stage__c = 'Draft';
                }
                
                quote.Apttus_QPApprov__Approval_Status__c = 'Not Submitted';
                //Update quote
                update quote;
                
                APTS_LP_Local_Customer_Reference_Data__c lODData = mapWrapperLODData.get(Integer.valueOf(selectedLODId)).LSOData;
                APTS_WrapperLOD selectedWrapperLOD = mapWrapperLODData.get(Integer.valueOf(selectedLODId));
                system.debug(selectedLODId+'========lODData ==>'+lODData+'=============='+lODDataList);
                
                //set the quote account and quottion for
                quote.Apttus_Proposal__Account__c = lODData.APTS_LP_Account__c;
                quote.APTS_LP_AccountCustomer__c = lODData.APTS_LP_Account__c;
                quote.APTS_Quotation_Account_Type__c = APTS_CaptureInputForLSODataConstants.ACCOUNT_CUSTOMER;
                quote.Apttus_Proposal__Proposal_Name__c = 'Quotation - ' + sAccountName;
                update quote;
                
                quote.APTS_SAP_Customer_ID__c     = lODData.APTS_LP_SAP_Customer_ID__c;
                quote.APTS_Distribution_Channel__c = selectedWrapperLOD.sDistributionChannelId;     //processor.getCodeDescriptionIdForLSOCode(lODData.APTS_LP_Distribution_Channel__c, APTS_CaptureInputForLSODataConstants.DISTRIBUTION_CHANNEL);
                quote.APTS_LP_Sales_Organization__c = lODData.APTS_LP_Sales_Organisation__c;
                quote.APTS_Payment_Terms__c =   selectedWrapperLOD.sPaymentTermId;   //processor.getCodeDescriptionIdForLSOCode(lODData.APTS_Payment_Terms__c, APTS_CaptureInputForLSODataConstants.PAYMENT_TERM);
                //quote.APTS_Incoterms__c =     processor.getCodeDescriptionIdForLSOCode(lODData.APTS_LP_Incoterms__c, APTS_CaptureInputForLSODataConstants.INCOTERM);
                quote.APTS_Local_Channel__c =   selectedWrapperLOD.sLocalChannelId;    //processor.getCodeDescriptionIdForLSOCode(lODData.APTS_LP_Local_Channel__c, APTS_CaptureInputForLSODataConstants.LOCAL_CHANNEL);
                
                quote.APTS_Incoterms__c = selectedWrapperLOD.sIncotermId;  //processor.getCodeDescriptionIdForLSOCode(lODData.APTS_LP_Incoterms__c, APTS_CaptureInputForLSODataConstants.INCOTERM);
                
                system.debug('<<<< Sales Office From Controller >>>>'+ selectedWrapperLOD.salesOffice);
                if(!String.isEmpty(selectedWrapperLOD.salesOffice)){
                    User oCurrentUser = [select Sales_Territory_Name__c,LocaleSidKey, Country from User where id=:UserInfo.getUserId()];
                    
                    String sSalesOfficeId = APTS_LP_CommonUtil.getSalesOfficeExistInLSOFields(selectedWrapperLOD.salesOffice,oCurrentUser.Country);
                    
                    system.debug('@@ salesOfficeId: '+ sSalesOfficeId);
                    quote.APTS_Sales_Office__c = sSalesOfficeId;
                    
                    // Set Sales Office details from Master PickList Table
                    APTS_Master_Picklist_Table__c oMPLSalesOffice = APTS_LP_CommonUtil.getMPLSalesOffice(selectedWrapperLOD.salesOffice,oCurrentUser.Country);
                    if(oMPLSalesOffice != null){
                        quote.APTS_Sales_Office_LP__c = oMPLSalesOffice.Id;
                    }
                }
                
                
                //Update quote
                update quote;
                
                quote.APTS_Manually_Edited__c = FALSE;
                update quote;
                
                // Create Activity History for Refresh Log - JS+ 02-Dec-2015
                createTask(Label.APTS_Refresh_Quote_Sub, Label.APTS_Refresh_Quote_Summary,quote.Id);
                
                quotePage = Page.Apttus_QPConfig__ProposalConfiguration;
                quotePage.getParameters().put(ID, quote.Id);
                quotePage.getParameters().put(FLOW, APTS_CaptureInputForLSODataConstants.LP_SPAIN);
                quotePage.getParameters().put(USE_ADVANCED_APPROVAL, 'true');
                quotePage.setRedirect(true);
            }
        }catch(exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Error generated while updating Quotation.\n'+ex.getMessage()));
            return quotePage;
        }
        return quotePage;
     }
     
     /**
        Method update LOD data on Quote record and redirect to quotation page
        Added by: Shahid Ali 23-12-2015
     **/
     public PageReference updateQuoteAndCreateAgreement() {
        PageReference agreementPage = null;
        try{
            
            if((selectedLODId != null && mapWrapperLODData.get(Integer.valueOf(selectedLODId)) != null) || (lODDataList.size() == 1)){
                // added by Rangan 
                // When Quote is refreshed and it’s in one of the status’s of Approved/Recalled/Generated/Presented, the status should go back to Draft post 
                // before the quotation fields are updated, to make it Editable.
                /*if( quote.Apttus_Proposal__Approval_Stage__c  =='Approved' ||
                    quote.Apttus_Proposal__Approval_Stage__c =='Recalled'  ||
                    quote.Apttus_Proposal__Approval_Stage__c =='Generated' ||
                    quote.Apttus_Proposal__Approval_Stage__c =='Presented' ){
                        
                        quote.Apttus_Proposal__Approval_Stage__c = 'Draft';
                }
                
                quote.Apttus_QPApprov__Approval_Status__c = 'Not Submitted';

                update quote;
                */
                
                /* Commenting as a part of change suggested by functional team as we might not need to update LOD data on quotation when we create an
                  from non buying quotation 
                  Uncomment this piece to activate again
                  *******************************************************************************************************************************
                APTS_LP_Local_Customer_Reference_Data__c lODData = mapWrapperLODData.get(Integer.valueOf(selectedLODId)).LSOData;
                APTS_WrapperLOD selectedWrapperLOD = mapWrapperLODData.get(Integer.valueOf(selectedLODId));
                system.debug(selectedLODId+'========lODData ==>'+lODData+'=============='+lODDataList);
                
                //set the quote account and quottion for
                quote.Apttus_Proposal__Account__c = lODData.APTS_LP_Account__c;
                quote.APTS_LP_AccountCustomer__c = lODData.APTS_LP_Account__c;
                quote.APTS_Quotation_Account_Type__c = APTS_CaptureInputForLSODataConstants.ACCOUNT_CUSTOMER;
                update quote;
                
                quote.APTS_SAP_Customer_ID__c     = lODData.APTS_LP_SAP_Customer_ID__c;
                quote.APTS_Distribution_Channel__c = selectedWrapperLOD.sDistributionChannelId;     //processor.getCodeDescriptionIdForLSOCode(lODData.APTS_LP_Distribution_Channel__c, APTS_CaptureInputForLSODataConstants.DISTRIBUTION_CHANNEL);
                quote.APTS_LP_Sales_Organization__c = lODData.APTS_LP_Sales_Organisation__c;
                quote.APTS_Payment_Terms__c =   selectedWrapperLOD.sPaymentTermId;   //processor.getCodeDescriptionIdForLSOCode(lODData.APTS_Payment_Terms__c, APTS_CaptureInputForLSODataConstants.PAYMENT_TERM);
                //quote.APTS_Incoterms__c =     processor.getCodeDescriptionIdForLSOCode(lODData.APTS_LP_Incoterms__c, APTS_CaptureInputForLSODataConstants.INCOTERM);
                quote.APTS_Local_Channel__c =   selectedWrapperLOD.sLocalChannelId;    //processor.getCodeDescriptionIdForLSOCode(lODData.APTS_LP_Local_Channel__c, APTS_CaptureInputForLSODataConstants.LOCAL_CHANNEL);
                
                quote.APTS_Incoterms__c = selectedWrapperLOD.sIncotermId;  //processor.getCodeDescriptionIdForLSOCode(lODData.APTS_LP_Incoterms__c, APTS_CaptureInputForLSODataConstants.INCOTERM);
                //Update quote
                update quote;
                
                quote.APTS_Manually_Edited__c = FALSE;
                //Update quote
                update quote; 
                */
                
                
                //Set temporary object fields to be populated on agreement
                APTS_LP_Local_Customer_Reference_Data__c lODData = mapWrapperLODData.get(Integer.valueOf(selectedLODId)).LSOData;
                APTS_WrapperLOD selectedWrapperLOD = mapWrapperLODData.get(Integer.valueOf(selectedLODId));
                
                APTS_Quotation_Refreshed_LOD_Temp__c tempLODRec = new APTS_Quotation_Refreshed_LOD_Temp__c();
                tempLODRec.APTS_Quotation_ID__c                 = quote.Id;
                tempLODRec.APTS_Account__c                      = lODData.APTS_LP_Account__c;
                //tempLODRec.APTS_Account_End_User__c             = quote.APTS_Account_End_User__c;
                System.Debug('## sQuotationAccountType: '+sQuotationAccountType);
                if(String.isNotBlank(sQuotationAccountType)){
                    System.Debug('## Inside: '+sQuotationAccountType);
                    System.Debug('## Inside Account: '+quote.APTS_LP_Account_End_User__c);
                    if(sQuotationAccountType.equalsignorecase(Label.ATPS_Primary_Partner)){
                        tempLODRec.APTS_Primary_Partner_Account__c = quote.APTS_LP_Account_End_User__c;
                    }else if(sQuotationAccountType.equalsignorecase(Label.APTS_Account_End_User)){
                        tempLODRec.APTS_Account_End_User__c  = quote.APTS_Account_End_User__c;
                    }
                }
                tempLODRec.APTS_Distribution_Channel__c         = selectedWrapperLOD.sDistributionChannelId;
                //tempLODRec.APTS_Incoterms__c                  = processor.getCodeDescriptionIdForLSOCode(lODData.APTS_LP_Incoterms__c, APTS_CaptureInputForLSODataConstants.INCOTERM);
                tempLODRec.APTS_Local_Channel__c                = selectedWrapperLOD.sLocalChannelId;
                tempLODRec.APTS_Payment_Terms__c                = selectedWrapperLOD.sPaymentTermId; 
                //tempLODRec.APTS_Primary_Partner_Account__c      = quote.APTS_LP_Account_End_User__c;
                tempLODRec.APTS_LP_Sales_Organization__c        = lODData.APTS_LP_Sales_Organisation__c;
                tempLODRec.APTS_SAP_Customer_ID__c              = lODData.APTS_LP_SAP_Customer_ID__c;
                tempLODRec.APTS_Incoterms__c                     = selectedWrapperLOD.sIncotermId;
                
                //Populate sales office fields
                if(!String.isEmpty(selectedWrapperLOD.salesOffice)){
                    User oCurrentUser = [select Sales_Territory_Name__c,LocaleSidKey, Country from User where id=:UserInfo.getUserId()];
                    
                    String sSalesOfficeId = APTS_LP_CommonUtil.getSalesOfficeExistInLSOFields(selectedWrapperLOD.salesOffice,oCurrentUser.Country);
                    tempLODRec.APTS_Sales_Office__c = sSalesOfficeId;
                    
                    // Set Sales Office details from Master PickList Table
                    APTS_Master_Picklist_Table__c oMPLSalesOffice = APTS_LP_CommonUtil.getMPLSalesOffice(selectedWrapperLOD.salesOffice,oCurrentUser.Country);
                    if(oMPLSalesOffice != null){
                        tempLODRec.APTS_Sales_Office_LP__c = oMPLSalesOffice.Id;
                    }
                }
                
                //Insert temp obj
                try{
                    insert tempLODRec;
                }catch(Exception ex){
                    
                }
                
                //// Create Activity History for Refresh Log
                createTask(Label.APTS_Refresh_Quote_Sub, Label.APTS_Refresh_Quote_Summary,quote.Id);
                
                if(String.isNotBlank(paramCopyWith)){
                    agreementPage = Page.APTS_MSPAWithoutChangesPage;
                    agreementPage.getParameters().put(id, quote.Id);
                    if(paramCopyWith.equals(Label.APTS_With_Changes)){
                        agreementPage.getParameters().put(APTS_Constants.PARAM_FLAG, APTS_Constants.PARAM_VAL_FALSE);
                    }//else If(paramCopyWith.equals(Label.APTS_Without_Changes)){
                        //agreementPage.getParameters().put(APTS_Constants.PARAM_FLAG, APTS_Constants.PARAM_VAL_TRUE);
                    //}
                    agreementPage.getParameters().put(APTS_Constants.PARAM_FLAG, quote.Id);
                }else{
                    agreementPage = Page.Apttus_Proposal__ProposalAgreementCreate;
                    agreementPage.getParameters().put(id, quote.Id);
                }
                //Update flag on Quotatition that the MSPA has been created.
                System.Debug('## Outside update: '+quote.APTS_Is_MSPA_Created_Non_Buying_Qoute__c);
                if(quote != null){
                    // When Quote is refreshed and it’s in one of the status’s of Approved/Recalled/Generated/Presented, the status should go back to Draft post 
                    // before the quotation fields are updated, to make it Editable.
                    String prevApprovalStatus = quote.Apttus_QPApprov__Approval_Status__c;
                    String prevApprovalStage = quote.Apttus_Proposal__Approval_Stage__c;
                    if( quote.Apttus_Proposal__Approval_Stage__c  =='Approved' ||
                        quote.Apttus_Proposal__Approval_Stage__c =='Recalled'  ||
                        quote.Apttus_Proposal__Approval_Stage__c =='Generated' ||
                        quote.Apttus_Proposal__Approval_Stage__c =='Presented' ){
                            
                            quote.Apttus_Proposal__Approval_Stage__c = 'Draft';
                    }
                    
                    quote.Apttus_QPApprov__Approval_Status__c = 'Not Submitted';
                    //Update quote
                    try{
                        APTS_ProcessorControl.isByPassTriggerOnDML = true;
                        update quote;
                        System.Debug('## sucess update: '+quote.Apttus_Proposal__Approval_Stage__c);
                    }catch(Exception ex){
                        System.Debug('## error update 1: '+quote.APTS_Is_MSPA_Created_Non_Buying_Qoute__c);
                    }
                    
                    quote.APTS_Is_MSPA_Created_Non_Buying_Qoute__c  = true;
                    quote.Apttus_Proposal__Approval_Stage__c        = prevApprovalStage;
                    quote.Apttus_QPApprov__Approval_Status__c       = prevApprovalStatus;
                    try{
                        APTS_ProcessorControl.isByPassTriggerOnDML = true;
                        update quote;
                        System.Debug('## after update: '+quote.APTS_Is_MSPA_Created_Non_Buying_Qoute__c);
                    }Catch(Exception ex){
                        System.Debug('## error update: '+quote.APTS_Is_MSPA_Created_Non_Buying_Qoute__c);
                    }
                }
                
                agreementPage.setRedirect(true);
            }
        }catch(exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Error generated while updating Quotation.\n'+ex.getMessage()));
            return agreementPage;
        }
        return agreementPage;
     }
     
     /**
     * Returning back to quote record
     */
     public PageReference back(){
        return new PageReference('/'+srecordId);
     }
     
     
     /**
     * Method to fetch LOD from selected account
     */
     public void FetchLodforSelectedAccount(){
        Id accountId;
        if(isForAgreement){
            accountId = agreement.APTS_LP_AccountCustomer__c;
        } else if (isForQuotation){
            accountId = quote.APTS_LP_AccountCustomer__c;
        }
        if(accountId != null){
            
            //Update Account
            saccountId = accountId;
            Account objAcc = [Select recordTypeId, RecordType.name , Name, GUID__c from Account where Id =: saccountId];
            sAccountName = objAcc.name;
            sGUIDId = objAcc.GUID__c;
            lODDataList = fetchlODDataList();
            
            bIsUpdatable = (lODDataList.isEmpty()) ? false : true;
            
            if(bIsUpdatable){
                maplODData.putAll(lODDataList);
                for(APTS_WrapperLOD wrapper :listUniqWrapperLOD)
                    mapWrapperLODData.put(wrapper.iRecordId,wrapper);
            }
            
            // Setting values on wrapper information
            lstLODWrapperInfo = assignLODWrapperInfo(lODDataList);
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'After Operation ========>'+lODDataList.size()));
            
            if(lstLODWrapperInfo == null || lstLODWrapperInfo.size()==0){
                addWarningMessage(Label.APTS_NoLODForAccCust);
            }
        }
        else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Please select valid Account.'));
        }
     }
    
    /*
     * @Description: Create new Task entry in activity history (Task #2173 in HPALM)
     * @Owner: Jignesh Shekhaliya
     * @Date: 02-Dec-2015
    */
    private void createTask(String subject, String description, String whatId){
        Task t = new Task();
        t.Subject = subject;
        t.WhatId = whatId;
        t.Description = description;
        t.Status = 'Completed';
        t.Priority = 'Normal';
        t.ActivityDate = system.today();
        insert t;
    }
}