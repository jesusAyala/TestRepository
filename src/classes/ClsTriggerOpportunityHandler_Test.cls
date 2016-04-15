/**
*  This test class used to test class ClsTriggerOpportunityHandler.
*    
@author Jinbo Shan
@created 2015-03-26
@version 1.0   
@since 30.0
*
@changelog
* coverage 100% 
* 
* 
2015-03-26 Jinbo Shan <jinbo.shan@itbconsult.com>
* - Created
*/
@isTest(SeeAllData = False)
private class ClsTriggerOpportunityHandler_Test {
    
    public static LBU_Code__c createTestLBUCode() {
        LBU_Code__c lbu = new LBU_Code__c();
        lbu.Name = 'test';
        lbu.BU__c = 'test';
        lbu.Division__c = 'DM';       
        return lbu;
    }
    
    
    static testMethod void myUnitTest() {
        Profile p = [SELECT id FROM profile WHERE name = 'System Administrator'];
        User u1 = new User(alias = 'chfree01',
                           email = 'chatterfreeuser101@testorg.com',
                           emailencodingkey = 'UTF-8',
                           lastname = 'Testing',
                           companyname = 'testorg',
                           languagelocalekey = 'en_US',
                           localesidkey = 'en_US',
                           profileId = p.Id,
                           timezonesidkey = 'America/Los_Angeles',
                           username = 'chatterfreeuser101@testorg.com');
        insert u1;
        System.runAs(u1){
            // TO DO: implement unit test
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Name = 'sdjinbosetssss';
            insert acc;
        
            Contact con = ClsTestHelp.createTestContacts();
            con.LastName = 'testddsssdd';
            con.AccountId = acc.Id;
            con.Email_Opt_Out__c = false;
            con.Preferred_Contact_Method__c = 'Email';
            insert con;
        
            Product_Group__c pg = new Product_Group__c();
            pg.Business_Unit__c = 'tdsd';
            pg.Name = 'jinboestdspro';
            pg.Division__c = '10';
            insert pg;
        
            End_User_Project__c proj=new End_User_Project__c();
            proj.name='Test End User';
            proj.Account_End_User__c=acc.id;
            proj.End_User_Project_Status__c='Open';
            proj.End_User_Project_Site_Country__c='CH';
            insert proj;
        
           LBU_Code__c lbu = createTestLBUCode();       
           insert lbu;
        
        Opportunity oppy = new Opportunity();
        oppy.AccountId = acc.Id;
        oppy.Primary_Contact__c = con.Id; 
        oppy.Name = 'Testoppyssss';
        oppy.StageName = 'Negotiation';
        oppy.CloseDate = system.today();
        oppy.Actual_Bid_Submission_Date_Comm__c = system.today() -1;
        oppy.Actual_Bid_Submission_Date_Tech__c = system.today() -1;
        oppy.Product_Group__c = pg.Id;
        oppy.Opportunity_Value__c = 18646;
        oppy.End_User_Project__c=proj.id;
        oppy.Requested_Bid_Submission_Date_Comm__c = system.today() -1;
        oppy.Requested_Bid_Submission_Date_Tech__c = system.today() -1;
        oppy.Application__c ='Test';
        oppy.Local_Business_Unit__c = lbu.id;
        oppy.Local_Product_Group__c = pg.id;
        
        Test.startTest();
        insert oppy;
        Test.stopTest();
        }
        
    }
 /*
@author Aswini Arasu
@created 2015-12-23
@version 1.0  
*/
   /* static testMethod void myUnitTest1()
    {
    Account a = new Account();
    a.Name = 'Acciona, S.A';
    a.BillingStreet = 'dajie';
    a.BillingCity = 'berlin';
    a.BillingState = 'Berlin';
    a.BillingPostalCode = '20012';
    a.BillingCountry = 'Germany';
    insert a;
    
    RecordType ft = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Opportunity' and DeveloperName = 'Fast_Track'];  
    RecordType rg = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Opportunity' and DeveloperName = 'Regular'];
    Opportunity o = new Opportunity();
    o.AccountId = a.id;
    o.RecordtypeId = rg.id;
    o.Account_End_User__c =a.id;
    //o.End_User_Project__c = 'Testct';
    o.Name = 'ES-Acciona, S.A-Test';
    o.StageName = 'Closed(Cancelled)';
    o.Sales_Pursuit_Progress__c = 'CLOSED cancelled';
    o.Specific_Opportunity_Info__c ='Test';
    o.Confidence_Level__c ='No Delay Expected';
    //o.Probability_Verification__c = '';
    //o.ABB_Location__c ='Test';
    o.CloseDate = date.today();
    //o.Opportunity_Value__c = '10';
    //o.Technical_Amount_USD = ''
    o.Industry_Usage__c = 'BLD.10.1';
    o.Channel_Class__c = 'Direct Sales to End Customer / End User';
    o.Customer_Buying_Path__c = 'Awareness';
    o.Opportunity_Winner__c = a.id;
    insert o;
    
    Apttus_Proposal__Proposal__c ap = new Apttus_Proposal__Proposal__c();
    ap.Apttus_Proposal__Opportunity__c = o.id;
    ap.Quotation_status__c = 'RFQ';
    insert ap;
    ap.Apttus_Proposal__Valid_Until_Date__c = System.today()-1;
   // ap.Quotation_status__c = 'Closed' ;
    update ap;
   

    }
    static testMethod void myUnitTest2()
    {
    Account a = new Account();
    a.Name = 'Acciona, S.A';
    a.BillingStreet = 'dajie';
    a.BillingCity = 'berlin';
    a.BillingState = 'Berlin';
    a.BillingPostalCode = '20012';
    a.BillingCountry = 'Germany';
    insert a;
    
    Opportunity o = new Opportunity();
    o.AccountId = a.id;
    o.Account_End_User__c =a.id;
    //o.End_User_Project__c = 'Testct';
    o.Name = 'ES-Acciona, S.A-Test';
    o.StageName = 'Closed(Cancelled)';
    o.Sales_Pursuit_Progress__c = 'CLOSED cancelled';
    o.Specific_Opportunity_Info__c ='Test';
    o.Confidence_Level__c ='No Delay Expected';
    //o.Probability_Verification__c = '';
    //o.ABB_Location__c ='Test';
    o.CloseDate = date.today();
    //o.Opportunity_Value__c = '10';
    //o.Technical_Amount_USD = ''
    o.Industry_Usage__c = 'BLD.10.1';
    o.Channel_Class__c = 'Direct Sales to End Customer / End User';
    o.Customer_Buying_Path__c = 'Awareness';
    o.Opportunity_Winner__c = a.id;
  
    
    Opportunity o1 = new Opportunity();
    o1.AccountId = a.id;
    o1.Account_End_User__c =a.id;
    //o.End_User_Project__c = 'Testct';
    o1.Name = 'ES-Acciona, S.A-Test';
    o1.StageName = 'Closed(Cancelled)';
    o1.Sales_Pursuit_Progress__c = 'CLOSED cancelled';
    o1.Specific_Opportunity_Info__c ='Test';
    o1.Confidence_Level__c ='No Delay Expected';
    //o.Probability_Verification__c = '';
    //o.ABB_Location__c ='Test';
    o1.CloseDate = date.today();
    //o.Opportunity_Value__c = '10';
    //o.Technical_Amount_USD = ''
    o1.Industry_Usage__c = 'BLD.10.1';
    o1.Channel_Class__c = 'Direct Sales to End Customer / End User';
    o1.Customer_Buying_Path__c = 'Awareness';
    //o1.Alternative_Opportunity_To__c = o.id;
    o1.Opportunity_Winner__c = a.id;
 
    
    Opportunity o3 = new Opportunity();
    o3.AccountId = a.id;
    o3.Account_End_User__c =a.id;
    //o.End_User_Project__c = 'Testct';
    o3.Name = 'ES-Acciona, S.A-Test';
    o3.StageName = 'Closed(Cancelled)';
    o3.Sales_Pursuit_Progress__c = 'CLOSED cancelled';
    o3.Specific_Opportunity_Info__c ='Test';
    o3.Confidence_Level__c ='No Delay Expected';
    //o3.Probability_Verification__c = '';
    //o3.ABB_Location__c ='Test';
    o3.CloseDate = date.today();
    //o3.Opportunity_Value__c = '10';
    //o3.Technical_Amount_USD = ''
    o3.Industry_Usage__c = 'BLD.10.1';
    o3.Channel_Class__c = 'Direct Sales to End Customer / End User';
    o3.Customer_Buying_Path__c = 'Awareness';
    //o3.Alternative_Opportunity_To__c = o.id;
    o3.Opportunity_Winner__c = a.id;

    
    Opportunity o4 = new Opportunity();
    o4.AccountId = a.id;
    o4.Account_End_User__c =a.id;
    //o.End_User_Project__c = 'Testct';
    o4.Name = 'ES-Acciona, S.A-Test';
    o4.StageName = 'Closed(Cancelled)';
    o4.Sales_Pursuit_Progress__c = 'CLOSED cancelled';
    o4.Specific_Opportunity_Info__c ='Test';
    o4.Confidence_Level__c ='No Delay Expected';
    //o4.Probability_Verification__c = '';
    //o4.ABB_Location__c ='Test';
    o4.CloseDate = date.today();
    //o4.Opportunity_Value__c = '10';
    //o4.Technical_Amount_USD = ''
    o4.Industry_Usage__c = 'BLD.10.1';
    o4.Channel_Class__c = 'Direct Sales to End Customer / End User';
    o4.Customer_Buying_Path__c = 'Awareness';
    //o4.Alternative_Opportunity_To__c = o.id;
    o4.Opportunity_Winner__c = a.id;
    
    List<Opportunity> oppList = new List<Opportunity>();
    oppList.add(o);
    oppList.add(o1);
    oppList.add(o3);
    oppList.add(o4);
    insert oppList;
    
    o1.Alternative_Opportunity_To__c = o.id;
    o1.id=o3.id;
    update o1;
    oppList.add(o1);
    //update oppList;
    
    System.assertEquals(o.Alternative_Opportunity_To__c,null);
    }*/
    
    
    
}