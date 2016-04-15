/**
*  This test class used to test class OpportunityLineItem_ServIS_WSDL_NewOLI.
*    
@author Rajesh K    
@created 2016-03-22
@version 1.0 
* 
*/
@isTest(seeAlldata = true)
private class OpportunityLI_ServIS_WSDL_NewOLI_TEST {
    
    public static LBU_Code__c createTestLBUCode() {
        LBU_Code__c lbu = new LBU_Code__c();
        lbu.Name = 'test';
        lbu.BU__c = 'test';
        lbu.Division__c = 'DM';       
        return lbu;
    }    
    
    static testMethod void myUnitTest() {
        
           Opportunity oppy; 
       
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
        
            oppy = new Opportunity();
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
            oppy.currencyIsoCode = 'USD';
        
            Test.startTest();
            Product2 prod = new Product2(Name = 'Mobile X200', CID__c = '9AAD30405614');
            insert prod;
            //Id pricebookId = Test.getStandardPricebookId();
            Pricebook2 pricebookId = [select id from Pricebook2 where isStandard=true];
            
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId.id, CurrencyIsoCode = 'USD',Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
            insert standardPrice;
            
            insert oppy;
            Test.stopTest();
            OpportunityLineItem_ServIS_WSDL_NewOLI.newLineItem objli = new OpportunityLineItem_ServIS_WSDL_NewOLI.newLineItem();
            objli.in_oppid = String.valueof(oppy.id);
            objli.in_CID = '9AAD30405614';
            objli.in_quantity = 23.0;
            objli.in_Description = 'Test Description';
            objli.in_Value = 50.0;
            objli.in_siteName = 'Test Site';
            objli.in_siteId = '12344';
            objli.in_creatorEmail = 'test1213@gmail.com';
            objli.in_ServISOppID = '2321314';
            objli.in_OppSource = 'Test Source'; 
            
            List<OpportunityLineItem_ServIS_WSDL_NewOLI.newLineItem> lstlineitem = new List<OpportunityLineItem_ServIS_WSDL_NewOLI.newLineItem>();
            lstlineitem.add(objli);
            
            OpportunityLineItem_ServIS_WSDL_NewOLI.createOLI(lstlineitem);
        
    }
}