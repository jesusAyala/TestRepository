/*  Description of the method. 
    *  @name NPS_SendRequestHandler
    *  @Author  Rajesh K
    *  @Description - Send Request Handler.
    */
global without sharing class NPS_SendRequestHandler {
    /*  Description of the method. 
    *  @name caseRequest
    *  @Description - Create case in NPS.
    *  @return Void
    */
    @future(callout=true)
    public static void caseRequest(String caseId){
        Case c =[Select id,Accountid, Originating_Country__c, ClosedDate, ownerid, contact.owner.email, Contactid,Business_Unit__c,Site_Name__c, Product.Name, Country__c, Reason_Of_Work__c, createdDate, Survey_End_Date__c, Participant_reminder__c from Case where id =: caseId LIMIT 1];
        String casOwnerID = c.ownerid;
        User contactOwner;
        if(casOwnerID.startsWithIgnoreCase('005')){
            User ownerdetail = [select Managerid,FederationIdentifier from user where id =: c.ownerid LIMIT 1];
            String fedIdUser = ownerdetail.FederationIdentifier;
        
            NPSservice.SurveyProperty parameters = new NPSservice.SurveyProperty();
            //Contact parameters
            List <NPSservice.participant> l_cont = new List<NPSservice.participant>();
            NPSservice.participant cont = new NPSservice.participant();
            
            List<Contact> l_contSFDC = [select firstName, lastName, salutation, email, Preferred_Language__c, owner.FederationIdentifier  from Contact where id =: c.contactid LIMIT 1];
            if(l_contSFDC .size()>0){
               contactOwner= [select Managerid,FederationIdentifier from user where id =: l_contSFDC[0].ownerid LIMIT 1];    
            }
            String partEmail=l_contSFDC[0].email;
            cont.email = partEmail;
            String languageCont = l_contSFDC[0].Preferred_Language__c;
            cont.nativeLanguage = languageCont != null ? languageCont.toUpperCase(): languageCont;
            cont.firstName = l_contSFDC[0].firstName;
            cont.lastName = l_contSFDC[0].lastName;
            String salutationFull = l_contSFDC[0].salutation;
            if(salutationFull ==NULL){
            }else{
                cont.title = salutationFull != 'Prof.' ? salutationFull.remove('.') : salutationFull;
            }
            l_cont.add(cont);
            
            
            //Account parameters
            List <NPSservice.customer> l_acc = new List<NPSservice.customer>();
            List<Account> l_accSFDC = [Select id,name, Root_Account_GUID__c, Account_Short_Name__c, ABB_Business_Partner_Segment_Level1__c, ABB_Business_Partner_Segment_Level2__c, BillingPostalCode, BillingCity, BillingState,BillingCountry, Account_Type__c, GUID__c from Account where id =: c.AccountId LIMIT 1];
            NPSservice.customer  acc = new NPSservice.customer();
            if(l_accSFDC[0].Root_Account_GUID__c !=NULL && l_accSFDC[0].Root_Account_GUID__c !=l_accSFDC[0].GUID__c ){
                //Create Head quarter values
                List<Account> l_head = [Select id,name, Root_Account_GUID__c, Account_Short_Name__c, ABB_Business_Partner_Segment_Level1__c, ABB_Business_Partner_Segment_Level2__c, BillingPostalCode, BillingCity, BillingState,BillingCountry, Account_Type__c, GUID__c from Account where guid__c =: l_accSFDC[0].Root_Account_GUID__c LIMIT 1];
                NPSservice.customer  head = new NPSservice.customer();
                head.name = l_head[0].name;
                head.zip = l_head[0].BillingPostalCode ;
                head.city = l_head[0].BillingCity ;
                head.state = l_head[0].BillingState ;
                head.country = l_head[0].BillingCountry;
                head.leadingBusinessPartnerSegment =  String.isBlank(l_head[0].ABB_Business_Partner_Segment_Level2__c)? l_head[0].ABB_Business_Partner_Segment_Level1__c : l_head[0].ABB_Business_Partner_Segment_Level2__c;
                String accTypeHead = l_head[0].Account_Type__c;
                head.accountType = accTypeHead != null ? accTypeHead.touppercase(): accTypeHead;
                head.guid= l_head[0].guid__c;
                head.shortName =l_head[0].Account_Short_Name__c;
                acc.headquarter=head;
            }
            
            acc.name = l_accSFDC[0].name;
            acc.zip = l_accSFDC[0].BillingPostalCode ;
            acc.city = l_accSFDC[0].BillingCity ;
            acc.state = l_accSFDC[0].BillingState ;
            acc.country = l_accSFDC[0].BillingCountry;
            acc.leadingBusinessPartnerSegment = String.isBlank(l_accSFDC[0].ABB_Business_Partner_Segment_Level2__c)? l_accSFDC[0].ABB_Business_Partner_Segment_Level1__c : l_accSFDC[0].ABB_Business_Partner_Segment_Level2__c; 
            String accType = l_accSFDC[0].Account_Type__c;
            acc.accountType = (accType != null ? accType.touppercase(): accType);
            acc.guid= l_accSFDC[0].guid__c;
            acc.shortName =l_accSFDC[0].Account_Short_Name__c;
            acc.participant = l_cont;
            l_acc.add(acc);
            
            //General parameters
            if(partEmail.contains('abb')){
                parameters.participantType = System.label.INTEG_SYS_SendNPS_PartType_Internal;  //'INTERNAL';
            }else{
               parameters.participantType = System.label.INTEG_SYS_SendNPS_PartType;         //'EXTERNAL'; 
            }
            String bu = c.Business_Unit__c;
            parameters.bu = bu.substring(0, 4);
            //parameters.bu = 'FULLSERVICE';
            parameters.plantSite = c.Site_Name__c;
            parameters.placeOfWork = c.Product.Name;
            parameters.lbu = c.Originating_Country__c;
            parameters.serviceReportNumber = c.id;
            parameters.reasonOfWork = c.Reason_Of_Work__c;
            parameters.serviceJobStartDate = c.createdDate;
            parameters.serviceJobEndDate = c.ClosedDate;
            parameters.surveyEndDate =  c.Survey_End_Date__c;
            parameters.detractorRedCardResponsibleEmail = contactOwner.FederationIdentifier; //c.contact.owner.email;
            parameters.reminderEmailDate = c.Participant_reminder__c;
            parameters.customers = l_acc;
            parameters.participants = l_cont;
            //NPS call
            NPSservice.SurveyServiceImplPort callNPS = new NPSservice.SurveyServiceImplPort();
           
            NPSservice.SurveyResponse resp = callNPS.createSurvey(parameters, true, fedIdUser);
            if(resp.surveyId !=NULL){
                Integer npsIDint = resp.surveyId;
                String npsIDstr = String.valueOf(npsIDint);
                c.NPS_ID__c = npsIDstr;
                Database.Update(c,False);
            }else{
                NPSservice.message[] mess = resp.result.message;
                c.NPS_Error_Message__c = mess[0].description;
                Database.Update(c,False);
            }        
       }
    }
    /*  Description of the method. 
    *  @name leadRequest
    *  @Description - Create lead in NPS.
    *  @return String
    */
    webService static String leadRequest(Id leadid){
        List <Lead> l_list = [Select id, NPS_ID__c, Ownerid, salutation, Related_existing_Contact__c, Related_Account__c, Lead_Origin__c, owner.email, Originating_Country__c, CreatedDate, NPS_Survey_End_Date__c, Email, Preferred_Language__c, Company, PostalCode, city, state, Country, firstName, lastName, phone, Participant_reminder__c,title from Lead where ID =: leadid LIMIT 1];
        if(l_list[0].NPS_ID__c !=NULL){
            return 'NPS Survey is already started by someone else while you were trying to execute it';
        }
        String ManagerFedid = null;
        User ownerdetail = [select Managerid,FederationIdentifier from user where id =: l_list[0].ownerid LIMIT 1];
        List<User> managerdetail = [select Managerid,FederationIdentifier from user where id =: ownerdetail.Managerid LIMIT 1];
        if(managerdetail.size()>0){
            ManagerFedid = managerdetail[0].FederationIdentifier;
        }
        NPSservice.SurveyProperty parameters = new NPSservice.SurveyProperty();
        //Parameters when Lead not converted or no Account Associated
        parameters.participantType = System.label.INTEG_SYS_SendNPS_PartType;    //'EXTERNAL';
        //Contact parameters
        List <NPSservice.participant> l_cont = new List<NPSservice.participant>();
        NPSservice.participant cont = new NPSservice.participant();
        if(l_list[0].Related_existing_Contact__c ==NULL){
            cont.email = l_list[0].email;
            String emailLead = l_list[0].email;
            if(emailLead.contains('abb')){
                parameters.participantType = System.label.INTEG_SYS_SendNPS_PartType_Internal;  //'INTERNAL';
            }else{
               parameters.participantType = System.label.INTEG_SYS_SendNPS_PartType;         //'EXTERNAL'; 
            }
            String languageCont = l_list[0].Preferred_Language__c;
            cont.nativeLanguage = languageCont != null ? languageCont.toUpperCase(): languageCont;
            cont.firstName = l_list[0].firstName;
            cont.lastName = l_list[0].lastName;
            cont.telephone = l_list[0].phone;
            String salutationFull = l_list[0].salutation;
            if(salutationFull ==NULL){
            }else{
                cont.title = salutationFull != 'Prof.' ? salutationFull.remove('.') : salutationFull;
            }
        }else{
            List<Contact> l_contSFDC = [select firstName, lastName, salutation, phone, email, Preferred_Language__c from Contact where id =: l_list[0].Related_existing_Contact__c LIMIT 1];
            String partEmail=l_contSFDC[0].email;
            cont.email = partEmail;
            String languageCont = l_contSFDC[0].Preferred_Language__c;
            cont.nativeLanguage = languageCont != null ? languageCont.toUpperCase(): languageCont;
            cont.firstName = l_contSFDC[0].firstName;
            cont.lastName = l_contSFDC[0].lastName;
            String salutationFull = l_contSFDC[0].salutation;
            if(salutationFull ==NULL){
            }else{
                cont.title = salutationFull != 'Prof.' ? salutationFull.remove('.') : salutationFull; 
            }
            //General parameters
            if(partEmail.contains('abb')){
                parameters.participantType = System.label.INTEG_SYS_SendNPS_PartType_Internal;  //'INTERNAL';
            }
            cont.telephone = l_contSFDC[0].phone;          
        }
        l_cont.add(cont);
        
        //Account parameters
        List <NPSservice.customer> l_acc = new List<NPSservice.customer>();
        NPSservice.customer  acc = new NPSservice.customer();
        if(l_list[0].Related_Account__c==NULL){
            acc.name = l_list[0].company;
            acc.zip = l_list[0].postalcode;
            acc.city = l_list[0].city;
            acc.state = l_list[0].state;
            acc.country = l_list[0].country;
            acc.participant = l_cont;
            //String accType = l_acc[0].Account_Type__c;
            String accType = System.label.INTEG_SYS_SendNPS_Acctype_Open;   //'OPEN';
            acc.accountType = (accType != null ? accType.touppercase(): accType);
            acc.leadingBusinessPartnerSegment =  '00.0';
        }else{
            List<Account> l_accSFDC = [Select id,name, Root_Account_GUID__c, Account_Short_Name__c, ABB_Business_Partner_Segment_Level1__c, ABB_Business_Partner_Segment_Level2__c, BillingPostalCode, BillingCity, BillingState,BillingCountry, Account_Type__c, GUID__c from Account where id =: l_list[0].Related_Account__c LIMIT 1];
            if(l_accSFDC[0].Root_Account_GUID__c !=NULL && l_accSFDC[0].Root_Account_GUID__c !=l_accSFDC[0].GUID__c ){
                //Create Head quarter values
                List<Account> l_head = [Select id,name, Root_Account_GUID__c, Account_Short_Name__c, ABB_Business_Partner_Segment_Level1__c, ABB_Business_Partner_Segment_Level2__c,  BillingPostalCode, BillingCity, BillingState,BillingCountry, Account_Type__c, GUID__c from Account where guid__c =: l_accSFDC[0].Root_Account_GUID__c LIMIT 1];
                NPSservice.customer  head = new NPSservice.customer();
                head.name = l_head[0].name;
                head.zip = l_head[0].BillingPostalCode ;
                head.city = l_head[0].BillingCity ;
                head.state = l_head[0].BillingState ;
                head.country = l_head[0].BillingCountry;
                head.leadingBusinessPartnerSegment = String.isBlank(l_head[0].ABB_Business_Partner_Segment_Level2__c)? l_head[0].ABB_Business_Partner_Segment_Level1__c : l_head[0].ABB_Business_Partner_Segment_Level2__c; 
                String accTypeHead = l_head[0].Account_Type__c;
                head.accountType = accTypeHead != null ? accTypeHead.touppercase() : accTypeHead;
                head.guid= l_head[0].guid__c;
                head.shortName =l_head[0].Account_Short_Name__c;
                acc.headquarter=head;
            }
            acc.name = l_accSFDC[0].name;
            acc.zip = l_accSFDC[0].BillingPostalCode ;
            acc.city = l_accSFDC[0].BillingCity ;
            acc.state = l_accSFDC[0].BillingState ;
            acc.country = l_accSFDC[0].BillingCountry;
            acc.leadingBusinessPartnerSegment = String.isBlank(l_accSFDC[0].ABB_Business_Partner_Segment_Level2__c)? l_accSFDC[0].ABB_Business_Partner_Segment_Level1__c : l_accSFDC[0].ABB_Business_Partner_Segment_Level2__c;  
            String accType = l_accSFDC[0].Account_Type__c;
            acc.accountType = (accType != null?accType.touppercase():accType);
            acc.guid= l_accSFDC[0].guid__c;
            acc.shortName =l_accSFDC[0].Account_Short_Name__c;
            acc.participant = l_cont;
        }
        l_acc.add(acc);
        
        //General parameters
        
        parameters.bu = System.label.INTEG_SYS_SendNPS_BU;  //'CCM';
        parameters.lbu = l_list[0].Originating_Country__c;
        parameters.serviceReportNumber = l_list[0].id;
        parameters.reasonOfWork = l_list[0].Lead_Origin__c;
        parameters.serviceJobStartDate = l_list[0].createdDate;
        parameters.serviceJobEndDate = system.now();
        parameters.surveyEndDate =  l_list[0].NPS_Survey_End_Date__c;
        //parameters.detractorRedCardResponsibleEmail = 'michal.pyla@pl.abb.com';
        parameters.detractorRedCardResponsibleEmail = ManagerFedid;
        parameters.reminderEmailDate = l_list[0].Participant_reminder__c;
        parameters.customers = l_acc;
        parameters.participants = l_cont;
        //NPS call
        NPSservice.SurveyServiceImplPort callNPS = new NPSservice.SurveyServiceImplPort();
        //NPSservice.SurveyResponse resp = callNPS.createSurvey(parameters, true, 'adam.kot@pl.abb.com');
        NPSservice.SurveyResponse resp = callNPS.createSurvey(parameters, true, ownerdetail.FederationIdentifier);
        if(resp.surveyId !=NULL){
            Integer npsIDint = resp.surveyId;
            String npsIDstr = String.valueOf(npsIDint);
            Lead l = l_list[0];
            l.NPS_ID__c = npsIDstr;
            Database.Update(l,False);
            String alertMessage = System.label.INTEG_SYS_SendNPS_Success + resp.surveyId; 
            return alertMessage;
        }else{
            NPSservice.message[] mess = resp.result.message;
            String alertMessage = System.label.INTEG_SYS_SendNPS_Error + mess[0].description;
            Boolean languageIssue =  alertMessage.contains('participant native language');
            Boolean languageIssue2 =  alertMessage.contains('Possible values: []');
            if(LanguageIssue && LanguageIssue2){
                return 'For the selected Originated Country, the preferred language selected is not valid.';
            }
            return alertMessage; 
        }
    }
}