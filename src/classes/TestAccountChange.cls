@isTest
private class TestAccountChange 
{    

  @testSetup static void setup()
  {    
     ApexPages.StandardSetController conAcc; 
     Account a = new Account(Name='testcheck', BillingCity='port', BillingCountry='Australia', BillingPostalCode='123456',BillingStreet='post34');
     insert a; 
     string accountQuery='select BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet,Name,Phone,GUID__c,Active__c from Account '; 
     Contact c = new Contact(FirstName='Test', Lastname='Acc', Email='BC@dg.com',Preferred_Language__c='English',MailingState='Victoria',MailingPostalCode='175018',
     Type__c='Internal',AccountID=a.ID,MailingCity='hsjs',MailingCountry='Australia', MailingStreet='dfg',Active__c=true); 
     insert c;
     
     
  }
  static testmethod void hasWhereClauseFalse() 
  {  
     Account acc=[select ID,Name from Account where Name='testcheck'];
     system.assertEquals(true,acc.id!=null);
     Contact con=[select ID,Name from Contact where FirstName='Test'];
     system.assertEquals(true,con.id!=null);
     String idVariable=con.Id;
     string idVariable1=acc.Id; 
     Test.startTest();
     PageReference myVfPage = Page.AccountChangeFlow;
     Test.setCurrentPage(myVfPage); // use setCurrentPageReference, 
     ApexPages.currentPage().getParameters().put('acid',idVariable1);
     String id1 = ApexPages.currentPage().getParameters().get('acid');
     ApexPages.currentPage().getParameters().put('varContactID',idVariable);
     String id = ApexPages.currentPage().getParameters().get('varContactID');
     system.assertEquals(true,id!=null);
     ApexPages.StandardController sc = new ApexPages.StandardController(con);    
     AccountChangeFlowController ac= new AccountChangeFlowController(sc);
     ac.inputText1='test1';
     ac.inputText2='test2';
     ac.inputText3='test3';
     ac.inputText4='test4';
     ac.inputText5='test5';
     ac.SuccessEmail='test@y.com';
     ac.MailingCity='hsjs';
     ac.MailingCountry='Australia';
     ac.MailingStreet='dfg';
     ac.MailingState='Melbourne';
     ac.MailingPostalCode='175018';
     ac.FirstName='Rahul';
     ac.LastName='oby';
     ac.hasNext=true;
     ac.hasPrevious=false;
     ac.pageNumberAcc=12;
     ac.Email='abc@xyz.com';
     ac.getAcc(acc.ID);
     ac.getSelected();
     List<Account> account=ac.querySelectAccount();
     ac.createContact();
     ac.step1();
     ac.step2();
     ac.step3();
     ac.step4();
     ac.step5();
     ac.step6();
     Boolean ab=ac.HasNext;
     Boolean ad=ac.HasPrevious;
     Integer ae=ac.pageNumberAcc;
     ac.BindData(1);
     ac.first();
     ac.last();
     ac.previous();
     ac.next();
     boolean checkemail=AccountChangeFlowController.validateEmail('abc@xyz.com');
     system.assertEquals(true,checkemail);
     
     Test.stopTest();
   }
   static testmethod void hasWhereClauseTrue() 
   {
     
     Account acc1=[select ID,Name from Account where Name='testcheck'];
     Contact con1=[select ID,Name from Contact where FirstName='Test'];
     String idVariable=con1.Id;
     string idVariable1=acc1.Id; 
     Test.startTest();
     PageReference myVfPage = Page.AccountChangeFlow;
     Test.setCurrentPage(myVfPage); // use setCurrentPageReference, 
     ApexPages.currentPage().getParameters().put('acid',idVariable1);
     String id1 = ApexPages.currentPage().getParameters().get('acid');
     ApexPages.currentPage().getParameters().put('varContactID',idVariable);
     String id = ApexPages.currentPage().getParameters().get('varContactID');
     system.assertEquals(true,id!=null);
     ApexPages.StandardController sc1 = new ApexPages.StandardController(con1);    
     AccountChangeFlowController ac1= new AccountChangeFlowController(sc1);
     ac1.getSelected();
     ac1.querySelectAccount();
     ac1.createContact();
     ac1.step1();
     ac1.step2();
     ac1.step3();
     ac1.Email='abc#xyz.com';
     ac1.step4();
     ac1.step5();
     ac1.step6();
     boolean checkemail=AccountChangeFlowController.validateEmail('abc#xyz.com');
     system.assertEquals(false,checkemail);
     test.stopTest(); 
   }
}