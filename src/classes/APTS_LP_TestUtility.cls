/*************************************************************
@Name: APTS_LP_TestUtility
@Author: Hardik Shah
@CreateDate: 23/08/2015
@Description: Utility class for creating Test data
@UsedBy: APTS_LP_AgreementLineItemControllerTest,APTS_ProductConfigurationTest
******************************************************************
@ModifiedBy: NA
@ModifiedDate: NA
@ChangeDescription: A brief description of what was modified.
**** PS: @ModifiedBy and @ChangeDescription can be repeated multiple time, based on number of changes made to the original process.
******************************************************************/
public class APTS_LP_TestUtility {
    
    // Dummy user-mail
    private static final string USER_DUMMY_EMAIL = 'test123+invalid@apttus.com';
    // System-Admin user-profile
    private static User testAdminUser;
    // Sales-Admin user-profile
    private static User salesUser;
    
    private static final String QUOTE_RECORD_TYPE = 'LP';
    private static final String AGREEMENT_RECORD_TYPE = 'MSPA';    
    private static final String QUOTATION = 'Quotation';
    private static final String AGREEMENT = 'Agreement';
    
    private static final String ACCOUNT_RECORD_TYPE = 'External Non-Buying Account';
    
    private static APTS_Master_Picklist_Table__c distributionChannel = null;
    private static APTS_Master_Picklist_Table__c localChannel = null;
    private static APTS_Master_Picklist_Table__c masterPicklistSalesOffice = null;
    private static APTS_Master_Picklist_Table__c incoterm = null;
    private static APTS_Master_Picklist_Table__c paymentTerm = null;
    private static LSO_Field_Entries__c salesOffice = null;
    public static boolean productLineTreeInserted;

    // Returns a User Object
    public static User getUser(){
         testAdminUser = getCustomUser(getAdminProfile());
         insert testAdminUser; 
         return testAdminUser;
    }
  
    public static void createContact() {
        Contact con = new Contact(LastName = 'DM', FirstName = 'ABB'); 
        insert con;
    }
    
    // Test Data to create Agreement
    public static Apttus__APTS_Agreement__c getAgreement(string sAgreementName){
        Apttus__APTS_Agreement__c agr = new Apttus__APTS_Agreement__c();
        agr.name = sAgreementName;
        agr.APTS_LP_MSPA_title__c = 'Test Title';
        agr.APTS_LP_Sales_Organization__c = 'ABB';
        agr.Apttus__Status__c = 'Draft';
        agr.APTS_Distribution_Channel__c = getDistributionChannel().Id;
        agr.APTS_LP_Distribution_Channel__c = getDistributionChannel().APTS_Code__c;
        agr.APTS_Local_Channel__c = getLocalChannel().Id;
        agr.APTS_Incoterms__c = getIncoterm().Id;
        agr.APTS_Payment_Terms__c = getPaymentTerm().Id;
        agr.recordTypeId = getRecordType(AGREEMENT).id;
        agr.APTS_Country__c = 'Spain';
        agr.APTS_Sales_Office__c = getSalesOffice().Id;
        agr.APTS_GTV_Code__c = 'GTV-Code';
        return agr;
    }   
    
    //Test Data to create Opportunity
    public static Opportunity getOpportunity(string sOppName){
        Opportunity oOpportunity = new Opportunity();
        oOpportunity.Name = sOppName;
        oOpportunity.RecordType = getRecordType('OPPORTUNITY');
        oOpportunity.StageName = 'Prospecting';
        oOpportunity.CloseDate = System.today();
		oOpportunity.Channel_Class_Level1__c='DEU';
        return oOpportunity;
    }
    
    //Test Data to create Opportunity Partner
    public static Partner getPartner(Id oppId,Id accId){
        Partner oPartner = new Partner();
        oPartner.AccountToId = accId;
        oPartner.OpportunityId = oppId;
        oPartner.IsPrimary = True;
        return oPartner;
    }
    
