@istest (SeeAllData = False)
public class clsOpportunity_OppScrning_Test {

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
    
Private Static testmethod void ClsTriggerOpportunityScreeningHandler_Test(){

    ABB_Location__c ABBloc = new ABB_Location__c();
    ABBloc.Company__c = 'USPON';
    ABBloc.BU__c = 'DMPC-Power Conversion';
    ABBloc.Product_Group__c = '4107 - Solar';
    ABBloc.Country__c = 'Spain';    
    insert ABBloc;
    
    Product_Group__c pg = createTestProductgroupFT();        
    insert pg;
    
    LBU_Code__c lbu = createTestLBUCode();       
    insert lbu;
    
    Account Acc = createTestAccount();
    insert Acc;
    
    Contact con = createTestContact(Acc.id);        
    insert con;
    
    Safe_Island_Assessments__c SFA = new Safe_Island_Assessments__c();
    SFA.AccountCustomer__c = Acc.Id;     
    SFA.Country__c = 'Spain';
    SFA.PG__c = PG.Id;          
    insert SFA;
    
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
    oppy.Local_Business_Unit__c = lbu.id;
    oppy.Local_Product_Group__c = pg.id;
    oppy.Primary_Contact__c = con.Id; 
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
    insert oppy;
    
    Map<String, Schema.RecordTypeInfo> oPP_SCREENING_RECORD_TYPES = Schema.SObjectType.Opportunity_Screening__c.getRecordTypeInfosByName();
    String oPP_SCREENING_GATE1_ID = oPP_SCREENING_RECORD_TYPES.get(Label.System_CL00085).getRecordTypeId();
    String oPP_SCREENING_GATE2_ID = oPP_SCREENING_RECORD_TYPES.get(Label.System_CL00086).getRecordTypeId();
    String oPP_SCREENING_GATE3_ID = oPP_SCREENING_RECORD_TYPES.get(Label.System_CL00087).getRecordTypeId();
        
    Opportunity_Screening__c OPS = new Opportunity_Screening__c();    
    OPS.Opportunity__c = oppy.Id;
    OPS.Recordtypeid = oPP_SCREENING_GATE1_ID;  
    OPS.Gate_Status__c = 'BID';
    insert OPS;
    OPS.IsApproved__c = true;
    update OPS;
    
    Test.StartTest();
    Opportunity_Screening__c OPS1 = new Opportunity_Screening__c();    
    OPS1.Opportunity__c = oppy.Id;
    OPS1.Recordtypeid = oPP_SCREENING_GATE2_ID; 
    OPS1.Gate_Status__c = 'NO BID';
    insert OPS1;
    OPS1.IsApproved__c = true;
    update OPS1;
    Test.StopTest();
}   

Private Static testmethod void ClsTriggerOpportunityHandler_Test(){   

    ABB_Location__c ABBloc = new ABB_Location__c();
    ABBloc.Company__c = 'USPON';
    ABBloc.BU__c = 'DMPC-Power Conversion';
    ABBloc.Product_Group__c = '4107 - Solar';
    insert ABBloc;
    
    Product_Group__c pg = createTestProductgroupFT();        
    insert pg;
    
    LBU_Code__c lbu = createTestLBUCode();       
    insert lbu;
    
    
    Account Acc1 = createTestAccount();
    insert Acc1;
    
    Contact con1 = createTestContact(Acc1.id);        
    insert con1;
    
    Opportunity oppy = new Opportunity();
    oppy.AccountId = Acc1.Id;
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
    
    // To cover indicator status in Opportunity Handler class
        Test.startTest();   
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Name = 'sdjinbosetssss';
        insert acc;
        
        Contact con = ClsTestHelp.createTestContacts();
        con.LastName = 'testddsssdd';
        con.AccountId = acc.Id;
        con.Email_Opt_Out__c = false;
        con.Preferred_Contact_Method__c = 'Email';
        insert con;
        
        End_User_PRoject__c eup = new End_User_PRoject__c();
        eup.Name = 'TEST EUP1';
        eup.Account_End_User__c = acc.id;
        insert eup;
        
        End_User_PRoject__c eup2 = new End_User_PRoject__c();
        eup2.Name = 'TEST EUP2';
        eup2.Account_End_User__c = acc.id;
        insert eup2;
        
        Capture_Team__c ct = new Capture_Team__c();
        ct.name = 'CT Name1';
        ct.End_User_PRoject__c = eup.id;
        
        Opportunity oppy1 = new Opportunity();
        oppy1.AccountId = acc.Id;
        oppy1.Name = 'TestOpportunity1';
        oppy1.StageName = 'Negotiation';
        oppy1.CloseDate = system.today();
        oppy1.Product_Group__c = pg.Id;
        oppy1.Opportunity_Value__c = 10000;
        oppy1.Actual_Bid_Submission_Date_Comm__c = system.today();
        oppy1.Actual_Bid_Submission_Date_Tech__c = system.today();
        oppy1.Requested_Bid_Submission_Date_Comm__c = system.today();
        oppy1.Requested_Bid_Submission_Date_Tech__c = system.today();
        oppy1.BU__c ='DMDR';
        oppy1.Application__c='AP.301 - Automatic Gate, Beam, Barrier or Door';
        oppy1.Description__c='Test Description';
        oppy1.ABB_Domain__c='DMDR';
        oppy1.Business_Line__c='BL.401 - Packaging';
        oppy1.Channel_Class_Level1__c='ABBINT - Internal ABB Sales';
        oppy1.Channel_Class_Level2__c='ALCEN - ABB Logistic Centre';
        oppy1.ABB_Industry_Usage_Level1__c='BLD - Building';
        oppy1.ABB_Industry_Usage_Level2__c='BLD.9 - Commercial & institutional Buildings';
        oppy1.ABB_Industry_Usage_Level3__c='BLD.9.1 - HVAC (Commercial Buildings)';
        oppy1.Local_Business_Unit__c = lbu.id;
        oppy1.Local_Product_Group__c = pg.id;
        oppy1.Primary_Contact__c = con.Id; 
        oppy1.Opportunity_Value__c = 18646;
        oppy1.End_User_PRoject__c = eup.id;
        oppy1.ABB_Location__c = ABBloc.id;
        
        Opportunity oppy3 = new Opportunity();
        oppy3.Target__c = true;
        oppy3.AccountId = acc.Id;
        oppy3.Name = 'TestOpportunity3';
        oppy3.StageName = 'Negotiation';
        oppy3.CloseDate = system.today();
        oppy3.Product_Group__c = pg.Id;
        oppy3.Opportunity_Value__c = 10000;
        oppy3.Actual_Bid_Submission_Date_Comm__c = system.today();
        oppy3.Actual_Bid_Submission_Date_Tech__c = system.today();
        oppy3.Requested_Bid_Submission_Date_Comm__c = system.today();
        oppy3.Requested_Bid_Submission_Date_Tech__c = system.today();
        oppy3.BU__c ='DMDR';
        oppy3.Application__c='AP.301 - Automatic Gate, Beam, Barrier or Door';
        oppy3.Description__c='Test Description';
        oppy3.ABB_Domain__c='DMDR';
        oppy3.Business_Line__c='BL.401 - Packaging';
        oppy3.Channel_Class_Level1__c='ABBINT - Internal ABB Sales';
        oppy3.Channel_Class_Level2__c='ALCEN - ABB Logistic Centre';
        oppy3.ABB_Industry_Usage_Level1__c='BLD - Building';
        oppy3.ABB_Industry_Usage_Level2__c='BLD.9 - Commercial & institutional Buildings';
        oppy3.ABB_Industry_Usage_Level3__c='BLD.9.1 - HVAC (Commercial Buildings)';
        oppy3.Local_Business_Unit__c = lbu.id;
        oppy3.Local_Product_Group__c = pg.id;
        oppy3.Primary_Contact__c = con.Id; 
        oppy3.Opportunity_Value__c = 5000002;
        oppy3.End_User_PRoject__c = eup.id;
        oppy3.ABB_Location__c = ABBloc.id;
            
        
        List<opportunity> insOpportunity = new list<opportunity>();
        insOpportunity.add(oppy);
        insOpportunity.add(oppy3);
        insOpportunity.add(oppy1);
        insert insOpportunity;     
        Test.stopTest();
        Map<String, Schema.RecordTypeInfo> oPP_SCREENING_RECORD_TYPES = Schema.SObjectType.Opportunity_Screening__c.getRecordTypeInfosByName();
        String oPP_SCREENING_GATE1_ID = oPP_SCREENING_RECORD_TYPES.get(Label.System_CL00085).getRecordTypeId();
                    
        Opportunity_Screening__c OPS = new Opportunity_Screening__c();    
        OPS.Opportunity__c = oppy3.Id;
        OPS.Recordtypeid = oPP_SCREENING_GATE1_ID;  
        OPS.Gate_Status__c = 'BID';
        insert OPS;
        OPS.IsApproved__c = true;
        update OPS;
    }
    
