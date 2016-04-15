/*
*  This test class used to test class addNewCQPCompetitor.
*
@author Aswini Arasu
@created 2015-12-23
@version 1.0  
*/
@istest(SeeAllData = False)
public class addNewCQPCompetitorTest{
    
    public static final String QUOTE_RECORD_TYPE = 'LP';
    
   static testMethod void  methodTest(){ 
   
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
    //o.RecordtypeId = rg.id;
    o.Account_End_User__c =a.id;
    //o.End_User_Project__c = eu.id;
    o.Name = 'ES-Acciona, S.A-Test';
    o.StageName = 'Prospecting';
    o.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    o.Specific_Opportunity_Info__c ='Test';
    o.Confidence_Level__c ='No Delay Expected';    
    o.CloseDate = date.today();    
    o.Industry_Usage__c = 'BLD.10.1';
    o.Channel_Class__c = 'Direct Sales to End Customer / End User';
    o.Channel_Class_Level1__c= 'DEU';
    o.Customer_Buying_Path__c = 'Awareness';
    o.Opportunity_Winner__c = a.id;
    //o.Capture_Team__c = cap.id; 
    insert o;
    
    APTS_Common_Config_Settings__c ap=new APTS_Common_Config_Settings__c();
    ap.Name='Global_Record_Type';
    ap.APTS_Value__c='Test';
    ap.APTS_Description__c='testdescr';
    
    APTS_Common_Config_Settings__c ap1=new APTS_Common_Config_Settings__c();
    ap1.Name='LP_USER_DIVISION';
    ap1.APTS_Value__c='Test';
    ap1.APTS_Description__c='testdescr';
   
    APTS_Common_Config_Settings__c ap2=new APTS_Common_Config_Settings__c();
    ap2.Name='DEFAULT_SAP_DIVISION';
    ap2.APTS_Value__c='Test';
    ap2.APTS_Description__c='testdescr';
    
    APTS_Common_Config_Settings__c ap3=new APTS_Common_Config_Settings__c();
    ap3.Name='SPAIN_LOCALE';
    ap3.APTS_Value__c='Test';
    ap3.APTS_Description__c='testdescr';
    
    APTS_Common_Config_Settings__c ap4=new APTS_Common_Config_Settings__c();
    ap4.Name='DIVISION';
    ap4.APTS_Value__c='Test';
    ap4.APTS_Description__c='testdescr';
    
    APTS_Common_Config_Settings__c ap5=new APTS_Common_Config_Settings__c();
    ap5.Name='APPROVAL_COUNTRY';
    ap5.APTS_Value__c='Test';
    ap5.APTS_Description__c='testdescr';
    
    List<APTS_Common_Config_Settings__c> aptsc = new List<APTS_Common_Config_Settings__c>();
    aptsc.add(ap);
    aptsc.add(ap1);
    aptsc.add(ap2);
    aptsc.add(ap3);
    aptsc.add(ap4);
    aptsc.add(ap5); 
    insert aptsc;
     
    Apttus_Proposal__Proposal__c app = new Apttus_Proposal__Proposal__c();
    app.Apttus_Proposal__Proposal_Name__c = 'test';
    //app.APTS_Quotation_Account_Type__c = APTS_Constants.ACCOUNTTYPE_ACCEND;
    app.APTS_Account_End_User__c = a.Id;
    app.Apttus_Proposal__Opportunity__c = o.id;
    app.APTS_Product_Configuration__c=true;
    app.APTS_SAP_Reference_No__c='Test';
    app.RecordTypeID = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(QUOTE_RECORD_TYPE).getRecordTypeId();
    insert app;
    /*Apttus_Proposal__Proposal__c app = APTS_LP_TestUtility.getProposal('TestProposal');
    insert app;*/
    
    /*Competitor__c c = new Competitor__c();
    c.Opportunity__c = o.id ;
    c.Competitor__c = a.id;
    insert c ;*/
    
    Competitor_CQP__c cqp = new Competitor_CQP__c();
    cqp.Account__c = a.id;
    //cqp.Competitor_Code__c = 
    cqp.Quote_Proposal__c = app.id;
    //insert cqp;
    
    /*Competitor_CQP__c cqp1 = new Competitor_CQP__c();
    cqp1.Account__c = a.id;
    //cqp1.Competitor_Code__c = ;
    cqp1.Quote_Proposal__c = app.id; */
    
     List<Competitor_CQP__c> lstcomp = new List<Competitor_CQP__c>();
     lstcomp.add(cqp);
     //lstcomp.add(cqp1);
     insert  lstcomp ;
     Test.startTest();
     PageReference pageRef = Page.Add_New_CQP_Competitor; 
     pageRef.getParameters().put('id', String.valueOf(app.Id));
     Test.setCurrentPage(pageRef);
     
    ApexPages.StandardSetController stdcomp = new ApexPages.StandardSetController(lstcomp );
    stdcomp.setSelected(lstcomp);
    ApexPages.currentPage().getParameters().put('Id',+app.Id);
    addNewCQPCompetitor objController = new addNewCQPCompetitor(stdcomp);    
    objController.getCompetitorList();
    
    addNewCQPCompetitor.CompetitorWrapper obj = new  addNewCQPCompetitor.CompetitorWrapper ();
    
    List<addNewCQPCompetitor.CompetitorWrapper > competitor = objController.getCompetitorList();
    for(addNewCQPCompetitor.CompetitorWrapper w : competitor)
    {
       w.selected = true;
    }
    
    objController.addSelectedCompetitors();
    objController.back();
    objController.selectedComptId=a.Id;
    pagereference pr=objController.addCompetitor();
    Boolean b=objController.dupAcc;
    objController.dupAcc=true;
    Test.stopTest();
    }
    