    // Test Data to create Proposal
    public static Apttus_Proposal__Proposal__c getProposal(string sName){
        Apttus_Proposal__Proposal__c oProposal = new Apttus_Proposal__Proposal__c();
        oProposal.Apttus_Proposal__Proposal_Name__c = sName;
        oProposal.APTS_LP_Distribution_Channel__c = getDistributionChannel().APTS_Code__c;
        oProposal.APTS_Distribution_Channel__c = getDistributionChannel().Id;
        oProposal.APTS_Local_Channel__c = getLocalChannel().Id;
        oProposal.APTS_Sales_Office_LP__c = getMasterPicklistSalesOffice().Id;
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
    
    // Test Data to create AgreementLineItem
    public static Apttus__AgreementLineItem__c getAgreementLineItem(string sAgreementId){
        Apttus__AgreementLineItem__c oAgrline = new Apttus__AgreementLineItem__c();
        oAgrline.Apttus__AgreementId__c = sAgreementId;
        return oAgrline;
    }    
    
    // Test Data to create List of AgreementLineItem
    public static List<Apttus__AgreementLineItem__c> getAgreementLineItemList(string sAgreementId, Integer iCount){
        
        List<Apttus__AgreementLineItem__c> listAgrLineItem = new List<Apttus__AgreementLineItem__c>();
        
        for(Integer i = 0;i<iCount;i++){
            Apttus__AgreementLineItem__c oAgrline = new Apttus__AgreementLineItem__c();
            oAgrline.Apttus__AgreementId__c = sAgreementId;
            listAgrLineItem.add(oAgrline);
            
        }
        return listAgrLineItem;
      }


    // Test-Data to Create Product Configuration
    public static  Apttus_Config2__ProductConfiguration__c getProductConfiguration(String sName){
        Apttus_Config2__ProductConfiguration__c oProductConfig = new Apttus_Config2__ProductConfiguration__c();
        oProductConfig.name = sName;
        oProductConfig.Apttus_Config2__Status__c = 'NEW';
        return oProductConfig;
    }   
    
    // to fetch Product Configuration related to an agreement
    public static List<Apttus_Config2__ProductConfiguration__c> getConfigurationFromAgreement(Id agreementId){
        List<Apttus_Config2__ProductConfiguration__c> listProductConfig = new List<Apttus_Config2__ProductConfiguration__c>();
        listProductConfig = [Select Id, Name,Apttus_Config2__Status__c,APTS_LP_Finalize_Cart__c,Apttus_Config2__PriceListId__c,Apttus_Config2__PriceListId__r.Name from Apttus_Config2__ProductConfiguration__c
                                where Apttus_CMConfig__AgreementId__c =:agreementId ];
        return listProductConfig;
    }   
   
    // Test-Data to get List of LineItem with List-Price as 0 and NetAdjustmentPercent Value
    public static  List<Apttus_Config2__LineItem__c> getLineItemListWithPriceOveride(ID productConfigID, Integer iCount, Product2 prod,Integer iInitialAdjustAmount){
         
        List<Apttus_Config2__LineItem__c> listLineItem = new List<Apttus_Config2__LineItem__c>();
        
        for(Integer i = 0;i< iCount ;i++){
            Apttus_Config2__LineItem__c olineItem = new Apttus_Config2__LineItem__c();
            olineItem.Apttus_Config2__ConfigurationId__c = productConfigID;
            olineItem.Apttus_Config2__LineNumber__c = i+1;
            olineItem.Apttus_Config2__PrimaryLineNumber__c = i+1;
            olineItem.Apttus_Config2__NetAdjustmentPercent__c = iInitialAdjustAmount + i*2;
            olineItem.Apttus_Config2__ItemSequence__c = i+1;
            olineItem.Apttus_Config2__ListPrice__c = 15;
            olineItem.Apttus_Config2__ProductId__c = prod.id;
            olineItem.APTS_Discount_Type__c = 'Net Price Discount';
            listLineItem.add(olineItem);
        }
        
        return listLineItem;
    } 
    
    // Returns a Product
    public static Product2 getProduct(){
        
        Product2 oProduct  = new Product2();
        oProduct.name = 'Test Prod';
        oProduct.APTS_Product_ID__c = 'P1234';
        oProduct.APTS_Country_Code__c = 'EN';
        oProduct.APTS_GTV_Level__c = 'TestGTV';
        oProduct.Description = 'Test Desc';
        oProduct.RecordTypeId = getRecordId();
        oProduct.IsActive = true;
        oProduct.APTS_Product_ID__c = 'P123';
        return oProduct;
    }
    
    // Returns a list of Product Object
    public static List<Product2> getProductList(Integer iCount){
        
        List<Product2> listProduct = new List<Product2>();
         
        for(Integer i = 0;i< iCount ;i++){
            Product2 oProduct  = new Product2();
            oProduct.name = 'Test Prod' + i;
            oProduct.APTS_Country_Code__c = 'ES';
            oProduct.APTS_GTV_Level__c = 'TestGTV' + i*2;
            oProduct.Description = 'Test Desc';
            oProduct.RecordTypeId = getRecordId();
            oProduct.IsActive = true;
            oProduct.APTS_Product_ID__c = 'P123' + i;
            oProduct.APTS_LP_Product_Hierarchy__c = 'HierachyTestXYZ' + i;
            listProduct.add(oProduct);
        }
        
        for(Integer i = 0;i< iCount ;i++){
            Product2 oProduct  = new Product2();
            oProduct.name = 'Test Prod' + i;
            oProduct.APTS_Country_Code__c = 'ES';
            oProduct.APTS_LP_Product_Hierarchy__c = '000030099600001116';
            oProduct.APTS_LP_Is_Hierarchy__c = TRUE;
            oProduct.APTS_Hierarchy_Level__c = 3;
            oProduct.APTS_Hierarchy_Level_3_Code__c = '00996';
            oProduct.APTS_GTV_Level__c = 'TestGTV' + i*2;
            oProduct.Description = 'Test Desc';
            oProduct.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Local Hierarchy').getRecordTypeId();
            oProduct.IsActive = true;
            oProduct.APTS_Product_ID__c = 'P123' + i;
            listProduct.add(oProduct);
        }
        
        return listProduct;
    }
    
    public static Product2 getHierarchyProduct() {
        Product2 oProduct  = new Product2();
        oProduct.name = 'Test Hierarchy Prod';
        oProduct.APTS_Country_Code__c = 'ES';
        oProduct.APTS_LP_Product_Hierarchy__c = '000030099600001116';
        oProduct.APTS_LP_Is_Hierarchy__c = TRUE;
        oProduct.APTS_Hierarchy_Level__c = 3;
        oProduct.APTS_Hierarchy_Level_3_Code__c = '00996';
        oProduct.APTS_GTV_Level__c = 'TestGTV';
        oProduct.Description = 'Test Desc';
        oProduct.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Local Hierarchy').getRecordTypeId();
        oProduct.IsActive = true;
        oProduct.APTS_Product_ID__c = 'P123';
        
        return oProduct;
    }
    
    // Test-Data to get List of LineItem associated with LineItem
    public static  List<Apttus_Config2__LineItem__c> getLineItemListWithDiscount(ID productConfigID, Integer iCount, Product2 prod,Integer iInitialAdjustmentAmount){ 
         
        List<Apttus_Config2__LineItem__c> listLineItem = new List<Apttus_Config2__LineItem__c>();
        
        for(Integer i = 0;i< iCount ;i++){
            Apttus_Config2__LineItem__c oLineItem = new Apttus_Config2__LineItem__c();
            oLineItem.Apttus_Config2__ConfigurationId__c = productConfigID;
            oLineItem.Apttus_Config2__LineNumber__c = i+1;
            oLineItem.Apttus_Config2__PrimaryLineNumber__c =i+1;
            oLineItem.Apttus_Config2__ListPrice__c = 10;
            oLineItem.Apttus_Config2__ItemSequence__c = i+1;
            oLineItem.Apttus_Config2__AdjustmentAmount__c = iInitialAdjustmentAmount + i*2;
            oLineItem.Apttus_Config2__ProductId__c = prod.id;
            oLineItem.APTS_Discount_Type__c = 'Substitute Discount';
            oLineItem.APTS_Discount_Percentage__c = 62.00;
            listLineItem.add(oLineItem);
            
        }
        return listLineItem;
    } 
    
     // Test-Data to get List of LineItem associated with LineItem
    public static Apttus_Config2__LineItem__c getLineItem (ID productConfigID){
            Apttus_Config2__LineItem__c oLineItem = new Apttus_Config2__LineItem__c();
            oLineItem.Apttus_Config2__ConfigurationId__c = productConfigID;
            oLineItem.Apttus_Config2__LineNumber__c = 1;
            oLineItem.Apttus_Config2__ItemSequence__c = 1;
            return oLineItem;
    } 
    
    // Returns a User Object
    public static Account getNewAccount(String sAccName,String sCountryName){
        Account oAcc = new Account();
        oAcc.name = sAccName;
        oAcc.Primary_Address_Country__c = sCountryName;
        oAcc.Main_Local_City__c = 'Madrid';
        oAcc.Main_Local_Street__c = 'XYZ';
        oAcc.BillingCity = 'Madrid';
        oAcc.BillingStreet = 'XYZ';
        oAcc.BillingCountry = 'Spain';
        oAcc.GUID__c = 'G01413815';
        oACC.Migration_ID__c = '800000008';
        oACC.Company_Status__c = 'Approved';
        oACC.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACCOUNT_RECORD_TYPE).getRecordTypeId();
        return oAcc;
    }
    
    public static User getUser(String sCountryName){
        User oUser = new User();
        oUser.Country = sCountryName;
        return oUser;
    }
    
