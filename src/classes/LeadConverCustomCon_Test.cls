@isTest
private class LeadConverCustomCon_Test {

    static testMethod void myUnitTest() {
           Profile p = [select id from profile where name='Standard User'];

         User u = new User(alias = 'standt', email='standarduser@testorg.com',

            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',

            localesidkey='en_US', profileid = p.Id,

            timezonesidkey='America/Los_Angeles', 
            username='testUser@testleadconvert.com');
        
        DateTime d=system.now();
        Lead newLead = new Lead(
                        Company = 'Test Account', LastName= 'Test Lead',email='ishita4@abc.com',
                        LeadSource = 'Web',  
                        Status = 'Contacted',Interest_need__c='int',Lead_Engagement__c='High',
                         Purchasing_power__c='yes',Budget__c='yes',Positioning__c='yes',Fit__c='yes',
                         Timeframe__c=d.date(),Description__c='desc',subject__c='sub',division__c='PP');
     
        newLead.street='Teststr. 1';
          newLead.state='Tibet';
          newLead.country='China';
          newLead.city='Musterstadt';
      
        Insert newLead;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(newLead);
        LeadConvertCustomCon leadController = new LeadConvertCustomCon(stdController);
        
        leadcontroller.leadReference = newLead;
        
       leadcontroller.leadReference.status='Qualified';
      leadController.taskID.Subject = 'TEST TASK';
          leadController.taskID.ActivityDate = system.today();
          leadController.taskID.isReminderSet=true;
         leadController.taskID.Subject = 'Other';
        leadController.taskID.Priority = 'High';
        leadController.taskID.Status = 'In Progress';
      leadController.selectedAccount = 'NEW';
      

        Contact contactID = leadController.contactID;
        leadController.cancelOpp = true;
        List<SelectOption> leadStatuses = leadController.LeadStatusOption;
        
        Opportunity opportunityID = leadController.opp;
        leadController.reminder = true;
        String reminderTime = leadController.reminderTime;
        List<SelectOption> timeOptions = leadController.ReminderTimeOption;
        leadController.emailChecked = true;
       List<SelectOption> priorityOptions = leadController.TaskPriorityOption;
        List<SelectOption> statusOptions = leadController.TaskStatusOption;
        System.runAs(u) {
           List<SelectOption> timeOptions2= leadController.ReminderTimeOption;
            LeadController.convertToDatetime(d.date(),'8:00 a');
         }
        leadController.convertLead();   
        leadController.PrintErrors(new List<Database.Error>());
       Account [] checkAccount = [SELECT Id FROM Account WHERE Name ='Test Account' ];
        system.debug(checkAccount);
        system.assertEquals(1, checkAccount.size(), 'There was a problem converting lead to an account');
       Contact [] checkContact = [SELECT Id FROM Contact WHERE Name ='Test Lead' ];
        system.debug(checkContact);
        system.assertEquals(1, checkContact.size(), 'There was a problem converting lead to a contact');
        
       string reminderDate = leadController.disabledActivityDate;
     
       
        // test the reminder time as a French user to test the 24 hour clock
       
        
         System.runAs(u) {
            timeOptions = leadController.ReminderTimeOption;
             LeadController.convertToDatetime(d.date(),'8:00 a');
         }
         
         leadController.selectedAccount = 'None';
         leadController.emailChecked= false;
         
         //test the situation where there is a due date but no subject
         leadController.taskID.ActivityDate = system.today();
          leadController.taskID.isReminderSet=true;
         leadController.taskID.Subject = 'Other';
         leadController.leadReference.Status = 'Qualified';
         
         //convert the lead
        System.assertequals( leadController.convertLead(),null);
         
         leadController.accountLookedUp();
         leadController.DueDateChanged();
         leadController.accountChanged();
     
    } 


}