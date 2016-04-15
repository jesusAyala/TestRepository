/**
*  This test class used to test class OpportunityTimeLineCTR.
*
@author Jinbo Shan
@created 2015-03-26
@version 1.0   
@since 30.0
*
@changelog
* coverage 88% 
* 
* 
2015-03-26 Jinbo Shan <jinbo.shan@itbconsult.com>
* - Created
*/
@isTest
private class OpportunityTimeLineCTR_Test {

    public static LBU_Code__c createTestLBUCode() {
        LBU_Code__c lbu = new LBU_Code__c();
        lbu.Name = 'test';
        lbu.BU__c = 'test';
        lbu.Division__c = 'DM';       
        return lbu;
    }

    static testMethod void myUnitTest() {
        
        OpportunityStages__c os1 = ClsTestHelp.createTestpportunityStages1();
        OpportunityStages__c os2 = ClsTestHelp.createTestpportunityStages2();
        OpportunityStages__c os3 = ClsTestHelp.createTestpportunityStages3();
        
        CustomerBuyingPath__c cbp1 = ClsTestHelp.createTestCustomerBuyingPath1();
        CustomerBuyingPath__c cbp2 = ClsTestHelp.createTestCustomerBuyingPath2();
        
        // TO DO: implement unit test
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Name = 'sdjinbosetsss';
        insert acc;
        
        Contact con = ClsTestHelp.createTestContacts();
        con.Active__c = true;
        con.LastName = 'testdsssddsdsf';
        con.AccountId = acc.Id;
        con.Preferred_Contact_Method__c = 'Email';
        con.Email_Opt_Out__c = false;
        insert con;
        
        Product_Group__c pg = new Product_Group__c();
        pg.Business_Unit__c = 'tdsd';
        pg.Name = 'jinboestspro';
        pg.Division__c = '10';
        insert pg;
        
        LBU_Code__c lbu = createTestLBUCode();       
        insert lbu;
        
        Opportunity oppy = new Opportunity();
        oppy.AccountId = acc.Id;
        oppy.Primary_Contact__c = con.Id; 
        oppy.Name = 'Testoppysqsss';
        oppy.StageName = 'Negotiation';
        oppy.CloseDate = system.today();
        oppy.Actual_Bid_Submission_Date_Comm__c = system.today() -1;
        oppy.Actual_Bid_Submission_Date_Tech__c = system.today() -1;
        oppy.Product_Group__c = pg.Id;
        oppy.Opportunity_Value__c = 18646;
        oppy.Requested_Bid_Submission_Date_Comm__c = system.today() -1;
        oppy.Requested_Bid_Submission_Date_Tech__c = system.today() -1;
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
        insert oppy;
        
        Test.startTest();
        PageReference pageRef = Page.OpenPopup;
        Test.setCurrentPage(pageRef);
        Apexpages.currentPage().getParameters().put('id',oppy.Id);
        Apexpages.currentPage().getParameters().put('opptyId',oppy.Id);
        
        ApexPages.Standardcontroller stdCtrl = new ApexPages.Standardcontroller(oppy);
        
        //stdCtrl.addFields(new list<string>{'StageName','RecordType.DeveloperName','isClosed','isWon', 'Customer_Buying_Path__c'});
        
        OpportunityTimeLineCTR ext = new OpportunityTimeLineCTR(stdCtrl);
        OpportunityTimeLineCTR ext1 = new OpportunityTimeLineCTR();
        
        boolean showapproval = ext.getShowApproval();
        string currentcbp = ext.getCurrentCustomerBuyingPath();
        string currentStage = ext.getCurrentStage();
        List<String> list_scbps = ext.getSortedCustomerBuyingPaths();
        List<String> list_sstages = ext.getSortedStages();
        
        ext.setStage('Closed Cancelled');
        String s=ext.getStage();
        List<SelectOption> selectList=ext.getItems();
        Pagereference p=ext.goBack();
        Pagereference p1=ext.confirm();
        ext.setStage('Closed Lost Without ABB Bid');
        Pagereference p2=ext.confirm();
        ext.setStage('Closed Lost');
        Pagereference p3=ext.confirm();
        ext.setStage('Closed Won');
        Pagereference p4=ext.confirm();
        
        Test.stopTest();
    }
}