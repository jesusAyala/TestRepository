@isTest
private class APTS_CaptureInputForLSODataCtrlTest {
        
    private static Account acc = createNewAccount();
    private static Opportunity opp = createNewOpportunity();
    private static APTS_Capture_LSO_Input_Config_Settings__c lodConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();
    private static APTS_LP_Local_Customer_Reference_Data__c ref  = createApttusLSOData();
    private static ERP_Reference_Data__c erpRefData  = createERPReferenceData();
    private static APTS_Master_Picklist_Table__c masterPicklistTable = createMaterPicklistTable();
    private static boolean isPerformAction = true;
    
    public static testMethod void selectLSO(){
        
        System.runAs(APTS_LP_TestUtility.getUser()){
            APTS_LP_TestUtility.getCommonConfigSetting();
            PageReference pageRef = Page.APTS_CaptureInputForLSOData;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('lsoid', ref.id);
            APTS_CaptureInputForLSODataController controller = new APTS_CaptureInputForLSODataController();
            controller.mapLSODataList = new Map<string,APTS_LP_Local_Customer_Reference_Data__c>();
            controller.mapLSODataList.put(ref.id,ref);
            controller.selectLSO();
            
        }
        
    }
    
    public static testMethod void onPageLoad(){
        
        System.runAs(APTS_LP_TestUtility.getUser()){
            
            PageReference pageRef = Page.APTS_CaptureInputForLSOData;
            Test.setCurrentPage(pageRef);
            APTS_LP_TestUtility.getCommonConfigSetting();
            ApexPages.currentPage().getParameters().put('id', acc.id);
            ApexPages.currentPage().getParameters().put('baseObject', 'Account');
            ApexPages.currentPage().getParameters().put('name', acc.name);
            ApexPages.currentPage().getParameters().put('type', 'GIS Approved');
            ApexPages.currentPage().getParameters().put('lsoid', ref.id);
            ApexPages.currentPage().getParameters().put('targetObject', 'Quotation');
            
            APTS_CaptureInputForLSODataController controller = new APTS_CaptureInputForLSODataController();
            controller.mapLSODataList = new Map<string,APTS_LP_Local_Customer_Reference_Data__c>();
            controller.mapLSODataList.put(ref.id,ref);
            controller.onPageLoad();
            
        }
        
    }
    
      public static testMethod void onPageLoad2(){
        
        System.runAs(APTS_LP_TestUtility.getUser()){
            
            PageReference pageRef = Page.APTS_CaptureInputForLSOData;
            Test.setCurrentPage(pageRef);
            APTS_LP_TestUtility.getCommonConfigSetting();
            ApexPages.currentPage().getParameters().put('lsoid', ref.id);
            ApexPages.currentPage().getParameters().put('targetObject','Quotation');
            ApexPages.currentPage().getParameters().put('id', opp.id);
            ApexPages.currentPage().getParameters().put('baseObject', 'Opportunity');
            ApexPages.currentPage().getParameters().put('name', opp.name);
            ApexPages.currentPage().getParameters().put('type', 'GIS Approved');
            APTS_CaptureInputForLSODataController controller = new APTS_CaptureInputForLSODataController();
           
            controller.mapLSODataList = new Map<string,APTS_LP_Local_Customer_Reference_Data__c>();
            controller.mapLSODataList.put(ref.id,ref);
            controller.onPageLoad();
            
        }
        
    }
    
    
    public static testMethod void controllerTestMethod() {

        APTS_LP_TestUtility.getCommonConfigSetting();
        ApexPages.currentPage().getParameters().put('id', acc.id);
        ApexPages.currentPage().getParameters().put('baseObject', 'Account');
        ApexPages.currentPage().getParameters().put('name', acc.name);
        ApexPages.currentPage().getParameters().put('type', 'GIS Approved');
        ApexPages.currentPage().getParameters().put('lsoid', ref.id);
        ApexPages.currentPage().getParameters().put('targetObject', 'Quotation');
        
        APTS_CaptureInputForLSODataController controller = new APTS_CaptureInputForLSODataController();
        controller.sQuotationFor= 'Account Customer';
        PageReference pageRef = Page.APTS_CaptureInputForLSOData;
        Test.setCurrentPage(pageRef);

        // Test.startTest();
        controller.onPageLoad();
        system.debug('MS TESt onPageLoad');
        
        if(isPerformAction)
            controller.bIsInputDataSectionVisible = true;
            controller.performNextAction();
            controller.getDistributionChannelList();
            controller.getSAPDivisionList();
            controller.getSalesOrganizationList();
         
         // Test.stopTest();
        
    }
    