    // Returns PriceList Object
    public static Apttus_Config2__PriceList__c getPriceList(Account accnt,String sCountryName){
        Apttus_Config2__PriceList__c oPriceList = new Apttus_Config2__PriceList__c(Apttus_Config2__AccountId__c = accnt.id
                                                                                  ,Name='Test - Price List');
        oPriceList.APTS_Country__c = sCountryName;
        return oPriceList;
    }
    
    // Return System-Administrator Profile
    public static Profile getAdminProfile(){
        return [select id, name from Profile where  name = 'System Administrator' Limit 1];
    }
    
    // Returns Standard Sales Profile
    public static Profile getSalesProfile(){
        return [select id, name from Profile where  name = 'ABB Basic Admin' Limit 1];
    }
    
    // Returns the Record Type Id for a Given Product
    public static ID getRecordId(){
        Id devRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Local Products').getRecordTypeId();
        return devRecordTypeId;
    }
    
     // initiates User Object
     public static User getCustomUser(Profile userProfile ,string sUserEmail){
        User oUser = new User(alias = 'test123', email=sUserEmail, emailencodingkey='UTF-8',
                              lastname='Testing', languagelocalekey='en_US', localesidkey='es_ES', APTS_Locale__c = 'es_ES',
                              profileid = userProfile.Id, country = 'Spain', countryCode = 'ES', 
                              City = 'Barcelona', Sales_Territory_Name__c = 'BT/Niessen Barcelona',
                              Division = 'LP', Division_DIV__c = 'LP', timezonesidkey='America/Los_Angeles',
                              Default_LSO__c = 'ES_LP', Default_BU__c = 'ESABB-LPBS',IsActive = true,
                              username = getUserNamePrefix() + sUserEmail);
        return oUser;
    }
    
    // get User Object
    public static User getCustomUser(Profile userProfile){
        return getCustomUser(userProfile, USER_DUMMY_EMAIL);
    }
    
    // Add PreFix to user-name
    private static String getUserNamePrefix(){
        return  UserInfo.getOrganizationId() + System.now().millisecond();
    }    
         
    public static void addPricebookAndEntries(Product2 prod) {
        // First, set up test price book entries.
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
     
        // 1. Insert a price book entry for the standard price book.
        // Standard price book entries require the standard price book ID we got earlier.
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        // Create a custom price book
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        // 2. Insert a price book entry with a custom price.
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = prod.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
    }
    
    // Added By Kruti Shah (Req#30)
    // Test Data to create Discounts Backup
    public static APTS_Discounts_Config__c getDiscountsBackup(string sDBName){        
        APTS_Discounts_Config__c oDBobj = new APTS_Discounts_Config__c();
       // oDBobj.name = sDBName;
        oDBobj.APTS_Country__c = 'Spain';
        oDBobj.APTS_Record_Type__c = 'LP Spain - Project MSPA';
        APTS_Master_PickList_Table__c mpt = getMasterPickListTableLocalChannelWithInsert();
        oDBobj.APTS_Local_Channel__c = mpt.id;
        return oDBobj;
    }
    
    public static APTS_Master_PickList_Table__c getMasterPickListTableLocalChannelWithInsert(){
    
        APTS_Master_PickList_Table__c mpt = new APTS_Master_PickList_Table__c();
        
        mpt.name = 'BT - AP-Baja Tensi¢n';
        mpt.APTS_Code__c = 'BT';
        mpt.APTS_Code_Description__c = 'AP-Baja Tensi¢n';
        mpt.APTS_Locale__c = 'es_ES';
        mpt.APTS_Code_Used_For__c='Local Channel';
        insert mpt;
        
        return mpt;
    }
    
    /* Added By : Hardik Shah
     * Test Data to create MSPA Reference Number Object
     */
    public static APTS_MSPA_Ref_Number__c getMSPARefNumber(String sRefId){
        APTS_MSPA_Ref_Number__c oRefNumber = new APTS_MSPA_Ref_Number__c();
        oRefNumber.APTS_MSPA_Ref_ID__c = sRefId; 
        oRefNumber.APTS_Is_Used__c = false;
        return oRefNumber;
    }
    
    public static void getCustomSetting(){
        List<APTS_Custom_Cart_Settings__c> customSettings = new List<APTS_Custom_Cart_Settings__c>();
        APTS_Custom_Cart_Settings__c setting = new APTS_Custom_Cart_Settings__c();
        setting.Name = 'useAdvancedApproval';
        setting.APTS_Value__c = TRUE;
        customSettings.add(setting);
        
        setting = new APTS_Custom_Cart_Settings__c();
        setting.Name = 'useDealOptimizer';
        setting.APTS_Value__c = FALSE;
        customSettings.add(setting);
        insert customSettings;
    }
   
    public static APTS_Capture_LSO_Input_Config_Settings__c getLODConfigSetting()
    {
        APTS_Capture_LSO_Input_Config_Settings__c oTemp = new APTS_Capture_LSO_Input_Config_Settings__c();
        oTemp.name = 'LP-Spain Config Settings';
        oTemp.APTS_Distribution_Channel_Values__c ='BT, NI';
        oTemp.APTS_MSPA_Record_Type__c = AGREEMENT_RECORD_TYPE;
        oTemp.APTS_Quotation_Record_Type__c = QUOTE_RECORD_TYPE;
        oTemp.APTS_Sales_Organization_Values__c ='ABB';
        oTemp.APTS_SAP_Division_Values__c = 'ZZ';
        oTemp.APTS_Default_SAP_Customer_ID__c = '80006275';
        
        insert oTemp;
        return oTemp;
    }

