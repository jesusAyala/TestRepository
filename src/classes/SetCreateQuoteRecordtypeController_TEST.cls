/**
*  This test class used to SetCreateQuoteRecordtypeController.
*
@author Rajesh Kaliyaperumal    
@created 2015-09-7
@version 1.0  
* 
*/
@isTest
private class SetCreateQuoteRecordtypeController_TEST {
    public static Account createTestAccount() {
        Account acc = new Account();    
        acc.Name = 'Test1';
        acc.BillingStreet = 'dajie';
        acc.BillingCity = 'berlin';
        acc.BillingState = 'Berlin';
        acc.BillingPostalCode = '20012';
        acc.BillingCountry = 'Germany';
        return acc;
    }
     public static User createTestUsers() {
        User u = new User();
        u.FirstName ='haobo';
        u.LastName = 'song';
        u.Username = 'tv@test123.com.prod';
        u.Alias = 'mtst';
        u.Email = 'mtester@company.com';
        u.CommunityNickname = u.Alias;
        u.ProfileId = [Select Id from Profile Where Name = 'Systemadministrator' OR Name = 'System Administrator' limit 1].Id;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.ManagerId = UserInfo.getUserId();
        u.Division_DIV__c = 'DM';
        return u;
    }
    public static User createTestUsers2() {
        User u = new User();
        u.FirstName ='haobo';
        u.LastName = 'song';
        u.Username = 'tv@test1234.com.prod';
        u.Alias = 'mtste';
        u.Email = 'mtester@company.com';
        u.CommunityNickname = u.Alias;
        u.ProfileId = [Select Id from Profile Where Name = 'Systemadministrator' OR Name = 'System Administrator' limit 1].Id;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.ManagerId = UserInfo.getUserId();
        u.Division_DIV__c = 'PL';
        return u;
    }
   
    public static Contact createTestContact() {
        account acc = createTestAccount();
        acc.Name='Test111';
        acc.BillingStreet = 'dajie123';
        acc.BillingCity = 'berlin123';
        acc.BillingState = 'Berlin';
        acc.BillingPostalCode = '200123';
        insert acc;
        Contact con = ClsTestHelp.createTestContacts();
        con.LastName = 'testContact';
        con.AccountId = acc.Id;
        con.Email_Opt_Out__c = false;
        con.Preferred_Contact_Method__c = 'Email';
        return con;
    }
    public static Product_Group__c createTestProductgroupFT() {
        Product_Group__c pg = new Product_Group__c();
        pg.Business_Unit__c = 'tdsd';
        pg.Name = '13333';
        pg.Opportunity_Default_Type__c = 'Fast Track';
        pg.Opportunity_Threshold__c = 100;
        pg.Division__c = 'DM';        
        return pg;
    }
    public static LBU_Code__c createTestLBUCode() {
        LBU_Code__c lbu = new LBU_Code__c();
        lbu.Name = 'test';
        lbu.BU__c = 'test';
        lbu.Division__c = 'DM';       
        return lbu;
    }
    static testMethod void SetCreateQuoteRecordtypeController1() {      
        Map<String, Schema.RecordTypeInfo> OPPORTUNITY_RECORD_TYPES = Schema.SObjectType.Opportunity.getRecordTypeInfosByName();
        String OPP_FASTTRACK_RECORD_TYPE_ID = OPPORTUNITY_RECORD_TYPES.get(System.label.Opportunity_RecordType_FastTrack).getRecordTypeId();
        
        Account acc = createTestAccount();
        acc.Name='Test11122';
        acc.BillingStreet = 'dajie23';
        acc.BillingCity = 'berlin23';
        acc.BillingState = 'Berlin';
        acc.BillingPostalCode = '2002312';
        insert acc;
        
        Account acc22 = createTestAccount();
        acc22.Name='Test11112';
        acc22.BillingStreet = 'dajie12312';
        acc22.BillingCity = 'berlin12312';
        acc22.BillingState = 'Berlin';
        acc22.BillingPostalCode = '20012312';
        insert acc22;
        Contact con1 = ClsTestHelp.createTestContacts();
        con1.LastName = 'testContact12';
        con1.AccountId = acc22.Id;
        con1.Email_Opt_Out__c = false;
        con1.Preferred_Contact_Method__c = 'Email';
        insert con1;
        
        Product_Group__c pg = createTestProductgroupFT();        
        insert pg;
        
        LBU_Code__c lbu = createTestLBUCode();       
        insert lbu;
        
        Opportunity oppy = new Opportunity();
        oppy.AccountId = acc.Id;
        oppy.Name = 'TestOpportunity';
        oppy.StageName = 'Negotiation';
        oppy.CloseDate = system.today();
        oppy.Product_Group__c = pg.Id;
        oppy.Opportunity_Value__c = 10000;
        oppy.Actual_Bid_Submission_Date_Comm__c = system.today();
        oppy.Actual_Bid_Submission_Date_Tech__c = system.today();
        oppy.Requested_Bid_Submission_Date_Comm__c = system.today();
        oppy.Requested_Bid_Submission_Date_Tech__c = system.today();
        oppy.BU__c ='DMDR';
        oppy.Application__c='AP.301 - Automatic Gate, Beam, Barrier or Door';
        oppy.Description__c='Test Description';
        oppy.ABB_Domain__c='DMDR';
        oppy.Business_Line__c='BL.401 - Packaging';
        oppy.Channel_Class_Level1__c='ABBINT - Internal ABB Sales';
        oppy.Channel_Class_Level2__c='ALCEN - ABB Logistic Centre';
        oppy.ABB_Industry_Usage_Level1__c='BLD - Building';
        oppy.ABB_Industry_Usage_Level2__c='BLD.9 - Commercial & institutional Buildings';
        oppy.ABB_Industry_Usage_Level3__c='BLD.9.1 - HVAC (Commercial Buildings)';
        oppy.Local_Business_Unit__c = lbu.id;
        oppy.Local_Product_Group__c = pg.id;
        oppy.Primary_Contact__c = con1.Id; 
        insert oppy;
        
        //ApexPages.StandardController sc = new ApexPages.StandardController(oppy);
        //OpportunitysetRecordtypeController  objopp = new OpportunitysetRecordtypeController(sc);
        //objopp.changeRecordtype(); 
        
        Apttus_Proposal__Proposal__c objproposal = new Apttus_Proposal__Proposal__c();
        ApexPages.StandardController sc1 = new ApexPages.StandardController(objproposal);      
       
        ApexPages.currentPage().getParameters().put('opportunityNumber','OPP-1233');
        CanvasController objcanvas = new CanvasController(sc1);
        objcanvas.getcParameters();
    }
    