    public static testMethod void controllerTestMethod2() {
        
        APTS_LP_TestUtility.getCommonConfigSetting();
        ApexPages.currentPage().getParameters().put('id', acc.id);
        ApexPages.currentPage().getParameters().put('baseObject', 'Account');
        ApexPages.currentPage().getParameters().put('name', acc.name);
        ApexPages.currentPage().getParameters().put('type', 'GIS Approved');
        ApexPages.currentPage().getParameters().put('targetObject', 'MSPA');
        // Test.startTest();
        APTS_CaptureInputForLSODataController controller=new APTS_CaptureInputForLSODataController();
        controller.sQuotationFor= 'Account Customer';
        PageReference pageRef = Page.APTS_CaptureInputForLSOData;
        Test.setCurrentPage(pageRef);
        
        controller.onPageLoad();
        SYstem.debug('MS TESt onPageLoad');
        if(isPerformAction)
            controller.performNextAction();
            controller.getDistributionChannelList();
            controller.getSAPDivisionList();
            controller.getSalesOrganizationList();
            // Test.stopTest();
    }
    
    public static testMethod void controllerTestMethod3() {

        APTS_LP_TestUtility.getCommonConfigSetting();
        ApexPages.currentPage().getParameters().put('id', opp.id);
        ApexPages.currentPage().getParameters().put('baseObject', 'Opportunity');
        ApexPages.currentPage().getParameters().put('name', opp.name);
        ApexPages.currentPage().getParameters().put('type', 'GIS Approved');
        ApexPages.currentPage().getParameters().put('targetObject', 'Opportunity');
        //Test.startTest();
        APTS_CaptureInputForLSODataController controller=new APTS_CaptureInputForLSODataController();
        controller.sQuotationFor= 'Account Customer';
        PageReference pageRef = Page.APTS_CaptureInputForLSOData;
        
        Test.setCurrentPage(pageRef);
        
        controller.onPageLoad();
        SYstem.debug('MS TESt onPageLoad');
        if(isPerformAction)
            controller.performNextAction();
            controller.getDistributionChannelList();
            controller.getSAPDivisionList();
            controller.getSalesOrganizationList();
        
        //Test.stopTest();
    }
    
     public static testMethod void controllerTestMethod5() {
        
         APTS_LP_TestUtility.getCommonConfigSetting();
        ApexPages.currentPage().getParameters().put('id', acc.id);
        ApexPages.currentPage().getParameters().put('baseObject', 'Account');
        ApexPages.currentPage().getParameters().put('name', acc.name);
        ApexPages.currentPage().getParameters().put('type', 'External Non-Buying Account');
        ApexPages.currentPage().getParameters().put('targetObject', 'Quotation');
        //Test.startTest();
        APTS_CaptureInputForLSODataController controller = new APTS_CaptureInputForLSODataController();
        controller.sQuotationFor= 'Account Customer';
        PageReference pageRef = Page.APTS_CaptureInputForLSOData;
        
        Test.setCurrentPage(pageRef);
        
        controller.onPageLoad();
        SYstem.debug('MS TESt onPageLoad');
        if(isPerformAction)
            controller.performNextAction();
        
        controller.setPageBlockSectionVisibility(false,false);
        controller.getAdditionalLSODataList();
        controller.navigateToPreviousPage();
        //Test.stopTest();
        
        
    }
    
    public static testMethod void controllerTestMethod4(){
        Test.startTest();
        User pu = createLPUser();
        isPerformAction = false;
        system.runAs(pu){
            
            
            controllerTestMethod();
            controllerTestMethod2();
            controllerTestMethod3();
            controllerTestMethod5();
            //controllerTestMethod6();
            
            opp.Account_Customer_LSO_Reference_Data__c = erpRefData.id;
            update opp;
            controllerTestMethod3();
            opp.Primary_Partner_LSO_Reference_Data__c =  erpRefData.id;
            update opp;
            APTS_LP_Local_Customer_Reference_Data__c refLP  = createApttusLSOData();
            controllerTestMethod();
            
            
        }
        
       
        Test.stopTest();
    }
    
