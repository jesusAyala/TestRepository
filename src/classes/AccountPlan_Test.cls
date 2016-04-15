/**
 * ApexClass -  Test class AccountPlan_Test
 * Release R5
 * @author  Ayiravalli Arasu (Accenture)
 * @created 2016-03-15
 * @version 1.0
 * Description: Test class for 
 * Created
 * This is the Test calss for 1.ClsTriggerAccountPlan
                              2.ClsTriggerAccountPlanContactRole
                              3.ClsTriggerAccountPlanTeam
                              4.ClsTriggerAction
                                
  */
@isTest
private class AccountPlan_Test{
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
    public static User createTestUser2() {
        User sau = new User();
        sau.FirstName ='helan';
        sau.LastName = 'song';
        sau.Username = 'testHelanABB1237@test123ABB1237.com';
        sau.Alias = 'hSong';
        sau.Email = 'hSong123@company.com';
        sau.CommunityNickname = sau.Alias;
        sau.ProfileId = [Select Id from Profile Where Name = 'ABB Sales Standard Profile' limit 1].Id;
        sau.TimeZoneSidKey = 'America/Chicago';
        sau.LocaleSidKey = 'en_US';
        sau.EmailEncodingKey = 'UTF-8';
        sau.LanguageLocaleKey = 'en_US';
        sau.ManagerId = UserInfo.getUserId();
        return sau;
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
    
     public static Account_Plan__c createAccPlan() {
        Account_Plan__c ap = new Account_Plan__c();
        ap.Name= 'TestAccPlan1';
        ap.Status__c='Planning';
        ap.Account_Plan_Year__c = '1992';
        return ap;
    }
    
     public static Account_Plan__c createAccPlan2() {
        Account_Plan__c ap2 = new Account_Plan__c();
        ap2.Name= 'TestAccPlan2';
        ap2.Status__c='Planning';
        ap2.Account_Plan_Year__c = '1995';
        return ap2;
    }
    
    public static Account_Plan__c createAccPlan3() {
        Account_Plan__c ap3 = new Account_Plan__c();
        ap3.Name= 'TestAccPlan3';
        ap3.Status__c='Planning';
        ap3.Account_Plan_Year__c = '1998';
        return ap3;
    }
    
    public static Account_Plan_Information__c createAccPlanInfo(){
        Account_Plan_Information__c api= new Account_Plan_Information__c();
        return api;
    }
    
    public static AccountTeamMember createAccTeam1(){
         AccountTeamMember atm=new AccountTeamMember();
         atm.TeamMemberRole= 'Sales Support';
         return atm;
    } 
    
    public static AccountTeamMember createAccTeam2(){
         AccountTeamMember atm1=new AccountTeamMember();
         atm1.TeamMemberRole= 'Service Support';
         return atm1;
    } 
    
    public static Contact createTestContacts() {
        Contact contact = new Contact();
        contact.LastName = 'Test';
        contact.MailingStreet = 'dada';
        contact.MailingCity = 'berlin';
        contact.MailingState = 'Berlin';
        contact.MailingPostalCode = '1792';
        contact.MailingCountry = 'Germany';
        contact.ABB_Perspective_Role__c='Finance'; 
        return contact;
    }
    
    public static Contact createTestContact2() {
        Contact contact2 = new Contact();
        contact2.LastName = 'Test';
        contact2.MailingStreet = 'dada';
        contact2.MailingCity = 'berlin';
        contact2.MailingState = 'Berlin';
        contact2.MailingPostalCode = '1792';
        contact2.MailingCountry = 'Germany';
        contact2.ABB_Perspective_Role__c='Finance'; 
        return contact2;
    }
    
    public static Contact_Roles__c createContRole(){
        Contact_Roles__c cr = new Contact_Roles__c();
        cr.Role__c='Business';
        return cr;
    }
    
    public static Contact_Roles__c createContRole2(){
        Contact_Roles__c cr2 = new Contact_Roles__c();
        cr2.Role__c='Business';
        return cr2;
    }
    
     public static Account_Plan_Team__c createAccPlanTeam1(){
        Account_Plan_Team__c apT1 = new Account_Plan_Team__c();
        apT1.Access__c= 'Read/Write';
        apT1.Team_Role__c='GAM/SAM Account Manager';
        return apT1;
    }
    
    public static Account_Plan_Team__c createAccPlanTeam2(){
        Account_Plan_Team__c apT2 = new Account_Plan_Team__c();
        apT2.Access__c= 'Read/Write';
        apT2.Team_Role__c='Account Manager';
        return apT2;
    }
    
    public static Actions__c createAction(){
        Actions__c act = new Actions__c();
        act.Name = 'test action';
        act.Year__c = '1991';
        return act;
    }
    
      
     static testMethod void AccountPlanMethod1(){
        Test.StartTest();
        
        User u1 = createTestUser1();
            insert u1;        
            
        Account a = createAccount1();
            insert a; 
            
        AccountTeamMember atm1 = createAccTeam1();
            atm1.UserId = u1.Id;
            atm1.AccountId = a.Id;
            insert atm1; 
       
        Id MP= Schema.SObjectType.Account_Plan__c.getRecordTypeInfosByName().get('Master Account Plan').getRecordTypeId();
        Id SP= Schema.SObjectType.Account_Plan__c.getRecordTypeInfosByName().get('Sub Account Plan').getRecordTypeId();
        Id FB= Schema.SObjectType.Account_Plan__c.getRecordTypeInfosByName().get('Master Account Plan-Freeze Budget').getRecordTypeId();
        
        Account_Plan__c ap1 = createAccPlan();
            ap1.Account__c=a.id;
            ap1.RecordTypeId = MP;
            insert ap1;
            
         Account_Plan__c ap2 = createAccPlan2();
            ap2.Account__c=a.id;
            ap2.RecordTypeId = MP;
            insert ap2;
            delete ap2;
            
         Account_Plan__c ap3 = createAccPlan3(); 
           ap3.Account__c=a.id;
            ap3.RecordTypeId = MP;
            insert ap3; 
            ap3.Freeze_Account_Plan_Budgets__c = True;
            update ap3; 
            ap3.Freeze_Account_Plan_Budgets__c = False;
            ap3.RecordTypeId = SP;
            update ap3;
             
            
         Account_Plan_Information__c api1= createAccPlanInfo();
            insert api1; 
          ClsTriggerAccountPlan apInfo = new  ClsTriggerAccountPlan();
         // Accountplan Contact Role   
         Contact con =  createTestContacts();  
            con.AccountId = a.Id;
             insert con;
         Contact con2 = createTestContact2();
             con2.AccountId = a.Id;
             insert con2;
         
         Contact_Roles__c  cr1 = createContRole ();
             cr1.Account_Plan__c = ap1.Id;
             cr1.Contact__c= con.Id;
             cr1.ABB_Perspective_Role__c = con.ABB_Perspective_Role__c;
             insert cr1;
             
         Contact_Roles__c  cr2 = createContRole2();
             cr2.Account_Plan__c = ap1.Id;
             cr2.Contact__c= con2.Id;
             insert cr2; 
             delete cr2;
          ClsTriggerAccountPlanContactRole cRole = new ClsTriggerAccountPlanContactRole();  
             
         Test.StopTest(); 
       }
             
       static testMethod void AccountPlanMethod2(){
        Test.StartTest();  
        
        User u1 = createTestUser1();
            insert u1;        
        User u2 = createTestUser2();
            insert u2;
        Account a = createAccount1();
            insert a; 
        
        Id MP= Schema.SObjectType.Account_Plan__c.getRecordTypeInfosByName().get('Master Account Plan').getRecordTypeId();
         
         Account_Plan__c ap1 = createAccPlan();
            ap1.Account__c=a.id;
            ap1.RecordTypeId = MP;
            insert ap1;
         Account_Plan__c ap2 = createAccPlan2();
            ap2.Account__c=a.id;
            ap2.RecordTypeId = MP;
            insert ap2;
                
         // Code for Apex Class - AddAccountPlanTeam
         Account_Plan_Team__c apTeam = new Account_Plan_Team__c ();
              ApexPages.StandardController sc = new ApexPages.StandardController(apTeam);
              AddAccountPlanTeam apt = new AddAccountPlanTeam(sc);
                apt.accountPlanTeam1.User__c = u1.id;
                apt.accountPlanTeam2.User__c = u1.id;
                apt.accountPlanTeam3.User__c = u1.id;
                apt.accountPlanTeam4.User__c = u1.id;
                apt.accountPlanTeam5.User__c = u1.id;
                apt.saveRecord();
                apt.saveMoreRecord();
                apt.cancel();  
                apt.GoBack();                 
              
         // Code for Apex Class - ClsTriggerAccountPlanTeam
          Account_Plan_Team__c  actPlanTeam1 = createAccPlanTeam1();
            actPlanTeam1.Account_Plan__c = ap1.Id;
            actPlanTeam1.User__c = u1.id;
            insert actPlanTeam1 ;
            
         Account_Plan_Team__c  actPlanTeam2 = createAccPlanTeam2();
            actPlanTeam2.Account_Plan__c =ap2.Id;
            actPlanTeam2.User__c = u2.id;
            insert actPlanTeam2;
            delete actPlanTeam2;
            
         ClsTriggerAccountPlanTeam accplanTeam = new ClsTriggerAccountPlanTeam(); 
         
         Test.StopTest(); 
     }
     
      static testMethod void AccountPlanMethod3(){
         Test.StartTest();
           
        User u1 = createTestUser1();
            insert u1;        
        User u2 = createTestUser2();
            insert u2;
            u2.isActive = TRUE;
            update u2;
            
        Account a = createAccount1();
            insert a; 
            
             
        AccountTeamMember aTM = new AccountTeamMember(
            UserId = u1.id,
            TeamMemberRole = 'Manager', 
            AccountId = a.id);
            insert aTM;       
        AccountTeamMember aTM1 = new AccountTeamMember(
            UserId = u2.id,
            TeamMemberRole = 'Manager', 
            AccountId = a.id);
            insert aTM1;  
        AccountTeamMember aTM2 = new AccountTeamMember(
            UserId = u2.id,
            TeamMemberRole = 'Manager', 
            AccountId = a.id);
            insert aTM2;  
           
        Account_Plan__c ap1 = createAccPlan();
            ap1.Account__c=a.id;           
            insert ap1;
       Account_Plan_Team__c  actPlanTeam1 = createAccPlanTeam1();
            actPlanTeam1.Account_Plan__c = ap1.Id;
            actPlanTeam1.User__c = u1.id;
            insert actPlanTeam1 ;            
       Account_Plan_Team__c  actPlanTeam2 = createAccPlanTeam2();
            actPlanTeam2.Account_Plan__c =ap1.Id;
            actPlanTeam2.User__c = u2.id;
            insert actPlanTeam2;
            delete actPlanTeam2;           
          
            
         // Code coverage for Apex Class - ClsCreateAccTeamMember            
        apexpages.currentpage().getparameters().put('Id', ap1.Id);
        ApexPages.StandardController stdCtrller = new ApexPages.StandardController(ap1);  
        ClsCreateAccTeamMember accPlanTeamCopy  =  new ClsCreateAccTeamMember();                  
        accPlanTeamCopy  =  new ClsCreateAccTeamMember(stdCtrller);    
        accPlanTeamCopy.copyAccountTeamMember();   
        accPlanTeamCopy.GoBack();
        ApexPages.currentPage().getParameters().put('/',ap1.id);    
            
         Test.StopTest(); 
     }
//method for ClsTriggerAction
       static testMethod void AccountPlanMethod4(){
         Test.StartTest();
         User u1 = createTestUser1();
            insert u1; 
         Account a = createAccount1();
            insert a; 
         Account_Plan__c ap1 = createAccPlan();
            ap1.Account__c=a.id;           
            insert ap1;
         Account_Plan_Team__c  actPlanTeam1 = createAccPlanTeam1();
            actPlanTeam1.Account_Plan__c = ap1.Id;
            actPlanTeam1.User__c = u1.id;
            insert actPlanTeam1;
         Id ASA = Schema.SObjectType.Actions__c.getRecordTypeInfosByName().get('1. Account SWOT Analysis').getRecordTypeId();
         Actions__c act1= createAction();
             act1.Account_Plan__c= ap1.Id;
             act1.RecordTypeId = ASA;
             insert act1;
         ap1.Status__c='Closed';
system.runAs(u1){           
            try{ 
                update ap1;
                delete act1;
            }catch(exception e){}
 }           
         Test.StopTest(); 
     }
     
           
}