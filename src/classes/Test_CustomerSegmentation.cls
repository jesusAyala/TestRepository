/**
 * ApexClass -  Test class Test_CustomerSegmentation
 * Release R5
 * @author  Abiramasundari Radha (Accenture)
 * @created 2016-03-14
 * @version 1.0
 * Description: Test class for 
 * Created
 * This is the Test calss for 1. ClsAddCustomerSegmentTeam
                              2. ClsAddProductCustSeg
                              3. ClsCustSegEdit
                              4.ClsRemoveProductCustSeg
                              5.ClsTriggerCustomerSegmentTeam
                              6.ClsCustSegTeamMembersCopy
                              7.ClsCustSegmChart    
 
  */
@isTest
private class Test_CustomerSegmentation {
         
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
    public static User createTestUser2() {
        User u = new User();
        u.FirstName ='haobo';
        u.LastName = 'song';
        u.Username = 'test1234awsedr@test1234.com';
        u.Alias = 'mtst2';
        u.Email = 'mtester2ABB1236@companyABB1236.com';
        u.CommunityNickname = u.Alias;
        u.ProfileId = [Select Id from Profile Where Name = 'System Administrator' limit 1].Id;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.ManagerId = UserInfo.getUserId();
        return u;
    }
    public static User createTestUser3() {
        User u = new User();
        u.FirstName ='haobo';
        u.LastName = 'song';
        u.Username = 'test12345ABB1235@test12345ABB1235.com';
        u.Alias = 'mtst3';
        u.Email = 'mtester3@company.com';
        u.CommunityNickname = u.Alias;
        u.ProfileId = [Select Id from Profile Where Name = 'ABB Sales Standard Profile' limit 1].Id;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.ManagerId = UserInfo.getUserId();
        return u;
    }
    public static User createTestUser4() {
        User u = new User();
        u.FirstName ='haobo';
        u.LastName = 'song';
        u.Username = 'test12345ABB1234@test12345ABB1234.com';
        u.Alias = 'mtst31';
        u.Email = 'mtester3@company.com';
        u.CommunityNickname = u.Alias;
        u.ProfileId = [Select Id from Profile Where Name = 'Standard User' limit 1].Id;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.ManagerId = UserInfo.getUserId();
        return u;
    }
    
    public static Customer_Segmentation__c createAccSegmentation() {
        Customer_Segmentation__c cs = new Customer_Segmentation__c();
        cs.Customer_Sales_Segmentation__c = 'A';
        cs.Growth_Potential_Year__c='1992';
        cs.DIV__c = 'DM';
        return cs;
    }
    
