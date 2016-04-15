@istest (SeeAllData = False)
public class clsOpportunityScreeningChart_Test {

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

public static Contact createTestContact(String accid) {       
        Contact con = ClsTestHelp.createTestContacts();
        con.LastName = 'testContact';
        con.AccountId = accid;
        con.Email_Opt_Out__c = false;
        con.Preferred_Contact_Method__c = 'Email';
        return con;
}


public static Product_Group__c createTestProductgroupFT() {
        Product_Group__c pg = new Product_Group__c();
        pg.Business_Unit__c = 'DMPC';
        pg.Name = '4107';
        pg.Opportunity_Default_Type__c = 'Fast Track';
        pg.Opportunity_Threshold__c = 100;
        pg.Division__c = 'DM';        
        return pg;
}
    
public static LBU_Code__c createTestLBUCode() {
        LBU_Code__c lbu = new LBU_Code__c();
        lbu.Name = 'USPON-DMPC';
        lbu.BU__c = 'DMPC';
        lbu.Division__c = 'DM';       
        return lbu;
}
        
Private Static testmethod void clsOpportunityScreeningChart_Test(){   


    Account Acc = createTestAccount();
    insert Acc;
    
    Contact con = createTestContact(Acc.id);        
    insert con;
    
    Product_Group__c pg = createTestProductgroupFT();        
    insert pg;
    
    LBU_Code__c lbu = createTestLBUCode();       
    insert lbu;
     
    Opportunity oppy = new Opportunity();
    oppy.AccountId = Acc.Id;
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
    oppy.Primary_Contact__c = con.Id; 
    insert oppy;

    Opportunity_Screening__c OPS = new Opportunity_Screening__c();    
    OPS.Opportunity__c = oppy.Id;
    
    insert OPS; 
    
    ApexPages.currentPage().getParameters().put('Id', OPS.Id);        
    
    ApexPages.StandardController OPPScrn = new ApexPages.StandardController(OPS);
    clsOpportunityScreeningChart objController  =  new clsOpportunityScreeningChart(OPPScrn);    
    
    objController.getPieData();
    
    clsOpportunityScreeningChart.Item[] itm = objController.data;
    
    }
    
    Private Static testmethod void clsOpportunityScreeningChartG2_Test(){  
    
    Account Acc = createTestAccount();
    insert Acc;
    
    Contact con = createTestContact(Acc.id);        
    insert con;
    
    Product_Group__c pg = createTestProductgroupFT();        
    insert pg;
    
    LBU_Code__c lbu = createTestLBUCode();       
    insert lbu;
    
    Opportunity oppy = new Opportunity();
    oppy.AccountId = Acc.Id;
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
    oppy.Primary_Contact__c = con.Id; 
    insert oppy;

    Opportunity_Screening__c OPS = new Opportunity_Screening__c();    
    OPS.Opportunity__c = oppy.Id;
    
    insert OPS; 
    
    ApexPages.currentPage().getParameters().put('Id', OPS.Id);        
    
    ApexPages.StandardController OPPScrn = new ApexPages.StandardController(OPS);
    clsOpportunityScreeningChartG2 objController  =  new clsOpportunityScreeningChartG2(OPPScrn);    
    
    objController.getPieData();
    
    }
    
    Private Static testmethod void clsOpportunityScreeningChartG1_Test(){  
    
    Account Acc = createTestAccount();
    insert Acc;
    
    Contact con = createTestContact(Acc.id);        
    insert con;
    
    Product_Group__c pg = createTestProductgroupFT();        
    insert pg;
    
    LBU_Code__c lbu = createTestLBUCode();       
    insert lbu;
    
    Opportunity oppy = new Opportunity();
    oppy.AccountId = Acc.Id;
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
    oppy.Primary_Contact__c = con.Id; 
    insert oppy;

    Opportunity_Screening__c OPS = new Opportunity_Screening__c();    
    OPS.Opportunity__c = oppy.Id;
    
    insert OPS; 
    
    ApexPages.currentPage().getParameters().put('Id', OPS.Id);        
    
    ApexPages.StandardController OPPScrn = new ApexPages.StandardController(OPS);
    clsOpportunityScreeningChartG1 objController  =  new clsOpportunityScreeningChartG1(OPPScrn);    
    
    objController.getPieData();
    
    }
    
    
    
}