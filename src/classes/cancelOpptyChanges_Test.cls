/**************************************************************************
Author      :  Sajila Kadayaprath
Description :  Test class for cancelOpptyChanges
*****************************************************************************/
@isTest
private class cancelOpptyChanges_Test{
    private static testMethod void cancelOpptyTest(){
        
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
        
        LBU_Code__c lbu = new LBU_Code__c();
        lbu.Name = 'test';
        lbu.BU__c = 'test';
        lbu.Division__c = 'DM';         
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
        PageReference pageRef = Page.Cancel_Oppty_Record_Type_change;
        Test.setCurrentPage(pageRef);
        Apexpages.currentPage().getParameters().put('id',oppy.Id);
        Apexpages.currentPage().getParameters().put('StageName','Closed Won');
        Apexpages.currentPage().getParameters().put('Sales_Pursuit_Progress__c','Opportunity Is Captured');
        //String s=oppy.CloseDate;
        Apexpages.currentPage().getParameters().put('CloseDate',String.valueOf(oppy.CloseDate));
        //ApexPages.StandardController sc = new ApexPages.StandardController(oppy);
        cancelOpptyChanges c=new cancelOpptyChanges();
        PageReference p=c.revertOpptyRecrdType();
        PageReference p1=c.back();
        Test.stopTest();
    }
}