/**   
    * Controller : SendToCCRP Button on Case Controller 
    * Release R5
    *  
    * @author  (Nikhil Pimpale)
    * @created  09-12-2015
    * @Updated Rajesh Kaliyaperumal
    */ 
    global without sharing class SendToCCRPController {

        /**   
        * Controller : SendToCCRPController
        * Release R5
        *  
        * @author  
        * @created  
        *
        */
        public Case caseController;
        private Id complaintRecTypeId;
        public Boolean innerblock {get;set;}
        public Boolean outerblock {get;set;}
        public String caseId;
        public String strSubstituteFedId {get; set;}
         /**   
        * Controller : SendToCCRPController
        * Release R5
        *
        */
        global SendToCCRPController(ApexPages.StandardController controller) {
            caseId = apexpages.currentpage().getparameters().get(System.label.INTEG_SYS_Case_BU_ID);
            //controller.addFields(new List<String>{'AccountId','Account.Name','Owner_Type__c','Contact.Name','ContactId','OwnerId','Description','Category_2__c','CCRP_Status__c','RecordtypeId'});
            //controller.addFields(new List<String>{System.label.INTEG_SYS_SendCCRP_Accountid,System.label.INTEG_SYS_SendCCRP_AccountName,System.label.INTEG_SYS_SendCCRP_OwnerType,System.label.INTEG_SYS_SendCCRP_ContactName,System.label.INTEG_SYS_SendCCRP_ContactId,System.label.INTEG_SYS_SendCCRP_OwnerId,System.label.INTEG_SYS_SendCCRP_Description,System.label.INTEG_SYS_SendCCRP_Category2,System.label.INTEG_SYS_SendCCRP_CCRPStatus,System.label.INTEG_SYS_SendCCRP_RecordtypeId});
            //this.caseController = (Case)controller.getRecord();
            complaintRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.label.INTEG_SYS_SendCCRP_Complaint).getRecordTypeId();
            innerblock = true;
            outerblock = false;
        }   
         /**   
        * Controller : updatestatus
        * Release R5
        *
        */
        public pagereference updatestatus(){
            String customerfederationidentifier = '';
            String userEmail = '';
            String caseStatus = '';
            String caseDescription = '';
            String caseSubject = '';
            String caseProdCategory = '';
            String caseCustomerReference = '';
            String casePriority = '';
            String caseSeverity = '';
            String caseTargetSolutionDate = '';
            String custAccountid = '';
            String caseAccountABBid = '';
            String custname = '';
            String customerstreet = '';
            String customercity = '';
            String customercountrycode = '';
            String customerzip = '';
            String customerstate = '';
            String contactid = '';
            String contactfirstname = '';
            String contactlastname = '';
            String contactemail = '';
            String conphone = '';
            String cnumber = '';
            String origicountry = '';
            String division = '';
            String businessunit = '';
            String productgroup = '';
            String product = '';
            String serialnumber = '';
            String abbordernumber = '';
            String salesordernumber = '';
            String purchaseordernumber = '';
            String serviceagreement = '';
            String sapnumber = '';
            String projectnumber = '';
            String substituteFedId = ''; 
            String error;
            String complaintID;
            String complaintNumber;
            String resultType;
            String answer;
            String resStatus;
            Map<String, object> m = new Map<String, object>();
            
        try{
            Case objcase = [SELECT Id, Related_Account_Identifier__c, AccountId, Account.BillingStreet, Account.BillingCity, Contact.Name, Account.BillingState, Account.BillingCountry, Account.BillingCountryCode, Account.BillingPostalCode, Account.Name, ContactId, Contact.Firstname, Contact.Lastname, Contact.Email,Contact.Phone, OwnerId, Status, Description, Subject, Product_Category__c, Customer_Reference__c, Priority, Severity__c, Target_Resolution_Date__c, CaseNumber, Originating_Country__c, Division__c, Business_Unit__c, Product_Group__c, ProductID, Product.Name, Serial_Number__c, ABB_Order_Number__c, Sales_Order_Number__c, Purchase_Order_Number__c, Service_Agreement__c, SAP_Number__c, Project_Number__c, CCRP_Owner_Email__c, CCRP_Status__c FROM case WHERE id =: caseId LIMIT 1];
            List<User> objuser = [SELECT FederationIdentifier, email from user WHERE id =: objcase.OwnerId Limit 1];
            List<Attachment> lstattachments = [SELECT Id,Name,OwnerId,ParentId FROM Attachment WHERE ParentId =: caseId];
            if(strSubstituteFedId != null){
                string newSubs= strSubstituteFedId.replace(' ','');
                substituteFedId  = newSubs;
            }           
            if(!objuser.isEmpty() && objuser[0].FederationIdentifier != null){                
                customerfederationidentifier = objuser[0].FederationIdentifier;
            }
            if(!objuser.isEmpty() && objuser[0].Email != null){                
                userEmail = objuser[0].Email;
            }
            if(objcase.Status != null){
                caseStatus = objcase.Status;
            }
            if(objcase.Description != null){
                caseDescription = objcase.Description;
            }
            if(objcase.Subject != null){
                caseSubject = objcase.Subject;
            }
            if(objcase.Product_Category__c != null){
                caseProdCategory = objcase.Product_Category__c;
            }
            if(objcase.Customer_Reference__c != null){
                caseCustomerReference = objcase.Customer_Reference__c;
            }
            if(objcase.Priority != null){
                casePriority = objcase.Priority;
            }
            if(objcase.Severity__c != null){
                caseSeverity = objcase.Severity__c;
            }
            if(objcase.Target_Resolution_Date__c != null){
                caseTargetSolutionDate = String.valueof(objcase.Target_Resolution_Date__c);
            }
            if(objcase.AccountId != null){
                custAccountid = objcase.AccountId;
                //custAccountid = 'G01209365';
            }
            if(objcase.Related_Account_Identifier__c!= null){
                caseAccountABBid = objcase.Related_Account_Identifier__c;
                //custAccountid = 'G01209365';
            }
            if(objcase.Account.Name != null){
                custname = objcase.Account.Name;
            }
            if(objcase.Account.BillingStreet != null){
                customerstreet = objcase.Account.BillingStreet;
            }
            if(objcase.Account.BillingCity != null){
                customercity = objcase.Account.BillingCity;
            }
            if(objcase.Account.BillingCountryCode != null){
                customercountrycode = objcase.Account.BillingCountryCode;
            }
            if(objcase.Account.BillingPostalCode != null){
                customerzip = objcase.Account.BillingPostalCode;
            }
            if(objcase.Account.BillingState != null){
                customerstate = objcase.Account.BillingState;
            }
            if(objcase.ContactId != null){
                contactid = objcase.ContactId;
            }
            if(objcase.Contact.Name != null){
                contactfirstname = objcase.Contact.firstname;
            }
            if(objcase.Contact.Name != null){
                contactlastname = objcase.Contact.lastname;
            }
            if(objcase.Contact.Email != null){
                contactemail = objcase.Contact.Email;
            }
            if(objcase.Contact.Phone != null){
                conphone = objcase.Contact.Phone;
            }
            if(objcase.CaseNumber != null){
                cnumber = objcase.CaseNumber;
            }
            if(objcase.Originating_Country__c != null){
                origicountry = objcase.Originating_Country__c;
            }
            if(objcase.Division__c != null){
                division = objcase.Division__c;
            }
            if(objcase.Business_Unit__c != null){
                businessunit = objcase.Business_Unit__c;
            }
            if(objcase.Product_Group__c != null){
                productgroup = objcase.Product_Group__c;
            }
            if(objcase.Product != null){
                product = String.valueof(objcase.Product.Name);
            }
            if(objcase.Serial_Number__c != null){
                serialnumber = objcase.Serial_Number__c;
            }
            if(objcase.ABB_Order_Number__c != null){
                abbordernumber = objcase.ABB_Order_Number__c;
            }
            if(objcase.Sales_Order_Number__c != null){
                salesordernumber = objcase.Sales_Order_Number__c;
            }
            if(objcase.Purchase_Order_Number__c != null){
                purchaseordernumber = objcase.Purchase_Order_Number__c;
            }
            if(objcase.Service_Agreement__c != null){
                serviceagreement = objcase.Service_Agreement__c;
            }
            if(objcase.SAP_Number__c != null){
                sapnumber = objcase.SAP_Number__c;
            }
            if(objcase.Project_Number__c != null){
                projectnumber = objcase.Project_Number__c;
            }      
            
            String serverurl = URL.getSalesforceBaseUrl().toExternalForm();
            //Parameters
            JSONGenerator generator = JSON.createGenerator(true);   //instantiation of the generator
            generator.writeStartObject();               // Writes the starting marker of a JSON object '{'
            generator.writeStringField('caseOwnerFederationId', customerfederationidentifier);
            generator.writeStringField('status', caseStatus);
            generator.writeStringField('description', caseDescription);
            generator.writeStringField('subject', caseSubject);
            generator.writeStringField('productCategoryName', caseProdCategory);
            generator.writeStringField('CustomerReference', caseCustomerReference);
            generator.writeStringField('priority', casePriority);
            generator.writeStringField('severity', caseSeverity);
            generator.writeStringField('targetResolutionDate', caseTargetSolutionDate);
            generator.writeStringField('substituteFederationId', substituteFedId);
            generator.writeFieldName('customer');
            generator.writeStartObject();
            generator.writeStringField('sfdcAccountId', custAccountid);
            generator.writeStringField('customerAccountCode', caseAccountABBid);
            generator.writeStringField('customerName', custname);
            generator.writeStringField('street', customerstreet);
            generator.writeStringField('city', customercity);
            generator.writeStringField('countryCode', customercountrycode);
            generator.writeStringField('zipCode', customerzip);
            generator.writeStringField('state', customerstate);
            generator.writeEndObject();
            generator.writeFieldName('customerContact');
            generator.writeStartObject();
            generator.writeStringField('sfdcContactId', contactid);
            generator.writeStringField('firstName', contactfirstname);
            generator.writeStringField('lastName', contactlastname);
            generator.writeStringField('email', contactemail);
            generator.writeStringField('contactPhone', conphone);
            generator.writeEndObject();
            generator.writeFieldName('salesForceInfo');
            generator.writeStartObject();
            generator.writeStringField('caseId', caseid);
            generator.writeStringField('caseNumber', cnumber);
            generator.writeStringField('originatingCountry', origicountry);
            generator.writeStringField('division', division);
            generator.writeStringField('businessUnit', businessunit);
            generator.writeStringField('productGroup', productgroup);
            generator.writeStringField('product', product);
            generator.writeStringField('serialNumber', serialnumber);
            generator.writeStringField('abbOrderNumber', abbordernumber);
            generator.writeStringField('salesOrderNumber', salesordernumber);
            generator.writeStringField('purchaseOrderNumber', purchaseordernumber);
            generator.writeStringField('serviceAgreement', serviceagreement);
            generator.writeStringField('sapNumber', sapnumber);
            generator.writeStringField('projectNumber', projectnumber);
            generator.writeEndObject();
            if(lstattachments.size()>0){
            generator.writeFieldName('attachments');
            generator.writeStartArray();
            
            
            for(Attachment objattach : lstattachments){
                generator.writeStartObject();
                //String[] strname = String.valueof(objattach.Name).split('\\.');
                generator.writeStringField('id', String.valueof(objattach.id));
                generator.writeStringField('fileName', objattach.Name);
                //generator.writeStringField('fileName', !strname.isEmpty()? strname[0]: '');
                generator.writeStringField('urlToFile', serverurl + '/servlet/servlet.FileDownload?file=' + String.valueof(objattach.id));
                generator.writeEndObject();
            }
            
            
            generator.writeEndArray(); 
            }
            generator.writeEndObject();                 //Writes the ending marker of a JSON object '}'
            String jsonString = generator.getAsString();
            System.debug('JSON:::'+jsonString);


            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json; charset=UTF-8');
            req.setHeader('Authorization', system.label.SYS_CCRP_Authorization);
            req.setBody(jsonString);
            //String reqbody = 'https://ccrp.e.abb.com/SIT/api/complaints';
            req.setEndpoint(System.label.INTEG_SYS_CCRP_Popup_Endpoint_URL); 
            //req.setEndpoint(reqbody); 
            Http http = new Http();
            HTTPResponse res = http.send(req);
            answer = res.getBody();
            resStatus = res.getStatus();
            System.debug('Answer:::::: '+ answer);
            m = (Map<String, object>) JSON.deserializeUntyped(answer);
            if(m.containskey('resultType')){
                resultType = String.valueof(m.get('resultType'));
            }
            if(m.containskey('ResultType')){
                resultType = String.valueof(m.get('ResultType'));
            }
            
            }Catch(Exception ex){
                innerblock = false;
                outerblock = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
                return null;
            }   
            if(resultType == null){
                innerblock = false;
                outerblock = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,answer));   
                return null;
            }
            else if(resStatus.equals('Created') || resultType.equals('SUCCESS')){
                if(m.containskey('complaintId')){
                    complaintID = String.valueof(m.get('complaintId'));
                }
                if(m.containskey('ComplaintId')){
                    complaintID = String.valueof(m.get('ComplaintId'));
                }
                if(m.containskey('complaintNumber')){
                    complaintNumber = String.valueof(m.get('complaintNumber')); 
                }
                if(m.containskey('ComplaintNumber')){
                    complaintNumber = String.valueof(m.get('ComplaintNumber')); 
                }
                   
                List<Case> lstcase = new List<Case>();
                lstcase.add(new Case(id = caseId, CCRP_Status__c = 'Draft', CCRP_Owner_Email__c = userEmail, Complaint_Number__c = complaintNumber, Complaint_ID__c = complaintID, Status = System.label.INTEG_SYS_SendCCRP_Status, RecordtypeId = complaintRecTypeId)); //'Under Investigation'
                Database.update(lstcase, false);
                innerblock = false;
                outerblock = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Complaint has been created successfully on CCRP. \nComplaint Number: ' + complaintNumber));   //'Request has been sent successfully to CCRP.')); 
                return null;
            }
            else if(ResultType.equals('ERROR')){
                if(m.containskey('error')){                 
                    error = String.valueof(m.get('error'));
                }
                if(m.containskey('Error')){
                    error = String.valueof(m.get('Error'));
                }
                innerblock = false;
                outerblock = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,error));   //'Request has been sent successfully to CCRP.')); 
                return null;
            }
            else if(resStatus.equals('Bad Request')){
                innerblock = false;
                outerblock = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,answer));   
                return null;
            }
            
            return null;
        }
    }