public with sharing class LeadConvertCustomCon {

    public  Lead leadReference {get; set;}
     public Contact contactID {
        get {
            if (contactId == null) {
                contactID = new Contact(OwnerId = leadReference.ownerId);
            }
            return contactId;
        }
        set;
    }
     public boolean emailChecked {get; set;}
    public boolean readyToConvert {get; set;}
    public string selectedAccount {get; set;}
    public List<SelectOption> accounts {get; set;}    
    private string company;
    private final string EXISTING = 'Attach to existing: ';
     public Boolean cancelOpp {get; set;}
    public Opportunity opp {get; set;}
    public List<SelectOption> LeadStatusOption 
    {
        get 
        {
            if(LeadStatusOption == null) 
            {
                LeadStatusOption = new List<SelectOption>();
                LeadStatus [] ls = [select MasterLabel from LeadStatus where IsConverted=true order by SortOrder];
                
                for (LeadStatus convertStatus : ls)
                {
                    LeadStatusOption.add(new SelectOption(convertStatus.MasterLabel, convertStatus.MasterLabel));
                } 
            }
            return LeadStatusOption;
        }
        set;
    }
    public Task taskID {get; set;}
    private transient List<Schema.PicklistEntry> taskStatuses = Task.Status.getDescribe().getPicklistValues();
    private transient List<Schema.PicklistEntry> taskPriorities = Task.Priority.getDescribe().getPicklistValues();
    public List<SelectOption> taskStatusOption 
    {
        get {
            if(taskStatusOption == null) 
            {
                taskStatusOption = new List<SelectOption>();
                for (Schema.PicklistEntry status : taskStatuses)
                {
                    taskStatusOption.add(new SelectOption(status.getLabel(), status.getLabel()));
                } 
            }
            return taskStatusOption;
            }
        set;
    }
    public List<SelectOption> taskPriorityOption {
        get {
            if(taskPriorityOption == null) 
            {
                taskPriorityOption = new List<SelectOption>();
                for (Schema.PicklistEntry priority : taskPriorities)
                {
                    taskPriorityOption.add(new SelectOption(priority.getLabel(), priority.getLabel()));
                } 
            }
            return taskPriorityOption;
            }
        set;
    }
    
     public String reminderTime {get; set;}
    public Boolean reminder {get; set;}
    public List<SelectOption> ReminderTimeOption {
        get {
            if(ReminderTimeOption == null) {
              
                ReminderTimeOption = new List<SelectOption>();
               String timeFormat = LocaleToTimeFormatMap().get(UserInfo.getLocale());
               String timeValue;
                 if (timeFormat != null && timeFormat.endsWith('a')) {
                    ReminderAddMeridiem(ReminderTimeOption, 'AM');
                    ReminderAddMeridiem(ReminderTimeOption, 'PM');
                    reminderTime = '8:00 AM';
                } else {
                    ReminderAddHour(ReminderTimeOption, '00', '');
                    for (Integer i = 1; i <= 23; i++)
                    {
                        ReminderAddHour(ReminderTimeOption, i.format(), '');
                    }
                    reminderTime = '8:00';
                }
            }
            return ReminderTimeOption;
        }
        set;
    }
    private void ReminderAddMeridiem(List<SelectOption> reminderTimeOption, String meridiem)
    {
        ReminderAddHour(reminderTimeOption, '12', ' ' + meridiem);
        for (Integer i = 1; i <= 11; i++)
        {
            ReminderAddHour(reminderTimeOption, i.format(), ' ' + meridiem);
        }
    }
  private void ReminderAddHour(List<SelectOption> reminderTimeOption, String hour, String meridiem)
    {
        reminderTimeOption.add(ReminderOption(hour + ':00' + meridiem));
        reminderTimeOption.add(ReminderOption(hour + ':30' + meridiem));
    }
  private SelectOption ReminderOption(String value)
    {
        return new SelectOption(value, value);
    }
      public string disabledActivityDate {
        get {
            return (taskId.ActivityDate != null) ? (DateTime.newInstance(taskId.ActivityDate, Time.newInstance(0,0,0,0)).format('M/d/yyyy')).trim() : '';
        }
        set;
    }
    public LeadConvertCustomCon(ApexPages.StandardController stdController) {
        
      
        Id leadId = stdController.getId();
        leadReference = [SELECT Id, Status, OwnerId, Name, Company , Interest_need__c,Lead_Engagement__c,Ready_to_convert__c ,
                         Lead_Number__c,Lead_Score__c,Purchasing_power__c,Budget__c,Positioning__c,Fit__c,
                         Unqualifying_Reason__c,Other_Reason__c,Timeframe__c,Description__c,subject__c,division__c 
                         FROM Lead WHERE Id = :leadId];
        company = leadReference.Company;
        readyToConvert = LeadReference.Ready_to_convert__c;
        selectedAccount = 'Create New Account: ' + company;
        populateAccounts(); 
         opp = new Opportunity();
        opp.Name=company+'-';
         taskId = new Task();
        taskId.subject='Other';
        taskId.IsReminderSet = true;
        
        taskId.Status = defaultVal(taskStatuses);
        taskId.Priority = defaultVal(taskPriorities);
        taskId.ReminderDateTime = datetime.now();
        reminder=true;
    }
    private void populateAccounts() 
    {
      
        if (leadReference != null) 
        {
           
            accounts = new List<selectOption>();
             accounts.add(new SelectOption('NEW', 'Create New Account: ' + company ));
          
        }
        else system.debug('leadRef= null');
    }
   public PageReference accountLookedUp() 
    {
        system.debug('!!! Account looked up --> ' + contactId.AccountId );
        Account [] a = [SELECT Id, Name FROM Account WHERE Id = :contactId.AccountId];
        if (a.size() > 0) 
        {   
        system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!!! Account looked up --> ' + contactId.AccountId );
            accounts.add(new SelectOption(a[0].Id, EXISTING + a[0].Name));
            selectedAccount = a[0].Id;
            system.debug('accounts --> ' + accounts);
        }
        return null;
    }
      public PageReference accountChanged() 
    {
        return null;
    }
    
    public PageReference convertLead()
    {
         Database.LeadConvert leadConvert = new database.LeadConvert();
         leadConvert.setLeadId(leadReference.Id); 
        if(selectedAccount != 'NEW') {
            try{
                leadConvert.setAccountId(selectedAccount);
            }
            catch(Exception e)
            {}
        }
        leadConvert.setConvertedStatus(leadReference.Status);
        leadConvert.setSendNotificationEmail(emailChecked);
        leadConvert.setDoNotCreateOpportunity(cancelOpp );
        leadConvert.setOpportunityName(((cancelOpp )? null : opp.Name));
        leadConvert.setOwnerId(contactId.ownerID);
        
        try{
            Database.LeadConvertResult leadConvertResult = Database.convertLead(leadConvert);
                
       
                 
        
        if (leadConvertResult.success)
        {
         
            if(taskID.subject != null)
            {
              
                Task taskToCreate = new Task();
        taskToCreate.IsReminderSet = taskID.IsReminderSet;
                if (taskToCreate.IsReminderSet && taskID.ActivityDate != null) {
          
                    taskToCreate.ReminderDateTime =convertToDatetime(taskID.ActivityDate,reminderTime);
                    system.debug('taskToCreate.ReminderDateTime --> ' + taskToCreate.ReminderDateTime);
                    
                }  
        
                   
                taskToCreate.WhatId = leadConvertResult.getOpportunityId();
                
               taskToCreate.WhoId = leadConvertResult.getContactId();
                
                taskToCreate.Subject = taskID.Subject;
                
               taskToCreate.Status = taskID.Status;
                
                taskToCreate.ActivityDate = taskID.ActivityDate;
                
                taskToCreate.Priority = taskID.Priority;
                
                taskToCreate.Description = taskID.Description;
                
                if (emailChecked )
                {
                 
                    Database.DMLOptions dmlo = new Database.DMLOptions();
                    dmlo.EmailHeader.triggerUserEmail = true;
                    database.insert(taskToCreate, dmlo);
                }
                else
                {
                 insert taskToCreate;
                }
            }
            
           
            PageReference pageRef = new PageReference('/' + leadConvertResult.getAccountId());
            
            pageRef.setRedirect(true);
            
            return pageRef; 
        }
        else
        {

           
            System.Debug(leadConvertResult.errors);

            PrintErrors(leadConvertResult.errors);
        }
        }
        catch(exception e)
        {
            e.getMessage();
        }
        
        return null;
    }
    private String defaultVal(List<Schema.PicklistEntry> pickList)
    {
        String defVal = '';
        for(Schema.PicklistEntry entry : pickList)
        {
            if(entry.isDefaultValue())
            {
                defVal = entry.getLabel();
                break;
            }
        }
        return defVal;
    }
    public static Map<String, String> LocaleToTimeFormatMap() { 
        Map<String, String> locale_map = new Map<String, String>(); 
        locale_map.put('ar', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_AE', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_BH', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_JO', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_KW', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_LB', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_SA', 'dd/MM/yyyy hh:mm a');
        locale_map.put('bg_BG', 'yyyy-M-d H:mm');
        locale_map.put('ca', 'dd/MM/yyyy HH:mm');
        locale_map.put('ca_ES', 'dd/MM/yyyy HH:mm');
        locale_map.put('ca_ES_EURO', 'dd/MM/yyyy HH:mm');
        locale_map.put('cs', 'd.M.yyyy H:mm');
        locale_map.put('cs_CZ', 'd.M.yyyy H:mm');
        locale_map.put('da', 'dd-MM-yyyy HH:mm');
        locale_map.put('da_DK', 'dd-MM-yyyy HH:mm');
        locale_map.put('de', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_AT', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_AT_EURO', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_CH', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_DE', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_DE_EURO', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_LU', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_LU_EURO', 'dd.MM.yyyy HH:mm');
        locale_map.put('el_GR', 'd/M/yyyy h:mm a');
        locale_map.put('en_AU', 'd/MM/yyyy HH:mm');
        locale_map.put('en_B', 'M/d/yyyy h:mm a');
        locale_map.put('en_BM', 'M/d/yyyy h:mm a');
        locale_map.put('en_CA', 'dd/MM/yyyy h:mm a');
        locale_map.put('en_GB', 'dd/MM/yyyy HH:mm');
        locale_map.put('en_GH', 'M/d/yyyy h:mm a');
        locale_map.put('en_ID', 'M/d/yyyy h:mm a');
        locale_map.put('en_IE', 'dd/MM/yyyy HH:mm');
        locale_map.put('en_IE_EURO', 'dd/MM/yyyy HH:mm');
        locale_map.put('en_NZ', 'd/MM/yyyy HH:mm');
        locale_map.put('en_SG', 'M/d/yyyy h:mm a');
        locale_map.put('en_US', 'M/d/yyyy h:mm a');
        locale_map.put('en_ZA', 'yyyy/MM/dd hh:mm a');
        locale_map.put('es', 'd/MM/yyyy H:mm');
        locale_map.put('es_AR', 'dd/MM/yyyy HH:mm');
        locale_map.put('es_BO', 'dd-MM-yyyy hh:mm a');
        locale_map.put('es_CL', 'dd-MM-yyyy hh:mm a');
        locale_map.put('es_CO', 'd/MM/yyyy hh:mm a');
        locale_map.put('es_CR', 'dd/MM/yyyy hh:mm a');
        locale_map.put('es_EC', 'dd/MM/yyyy hh:mm a');
        locale_map.put('es_ES', 'd/MM/yyyy H:mm');
        locale_map.put('es_ES_EURO', 'd/MM/yyyy H:mm');
        locale_map.put('es_GT', 'd/MM/yyyy hh:mm a');
        locale_map.put('es_HN', 'MM-dd-yyyy hh:mm a');
        locale_map.put('es_MX', 'd/MM/yyyy hh:mm a');
        locale_map.put('es_PE', 'dd/MM/yyyy hh:mm a');
        locale_map.put('es_PR', 'MM-dd-yyyy hh:mm a');
        locale_map.put('es_PY', 'dd/MM/yyyy hh:mm a');
        locale_map.put('es_SV', 'MM-dd-yyyy hh:mm a');
        locale_map.put('es_UY', 'dd/MM/yyyy hh:mm a');
        locale_map.put('es_VE', 'dd/MM/yyyy hh:mm a');
        locale_map.put('et_EE', 'd.MM.yyyy H:mm');
        locale_map.put('fi', 'd.M.yyyy H:mm');
        locale_map.put('fi_FI', 'd.M.yyyy H:mm');
        locale_map.put('fi_FI_EURO', 'd.M.yyyy H:mm');
        locale_map.put('fr', 'dd/MM/yyyy HH:mm');
        locale_map.put('fr_BE', 'd/MM/yyyy H:mm');
        locale_map.put('fr_CA', 'yyyy-MM-dd HH:mm');
        locale_map.put('fr_CH', 'dd.MM.yyyy HH:mm');
        locale_map.put('fr_FR', 'dd/MM/yyyy HH:mm');
        locale_map.put('fr_FR_EURO', 'dd/MM/yyyy HH:mm');
        locale_map.put('fr_LU', 'dd/MM/yyyy HH:mm');
        locale_map.put('fr_MC', 'dd/MM/yyyy HH:mm');
        locale_map.put('hr_HR', 'yyyy.MM.dd HH:mm');
        locale_map.put('hu', 'yyyy.MM.dd. H:mm');
        locale_map.put('hy_AM', 'M/d/yyyy h:mm a');
        locale_map.put('is_IS', 'd.M.yyyy HH:mm');
        locale_map.put('it', 'dd/MM/yyyy H.mm');
        locale_map.put('it_CH', 'dd.MM.yyyy HH:mm');
        locale_map.put('it_IT', 'dd/MM/yyyy H.mm');
        locale_map.put('iw', 'HH:mm dd/MM/yyyy');
        locale_map.put('iw_IL', 'HH:mm dd/MM/yyyy');
        locale_map.put('ja', 'yyyy/MM/dd H:mm');
        locale_map.put('ja_JP', 'yyyy/MM/dd H:mm');
        locale_map.put('kk_KZ', 'M/d/yyyy h:mm a');
        locale_map.put('km_KH', 'M/d/yyyy h:mm a');
        locale_map.put('ko', 'yyyy. M. d a h:mm');
        locale_map.put('ko_KR', 'yyyy. M. d a h:mm');
        locale_map.put('lt_LT', 'yyyy.M.d HH.mm');
        locale_map.put('lv_LV', 'yyyy.d.M HH:mm');
        locale_map.put('ms_MY', 'dd/MM/yyyy h:mm a');
        locale_map.put('nl', 'd-M-yyyy H:mm');
        locale_map.put('nl_BE', 'd/MM/yyyy H:mm');
        locale_map.put('nl_NL', 'd-M-yyyy H:mm');
        locale_map.put('nl_SR', 'd-M-yyyy H:mm');
        locale_map.put('no', 'dd.MM.yyyy HH:mm');
        locale_map.put('no_NO', 'dd.MM.yyyy HH:mm');
        locale_map.put('pl', 'yyyy-MM-dd HH:mm');
        locale_map.put('pt', 'dd-MM-yyyy H:mm');
        locale_map.put('pt_AO', 'dd-MM-yyyy H:mm');
        locale_map.put('pt_BR', 'dd/MM/yyyy HH:mm');
        locale_map.put('pt_PT', 'dd-MM-yyyy H:mm');
        locale_map.put('ro_RO', 'dd.MM.yyyy HH:mm');
        locale_map.put('ru', 'dd.MM.yyyy H:mm');
        locale_map.put('sk_SK', 'd.M.yyyy H:mm');
        locale_map.put('sl_SI', 'd.M.y H:mm');
        locale_map.put('sv', 'yyyy-MM-dd HH:mm');
        locale_map.put('sv_SE', 'yyyy-MM-dd HH:mm');
        locale_map.put('th', 'M/d/yyyy h:mm a');
        locale_map.put('th_TH', 'd/M/yyyy, H:mm ?.');
        locale_map.put('tr', 'dd.MM.yyyy HH:mm');
        locale_map.put('ur_PK', 'M/d/yyyy h:mm a');
        locale_map.put('vi_VN', 'HH:mm dd/MM/yyyy');
        locale_map.put('zh', 'yyyy-M-d ah:mm');
        locale_map.put('zh_CN', 'yyyy-M-d ah:mm');
        locale_map.put('zh_HK', 'yyyy-M-d ah:mm');
        locale_map.put('zh_TW', 'yyyy/M/d a h:mm');
        return locale_map; 
    }
     public PageReference DueDateChanged() {
        taskId.ReminderDateTime = taskId.ActivityDate;
        return null;
    }
    public DateTime convertToDatetime(Date d, string t) {
        String timeFormat = LocaleToTimeFormatMap().get(UserInfo.getLocale());
        
        //if the local of the user uses AM/PM 
        if (timeFormat != null && timeFormat.endsWith('a')) {
          
          //split the time into 2 strings 1 time and 1 am r pm
            string [] reminderTime = t.split(' ');
            
            //split the time into hour and minute
            string hour = reminderTime[0].split(':')[0];
            string min = reminderTime[0].split(':')[1];
            
            //get the am or pm
            string AM_PM = reminderTime[1];
            
            //turn the hour into an integer
            integer hr = Integer.valueOf(hour);
            
            //if the am/pm part of the string is PM then add 12 hours
            if (AM_PM.equalsIgnoreCase('PM')) hr += 12;
            
            //return a new DateTime based on the above information
            return (
                DateTime.newInstance(
                    d, 
                    Time.newInstance(
                        hr, 
                        Integer.valueOf(min), 
                        0,
                        0
                    )
                )
            ); 
        }
        //If the user's local does not use AM/PM and uses 24 hour time
        else {
            
            //split the time by a : to get hour and minute
            string hour = t.split(':')[0];
            string min = t.split(':')[1];
            
            //turn the hour into an integer
            integer hr = Integer.valueOf(hour);
            
            //return a new DateTime based on the above information
            return (
                DateTime.newInstance(
                    d, 
                    Time.newInstance(
                        hr, 
                        Integer.valueOf(min), 
                        0,
                        0
                    )
                )
            ); 
        }
    }
    public void PrintErrors(Database.Error[] errors)
    {
        for(Database.Error error : errors)
        {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, error.message);
            ApexPages.addMessage(msg);
        }
    }
}