/*
 * ApexClass :  Test class - ChannelPartnerMarketScope_Test
 * Release R5
 * @author  Indhu Ramalingam (Accenture)
 * @created 2016-03-15
 * @version 1.0
 * Description: Test class 
 * Created
 * This is the Test class for 1.ClsPISChannelMarketCoverageProdLine
                              2.ClsTriggerChannelMarketCoverageHandler 
                              3.ClsChannelMarketCoverageEdit
                              4.ClsTriggerChannelPreQualProductLine
 
 */
    @isTest
    private class ChannelPartnerMarketScope_Test{

    public static User createTestUser1() {
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
    
    public static Account createAccount1() {
        Account a = new Account();
        a.Name = 'test';
        a.BillingStreet = 'street'; 
        a.BillingCity = 'city';
        a.BillingCountry = 'Germany';
        a.GUID__c = '1234sghf';
        return a;
    }    
    
    public static Account createAccount2() {
        Account a1 = new Account();
        a1.Name = 'test1';
        a1.BillingStreet = 'street1'; 
        a1.BillingCity = 'city1';
        a1.BillingCountry = 'France';
        a1.GUID__c = '12345sghf';
        return a1;
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
    
    public static Product2 createProduct1() {
        Product2 prod1 = new Product2();   
        prod1.Description = 'Cooling Systems';     
        prod1.Name = 'Desc Cooling Systems';
        prod1.Product_Group__c = 4442;
        prod1.CID__c = 'ABCD0123';
        prod1.IsActive = TRUE;
        return prod1;
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
    
    public static Product_Group__c createProductGroup1() {
        Product_Group__c pg1 = new Product_Group__c();
        pg1.Name = '4442';
        pg1.Product_Group_Name__c = 'Force Measurement';
        pg1.Business_Unit__c = 'PAMP';
        pg1.Business_Unit_Name__c = 'Measurement & Analytics';
        pg1.Division__c = 'PA';
        pg1.Division_Name__c ='Process Automation';
        return pg1;
    }
    
    public static Channel_Market_Coverage__c createChannelPartMarScope() {
        Channel_Market_Coverage__c cms = new Channel_Market_Coverage__c();
        cms.Name = 'Test Market Scope';
        cms.Primary_Channel_Class__c = 'Distributor (DIS)';
        cms.Division__c = 'DM';
        cms.Focussed_Industry1__c = 'Building - Residential Buildings';
        cms.Relationship_Status__c = 'Channel';
        cms.Targeted_Key_Strategic__c = TRUE;
        return cms;
    }
    
    public static Channel_Market_Coverage__c createChannelPartMarScope1() {
        Channel_Market_Coverage__c cms1 = new Channel_Market_Coverage__c();
        cms1.Name = 'Test Market Scope1';
        cms1.Primary_Channel_Class__c = 'Installer (INST)';
        cms1.Division__c = 'PG' + ';' + 'EP';
        cms1.Focussed_Industry1__c = 'Industry - Printing';
        cms1.Relationship_Status__c = 'ABB authorized value provider';
        cms1.Targeted_Key_Strategic__c = TRUE;
        return cms1;
    }
    
     public static Channel_Market_Coverage__c createChannelPartMarScope2() {
        Channel_Market_Coverage__c cms2 = new Channel_Market_Coverage__c();
        cms2.Name = 'Test Market Scope2';
        cms2.Primary_Channel_Class__c = 'Panel builder (PBL)';
        cms2.Division__c = 'PG' + ';' + 'EP' + ';' + 'DM' ;
        cms2.Focussed_Industry1__c = 'Industry - Printing' + ';' + 'Utilities - Gas Utilities';
        cms2.Relationship_Status__c = 'Strategic / Key Partner';
        cms2.Targeted_Key_Strategic__c = FALSE;
        return cms2;
    }
    
    public static Channel_Market_Coverage__c createChannelPartMarScope3() {
        Channel_Market_Coverage__c cms3 = new Channel_Market_Coverage__c();
        cms3.Name = 'Test Market Scope3';
        cms3.Primary_Channel_Class__c = 'Panel builder (PBL)';
        cms3.Division__c = 'PG';
        cms3.Focussed_Industry1__c = 'Utilities - Gas Utilities';
        cms3.Relationship_Status__c = 'Partner';
        cms3.Targeted_Key_Strategic__c = TRUE;
        return cms3;
    }
    
    public static Joint_Business_Plan__c createJBP() {
        Date sDate = Date.today();
        Date eDate = sDate.addDays(2);
        Joint_Business_Plan__c jbp = new Joint_Business_Plan__c();
        jbp.Name = 'JBP Test1';
        jbp.Start_Date__c = sDate;
        jbp.End_Date__c= eDate;
        jbp.CurrencyIsoCode= 'USD';      //'USD-U.S. Dollar';
        jbp.Status__c= 'Draft';
        return jbp;
    }
    
    public static Channel_Business_Review__c createCBR() {
        Channel_Business_Review__c CBR = new Channel_Business_Review__c();
        CBR.Name='TestReview1';
        return CBR;
    }
    
    public static Channel_Market_Coverage_Product_Lines__c createCMSProdLines() {
        Channel_Market_Coverage_Product_Lines__c cmsProdLines = new Channel_Market_Coverage_Product_Lines__c();
        return cmsProdLines;
    }
    
     public static Channel_Market_Coverage_Product_Lines__c createCMSProdLines1() {
        Channel_Market_Coverage_Product_Lines__c cmsProdLines1 = new Channel_Market_Coverage_Product_Lines__c();
        return cmsProdLines1;
    }
     
    static testMethod void channelMarketScopeMethod(){
        Test.StartTest();
        User u1 = createTestUser1();
            insert u1;
        Account a = createAccount1();
            insert a;          
        Product2 prod = createProduct();
            
        Product2 prod1 = createProduct1();
           
        List<Product2> pr = new List<Product2>();
        pr.add(prod);
        pr.add(prod1);
        insert pr;   
           
        Product_Group__c pg = createProductGroup();
            insert pg;    
        AccountTeamMember aTM = new AccountTeamMember(
            UserId = u1.id,
            TeamMemberRole = 'Manager', 
            AccountId = a.id);
           insert aTM;  
        Channel_Market_Coverage__c cms = createChannelPartMarScope();
            cms.Account__c = a.id;         
            insert cms;    
               
        Channel_Market_Coverage_Product_Lines__c cmsProdLines = createCMSProdLines();
            cmsProdLines.Channel_Market_Coverage__c = cms.id;
            cmsProdLines.Product_Group__c = pg.Name;
            cmsProdLines.Product__c = prod.Id;
            cmsProdLines.Division__c = pg.Division__c;
            cmsProdLines.Business_Unit__c = pg.Business_Unit__c;
            insert cmsProdLines;           
         
        
       // Code for Apex Class - ClsPISChannelMarketCoverageProdLine
        Channel_Market_Coverage_Product_Lines__c cmsPrLine = new Channel_Market_Coverage_Product_Lines__c ();
            apexpages.currentpage().getparameters().put('retURL', cmsProdLines.Id);
            ApexPages.StandardController cs = new ApexPages.StandardController(cmsProdLines);      
        ClsPISChannelMarketCoverageProdLine cmsPrLine1 = new ClsPISChannelMarketCoverageProdLine(cs);
            cmsPrLine1.GoBack();         
        List<ClsPISChannelMarketCoverageProdLine.PISNode> products = new List<ClsPISChannelMarketCoverageProdLine.PISNode>();
        ClsPISChannelMarketCoverageProdLine.PISNode objPIS = new ClsPISChannelMarketCoverageProdLine.PISNode();
            objPIS.cid = prod.Cid__c;
            objPIS.englishDescription = 'englishDescription';
            objPIS.languageSpecificDescription = 'languageSpecfDesption';
            products.add(objPIS);   
            ClsPISChannelMarketCoverageProdLine.ProductResult objProdResult = new ClsPISChannelMarketCoverageProdLine.ProductResult();    
            ClsPISChannelMarketCoverageProdLine.ProductResult objResult = ClsPISChannelMarketCoverageProdLine.addProducts(cmsProdLines.Id,products);
      
        Test.StopTest();       
     }
     
      static testMethod void channelMarketScopeMethod1(){
        
        User u1 = createTestUser1();
            insert u1;
        Account a = createAccount1();
            insert a;  
        Product2 prod = createProduct();
           
        Product2 prod1 = createProduct1();
           
        List<Product2> pr = new List<Product2>();
        pr.add(prod);
        pr.add(prod1);
        insert pr;
        
        Product_Group__c pg = createProductGroup();
           
        Product_Group__c pg1 = createProductGroup1();
           
        List<Product_Group__c> prodg = new List<Product_Group__c>();
        prodg.add(pg);
        prodg.add(pg1);
        insert prodg;
        
        Channel_Market_Coverage__c cms = createChannelPartMarScope();
            cms.Account__c = a.id; 
            cms.Product_Line1__c += prod.Name + ';' + prod1.Name;
            cms.BU_Covered__c += pg.Business_Unit__c + ';' + pg1.Business_Unit__c;    
            cms.PG_Covered__c += pg.Division__c + ';' + pg1.Division__c;   
            insert cms;       
        Channel_Market_Coverage_Product_Lines__c cmsProdLines1 = createCMSProdLines1();
            cmsProdLines1.Channel_Market_Coverage__c = cms.id;
            cmsProdLines1.Product_Group__c = pg1.Name;
            cmsProdLines1.Product__c = prod1.Id;
            cmsProdLines1.Division__c = pg1.Division__c;
            cmsProdLines1.Business_Unit__c = pg1.Business_Unit__c;
            insert cmsProdLines1;
          Test.StartTest();  
          // Code for Apex Class - ClsChannelMarketCoverageEdit     
            apexpages.currentpage().getparameters().put('id', cmsProdLines1.Id);
            ApexPages.StandardController cs1 = new ApexPages.StandardController(cmsProdLines1);      
        ClsChannelMarketCoverageEdit cmsPrLineEdit = new ClsChannelMarketCoverageEdit(cs1);
            cmsPrLineEdit.GoBack();         
        ClsChannelMarketCoverageEdit.PISNode editPIS = new ClsChannelMarketCoverageEdit.PISNode();
            editPIS.cid = prod.Cid__c;
            editPIS.englishDescription = 'englishDescription';
            editPIS.languageSpecificDescription = 'languageSpecfDesption';
             
            ClsChannelMarketCoverageEdit.ProductResult objProdResult1 = new ClsChannelMarketCoverageEdit.ProductResult();    
            ClsChannelMarketCoverageEdit.ProductResult objResult1 = ClsChannelMarketCoverageEdit.replaceProduct(cmsProdLines1.Id,editPIS);
       
           
        Test.stopTest();
       }
        
        static testMethod void channelMarketScopeMethod2(){
        Test.StartTest();
        
        User u1 = createTestUser1();
            insert u1;
        Account a1 = createAccount2();
            insert a1;
        Product2 prod = createProduct();
            insert prod;    
        Product2 prod1 = createProduct1();
            insert prod1;     
        Product_Group__c pg = createProductGroup();
            insert pg;   
        Product_Group__c pg1 = createProductGroup1();
            insert pg1;  
        Channel_Market_Coverage__c cms1 = createChannelPartMarScope1();
            cms1.Account__c = a1.id;          
            insert cms1;
        Channel_Market_Coverage_Product_Lines__c cmsProdLines1 = createCMSProdLines1();
            cmsProdLines1.Channel_Market_Coverage__c = cms1.id;
            cmsProdLines1.Product_Group__c = pg.Name;
            cmsProdLines1.Product__c = prod.Id;
            cmsProdLines1.Division__c = pg.Division__c;
            cmsProdLines1.Business_Unit__c = pg.Business_Unit__c;
            insert cmsProdLines1;     
            
        // Code for Apex Class - ClsChannelMarketCoverageEdit     
            apexpages.currentpage().getparameters().put('id', cmsProdLines1.Id);
            ApexPages.StandardController cs1 = new ApexPages.StandardController(cmsProdLines1);      
        ClsChannelMarketCoverageEdit cmsPrLineEdit = new ClsChannelMarketCoverageEdit(cs1);
            cmsPrLineEdit.GoBack();         
        ClsChannelMarketCoverageEdit.PISNode editPIS = new ClsChannelMarketCoverageEdit.PISNode();
            editPIS.cid = prod.Cid__c;
            editPIS.englishDescription = 'englishDescription';
            editPIS.languageSpecificDescription = 'languageSpecfDesption';
         
        ClsChannelMarketCoverageEdit.ProductResult objProdResult1 = new ClsChannelMarketCoverageEdit.ProductResult();    
        ClsChannelMarketCoverageEdit.ProductResult objResult1 = ClsChannelMarketCoverageEdit.replaceProduct(cmsProdLines1.Id,editPIS);
                  
        
        Test.stopTest();
        }
        
        static testMethod void channelMarketScopeMethod3(){
        Test.StartTest();
        
        User u1 = createTestUser1();
            insert u1;
        Account a1 = createAccount2();
            insert a1;
        Product2 prod = createProduct();
            insert prod;    
        Product2 prod1 = createProduct1();
            insert prod1;     
        Product_Group__c pg = createProductGroup();
            insert pg;   
        Product_Group__c pg1 = createProductGroup1();
            insert pg1;  
        Channel_Market_Coverage__c cms2 = createChannelPartMarScope2();
            cms2.Account__c = a1.id;    
            insert cms2;     
        ID DP = Schema.SObjectType.Joint_Business_Plan__c.getRecordTypeInfosByName().get('1. Distributor as Partner').getRecordTypeId();
        Joint_Business_Plan__c jbp = createJBP();
        jbp.RecordtypeId = DP;
        jbp.Channel_Market_Coverage__c = cms2.Id;
        insert jbp;
        
        ID EP = Schema.SObjectType.Channel_Business_Review__c.getRecordTypeInfosByName().get('End-Period Business Review Detail').getRecordTypeId();
        Channel_Business_Review__c CBR = createCBR();
        CBR.Account__c=a1.Id;
        CBR.Joint_Business_Plan__c=jbp.Id; 
        CBR.RecordtypeId =  EP;
        insert CBR;
        
        Channel_Market_Coverage_Product_Lines__c cmsProdLines = createCMSProdLines();
            cmsProdLines.Channel_Market_Coverage__c = cms2.id;
            cmsProdLines.Product__c = prod.Id;
            cmsProdLines.Product_Group__c = pg.Name;
            cmsProdLines.Division__c = pg.Division__c;
            cmsProdLines.Business_Unit__c = pg.Business_Unit__c;           
          //  insert cmsProdLines;           
        Channel_Market_Coverage_Product_Lines__c cmsProdLines1 = createCMSProdLines1();
            cmsProdLines1.Channel_Market_Coverage__c = cms2.id;
            cmsProdLines1.Product_Group__c = NULL;
            cmsProdLines1.Product__c = NULL; 
            cmsProdLines1.Division__c = NULL;
            cmsProdLines1.Business_Unit__c = NULL;         
    //        insert cmsProdLines1; 
    
        List<Channel_Market_Coverage_Product_Lines__c> cms = new List<Channel_Market_Coverage_Product_Lines__c>();
        cms.add(cmsProdLines);
        cms.add(cmsProdLines1);
        insert cms;
       
        Test.stopTest();
        }
        
        static testMethod void channelMarketScopeMethod4(){
        Test.StartTest();
        
        User u1 = createTestUser1();
            insert u1;
        Account a1 = createAccount2();
            insert a1;
        Product2 prod = createProduct();
            insert prod;    
        Product2 prod1 = createProduct1();
            insert prod1;     
        Product_Group__c pg = createProductGroup();
            insert pg;   
        Product_Group__c pg1 = createProductGroup1();
            insert pg1;  
        Channel_Market_Coverage__c cms3 = createChannelPartMarScope3();
            cms3.Account__c = a1.id;         
            cms3.Product_Line1__c += prod.Name + ';' + prod1.Name;
            cms3.BU_Covered__c += pg.Business_Unit__c + ';' + pg1.Business_Unit__c;    
            cms3.PG_Covered__c += pg.Division__c + ';' + pg1.Division__c;  
            insert cms3;
        Channel_Market_Coverage_Product_Lines__c cmsProdLines1 = createCMSProdLines1();
            cmsProdLines1.Channel_Market_Coverage__c = cms3.id;
            cmsProdLines1.Product_Group__c = pg1.Name;
            cmsProdLines1.Product__c = prod1.Id;
            cmsProdLines1.Division__c = pg1.Division__c;
            cmsProdLines1.Business_Unit__c = pg1.Business_Unit__c;
            insert cmsProdLines1;
        
        //Code for Apex Class - ClsCMSProductLinesList  
          apexpages.currentpage().getparameters().put('Id', cms3.Id);
          ApexPages.StandardController stdCtrllerCMSList = new ApexPages.StandardController(cms3);        
          ClsCMSProductLinesList cmsProdLineList = new ClsCMSProductLinesList(stdCtrllerCMSList);
          cmsProdLineList.save();
          cmsProdLineList.cancel();     
           
        Test.stopTest();
        }
     
}