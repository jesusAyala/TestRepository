/**
 * ApexClass -  Test class Test_JointBusinessPlan
 * Release R5
 * @author  Abiramasundari Radha (Accenture)
 * @created 2016-03-15
 * @version 1.0
 * Description: Test class for 
 * Created
 * This is the Test class for the below Apex Classes            
                1. ClsAddJointBusinessTeam
                2. ClsJBPContactRoleCopy 
                3. ClsPISJBPProductLine
                4. ClsJointBusinessPlanEdit
                5. ClsJBPMarketCoverage     
                6. ClsJBPMarketCoverageList            
                7. ClsTriggerJBPProductLines 
  */
@isTest
private class Test_JointBusinessPlan{

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
    
     public static Contact createTestContacts2(){
        Contact contact2 = new Contact();
        contact2.LastName = 'Test123';
        contact2.MailingStreet = 'dada';
        contact2.MailingCity = 'NY';
        contact2.MailingState = 'Berlin';
        contact2.MailingPostalCode = '1792';
        contact2.MailingCountry = 'Germany'; 
        return contact2;
    }
    
     public static Customer_Segmentation__c createAccSegmentation(){
        Customer_Segmentation__c cs = new Customer_Segmentation__c();
        cs.Customer_Sales_Segmentation__c = 'A';
        cs.Growth_Potential_Year__c='1992';
        cs.DIV__c = 'DM';
        return cs;
    }
       
    public static Channel_Market_Coverage__c createChannelMarkCov(){
        Channel_Market_Coverage__c mc = new Channel_Market_Coverage__c ();
        mc.Name = 'Test Market Coverage'; 
        mc.Division__c = 'PA';
        mc.Primary_Channel_Class__c ='Installer (INST)';
        mc.Focussed_Industry1__c = 'Building - Residential Buildings;Industry - Petrochemicals;Industry - Textile';  
        return mc;
    }  
        
    public static Joint_Business_Plan__c createJointBussPlan(){
        Joint_Business_Plan__c jbp = new Joint_Business_Plan__c();
        jbp.Name = 'Test Joint Business Plan'; 
        jbp.Start_Date__c = Date.valueOf(system.now());
        jbp.End_Date__c = Date.valueOf(system.now());
        jbp.Status__c='Active'; 
        jbp.CurrencyISOCode = 'USD';      
        return jbp;
    }
     
     public static Joint_Business_Plan__c createJointBussPlan2(){
        Joint_Business_Plan__c jbp2 = new Joint_Business_Plan__c();
        jbp2.Name = 'Test Joint Business Plan'; 
        jbp2.CurrencyISOCode = 'USD';  
        jbp2.Start_Date__c = Date.valueOf(system.now());
        jbp2.End_Date__c = Date.valueOf(system.now());
        jbp2.Status__c='Draft';
        return jbp2;
    }
  
    public static Joint_Business_Plan_Contact_Role__c createJointBussPlanContRole(){
        Joint_Business_Plan_Contact_Role__c jbpContRole = new Joint_Business_Plan_Contact_Role__c();
        jbpContRole.Product_Lines__c= 'Read/Write';
        jbpContRole.ABB_Perspective_Role__c='Manager';       
        return jbpContRole;
    }
    