   public static APTS_Common_Config_Settings__c getCommonConfigSetting()
    {
        
        List <APTS_Common_Config_Settings__c> oCommonSettingsList = new List<APTS_Common_Config_Settings__c>();
        APTS_Common_Config_Settings__c oCommonSettings = new APTS_Common_Config_Settings__c();
        oCommonSettings.Name = 'Global_Record_Type';
        oCommonSettings.APTS_Description__c = 'Global_Record_Type';
        oCommonSettings.APTS_Value__c ='Global Products';
        oCommonSettingsList.add(oCommonSettings) ;
        
        oCommonSettings = new APTS_Common_Config_Settings__c();
        oCommonSettings.Name = 'LP_USER_DIVISION';
        oCommonSettings.APTS_Description__c = 'LP_USER_DIVISION';
        oCommonSettings.APTS_Value__c ='LP';
        oCommonSettingsList.add(oCommonSettings) ;
        
        oCommonSettings = new APTS_Common_Config_Settings__c();
        oCommonSettings.Name = 'APPROVAL_COUNTRY';
        oCommonSettings.APTS_Description__c = 'APPROVAL_COUNTRY';
        oCommonSettings.APTS_Value__c ='Spain';
        oCommonSettingsList.add(oCommonSettings) ;
        
        oCommonSettings = new APTS_Common_Config_Settings__c();
        oCommonSettings.Name = 'BUYING';
        oCommonSettings.APTS_Description__c = 'BUYING';
        oCommonSettings.APTS_Value__c ='GIS Approved';
        oCommonSettingsList.add(oCommonSettings) ;
        
        oCommonSettings = new APTS_Common_Config_Settings__c();
        oCommonSettings.Name = 'DEFAULT_SAP_DIVISION';
        oCommonSettings.APTS_Description__c = 'DEFAULT_SAP_DIVISION';
        oCommonSettings.APTS_Value__c ='ZZ';
        oCommonSettingsList.add(oCommonSettings) ;
        
		oCommonSettings = new APTS_Common_Config_Settings__c();
        oCommonSettings.Name = 'DIVISION';
        oCommonSettings.APTS_Description__c = 'DIVISION';
        oCommonSettings.APTS_Value__c ='LP';
        oCommonSettingsList.add(oCommonSettings) ;
        
        oCommonSettings = new APTS_Common_Config_Settings__c();
        oCommonSettings.Name = 'LP_DIVISION';
        oCommonSettings.APTS_Description__c = 'LP_DIVISION';
        oCommonSettings.APTS_Value__c ='LP';
        oCommonSettingsList.add(oCommonSettings) ;
        
        oCommonSettings = new APTS_Common_Config_Settings__c();
        oCommonSettings.Name = 'LP_SPAIN';
        oCommonSettings.APTS_Description__c = 'LP_SPAIN';
        oCommonSettings.APTS_Value__c ='LP_Spain';
        oCommonSettingsList.add(oCommonSettings) ;
        
        oCommonSettings = new APTS_Common_Config_Settings__c();
        oCommonSettings.Name = 'NON_BUYING';
        oCommonSettings.APTS_Description__c = 'NON_BUYING';
        oCommonSettings.APTS_Value__c ='External Non-Buying Account';
        oCommonSettingsList.add(oCommonSettings) ;

        oCommonSettings = new APTS_Common_Config_Settings__c();
        oCommonSettings.Name = 'SPAIN_LOCALE';
        oCommonSettings.APTS_Description__c = 'SPAIN_LOCALE';
        oCommonSettings.APTS_Value__c ='es_ES';
        oCommonSettingsList.add(oCommonSettings) ;

        oCommonSettings = new APTS_Common_Config_Settings__c();
        oCommonSettings.Name = 'UNKNOWN_ES';
        oCommonSettings.APTS_Description__c = 'UNKNOWN_ES';
        oCommonSettings.APTS_Value__c ='Unknown - ES';
        oCommonSettingsList.add(oCommonSettings) ;
        
        insert oCommonSettingsList;
        return oCommonSettings;
    }    
    
    public static Apttus_Approval__ApprovalsSystemProperties__c getApprovalSystemProperty() {
        
        Apttus_Approval__ApprovalsSystemProperties__c approvalSystemProperties = new Apttus_Approval__ApprovalsSystemProperties__c ();
        approvalSystemProperties.name = 'System Properties';
        approvalSystemProperties.APTS_Comments_Mandatory_On_Rejection__c = 'Comments are mandatory upon rejection.';
        
        insert approvalSystemProperties;
        return approvalSystemProperties;
    }
    
     public static List<APTS_Stage_Product_Line_Tree__c> getStageProductLineTreeList(Integer count){
        productLineTreeInserted = True;
        APTS_Stage_Product_Line_Tree__c stageProductLineTree = null;
        List<APTS_Stage_Product_Line_Tree__c> listStageProductLineTree = new List<APTS_Stage_Product_Line_Tree__c>();
        Integer loopCount = count /2 ;
        
        for(Integer i = 0;i<loopCount; i++){
            stageProductLineTree = new APTS_Stage_Product_Line_Tree__c();
            stageProductLineTree.APTS_Active__c = 'True';
            stageProductLineTree.APTS_BU__c = 'LPBS';
            stageProductLineTree.APTS_BU_Name__c = 'XYZ';
            stageProductLineTree.APTS_PG__c = 1250 + i;
            stageProductLineTree.APTS_Product_Line_1_ID__c = 32000 + i;
            stageProductLineTree.APTS_Product_Line_2_ID__c = 32001 + i;
            stageProductLineTree.APTS_Product_Line_3_ID__c = 32002 + i;
            stageProductLineTree.APTS_External_ID__c = 'H1' + i;
            stageProductLineTree.APTS_Division__c = 'LP';
            stageProductLineTree.APTS_Owner__c = 'John Test';
            stageProductLineTree.APTS_BU_Name__c = 'TestBU';
            listStageProductLineTree.add(stageProductLineTree);
            
        }
        
        for(Integer i = 0;i<loopCount; i++){
            stageProductLineTree = new APTS_Stage_Product_Line_Tree__c();
            stageProductLineTree.APTS_Active__c = 'XYZ';
            stageProductLineTree.APTS_BU__c = 'LPBS1';
            stageProductLineTree.APTS_BU_Name__c = 'XYZ';
            stageProductLineTree.APTS_PG__c = 1250 + i;
            stageProductLineTree.APTS_Division__c = 'Xyz';
            stageProductLineTree.APTS_External_ID__c = 'J1' + i;
            stageProductLineTree.APTS_Product_Line_2_ID__c = 32001 + i;
            stageProductLineTree.APTS_Product_Line_3_ID__c = 32002 + i;
            stageProductLineTree.APTS_Owner__c = 'John Test';
            listStageProductLineTree.add(stageProductLineTree);
            
        }
        
        return listStageProductLineTree;
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
        
        APTS_Discounts_Config__c agreementConfig = new APTS_Discounts_Config__c();
       // agreementConfig.name = 'Spain/MSPA-MSPA/P5/LP';
        agreementConfig.APTS_Country__c = 'Spain';
        agreementConfig.APTS_Record_Type__c = AGREEMENT_RECORD_TYPE;
        agreementConfig.APTS_Division__c = 'LP';
        agreementConfig.APTS_Hierarchy_Level_MS__c = '3';
        agreementConfig.APTS_IsActive__c = TRUE;
        agreementConfig.APTS_Additional_Discount__c = TRUE;
        agreementConfig.APTS_Substitute_Discount__c = TRUE;
        agreementConfig.APTS_Additional_Discounts_Hierarchy__c = TRUE;
        agreementConfig.APTS_Net_Discount_Hierarchy__c = TRUE;
        agreementConfig.APTS_Substitutional_Discounts_Hierarchy__c = TRUE;
        agreementConfig.APTS_Net_Discount__c = TRUE;
        agreementConfig.APTS_Local_Channel__c = getLocalChannel().id;
        
        listDiscountConfig.add(quoteConfig);
        listDiscountConfig.add(agreementConfig);
        
        insert listDiscountConfig;
        return listDiscountConfig;
    }
    
