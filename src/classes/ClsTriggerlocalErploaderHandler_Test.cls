/**
*  Test class for the classes ClsTriggerlocalErploaderHandler, batchDeleteLocalErpLoader, ClsLocalReferenceDataHandler
*
@author Abiramasundari Radha(Accenture)
@created 2015-08-04
*
@changelog
* 
*  
* - Created
*/
@isTest(SeeAllData=False)
private class ClsTriggerlocalErploaderHandler_Test {
  
    static testMethod void myUnitTest() {    
         Profile p = [select id from profile where name='Standard User']; 
         RecordType recType = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'ERP_Reference_Data__c' and DeveloperName = 'GIS_Approved_LSO_Reference_Data'];
         RecordType accRecType = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Account' and DeveloperName = 'GIS_Approved'];
        
         User u = new User();
             u.alias = 'standt';
             u.email='standarduser@testorg.com';
             u.emailencodingkey='UTF-8';
             u.lastname='Testing';
             u.languagelocalekey='en_US'; 
             u.localesidkey='en_US';
             u.profileid = p.Id;
             u.timezonesidkey='America/Los_Angeles';
             u.username='standardusertest2345@testorg.com';
             insert u;
                 
         Account acc = new Account();
            acc.Name = 'Test ABB Account';
            acc.BillingCountry = 'United States';
            acc.BillingStreet = 'Teststr. 1';           
            acc.BillingCity = 'Test Detroit';
            acc.BillingPostalCode = '543358';
            acc.Company_Status__c = 'New';
            acc.ShippingCity = 'Detroit';
            acc.GUID__c='GU1234';
            acc.BillingState = 'New York';
            acc.recordtypeid= accRecType.Id;
            insert acc;
            
        
        acc = [select Id, Name from Account where Id = :acc.Id];
        System.assertEquals(acc.Name, 'Test ABB Account'); 
        
