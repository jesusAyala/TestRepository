@isTest
public class ClsTriggerProductQualification_TEST{
static testMethod void MethodProductQualification1(){ 
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
        insert u2;   
   
        Account acc1 = new Account();    
        acc1.Name = 'Test Account1 239';    
        acc1.Primary_Account_Manager__c = 'mtester@company.com';   
        acc1.BillingStreet = 'dajie';
        acc1.BillingCity = 'berlin';
        acc1.BillingState = 'Berlin';
        acc1.BillingPostalCode = '20012';
        acc1.BillingCountry = 'Germany';
        insert acc1;
    
        Account acc2 = new Account();    
        acc2.Name = 'Test Account2 239';    
        acc2.Primary_Account_Manager__c = 'mtester1@company.com';   
        acc2.BillingStreet = 'dajie1';
        acc2.BillingCity = 'berlin1';
        acc2.BillingState = 'Bayern';
        acc2.BillingPostalCode = '20098';
        acc2.BillingCountry = 'Germany';
        insert acc2;

        Account acc3 = new Account();    
        acc3.Name = 'Test Account3 239';    
        acc3.Primary_Account_Manager__c = 'mtester12@company.com';   
        acc3.BillingStreet = 'dajie132';
        acc3.BillingCity = 'berlin123';
        acc3.BillingState = 'Jilin';
        acc3.BillingPostalCode = '200123';
        acc3.BillingCountry = 'China';
        insert acc3;
        
        Account acc4 = new Account();    
        acc4.Name = 'Test Account4 239';    
        acc4.Primary_Account_Manager__c = 'mtester124@company.com';   
        acc4.BillingStreet = 'dajie1324';
        acc4.BillingCity = 'berlin123';
        acc4.BillingState = 'hunan';
        acc4.BillingPostalCode = '2265123';
        acc4.BillingCountry = 'China';
        insert acc4;
     
   Contact cont1 = new Contact();       
        cont1.LastName = 'Test Contact'; 
        cont1.Email = 'test@test.com';
        cont1.MailingCountry = 'Afghanistan';
        insert cont1;
   
   ABB_Location__c abblocation1 = new ABB_Location__c();
       abblocation1.Name = 'abblocation1'; 
       abblocation1.Activity__c = 'testactivity';   
       abblocation1.Address__c = 'testAddress';
       abblocation1.BALId__c = 'tes123';
       abblocation1.BU__c = 'testBU';
       abblocation1.City__c = 'china';
       abblocation1.Product_Group__c = '2134';
       abblocation1.Company__c = 'testcompany';
       abblocation1.Country__c = 'china';
       abblocation1.Descriptive_Name__c = 'testdescriptive';
       abblocation1.DIV__c = 'testDIV';
       abblocation1.LocationId__c = 'loca123';
       abblocation1.Location_Type__c = 'Main';
       abblocation1.Non_ABB__c = 'non ABB';
       abblocation1.Region__c = 'Europe';
       abblocation1.Successor__c = 'sucess';
       insert abblocation1;    
              
   Product2 productlist1 = new Product2(); 
       productlist1.name='product1';  
       productlist1.Product_Group__c=2134;
        productlist1.IsActive = true;
       insert productlist1;
    
   Product_Group__c prodGroup1 = new Product_Group__c();    
       prodGroup1.Name = '2134';
       prodGroup1.Product_Group_Code__c = '2134';
       prodGroup1.Business_Unit__c = 'BU';
       prodGroup1.Business_Unit_Name__c = 'BUName';
       prodGroup1.Division__c ='DIV';
       prodGroup1.Division_Name__c = 'DIV name';
       insert prodGroup1;
              
   Product_Qualification__c prodQual1 = new Product_Qualification__c(); 
       prodQual1.Actual_Cost_USD__c=1;  
       prodQual1.Account__c=acc1.id;
       prodQual1.Competitor_Account_Name__c = 'acc1';
       prodQual1.Actual_End_Date__c=Date.valueOf(system.now());
       prodQual1.Initiative_Name__c='test1';
       prodQual1.Initiative_Strategic_Reason__c='testing';
       prodQual1.Initiative_Status__c='open';
       prodQual1.Reason_for_not_Qualified__c='Not Fulfilling Customer Specification';
       prodQual1.Available_Market_CAPEX__c=2;
       prodQual1.Available_Market_OPEX__c=1;
       prodQual1.Approval_Date__c=Date.valueOf(system.now());
       prodQual1.Quotation_ID__c='test123';
       prodQual1.Quotation_Value__c=12;
       prodQual1.Startdate__c=Date.valueOf(system.now());  
       prodQual1.Target_End_Date__c=Date.valueOf(system.now().AddDays(1));   
       prodQual1.Comments__c='testcomments';
       prodQual1.Estimated_Cost_USD__c=21;
       prodQual1.Actual_Cost_USD__c=1;
       prodQual1.Quotation_Status__c='won'; 
       prodQual1.Quotation_Closed_Date__c=Date.valueOf(system.now());
       insert prodQual1;    
  
   Product_Qualification_Team_Role__c prodQualteam1 = new Product_Qualification_Team_Role__c(); 
       prodQualteam1.Product_Qualification__c = prodQual1.id;
       prodQualteam1.User__c = u2.id;
       prodQualteam1.Team_Role__c='test1';  
       prodQualteam1.Access__c='Read/Write';
       insert prodQualteam1;
       
       prodQualTeam1.Team_Role__c = 'Test Role1'; 
       update prodQualteam1;       
       delete prodQualteam1;
             
    Product_Qualification_Team_Role__c prodQualteam = new Product_Qualification_Team_Role__c(); 
       prodQualteam.Product_Qualification__c = prodQual1.id;
       prodQualteam.User__c = u2.id;
       prodQualteam.Team_Role__c='test1';  
       prodQualteam.Access__c='Read/Write';
       insert prodQualteam;
       
       prodQualTeam.Team_Role__c = 'Test Role1'; 
       update prodQualteam;      
   
  
   Product_Qualification_Level__c prodQualLevel = new Product_Qualification_Level__c();      
       prodQualLevel.Product_Qualification__c = prodQual1.id;
       prodQualLevel.Option1_NQual__c = 'Yes';
       prodQualLevel.Option2_NQual__c = 'Yes';
       prodQualLevel.Option_1Planning__c = 'Yes';
       prodQualLevel.Option_2Planning__c = 'Yes';
       prodQualLevel.Option_3Planning__c = 'Yes';
       prodQualLevel.Option_4Planning__c = 'Yes';
       prodQualLevel.Option_1Execution__c = 'Yes';
       prodQualLevel.Option_2Execution__c = 'Yes';
       prodQualLevel.Option_3Execution__c = 'Yes';
       prodQualLevel.Option_4Execution__c = 'Yes';
       prodQualLevel.Option_5Execution__c = 'Yes';
       prodQualLevel.Option_1Submitted__c = 'Yes';
       prodQualLevel.Option_2Submitted__c = 'Yes';
       prodQualLevel.Option_1Qualified1__c = 'Yes';
       prodQualLevel.Option_2Qualified2__c = 'Yes';
       prodQualLevel.Date_when_Step_is_setStep1NQual__c = Date.valueOf(system.now());
       prodQualLevel.Date_when_Step_is_setStep2NQual__c = Date.valueOf(system.now());
       prodQualLevel.Date_when_Step_is_setPlanning1__c = Date.valueOf(system.now());
       prodQualLevel.Date_when_Step_is_setPlanning2__c = Date.valueOf(system.now());
       prodQualLevel.Date_when_Step_is_setPlanning3__c = Date.valueOf(system.now());
       prodQualLevel.Date_when_Step_is_setPlanning4__c = Date.valueOf(system.now());
       prodQualLevel.Date_when_Step_is_setExecution1__c = Date.valueOf(system.now());
       prodQualLevel.Date_when_Step_is_setExecution2__c = Date.valueOf(system.now());
       prodQualLevel.Date_when_Step_is_setExecution3__c = Date.valueOf(system.now());
       prodQualLevel.Date_when_Step_is_setExecution4__c = Date.valueOf(system.now());
       prodQualLevel.Date_when_Step_is_setExecution5__c = Date.valueOf(system.now());
       prodQualLevel.Date_when_Step_is_setSubmitted1__c = Date.valueOf(system.now());
       prodQualLevel.Date_when_Step_is_setSubmitted2__c = Date.valueOf(system.now());
       prodQualLevel.Date_when_Step_is_setQualified1__c = Date.valueOf(system.now());
       prodQualLevel.Date_when_Step_is_setQualified1__c = Date.valueOf(system.now());
       insert prodQualLevel;

    Competitor_Product_Qualification__c compProdQual = new Competitor_Product_Qualification__c();   
        compProdQual.Product_Qualification__c = prodQual1.id;
        compProdQual.Account__c = acc3.id;
        compProdQual.Comments__c = 'testcomments';
        Test.startTest(); 
        insert compProdQual;
        Test.stopTest(); 
      

  Contact_Role__c controle1 = new Contact_Role__c();
         controle1.Product_Qualification__c = prodQual1.id;
         controle1.Role__c='Read';
         controle1.Contact__c = cont1.id;
         insert controle1;
         delete controle1;  
}

static testMethod void MethodProductQualification2(){ 

        Account acc1 = new Account();    
        acc1.Name = 'Test Account5 239';    
        acc1.Primary_Account_Manager__c = 'mtester5@company.com';   
        acc1.BillingStreet = 'dajie5';
        acc1.BillingCity = 'berlin5';
        acc1.BillingState = 'Berlin';
        acc1.BillingPostalCode = '520012';
        acc1.BillingCountry = 'Germany';
        insert acc1;
        
        Account acc2 = new Account();    
        acc2.Name = 'Test Account2 239';    
        acc2.Primary_Account_Manager__c = 'mtester1@company.com';   
        acc2.BillingStreet = 'dajie1';
        acc2.BillingCity = 'berlin1';
        acc2.BillingState = 'Bayern';
        acc2.BillingPostalCode = '20098';
        acc2.BillingCountry = 'Germany';
        insert acc2;
        
      Product_Qualification__c prodQual1 = new Product_Qualification__c(); 
       prodQual1.Actual_Cost_USD__c=1;  
       prodQual1.Account__c=acc1.id;
       prodQual1.Competitor_Account_Name__c = 'acc1';
       prodQual1.Actual_End_Date__c=Date.valueOf(system.now());
       prodQual1.Initiative_Name__c='test1';
       prodQual1.Initiative_Strategic_Reason__c='testing';
       prodQual1.Reason_for_not_Qualified__c='Not Fulfilling Customer Specification';
       prodQual1.Available_Market_CAPEX__c=2;
       prodQual1.Available_Market_OPEX__c=1;
       prodQual1.Approval_Date__c=Date.valueOf(system.now());
       prodQual1.Quotation_ID__c='test123';
       prodQual1.Quotation_Value__c=12;
       prodQual1.Startdate__c=Date.valueOf(system.now());  
       prodQual1.Target_End_Date__c=Date.valueOf(system.now().AddDays(1));   
       prodQual1.Comments__c='testcomments';
       prodQual1.Estimated_Cost_USD__c=21;
       prodQual1.Actual_Cost_USD__c=1;
       prodQual1.Quotation_Status__c='won'; 
       prodQual1.Quotation_Closed_Date__c=Date.valueOf(system.now());
       insert prodQual1;  
       
  ABB_Location__c abblocation1 = new ABB_Location__c();
       abblocation1.Name = 'abblocation1'; 
       abblocation1.Activity__c = 'testactivity';   
       abblocation1.Address__c = 'testAddress';
       abblocation1.BALId__c = 'tes123';
       abblocation1.BU__c = 'testBU';
       abblocation1.City__c = 'china';
       abblocation1.Product_Group__c = '2134';
       abblocation1.Company__c = 'testcompany';
       abblocation1.Country__c = 'china';
       abblocation1.Descriptive_Name__c = 'testdescriptive';
       abblocation1.DIV__c = 'testDIV';
       abblocation1.LocationId__c = 'loca123';
       abblocation1.Location_Type__c = 'Main';
       abblocation1.Non_ABB__c = 'non ABB';
       abblocation1.Region__c = 'Europe';
       abblocation1.Successor__c = 'sucess';
       insert abblocation1;    

Product2 productlist1 = new Product2(); 
       productlist1.name='product1';  
       productlist1.Product_Group__c=2134;
        productlist1.IsActive = true;
       insert productlist1;
    
   Qualification_Products_List__c qualProd = new Qualification_Products_List__c();                               
       qualProd.Product_Qualification__c = prodQual1.id;
       qualProd.ABB_Location__c = abblocation1.Id;
       qualProd.Product__c = productlist1.Id;
       qualProd.Commercial_Name__c = 'testcommercial';   
       insert qualProd;
       delete qualProd;
      
        Competitor_Product_Qualification__c compProdQual1 = new Competitor_Product_Qualification__c();   
        compProdQual1.Product_Qualification__c = prodQual1.id;
        compProdQual1.Account__c = acc2.id;
        compProdQual1.Comments__c = 'testcomments';
        Test.startTest(); 
        insert compProdQual1;    
        Test.stopTest();     
        delete compProdQual1;
        
       Product_Qualification_Level__c prodQualLevel = new Product_Qualification_Level__c();
       prodQualLevel.Product_Qualification__c = prodQual1.id;
       prodQualLevel.Option1_NQual__c = 'No';
       prodQualLevel.Option2_NQual__c = 'No';
       try {
       insert prodQualLevel;               
       }Catch(DMLException e) {}                 
                                                                       
}

static testMethod void MethodProductQualification3(){ 

       Account acc1 = new Account();    
        acc1.Name = 'Test Account6 239';    
        acc1.Primary_Account_Manager__c = 'mtester6@company.com';   
        acc1.BillingStreet = 'dajie6';
        acc1.BillingCity = 'berlin6';
        acc1.BillingState = 'Berlin';
        acc1.BillingPostalCode = '620012';
        acc1.BillingCountry = 'Germany';
        insert acc1;
        
      Product_Qualification__c prodQual1 = new Product_Qualification__c(); 
       prodQual1.Actual_Cost_USD__c=1;  
       prodQual1.Account__c=acc1.id;
       prodQual1.Competitor_Account_Name__c = 'acc1';
       prodQual1.Actual_End_Date__c=Date.valueOf(system.now());
       prodQual1.Initiative_Name__c='test1';
       prodQual1.Initiative_Strategic_Reason__c='testing';
       prodQual1.Reason_for_not_Qualified__c='Not Fulfilling Customer Specification';
       prodQual1.Available_Market_CAPEX__c=2;
       prodQual1.Available_Market_OPEX__c=1;
       prodQual1.Startdate__c=Date.valueOf(system.now());  
       prodQual1.Target_End_Date__c=Date.valueOf(system.now().AddDays(1));   
       prodQual1.Comments__c='testcomments';
       prodQual1.Estimated_Cost_USD__c=21;
       prodQual1.Actual_Cost_USD__c=1;
       insert prodQual1;  
             
       Product_Qualification_Level__c prodQualLevel = new Product_Qualification_Level__c();
       prodQualLevel.Product_Qualification__c = prodQual1.id;
       prodQualLevel.Option1_NQual__c = 'Yes';
       insert prodQualLevel;   
       
       ApexPages.StandardController scon1 = new ApexPages.StandardController(prodQual1);
        ProductQualificationLevelRecordCount reccount1 = new ProductQualificationLevelRecordCount(scon1);
        reccount1.recordCount(); 
                     
        ApexPages.currentPage().getParameters().put('id',prodQual1.Id);                             
        ApexPages.StandardController scon = new ApexPages.StandardController(prodQual1);
        ProductQualificationLevelRecordCount reccount = new ProductQualificationLevelRecordCount(scon);
        reccount.recordCount(); 
        reccount.prodName =  prodQual1.Name;   
        reccount.GoBack();       
        
}

static testMethod void MethodProductQualification4(){ 

User u2 = new User();
        u2.FirstName ='haikoo';
        u2.LastName = 'testg';
        u2.Username = 'haikootest321ABB12344@test123ABB12344.com';
        u2.Alias = 'mtasd';
        u2.Email = 'mtester12@company.com';
        u2.ProfileId = [Select Id from Profile Where Name = 'ABB Sales Standard Profile' limit 1].Id;
        u2.TimeZoneSidKey = 'America/Chicago';
        u2.LocaleSidKey = 'en_US';
        u2.EmailEncodingKey = 'UTF-8';
        u2.LanguageLocaleKey = 'en_US';
        u2.ManagerId = UserInfo.getUserId();
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
        u3.ManagerId = UserInfo.getUserId();
        insert u3;
        
       User u4 = new User();
        u4.FirstName ='hellomanager';
        u4.LastName = 'managertestg';
        u4.Username = 'hellomanagerABB123111111@test123ABB1231111111.com';
        u4.Alias = 'otsd';
        u4.Email = 'managertester12@company.com';
        u4.ProfileId = [Select Id from Profile Where Name = 'ABB Sales Standard Profile' limit 1].Id;
        u4.TimeZoneSidKey = 'America/Chicago';
        u4.LocaleSidKey = 'en_US';
        u4.EmailEncodingKey = 'UTF-8';
        u4.LanguageLocaleKey = 'en_US';
        u4.ManagerId = UserInfo.getUserId();
        insert u4;
        
        User u5 = new User();
        u5.FirstName ='managerhello';
        u5.LastName = 'testgmanager';
        u5.Username = 'managerhelloABB1232222222@test123ABB12323232.com';
        u5.Alias = 'mgdsc';
        u5.Email = 'tester12manager@company.com';
        u5.ProfileId = [Select Id from Profile Where Name = 'ABB Sales Standard Profile' limit 1].Id;
        u5.TimeZoneSidKey = 'America/Chicago';
        u5.LocaleSidKey = 'en_US';
        u5.EmailEncodingKey = 'UTF-8';
        u5.LanguageLocaleKey = 'en_US';
        u5.ManagerId = UserInfo.getUserId();
        insert u5;
        
       User u6 = new User();
        u6.FirstName ='managertest12';
        u6.LastName = 'test12manager';
        u6.Username = 'test12helloABB1231231231231@test123ABB1231231231.com';
        u6.Alias = 'mfrdc';
        u6.Email = 'test12manager@company.com';
        u6.ProfileId = [Select Id from Profile Where Name = 'ABB Sales Standard Profile' limit 1].Id;
        u6.TimeZoneSidKey = 'America/Chicago';
        u6.LocaleSidKey = 'en_US';
        u6.EmailEncodingKey = 'UTF-8';
        u6.LanguageLocaleKey = 'en_US';
        u6.ManagerId = UserInfo.getUserId();
        insert u6;

        Account acc1 = new Account();    
        acc1.Name = 'Test Account6 239';    
        acc1.Primary_Account_Manager__c = 'mtester6@company.com';   
        acc1.BillingStreet = 'dajie6';
        acc1.BillingCity = 'berlin6';
        acc1.BillingState = 'Berlin';
        acc1.BillingPostalCode = '620012';
        acc1.BillingCountry = 'Germany';
        insert acc1;
        
      Product_Qualification__c prodQual1 = new Product_Qualification__c(); 
       prodQual1.Actual_Cost_USD__c=1;  
       prodQual1.Account__c=acc1.id;
       prodQual1.Competitor_Account_Name__c = 'acc1';
       prodQual1.Actual_End_Date__c=Date.valueOf(system.now());
       prodQual1.Initiative_Name__c='test1';
       prodQual1.Initiative_Strategic_Reason__c='testing';
       prodQual1.Reason_for_not_Qualified__c='Not Fulfilling Customer Specification';
       prodQual1.Available_Market_CAPEX__c=2;
       prodQual1.Available_Market_OPEX__c=1;
       prodQual1.Startdate__c=Date.valueOf(system.now());  
       prodQual1.Target_End_Date__c=Date.valueOf(system.now().AddDays(1));   
       prodQual1.Comments__c='testcomments';
       prodQual1.Estimated_Cost_USD__c=21;
       prodQual1.Actual_Cost_USD__c=1;
       insert prodQual1;        
            
  Product_Qualification_Team_Role__c prodQualteam1 = new Product_Qualification_Team_Role__c(); 
       prodQualteam1.Product_Qualification__c = prodQual1.id;
       prodQualteam1.User__c = u2.id;
       prodQualteam1.Team_Role__c='test1';  
       prodQualteam1.Access__c='Read/Write';
       insert prodQualteam1;
       
       prodQualTeam1.Team_Role__c = 'Test Role1'; 
       update prodQualteam1;       
       delete prodQualteam1;  
   
 ApexPages.StandardController sc = new ApexPages.StandardController(prodQualteam1);
        AddProductQualificationTeam objCT = new AddProductQualificationTeam(sc);
        objCT.prodQualTeam1.Product_Qualification__c = prodQual1.id;
        objCT.prodQualTeam1.User__c = u2.id;
        objCT.prodQualTeam1.Team_Role__c = 'Test1';
        objCT.prodQualTeam1.Access__c = 'Read/Write';
        objCT.prodQualTeam2.Product_Qualification__c = prodQual1.id;
        objCT.prodQualTeam2.User__c = u3.id;
        objCT.prodQualTeam2.Team_Role__c = 'Test1';
        objCT.prodQualTeam2.Access__c = 'Read/Write';
        objCT.prodQualTeam3.Product_Qualification__c = prodQual1.id;
        objCT.prodQualTeam3.User__c = u4.id;
        objCT.prodQualTeam3.Team_Role__c = 'Test1';
        objCT.prodQualTeam3.Access__c = 'Read/Write';
        objCT.prodQualTeam4.Product_Qualification__c = prodQual1.id;
        objCT.prodQualTeam4.User__c = u5.id;
        objCT.prodQualTeam4.Team_Role__c = 'Test1';
        objCT.prodQualTeam4.Access__c = 'Read/Write';
        objCT.prodQualTeam5.Product_Qualification__c = prodQual1.id;
        objCT.prodQualTeam5.User__c = u6.id;
        objCT.prodQualTeam5.Team_Role__c = 'Test1';
        objCT.prodQualTeam5.Access__c = 'Read/Write';
        objCT.saveRecord();
        objCT.saveMoreRecord();
        objCT.cancel();     
        objCT.GoBack();  

} 
 
 }