     public static Joint_Business_Plan_Contact_Role__c createJointBussPlanContRole1(){
        Joint_Business_Plan_Contact_Role__c jbpContRole1 = new Joint_Business_Plan_Contact_Role__c();
        jbpContRole1.Product_Lines__c= 'Read/Write';
        jbpContRole1.ABB_Perspective_Role__c='Manager';       
        return jbpContRole1;
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
        prod2.Product_Group__c = 2143;
        prod2.CID__c = 'EFGH1234';
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
    
     public static Product_Group__c createProductGroup2() {
        Product_Group__c pg2 = new Product_Group__c();
        pg2.Name = '2143';
        pg2.Product_Group_Name__c = 'Metals';
        pg2.Business_Unit__c = 'PAPI';
        pg2.Business_Unit_Name__c = 'Process Industries';
        pg2.Division__c = 'PA';
        pg2.Division_Name__c ='Process Automation';
        return pg2;
    }
    
    public static  Product_Lines__c createProdLines() {
        Product_Lines__c prodLines = new Product_Lines__c();     
        return prodLines;
    }
    
    public static  Product_Lines__c createProdLines1() {
        Product_Lines__c prodLines1 = new Product_Lines__c();     
        return prodLines1;
    }
    
    public static  Channel_Market_Coverage_Product_Lines__c createCMCProdLines(){
        Channel_Market_Coverage_Product_Lines__c cmcprodLines = new Channel_Market_Coverage_Product_Lines__c();    
        return cmcprodLines;
    }
    
    public static  Channel_Market_Coverage_Product_Lines__c createCMCProdLines2(){
        Channel_Market_Coverage_Product_Lines__c cmcprodLines2 = new Channel_Market_Coverage_Product_Lines__c();    
        return cmcprodLines2;
    }
    
    public static  Channel_Market_Coverage_Product_Lines__c createCMCProdLines3(){
        Channel_Market_Coverage_Product_Lines__c cmcprodLines3 = new Channel_Market_Coverage_Product_Lines__c();    
        return cmcprodLines3;
    }
    
   public static Joint_Business_Plan_Market_Coverage__c createJBPMarkCov(){
        Joint_Business_Plan_Market_Coverage__c jbpMarkCov = new Joint_Business_Plan_Market_Coverage__c();  
        jbpMarkCov.Focussed_Industry1__c = 'Building - Residential Buildings';  
        return jbpMarkCov;
    }
       
    public static Joint_Business_Plan_Product_Lines__c createJBPProdLines(){
        Joint_Business_Plan_Product_Lines__c jbpProdLines = new Joint_Business_Plan_Product_Lines__c();  
        jbpProdLines.Division__c = 'PM'; 
        jbpProdLines.Previous_Year_Currency__c = 16;
        jbpProdLines.Current_Year_Currency__c = 17;
        jbpProdLines.Current_Ongoing_Year__c = 11;      
        jbpProdLines.Second_Year_Currency__c = 12;
        jbpProdLines.Third_Year_Currency__c = 13;
        jbpProdLines.Forecast_Ongoing_Year__c = 14; 
        jbpProdLines.Starting_Year__c='2016';        
        return jbpProdLines;
    }
     
     public static Joint_Business_Plan_Product_Lines__c createJBPProdLines2(){
        Joint_Business_Plan_Product_Lines__c jbpProdLines2 = new Joint_Business_Plan_Product_Lines__c();  
        jbpProdLines2.Division__c = 'PP'; 
        jbpProdLines2.Previous_Year_Currency__c = 66;
        jbpProdLines2.Current_Year_Currency__c = 217;
        jbpProdLines2.Current_Ongoing_Year__c = 31;      
        jbpProdLines2.Second_Year_Currency__c = 22;
        jbpProdLines2.Third_Year_Currency__c = 12;
        jbpProdLines2.Forecast_Ongoing_Year__c = 24; 
 //       jbpProdLines2.Starting_Year__c='2016';        
        return jbpProdLines2;
    }
    
     public static AccountTeamMember createAccountTeamMember1(){
        AccountTeamMember atm = new AccountTeamMember();        
        return atm;
    }
      static testMethod void jointBusinessPlanMethod1(){
         User u1 = createTestUser1();
                insert u1;  
        Account a = createAccount1();
            insert a;  
        Contact con =  createTestContacts();  
            con.AccountId = a.Id;    
            insert con;
        Product2 prod = createProduct();
            insert prod;
        Product2 prod2 = createProduct2();
             insert prod2;     
        Product_Lines__c pl = createProdLines();
            pl.Contact__c = con.Id;
            pl.Product__c = prod.Id;
            insert pl; 
        Product_Lines__c pl1 = createProdLines1();
            pl1.Contact__c = con.Id;
            pl1.Product__c = prod2.Id;
            insert pl1;         
        Customer_Segmentation__c cs1 = createAccSegmentation();
            cs1.Account__c=a.id;
            insert cs1;                 
        Channel_Market_Coverage__c cmc1 = createChannelMarkCov();
            cmc1.Account__c = a.id;
            insert cmc1;  
    
        Id devRecordTypeId = Schema.SObjectType.Joint_Business_Plan__c.getRecordTypeInfosByName().get('4. Technical Channel as Partner').getRecordTypeId();                      
      
        
        /* Joint_Business_Plan__c jbp1 = new Joint_Business_Plan__c();
            jbp1.Name = 'Test Joint Business Plan'; 
            jbp1.Start_Date__c = Date.valueOf(system.now());
            jbp1.End_Date__c = Date.valueOf(system.now());
            jbp1.Status__c='Active';
            jbp1.CurrencyISOCode = 'USD';
            jbp1.Account__c = a.id;
            jbp1.Channel_Market_Coverage__c = cmc1.id;   */   
            //insert jbp1; 
                
        Joint_Business_Plan__c jbp2 = createJointBussPlan2();
            jbp2.Account__c = a.id;
            jbp2.Channel_Market_Coverage__c = cmc1.id;  
            jbp2.recordtypeid=devRecordTypeId;                        
            jbp2.Start_Date__c = Date.valueOf(system.now());               
            jbp2.Assigned_To__c = u1.Id;
            jbp2.Date_for_Next_Review__c = Date.valueOf(system.now());                
            jbp2.Co_operation_Overview_2_Info__c = 'Must Have';
            jbp2.Co_operation_Overview_1_Info__c = 'Must Have';
            jbp2.Suppliers_with_complementary_products__c='TestSuppliers';
            jbp2.Suppliers_with_potential_ABB_offering__c ='Testpotential';
            jbp2.Check_Company_Description__c ='Testcompany';
            jbp2.Existing_ABB_offering__c = 'TestAbbOffering'; 
            jbp2.Status__c = 'Draft'; 
            jbp2.End_Date__c = Date.valueOf(system.now());
            insert jbp2;
            
       /* List<Joint_Business_Plan__c> jbList = new List<Joint_Business_Plan__c> { jbp1, jbp2 };
        Database.insert(jbList,false);
                
        jbList[0].Start_Date__c = Date.valueOf(system.now());
        Joint_Business_Plan__c jbpupdateobj = jbList[0];
        Update jbpupdateobj;  */
            system.debug('jbp2-----'+jbp2);
     /*       try{
                insert jbp2;
            }catch(exception e){}*/
            
        Id devRecordTypeId1 = Schema.SObjectType.Joint_Business_Plan_Actions__c.getRecordTypeInfosByName().get('1.Sales').getRecordTypeId();                        
        Joint_Business_Plan_Actions__c jbpActions = new Joint_Business_Plan_Actions__c();
                jbpActions.Joint_Business_Plan__c = jbp2.id;
                jbpActions.Name='TestJBPActions';
                jbpActions.recordtypeid=devRecordTypeId1; 
                jbpActions.Registered__c = Date.valueOf(system.now()); 
                jbpActions.Deadline__c = Date.valueOf(system.now()); 
                jbpActions.Status__c = 'In progress';                                
                insert jbpActions;
         
        Joint_Business_Plan_Contact_Role__c jbpConRole = createJointBussPlanContRole();
            jbpConRole.Joint_Business_Plan__c = jbp2.Id;
            jbpConRole.Contact__c = con.Id; 
            insert jbpConRole;
            
       Joint_Business_Plan_Contact_Role__c jbpConRole1 = createJointBussPlanContRole1();
            jbpConRole1.Joint_Business_Plan__c = jbp2.Id;
            jbpConRole1.Contact__c = con.Id; 
            insert jbpConRole1;    
                        
        Joint_Business_Plan_Market_Coverage__c jbpMC = createJBPMarkCov();
            jbpMC.Joint_Business_Plan__c = jbp2.Id;
            Insert jbpMC;  
                 
 /*           
 system.runas(u1){       
 try{      
     jbp2.Status__c = 'Closed';
     update jbp2;   
     
     system.debug('-----jbp2.Status__c&&'+jbp2.Status__c);
     delete jbpConRole2;
     }catch(exception e){}
}     
    */   
        Joint_Business_Plan_Product_Lines__c jbpPlines2 = createJBPProdLines();
            jbpPlines2.Joint_Business_Plan__c = jbp2.Id; 
            jbpPlines2.Product__c = prod.Id;
            insert jbpPlines2; 
Test.StartTest();                                 
//Code for Apex Class - ClsAddJointBusinessTeam                              
    Joint_Business_Team__c  jbpTeam = new Joint_Business_Team__c();
        ApexPages.StandardController sc = new ApexPages.StandardController(jbpTeam);
      ClsAddJointBusinessTeam jbpT = new ClsAddJointBusinessTeam(sc);
        jbpT.jointBusinessTeam1.User__c = u1.id;
        jbpT.jointBusinessTeam2.User__c = u1.id;
        jbpT.jointBusinessTeam3.User__c = u1.id;
        jbpT.jointBusinessTeam4.User__c = u1.id;
        jbpT.jointBusinessTeam5.User__c = u1.id;
        jbpT.saveRecord();
        jbpT.saveMoreRecord();
        jbpT.cancel();  
        jbpT.GoBack();
            
//Code for Apex Class - ClsJBPContactRoleCopy 
        apexpages.currentpage().getparameters().put('Id', jbp2.Id);
        ApexPages.StandardController stdCtrller = new ApexPages.StandardController(jbp2);  
        ClsJBPContactRoleCopy contRoleCopy = new  ClsJBPContactRoleCopy(stdCtrller);
        contRoleCopy.copyAccountContacts();                 
        contRoleCopy.goBack();
        ClsJBPContactRoleCopy contRoleCopy1 = new  ClsJBPContactRoleCopy(); 

//Code for Apex Class - ClsPISJBPProductLine
    Joint_Business_Plan_Product_Lines__c jbpPL = new Joint_Business_Plan_Product_Lines__c();
        apexpages.currentpage().getparameters().put('retURL', jbpPlines2.Id);
        ApexPages.StandardController cs = new ApexPages.StandardController(jbpPlines2);      
      ClsPISJBPProductLine custseg = new ClsPISJBPProductLine(cs);
        custseg.GoBack();         
        List<ClsPISJBPProductLine.PISNode> products = new List<ClsPISJBPProductLine.PISNode>();
        ClsPISJBPProductLine.PISNode objPIS = new ClsPISJBPProductLine.PISNode();
        objPIS.cid = prod.Cid__c;
        objPIS.englishDescription = 'englishDescription';
        objPIS.languageSpecificDescription = 'languageSpecfDesption';
        products.add(objPIS);   
        ClsPISJBPProductLine.ProductResult objProdResult1 = new ClsPISJBPProductLine.ProductResult();    
        ClsPISJBPProductLine.ProductResult objResults = ClsPISJBPProductLine.addProducts(jbpPlines2.Id,products);

//Code for Apex Class - ClsJointBusinessPlanEdit
     apexpages.currentpage().getparameters().put('Id', jbpPlines2.Id);
          ApexPages.StandardController jointBusinessPlanEdit = new ApexPages.StandardController(jbpPlines2);        
          ClsJointBusinessPlanEdit jbpBusinessPlanEdit = new ClsJointBusinessPlanEdit(jointBusinessPlanEdit);    
         jbpBusinessPlanEdit.GoBack();   
         ClsJointBusinessPlanEdit.PISNode jbpEdit = new ClsJointBusinessPlanEdit.PISNode();
         jbpEdit.cid = prod.Cid__c;
         jbpEdit.englishDescription = 'englishDescription';
         jbpEdit.languageSpecificDescription = 'languageSpecfDesption';   
         
     ClsJointBusinessPlanEdit.ProductResult prodResult = new ClsJointBusinessPlanEdit.ProductResult();    
     ClsJointBusinessPlanEdit.ProductResult objResult1 = ClsJointBusinessPlanEdit.replaceProduct(jbpPlines2.Id,jbpEdit);   

        Test.StopTest();       
     }
     

     static testMethod void jointBusinessPlanMethod2(){
         Account a = createAccount1();
            insert a;  
         Product2 prod = createProduct();
            insert prod;
         Product2 prod2 = createProduct2();
             insert prod2;       
         Channel_Market_Coverage__c cmc1 = createChannelMarkCov();
            cmc1.Account__c = a.id;
            cmc1.Primary_Channel_Class__c='Engineering, Procurement and Construction (EPC)';
            insert cmc1;         
         Joint_Business_Plan__c jbp1 = createJointBussPlan();
            jbp1.Account__c = a.id;
            jbp1.Channel_Market_Coverage__c = cmc1.id;
            insert jbp1;
         Joint_Business_Plan_Market_Coverage__c jbpMC = createJBPMarkCov();
            jbpMC.Joint_Business_Plan__c = jbp1.Id;
            Insert jbpMC;          
        Channel_Market_Coverage_Product_Lines__c cmcPL = createCMCProdLines();
            cmcPL.Channel_Market_Coverage__c = cmc1.Id;   
            cmcPL.Product__c = prod.Id; 
            insert cmcPL;
Test.StartTest();                  
//Code for Apex Class - ClsJBPMarketCoverage         
          apexpages.currentpage().getparameters().put('Id', jbp1.Id);
          ApexPages.StandardController stdCtrllerMC = new ApexPages.StandardController(jbp1);                                
          ClsJBPMarketCoverage jbpMarkCov =  new ClsJBPMarketCoverage(stdCtrllerMC); 
          jbpMarkCov.createJBPMarketCoverageRec();   
          jbpMarkCov.goback();            
          ClsJBPMarketCoverage jbpMarkCov1 =  new ClsJBPMarketCoverage(); 

//Code for Apex Class - ClsJBPMarketCoverageList  
          apexpages.currentpage().getparameters().put('Id', jbp1.Id);
          ApexPages.StandardController stdCtrllerMCList = new ApexPages.StandardController(jbp1);        
          ClsJBPMarketCoverageList jbpMarCovlist = new ClsJBPMarketCoverageList(stdCtrllerMCList);
          jbpMarCovlist.save();
          jbpMarCovlist.cancel();                                                    
          
/*Code for Apex Class - ClsTriggerJointBusinessPlanHandler            
        ClsTriggerJointBusinessPlanHandler tiggerJBPhandler = new ClsTriggerJointBusinessPlanHandler();     
  
  Joint_Business_Plan__c jbp2 = createJointBussPlan2();
            jbp2.Account__c = a.id;
            jbp2.Channel_Market_Coverage__c = cmc1.id;            
            insert jbp2;   
            Update jbp2;      */  
 /*
      Joint_Business_Plan_Product_Lines__c jbpPlines3 =  createJBPProdLines2();          
            jbpPlines3.Joint_Business_Plan__c = jbp2.Id; 
            jbpPlines3.Product__c = prod2.Id;
            jbpPlines3.Starting_Year__c = '2016'; 
            insert jbpPlines3;
            jbpPlines3.Forecast_Ongoing_Year__c=28;
            jbpPlines3.Current_Ongoing_Year__c=32;            
            jbpPlines3.Actual_Year_to_Date_Changed_on__c= Date.valueOf(system.now());            
            Update jbpPlines3; 
 
        Code for Apex Class - ClsTriggerJBPProductLines 
         ClsTriggerJBPProductLines triggerJointBussPlan = new ClsTriggerJBPProductLines();
  */                     
     Test.StopTest();       
     } 
     
      static testMethod void jointBusinessPlanMethod3(){

            Test.StartTest();
             User u1 = createTestUser1();
                insert u1;  
            Account a = createAccount1();
                insert a;  
                
            AccountTeamMember atm1 = new AccountTeamMember();
                 atm1.AccountId=a.Id;
                 atm1.UserId=u1.Id;
                 insert atm1;  
    
            Product2 prod = createProduct();
    
            Product2 prod2 = createProduct2();
    
            List<Product2> product2List = new List<Product2>(); 
            product2List.add(prod2);
            product2List.add(prod);
            
            insert product2List;
             
            Channel_Market_Coverage__c cmc1 = createChannelMarkCov();
            cmc1.Account__c = a.id;
            insert cmc1; 
                
            Joint_Business_Plan__c jbp1 = createJointBussPlan();
            jbp1.Account__c = a.id;
            jbp1.Channel_Market_Coverage__c = cmc1.id;
            jbp1.Start_Date__c = Date.Today();
            jbp1.End_Date__c = Date.Today().AddDays(1);
            insert jbp1;  
            
            List<Joint_Business_Plan_Product_Lines__c> productLinesList = new List<Joint_Business_Plan_Product_Lines__c>();
                 
            Joint_Business_Plan_Product_Lines__c jbpPlines3=  createJBPProdLines2();          
            jbpPlines3.Joint_Business_Plan__c = jbp1.Id; 
            jbpPlines3.Product__c = product2List[0].Id;
            jbpPlines3.Starting_Year__c =  String.valueOf(Date.Today().YEar()); 
            jbpPlines3.Forecast_Ongoing_Year__c=80;
            productLinesList.add(jbpPlines3);
            
            Joint_Business_Plan_Product_Lines__c jbpPlines4=  createJBPProdLines2();          
            jbpPlines4.Joint_Business_Plan__c = jbp1.Id; 
            jbpPlines4.Product__c = product2List[1].Id;
            jbpPlines4.Starting_Year__c =  String.valueOf(Date.Today().YEar()); 
            jbpPlines4.Forecast_Ongoing_Year__c= 200;
            jbpPlines4.Third_Year_Currency__c = 780;
            productLinesList.add(jbpPlines4);
            
            insert productLinesList;
            ClsTriggerJBPProductLines.processedIdSet = new Set<ID>();
            productLinesList[0].Forecast_Ongoing_Year__c = 140;
            productLinesList[1].Forecast_Ongoing_Year__c = 140;
            update productLinesList;
            
            ClsTriggerJBPProductLines.processedIdSet = new Set<ID>();
            delete productLinesList;
            
            
            
        Test.StopTest();       
     }
     
         static testMethod void jointBusinessPlanMethodCopy(){
 
        Test.StartTest();
        User u1 = createTestUser1();
        insert u1;  
        Account a = createAccount1();
        insert a;  
        AccountTeamMember atm1 = new AccountTeamMember( AccountId=a.Id, UserId=u1.Id);
        insert atm1;  
    
        Product2 prod = createProduct();
        Product2 prod2 = createProduct2();

        List<Product2> product2List = new List<Product2>(); 
        product2List.add(prod2);
        product2List.add(prod);
        
        insert product2List;
         
        Channel_Market_Coverage__c cmc1 = createChannelMarkCov();
        cmc1.Account__c = a.id;
        insert cmc1; 
            
        Joint_Business_Plan__c jbp1 = createJointBussPlan();
        jbp1.Account__c = a.id;
        jbp1.Channel_Market_Coverage__c = cmc1.id;
        jbp1.Start_Date__c = Date.Today();
        jbp1.End_Date__c = Date.Today().AddDays(1);
        insert jbp1;  
        
        List<Channel_Market_Coverage_Product_Lines__c> cmlines = new List<Channel_Market_Coverage_Product_Lines__c>();
           
        Channel_Market_Coverage_Product_Lines__c cmcPL2 = createCMCProdLines();
        cmcPL2.Channel_Market_Coverage__c = cmc1.Id;   
        cmcPL2.Product__c = prod.Id; 
        cmlines.add(cmcPL2);
        
        Channel_Market_Coverage_Product_Lines__c cmcPL3 = createCMCProdLines2();
            cmcPL3.Channel_Market_Coverage__c = cmc1.Id;   
            cmcPL3.Product__c = prod2.Id;          
        cmlines.add(cmcPL3);
       insert cmlines;

        //Code for Apex Class - ClsJBPProductLineCopy 
          apexpages.currentpage().getparameters().put('Id', jbp1.Id);
          ApexPages.StandardController stdCtrllerProdLineCopy = new ApexPages.StandardController(jbp1);        
          ClsJBPProductLineCopy jbpPLCopy = new ClsJBPProductLineCopy(stdCtrllerProdLineCopy);
          jbpPLCopy.copyChanMarCovProductLine();
          jbpPLCopy.copyChanMarCovProductLine();
          jbpPLCopy.GoBack();          
          ClsJBPProductLineCopy jbpPLCopy1 = new ClsJBPProductLineCopy();   
            
        Test.StopTest();       
     }
    
     static testMethod void TestJoinBusinessTeamDeletion() {
     
        Test.startTest();
        
        User u2 = createTestUser2();
        insert u2;
        
        
        profile[] profileList = [ Select Id, Name FROM Profile Where Name IN ('ABB Sales Standard Profile', 'System Administrator')];
        
        ID adminId = (!profileList.IsEmpty() && profileList[0].Name == 'System Administrator') ? profileList[0].Id : profileList[1].Id;
        ID abbID = (!profileList.IsEmpty() && profileList[0].Name == 'ABB Sales Standard Profile') ? profileList[0].Id :  profileList[1].Id;
        
        Account[] accs = new List<Account> {
            new Account ( Name = 'test1',
                BillingStreet = 'street', 
                BillingCity = 'city', 
                BillingCountry = 'Germany'),
            new Account ( Name = 'test2',
                BillingStreet = 'street', 
                BillingCity = 'city', 
                BillingCountry = 'Germany')};
                
        insert accs;
        
        List<User> userList = new List<User>();
        userList.add(createTestUser(abbID, 'TestABB1'));
        userList.add(createTestUser(abbID, 'TestABB2'));
        insert userList;
        
        AccountTeamMember[] accTeamList = new AccountTeamMember[] {
            new AccountTeamMember(AccountId = accs[0].Id, UserID = userList[0].ID),
            new AccountTeamMember(AccountId = accs[0].Id, UserID = userList[1].ID)
        };
        
        insert accTeamList;
       
         
      
        Channel_Market_Coverage__c[] cmcList = new Channel_Market_Coverage__c[]{
            new Channel_Market_Coverage__c(Account__c = accs[0].Id, Primary_Channel_Class__c='Engineering, Procurement and Construction (EPC)', Division__c = 'EP;PA;')
        };
        
        insert cmcList;
        
        Joint_Business_Plan__c[] jbpList = new Joint_Business_Plan__c[] {
            new Joint_Business_Plan__c (Account__c = accs[0].id, Channel_Market_Coverage__c = cmcList[0].id, 
                Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(3), Status__c = 'Draft',OwnerId=userList[0].ID)
        };
        insert jbpList;
    /*    
         Joint_Business_Team__c[] teamList = new Joint_Business_Team__c[] {
            new Joint_Business_Team__c(Joint_Business_Plan__c = jbpList[0].Id, User__c= userList[0].ID, Access__c= 'Read/Write', Team_Role__c='GAM/SAM Account Manager'),
            new Joint_Business_Team__c(Joint_Business_Plan__c = jbpList[0].Id,  USer__c = userList[1].ID, Access__c= 'Read/Write', Team_Role__c='GAM/SAM Account Manager' )
        }; 
        
        insert teamList;
        
       Joint_Business_Plan_Contact_Role__c jbpConRole2 = createJointBussPlanContRole1();
            jbpConRole2.Joint_Business_Plan__c = jbpList[0].Id;
            jbpConRole2.Contact__c = con.Id; 
            insert jbpConRole2;
    */  
      
            
                          
        jbpList[0].Status__c = 'Obsolete';
        
        
       system.runAs(userList[0]) {
            try {     
            Contact con =  createTestContacts();  
            con.AccountId = accs[0].Id;    
            insert con;
            Joint_Business_Plan_Contact_Role__c[] planContRole = new Joint_Business_Plan_Contact_Role__c[] {
        //    new Joint_Business_Plan_Contact_Role__c(Joint_Business_Plan__c = jbpList[0].Id, Contact__c = con.Id,Product_Lines__c= 'Read/Write',ABB_Perspective_Role__c='Manager' ),
            new Joint_Business_Plan_Contact_Role__c(Joint_Business_Plan__c = jbpList[0].Id,Contact__c = con.Id,Product_Lines__c= 'Read/Write',ABB_Perspective_Role__c='Account Manager')
        }; 
        
            insert planContRole;      
        system.debug('planContRole[0]'+planContRole);
            
                  update jbpList;
                  system.debug('TRYBlock'+jbpList[0].Status__c);  
             //   delete teamList[0];
                delete planContRole[0];
            } Catch(DMLEXception e) {
            
            }
        }        
          
        Test.stopTest();       
        
     }
         
     public static User createTestUser(Id profileId, String LastNameVal) {
        User u = new User( FirstName ='haobo', LastName = LastNameVal, Username = 'test123ABB1237'+LastNameVal+'@test123ABB1237.com', Alias = LastNameVal,
            Email = 'mtester1'+LastNameVal+'@company.com', CommunityNickname = LastNameVal,
            ProfileId = profileId, TimeZoneSidKey = 'America/Chicago', LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US', ManagerId = UserInfo.getUserId());
        return u;
    }
     

}