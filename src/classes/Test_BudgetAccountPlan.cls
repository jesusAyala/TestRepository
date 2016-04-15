/**
 * ApexClass -  Test class Test_BudgetAccountPlan
 * Release R5
 * @author  Abiramasundari Radha (Accenture)
 * @created 2016-03-17
 * @version 1.0
 * Description: Created
 * This is the Test class for the below Apex Classes            
                1. 
                2. 
                3.  
                 
  */
@isTest
private class Test_BudgetAccountPlan{

    public static User createTestUser1(){
        User u = new User();
        u.FirstName ='haobo';
        u.LastName = 'song';
        u.Username = 'test123ABB1237@test123ABB1237.com';
        u.Alias = 'mtst1';
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
    public static User createTestUser2(){
        User u2 = new User();
        u2.FirstName ='songhaobo';
        u2.LastName = 'haobosong';
        u2.Username = 'test123adsadsas@test123.com';
        u2.Alias = 'mtst1';
        u2.Email = 'mtester123@company.com';
        u2.ProfileId = [Select Id from Profile Where Name = 'System Administrator' limit 1].Id;
        u2.TimeZoneSidKey = 'America/Chicago';
        u2.LocaleSidKey = 'en_US';
        u2.EmailEncodingKey = 'UTF-8';
        u2.LanguageLocaleKey = 'en_US';
        u2.ManagerId = UserInfo.getUserId();
        return u2;
    }    
    public static Account createAccount1(){
        Account a = new Account();
        a.Name = 'test';
        a.BillingStreet = 'street'; 
        a.BillingCity = 'city';
        a.BillingCountry = 'Germany';
        a.GUID__c = '1234sghf';
        a.Root_Account_GUID__c='zyxa321';
        return a;
    }
    
      public static Contact createTestContacts(){
        Contact contact = new Contact();
        contact.LastName = 'Test';
        contact.MailingStreet = 'dada';
        contact.MailingCity = 'berlin';
        contact.MailingState = 'Berlin';
        contact.MailingPostalCode = '1792';
        contact.MailingCountry = 'Germany'; 
        return contact;
    }
     public static Product2 createProduct() {
        Product2 prod = new Product2();   
        prod.Description = 'Aluminium Solutions';     
        prod.Name = 'Desc Aluminium Solutions';
        prod.Product_Group__c = 4104;
        prod.CID__c = 'ABCD1234';
        prod.IsActive = TRUE;
        return prod;
    }   
     public static Account_Plan__c createAccPlan() {
        Account_Plan__c ap = new Account_Plan__c();
        ap.Name= 'TestAccPlan1';
        ap.Status__c='Planning';
        ap.Account_Plan_Year__c = '1992';
        return ap;
    }   
     public static Account_Plan__c createAccPlan2() {
        Account_Plan__c ap2 = new Account_Plan__c();
        ap2.Name= 'TestAccPlan12';
        ap2.Status__c='Planning';
        ap2.Account_Plan_Year__c = '2002';
        return ap2;
    } 
    public static End_User_Project__c createEndUserProj() {
        End_User_Project__c eup = new End_User_Project__c();
        eup.name='Test End User';
        eup.End_User_Project_Status__c='Open';
        eup.End_User_Project_Site_Country__c='CH';
        return eup;
    }
    public static LBU_Code__c createTestLBUCode() {
        LBU_Code__c lbu = new LBU_Code__c();
        lbu.Name = 'test';
        lbu.BU__c = 'test';
        lbu.Division__c = 'DM';       
        return lbu;
    }
    
     public static Product_Group__c createProductGroup() {
        Product_Group__c pg = new Product_Group__c();
        pg.Name = '4104';
        pg.Product_Group_Name__c = 'Metals';
        pg.Business_Unit__c = 'PAPI';
        pg.Business_Unit_Name__c = 'Process Industries';
        pg.Division__c = 'PA';
        pg.Division_Name__c ='Process Automation';
        return pg;
    }
    
    public static Opportunity createOpportunity() {
        Opportunity oppy = new Opportunity();    
        oppy.Name = 'Testoppyssss';
        oppy.StageName = 'Negotiation';
        oppy.CloseDate = system.today();
        oppy.Actual_Bid_Submission_Date_Comm__c = system.today() -1;
        oppy.Actual_Bid_Submission_Date_Tech__c = system.today() -1;        
        oppy.Opportunity_Value__c = 18646;        
        oppy.Requested_Bid_Submission_Date_Comm__c = system.today() -1;
        oppy.Requested_Bid_Submission_Date_Tech__c = system.today() -1;
        oppy.Application__c ='Test';
        return oppy;
    }  
    
    public static Budget__c createBudget() {
        Budget__c budg = new Budget__c();
        budg.Division__c='PM';
        budg.Account_Plan_Year__c='2016';
        return budg;
    } 
       
     public static Budget_Opp__c createBudgetOpp() {
        Budget_Opp__c budgOpp = new Budget_Opp__c();
        budgOpp.DIV__c='PM';
     //   budgOpp.CloseDate=Date.valueOf(system.now());
    //    budgOpp.StageName = 'Bidding';
        return budgOpp;
    } 
        
     static testMethod void budgetAccountPlanMethod1(){         
         Test.startTest();
         User u1 = createTestUser1();
            insert u1;  
         User u2 = createTestUser2();
             insert u2;       
        Account a = createAccount1();
            insert a;                    
        Contact con =  createTestContacts();  
            con.AccountId = a.Id;    
            insert con;
        Product2 prod = createProduct();
            insert prod; 
        List<Account_Plan__c> accPlanList = new List<Account_Plan__c>();    
        Account_Plan__c accPlan = createAccPlan();
            accPlan.Account__c = a.Id;
            accPlanList.add(accPlan);
        Account_Plan__c accPlan2 = createAccPlan2();
            accPlan2.Account__c = a.Id;
            accPlanList.add(accPlan2);
            insert accPlanList;                      
        End_User_Project__c eup = createEndUserProj();
            eup.Account_End_User__c=a.id;  
            insert eup;  
        LBU_Code__c lbu = createTestLBUCode();
            insert lbu;
        Product_Group__c pg = createProductGroup();
            insert pg;     
        Opportunity oppy = createOpportunity(); 
            oppy.AccountId = a.Id;
            oppy.Primary_Contact__c = con.Id;      
            oppy.Product_Group__c = pg.Id;
            oppy.End_User_Project__c=eup.id;
            oppy.Local_Business_Unit__c = lbu.id;
            oppy.Local_Product_Group__c = pg.id; 
            insert oppy;
       Budget__c budg = createBudget();
            budg.Account_Plan__c=accPlan.Id;
            budg.Product__c=prod.Id;
            budg.Segment_Level__c='Product Line';
            insert budg;
       Budget_Opp__c budOpp = createBudgetOpp();
            budOpp.Account_Customer__c = a.Id;
            budOpp.Account_Plan__c = accPlan.Id;
            budOpp.Alternative_Opportunity__c = oppy.Id;
            budOpp.End_User_Project__c = eup.Id;
            budOpp.Opportunity_Name__c = oppy.Id;
            budOpp.PG__c=pg.Id;
            insert budOpp;

system.runas(u2){                                                      
//Code for Apex Class - ClsAccPlanBudgetOppyList 
        apexpages.currentpage().getparameters().put('Id', accPlan.Id);
        ApexPages.StandardSetController  stdCtrller = new ApexPages.StandardSetController (accPlanList);           
        ClsAccPlanBudgetOppyList accPlanOppList = new ClsAccPlanBudgetOppyList(stdCtrller);
        accPlanOppList.SearchOppRecords();
        accPlanOppList.sortRecordsByColumn();
        accPlanOppList.SaveBudget();
        accPlanOppList.goToAccPlan();
        accPlanOppList.cancel();        
} 



//Code for Apex Class - ClsBudgetEdit
        apexpages.currentpage().getparameters().put('ID', budg.Id);
        ApexPages.StandardController stdCtrller2 = new ApexPages.StandardController(budg);        
        ClsBudgetEdit budgetEdit = new ClsBudgetEdit(stdCtrller2);    
        budgetEdit.GoBack();   
        ClsBudgetEdit.PISNode budEdit = new ClsBudgetEdit.PISNode();
        budEdit.cid = prod.Cid__c;
        budEdit.englishDescription = 'englishDescription';
        budEdit.languageSpecificDescription = 'languageSpecfDesption';           
        ClsBudgetEdit.ProductResult prodResult = new ClsBudgetEdit.ProductResult();    
        ClsBudgetEdit.ProductResult objResult1 = ClsBudgetEdit.replaceProduct(budg.Id,budEdit);   
       
        Test.stopTest();     
    }  
   static testMethod void budgetAccountPlanMethod2(){         
        Test.startTest();           
        Account a = createAccount1();
            insert a;                          
        Product2 prod = createProduct();
            insert prod; 
        List<Account_Plan__c> accPlanList = new List<Account_Plan__c>();    
        Account_Plan__c accPlan = createAccPlan();
            accPlan.Account__c = a.Id;
            accPlanList.add(accPlan);
        Account_Plan__c accPlan2 = createAccPlan2();
            accPlan2.Account__c = a.Id;
            accPlanList.add(accPlan2);
            insert accPlanList;
       Product_Group__c pg = createProductGroup();
            insert pg;                                    
       Budget__c budg = createBudget();
            budg.Account_Plan__c=accPlan.Id;
            budg.Product__c=prod.Id;
            budg.Segment_Level__c='Product Line';
            insert budg;
            
// Code for Apex Class - ClsRemoveProductBudget
        apexpages.currentpage().getparameters().put('ID', budg.Id);
        ApexPages.StandardController stdCtrller3 = new ApexPages.StandardController(budg);  
        ClsRemoveProductBudget clsRemoveProduct = new ClsRemoveProductBudget(stdCtrller3);
        clsRemoveProduct.removeProduct();

// Code for Apex Class - ClsTriggerBudget
     //   ClsTriggerBudget triggerBud = new ClsTriggerBudget();
        
// Code for Apex Class - ClsTriggerBudgetOpp
 //       ClsTriggerBudgetOpp triggerBudOpp = new ClsTriggerBudgetOpp();      
        
//Code for Apex Class - ClsAddProductBudget
        Budget__c budgClass = new Budget__c();
        apexpages.currentpage().getparameters().put('BudgetID', budg.Id);
        ApexPages.StandardController stdCtrller1 = new ApexPages.StandardController(budg);      
        ClsAddProductBudget addProdBudget = new ClsAddProductBudget(stdCtrller1);
        addProdBudget.GoBack();         
        List<ClsAddProductBudget.PISNode> products = new List<ClsAddProductBudget.PISNode>();
        ClsAddProductBudget.PISNode objPIS = new ClsAddProductBudget.PISNode();
        objPIS.cid = prod.Cid__c;
        objPIS.englishDescription = 'englishDescription';
        objPIS.languageSpecificDescription = 'languageSpecfDesption';
        products.add(objPIS);   
        ClsAddProductBudget.ProductResult objProdResult1 = new ClsAddProductBudget.ProductResult();    
        ClsAddProductBudget.ProductResult objResults = ClsAddProductBudget.addProducts(budg.Id,products);        
        Test.stopTest();
   
   
   
   }
   
   
     
}