      public static testMethod void controllerTestMethod6()
     {
          User pu = createLPUser();
        isPerformAction = false;
         pu.Division_DIV__c='LPP';
        update pu;
         system.runAs(pu){
            
            
            controllerTestMethod();
         
            opp.Account_Customer_LSO_Reference_Data__c = erpRefData.id;
            update opp;
            controllerTestMethod3();
            opp.Primary_Partner_LSO_Reference_Data__c =  erpRefData.id;
            update opp;
            APTS_LP_Local_Customer_Reference_Data__c refLP  = createApttusLSOData();
            controllerTestMethod();
            APTS_CaptureInputForLSODataController controller = new APTS_CaptureInputForLSODataController();
            controller.selectLSO();
            controller.onChangeQuotationFor();
            //wapperLSOLIst wapper = new wapperLSOLIst(9,refLP,'','','','','');
    
        }
    }
    
    private static User createLPUser(){
        
        Profile p;
        for(Profile prof : [Select Id, name from Profile]) {
            if(prof.name == 'System Administrator') {
                p = prof;
                break;
            }
        }
        String testemail = 'testuser@test.com';
        String uname  = 'testuser123456789@test.com';

        User pu = new User(profileId = p.id, username = uname, email = testemail, 
                           emailencodingkey = 'UTF-8', localesidkey = 'es_ES', 
                           languagelocalekey = 'es', timezonesidkey = 'Europe/Berlin', 
                           alias='cspu', lastname='lastname', Division_DIV__c='LP',CountryCode='ES');
        
        
        Database.insert(pu);
        
        return pu;
    }
    
    /**
    * Method to create test account.
    */
    private static Account createNewAccount() {
        
        acc = new Account();
        acc.Name = 'Test Account';
        acc.BillingCity = 'Barcelona';
        acc.BillingStreet = 'Some street in Barcelona';
        acc.BillingCountry = 'Spain';
        acc.BillingState = 'Barcelona';
        acc.BillingPostalCode = 'BRX12344';
        acc.Channel_Class__c= ''; 
        
        insert acc;
        
        return acc;
    }
    
    /**
    * Method to create Apttus LSO Data for account.
    */
    private static APTS_LP_Local_Customer_Reference_Data__c createApttusLSOData() {
        
        List<APTS_LP_Local_Customer_Reference_Data__c> refList = new List<APTS_LP_Local_Customer_Reference_Data__c>();
        
        ref = new APTS_LP_Local_Customer_Reference_Data__c();
        ref.APTS_LP_Account__c = acc.Id;
        ref.APTS_Country__c = 'ES';
        ref.APTS_LP_Distribution_Channel__c = 'BT';
        ref.APTS_LP_Incoterms__c = 'FOB';
        ref.APTS_LP_Local_Channel__c = 'Test Channel';
        ref.APTS_Payment_Terms__c = 'Test Term';
        ref.APTS_LP_Sales_Organisation__c = 'ABB';
        ref.APTS_LP_SAP_Customer_ID__c = '1234';
        ref.APTS_SAP_Division__c = 'ZZ';
        ref.APTS_External_ID__c = '1234ABBBT';

        insert ref;
        return ref;
      
    }
    
    private static APTS_Master_Picklist_Table__c createMaterPicklistTable() {
        
        masterPicklistTable = new APTS_Master_Picklist_Table__c();
        
        masterPicklistTable.APTS_Code_Used_For__c = 'Incoterm';
        masterPicklistTable.APTS_Code_Description__c = 'Franco a bordo';
        masterPicklistTable.APTS_Code__c='FOB';
        masterPicklistTable.APTS_Locale__c = 'es_ES';
        masterPicklistTable.name= masterPicklistTable.APTS_Code__c + ' - ' + masterPicklistTable.APTS_Code_Description__c;
        insert masterPicklistTable;
        return masterPicklistTable;
    }
    /**
     * Method to create ERP Reference data
     * 
     */
     private static ERP_Reference_Data__c createERPReferenceData() {
        
        erpRefData = new ERP_Reference_Data__c();
        erpRefData.Account__c = acc.Id;
        erpRefData.Country__c  = 'Spain';
        erpRefData.SAP_Sales_Organization__c = 'ABB';
        erpRefData.SAP_Division__c = 'ZZ';
        erpRefData.SAP_Distribution_Channel__c = 'BT';
        erpRefData.Local_Customer_ID__c = '1234';
        erpRefData.LSO__c = 'ES_LP';
        erpRefData.LBU__c = 'test code';
        
        insert erpRefData;
        return erpRefData;
     }
    
    /**
    * Method to create test opportunity.
    */
    private static Opportunity createNewOpportunity() {

        opp = new Opportunity();
        opp.Name = 'Test Optty';
        opp.Accountid = acc.id;
        opp.StageName = 'Negotiation1';
        opp.CloseDate = Date.today();
        opp.Channel_Class__c = acc.Channel_Class__c;
        
        insert opp;
        
        return opp;
    }
    
   

}