    static testMethod void  methodTest1(){
    
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
    //o.RecordtypeId = rg.id;
    o.Account_End_User__c =a.id;
    //o.End_User_Project__c = eu.id;
    o.Name = 'ES-Acciona, S.A-Test';
    o.StageName = 'Prospecting';
    o.Sales_Pursuit_Progress__c = 'Opportunity Is Captured';
    o.Specific_Opportunity_Info__c ='Test';
    o.Confidence_Level__c ='No Delay Expected';    
    o.CloseDate = date.today();    
    o.Industry_Usage__c = 'BLD.10.1';
    o.Channel_Class__c = 'Direct Sales to End Customer / End User';
    o.Customer_Buying_Path__c = 'Awareness';
    o.Opportunity_Winner__c = a.id;
    o.Channel_Class_Level1__c= 'DEU';
    //o.Capture_Team__c = cap.id; 
    insert o;
   
    APTS_Common_Config_Settings__c ap=new APTS_Common_Config_Settings__c();
    ap.Name='Global_Record_Type';
    ap.APTS_Value__c='Test';
    ap.APTS_Description__c='testdescr';
   
    APTS_Common_Config_Settings__c ap1=new APTS_Common_Config_Settings__c();
    ap1.Name='LP_USER_DIVISION';
    ap1.APTS_Value__c='Test';
    ap1.APTS_Description__c='testdescr';
    
    APTS_Common_Config_Settings__c ap2=new APTS_Common_Config_Settings__c();
    ap2.Name='DEFAULT_SAP_DIVISION';
    ap2.APTS_Value__c='Test';
    ap2.APTS_Description__c='testdescr';
    
    APTS_Common_Config_Settings__c ap3=new APTS_Common_Config_Settings__c();
    ap3.Name='SPAIN_LOCALE';
    ap3.APTS_Value__c='Test';
    ap3.APTS_Description__c='testdescr';
    
    APTS_Common_Config_Settings__c ap4=new APTS_Common_Config_Settings__c();
    ap4.Name='DIVISION';
    ap4.APTS_Value__c='Test';
    ap4.APTS_Description__c='testdescr';
    
    APTS_Common_Config_Settings__c ap5=new APTS_Common_Config_Settings__c();
    ap5.Name='APPROVAL_COUNTRY';
    ap5.APTS_Value__c='Test';
    ap5.APTS_Description__c='testdescr';
    
    List<APTS_Common_Config_Settings__c> aptsc = new List<APTS_Common_Config_Settings__c>();
    aptsc.add(ap);
    aptsc.add(ap1);
    aptsc.add(ap2);
    aptsc.add(ap3);
    aptsc.add(ap4);
    aptsc.add(ap5); 
    insert aptsc;
   
    Apttus_Proposal__Proposal__c app = new Apttus_Proposal__Proposal__c();
    app.Apttus_Proposal__Proposal_Name__c = 'test';
    //app.APTS_Quotation_Account_Type__c = APTS_Constants.ACCOUNTTYPE_ACCEND;
    app.APTS_Account_End_User__c = a.Id;
    app.Apttus_Proposal__Opportunity__c = o.id;
    app.APTS_Product_Configuration__c=true;
    app.APTS_SAP_Reference_No__c='Test';
    app.RecordTypeID = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(QUOTE_RECORD_TYPE).getRecordTypeId();
    insert app;
    /*Apttus_Proposal__Proposal__c app = APTS_LP_TestUtility.getProposal('TestProposal');
    insert app;*/
    
    Competitor__c c = new Competitor__c();
    c.Opportunity__c = o.id ;
    c.Competitor__c = a.id;
    //insert c;
  
    /*Competitor__c c1 = new Competitor__c();
    c1.Opportunity__c = o.id ;
    c1.Competitor__c = a.id;*/
    
    List<Competitor__c> lstcomp1 = new List<Competitor__c>();
    lstcomp1.add(c);
   // lstcomp1.add(c1);
    insert  lstcomp1 ;
    
    Test.StartTest();
    PageReference pageRef = Page.Add_New_CQP_Competitor; 
    pageRef.getParameters().put('id', String.valueOf(app.Id));
    Test.setCurrentPage(pageRef);
     
    ApexPages.StandardSetController stdcomp = new ApexPages.StandardSetController(lstcomp1);
    stdcomp.setSelected(lstcomp1);
    ApexPages.currentPage().getParameters().put('Id',+app.Id);
    addNewCQPCompetitor objController = new addNewCQPCompetitor(stdcomp);    
    objController.getCompetitorList();
    
    addNewCQPCompetitor.CompetitorWrapper obj = new  addNewCQPCompetitor.CompetitorWrapper ();
    
    List<addNewCQPCompetitor.CompetitorWrapper > competitor = objController.getCompetitorList();
    for(addNewCQPCompetitor.CompetitorWrapper w : competitor)
    {
       w.selected = true;
    }
    
    objController.addSelectedCompetitors();
    objController.back();
    objController.selectedComptId=a.Id;
    pagereference pr=objController.addCompetitor();
    Boolean b=objController.dupAcc;
    objController.dupAcc=true;
    Test.stopTest();
    }
   }