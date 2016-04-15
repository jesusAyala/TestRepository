/*************************************************************
@Name: APTS_MSPACreatorInSAPController
@Author: Ganga Vemula
@CreateDate: 17th sep 2015.
@Description: This class is to create MSPA in SAP also the same class is being used to block MSPA in SAP.
                This class will invoke from the button where user click on button to create MSPA in SAP or Block in SAP.
@UsedBy: used by agreetement trigger to create MSPA in SAP 
******************************************************************/

public class APTS_MSPACreatorInSAPController {

    //current agreement
    private Apttus__APTS_Agreement__c oAgreement;
    //status to set to failed
    private static string STATUS_FAILED = 'Approved but failed to load on SAP';
    //status to approved
    private static string STATUS_APPROVED = 'Approved';
    //status blocked
    private static string STATUS_BLOCKED = 'Blocked';
    //identify "block" action
    public static string sIsBlock;
    private static string SUBSTITUTE_DISCOUNT = 'Substitute Discount';
    private static string NET_DISCOUNT = 'Net Price Discount';
    private static string ADDITIONAL_DISCOUNT = 'Additional Discount';
    private static string ERROR_EXIST = 'SERVER_ERROR_EXIST';
    private static string INT_STATUS_FAILED='Failed';
    private static string INT_STATUS_SUCCESS='Success';
    private static string INT_STATUS_SENT='Sent';
    
    //Constructor
    public APTS_MSPACreatorInSAPController(ApexPages.StandardController stdController) {
        //get agreement
        this.oAgreement = (Apttus__APTS_Agreement__c) stdController.getRecord();
        sIsBlock=Apexpages.currentpage().getparameters().get('BlockParam');
    }

    /*
        @Method to create MSPA in SAP
        @This method will be called through button on MSPA layout
        @param: pagereference 
        */
    public pagereference createMSPAviaButton() {

        Set < Id > setAgrmtIds = new set < Id > ();
        
        /*
        //get block param from url if the action is "block" or skip if the action in MSPA creation  
        if (Apexpages.currentpage().getparameters().get('BlockParam') != null) {
            sIsBlock = Apexpages.currentpage().getparameters().get('BlockParam');
        }*/
        
        //APTS_SAP_Integration_Tokens__c sapToken = APTS_SAP_Integration_Tokens__c.getValues('SAP MSPA Creation Tokens');
         APTS_Agreement_SAP_Setting__c sapSettings = [select id,name,APTS_Block_MSPA_Creation_In_SAP__c from APTS_Agreement_SAP_Setting__c where APTS_Country__c=:this.oAgreement.APTS_Country__c limit 1];
         
        if(sIsBlock != null && sIsBlock.toLowerCase().equals('true') && !sapSettings.APTS_Block_MSPA_Creation_In_SAP__c){
            //System.debug('blocking MSPA..'+ sIsBlock.toLowerCase() +':::'+sapToken.APTS_Block_in_SAP__c);
           
            ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Warning,Label.APTS_MSPA_Block_error);
            ApexPages.addmessage(msg);
            return null; 
            //return new pagereference('/' + oAgreement.Id);
        }
        //this method will be called when user click on create MSPA button on layout, so set<agrmtIds> will always holds single value 
        //since the method "CreateOrBlockMSPA" expects set<Id>, added the current agreement id to set and passed it to method.
        /*
        setAgrmtIds.add(oAgreement.Id);
        //call method to create MSPA 
       string errorMsg = CreateOrBlockMSPA(setAgrmtIds, sIsBlock);
       */
       APTS_ABB_SAPIntegrationServiceBaseImpl integrationHandler = new APTS_ABB_SAPIntegrationServiceBaseImpl();
       Boolean isSuccess = integrationHandler.invoke(oAgreement.Id, sIsBlock);
       System.debug('is Integration Successful?: '+isSuccess);
       