     public static Customer_Segmentation__c createAccSegmentation2() {
        Customer_Segmentation__c cs2 = new Customer_Segmentation__c();
        cs2.Customer_Sales_Segmentation__c = 'A';
        cs2.Growth_Potential_Year__c='1998';
        cs2.DIV__c = 'PM';
        return cs2;
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
    
    public static Product2 createProduct2() {
        Product2 prod2 = new Product2();   
        prod2.Description = 'Cement Solutions';     
        prod2.Name = 'Desc Cement Solutions';
        prod2.Product_Group__c = 2413;
        prod2.CID__c = 'WERT1234';
        prod2.IsActive = TRUE;
        return prod2;
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
        
    static testMethod void customerSegmentationMethod1(){
        Test.StartTest();
        User u1 = createTestUser1();
        insert u1;
        User u2 = createTestUser2();
        insert u2; 
        User u3 = createTestUser3();
        insert u3;
        User u4 = createTestUser4();
        insert u4;
        Product2 p = createProduct();
        insert p;
        Product2 p2 = createProduct2();
        insert p2;
        Product_Group__c pg = createProductGroup();
        insert pg;
                
        Customer_Segmentation__c cs1 = createAccSegmentation();
            cs1.Product__c=p.id;
            cs1.Segment_Level__c='Product Line';
            insert cs1;  
                             
        Customer_Segmentation_Team__c CST4 = new Customer_Segmentation_Team__c ();
        CST4.User__c = u1.id;
        CST4.Customer_Segmentation__c= cs1.id;
        insert CST4;       
        CST4.User__c = u2.id;
        CST4.Access__c = 'Read/Write';
        
        try{
            update CST4;
        } catch(exception e){ }  // Cannot add System Administrator as a User 
        
       System.runAs(u1) {
           try {
               delete CST4;
           } Catch (exception e) { //Cannot edit/delete yourself. Please contact Record owner or System Administrator. 
           
           }
       }  
       
       try {
          CST4.Access__c = null;
           update CST4;
       } Catch (exception e) {
       
       }
       
        Customer_Segmentation_Team__c CST5 = new Customer_Segmentation_Team__c ();
        CST5.User__c = u1.id;
        CST5.Customer_Segmentation__c= cs1.id;
        try{
            insert CST5;  
        }catch(exception e){}

        system.runAs(u3){
            Customer_Segmentation__c cs2 = createAccSegmentation2();
            cs2.Product__c=p2.id;
            cs2.Segment_Level__c='Product Line';
            insert cs2;
            Customer_Segmentation_Team__c CST6 = new Customer_Segmentation_Team__c ();
            CST6.User__c = u3.Id;
            CST6.Customer_Segmentation__c= cs2.id;
            try{
                insert CST6;  
            }catch(exception e){}
        }
           
  // Code coverage for Apex Class - ClsAddCustomerSegmentTeam                               
    Customer_Segmentation_Team__c  stdCT = new Customer_Segmentation_Team__c ();
        ApexPages.StandardController sc = new ApexPages.StandardController(stdCT);
    ClsAddCustomerSegmentTeam objCT = new ClsAddCustomerSegmentTeam(sc);
        objCT.customerSegTeam1.User__c = u1.id;
        objCT.customerSegTeam2.User__c = u1.id;
        objCT.customerSegTeam3.User__c = u1.id;
        objCT.customerSegTeam4.User__c = u1.id;
        objCT.customerSegTeam5.User__c = u1.id;
        objCT.saveRecord();
        objCT.saveMoreRecord();
        objCT.cancel();  
        objCT.GoBack();
 
// Code coverage for Apex Class - ClsTriggerCustomerSegmentTeam
       ClsTriggerCustomerSegmentTeam cusSegTeam = new ClsTriggerCustomerSegmentTeam();
        
// Code coverage for Apex Class - ClsAddProductCustSeg   
    Customer_Segmentation__c  cusSeg = new Customer_Segmentation__c ();
        apexpages.currentpage().getparameters().put('CustSegID', cs1.Id);
        ApexPages.StandardController cs = new ApexPages.StandardController(cs1);      
    ClsAddProductCustSeg custseg = new ClsAddProductCustSeg(cs);
        custseg.GoBack();         
        List<ClsAddProductCustSeg.PISNode> products = new List<ClsAddProductCustSeg.PISNode>();
        ClsAddProductCustSeg.PISNode objPIS = new ClsAddProductCustSeg.PISNode();
        objPIS.cid = p.Cid__c;
        objPIS.englishDescription = 'englishDescription';
        objPIS.languageSpecificDescription = 'languageSpecfDesption';
        products.add(objPIS);   
        ClsAddProductCustSeg.ProductResult objProdResult = new ClsAddProductCustSeg.ProductResult();    
        ClsAddProductCustSeg.ProductResult objResult = ClsAddProductCustSeg.addProducts(cs1.Id,products);

// Code coverage for Apex Class - ClsCustSegEdit          
        apexpages.currentpage().getparameters().put('Id', cs1.Id);
        ApexPages.StandardController stdCtrller = new ApexPages.StandardController(cs1);           
    ClsCustSegEdit CustSegEdit  =  new ClsCustSegEdit(stdCtrller);    
        CustSegEdit.GoBack();   
        ClsCustSegEdit.PISNode segEdit = new ClsCustSegEdit.PISNode();
        segEdit.cid = p.Cid__c;
        segEdit.englishDescription = 'englishDescription';
        segEdit.languageSpecificDescription = 'languageSpecfDesption';   
        ClsCustSegEdit.ProductResult prodResult = new ClsCustSegEdit.ProductResult();    
        ClsCustSegEdit.ProductResult objResult1 = ClsCustSegEdit.replaceProduct(cs1.Id,segEdit);       

// Code coverage for Apex Class - ClsRemoveProductCustSeg     
    ClsRemoveProductCustSeg clsRemoveProduct = new ClsRemoveProductCustSeg(stdCtrller);
        clsRemoveProduct.removeProduct();
   
// Code coverage for Apex Class - ClsTriggerCustomerSegmentation    
    ClsTriggerCustomerSegmentation triggerCusSeg = new ClsTriggerCustomerSegmentation();
            
            
       Test.StopTest();    
       } 
   
  static testMethod void customerSegmentationMethod2() {    
       User u1 = new User();
        u1.FirstName ='haobo';
        u1.LastName = 'song';
        u1.Username = 'test123adsadsas@test123.com';
        u1.Alias = 'mtst1';
        u1.Email = 'mtester1@company.com';
        u1.ProfileId = [Select Id from Profile Where Name = 'System Administrator' limit 1].Id;
        u1.TimeZoneSidKey = 'America/Chicago';
        u1.LocaleSidKey = 'en_US';
        u1.EmailEncodingKey = 'UTF-8';
        u1.LanguageLocaleKey = 'en_US';
        u1.ManagerId = UserInfo.getUserId();
        insert u1;
        
      User u2 = new User();
        u2.FirstName ='haikoo';
        u2.LastName = 'testg';
        u2.Username = 'haikootest321ABB123@ABB123test123.com';
        u2.Alias = 'mtasd';
        u2.Email = 'mtester12@company.com';
        u2.ProfileId = [Select Id from Profile Where Name = 'ABB Sales Standard Profile' limit 1].Id;
        u2.TimeZoneSidKey = 'America/Chicago';
        u2.LocaleSidKey = 'en_US';
        u2.EmailEncodingKey = 'UTF-8';
        u2.LanguageLocaleKey = 'en_US';
        u2.ManagerId = UserInfo.getUserId();
        u2.IsActive=TRUE;
        insert u2;   
        
      User u3 = new User();
        u3.FirstName ='hellohaikoo';
        u3.LastName = 'hellotestg';
        u3.Username = 'hellohaikooABB123444444@test123ABB12344444.com';
        u3.Alias = 'helld';
        u3.Email = 'hellomtester12@company.com';
        u3.ProfileId = [Select Id from Profile Where Name = 'ABB Sales Standard Profile' limit 1].Id;
        u3.TimeZoneSidKey = 'America/Chicago';
        u3.LocaleSidKey = 'en_US';
        u3.EmailEncodingKey = 'UTF-8';
        u3.LanguageLocaleKey = 'en_US';
        u3.IsActive=TRUE;
        u3.ManagerId = UserInfo.getUserId();
        insert u3;
        
        Account a = new Account(
            Name = 'test',
            BillingStreet = 'street', 
            BillingCity = 'city', 
            BillingCountry = 'Germany', GUID__c = '1234sghf');
        insert a;
        
        AccountTeamMember aTM = new AccountTeamMember(
            UserId = u3.id,
            TeamMemberRole = 'Manager', 
            AccountId = a.id);
        insert aTM;
        
        AccountTeamMember aTM1 = new AccountTeamMember(
            UserId = u2.id,
            TeamMemberRole = 'Manager', 
            AccountId = a.id);
        insert aTM1;  
         Test.StartTest(); 
                     
// Code coverage for Apex Class - ClsCustSegTeamMembersCopy     
      System.Runas(u3){ 
       
        Customer_Segmentation__c cs1 = new Customer_Segmentation__c();
                cs1.Customer_Sales_Segmentation__c = 'A';
                cs1.Growth_Potential_Year__c='1992';
                cs1.DIV__c = 'DM';
                cs1.Account__c=a.Id;
                cs1.Segment_Level__c='Product Line';
                insert cs1;    
                apexpages.currentpage().getparameters().put('Id', cs1.Id);
                ApexPages.StandardController stdCtrller = new ApexPages.StandardController(cs1);                    
                ClsCustSegTeamMembersCopy CustSegCopy  =  new ClsCustSegTeamMembersCopy(stdCtrller);    
                CustSegCopy.copyAccountTeamMember();   
         } 
     
      Id devRecordTypeId = Schema.SObjectType.Customer_Segmentation__c.getRecordTypeInfosByName().get('Heat Maps').getRecordTypeId();              
      Customer_Segmentation__c cs1 = new Customer_Segmentation__c();
                cs1.Customer_Sales_Segmentation__c = 'A';
                cs1.Growth_Potential_Year__c='1992';
                cs1.DIV__c = 'DM';
                cs1.Account__c=a.Id;
                cs1.Business_Line_BU__c='PATU';
                cs1.Marketing_Segmentation_Year__c='1995';
                cs1.Segment_Level__c='Product Line';
                cs1.PIE_Customer_Marketing_Segmentation__c='Preferred Supplier';
                cs1.recordtypeid=devRecordTypeId;
                insert cs1; 
                
     Customer_Segmentation__c cs2 = new Customer_Segmentation__c();
                cs2.Customer_Sales_Segmentation__c = 'A';
                cs2.Growth_Potential_Year__c='1993';
                cs2.DIV__c = 'EP';
                cs2.Account__c=a.Id;
                cs2.Business_Line_BU__c='EPMP';
                cs2.Marketing_Segmentation_Year__c='1995';
                cs1.Segment_Level__c='Product Line';
                cs2.PIE_Customer_Marketing_Segmentation__c='Supplier amongst others';
                cs2.recordtypeid=devRecordTypeId;
                insert cs2; 
                
     Customer_Segmentation__c cs3 = new Customer_Segmentation__c();
                cs3.Customer_Sales_Segmentation__c = 'A';
                cs3.Growth_Potential_Year__c='1994';
                cs3.DIV__c = 'PA';
                cs3.Account__c=a.Id;
                cs1.Segment_Level__c='Product Line';
                cs3.Business_Line_BU__c='PGSU';
                cs3.Marketing_Segmentation_Year__c='1995';
                cs3.PIE_Customer_Marketing_Segmentation__c='Weak or not approved supplier';
                cs3.recordtypeid=devRecordTypeId;
                insert cs3; 
                
    Customer_Segmentation__c cs4 = new Customer_Segmentation__c();
                cs4.Customer_Sales_Segmentation__c = 'A';
                cs4.Growth_Potential_Year__c='1995';
                cs4.DIV__c = 'PG';
                cs4.Account__c=a.Id;
                cs1.Segment_Level__c='Product Line';
                cs4.Business_Line_BU__c='EPSU';
                cs4.Marketing_Segmentation_Year__c='1995';
                cs4.PIE_Customer_Marketing_Segmentation__c='Others';
                cs4.recordtypeid=devRecordTypeId;
                insert cs4; 
                
     Customer_Segmentation__c cs5 = new Customer_Segmentation__c();
                cs5.Customer_Sales_Segmentation__c = 'A';
                cs5.Growth_Potential_Year__c='1996';
                cs5.DIV__c = 'DM';
                cs5.Account__c=a.Id;
                cs5.Business_Line_BU__c='EPLS';
                cs1.Segment_Level__c='Product Line';
                cs5.Marketing_Segmentation_Year__c='1995';
                cs5.PIE_Customer_Marketing_Segmentation__c='Not applicable';
                cs5.recordtypeid=devRecordTypeId;
                insert cs5;                                              

// Code coverage for Apex Class - ClsCustSegmChart         
          apexpages.currentpage().getparameters().put('Id', a.Id);
          ApexPages.StandardController stdCtrller = new ApexPages.StandardController(a);                                
          ClsCustSegmChart custSegmChart=  new ClsCustSegmChart (stdCtrller);    
          ClsCustSegmChart.chartClass[] itm = custSegmChart.data; 
          String getFields = custSegmChart.fields;
          String gettitles = custSegmChart.titles;           
          Test.StopTest();     
                                  
     }  

        
       
        
       
       
}