    public static void getMasterPicklistTableData() {
        List<APTS_Master_Picklist_Table__c> listMasterPicklistTableData = new List<APTS_Master_Picklist_Table__c>();
        
        if(distributionChannel == null || localChannel == null || incoterm == null || paymentTerm == null || masterPicklistSalesOffice == null) {
            
            distributionChannel = new APTS_Master_Picklist_Table__c();
            distributionChannel.name = 'BT';
            distributionChannel.APTS_Locale__c = 'es_ES';
            distributionChannel.APTS_Code__c = 'BT';
            distributionChannel.APTS_Code_Used_For__c = 'Distribution Channel';
            
            localChannel = new APTS_Master_Picklist_Table__c();
            localChannel.Name = 'P5 - Distribución General';
            localChannel.APTS_Code__c = 'P5';
            localChannel.APTS_Code_Description__c = 'Distribución General';
            localChannel.APTS_Code_Used_For__c = 'Local Channel';
            localChannel.APTS_Locale__c = 'es_ES';
            
            masterPicklistSalesOffice = new APTS_Master_Picklist_Table__c();
            masterPicklistSalesOffice.Name = 'Z111 - BT/Niessen Barcelona';
            masterPicklistSalesOffice.APTS_Code__c = 'Z111';
            masterPicklistSalesOffice.APTS_Code_Description__c = 'BT/Niessen Barcelona';
            masterPicklistSalesOffice.APTS_Code_Used_For__c = 'Sales Office';
            masterPicklistSalesOffice.APTS_Locale__c = 'es_ES';
            masterPicklistSalesOffice.APTS_Country__c = 'Spain';
            
            incoterm = new APTS_Master_Picklist_Table__c();
            incoterm.Name = 'CPT - Porte pagado';
            incoterm.APTS_Code__c = 'CPT';
            incoterm.APTS_Code_Description__c = 'Porte pagado';
            incoterm.APTS_Code_Used_For__c = 'Incoterm';
            incoterm.APTS_Locale__c = 'es_ES';
            
            paymentTerm = new APTS_Master_Picklist_Table__c();
            paymentTerm.Name = 'Z004 - Cobro a 30 d¡as';
            paymentTerm.APTS_Code__c = 'Z004';
            paymentTerm.APTS_Code_Description__c = 'Cobro a 30 d¡as';
            paymentTerm.APTS_Code_Used_For__c = 'Payment Term';
            paymentTerm.APTS_Locale__c = 'es_ES';
            
            listMasterPicklistTableData.add(distributionChannel);
            listMasterPicklistTableData.add(localChannel);
            listMasterPicklistTableData.add(incoterm);
            listMasterPicklistTableData.add(paymentTerm);
            listMasterPicklistTableData.add(masterPicklistSalesOffice);
            
            insert listMasterPicklistTableData;
        }
    }
    
    public static APTS_Master_Picklist_Table__c getDistributionChannel() {
        if(distributionChannel == null) {
            getMasterPicklistTableData();
        }
        return distributionChannel;
    }
    
    public static APTS_Master_Picklist_Table__c getLocalChannel() {
        if(localChannel == null) {
            getMasterPicklistTableData();
        }
        return localChannel;
    }

    public static APTS_Master_Picklist_Table__c getMasterPicklistSalesOffice() {
        if(masterPicklistSalesOffice == null) {
            getMasterPicklistTableData();
        }   
        return masterPicklistSalesOffice;
    }
    
    public static APTS_Master_Picklist_Table__c getIncoterm() {
        if(incoterm == null) {
            getMasterPicklistTableData();
        }
        return incoterm;
    }
    
    public static APTS_Master_Picklist_Table__c getPaymentTerm() {
        if(paymentTerm == null) {
            getMasterPicklistTableData();
        }
        return paymentTerm;
    }
    
     public static LSO_Field_Entries__c getSalesOffice() {
        List <LSO_Field_Entries__c> sOffice = [select ID from LSO_Field_Entries__c 
                                        where PickList_Code__c = 'Z111' 
                                        and PickList_Description__c = 'BT/Niessen Barcelona'
                                        and Value__c = 'Spain' and Country__c = 'Spain' limit 1];
        if(sOffice == null || sOffice.size() == 0) {
            if(salesOffice == null) {
                salesOffice = new LSO_Field_Entries__c();
                salesOffice.Active__c = TRUE;
                salesOffice.PickList_Code__c = 'Z111';
                salesOffice.PickList_Description__c = 'BT/Niessen Barcelona';
                salesOffice.Controlling_Field__c = 'LSO Reference Data.Country';
                salesOffice.Value__c = 'Spain';
                salesOffice.Country__c = 'Spain';
                salesOffice.LSO_Pick_List_Value_Name__c = 'LSO Reference Data. Sales Office';
                salesOffice.Manual_Unique__c = 'Test9999';
                insert salesOffice;
            }
        } else {
            salesOffice = sOffice[0];
        }
        return salesOffice;
    }    
    public static APTS_Delegated_Approver_Settings__c getDelegateApprovalCustomSettings() {
        
        APTS_Delegated_Approver_Settings__c setting = new APTS_Delegated_Approver_Settings__c();
        setting.Name = 'Spain';
        setting.APTS_Country__c = 'Spain';
        
        return setting;
    }
    
     // Returns a list of Product Object
    public static List<APTS_Stage_Product__c> getProductList(Integer iCount,String sRecordType){
        
        List<APTS_Stage_Product__c> listProduct = new List<APTS_Stage_Product__c>();
        APTS_Stage_Product__c oProduct  = null;
               
        for(Integer i = 0;i< iCount ;i++){
                oProduct  = new APTS_Stage_Product__c();
                oProduct.name = 'Test Prod' + i;
                oProduct.APTS_Country_Code__c = 'EN';
                oProduct.APTS_GTV_Level__c = 'TestGTV' + i*2;
                oProduct.APTS_RecordType__c = getRecordId(sRecordType);
                oProduct.APTS_Active__c = 'true';
                oProduct.APTS_Product_ID__c = '123' + i;
                //oProduct.APTS_Product_Line_ID__c = '32003' ;
                oProduct.APTS_ABB_Global_ID__c = 'Product-Code0';
                oProduct.APTS_BU__c = 'LPCW';
                oProduct.Name = '';
                oProduct.APTS_PG__c = '';
                oProduct.APTS_ABB_Global_ID__c = '';
                oProduct.APTS_Offering_Tree_Classification_ID_1__c = '';
                oProduct.APTS_LP_Product_Hierarchy__c = 'HierachyTestXYZ' + i;
                listProduct.add(oProduct);
        }
        
        
          for(Integer i = 0;i< iCount ;i++){
                oProduct  = new APTS_Stage_Product__c();
                oProduct.name = 'Test Prod1' + i;
                oProduct.APTS_Country_Code__c = 'EN';
                oProduct.APTS_GTV_Level__c = 'TestGTV' + i*2;
                oProduct.APTS_RecordType__c = getRecordId(sRecordType);
                oProduct.APTS_Active__c = 'xyz';
                oProduct.APTS_Product_ID__c = '123' + i;
                //oProduct.APTS_Product_Line_ID__c = '32003' ;
                oProduct.APTS_BU__c = 'TEST';
                oProduct.Name = '';
                oProduct.APTS_PG__c = '';
                oProduct.APTS_ABB_Global_ID__c = '';
                oProduct.APTS_Offering_Tree_Classification_ID_1__c = '';
                oProduct.APTS_LP_Product_Hierarchy__c = 'HierachyTestXYZ' + i;
                listProduct.add(oProduct);
        } 
        
        return listProduct;
    }
    
