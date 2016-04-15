trigger Lead on Lead (after delete, after insert, after undelete, after update, 
                      before delete, before insert, before update){
  If(!System.label.SYS_RunLeadTrigger.equalsIgnoreCase('NO')){
   
   
   /*-- 
       Modified  : Abiramasundari Radha(Accenture)
       Date : 25/03/2016
       Replaced the Hardcoded value(Lead record type name - Contact Centre) with the custom Label - Sys_Lead_RecordType_Contact_Center     
   */
   
    Id ContactCenterID = Schema.Sobjecttype.Lead.getRecordTypeInfosByName().get(System.label.Sys_Lead_RecordType_Contact_Center).getRecordTypeId();
    if(trigger.isBefore){
        if(trigger.isInsert){
            ClsUtil cu = new ClsUtil();
            set<String> set_LeadNumber = new set<String>();
            set<String> set_ExitLeadNumber = new set<String>();
            List<String> list_addLeadNumber =  new List<String>(); //added by Jinbo Shan 2015-04-16 for duplicate lead Number when loading data.
            
            for(Lead l : [select Id, Lead_Number__c from Lead where CreatedDate = today]){
                set_ExitLeadNumber.add(l.Lead_Number__c);
            }
            system.debug('@set_LeadNumber.size()--'+set_LeadNumber.size());
            while(list_addLeadNumber.size() < trigger.new.size()){
                String lin = cu.formatInquiryNumber();
                if(set_ExitLeadNumber.contains(lin)){
                    continue;
                }else{
                    set_LeadNumber.add(lin);
                    list_addLeadNumber.add(lin);//added by Jinbo Shan 2015-04-16 for duplicate lead Number when loading data.
                }
            }
            system.debug('@list_addLeadNumber--'+list_addLeadNumber);
            integer i = 0;//added by Jinbo Shan 2015-04-16 for duplicate lead Number when loading data.
            for(Lead l : trigger.new){
                if(l.Lead_Number__c == '' || l.Lead_Number__c == null) {
                    //for(String s : set_addLeadNumber){
                        //l.Lead_Number__c = s;
                    //}
                    /*Start: added by Jinbo Shan 2015-04-16 for duplicate lead Number when loading data.*/
                    l.Lead_Number__c = list_addLeadNumber.get(i);
                    i++;
                    /*End*/
                }
            }
            for(Lead ld:trigger.new)
            {
                if(Ld.Leadsource=='Web'||Ld.RecordTypeId==ContactCenterID)
                {
                    if(Ld.Email_unclean__c!=null && Ld.Email_unclean__c!='')
                    {
                        if(Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}', Ld.Email_unclean__c)||Ld.RecordTypeId==ContactCenterID)
                        {
                           Ld.email=Ld.Email_unclean__c;
                            
                        }
                    }
                    if(Ld.Phone_captured__c!=null && Ld.Phone_captured__c!='')
                    {
                        Pattern isnumbers = Pattern.Compile('^[0-9]+$');
                        Matcher phoneMatch = isnumbers.matcher(Ld.Phone_captured__c);
                             
                        if(phoneMatch.Matches()||Ld.RecordTypeId==ContactCenterID )
                           {
                               Ld.Phone=Ld.Phone_captured__c;
                           }
                    }
                }
            }
        }
        
    }
    if(trigger.isAfter){
        if(trigger.isUpdate){
              
            Lead_triggerFunctions.generatePDF(trigger.new, trigger.old);
          
        }
        // start add --to assignment the value to lst_Sobject and lnew
        if(trigger.isUpdate && trigger.new.size() <= 1){
            
            for(Lead l : trigger.old){
                if(GlobalMergeClass.set_sIds == null) {
                    GlobalMergeClass.set_sIds = new set<Id>();
                }
                if(!GlobalMergeClass.set_sIds.contains(l.Id)) {
                    if(GlobalMergeClass.lst_Sobject == null) {
                        GlobalMergeClass.lst_Sobject = new List<Lead>();
                    }
                    GlobalMergeClass.lst_Sobject.add(l);
                    GlobalMergeClass.set_sIds.add(l.Id);
                }
                
            }
            for(Lead l : trigger.new){
                GlobalMergeClass.lnew = l;
            }
        }
        // end add
        if(trigger.isDelete){
            for(lead obj_lead: trigger.Old){
                IF(obj_lead.MasterRecordId != null){
                    if(GlobalMergeClass.set_sIds == null) {
                        GlobalMergeClass.set_sIds = new set<Id>();
                    }
                    if(!GlobalMergeClass.set_sIds.contains(obj_lead.Id)) {
                        if(GlobalMergeClass.lst_Sobject == null) {
                            GlobalMergeClass.lst_Sobject = new List<Lead>();
                        }
                        GlobalMergeClass.lst_Sobject.add(obj_lead);
                        GlobalMergeClass.set_sIds.add(obj_lead.Id);
                    }
                }
            }
            //GlobalMergeClass.globalMergeMethod();
        }
    }
    // start add --to transport the value of lst_Sobject and lnew to globalMergeMethod 
    if(GlobalMergeClass.lst_Sobject != null && GlobalMergeClass.lst_Sobject.size() > 1 && GlobalMergeClass.lnew != null) {
        GlobalMergeClass.globalMergeMethod();
    }
    // end add
    }
}