/*************************************************************
@Name: APTS_SAPPricingIntegrationController
@Author: Ganga Vemula
@CreateDate: 17th sep 2015.
@Description: This class is to get pricing for products from SAP server. 
@UsedBy: Used by a custom button "Get SAP Pricing" on shopping cart
******************************************************************/
    
    public class APTS_SAPPricingIntegrationController {
        
        public string refURL {get; set;}
        //configuration Id
        private string sConfigId;
        //temp object Id
        private string sConfigRequestId;
        private List<Apttus_Config2__LineItem__c> listLineItems;
        public map<string,Apttus_Config2__LineItem__c> mapProductLineitem;
        public Map<String, List<Apttus_Config2__LineItem__c>> mapProductCodeToLineitems;//added by Axay
        private static string FLOW_NAME='LP_Spain';
        private static string STATUS_PENDING='Pending';
        private static string ERROR_EXIST='SERVER_ERROR_EXIST';
        private static string LPSPAIN_CONFIG_SETTING = 'LP-Spain Config Settings';
        
        static final String QUERY_PARAM_CONFIG_REQ_ID ='ConfigRequestId';
        static final String QUERY_PARAM_FLOW ='flow';
        static final String QUERY_PARAM_RECORD_ID ='id';
        static final String ERROR_CODE_HEADER_NAME ='Error Code: ';
        static final String TASK_STATUS_COMPLETED ='Completed';
        static final String TASK_PROPRITY_LOW ='Low';
        static final String BUSINESS_OBJ_TYPE_PROPOSAL ='Proposal';
        static final String BUSINESS_OBJ_TYPE_AGREEMENT ='Agreement';
        static final String CUSTOM_SETTING_HIERARCHY_PRICING_PROP_NAME ='Hierarchy Pricing Properties';
        static final String CUSTOM_SETTING_SAP_PRICING_TOKEN_NAME ='SAP Pricing Tokens';
        static final String SAS_TOKEN_HEADER ='SharedAccessSignature';
        static final String SAS_TOKEN_PARAM_SR ='sr';
        static final String SAS_TOKEN_PARAM_SIG ='sig';
        static final String SAS_TOKEN_PARAM_SE ='se';
        static final String SAS_TOKEN_PARAM_SKN ='skn';
        
        //constructor
        public APTS_SAPPricingIntegrationController(){
            
            //get previous page url
            refURL = ApexPages.currentPage().getHeaders().get(APTS_Constants.HTTP_HEADER_REFERER);
            //get configuration id from url
            sConfigId = ApexPages.currentPage().getParameters().get(QUERY_PARAM_RECORD_ID);
            System.debug('testKushal'+sConfigId);
            //get temp object id from url
            sConfigRequestId = ApexPages.currentPage().getParameters().get(QUERY_PARAM_CONFIG_REQ_ID);
           
        }
        
        /**
        @ Method to call web service of SAP Pricing
        @ Param: pagereference.
        @ User will be redirecting to pricing page after successful SAP pricing call
        **/
         public PageReference init(){
               
            //get config line items
            listLineItems = [SELECT Apttus_Config2__Quantity__c,
            Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__c,
            Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_SAP_Customer_ID__c,
            Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Distribution_Channel__r.APTS_Code__c,
            Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_Distribution_Channel__r.APTS_Code__c,
            Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_LP_Sales_Organization__c,
            Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_LP_Sales_Organization__c,
            Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_LP_Price_Date__c,
            Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Price_Date__c,
            Apttus_Config2__ConfigurationId__r.Apttus_Config2__BusinessObjectType__c,
            Apttus_Config2__ProductId__r.APTS_Hierarchy_Level__c,
            Apttus_Config2__ProductId__r.APTS_LP_Product_Hierarchy__c,
            Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_SAP_Customer_ID__c,
            Apttus_Config2__ProductId__r.APTS_LP_Is_Hierarchy__c,Apttus_Config2__ProductId__r.APTS_Product_ID__c, 
            Apttus_Config2__ConfigurationId__r.Apttus_Config2__AccountId__r.name, Id, 
            Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.Name, Apttus_Config2__ConfigurationId__c, 
            Apttus_Config2__ListPrice__c, Apttus_Config2__LineNumber__c
            FROM Apttus_Config2__LineItem__c
            WHERE Apttus_Config2__ConfigurationId__c = :sConfigId];
            //call web service
            string errormsg = getSapPricing(listLineItems);
            //set pagreference to redirect to pricing page
            PageReference resPage = Page.Apttus_Config2__Pricing;
            resPage.setRedirect(true);
            resPage.getParameters().put(QUERY_PARAM_FLOW,FLOW_NAME);
            //set url parameters
            resPage.getParameters().put(QUERY_PARAM_CONFIG_REQ_ID,sConfigRequestId);
            resPage.getParameters().put(QUERY_PARAM_RECORD_ID,sConfigId);
            
            //set configuration status to pending, so system will call pricing
            Apttus_Config2__ProductConfiguration__c conf = new Apttus_Config2__ProductConfiguration__c();
            conf.Apttus_Config2__IsPricePending__c = true;
            conf.Id=sConfigId;
            system.debug(conf.id+'&&****'+sConfigId);
            
            update conf;
            system.debug('pricing page****');
            
            //show it here if there are any errors exist while getting pricing response from SAP
             if(!string.isEmpty(errormsg)){
               system.debug('entered error**');
               ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, errormsg);
               ApexPages.addMessage(errMsg);
               return null;
               
             }else{ //in case of successful response, redirect to pricing   
             
               return resPage;
               
             }
         
        }    
        
       /*
       @ Method to get sas token
       @ Param: resource url,key name,key
       **/
        public static string getSasToken(string resourceUri, string keyName, string key)
        {   
            //set expiry here
            String expiry = string.valueof(system.now().getTime() /1000);
            //encode resource url and append expiry
            String stringToSign = EncodingUtil.urlEncode(resourceUri, APTS_Constants.ENCODING_UTF_8) + '\n' + expiry;
            //get hmac code and encode it
            String signature = EncodingUtil.base64Encode(crypto.generateMac(APTS_Constants.ENCRYPTION_ALGO_HMACSHA256,blob.valueof(stringtosign),blob.valueof(key)));
            //form the sas key in the format of (SharedAccessSignature sig=<signature-string>&se=<expiry>&skn=<keyName>&sr=<URL-encoded-resourceURI>)
            String sasToken=SAS_TOKEN_HEADER+' '+SAS_TOKEN_PARAM_SR+'='+EncodingUtil.urlEncode(resourceUri, APTS_Constants.ENCODING_UTF_8)+
                            '&'+SAS_TOKEN_PARAM_SIG+'='+EncodingUtil.urlEncode(signature, APTS_Constants.ENCODING_UTF_8)+
                            '&'+SAS_TOKEN_PARAM_SE+'='+expiry+
                            '&'+SAS_TOKEN_PARAM_SKN+'='+keyName;
           
            system.debug('***sas token'+sasToken);
            return sasToken;
        }
    
       /*
       @ Method to place webservice call to SAP
       @ We are forming the json string with line item data and passing in body
       @ Param: config line items
       **/
        public string getSapPricing(list<Apttus_Config2__LineItem__c> Configlines) {
                
             mapProductLineitem = new map<string,Apttus_Config2__LineItem__c>();
             mapProductCodeToLineitems = new Map<String, List<Apttus_Config2__LineItem__c>>();
            //response body
             APIResponseWrapper  sapResponseBody;
             string SAPCustomerId;
             string distributionChannel;
             string salesOrganization;
             //datetime PriceDate = system.today();
             //access token from authentication response
             String access_token;
             //errors while getting pricing from SAP
             string errors='';
             
            //read static values that are neded for authetication from custom settings
            APTS_SAP_Integration_Tokens__c SAPPricingDataset= APTS_SAP_Integration_Tokens__c.getValues(CUSTOM_SETTING_SAP_PRICING_TOKEN_NAME);
            
            //get base address from custom setting
            String baseaddress = SAPPricingDataset.APTS_Base_Address__c;
            //get key name
            string keyname=SAPPricingDataset.APTS_Key_Name__c;
            //get key
            string key=SAPPricingDataset.APTS_Key__c;
            //get Baucode
            string Baucode=SAPPricingDataset.APTS_Bau_Code__c;
            //get response culture
            string ErpResponseCulture=SAPPricingDataset.APTS_ERP_Response_Culture__c;
            //get end point
            string endpoint=SAPPricingDataset.APTS_End_Point__c;
            //get http header key value
            string headerkey=SAPPricingDataset.APTS_Http_Header_Key__c;
            
            
            //read hierarchy product pricing details and form the json body
            APTS_Hierarchy_Pricing_Properties__c HierarchyPricingDataset= APTS_Hierarchy_Pricing_Properties__c.getValues(CUSTOM_SETTING_HIERARCHY_PRICING_PROP_NAME);
            //check if hierarchy pricing is ON
            boolean IsPricingEnabled=HierarchyPricingDataset.APTS_Hierarchy_Pricing_ON__c;
            
            
            //if azure authentication is success, access token will be returned by APTS_GenerateSecureoAuthTokenController 
            if(!APTS_GenerateSecureoAuthTokenController.GetSecureOauthTokenAzure(baseaddress).contains(ERROR_EXIST)){
            
                //get access token here
                access_token = APTS_GenerateSecureoAuthTokenController.GetSecureOauthTokenAzure(baseaddress);
            
            } else {//in case of authentication failure, return an error message to show on UI
                
                //get errors(if any exist) here
                errors=APTS_GenerateSecureoAuthTokenController.GetSecureOauthTokenAzure(baseaddress).replace(ERROR_EXIST, ''); 
                return errors;
                
            }
            
            //get sas token to send in request body
            string sasToken = getSasToken(baseaddress, keyname, key);
            system.debug ('#### sasToken: ' + sasToken);
            
            //get customer Id and price date from quote/MSPA
            if(!Configlines.isEmpty() && !string.isEmpty(Configlines[0].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c)){   
                
                if(Configlines[0].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Distribution_Channel__c != null){
                    //get distribution channel
                    distributionChannel=Configlines[0].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Distribution_Channel__r.APTS_Code__c;
                }
                //get sales organization
                salesOrganization=Configlines[0].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_LP_Sales_Organization__c;
                
                if(!String.isEmpty(Configlines[0].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_SAP_Customer_ID__c)){
                    //get SAP Customer Id from quote
                    SAPCustomerId=Configlines[0].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_SAP_Customer_ID__c;
                }else{
                    // get dummy SAP ID
                    SAPCustomerId = APTS_Capture_LSO_Input_Config_Settings__c.getValues(LPSPAIN_CONFIG_SETTING).APTS_Default_SAP_Customer_ID__c;
                }
                //PriceDate=Configlines[0].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Price_Date__c;
            
            }else  if(!Configlines.isEmpty() && !string.isEmpty(Configlines[0].Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__c)){
                
                //get SAP Customer Id from quote
                SAPCustomerId=Configlines[0].Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_SAP_Customer_ID__c;
                
                //get distribution channel from MSPA
                if(Configlines[0].Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_Distribution_Channel__c != null){
                    distributionChannel=Configlines[0].Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_Distribution_Channel__r.APTS_Code__c;
                }
                //get sales organization
                salesOrganization=Configlines[0].Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_LP_Sales_Organization__c;
                //PriceDate=Configlines[0].Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_LP_Price_Date__c;
            }
            
            
            //wrapper to form json body
            APIRequestWrapper reqBody = new APIRequestWrapper();
            cls_globalParams globalPar = new cls_globalParams();
            //set global parameters that are needed for authentication
            globalPar.BauCode = Baucode;
            //set customer Id
            globalPar.CustomerCode = SAPCustomerId;//'0080003494'
            globalPar.ErpResponseCulture =ErpResponseCulture;
            //set authetication token
            globalPar.AuthToken = access_token;       
            
            //assign global parameters to request body
            reqBody.globalParams = globalPar;
            
           
            
        
                //form json string with line item data
                cls_productListRequest prodListrequestcls = new cls_productListRequest();
        
                List<cls_Products> prodListscls = new List<cls_Products>();
                
                
                //associate product date to SAP variables
                for(Apttus_Config2__LineItem__c line : configlines){
                       
                    mapProductLineitem.put(line.Apttus_Config2__ProductId__r.APTS_Product_ID__c,line);
                    /*
                    Added by  AXAY to handle bulk product upload
                    */
                    if(mapProductCodeToLineitems.containsKey(line.Apttus_Config2__ProductId__r.APTS_Product_ID__c)){
                        List<Apttus_Config2__LineItem__c> temp = mapProductCodeToLineitems.get(line.Apttus_Config2__ProductId__r.APTS_Product_ID__c);
                        temp.add(line);
                        mapProductCodeToLineitems.put(line.Apttus_Config2__ProductId__r.APTS_Product_ID__c, temp);
                    }else{
                        mapProductCodeToLineitems.put(line.Apttus_Config2__ProductId__r.APTS_Product_ID__c, new List<Apttus_Config2__LineItem__c>{line});
                    }
                    
                    
                    //control hierarchy products pricing from custom setting values, because in R3 we dont have any pricing for hierarchies, however we may get prices in future, so controlling that from custom setting value
                    //if IsPricingEnabled =false, skipping hierachy products being sent to SAP.
                    if(IsPricingEnabled  && line.Apttus_Config2__ProductId__r.APTS_LP_Is_Hierarchy__c && line.Apttus_Config2__ProductId__r.APTS_Hierarchy_Level__c==3){
                           
                        //pass hierarchy code for hierarchy products
                        cls_Products productdetails= new cls_Products();
                        productdetails.Hierarchy=line.Apttus_Config2__ProductId__r.APTS_LP_Product_Hierarchy__c;
                        productdetails.Hierarchyname=line.Apttus_Config2__ProductId__r.Name;
                        productdetails.Quantity = line.Apttus_Config2__Quantity__c.setscale(2);
                        prodListscls.add(productdetails);
                     
                     }else if(!line.Apttus_Config2__ProductId__r.APTS_LP_Is_Hierarchy__c){
                       
                        //pass product Id for normal products
                        cls_Products productdetails= new cls_Products();
                        productdetails.Code =line.Apttus_Config2__ProductId__r.APTS_Product_ID__c;
                        //prod1.PriceDate='/Date('+PriceDate.getTime()+')/';
                        //quantity
                        productdetails.Quantity = line.Apttus_Config2__Quantity__c.setscale(2); 
                        prodListscls.add(productdetails);
                     
                     }
                    
                        
               }
        
                prodListrequestcls.Products = prodListscls;
                prodListrequestcls.SalesDistribution=distributionChannel;
                prodListrequestcls.salesOrganization=salesOrganization;
                //form json body
                reqBody.productListRequest = prodListrequestcls;
                
               
               // reqBody.QuotationPriceListSearch=rootSearch;
                
                string Jsonbody = JSON.serialize(reqBody);
    
                //create post request here
                HttpRequest req = new HttpRequest();
                HttpResponse res = new HttpResponse();
                Http http = new Http();
                //set end point    
                req.setEndpoint(endpoint);
                //set method to 'POST'
                req.setMethod(APTS_Constants.HTTP_METHOD_POST);
                //pass authentication token in header
                req.setHeader(headerkey,sasToken);
                req.setHeader(APTS_Constants.HTTP_HEADER_X_HTTP_METHOD,APTS_Constants.HTTP_METHOD_POST);
                req.setHeader(APTS_Constants.HTTP_HEADER_CONTENT_TYPE, APTS_Constants.HTTP_CONTENT_TYPE_JSON);
                //pass the required data as JSON in http body
                req.setBody(Jsonbody);
                //set time out to 2 minutes
                req.setTimeout(120000);
                        
                System.debug('#### Request Body: ' + req.getBody());
                System.debug('#### Request: ' + String.valueOf(req));
                                                
                try {
                       //get the reponse here
                        res = http.send(req);
                        system.debug('responsebody****'+res.getbody());
                       
                        //passing the response body to deserialize, checking if the reponse is not success and skipping deserialization. 
                        if(res.getStatusCode() >= 200 && res.getStatusCode() < 300){
                            
                            //de serialize response here
                            sapResponseBody = (APIResponseWrapper)JSON.deserialize(res.getbody(), APIResponseWrapper.class);
                            //method to apply the response data to line items
                            getPricing(sapResponseBody);
                            
                        } else {//through an error message on failing to get response from SAP
                           
                           //get proper error message on failue of getting pricing response from SAP
                          /* errors='HTTP callout failed:'
                                    + '\nstatusCode=' + res.getStatusCode()
                                    + '\nstatus=' + res.getStatus();*/
                                    
                           errors= Label.APTS_Pricing_Server_Error;
                                    
                          /* if(res.getStatusCode() == 401 || res.getStatusCode() == 500 || res.getStatusCode() == 404){
                               return 'SAS token is refreshed and the request is retried.';//todo: do we need to retried again?
                           }*/
                           
                            return errors;
                             
                        }
                        
                        System.debug('#### Response Body: ' + res.getBody());
                        System.debug('#### Response Status Code: ' + res.getStatusCode());
                        System.debug('#### Response Status: ' + res.getStatus());
                        
                        String whoId;
                        if(Configlines[0].Apttus_Config2__ConfigurationId__r.Apttus_Config2__BusinessObjectType__c == BUSINESS_OBJ_TYPE_AGREEMENT){
                            whoId = Configlines[0].Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__c;
                        }else if(Configlines[0].Apttus_Config2__ConfigurationId__r.Apttus_Config2__BusinessObjectType__c == BUSINESS_OBJ_TYPE_PROPOSAL){
                            whoId = Configlines[0].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c;
                        }
                        
                        //Activity History
                        Task sapReq = new Task();
                        sapReq.ActivityDate = System.today();
                        //sapReq.IsClosed = true;
                        sapReq.OwnerId = UserInfo.getUserId();
                        sapReq.Priority = TASK_PROPRITY_LOW;
                        sapReq.Status = TASK_STATUS_COMPLETED;
                        sapReq.Subject = Label.APTS_PRICING_INFO_SENT_TO_SAP;
                        sapReq.Description = req.getBody().length() < 32000 ? req.getBody() : req.getBody().left(29999);//'Pricing request for products sent to SAP';
                        sapReq.WhatId = whoId;//Configlines[0].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c;
                        
                        Task sapRes = new Task();
                        sapRes.ActivityDate = System.today();
                        //sapRes.IsClosed = true;
                        sapRes.OwnerId = UserInfo.getUserId();
                        sapRes.Priority = TASK_PROPRITY_LOW;
                        sapRes.Status = TASK_STATUS_COMPLETED;
                        sapRes.Subject = Label.APTS_PRICING_INFO_RECEIVED_FROM_SAP;
                        sapRes.Description = res.getBody().length() < 32000 ? res.getBody() : res.getBody().left(29999);// : 'Error in receiving pricing information from SAP';
                        sapRes.WhatId = whoId;//Configlines[0].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c;
                        insert new List<Task>{sapReq, sapRes};
                
                        system.debug('history***'+sapRes.Id);
                   //catch list of errors from response body(if any exist) and display on UI
                    if(sapResponseBody.errors != null){
                          /*
                          if(res.getStatusCode() == 200 && sapResponseBody.errors != null){
                              return 'The product IDs and distribution channel combination is invalid, OR invalid product ID has been sent.';
                          }*/
                          
                          for(error err : sapResponseBody.errors){
                              errors += ERROR_CODE_HEADER_NAME + err.code + ' : ' +err.Message+'\n';
                              
                          }
                          
                          return errors;
                      
                    } else{
                    
                          return null;
                      
                    }
                
                
               }catch(System.CalloutException ex) {
                    System.debug('#### Callout error: '+ ex.getMessage());
                    Errors = ex.getMessage();
                    return Errors;
               }catch (Exception ex) {
                    System.debug('#### General Callout error: '+ ex.getMessage());
                    Errors = ex.getMessage();
                    return Errors;
               }
                
                    return null;
        }   
        
        /*
        @ Method to catch the response from SAP and apply to line items in salesforce
        @ Param: SAP response wrapper
        */
        public void getPricing(APIResponseWrapper response ){
         
          list<Apttus_Config2__LineItem__c > lineslist=new list<Apttus_Config2__LineItem__c >();
          set<id> LineIds=new set<Id>();
          
          //loop through each product in response
          for(Product prod : response.Products){
               
               //check price!=0 condition because SAP will return 0 prices for all lines if there is some error exist for any of those products
               if( mapProductLineitem.get(prod.Code)!= null && prod.price !=0){
                   
                    //assign the reponse data to line items
                    Apttus_Config2__LineItem__c linetoupdate= mapProductLineitem.get(prod.Code);
                  
                    //update list price of line item
                    linetoupdate.Apttus_Config2__ListPrice__c = prod.price1;
                    //update base price
                    linetoupdate.Apttus_Config2__BasePrice__c = prod.price1;
                    system.debug('***baseprice'+prod.price1);
                    //set status to pending to force system to reprice
                    linetoupdate.Apttus_Config2__PricingStatus__c =STATUS_PENDING;
                    //set base price override
                    linetoupdate.Apttus_Config2__BasePriceOverride__c =prod.price1;
                    linetoupdate.APTS_LP_Standard_Net__c=prod.price;
                    //Start: Added By Kruti Shah (Defect# 620)
                    linetoupdate.APTS_LP_Unit_Of_Measure__c=prod.PricingUom;
                    linetoupdate.APTS_LP_Unit_Of_Price__c=prod.PricingUnit;
                    //mark the line once it got priced from SAP
                    linetoupdate.APTS_Is_Line_Priced__c=true;
                    
                   //End: Added By Kruti shah (Defect# 620)
                    system.debug('pricinguom****'+prod.PricingUom+':::'+prod.UnitOfMeasure);
                    system.debug('prod.price1: '+prod.price1+' --> prod.price: '+prod.price+' --> is Hierarchy?: '+linetoupdate.Apttus_Config2__ProductId__r.APTS_LP_Is_Hierarchy__c);
                    /*
                    if(linetoupdate.Apttus_Config2__ProductId__r.APTS_LP_Is_Hierarchy__c){
                     linetoupdate.APTS_LP_Standard_Discount__c = prod.Percentage1;
                    }*/
                    linetoupdate.APTS_LP_Standard_Discount__c = (prod.price1 != 0 && prod.price1 != null ) ? ((prod.price1 - prod.price) * 100) / prod.price1 : 0;
                    
                    //set custom pricing to true to stop OOB pricing fro PLI
                    linetoupdate.Apttus_Config2__IsCustomPricing__c=true;
                    
                    //filter duplicate lines(if exist on cart)
                    if(LineIds.add(linetoupdate.Id)){
                        lineslist.add(linetoupdate);
                    }
              }
              
              /*
              *Added by: AXAY - 
              */
              if(mapProductCodeToLineitems.get(prod.Code).size() > 0 && prod.price !=0){
                    
                    for(Apttus_Config2__LineItem__c linetoupdate : mapProductCodeToLineitems.get(prod.Code)){
                        
                        //update list price of line item
                        linetoupdate.Apttus_Config2__ListPrice__c = prod.price1;
                        //update base price
                        linetoupdate.Apttus_Config2__BasePrice__c = prod.price1;
                        
                        //set status to pending to force system to reprice
                        linetoupdate.Apttus_Config2__PricingStatus__c =STATUS_PENDING;
                        
                        //set base price override
                        linetoupdate.Apttus_Config2__BasePriceOverride__c =prod.price1;
                        linetoupdate.APTS_LP_Standard_Net__c=prod.price;
                       
                        linetoupdate.APTS_LP_Unit_Of_Measure__c=prod.PricingUom;
                        linetoupdate.APTS_LP_Unit_Of_Price__c=prod.PricingUnit;
                        //mark the line once it got priced from SAP
                        linetoupdate.APTS_Is_Line_Priced__c=true;
                        linetoupdate.APTS_LP_Standard_Discount__c = (prod.price1 != 0 && prod.price1 != null ) ? ((prod.price1 - prod.price) * 100) / prod.price1 : 0;
                        
                        //set custom pricing to true to stop OOB pricing fro PLI
                        linetoupdate.Apttus_Config2__IsCustomPricing__c=true;
                        
                        //filter duplicate lines(if exist on cart)
                        if(LineIds.add(linetoupdate.Id)){
                            lineslist.add(linetoupdate);
                        }
                    }
              }
              
          } 
       
                 if(lineslist.size()>0){
                       update lineslist;
                 }
                 
                 for(Apttus_Config2__LineItem__c line : lineslist){
                  System.debug('-> '+line.Apttus_Config2__IsCustomPricing__c+' -> pricing status: '+line.Apttus_Config2__PricingStatus__c+'---'+line.Apttus_Config2__BasePriceOverride__c );   
                 }
          
          
       }  
       
       /*
       @Method to get back to cart during error scenarion
       @Param: None
       */
       public pagereference backToCart(){
           //set pricing page
            PageReference cartpage = Page.Apttus_Config2__Pricing;
            cartpage.setRedirect(true);
            cartpage.getParameters().put(QUERY_PARAM_FLOW,FLOW_NAME);
            //set url parameters
            cartPage.getParameters().put(QUERY_PARAM_CONFIG_REQ_ID,sConfigRequestId);
            cartPage.getParameters().put(QUERY_PARAM_RECORD_ID,sConfigId);
            return cartPage;
       } 
       
         
       
       
       //Inner class to pass global parameters as json for authentication
        public class APIRequestWrapper{
            public cls_globalParams globalParams;
            public cls_productListRequest productListRequest;
            
        }
            //inner class to form global parameters
            @TestVisible 
            class cls_globalParams {
            public String BauCode;  
            public String CustomerCode; 
            public String ErpResponseCulture;   
            public String AuthToken;    //'+access_token+'
            public string PriceDate;
            
        }
        
      
        
        class cls_productListRequest {
            public cls_Products[] Products;
            public string SalesDistribution;
            public string SalesOrganization;
            public string PriceDate;
        }
        //inner class to pass product data to SAP variables from salesforce
        class cls_Products {
            
            public String Code; 
            public decimal Quantity;    
            public string Hierarchy;
            public string HierarchyName;
            public string PriceDate;
            //public string SalesOrganization;
            //public string DistributionChannel;
            //public string Division;
           
        }

    
        public class ExtraInfo
        {
            public string Code { get; set; }
            public string Message { get; set; }
        }
       
        //error info of response
        public class Error
        {
            public string Code { get; set; }
            public List<ExtraInfo> ExtraInfos { get; set; }
            public string Message { get; set; }
            //public object StackTrace { get; set; }
        }
       
       //inner class to hpld response of listed products
        public class Product
        {
            public string ABBCode { get; set; }
            public string Code { get; set; }
            // public decimal Currency { get; set; }
            public integer CurrencyPurchaseOrder { get; set; }
            //SAP customer Id
            public string CustomerCode { get; set; }
            public integer DeliveryTime { get; set; }
            public string Description { get; set; }
            //public object DummyFunction { get; set; }
            public string EANCode { get; set; }
            public string Hierarchy { get; set; }
            public string HierarchyString { get; set; }
            public integer ItemNumber { get; set; }
            public integer MinQuantity { get; set; }
            public string OldCode { get; set; }
            public string PKWiUCode { get; set; }
            public decimal Parent { get; set; }
            public decimal Percentage1 { get; set; }
            public decimal Percentage10 { get; set; }
            public decimal Percentage2 { get; set; }
            public decimal Percentage3 { get; set; }
            public decimal Percentage4 { get; set; }
            public decimal Percentage5 { get; set; }
            public decimal Percentage6 { get; set; }
            public decimal Percentage7 { get; set; }
            public decimal Percentage8 { get; set; }
            public decimal Percentage9 { get; set; }
            //standard net price
            public decimal Price { get; set; }
            //Base price
            public decimal Price1 { get; set; }
            public decimal Price10 { get; set; }
            public decimal Price2 { get; set; }
            public decimal Price3 { get; set; }
            public decimal Price4 { get; set; }
            public decimal Price5 { get; set; }
            public decimal Price6 { get; set; }
            public decimal Price7 { get; set; }
            public decimal Price8 { get; set; }
            public decimal Price9 { get; set; }
            public string PriceListCode { get; set; }
            public integer PricePurchaseOrder { get; set; }
            //public object PriceUnit { get; set; }
            public string PricingUnit { get; set; }
            public string PricingUom { get; set; }
            //quantity
            public decimal Quantity { get; set; }
            //public object QuotationCondition { get; set; }
            //public List<object> QuotationConditionFilteredList { get; set; }
            //public List<object> QuotationConditionList { get; set; }
           // public object Reserve1 { get; set; }
           /* public object Reserve10 { get; set; }
            public object Reserve2 { get; set; }
            public object Reserve3 { get; set; }
            public object Reserve4 { get; set; }
            public object Reserve5 { get; set; }
            public object Reserve6 { get; set; }
            public object Reserve7 { get; set; }
            public object Reserve8 { get; set; }
            public object Reserve9 { get; set; }*/
            //public object SalesUnit { get; set; }
            public string SpaNumber { get; set; }
           //public object Stock { get; set; }
            public string UnitOfMeasure { get; set; }
            public integer UnitTransferPrice { get; set; }
            //public object Variants { get; set; }
        }
       //response wrapper
        public class APIResponseWrapper
        {
            public List<Error> Errors { get; set; }
            //public List<object> Incomplete { get; set; }
            public object Messages { get; set; }
            public List<Product> Products { get; set; }
            public object SpaNumber { get; set; }
        }


}