     public static ID getRecordId(String sRecordType){
        Id devRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(sRecordType).getRecordTypeId();
        return devRecordTypeId;
    }
    
    public static List<APTS_Stage_Local_Hierarchy__c> getLocalHierachyList(Integer iCount){
        List<APTS_Stage_Local_Hierarchy__c> listLocal = new List<APTS_Stage_Local_Hierarchy__c>();
        APTS_Stage_Local_Hierarchy__c oLocalHierachy = null;
        Integer loopCount = iCount/2;
        
         for(Integer i = 0;i< loopCount ;i++){
             oLocalHierachy = new APTS_Stage_Local_Hierarchy__c();
             oLocalHierachy.APTS_Level1_Name__c = 'L1' + i;
             oLocalHierachy.APTS_Level2_Name__c = 'L2' + i;
             oLocalHierachy.APTS_Level3_Name__c = 'L3' + i;
             oLocalHierachy.APTS_Level1_Code__c = 'C1' + i;
             oLocalHierachy.APTS_Level2_Code__c= 'C2' + i;
             oLocalHierachy.APTS_Level3_Code__c = 'C3' + i;  
             oLocalHierachy.APTS_Owner__c = 'Test1 Test';
             listLocal.add(oLocalHierachy);
         }
        
        for(Integer i = 0;i< loopCount ;i++){
             oLocalHierachy = new APTS_Stage_Local_Hierarchy__c();
             oLocalHierachy.APTS_Level1_Name__c = 'L1' + i;
             oLocalHierachy.APTS_Level2_Name__c = 'L2' + i;
             oLocalHierachy.APTS_Level3_Name__c = 'L3' + i;
            listLocal.add(oLocalHierachy);
         }
        return listLocal;
    }
    
     public static List<APTS_Stage_MSPA__c> getStageMSPA(Integer iCount){
        
        List<APTS_Stage_MSPA__c> listStageMSPA = new List<APTS_Stage_MSPA__c>();
        Integer loopCount = iCount/2;
        
        APTS_Stage_MSPA__c stageMSPA = null;
        
        for(Integer i = 0;i< loopCount ;i++){
            stageMSPA = new APTS_Stage_MSPA__c();
            stageMSPA.APTS_Final_Indirect_Customer_SPA__c = 'Acct-1';
            stageMSPA.APTS_DistributionChannel_SPA__c = getDistributionChannel().APTS_Code__c;
            stageMSPA.APTS_Sales_Office_SPA__c = getLocalChannel().APTS_Code__c;
            stageMSPA.APTS_ChannelSetValue_Code__c = getIncoterm().APTS_Code__c;
            stageMSPA.APTS_External_ID__c = 'testing1'+i;
            listStageMSPA.add(stageMSPA);
        }
        
         for(Integer i = 0;i< loopCount ;i++){
            stageMSPA = new APTS_Stage_MSPA__c();
            stageMSPA.APTS_DistributionChannel_SPA__c = 'Xyz';
            stageMSPA.APTS_Sales_Office_SPA__c = 'XYZ';
            stageMSPA.APTS_ChannelSetValue_Code__c = 'XYZ';
            stageMSPA.APTS_External_ID__c = 'testing2'+i;
            listStageMSPA.add(stageMSPA);
        }
        
        return listStageMSPA;
        
    }
    
     public static List<APTS_Stage_MSPA_LineItems__c> getStageMSPALineItems(Integer iCount){
         
        List<APTS_Stage_MSPA_LineItems__c> listStageMSPALineItems = new List<APTS_Stage_MSPA_LineItems__c>();
        Integer loopCount = iCount/2;
        APTS_Stage_MSPA_LineItems__c stageMSPALineItems = null;
        
        for(Integer i = 0;i<loopCount; i++){
            stageMSPALineItems = new APTS_Stage_MSPA_LineItems__c();
            stageMSPALineItems.APTS_Product_Code__c = 'Product-Code' + i;
            stageMSPALineItems.APTS_SPA_Identifier__c = i;
            listStageMSPALineItems.add(stageMSPALineItems);
        }
        
         return listStageMSPALineItems;
      
     }
    
    private static RecordType getRecordType(String recordTypeFor) {
        String recordTypeName = null;
        String objectType = null;
        
        if(QUOTATION.equals(recordTypeFor)) {
            recordTypeName = QUOTE_RECORD_TYPE;
            objectType = 'Apttus_Proposal__Proposal__c';
        } else if(AGREEMENT.equals(recordTypeFor)) {
            recordTypeName = AGREEMENT_RECORD_TYPE;
            objectType = 'Apttus__APTS_Agreement__c';
        } else if('OPPORTUNITY'.equals(recordTypeFor)){
            recordTypeName = 'Initial';
            objectType = 'Opportunity';
        }
        
        RecordType rt = [SELECT id, name FROM RecordType WHERE name = :recordTypeName AND sObjectType = :objectType];
        return rt;
    }
    
