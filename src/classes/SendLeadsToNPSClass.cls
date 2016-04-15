/**
    @Author Rajesh K
    @name SendLeadsToNPSClass
    @CreateDate 1/06/2015
    @Version 1.0
    **/
global without sharing class SendLeadsToNPSClass
{
    /*  Description of the purpose of the method. 
    *  @name validator
    *  @Description - validate valid lead or not.
    *  @return String
    */
    webservice static String validator(List<Id> leadids) 
    {       
        List<Lead> lstLead = [Select id, ownerid, salutation, Related_existing_Contact__c, Related_Account__c, NPS_ID__c, 
                              NPS_Ready__c, Lead_Origin__c, owner.email, Originating_Country__c, CreatedDate, NPS_Survey_End_Date__c,
                              Email, Preferred_Language__c, Company, PostalCode, city, state, Country, firstName, 
                              lastName, phone, Participant_reminder__c,title from Lead where id IN:leadids];
        //List<Lead> lstupdLead = new List<Lead>();
        List<Lead> lstcorrectLeads = new List<Lead>();
        List<Lead> lstfalseLeads = new List<Lead>();
        //Boolean check = false;
        //String npsparam = null;
        for(Lead objlead: lstLead){
            if(objlead.NPS_ID__c != null || objlead.NPS_Ready__c == false){
                lstfalseLeads.add(objlead);
                //check = true;
            }else{
                lstcorrectLeads.add(objlead);
            }
        }
        if(lstcorrectLeads.size() == 0){
            return System.label.INTEG_SYS_SendNPS_Return1; //'No Leads ready for NPS selected, please use a correct filtering criteria to select only valid leads';           
        }else{
            Map<id, Integer> map_leadidNPSprop = new Map<id,Integer>();
            List <Lead> l_resp = new List<Lead>();
            Set<Id> setRelExContacts = new Set<Id>();
            Set<Id> setRelAccs = new Set<Id>();
            Set<String> setGUIDS = new Set<String>();
            Set<Id> ownerids = new Set<Id>();
            Set<Id> managerids = new Set<Id>();
            Map<id,Contact> map_contact = new Map<id,Contact>();
            Map<id,Account> map_account = new Map<id,Account>();
            Map<id,User> map_manager = new Map<id,User>();
            Map<id,String> map_managerfedid = new Map<id,String>();
            
            Map<String,Account> map_RootAccountGUID = new Map<String,Account>();
            for(Lead led: lstcorrectLeads){
                setRelExContacts.add(led.Related_existing_Contact__c);
                setRelAccs.add(led.Related_Account__c);
                ownerids.add(led.ownerid);
            }
          //  System.debug('Test'+ ownerids );
            for(User usr : [select Managerid,FederationIdentifier from user where id IN: ownerids LIMIT 50000]){
                managerids.add(usr.Managerid);
                map_manager.put(usr.id,usr);
            }
            //System.debug('Test'+ managerids);
            for(User usr : [select Managerid,FederationIdentifier from user where id IN: managerids LIMIT 50000]){
                map_managerfedid.put(usr.id,usr.FederationIdentifier);
            }
           // System.debug('Test'+ map_managerfedid);
            //map_managerfedid.get(map_manager.get(l.ownerid).Managerid);
            for(Contact objcon : [select id, firstName, lastName, title, salutation, email, phone, Preferred_Language__c from Contact where id IN: setRelExContacts LIMIT 50000]){
                map_contact.put(objcon.id, objcon);
            }
            for(Account objacc : [Select id,name, Root_Account_GUID__c, Account_Short_Name__c, ABB_Business_Partner_Segment_Level1__c, ABB_Business_Partner_Segment_Level2__c, BillingPostalCode, BillingCity, BillingState,BillingCountry, Account_Type__c, GUID__c from Account where id IN: setRelAccs LIMIT 50000]){
                if(objacc.Root_Account_GUID__c != null){
                    setGUIDS.add(objacc.Root_Account_GUID__c);
                }
                map_account.put(objacc.id, objacc);
            }
            for(Account objacc : [Select id,name, Root_Account_GUID__c, Account_Short_Name__c, ABB_Business_Partner_Segment_Level1__c, ABB_Business_Partner_Segment_Level2__c, BillingPostalCode, BillingCity, BillingState,BillingCountry, Account_Type__c, GUID__c from Account where guid__c IN: setGUIDS LIMIT 50000]){
                map_RootAccountGUID.put(objacc.guid__c,objacc);
            }
            
            for(Lead l: lstcorrectLeads){
                NPSservice.SurveyProperty parameters = new NPSservice.SurveyProperty();             
                //Parameters when Lead not converted or no Account Associated
                //Contact parameters
                List <NPSservice.participant> l_cont = new List<NPSservice.participant>();
                NPSservice.participant cont = new NPSservice.participant();
                if(l.Related_existing_Contact__c == NULL){
                    cont.email = l.email;
                    String languageCont = l.Preferred_Language__c;
                    cont.nativeLanguage = languageCont.toUpperCase();
                    cont.firstName = l.firstName;
                    cont.lastName = l.lastName;
                    cont.telephone = l.phone;
                    String salutationFull = l.salutation;
                    if(!String.isBlank(salutationFull )){
                        cont.title = salutationFull != 'Prof.' ? salutationFull.remove('.') : salutationFull;    
                    }
            
                }else{
                    if(map_contact.containskey(l.Related_existing_Contact__c)){                 
                        String partEmail = map_contact.get(l.Related_existing_Contact__c).email;
                        cont.email = partEmail;
                        String languageCont = map_contact.get(l.Related_existing_Contact__c).Preferred_Language__c;
                        cont.nativeLanguage = languageCont.toUpperCase();
                        cont.firstName = map_contact.get(l.Related_existing_Contact__c).firstName;
                        cont.lastName = map_contact.get(l.Related_existing_Contact__c).lastName;
                        cont.telephone = map_contact.get(l.Related_existing_Contact__c).phone;
                        String salutationFull = map_contact.get(l.Related_existing_Contact__c).salutation;
                        if(!String.isBlank(salutationFull )){
                            cont.title = salutationFull != 'Prof.' ? salutationFull.remove('.') : salutationFull;    
                        }
                    }
                }
                l_cont.add(cont);
                
                
                //Account parameters
                List <NPSservice.customer> l_acc = new List<NPSservice.customer>();
                NPSservice.customer acc = new NPSservice.customer();
                if(l.Related_Account__c == NULL){
                    acc.name = l.company;
                    acc.zip = l.postalcode;
                    acc.city = l.city;
                    acc.state = l.state;
                    acc.country = l.country;
                    acc.participant = l_cont;
                    //String accType = l_acc[0].Account_Type__c;
                    String accType = System.label.INTEG_SYS_SendNPS_Acctype; //'OPEN';
                    acc.accountType = accType.touppercase();
                    acc.leadingBusinessPartnerSegment = System.label.INTEG_SYS_SendNPS_AccBusinessSegment1; //'None Classified';
                }else{
                    if(map_account.containskey(l.Related_Account__c)){
                        Account accSFDC = map_account.get(l.Related_Account__c);                        
                        if(accSFDC.Root_Account_GUID__c !=NULL && accSFDC.Root_Account_GUID__c != accSFDC.GUID__c ){
                            //Create Head quarter values
                            if(map_RootAccountGUID.containskey(accSFDC.Root_Account_GUID__c)){
                                Account l_head = map_RootAccountGUID.get(accSFDC.Root_Account_GUID__c);                             
                                NPSservice.customer head = new NPSservice.customer();
                                head.name = l_head.name;
                                head.zip = l_head.BillingPostalCode ;
                                head.city = l_head.BillingCity ;
                                head.state = l_head.BillingState ;
                                head.country = l_head.BillingCountry;
                                head.leadingBusinessPartnerSegment = String.isBlank(l_head.ABB_Business_Partner_Segment_Level2__c)? l_head.ABB_Business_Partner_Segment_Level1__c : l_head.ABB_Business_Partner_Segment_Level2__c; //'Wholesale and distribution';
                                String accTypeHead = accSFDC.Account_Type__c;
                                head.accountType = accTypeHead.touppercase();
                                head.guid= l_head.guid__c;
                                head.shortName =l_head.Account_Short_Name__c;
                                acc.headquarter=head;
                            }
                        }
                        acc.name = accSFDC.name;
                        acc.zip = accSFDC.BillingPostalCode ;
                        acc.city = accSFDC.BillingCity ;
                        acc.state = accSFDC.BillingState ;
                        acc.country = accSFDC.BillingCountry;
                        acc.leadingBusinessPartnerSegment = String.isBlank(accSFDC.ABB_Business_Partner_Segment_Level2__c)? accSFDC.ABB_Business_Partner_Segment_Level1__c : accSFDC.ABB_Business_Partner_Segment_Level2__c; //'Wholesale and distribution';
                        String accType = accSFDC.Account_Type__c;
                        if(String.isBlank(accType)){
                        }else{
                            acc.accountType = accType.touppercase();
                            acc.guid= accSFDC.guid__c;
                            acc.shortName = accSFDC.Account_Short_Name__c;
                            acc.participant = l_cont;
                        }                       
                    }
                }
                l_acc.add(acc);
                String detractorResEmail = null;
                String OwnerFedid = null;
                if(map_manager.containskey(l.ownerid) && map_managerfedid.containskey(map_manager.get(l.ownerid).Managerid)){                     
                    detractorResEmail = String.valueof(map_managerfedid.get(map_manager.get(l.ownerid).Managerid));
                }
                if(map_manager.containskey(l.ownerid)){
                    OwnerFedid = map_manager.get(l.ownerid).FederationIdentifier;
                }
                //General parameters
                parameters.participantType = System.label.INTEG_SYS_SendNPS_PartType; //'EXTERNAL';
                parameters.bu = System.label.INTEG_SYS_SendNPS_BU;  //'CCM';
                parameters.lbu = l.Originating_Country__c;
                parameters.serviceReportNumber = l.id;
                parameters.reasonOfWork = l.Lead_Origin__c;
                parameters.serviceJobStartDate = l.createdDate;
                parameters.serviceJobEndDate = system.Now();
                parameters.surveyEndDate = l.NPS_Survey_End_Date__c;
                //parameters.detractorRedCardResponsibleEmail = 'michal.pyla@pl.abb.com';
                parameters.detractorRedCardResponsibleEmail = detractorResEmail;
                parameters.reminderEmailDate = l.Participant_reminder__c;
                parameters.customers = l_acc;
                parameters.participants = l_cont;
                
                NPSservice.SurveyServiceImplPort callNPS = new NPSservice.SurveyServiceImplPort();
                try{    
                    System.debug('Param: '+parameters);                
                    //NPSservice.SurveyResponse resp = callNPS.createSurvey(parameters, true, 'adam.kot@pl.abb.com');
                    System.debug('Responsible:'+OwnerFedid);
                    System.debug('Detractor:'+detractorResEmail );
                    NPSservice.SurveyResponse resp = callNPS.createSurvey(parameters, true, OwnerFedid);
                    System.debug('Response: '+resp);
                    map_leadidNPSprop.put(l.id, resp.surveyId);
                    l_resp.add(l);
                }catch(Exception e){
                    system.debug('Exception'+ e);
                }
            }
            system.debug('Map Built:'+map_leadidNPSprop);
            List <Lead> toUpdate = new List<Lead>();
            Integer correctedLead = 0;
            for(Lead l: l_resp){
                Integer npsIDint = map_leadidNPSprop.get(l.Id);
                if(npsIDint !=NULL){
                    String npsIDstr = String.valueOf(npsIDint);
                    l.NPS_ID__c = npsIDstr;
                    toUpdate.add(l);
                    correctedLead = correctedLead + 1;
                }
            }
            update toUpdate;
            return System.label.INTEG_SYS_SendNPS_Return2 + ' ' + correctedLead  + ' ' + System.label.INTEG_SYS_SendNPS_Return3 + ' ' + lstLead.size() + ' ' + System.label.INTEG_SYS_SendNPS_Return4;
        }
    }    
}