    Private Static testmethod void ClsTriggerOpportunityHandler1_Test(){   
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Name = 'sdjinbosetssss';
        insert acc;
        
        Contact con = ClsTestHelp.createTestContacts();
        con.LastName = 'testddsssdd';
        con.AccountId = acc.Id;
        con.Email_Opt_Out__c = false;
        con.Preferred_Contact_Method__c = 'Email';
        insert con;
        
        Product_Group__c pg = createTestProductgroupFT();        
        insert pg;
        
        End_User_PRoject__c eup = new End_User_PRoject__c();
        eup.Name = 'TEST EUP1';
        eup.Account_End_User__c = acc.id;
        insert eup;
        
        End_User_PRoject__c eup2 = new End_User_PRoject__c();
        eup2.Name = 'TEST EUP2';
        eup2.Account_End_User__c = acc.id;
        insert eup2;
        
        Capture_Team__c ct = new Capture_Team__c();
        ct.name = 'CT Name1';
        ct.End_User_PRoject__c = eup.id;
        
        LBU_Code__c lbu = createTestLBUCode();       
        insert lbu;
        
        Opportunity oppy2 = new Opportunity();
        oppy2.Target__c = true;
        oppy2.AccountId = acc.Id;
        oppy2.Name = 'TestOpportunity2';
        oppy2.StageName = 'Negotiation';
        oppy2.CloseDate = system.today();
        oppy2.Product_Group__c = pg.Id;
        oppy2.Opportunity_Value__c = 10000;
        oppy2.Actual_Bid_Submission_Date_Comm__c = system.today();
        oppy2.Actual_Bid_Submission_Date_Tech__c = system.today();
        oppy2.Requested_Bid_Submission_Date_Comm__c = system.today();
        oppy2.Requested_Bid_Submission_Date_Tech__c = system.today();
        oppy2.BU__c ='DMDR';
        oppy2.Application__c='AP.301 - Automatic Gate, Beam, Barrier or Door';
        oppy2.Description__c='Test Description';
        oppy2.ABB_Domain__c='DMDR';
        oppy2.Business_Line__c='BL.401 - Packaging';
        oppy2.Channel_Class_Level1__c='ABBINT - Internal ABB Sales';
        oppy2.Channel_Class_Level2__c='ALCEN - ABB Logistic Centre';
        oppy2.ABB_Industry_Usage_Level1__c='BLD - Building';
        oppy2.ABB_Industry_Usage_Level2__c='BLD.9 - Commercial & institutional Buildings';
        oppy2.ABB_Industry_Usage_Level3__c='BLD.9.1 - HVAC (Commercial Buildings)';
        oppy2.Local_Business_Unit__c = lbu.id;
        oppy2.Local_Product_Group__c = pg.id;
        oppy2.Primary_Contact__c = con.Id; 
        oppy2.Opportunity_Value__c = 15000002;
        oppy2.End_User_PRoject__c = eup.id;
    
        Opportunity oppy4 = new Opportunity();
        oppy4.Target__c = true;
        oppy4.AccountId = acc.Id;
        oppy4.Name = 'TestOpportunity4';
        oppy4.StageName = 'Negotiation';
        oppy4.CloseDate = system.today();
        oppy4.Product_Group__c = pg.Id;
        oppy4.Opportunity_Value__c = 10000;
        oppy4.Actual_Bid_Submission_Date_Comm__c = system.today();
        oppy4.Actual_Bid_Submission_Date_Tech__c = system.today();
        oppy4.Requested_Bid_Submission_Date_Comm__c = system.today();
        oppy4.Requested_Bid_Submission_Date_Tech__c = system.today();
        oppy4.BU__c ='DMDR';
        oppy4.Application__c='AP.301 - Automatic Gate, Beam, Barrier or Door';
        oppy4.Description__c='Test Description';
        oppy4.ABB_Domain__c='DMDR';
        oppy4.Business_Line__c='BL.401 - Packaging';
        oppy4.Channel_Class_Level1__c='ABBINT - Internal ABB Sales';
        oppy4.Channel_Class_Level2__c='ALCEN - ABB Logistic Centre';
        oppy4.ABB_Industry_Usage_Level1__c='BLD - Building';
        oppy4.ABB_Industry_Usage_Level2__c='BLD.9 - Commercial & institutional Buildings';
        oppy4.ABB_Industry_Usage_Level3__c='BLD.9.1 - HVAC (Commercial Buildings)';
        oppy4.Local_Business_Unit__c = lbu.id;
        oppy4.Local_Product_Group__c = pg.id;
        oppy4.Primary_Contact__c = con.Id; 
        oppy4.Opportunity_Value__c = 15000002;
        oppy4.End_User_PRoject__c = eup2.id;
        
        Opportunity oppy5 = new Opportunity();
        oppy5.Target__c = true;
        oppy5.AccountId = acc.Id;
        oppy5.Name = 'TestOpportunity5';
        oppy5.StageName = 'Negotiation';
        oppy5.CloseDate = system.today();
        oppy5.Product_Group__c = pg.Id;
        oppy5.Opportunity_Value__c = 10000;
        oppy5.Actual_Bid_Submission_Date_Comm__c = system.today();
        oppy5.Actual_Bid_Submission_Date_Tech__c = system.today();
        oppy5.Requested_Bid_Submission_Date_Comm__c = system.today();
        oppy5.Requested_Bid_Submission_Date_Tech__c = system.today();
        oppy5.BU__c ='DMDR';
        oppy5.Application__c='AP.301 - Automatic Gate, Beam, Barrier or Door';
        oppy5.Description__c='Test Description';
        oppy5.ABB_Domain__c='DMDR';
        oppy5.Business_Line__c='BL.401 - Packaging';
        oppy5.Channel_Class_Level1__c='ABBINT - Internal ABB Sales';
        oppy5.Channel_Class_Level2__c='ALCEN - ABB Logistic Centre';
        oppy5.ABB_Industry_Usage_Level1__c='BLD - Building';
        oppy5.ABB_Industry_Usage_Level2__c='BLD.9 - Commercial & institutional Buildings';
        oppy5.ABB_Industry_Usage_Level3__c='BLD.9.1 - HVAC (Commercial Buildings)';
        oppy5.Local_Business_Unit__c = lbu.id;
        oppy5.Local_Product_Group__c = pg.id;
        oppy5.Primary_Contact__c = con.Id; 
        oppy5.Opportunity_Value__c = 5000002;
        oppy5.End_User_PRoject__c = eup2.id;
                
        insert oppy2;
        Test.starttest();       
        insert oppy4;
        insert oppy5; 
        Test.stoptest();
    
    
    }
    
    
}