    public static List<APTS_Stage_Master_Picklist__c> getStageMasterPicklistTableData() {
       
        List<APTS_Stage_Master_Picklist__c> listMasterPicklistTableData = new List<APTS_Stage_Master_Picklist__c>();
        APTS_Stage_Master_Picklist__c stageDistributionChannel = new APTS_Stage_Master_Picklist__c();
        APTS_Stage_Master_Picklist__c stageLocalChannel = new APTS_Stage_Master_Picklist__c();
        APTS_Stage_Master_Picklist__c stageIncoterm = new APTS_Stage_Master_Picklist__c();
        APTS_Stage_Master_Picklist__c stagePaymentTerm = new APTS_Stage_Master_Picklist__c();
        
        stageDistributionChannel.name = 'BT';
        stageDistributionChannel.APTS_Locale__c = 'es_ES';
        stageDistributionChannel.APTS_Code__c = 'BT';
        stageDistributionChannel.APTS_Code_Used_For__c = 'Distribution Channel';
        stageLocalChannel.Name = 'P5 - Distribución General';
        
        stageLocalChannel.APTS_Code__c = 'P5';
        stageLocalChannel.APTS_Code_Description__c = 'Distribución General';
        stageLocalChannel.APTS_Code_Used_For__c = 'Local Channel';
        stageLocalChannel.APTS_Locale__c = 'es_ES';
       
        stageIncoterm.Name = 'CPT - Porte pagado';
        stageIncoterm.APTS_Code__c = 'CPT';
        stageIncoterm.APTS_Code_Description__c = 'Porte pagado';
        stageIncoterm.APTS_Code_Used_For__c = 'Incoterm';
        stageIncoterm.APTS_Locale__c = 'es_ES';
            
        stagePaymentTerm.Name = 'Z004 - Cobro a 30 d¡as';
        stagePaymentTerm.APTS_Code__c = 'Z004';
        stagePaymentTerm.APTS_Code_Description__c = 'Cobro a 30 d¡as';
        stagePaymentTerm.APTS_Code_Used_For__c = 'Payment Term';
        stagePaymentTerm.APTS_Locale__c = 'es_ES';
            
        listMasterPicklistTableData.add(stageDistributionChannel);
        listMasterPicklistTableData.add(stageLocalChannel);
        listMasterPicklistTableData.add(stageIncoterm);
        listMasterPicklistTableData.add(stagePaymentTerm);
            
        return listMasterPicklistTableData;
        
    }
    
    
     public static List<APTS_Stage_Master_Picklist__c> getStageMasterPicklistTableData(Integer iCount) {
       
        List<APTS_Stage_Master_Picklist__c> listMasterPicklistTableData = new List<APTS_Stage_Master_Picklist__c>();
        APTS_Stage_Master_Picklist__c stageMasterPickList = null;
        
        for(Integer i = 0 ; i<iCount; i++){
            stageMasterPickList = new APTS_Stage_Master_Picklist__c();
            stageMasterPickList.APTS_Code__c = 'P1';
            stageMasterPickList.APTS_Code_Description__c = 'Local Channel';
            stageMasterPickList.APTS_Code_Used_For__c = 'Local Channel';
            stageMasterPickList.APTS_External_ID__c = 'h1' + i;
            stageMasterPickList.APTS_Locale__c = 'es-ES';
            listMasterPicklistTableData.add(stageMasterPickList);
            
        }
        
         for(Integer i = 0 ; i<iCount; i++){
            stageMasterPickList = new APTS_Stage_Master_Picklist__c();
            stageMasterPickList.APTS_Code__c = '';
            stageMasterPickList.APTS_Code_Description__c = 'Local Channel';
            stageMasterPickList.APTS_Code_Used_For__c = '';
            stageMasterPickList.APTS_External_ID__c = 'P1' + i;
            stageMasterPickList.APTS_Locale__c = 'es-ES';
            listMasterPicklistTableData.add(stageMasterPickList);
            
        }
            
        return listMasterPicklistTableData;
        
    }
    
    
    public static List<APTS_Stage_Approval_Rule_Matrix__c> getStageApprovalRuleMatrix(Integer iCount){
        
        List<APTS_Stage_Approval_Rule_Matrix__c> listStageApprovalRuleMatrix = new List<APTS_Stage_Approval_Rule_Matrix__c>();
        Integer loopCount = iCount/2;
        APTS_Stage_Approval_Rule_Matrix__c stageApprovalMatrix = null;
        
        for(Integer i = 0;i< loopCount ;i++){
            stageApprovalMatrix = new APTS_Stage_Approval_Rule_Matrix__c();
            stageApprovalMatrix.APTS_Threshold_Discount__c = 100;
            stageApprovalMatrix.APTS_Local_Channel__c = getLocalChannel().APTS_Code__c;
            stageApprovalMatrix.APTS_Assigned_to__c = 'Test';
            stageApprovalMatrix.APTS_Country__c = 'Spain';
            stageApprovalMatrix.APTS_Sales_Organisation__c = APTS_DMConstants.APPROVAL_ORGANIZATION;
            stageApprovalMatrix.APTS_Owner__c = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
            stageApprovalMatrix.APTS_External_ID__c = 'Test External ID+' + i;
            listStageApprovalRuleMatrix.add(stageApprovalMatrix);
        }
        
         for(Integer i = 0;i< loopCount ;i++){
            stageApprovalMatrix = new APTS_Stage_Approval_Rule_Matrix__c();
            stageApprovalMatrix.APTS_Threshold_Discount__c = -100;
            stageApprovalMatrix.APTS_Local_Channel__c = 'XYZ';
            stageApprovalMatrix.APTS_Country__c = 'India';
            stageApprovalMatrix.APTS_Sales_Organisation__c = 'XYZ';
            stageApprovalMatrix.APTS_Assigned_to__c = 'Test';
            stageApprovalMatrix.APTS_Owner__c = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
            stageApprovalMatrix.APTS_External_ID__c = 'Test External ID-' + i;
            listStageApprovalRuleMatrix.add(stageApprovalMatrix);
        }
            
        return listStageApprovalRuleMatrix;
    }
    
    public static List<APTS_Approval_Rule_Matrix__c> getApproalRuleMatrix() {
        List<APTS_Approval_Rule_Matrix__c> listRuleMatrix = new List<APTS_Approval_Rule_Matrix__c>();
        
        APTS_Approval_Rule_Matrix__c mat1 = new APTS_Approval_Rule_Matrix__c();
        mat1.APTS_Country__c = 'Spain';
        mat1.APTS_Sales_Organisation__c = 'ABB';
        mat1.APTS_GTV_Level_Code__c = '00996';
        mat1.APTS_Threshold_Discount__c = 61.12;
        mat1.APTS_Approval_Level__c = 1;
        mat1.APTS_Max_Discount__c = 71.12;
        mat1.APTS_LP_Local_Channel__c = getLocalChannel().Id;
        mat1.APTS_Sales_Office__c = getSalesOffice().Id;
        mat1.APTS_LP_Sales_Office__c = getMasterPicklistSalesOffice().Id;
        mat1.APTS_Assigned_to__c = UserInfo.getUserId();
        
        APTS_Approval_Rule_Matrix__c mat2 = new APTS_Approval_Rule_Matrix__c();
        mat2.APTS_Country__c = 'Spain';
        mat2.APTS_Sales_Organisation__c = 'ABB';
        mat2.APTS_GTV_Level_Code__c = '00996';
        mat2.APTS_Threshold_Discount__c = 71.13;
        mat2.APTS_Approval_Level__c = 2;
        mat2.APTS_Max_Discount__c = 100.00;
        mat2.APTS_LP_Local_Channel__c = getLocalChannel().Id;
        mat2.APTS_Sales_Office__c = getSalesOffice().Id;
        mat2.APTS_LP_Sales_Office__c = getMasterPicklistSalesOffice().Id;
        mat2.APTS_Assigned_to__c = UserInfo.getUserId();
        
        listRuleMatrix.add(mat1);
        listRuleMatrix.add(mat2);
        
        insert listRuleMatrix;
        return listRuleMatrix;
    }
    