       if(!isSuccess){
           
           String errMsg = APTS_ABB_LP_SAP_Integration_Util.errorMsg;
           
           if(APTS_ABB_LP_SAP_Integration_Util.errorMsg != null && APTS_ABB_LP_SAP_Integration_Util.errorMsg.toLowerCase().contains('read timed out')){
           
               errMsg = 'Error occurred: Read Timed out, please try after sometime.';
           }
           
            ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.error, errMsg);
            ApexPages.addmessage(msg);
            return null; 
       }

        //once MSPA creation is done, redirect back to MSPA 
        return new pagereference('/' + oAgreement.Id);
    }


    /*
        @param: set of agreement Ids, string
        @This is the common method is to handle both MSPA Creation and blocking
        @pass BlockParam as 'True' for blocking action, pass BlockParam as null for MSPA creation(from trigger)
        */
    public static string createOrBlockMSPA(set < Id > agrmntIds, string bBlockParam) {

        list < cls_SalesDealItems > agrmtlinestopass = new list < cls_SalesDealItems > ();
        list < Apttus__APTS_Agreement__c > agrmtstoupdate = new list < Apttus__APTS_Agreement__c > ();
        set<id> duppreventer=new set<id>();
        //access token from authentication response
        String access_token;
        string errorMsg;
        APIResponseBody sapResponseBody;


        //read static values from custom settings
        APTS_SAP_Integration_Tokens__c MSPACreationDataset = APTS_SAP_Integration_Tokens__c.getValues('SAP MSPA Creation Tokens');

        //get base address from custom setting
        String baseaddress = MSPACreationDataset.APTS_Base_Address__c, keyname = MSPACreationDataset.APTS_Key_Name__c,key = MSPACreationDataset.APTS_Key__c,Baucode = MSPACreationDataset.APTS_Bau_Code__c, ErpResponseCulture = MSPACreationDataset.APTS_ERP_Response_Culture__c, endpoint = MSPACreationDataset.APTS_End_Point__c, headerkey = MSPACreationDataset.APTS_Http_Header_Key__c, sasToken = APTS_SAPPricingIntegrationController.GetSasToken(baseaddress, keyname, key);
        system.debug('#### sasToken: ' + sasToken);

        //parent wrapper to form request body
        MSPARequestWrapper reqBody = new MSPARequestWrapper();

        /*
        //get current MSPA  and its child records using cross object query   
        list < Apttus__APTS_Agreement__c > agreementlist = [select id, name, CurrencyISOCode, APTS_Sales_Office_Code__c, APTS_SAP_Customer_ID__c, APTS_SAP_Reference_No__c, Apttus__Status__c, APTS_LP_Sales_Organization__c, APTS_Total_Agreement_Value__c, APTS_LP_MSPA_Type__c, APTS_LP_Local_Channel__c, APTS_LP_Max_Order_Amount__c, Apttus__Contract_End_Date__c, APTS_LP_Sales_Person__r.Name, Apttus__Contract_Start_Date__c, APTS_LP_Sales_Office__c, (select id, name, currencyISOcode, Apttus_CMConfig__BasePrice__c, Apttus__NetPrice__c, Apttus_CMConfig__LineNumber__c, Apttus__Quantity__c, APTS_Discount_Type__c, APTS_LP_Unit_Of_Measure__c, Apttus__AgreementId__c, APTS_Net_Price_Override__c, APTS_Discount_Percentage__c, Apttus__AgreementId__r.APTS_SAP_Reference_No__c, Apttus__ProductId__r.APTS_LP_Is_Hierarchy__c, Apttus__ProductId__r.APTS_LP_Product_Hierarchy__c, Apttus__AgreementId__r.APTS_LP_Sales_Organization__c, APTS_Product_Code__c
        from Apttus__AgreementLineItems__r) from Apttus__APTS_Agreement__c where Id IN: agrmntIds];
        */
        List<Apttus__APTS_Agreement__c> agreemnt = [select id, name,APTS_Integration_Status__c , CurrencyISOCode, APTS_Sales_Office_Code__c,
                                            APTS_SAP_Customer_ID__c, APTS_SAP_Reference_No__c, Apttus__Status__c, 
                                            APTS_LP_Sales_Organization__c,APTS_Manually_Create_MSPA_in_SAP__c, APTS_Total_Agreement_Value__c, APTS_Country__c,
                                            APTS_LP_MSPA_Type__c, /*APTS_LP_Local_Channel__c,*/ APTS_LP_Max_Order_Amount__c, 
                                            Apttus__Contract_End_Date__c, APTS_LP_Sales_Person__r.Name, 
                                            Apttus__Contract_Start_Date__c, APTS_Sales_Office__r.PickList_Code__c,
                                            (select id, name, currencyISOcode, Apttus_CMConfig__BasePrice__c, 
                                            Apttus__NetPrice__c, Apttus_CMConfig__LineNumber__c, Apttus__Quantity__c, 
                                            APTS_Discount_Type__c, APTS_LP_Unit_Of_Measure__c, Apttus__AgreementId__c, 
                                            APTS_Net_Price_Override__c, APTS_Discount_Percentage__c,
                                            Apttus__AgreementId__r.APTS_SAP_Reference_No__c, 
                                            Apttus__ProductId__r.APTS_LP_Is_Hierarchy__c, 
                                            Apttus__ProductId__r.APTS_LP_Product_Hierarchy__c, 
                                            Apttus__AgreementId__r.APTS_LP_Sales_Organization__c, APTS_Product_Code__c
                                            from Apttus__AgreementLineItems__r) 
                                            from Apttus__APTS_Agreement__c where Id IN: agrmntIds];
                                                    
        system.debug('#### no. of times of execution ####'+agreemnt.size())    ;    
        for (Apttus__APTS_Agreement__c agrmt: [select id, name,APTS_Integration_Status__c , CurrencyISOCode, APTS_Sales_Office_Code__c,
                                            APTS_SAP_Customer_ID__c, APTS_SAP_Reference_No__c,APTS_Manually_Create_MSPA_in_SAP__c, Apttus__Status__c, 
                                            APTS_LP_Sales_Organization__c, APTS_Total_Agreement_Value__c, APTS_Country__c,
                                            APTS_LP_MSPA_Type__c, APTS_Local_Channel__r.APTS_Code__c, APTS_LP_Max_Order_Amount__c, 
                                            Apttus__Contract_End_Date__c, APTS_LP_Sales_Person__r.Name, 
                                            Apttus__Contract_Start_Date__c, APTS_Sales_Office__r.PickList_Code__c,
                                            (select id, name, currencyISOcode, Apttus_CMConfig__BasePrice__c, 
                                            Apttus__NetPrice__c, Apttus_CMConfig__LineNumber__c, Apttus__Quantity__c, 
                                            APTS_Discount_Type__c, APTS_LP_Unit_Of_Measure__c, Apttus__AgreementId__c, 
                                            APTS_Net_Price_Override__c, APTS_Discount_Percentage__c,
                                            Apttus__AgreementId__r.APTS_SAP_Reference_No__c, 
                                            Apttus__ProductId__r.APTS_LP_Is_Hierarchy__c, 
                                            Apttus__ProductId__r.APTS_LP_Product_Hierarchy__c,
                                            Apttus__AgreementId__r.APTS_LP_Sales_Organization__c, APTS_Product_Code__c
                                            from Apttus__AgreementLineItems__r) 
                                            from Apttus__APTS_Agreement__c where Id IN: agrmntIds]) {
                                                    
            
            //set integration status to sent initially
            //agrmt.APTS_Integration_Status__c =INT_STATUS_SENT;
            //update agrmt;

            //if azure authentication is success, access token will be returned by APTS_GenerateSecureoAuthTokenController 
            if (!APTS_GenerateSecureoAuthTokenController.GetSecureOauthTokenAzure(baseaddress).contains(ERROR_EXIST)) {

                //get oAuth token
                access_token = APTS_GenerateSecureoAuthTokenController.GetSecureOauthTokenAzure(baseaddress);

            } else { //in case of authentication failure, stamp the MSPA status as failed.
                
                system.debug('authentication failed.');
                //error handling: stamp the status as failed upon athentication failure.
                agrmt.Apttus__Status__c = STATUS_FAILED;
                agrmt.APTS_Integration_Status__c =INT_STATUS_FAILED;
                if(duppreventer.add(agrmt.Id)){
                 agrmtstoupdate.add(agrmt);
                }
            }

            cls_globalParams globalPar = new cls_globalParams(Baucode, agrmt.CurrencyISOCode, agrmt.APTS_SAP_Customer_ID__c, 
            access_token);
            reqBody.globalParams = globalPar;
            /*
            //assign global parameters to pass in json string
            globalPar.BauCode = Baucode;
            globalPar.Currency1 = agrmt.CurrencyISOCode;
            //set customer Id
            globalPar.CustomerCode = agrmt.APTS_SAP_Customer_ID__c; // '0010009006';
            //set access token for autherization
            globalPar.AuthToken = access_token;
            
            */


            if (agrmt.Apttus__AgreementLineItems__r.size() > 0) {
                
                Map<String, String> mapDealType = new Map<String, String>{
                        SUBSTITUTE_DISCOUNT => 'S',
                        NET_DISCOUNT => 'N',
                        ADDITIONAL_DISCOUNT => 'A'
                    };
                    
                Map<String, String> mapDealValue = new Map<String, String>{
                    SUBSTITUTE_DISCOUNT => 'APTS_Discount_Percentage__c',
                    NET_DISCOUNT => 'APTS_Net_Price_Override__c',
                    ADDITIONAL_DISCOUNT => 'APTS_Discount_Percentage__c'
                };
                
                Map<String, String> mapDealCalculationType = new Map<String, String>{
                    SUBSTITUTE_DISCOUNT => 'A',
                    NET_DISCOUNT => 'B',
                    ADDITIONAL_DISCOUNT => 'A'
                };
                
                //create  list of agreement line items to pass in json string to SAP                                                      
                for (Apttus__AgreementLineItem__c ali : agrmt.Apttus__AgreementLineItems__r) {
                    //todo: skip all those line which are product and having zero price
                    if(ali.Apttus_CMConfig__BasePrice__c == 0 && !ali.Apttus__ProductId__r.APTS_LP_Is_Hierarchy__c){
                        continue;
                    }
                    
                    String ProductHierarchy = ali.Apttus__ProductId__r.APTS_LP_Product_Hierarchy__c;//ali.Apttus__ProductId__r.APTS_LP_Is_Hierarchy__c ? ali.Apttus__ProductId__r.APTS_LP_Product_Hierarchy__c : '';
                    String ProductCode = ali.Apttus__ProductId__r.APTS_LP_Is_Hierarchy__c ? '' : ali.APTS_Product_Code__c;
                    system.debug('Is Hierarchy? : '+ali.Apttus__ProductId__r.APTS_LP_Is_Hierarchy__c+' --> prod Code: '+ali.APTS_Product_Code__c);
                    String dealType, dealValue, dealCalculationType;
                    if(mapDealValue.containsKey(ali.APTS_Discount_Type__c)){
                        dealType = mapDealType.get(ali.APTS_Discount_Type__c);
                        dealValue = String.valueOf(ali.get(mapDealValue.get(ali.APTS_Discount_Type__c)));
                        dealCalculationType = mapDealCalculationType.containsKey(ali.APTS_Discount_Type__c) ? mapDealCalculationType.get(ali.APTS_Discount_Type__c) : 'B';
                    }
                    
                    dealValue = dealValue != null ? dealValue : '0';
                    system.debug('--> dealType: '+dealType+' --> dealValue: '+dealValue+' --> dealCalculationType: '+dealCalculationType);
                    /*todo:
                    deal calculation type = A , if discount % is specified for line item
                    deal calculation type = B, if net price override is specified for line item
                    */
                    
                    cls_SalesDealItems agrmtlineitem = new cls_SalesDealItems('0', dealCalculationType, 
                    agrmt.APTS_SAP_Reference_No__c, ali.currencyISOcode, dealType, dealValue, 
                    String.valueOf(ali.Apttus_CMConfig__LineNumber__c), '0', '0', '0', '0', '0', '0', '0', '0', 
                    ProductHierarchy, ali.Apttus__AgreementId__r.APTS_LP_Sales_Organization__c, 
                    String.valueOf(ali.Apttus__Quantity__c.setscale(2)), ProductCode);
                    
                    agrmtlinestopass.add(agrmtlineitem);
                }
            }

            //agreement line items data to pass as json body
            //cls_SalesDealItems agrmtlineitems = new cls_SalesDealItems();
            //agrmtlineitems.SalesDealItem = agrmtlinestopass;

            //pass MSPA values from salesforce to SAP      
            cls_createSalesDealRequest MSPA = new cls_createSalesDealRequest();

            if (bBlockParam != null && bBlockParam == 'True') {
                //for MSPA blocking, block=true
                MSPA.Block ='1'; //'true';
                system.debug('blocked status***' + bBlockParam);
            } else {
                //for MSPA creation block=false  
                MSPA.Block ='0';// 'false';
            }

            //set max order value
            MSPA.MaxOrdVal = String.valueOf(agrmt.APTS_LP_Max_Order_Amount__c);
            //min order value will be 0
            MSPA.MinOrdVal = '0';
            MSPA.SalesMan = agrmt.APTS_LP_Sales_Person__r.name;
            MSPA.SalesOffice = agrmt.APTS_Sales_Office__r.PickList_Code__c != null ? agrmt.APTS_Sales_Office__r.PickList_Code__c.left(3) : null;//read from sales office of MSPA - read first 3 chars.
            //sales organisation will be ABB always
            MSPA.SalesOrganization = agrmt.APTS_LP_Sales_Organization__c;
            //MSPA start date
            Datetime startdate = agrmt.Apttus__Contract_Start_Date__c;
            //MSPA end date
            Datetime enddate = agrmt.Apttus__Contract_End_Date__c;
            //convert dates into json format
            MSPA.ValidFrom = '/Date(' + startdate.getTime() + ')/';
            MSPA.ValidtO = '/Date(' + enddate.getTime() + ')/';

            if (bBlockParam == 'True') {
                //action will be 'B' for blocking of MSPA
                MSPA.Action = 'B';
                system.debug('blocked***' + bBlockParam);
            } else {
                //action will be 'I' for insertion of MSPA
                MSPA.Action = 'I';
            }
            
            String dealType1;
            
            for(APTS_IntegrationMappingParameters__c parameter : APTS_IntegrationMappingParameters__c.getAll().values()){
                
                if(parameter.APTS_TargetObject__c == 'Apttus__APTS_Agreement__c' && 
                    parameter.APTS_ParameterName__c == 'DealType' && agrmt.APTS_Country__c == parameter.APTS_Country__c){
                        
                        dealType1 = parameter.APTS_ParameterValue__c;
                }
            }
            system.debug('--> dealType1: '+dealType1);
            
            MSPA.CustomerGroup=agrmt.APTS_Local_Channel__r.APTS_Code__c;
            //MSPA.CustomerGroup = agrmt.APTS_LP_Local_Channel__c;//needs to be local chanel of mspa
            //deal type is "Project" whose code is "2" for spain
            //MSPA.DealType=agrmt.APTS_LP_MSPA_Type__c;
            MSPA.DealType = dealType1;//'3';//todo: deal type -> needs to be in custom settings
            MSPA.DealValue = String.valueOf(agrmt.APTS_Total_Agreement_Value__c.setscale(2));
            MSPA.DealCode = agrmt.APTS_SAP_Reference_No__c;
            //this field is not needed for spain but it cannot be null, hence passing 0 value
            MSPA.ResidualAmount = '0';
            MSPA.SalesDealItems = agrmtlinestopass;

            reqBody.createSalesDealRequest = MSPA;
            //serialize in to JSON
            string Jsonbody = JSON.serialize(reqBody);
            Jsonbody = Jsonbody.replace('Currency1', 'Currency');
            System.debug('#### Jsonbody ' + Jsonbody);


            //create http request to connect to SAP
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http();

            //set end point here    
            req.setEndpoint(endpoint);
            req.setMethod('POST');
            //pass sas token for authentication
            req.setHeader(headerkey, sasToken);
            req.setHeader('X-HTTP-Method', 'POST');
            req.setHeader('Content-Type', 'application/json');
            //pass json body with agreement and agreement line items
            req.setBody(Jsonbody);
            System.debug('#### Request Body: ' + req.getBody());
            System.debug('#### Request: ' + String.valueOf(req));

            try {
                system.debug('#### status before http request ###'+agrmt.Apttus__Status__c);
              //  if(agrmt.Apttus__Status__c == APTS_Constants.STATUS_APPROVED_ACTION_REQ){
                //here is the response from SAP
                res = http.send(req);

                // if status if 200-OK, de serialize the response here
                if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {

                    sapResponseBody = (APIResponseBody) JSON.deserialize(res.getbody(), APIResponseBody.class);
                    System.debug('#### response errors: ' + sapResponseBody.errors.size() + ':::' + sapResponseBody.SalesDealItems.size());
                    
                }

                System.debug('#### response Body: ' + res.getBody());
                //check if blocking is success and update the status
                if (res.getStatusCode() >= 200 && res.getStatusCode() < 300 && bBlockParam == 'True') {

                    //update status to blocked
                    agrmt.Apttus__Status__c = STATUS_BLOCKED;
                    agrmt.APTS_LP_Blocked__c = true;
                    agrmtstoupdate.add(agrmt);
                    

               } else if ((res.getStatusCode() >= 300 && (bBlockParam == '' || bBlockParam == null)) || (res.getStatusCode() >= 200 && res.getStatusCode() < 300 && (bBlockParam == '' || bBlockParam == null) && (!sapResponseBody.Errors.isEmpty() || sapResponseBody.SalesDealItems.isEmpty()))) { //check if MSPA creation is not success and update status to failed

                    //error handling: if authentication passed but errors exist in response or line item creation failed, then stamp the status as failed
                    //update MSPA status if MSPA creation failed in SAP
                    agrmt.Apttus__Status__c = STATUS_FAILED;
                    agrmt.APTS_Integration_Status__c =INT_STATUS_FAILED;
                    if(duppreventer.add(agrmt.Id)){
                        agrmtstoupdate.add(agrmt);
                    }

                } else if (res.getStatusCode() >= 200 && res.getStatusCode() < 300 && (bBlockParam == '' || bBlockParam == null)) { //check if MSPA creation is success and update the status to Approved

                    agrmt.Apttus__Status__c = STATUS_APPROVED;
                    agrmt.APTS_Manually_Create_MSPA_in_SAP__c=false;
                    agrmt.APTS_Integration_Status__c =INT_STATUS_SUCCESS;
                    agrmtstoupdate.add(agrmt);
                    

                }else if(res.getStatusCode() != 200 && bBlockParam == 'True') {
                    //return erro in case of server issues
                    errormsg=Label.APTS_Block_Server_Error;
                    return errormsg; 
                    
                }

                //Activity History
                Task sapReq = new Task();
                sapReq.ActivityDate = System.today();
                sapReq.OwnerId = UserInfo.getUserId();
                sapReq.Priority = 'Low';
                sapReq.Status = 'Completed';
                sapReq.Subject = 'MSPA Request sent to SAP '+agrmtstoupdate.size();
                sapReq.Description = req.getBody().length() < 32000 ? req.getBody() : req.getBody().left(29999);//'Pricing request for products sent to SAP';
                sapReq.WhatId = agrmt.Id;
                
                Task sapRes = new Task();
                sapRes.ActivityDate = System.today();
                sapRes.OwnerId = UserInfo.getUserId();
                sapRes.Priority = 'Low';
                sapRes.Status = 'Completed';
                sapRes.Subject = 'MSPA information received from SAP '+agrmtstoupdate.size();
                sapRes.Description = res.getBody().length() < 32000 ? res.getBody() : req.getBody().left(29999); // : 'Error in receiving pricing information from SAP';
                sapRes.WhatId =  agrmt.Id;
                insert new List<Task>{sapReq, sapRes};
               // }

            } catch (System.CalloutException ex) {
                System.debug('#### Callout error: ' + ex.getMessage()+' -> line#: '+ex.getLineNumber());
            } catch (Exception ex) {
                System.debug('#### General Callout error: ' + ex.getMessage()+' -> line#: '+ex.getLineNumber());
            }

        }

        //reset static flag to stop recursiveness
        APTS_ProcessorControl.inFutureContext = true;

        if (!agrmtstoupdate.isEmpty()) {
            update agrmtstoupdate;
        }
        
        return null;

    }

    
    //Method to go back to MSPA
     public pagereference backToMSPA(){
        // update new Apttus__APTS_Agreement__c(Id = oAgreement.Id, APTS_LP_Blocked__c = true);
         return new pagereference('/' + oAgreement.Id);
     }

    /*
        @This method will be called from trigger as async call
        @param: set of agreement Ids, string
        @This method is to handle both MSPA Creation and blocking
        @pass BlockParam as 'True' for blocking action, pass BlockParam as null for MSPA creation(from trigger)
        */
    @Future(callout = true)
    public static void createMSPA(set < Id > agrmntIds, string bBlockParam) {

        //call the method to create MSPA 
        //CreateOrBlockMSPA(agrmntIds, bBlockParam);
        List<Id> agrmnt = new List<Id>(agrmntIds);
        APTS_ABB_SAPIntegrationServiceBaseImpl integrationHandler = new APTS_ABB_SAPIntegrationServiceBaseImpl();
        Boolean isSuccess = integrationHandler.invoke(agrmnt[0], sIsBlock);
        System.debug('is Integration Successfull?: '+isSuccess);
        
        Integer NEXTTRY_INTERVAL = 5;
        Decimal EXECUTION_COUNT = 3;
        APTS_Config_SAP_Integration__c configInteg = APTS_Config_SAP_Integration__c.getValues('MSPA SAP Config');
        if(configInteg != null){
            NEXTTRY_INTERVAL = Integer.valueOf(configInteg.APTS_Call_Interval__c);
            EXECUTION_COUNT = configInteg.APTS_of_Re_Tries__c;
        }
        
        List<APTS_ABB_LP_Thwarted_Agreement__c> lstThwartedAgmt = [SELECT Id, APTS_Object_Id__c, APTS_Agreement_Status__c, 
                                                                   APTS_Block_Parameter__c, APTS_Job_execution_Count__c, APTS_Cron_Job_Id__c
                                                                   FROM APTS_ABB_LP_Thwarted_Agreement__c
                                                                   WHERE APTS_Object_Id__c = :agrmnt[0]];
        
        APTS_ABB_LP_Thwarted_Agreement__c thwartedAgreement = new APTS_ABB_LP_Thwarted_Agreement__c();
        
        if(isSuccess && lstThwartedAgmt.size() > 0){
            
            thwartedAgreement = lstThwartedAgmt[0];
            thwartedAgreement.APTS_Agreement_Status__c = 'Success';
            update thwartedAgreement;
            
            system.abortJob(thwartedAgreement.APTS_Cron_Job_Id__c);
        }
        
        if(!isSuccess){
            
            APTS_ABB_LP_PushFailedMSPAtoSAP schduler = new APTS_ABB_LP_PushFailedMSPAtoSAP(agrmnt[0]);
            
            Decimal NO_OF_TIMES_JOB_EXECUTED = 1;
            
            DateTime dt = System.now().addMinutes(NEXTTRY_INTERVAL);
            String day = String.valueOf(dt.day());
            String month = String.valueOf(dt.month());
            String year = String.valueOf(dt.year());
            String hour = String.valueOf(dt.hour());
            String minute = String.valueOf(dt.minute());
            
            String sch = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ? ' + year;
            String jobName = 'MSPA( '+agrmnt[0]+' ) - SAP Creation ';
            
            if(lstThwartedAgmt.size() > 0){
                
                thwartedAgreement = lstThwartedAgmt[0];
                NO_OF_TIMES_JOB_EXECUTED = thwartedAgreement.APTS_Job_execution_Count__c + 1;
                jobName = jobName + String.valueOf(NO_OF_TIMES_JOB_EXECUTED);
                thwartedAgreement.APTS_Job_execution_Count__c = thwartedAgreement.APTS_Job_execution_Count__c + 1;
                System.abortJob(thwartedAgreement.APTS_Cron_Job_Id__c);
                
            }else{
                
                jobName = jobName + ' 1';
                thwartedAgreement.APTS_Object_Id__c = agrmnt[0];
                thwartedAgreement.APTS_Block_Parameter__c = sIsBlock;
                thwartedAgreement.APTS_Job_execution_Count__c = 1;
            }
            
            if(NO_OF_TIMES_JOB_EXECUTED > EXECUTION_COUNT){
                
                thwartedAgreement.APTS_Description__c = 'MSPA is Failed to load in SAP '+NO_OF_TIMES_JOB_EXECUTED + ' times. \n System will not try loading same MSPA again to SAP.';
            }else{
                
                String jobID = System.schedule(jobName, sch, schduler);
                thwartedAgreement.APTS_Cron_Job_Id__c = jobID;
                thwartedAgreement.APTS_Description__c = 'Error occured loading to SAP.';
            }
            
            thwartedAgreement.APTS_Agreement_Status__c = 'Failure';
            
            try{
                upsert thwartedAgreement;
            }catch(Exception exp){
                System.debug('Error inserting Thwarted Agreement: '+exp.getMessage());
            }
        }
    }

    //following inner classes are created from provided json string   

    //wrapper class to construct JSON body for agreement and agreement line items
    public class MSPARequestWrapper {

        public cls_globalParams globalParams;
        public cls_createSalesDealRequest createSalesDealRequest;

    }

    //wrapper to set global parameters for authentication
    class cls_globalParams {

        public String BauCode;
        public string Currency1;
        public String CustomerCode;
        public string AuthToken;
        
        public cls_globalParams(){
            
        }
        public cls_globalParams(String BauCode, String Currency1, String CustomerCode, String AuthToken){
            this.BauCode = BauCode;
            this.Currency1 = Currency1;
            this.CustomerCode = CustomerCode;
            this.AuthToken = AuthToken;
        }
    }

    //wrapper to set MSPA field from salesforce to SAP
    class cls_createSalesDealRequest {

        //For blocking Action="B", for insert, "I", for read "R", for update "U"
        public String Action;
        //block=true for blocking else it will be false  
        public String Block;
        //local channel
        public String CustomerGroup;
        public String DealCode;
        //MSPA type
        public String DealType;
        //total agreement value
        public String DealValue;
        //maximum order value  
        public String MaxOrdVal;
        //minimum order value  
        public String MinOrdVal;
        //residual amount is not needed for spain
        public String ResidualAmount;
        public cls_SalesDealItems[] SalesDealItems;
        public String SalesMan;
        public String SalesOffice;
        public String SalesOrganization;
        //start date of MSPA  
        public string ValidFrom;
        //End date of MSPA
        public string ValidTo; ///Date(1391122800000)/
        
        public cls_createSalesDealRequest(){
            
        }
        
    }
    /*
    class cls_SalesDealItems {
        public cls_SalesDealItem[] SalesDealItem;
    }*/

    //wrapper to set MSPA line item field values
    class cls_SalesDealItems {
        
        public String ConditionPricingUnit, DealCalculationType,DealCode,DealCurrency,DealType,DealValue,ItemNumber,
        MaxOrdQty,MaxOrdVal,Maxconval,MinOrdQty,MinOrdVal,OrderQty,OrderVal,PricingUnit,ProductHierarchy,SalesOrganization,
        ScaleQuantity,ProductCode;
        
        public cls_SalesDealItems(){
            
        }
        
        public cls_SalesDealItems(String ConditionPricingUnit,String DealCalculationType,String DealCode,String DealCurrency,
        String DealType,String DealValue,String ItemNumber,String MaxOrdQty,String MaxOrdVal,String Maxconval, String MinOrdQty,
        String MinOrdVal, String OrderQty, String OrderVal, String PricingUnit, String ProductHierarchy,
        String SalesOrganization, String ScaleQuantity, String ProductCode){
        
            this.ConditionPricingUnit = ConditionPricingUnit;
            this.DealCalculationType = DealCalculationType;
            this.DealCode = DealCode;
            this.DealCurrency = DealCurrency;
            this.DealType = DealType;
            this.DealValue = DealValue;
            this.ItemNumber = ItemNumber;
            this.MaxOrdQty = MaxOrdQty;
            this.MaxOrdVal = MaxOrdVal;
            this.Maxconval = Maxconval;
            this.MinOrdQty = MinOrdQty;
            this.MinOrdVal = MinOrdVal;
            this.OrderQty = OrderQty;
            this.OrderVal = OrderVal;
            this.PricingUnit = PricingUnit;
            this.ProductHierarchy = ProductHierarchy;
            this.SalesOrganization = SalesOrganization;
            this.ScaleQuantity = ScaleQuantity;
            this.ProductCode = ProductCode;
            
        }
    }

    public class APIResponseBody {
        public cls_Errors[] Errors;
        public cls_SalesDealItems[] SalesDealItems;
    }


    class cls_Errors {

        public String Code;

    }


}