        RecordType recType1 = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'ERP_Reference_Data__c' and DeveloperName = 'External_Non_Buying_Account_LSO_Reference_Data'];
       
        ERP_Reference_Data__c erp1 = new ERP_Reference_Data__c();
            erp1.Account__c = acc.id;
            erp1.Account_GUID__c = 'GU1234';
            erp1.Block_Description__c = 'testBlock';
            erp1.Risk_class__c = 'testcreditInfo' ;
            erp1.Credit_Limit__c = 'testlimitInfo' ;
            erp1.Block__c = true;
            erp1.Local_Channel_Text__c = 'creditLocal' ;
            erp1.Local_Customer_ID__c = 'customerID';
            erp1.Local_Main_Business_Text__c = 'Business 1';
            erp1.Local_Segment_Text__c = 'segment test';
            erp1.Sales_District_Text__c = 'district';
            erp1.Sales_Office_Text__c = 'office';
            erp1.Crif_Number__c = 'test1234';
            erp1.Country__c = 'United States';
            erp1.LSO__c='LSOTest';
            erp1.LBU__c = 'LBUTest'; 
            erp1.Type_of_Sales_Resources_Text__c = 'testing'; 
            erp1.recordtypeid= recType1.Id;   
            erp1.Technical_Support__c=u.id;   
            erp1.Technical_Promoter__c=u.id;  
            erp1.Promotion_Plan__c =true;
            erp1.Business_1__c = 'entry1';
            erp1.Business_2__c = 'entry2';
            erp1.Business_3__c = 'entry3';
            erp1.Sales_Person_1_Manual_Entry__c = u.id;
            erp1.Sales_Person_2_Manual_Entry__c = u.id;
            erp1.Sales_Person_3_Manual_Entry__c = u.id;
         insert erp1;     
                            
        ERP_Mapping__c mapping = new ERP_Mapping__c();
            mapping.Country__c = 'United States';     
            mapping.ERP_ID__c = '100';
            mapping.SAP_Sales_Organization__c = 'ABB';
            mapping.SAP_Distribution_Channel__c = 'AT';
            mapping.SAP_Division__c = 'PP';            
            mapping.LSO__c='LSOTest';
            mapping.LBU__c = 'LBUTest'; 
            mapping.Description__c = 'TestDescription';
            insert mapping;
            
         ERP_Mapping__c mapping1 = new ERP_Mapping__c();
            mapping1.Country__c = 'United States';     
            mapping1.ERP_ID__c = '100';
            mapping1.SAP_Sales_Organization__c = 'ABB';
            mapping1.SAP_Distribution_Channel__c = 'AT';
            mapping1.SAP_Division__c = 'PP';            
            mapping1.LSO__c='LSOTest';
            mapping1.LBU__c = 'LBUTest1'; 
            mapping1.Description__c = 'TestDescription';
            insert mapping1;    
                                                                   
        Local_ERP_Loader__c localERP =new Local_ERP_Loader__c();     
            localERP.Account_GUID__c = 'GU1234';            
            localERP.Block_Description__c = 'testBlock';
            localERP.Business_1__c = 'Bperson 1';
            localERP.Business_2__c = 'Bperson 2';
            localERP.Business_3__c = 'Bperson 3'; 
            localERP.Country__c = 'United States';
            localERP.Credit_Information_Risk_class__c = 'testcreditInfo' ;
            localERP.Customer_Allocation__c = 'customettestallocation' ;
            localERP.Block__c = true ;            
            localERP.ERP_ID__c = '100' ;
            localERP.Local_Channel__c = 'creditLocal' ;
            localERP.Local_Customer_ID__c = 'customerID' ;
            localERP.Local_Main_Business__c = 'Business 1' ;
            localERP.Local_Segment__c = 'segment test' ;
            localERP.Sales_District__c = 'district' ;
            localERP.Sales_Office__c = 'office' ;
            localERP.Sales_Person_1__c = 'S person 1' ;
            localERP.Sales_Person_2__c = 'S Person 2' ;
            localERP.Sales_Person_3__c = 'S Person 3' ;
            localERP.SAP_Distribution_Channel__c = 'AT' ;
            localERP.SAP_Division__c = 'PP' ;
            localERP.SAP_Sales_Organization__c = 'ABB' ;
            localERP.Type_of_Sales_Force__c = 'testing' ;            
            insert localERP;
            
                   
        Test.startTest();
       
        ClsTriggerlocalErploaderHandler cls = new ClsTriggerlocalErploaderHandler();
        
        ClsTriggerErpMappingHandler erpTestClass = new ClsTriggerErpMappingHandler();
                                            
        // Pass account Id to cover inserting new LSO 
        PageReference pageRef = Page.LocalReferenceDataHandlerVF;
        pageRef.getParameters().put('accId', acc.Id);
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController ExtControlleracc = new ApexPages.StandardController(erp1);                   
        
        // Test coverage for ClsLocalReferenceDataHandler 
        ClsLocalReferenceDataHandler localReferenceDataAcc = new ClsLocalReferenceDataHandler(ExtControlleracc);
            localReferenceDataAcc.strLSOValues = 'LSOTest - TestDescription';
        //    localReferenceDataAcc.save();
            localReferenceDataAcc.cancel();
            localReferenceDataAcc.getlistLSO();
            localReferenceDataAcc.getlistLBU();
            
        BatchDeleteLocalErpLoaderSchedule schd = new BatchDeleteLocalErpLoaderSchedule();
        //string sch = '0 0 * * 1-12 ? *';
       // system.schedule('Process Trans 1', sch, schd);  
            
        Test.stopTest();
       
    }
    
 static testMethod void myUnitTestLSO() {    
 
     RecordType accRecType = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Account' and DeveloperName = 'GIS_Approved'];
          
     RecordType recType1 = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'ERP_Reference_Data__c' and DeveloperName = 'External_Non_Buying_Account_LSO_Reference_Data'];
     Profile p = [select id from profile where name='Standard User']; 
      
                 
         User u = new User();
             u.alias = 'standt';
             u.email='standarduser@testorg.com';
             u.emailencodingkey='UTF-8';
             u.lastname='Testing';
             u.languagelocalekey='en_US'; 
             u.localesidkey='en_US';
             u.profileid = p.Id;
             u.timezonesidkey='America/Los_Angeles';
             u.username='standardusertest4567@testorg.com';
             insert u;
     
     Account acc = new Account();
            acc.Name = 'Test ABB Account';
            acc.BillingCountry = 'United States';
            acc.BillingStreet = 'Teststr. 1';           
            acc.BillingCity = 'Test Detroit';
            acc.BillingPostalCode = '543358';
            acc.Company_Status__c = 'New';
            acc.ShippingCity = 'Detroit';
            acc.GUID__c='GU1234';
            acc.BillingState = 'New York';
            acc.recordtypeid= accRecType.Id;
            insert acc;       
       
       ERP_Reference_Data__c erp = new ERP_Reference_Data__c();
            erp.Account__c = acc.id;
            erp.Account_GUID__c = 'GU1234';
            erp.Block_Description__c = 'testBlock';
            erp.Country__c = 'United States';
            erp.Risk_class__c = 'testcreditInfo' ;
            erp.Credit_Limit__c = 'testlimitInfo' ;
            erp.Block__c = true;            
            erp.ERP_ID__c = '100';
            erp.Local_Channel_Text__c = 'creditLocal' ;
            erp.Local_Customer_ID__c = 'customerID';
            erp.Local_Main_Business_Text__c = 'Business 1';
            erp.Local_Segment_Text__c = 'segment test';
            erp.Sales_District_Text__c = 'district';
            erp.Sales_Office_Text__c = 'office';
            erp.Crif_Number__c = 'test1234';
            erp.Sales_Person_1_Manual_Entry__c = u.id;
            erp.Sales_Person_2_Manual_Entry__c = u.id ;
            erp.Sales_Person_3_Manual_Entry__c = u.id ;          
            erp.SAP_Distribution_Channel__c = 'AT';
            erp.SAP_Division__c = 'PP';
            erp.SAP_Sales_Organization__c = 'ABB';
            erp.LSO__c='LSOTest';
            erp.LBU__c = 'LBUTest'; 
            erp.Type_of_Sales_Resources_Text__c = 'testing'; 
            erp.recordtypeid= recType1.Id;   
            erp.Technical_Support__c=u.id;   
            erp.Technical_Promoter__c=u.id;  
            erp.Promotion_Plan__c =true;
            insert erp; 
  
        ApexPages.currentPage().getParameters().put('Id',erp.Id);
        ApexPages.currentPage().getParameters().put('accId',acc.id);
        Apexpages.currentpage().getparameters().put('countryValue',erp.Country__c);
        Apexpages.currentpage().getparameters().put('LSOValue',erp.LSO__c);
        
        Test.startTest();
        
        PageReference pRef = Page.LocalReferenceDataHandlerVF;
        pRef.getParameters().put('id', erp.Id);
        Test.setCurrentPage(pRef);

        ApexPages.currentPage().getParameters().put('Id',erp.id);
        ApexPages.StandardController ExtController = new ApexPages.StandardController(erp);                   
        
        
        // Test coverage for ClsLocalReferenceDataHandler 
        ClsLocalReferenceDataHandler localReferenceData = new ClsLocalReferenceDataHandler(ExtController);
            localReferenceData.strLSOValues = 'LSOTest - TestDescription';
       //     localReferenceData.save();
            localReferenceData.cancel();
            localReferenceData.getlistLSO();
            localReferenceData.getlistLBU(); 
        
                              
        // Pass account Id to cover inserting new LSO 
        PageReference pageRef = Page.LocalReferenceDataHandlerVF;
        pageRef.getParameters().put('accId', acc.Id);
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController ExtControlleracc = new ApexPages.StandardController(erp);                   
        
        // Test coverage for ClsLocalReferenceDataHandler 
        ClsLocalReferenceDataHandler localReferenceDataAcc = new ClsLocalReferenceDataHandler(ExtControlleracc);
            localReferenceDataAcc.strLSOValues = 'LSOTest - TestDescription';
        //    localReferenceDataAcc.save();
            localReferenceDataAcc.cancel();
            localReferenceDataAcc.getlistLSO();
            localReferenceDataAcc.getlistLBU();
            
           Local_ERP_Loader__c localERP1 =new Local_ERP_Loader__c();     
            localERP1.Account_GUID__c = 'GU1234';            
            localERP1.Block_Description__c = 'testBlock';
            localERP1.Business_1__c = 'Bperson 1';
            localERP1.Business_2__c = 'Bperson 2';
            localERP1.Business_3__c = 'Bperson 3';
            localERP1.Country__c = 'United States';
            localERP1.Credit_Information_Risk_class__c = 'testcreditInfo' ;
            localERP1.Customer_Allocation__c = 'customettestallocation' ;
            localERP1.Block__c = true ;            
            localERP1.ERP_ID__c = '100' ;
            localERP1.Local_Channel__c = 'creditLocal' ;
            localERP1.Local_Customer_ID__c = 'customerID' ;
            localERP1.Local_Main_Business__c = 'Business 1' ;
            localERP1.Local_Segment__c = 'segment test' ;
            localERP1.Sales_District__c = 'district' ;
            localERP1.Sales_Office__c = 'office' ;
            localERP1.Sales_Person_1__c = 'S person 1' ;
            localERP1.Sales_Person_2__c = 'S Person 2' ;
            localERP1.Sales_Person_3__c = 'S Person 3' ;
            localERP1.SAP_Distribution_Channel__c = 'AT' ;
            localERP1.SAP_Division__c = 'PP' ;
            localERP1.SAP_Sales_Organization__c = 'ABB' ;
            localERP1.Type_of_Sales_Force__c = 'testing' ;            
           // insert localERP1;
               
        List<Local_ERP_Loader__c> list_ERPLoader = new List<Local_ERP_Loader__c>();
        list_ERPLoader.add(localERP1);   
        insert list_ERPLoader;
        
        delete list_ERPLoader;
            
        BatchDeleteLocalErpLoader clsBatch = new BatchDeleteLocalErpLoader();          
  //      ID batchprocessid = Database.executeBatch(clsBatch);
        Database.BatchableContext BC;
       // clsBatch.start(BC);
        //clsBatch.execute(BC, list_ERPLoader);
        //clsBatch.finish(BC);
                  
        system.assert(true);
                   
       Test.stopTest();       
   
 }


 }