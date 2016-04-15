/**
 * ApexClass -  Test class ClsTriggerBudgetOpp_Test
 * Release R5
 * @author  Indhu Ramalingam (Accenture)
 * @created 2016-03-22
 * @version 1.0
 * Description: Test class for - ClsTriggerBudgetOpp
 * Created 
 */
 @isTest
private class ClsTriggerBudgetOpp_Test{
    public static User createTestUser1() {
        User u = new User();
        u.FirstName ='haobo';
        u.LastName = 'song';
        u.Username = 'test123ABB1237@test123ABB1237.com';
        u.Alias = 'mtst4';
        u.Email = 'mtester1@company.com';
        u.CommunityNickname = u.Alias;
        u.ProfileId = [Select Id from Profile Where Name = 'ABB Sales Standard Profile' limit 1].Id;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.ManagerId = UserInfo.getUserId();
        return u;
    }

    public static Account createAccount1(){
        Account a = new Account();
        a.Name = 'test';
        a.BillingStreet = 'street'; 
        a.BillingCity = 'city';
        a.BillingCountry = 'Germany';
        a.GUID__c = '1234sghf';
        return a;
    }
    
    public static Contact createTestContact() {       
        Contact con = ClsTestHelp.createTestContacts();
        con.LastName = 'testContact';      
        con.Email_Opt_Out__c = false;
        con.Preferred_Contact_Method__c = 'Email';
        return con;
    }

    public static LBU_Code__c createTestLBUCode() {
        LBU_Code__c lbu = new LBU_Code__c();
        lbu.Name = 'USPON-DMPC';
        lbu.BU__c = 'DMPC';
        lbu.Division__c = 'DM';       
        return lbu;
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
    
    public static Opportunity createOpp1(){
        Opportunity oppy = new Opportunity();       
        oppy.Name = 'TestOpportunity';
        oppy.StageName = 'Negotiation';
        oppy.CloseDate = system.today();
        
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
        return oppy;
    }
    
    public static Account_Plan__c createAccPlan() {
        Account_Plan__c ap = new Account_Plan__c();
        ap.Name = 'TestAccPlan1';
        ap.Status__c = 'Planning';
        ap.Account_Plan_Year__c = '2016';
        return ap;
    }
    
    public static Account_Plan_Team__c createAccPlanTeam1(){
        Account_Plan_Team__c apT1 = new Account_Plan_Team__c();
        apT1.Access__c= 'Read/Write';
        apT1.Team_Role__c='GAM/SAM Account Manager';
        return apT1;
    }
    
    public static Budget_Opp__c createBudOpp() {
        Budget_Opp__c bo = new Budget_Opp__c();           
        return bo;
    }
    
    static testMethod void budOppMethod() {
        Test.startTest();
        User u1 = createTestUser1();
            insert u1;
        Account a = createAccount1();
            insert a; 
        LBU_Code__c lbu = createTestLBUCode();       
            insert lbu;         
        Contact con = createTestContact();    
            con.AccountId = a.id;
            insert con;
        Product_Group__c pg = createTestProductgroupFT();        
            insert pg;    
        Opportunity oppy = createOpp1();
            oppy.AccountId = a.Id;
            oppy.Local_Business_Unit__c = lbu.id;
            oppy.Local_Product_Group__c = pg.id;
            oppy.Primary_Contact__c = con.Id; 
            oppy.Product_Group__c = pg.Id;
            insert oppy;
        Account_Plan__c ap = createAccPlan();
            insert ap;
        Account_Plan_Team__c  actPlanTeam1 = createAccPlanTeam1();
            actPlanTeam1.Account_Plan__c = ap.Id;
            actPlanTeam1.User__c = u1.id;
            insert actPlanTeam1 ;
        Budget_Opp__c bo = createBudOpp();
            bo.Account_Customer__c = a.id;
            bo.Account_Plan__c = ap.id;
            bo.Opportunity_Name__c = oppy.id;
            insert bo;
            ap.Status__c = 'Closed';
            update ap;
            system.runAs(u1){
            try{               
                delete bo;
            }catch(exception e){}
            }      
            
        Test.stopTest();
    }
    
    static testMethod void budOppMethod1() {
        Test.startTest();
        User u1 = createTestUser1();
            insert u1;
        Account a = createAccount1();
            insert a; 
        LBU_Code__c lbu = createTestLBUCode();       
            insert lbu;         
        Contact con = createTestContact();    
            con.AccountId = a.id;
            insert con;
        Product_Group__c pg = createTestProductgroupFT();        
            insert pg;    
        Opportunity oppy = createOpp1();
            oppy.AccountId = a.Id;
            oppy.Local_Business_Unit__c = lbu.id;
            oppy.Local_Product_Group__c = pg.id;
            oppy.Primary_Contact__c = con.Id; 
            oppy.Product_Group__c = pg.Id;
            insert oppy;
            
        Id FB= Schema.SObjectType.Account_Plan__c.getRecordTypeInfosByName().get('Master Account Plan-Freeze Budget').getRecordTypeId();
        
        Account_Plan__c ap = createAccPlan();
            ap.Account__c=a.id;            
            ap.RecordTypeId = FB;
            insert ap;
        Account_Plan_Team__c  actPlanTeam1 = createAccPlanTeam1();
            actPlanTeam1.Account_Plan__c = ap.Id;
            actPlanTeam1.User__c = u1.id;
            insert actPlanTeam1 ;
        Budget_Opp__c bo = createBudOpp();
            bo.Account_Customer__c = a.id;
            bo.Account_Plan__c = ap.id;
            bo.Opportunity_Name__c = oppy.id;
            insert bo;
            ap.Freeze_Account_Plan_Budgets__c = TRUE;
            update ap;
            system.runAs(u1){
            try{               
                delete bo;
            }catch(exception e){}
            }      
            
        Test.stopTest();
    }
}