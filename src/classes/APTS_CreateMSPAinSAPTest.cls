@isTest
Private class APTS_CreateMSPAinSAPTest {
    public static Apttus__APTS_Agreement__c agreement ;    
    Private Static list<Apttus__APTS_Agreement__c> ListOfAgreements ;
    
    @testsetup
    static void CreateTestData(){
          System.runAs(APTS_LP_TestUtility.getUser()) {
        Account acc = new Account();
        acc = APTS_LP_TestUtility.getNewAccount('Test Account', 'Spain');
        insert acc;

        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c(Apttus_Config2__AccountId__c = acc.id,Name='Test - Price List');
        priceList.APTS_Country__c = 'Spain';
        insert priceList;
        
        agreement = new Apttus__APTS_Agreement__c();
        agreement.Name = 'Test Agreement';
        agreement.APTS_Country__c = 'Spain';
        agreement.APTS_LP_MSPA_title__c = 'Test Title';
        agreement.APTS_LP_Sales_Organization__c = 'ABB';
        agreement.Apttus__Status__c = 'Draft';
        agreement.Apttus_CMConfig__PriceListId__c = priceList.Id;
        insert agreement;
          }
    }
    
    /*
    @isTest static void Test_CreateMSPAinSAP()
    {     
        //system.debug('KS--> Agreement Status' + database.query('SELECT id,Apttus__Status__c FROM Apttus__APTS_Agreement__c where id= \'' +objagreement.Id+'\''));
        CreateTestData();
        Apttus__APTS_Agreement__c objagreement = new Apttus__APTS_Agreement__c();
        test.startTest();              
        APTS_SAPConnectorForMSPACreationTest.SAPConnectorForMSPACreation();
        string status='Approved but Action Required';
        string query ='SELECT Id FROM Apttus__APTS_Agreement__c WHERE Apttus__Status__c=\'' +status+'\'';
        system.debug('KS--> Query' + database.query(query));
        //APTS_CreateMSPAinSAPBatch CreateMSPABatchObj = new APTS_CreateMSPAinSAPBatch();       
        CreateMSPABatchObj.query = query;
        //agreement = database.query('SElect id FROM Apttus__APTS_Agreement__c where id= \'' + agreement.Id +'\'');
        //agreement.Apttus__Status__c = 'Approved but Action Required';
        //update agreement;
        ID batchprocessid = Database.executeBatch(CreateMSPABatchObj,2);        
        String CRON_EXP = '0 26 * * * ?';
        APTS_ScheduledMSPACreation sch = new APTS_ScheduledMSPACreation();
        system.schedule('Create MSPA In SAP Hourly Test Run', CRON_EXP, sch);
        test.stopTest();
    }*/
    
}