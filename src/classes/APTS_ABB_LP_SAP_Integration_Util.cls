public with sharing class APTS_ABB_LP_SAP_Integration_Util {
    
    public static String errorMsg{get; private set;}
    public static String access_token{get; private set;}
    private static final String SAS_TOKEN_HEADER = 'SharedAccessSignature';
    private static final String SAS_TOKEN_PARAM_SR ='sr';
    private static final String SAS_TOKEN_PARAM_SIG ='sig';
    private static final String SAS_TOKEN_PARAM_SE = 'se';
    private static final String SAS_TOKEN_PARAM_SKN = 'skn';
    
    public static final String sapBaseAdd{get; private set;}
    public static final String sapKeyName{get; private set;}
    public static final String sapKey{get; private set;}
    public static final String sapBauCode{get; private set;}
    public static final String sapErpResCulture{get; private set;}
    public static final String sapEndPoint{get; private set;}
    public static final String sapHeaderKey{get; private set;}
    public static final Integer callTimeout{get; private set;}
    
    static{
        
        APTS_SAP_Integration_Tokens__c MSPACreationDataset = APTS_SAP_Integration_Tokens__c.getValues('SAP MSPA Creation Tokens');
        
        sapBaseAdd = MSPACreationDataset.APTS_Base_Address__c;////get base address from custom setting
        sapKeyName = MSPACreationDataset.APTS_Key_Name__c;////get key name
        sapKey = MSPACreationDataset.APTS_Key__c;////get key
        sapBauCode = MSPACreationDataset.APTS_Bau_Code__c;////get Baucode
        sapErpResCulture = MSPACreationDataset.APTS_ERP_Response_Culture__c;////get response culture
        sapEndPoint = MSPACreationDataset.APTS_End_Point__c;//get end point
        sapHeaderKey = MSPACreationDataset.APTS_Http_Header_Key__c;//get http header key value
        callTimeout = MSPACreationDataset.APTS_SAP_Call_Timeout_Millis__c != null ? Integer.valueOf(MSPACreationDataset.APTS_SAP_Call_Timeout_Millis__c) : 120000;
    }   
    
    public static Boolean GetSecureOauthTokenAzure(){
        
        Boolean isSuccess = false;
        
        //String oAuthToken, oAuthKeyName, oAuthPass, oAuthAdd, oAuthEndPoint, oAuthHeaderPoint, oAuthHeaderKey, 
        //read static values from custom settings
        APTS_SAP_Integration_Tokens__c SAPoAuthDataset = APTS_SAP_Integration_Tokens__c.getValues('SAP oAuth Tokens');
        
        //get erp gateway key from custom setting
        String authToken = SAPoAuthDataset.APTS_oAuth_Token__c;
        
        //get key name
        string keyname = SAPoAuthDataset.APTS_Key_Name__c;
        
        //get password
        string password = SAPoAuthDataset.APTS_Key__c;
        
        //get base address
        string authenticationaddress = SAPoAuthDataset.APTS_Base_Address__c;
        
        //get end point
        string endpoint = SAPoAuthDataset.APTS_End_Point__c;
        
        //get http header key value
        string headerkey = SAPoAuthDataset.APTS_Http_Header_Key__c;
        
        //generate oAuth token here
        String Token = EncodingUtil.base64Encode(Blob.valueof(authToken));
        
        string oAuthToken = 'Basic '+Token;
        
        Integer timeout = SAPoAuthDataset.APTS_SAP_Call_Timeout_Millis__c != null ? Integer.valueOf(SAPoAuthDataset.APTS_SAP_Call_Timeout_Millis__c) : 120000;
        
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        
        req.setEndpoint(endpoint);
        
        req.setMethod('POST');
        
        //pass authentication token to SAP
        req.setHeader(headerkey, oAuthToken);
        
        req.setHeader('Content-Type', 'application/json');
        
        //set the body with required parameters
        req.setBody('{"scope":"'+authenticationaddress+'","grant_type":"password","username":"'+keyname+'","password":"'+password+'"}');
        
        req.setTimeout(timeout);
        
        try{
            
            res = http.send(req);
            
            //system.debug('****responsebody azure'+res1.getbody()+':::'+req1.getbody());
            
            //check if authentication is success and deserialize the jason body to get access token
            if(res.getStatusCode() == 200){
                
                //deserialize json body to get access token
                APTS_ABB_LP_SAP_Tokens.oAuthIntegrationToken  jsonvalues = (APTS_ABB_LP_SAP_Tokens.oAuthIntegrationToken)JSON.deserialize(res.getbody(), APTS_ABB_LP_SAP_Tokens.oAuthIntegrationToken.class);
                APTS_ABB_LP_SAP_Integration_Util.access_token = 'OAuthJwt '+jsonvalues.access_token;
                isSuccess = true;
                
            }else {
                //return errormsg;
                APTS_ABB_LP_SAP_Integration_Util.errorMsg = 'Response code: '+res.getStatusCode() + '\n' + 'Response Status: '+res.getStatus();
            }   
            
        }catch (Exception exp) {
            //System.debug('#### General Callout error: '+ ex.getMessage());
            APTS_ABB_LP_SAP_Integration_Util.errorMsg = 'Error Type: '+ exp.getTypeName() + '\n Error: '+ exp.getMessage() + '\n'+ 'Cause: '+exp.getCause() + '\n' + 'Line Number: '+ exp.getLineNumber() + '\n StackTrace: '+ exp.getStackTraceString();
        }   
        
        return isSuccess;
        
    }
    
     /*
       @ Method to get sas token
       @ Param: resource url,key name,key
     **/
    public static string getSasToken() {   
        //set expiry here
        String expiry = string.valueof(system.now().getTime() /1000);
        //encode resource url and append expiry
        String stringToSign = EncodingUtil.urlEncode(sapBaseAdd, APTS_Constants.ENCODING_UTF_8) + '\n' + expiry;
        //get hmac code and encode it
        String signature = EncodingUtil.base64Encode(crypto.generateMac(APTS_Constants.ENCRYPTION_ALGO_HMACSHA256,
                                                    blob.valueof(stringtosign), blob.valueof(sapKey)));
                                                    
        //form the sas key in the format of (SharedAccessSignature sig=<signature-string>&se=<expiry>&skn=<keyName>&sr=<URL-encoded-resourceURI>)
        String sasToken = SAS_TOKEN_HEADER + ' ' + SAS_TOKEN_PARAM_SR + '=' + EncodingUtil.urlEncode(sapBaseAdd, APTS_Constants.ENCODING_UTF_8) +
                        '&' + SAS_TOKEN_PARAM_SIG + '=' + EncodingUtil.urlEncode(signature, APTS_Constants.ENCODING_UTF_8) +
                        '&' + SAS_TOKEN_PARAM_SE + '=' + expiry +
                        '&' + SAS_TOKEN_PARAM_SKN + '=' + sapKeyName;
       
        system.debug('***sas token'+sasToken);
        return sasToken;
    }

    public static String getSAPRequestJSON(Apttus__APTS_Agreement__c agrmt, String blockParam){
        
        APTS_ABB_LP_SAP_Tokens.SAPRequestAuthHeader globalPar = new APTS_ABB_LP_SAP_Tokens.SAPRequestAuthHeader();
        List<APTS_ABB_LP_SAP_Tokens.AgreementLineItems> agrmtlinestopass = new list<APTS_ABB_LP_SAP_Tokens.AgreementLineItems>();
        
        globalPar.BauCode = sapBauCode;
        globalPar.Currency1 = agrmt.Apttus_CMConfig__PriceListId__r.currencyISOcode;
        globalPar.CustomerCode = agrmt.APTS_SAP_Customer_ID__c;// '0010009006';//set customer Id
        globalPar.AuthToken = access_token;
        System.debug('***axay: '+access_token);
        
        //reqBody.globalParams = globalPar;
        for(Apttus__AgreementLineItem__c ali : agrmt.Apttus__AgreementLineItems__r){
                    
            //assign the MSPA line item field to JSON field values to be passesd to SAP
            APTS_ABB_LP_SAP_Tokens.AgreementLineItems agrmtlineitem = new APTS_ABB_LP_SAP_Tokens.AgreementLineItems();
            
            agrmtlineitem.ItemNumber = String.valueOf(ali.APTS_Line_Number_Custom__c);
            agrmtlineitem.DealCode = ali.Apttus__AgreementId__r.APTS_SAP_Reference_No__c;
            
            //setting default value for following fields which are not required for spain
            //since SAP expects some value for these fields we are sending default values as per json request
            //Scenario: MSPA line items were not created in SAP due to ignoring this data, hence populating all of these values to some defaults
            agrmtlineitem.OrderQty = '0';
            agrmtlineitem.OrderVal = '0';
            agrmtlineitem.PricingUnit = '0';
            agrmtlineitem.MinOrdVal = '0';
            agrmtlineitem.MinOrdQty = '0';
            agrmtlineitem.MaxOrdVal = '0';
            agrmtlineitem.MaxOrdQty = '0';
            agrmtlineitem.Maxconval = '0';
            agrmtlineitem.ConditionPricingUnit = '0';
            //end
            
            //send DealType="S" for substitute discount, "N" for net price discount and "A" for Additional discount
            //send Deal Value=Discount% for Substiture Discount, Net Price Override for Net Price Discount
            if(ali.APTS_Discount_Type__c == 'Substitute Discount'){
                
                agrmtlineitem.DealType = 'S';
                agrmtlineitem.DealValue = String.valueOf(ali.APTS_Discount_Percentage__c);
                agrmtlineitem.DealCalculationType = 'A';
                
                
            }else if(ali.APTS_Discount_Type__c == 'Net Price Discount'){
                
                agrmtlineitem.DealType = 'N';
                agrmtlineitem.DealValue = String.valueOf(ali.APTS_Net_Price_Override__c);
                agrmtlineitem.DealCalculationType = 'B';                
            }else if(ali.APTS_Discount_Type__c == 'Additional Discount'){
                
                agrmtlineitem.DealType = 'A';
                agrmtlineitem.DealValue = String.valueOf(ali.APTS_Discount_Percentage__c);
                agrmtlineitem.DealCalculationType = 'A';            
            }
            
            //sales organisation will be ABB always
            agrmtlineitem.SalesOrganization = agrmt.APTS_LP_Sales_Organization__c;
            agrmtlineitem.DistributionChannel = agrmt.APTS_Distribution_Channel__r.APTS_Code__c; 
            //set quantity
            agrmtlineitem.ScaleQuantity = String.valueOf(ali.Apttus__Quantity__c.setScale(2));
            agrmtlineitem.DealCurrency = ali.currencyISOcode;
            
            
            
            
            //pass productCode
            agrmtlineitem.ProductCode = ali.Apttus__ProductId__r.APTS_LP_Is_Hierarchy__c ? '' : ali.APTS_Product_Code__c;
            agrmtlineitem.ProductHierarchy = ali.Apttus__ProductId__r.APTS_LP_Product_Hierarchy__c;//ali.Apttus__ProductId__r.APTS_LP_Is_Hierarchy__c ? ali.Apttus__ProductId__r.APTS_LP_Product_Hierarchy__c : '';
            
          /*  if(ali.Apttus__ProductId__r.APTS_LP_Is_Hierarchy__c){
                agrmtlineitem.ProductHierarchy = ali.Apttus__ProductId__r.APTS_LP_Product_Hierarchy__c;
            }
           */
            
            agrmtlinestopass.add(agrmtlineitem);
        }
        
        //AgreementHeader
        APTS_ABB_LP_SAP_Tokens.AgreementHeader MSPA = new APTS_ABB_LP_SAP_Tokens.AgreementHeader();
        //MSPA.
        
        if(blockParam != null && blockParam.toLowerCase() == 'true'){
            //for MSPA blocking, block=true
            MSPA.Block = '1';
            MSPA.Action = 'B';
        }else{
            //for MSPA creation block=false  
            MSPA.Block = '0';
            MSPA.Action = 'I';
        }
        
        //Added by Jignesh from Old version of copy
        String sDealTypeForHeader;        
        for(APTS_IntegrationMappingParameters__c parameter : APTS_IntegrationMappingParameters__c.getAll().values()){
            
            if(parameter.APTS_TargetObject__c == 'Apttus__APTS_Agreement__c' && 
                parameter.APTS_ParameterName__c == 'DealType' && agrmt.APTS_Country__c == parameter.APTS_Country__c){
                    
                    sDealTypeForHeader = parameter.APTS_ParameterValue__c;
            }
        }

        
        MSPA.MaxOrdVal= String.valueOf(agrmt.APTS_LP_Max_Order_Amount__c); ////set max order value
        MSPA.MinOrdVal = '0';//min order value will be 0
        MSPA.SalesMan = agrmt.APTS_LP_Sales_Person__r.name;
        MSPA.SalesOffice = agrmt.APTS_Sales_Office__r.PickList_Code__c != null ? agrmt.APTS_Sales_Office__r.PickList_Code__c.left(3) : null;//read from sales office of MSPA - read first 3 chars.
        MSPA.SalesOrganization = agrmt.APTS_LP_Sales_Organization__c;//sales organisation will be ABB always
        MSPA.DistributionChannel = agrmt.APTS_Distribution_Channel__r.APTS_Code__c; 
        Datetime startdate = agrmt.Apttus__Contract_Start_Date__c;//MSPA start date
        Datetime enddate = agrmt.Apttus__Contract_End_Date__c;//MSPA end date
        MSPA.ValidFrom = '/Date('+startdate.getTime()+')/';//convert dates into json format
        MSPA.ValidtO = '/Date('+enddate.getTime()+')/'; 
        MSPA.CustomerGroup = agrmt.APTS_Local_Channel__r.APTS_Code__c;
        MSPA.DealType = sDealTypeForHeader;//agrmt.APTS_LP_MSPA_Type__c;//deal type is "Project" whose code is "2" for spain
        MSPA.DealValue = String.valueOf(agrmt.APTS_Total_Agreement_Value__c.setscale(2));
        MSPA.DealCode = agrmt.APTS_SAP_Reference_No__c;
        MSPA.ResidualAmount = '0';//this field is not needed for spain but it cannot be null, hence passing 0 value
        MSPA.SalesDealItems = agrmtlinestopass;
        
        APTS_ABB_LP_SAP_Tokens.MSPASAPRequestWrapper mspaReq = new APTS_ABB_LP_SAP_Tokens.MSPASAPRequestWrapper();
        mspaReq.globalParams = globalPar;
        mspaReq.createSalesDealRequest = MSPA;
        //mspaReq - is the main object that will be passed to the SAP
        String jsonbody = JSON.serialize(mspaReq);
        jsonbody = jsonbody.replace('Currency1', 'Currency');
        return jsonbody;
    }
}