    static testMethod void SetCreateQuoteRecordtypeController2() {      
        Map<String, Schema.RecordTypeInfo> OPPORTUNITY_RECORD_TYPES = Schema.SObjectType.Opportunity.getRecordTypeInfosByName();
        String OPP_FASTTRACK_RECORD_TYPE_ID = OPPORTUNITY_RECORD_TYPES.get(System.label.Opportunity_RecordType_FastTrack).getRecordTypeId();
        
        Account acc = createTestAccount();
        acc.Name='Test111234121';
        acc.BillingStreet = 'dajie2323';
        acc.BillingCity = 'berlin22343';
        acc.BillingState = 'Berlin';
        acc.BillingPostalCode = '200232341212';
        insert acc;
        
        Contact con = createTestContact();   
        con.LastName='Test11341';   
        insert con;
        
        Product_Group__c pg = createTestProductgroupFT();        
        insert pg;
        
        LBU_Code__c lbu = createTestLBUCode(); 
        lbu.Name='Test111';         
        insert lbu;
        
        User u = createTestUsers();
        insert u;
        User u2 = createTestUsers2();
        insert u2;
        
        Opportunity oppy = new Opportunity();
        oppy.AccountId = acc.Id;
        oppy.Name = 'TestOpportunity123';
        oppy.StageName = 'Negotiation';
        oppy.CloseDate = system.today();
        oppy.Product_Group__c = pg.Id;
        oppy.Opportunity_Value__c = 10000;
        oppy.Actual_Bid_Submission_Date_Comm__c = system.today();
        oppy.Actual_Bid_Submission_Date_Tech__c = system.today();
        oppy.Requested_Bid_Submission_Date_Comm__c = system.today();
        oppy.Requested_Bid_Submission_Date_Tech__c = system.today();
        oppy.BU__c ='DMDR';
        oppy.Application__c='AP.301 - Automatic Gate, Beam, Barrier or Door';
        oppy.Description__c='Test Description';
        oppy.ABB_Domain__c='DMDR';
        oppy.Business_Line__c='BL.401 - Packaging';
        oppy.Channel_Class_Level1__c='ABBINT - Internal ABB Sales';
        oppy.Channel_Class_Level2__c='ALCEN - ABB Logistic Centre';
        oppy.ABB_Industry_Usage_Level1__c='BLD - Building';
        oppy.ABB_Industry_Usage_Level2__c='BLD.9 - Commercial & institutional Buildings';
        oppy.ABB_Industry_Usage_Level3__c='BLD.9.1 - HVAC (Commercial Buildings)';
        oppy.Local_Business_Unit__c = lbu.id;
        oppy.Local_Product_Group__c = pg.id;
        oppy.Primary_Contact__c = con.Id; 
        insert oppy;
        
        Apttus_Proposal__Proposal__c objproposal = new Apttus_Proposal__Proposal__c();
        ApexPages.StandardController sc = new ApexPages.StandardController(objproposal);
        
        ApexPages.currentPage().getParameters().put('quotationNumber','234324');
        ApexPages.currentPage().getParameters().put('opportunityNumber','OPP-1233');
        CanvasController objcanvas = new CanvasController(sc);
        objcanvas.getcParameters();
        
        System.runAs(u) {
            ApexPages.currentPage().getParameters().put('id',acc.id);
            SetCreateQuoteRecordtypeController objQuote = new SetCreateQuoteRecordtypeController();
            objQuote.redirect();
        }
        System.runAs(u) {
            ApexPages.currentPage().getParameters().put('id',oppy.id);
            SetCreateQuoteRecordtypeController objQuote = new SetCreateQuoteRecordtypeController();
            objQuote.redirect();
        }
        System.runAs(u2) {
            ApexPages.currentPage().getParameters().put('id',acc.id);
            SetCreateQuoteRecordtypeController objQuote = new SetCreateQuoteRecordtypeController();
            objQuote.redirect();
        }
        System.runAs(u2) {
            ApexPages.currentPage().getParameters().put('id',oppy.id);
            SetCreateQuoteRecordtypeController objQuote = new SetCreateQuoteRecordtypeController();
            objQuote.redirect();
        }
        
    }
    static testMethod void canvascontroller() {      
        Apttus_Proposal__Proposal__c objproposal = new Apttus_Proposal__Proposal__c();
        ApexPages.StandardController sc = new ApexPages.StandardController(objproposal);
        CanvasController objcanvas = new CanvasController(sc);
        objcanvas.getcParameters();
    }
}