      public static List<APTS_Product_Line_Tree__c> getProductLineTreeList(){
 
        List<APTS_Product_Line_Tree__c> ProductLineTreeList= new List<APTS_Product_Line_Tree__c>();
        APTS_Product_Line_Tree__c stageProductLineTree = null;
        stageProductLineTree = new APTS_Product_Line_Tree__c();
        stageProductLineTree.APTS_Alternative_ID__c = 'text123';
        stageProductLineTree.APTS_BU__c = 'LPBS';
        stageProductLineTree.APTS_BU_Name__c = 'XYZ';
        stageProductLineTree.APTS_PG__c = 1250;
        stageProductLineTree.APTS_Product_Line_1_ID__c = 32000;
        stageProductLineTree.APTS_Product_Line_2_ID__c = 32001;
        stageProductLineTree.APTS_Product_Line_3_ID__c = 32002;
        stageProductLineTree.APTS_External_ID__c = 'H1';
        stageProductLineTree.APTS_Division__c = 'LP';
        stageProductLineTree.APTS_BU_Name__c = 'TestBU';
        ProductLineTreelist.add(stageProductLineTree);
        return ProductLineTreeList;
    }
    
    public static List<APTS_Stage_Local_Operational_Data__c> getStageLocalOperationData(){
    
       List<APTS_Stage_Local_Operational_Data__c> listLocalOperationData = new List<APTS_Stage_Local_Operational_Data__c>();
       APTS_Stage_Local_Operational_Data__c stageLocalOpData = new APTS_Stage_Local_Operational_Data__c(APTS_LP_Account_GUID__c='test',APTS_LP_Local_Channel__c=
                                                                            'Local Channel',
                                                                           APTS_LP_Distribution_Channel__c= 'Distribution Channel',APTS_LP_Incoterms__c='Incoterm',
                                                                           APTS_Payment_Terms__c='Payment Term',
                                                                           APTS_SAP_Division__c= 'SAP Division');
    listLocalOperationData.add(stageLocalOpData);
    return listLocalOperationData;
    }
                                                                           
                                                                           
        
    public static void getProductLineTreeCustomSettings(){
        
        APTS_Stage_Data_Validation_Rules_Setting__c rule = new APTS_Stage_Data_Validation_Rules_Setting__c();
        rule.Name = 'DataMigration';
        rule.APTS_SProductLineTree_BUName__c  = 'reakers & Switches; Control Products; Enclosures & DIN-Rail Products;LV Systems; Protection, Connection & Wire Management;Sundry LP; Wiring Accessories';
        
        insert rule;
        
    } 
    
    public static void getIntegrationParameters(){
        
        List<APTS_SAP_Integration_Tokens__c> listCustomSAP = new List<APTS_SAP_Integration_Tokens__c >();
        
        APTS_SAP_Integration_Tokens__c customSAP = new APTS_SAP_Integration_Tokens__c ();
        customSAP.name = 'SAP MSPA Creation Tokens';
        customSAP.APTS_Base_Address__c = 'https://abberpgatewaydev.servicebus.windows.net/';
        customSAP.APTS_Bau_Code__c = 'ES1';
        customSAP.APTS_Block_in_SAP__c = FALSE;
        customSAP.APTS_ERP_Response_Culture__c = 'es-ES';
        customSAP.APTS_Key__c = 'hj7nmmYxSZbtVsyeyqAJ';
        customSAP.APTS_Http_Header_Key__c = 'Authorization';
        customSAP.APTS_End_Point__c ='https://abberpgatewaydev.servicebus.windows.net/api/orders/createsalesdeal';
        customSAP.APTS_Key_Name__c = 'FaceServiceBusServices';
        customSAP.APTS_SAP_Call_Timeout_Millis__c = 120000;
        
        APTS_SAP_Integration_Tokens__c customSAP1 = new APTS_SAP_Integration_Tokens__c ();
        customSAP1.name = 'SAP oAuth Tokens';
        customSAP1.APTS_Base_Address__c = 'https://abberpgatewaydev.servicebus.windows.net/';
        customSAP1.APTS_Bau_Code__c = 'ES1';
        customSAP1.APTS_ERP_Response_Culture__c = 'es-ES';
        customSAP1.APTS_Key__c = 'Sd6tRl5wj9ieNgE6q7Q9Y/wkYoD24aqERudvHvB9Ow8=';
        customSAP1.APTS_Http_Header_Key__c = 'Authorization';
        customSAP1.APTS_Key_Name__c = 'FaceErpGateway_ServiceBus';
        customSAP1.APTS_End_Point__c ='https://applications.it.abb.com/abbaccountstest/issue/oauth2/token';
        customSAP1.APTS_oAuth_Token__c = 'ErpGateway:nU2+tOVFCK81+/wuuSx61QgOyySMcS9z//go4Lpej6k=';
        customSAP1.APTS_SAP_Call_Timeout_Millis__c = 120000;
        
        APTS_Config_SAP_Integration__c sapConfig = new APTS_Config_SAP_Integration__c(name = 'MSPA SAP Config');
        sapConfig.APTS_of_Re_Tries__c = 2;
        sapConfig.APTS_Call_Interval__c = 2;
        insert sapConfig;
        
        listCustomSAP.add(customSAP);
        listCustomSAP.add(customSAP1);
        
        insert listCustomSAP;
    }
    
    public static void getSAPIntegrationTokens(){
        
        APTS_IntegrationMappingParameters__c customSettings = new APTS_IntegrationMappingParameters__c();
        customSettings.Name = '1';
        customSettings.APTS_Country__c = 'Spain';
        customSettings.APTS_ParameterName__c = 'DealType';
        customSettings.APTS_ParameterValue__c= '3';
        customSettings.APTS_TargetObject__c= 'Apttus__APTS_Agreement__c';
        customSettings.APTS_ObjectField__c= 'APTS_LP_MSPA_Type__c';
        insert customSettings;
    }
    
     // Returns a Sales-User Object
    public static User getSalesUser(){
         salesUser = getCustomUser(getSalesProfile());
         insert salesUser; 
         return salesUser;
    }
    
    public static void getCustomSetting_QuoteNProposal(){
        
        APTS_Agreement_Record_Type__c custSettingAgr = new APTS_Agreement_Record_Type__c(
            SetupOwnerId = UserInfo.getOrganizationId(),
            APTS_Default_Record_Type__c = AGREEMENT_RECORD_TYPE);
        insert custSettingAgr;
        
        APTS_Proposal_Record_Type__c custSettingQuote = new APTS_Proposal_Record_Type__c(SetupOwnerId = UserInfo.getOrganizationId(),
                                                                                         APTS_Default_Record_Type__c = QUOTE_RECORD_TYPE); 
        insert custSettingQuote;
        
        getCommonConfigSetting();
    }
    
}