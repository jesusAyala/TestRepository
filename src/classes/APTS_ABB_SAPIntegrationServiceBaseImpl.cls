public with sharing class APTS_ABB_SAPIntegrationServiceBaseImpl implements APTS_ABB_LP_iIntegrationCallback {
    
    public class APTS_ABB_LP_IntegrationException extends Exception{}
    private List<Task> lstActivityInfo;
    
    public APTS_ABB_SAPIntegrationServiceBaseImpl(){
        this.lstActivityInfo = new List<Task>();
    }
    
    public Boolean invoke(String agreementId, String blockParam){
        
        Boolean isSuccess = false;
        if(blockParam == null || blockParam == ''){
            blockParam = 'false';
        }
        
        //Part- I - fetch the data
        List<Apttus__APTS_Agreement__c> lstAgreement =  [SELECT Id, Name, APTS_Integration_Status__c, CurrencyISOCode, APTS_Sales_Office_Code__c,
                                                        APTS_SAP_Customer_ID__c, APTS_SAP_Reference_No__c,APTS_Manually_Create_MSPA_in_SAP__c, 
                                                        Apttus__Status__c, APTS_LP_Sales_Organization__c, APTS_Total_Agreement_Value__c, APTS_Country__c,
                                                        APTS_LP_MSPA_Type__c, APTS_Local_Channel__r.APTS_Code__c, APTS_LP_Max_Order_Amount__c, 
                                                        Apttus__Contract_End_Date__c, APTS_LP_Sales_Person__r.Name, 
                                                        Apttus__Contract_Start_Date__c, APTS_Sales_Office__r.PickList_Code__c,
                                                        Apttus_CMConfig__PriceListId__r.currencyISOcode,
                                                        APTS_Distribution_Channel__r.APTS_Code__c, 
                                                        (SELECT Id, Name, currencyISOcode, Apttus_CMConfig__BasePrice__c, 
                                                        Apttus__NetPrice__c, Apttus_CMConfig__LineNumber__c, Apttus__Quantity__c, 
                                                        APTS_Discount_Type__c, APTS_LP_Unit_Of_Measure__c, Apttus__AgreementId__c, 
                                                        APTS_Net_Price_Override__c, APTS_Discount_Percentage__c,
                                                        Apttus__AgreementId__r.APTS_SAP_Reference_No__c, 
                                                        Apttus__ProductId__r.APTS_LP_Is_Hierarchy__c, 
                                                        Apttus__ProductId__r.APTS_LP_Product_Hierarchy__c,
                                                        Apttus__AgreementId__r.APTS_LP_Sales_Organization__c, APTS_Product_Code__c,
                                                        APTS_Line_Number_Custom__c
                                                        FROM Apttus__AgreementLineItems__r) 
                                                        FROM Apttus__APTS_Agreement__c WHERE Id = :agreementId];
        if(lstAgreement.size() != 1){
            notifyUser();
            return false;
        }
        
        Apttus__APTS_Agreement__c agrmt = lstAgreement[0];
        
        //Part- III - get Auth token
        isSuccess = APTS_ABB_LP_SAP_Integration_Util.GetSecureOauthTokenAzure();
        if(!isSuccess){
            
            if(!blockParam.toLowerCase().equals('true')){
                AgreementSO agreement = new AgreementSO(agrmt.Id);
                agreement.manualCreationInSAP = true;
                agreement.status = 'Approved but failed to load on SAP';
                agreement.integrationStatus = 'Failed';
                
                updateSObject(agreement);
            }
            
            
            createActivity(agrmt.Id, 'SAP Integration Error - Unable to get oAuth Token', APTS_ABB_LP_SAP_Integration_Util.errorMsg);
            insert lstActivityInfo;
            
            notifyUser();
            return false;
        }
        
        try{
            //Part- II - preapre data & Part- IV - prepare request
            
            String jsonRequest = APTS_ABB_LP_SAP_Integration_Util.getSAPRequestJSON(agrmt, blockParam.toLowerCase());
            System.debug('jsonRequest: '+jsonRequest);
            
            //Part- V - do callout
            //create http request to connect to SAP
            HttpRequest req = new HttpRequest();
            req.setEndpoint(APTS_ABB_LP_SAP_Integration_Util.sapEndPoint);//set end point here
            req.setMethod('POST');
            req.setHeader(APTS_ABB_LP_SAP_Integration_Util.sapHeaderKey, APTS_ABB_LP_SAP_Integration_Util.getSasToken());//pass sas token for authentication
            req.setHeader('X-HTTP-Method', 'POST');
            req.setHeader('Content-Type', 'application/json');
            req.setBody(jsonRequest);//pass json body with agreement and agreement line items
            req.setTimeout(APTS_ABB_LP_SAP_Integration_Util.callTimeout);
            
            Http http = new Http();
            
            createActivity(agrmt.Id, 'MSPA Request sent to SAP', req.getBody().length() < 32000 ? req.getBody() : req.getBody().left(29999));
            
            HttpResponse res = http.send(req);
            String responseJson = res.getBody();
            System.debug('responseJson: '+responseJson);
            APTS_ABB_LP_SAP_Tokens.MSPASAPResponseWrapper responses = (APTS_ABB_LP_SAP_Tokens.MSPASAPResponseWrapper)JSON.deserialize(responseJson, APTS_ABB_LP_SAP_Tokens.MSPASAPResponseWrapper.class);
            System.debug('responseWrapper: '+responses);
            
            createActivity(agrmt.Id, 'MSPA Response received from SAP', responseJson.length() < 32000 ? responseJson : res.getBody().left(29999));
            
            AgreementSO agreement = new AgreementSO(agrmt.Id);
            
            if(blockParam != null && blockParam.toLowerCase().equals('true')){
                agreement.blockStatus = true;
                agreement.status = 'Blocked';
            }
                
            if(res == null || res.getStatusCode() != 200 || responses.Errors.size() > 0){
                String descr = 'Erorr code: \n' + JSON.serialize(responses.Errors);
                if(descr.contains('502')){
                    descr = 'Error: MSPA('+agrmt.APTS_SAP_Reference_No__c+') already exist in SAP. \n' + descr;
                }
                
                agreement.manualCreationInSAP = true;
                agreement.status = 'Approved but failed to load on SAP';
                agreement.integrationStatus = 'Failed';
                createActivity(agrmt.Id, 'MSPA Failed to Load in SAP', descr);
            }
            
            updateSObject(agreement);
            
        }catch(Exception exp){
            
            AgreementSO agreement = new AgreementSO(agrmt.Id);
            agreement.manualCreationInSAP = true;
            agreement.status = 'Approved but failed to load on SAP';
            agreement.integrationStatus = 'Failed';
            String errorMsg = 'Error Type: '+ exp.getTypeName() + '\n Error: '+ exp.getMessage() + '\n'+ 'Cause: '+exp.getCause() + '\n' + 'Line Number: '+ exp.getLineNumber() + '\n StackTrace: '+ exp.getStackTraceString();
            APTS_ABB_LP_SAP_Integration_Util.errorMsg = errorMsg;
            createActivity(agrmt.Id, 'MSPA Failed to load in SAP', errorMsg);
            
            updateSObject(agreement);
            notifyUser();
            
            return false;
            
        }finally{
            
            if(lstActivityInfo.size() > 0){
                insert lstActivityInfo;
            }
        }
        
        return true;
    }
    
    private void updateSObject(AgreementSO agreement){
        
        Apttus__APTS_Agreement__c agreementObj = new Apttus__APTS_Agreement__c(Id = agreement.Id, Apttus__Status__c = agreement.status,
        APTS_Integration_Status__c = agreement.integrationStatus, 
        APTS_Manually_Create_MSPA_in_SAP__c = agreement.manualCreationInSAP);
        
        update agreementObj;
    }
    
    private void createActivity(String sObjectId, String subject, String description){
        
        Task activity = new Task();
        activity.ActivityDate = System.today();
        activity.OwnerId = UserInfo.getUserId();
        activity.Priority = 'Low';
        activity.Status = 'Completed';
        activity.Subject = subject;
        activity.Description = description;
        activity.WhatId = sObjectId;
        
        lstActivityInfo.add(activity);
    }
    
    private void notifyUser(){
         /*
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
         String[] toAddresses = new String[] {'avaru@apttus.com'};
         mail.setToAddresses(toAddresses);
         //mail.setReplyTo('developer@acme.com');
         mail.setSenderDisplayName('Apex error message');
         mail.setSubject('Error from Org : ' + UserInfo.getOrganizationName());
         mail.setPlainTextBody('error occurred integrating SAP.');
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
         */
    }
    
    public class AgreementSO{
        
        public String Id{get; set;}
        public String status{get; set;}
        public Boolean blockStatus{get; set;}
        public String integrationStatus{get; set;}
        public Boolean manualCreationInSAP{get; set;}
        
        public AgreementSO(){
            
            this.manualCreationInSAP = false;
            this.status = 'Approved';
            this.integrationStatus = 'Sent';
            this.blockStatus = false;
        }
        
        public AgreementSO(String agreementId){
            this();
            this.Id = agreementId;
        }
    }
}