/*************************************************************
@Name: APTS_SAPConnectorForMSPACreation
@Author: Ganga Vemula
@CreateDate: 17th sep 2015.
@Description: This class is to create MSPA in SAP also the same class is being used to block MSPA in SAP.
@UsedBy: 
******************************************************************/
    
    public class APTS_SAPConnectorForMSPACreation{
        
        //current agreement
        private Apttus__APTS_Agreement__c agreement;
        //status to set to failed
        private static string STATUS_FAILED='Approved but failed to load on SAP';
        //status to approved
        private static string STATUS_APPROVED='Approved';
        //set currency
        private static string CURRENCY_EUR='EUR';
        //status blocked
        private static string STATUS_BLOCKED='Blocked';  
        //identify "block" action
        public static string IsBlock;
           
         //Constructor
        public APTS_SAPConnectorforMSPACreation(ApexPages.StandardController stdController){ 
            this.agreement= (Apttus__APTS_Agreement__c)stdController.getRecord();
        }
        
        /*
        @This method will be called through button on MSPA layout
        @param: pagereference 
        */
        public pagereference CreateMSPAviaButton() {
            Set<Id> agrmtIds=new set<Id>();
           
            //get block param from url if the action is "block" or skip if the action in MSPA creation  
            if(Apexpages.currentpage().getparameters().get('BlockParam') != null){
               IsBlock=Apexpages.currentpage().getparameters().get('BlockParam');
            }
            //this method will be called when user click on create MSPA button on layout, so set<agrmtIds> will always holds single value 
            //since the method "CreateOrBlockMSPA" expects set<Id>, added the current agreement id to set and passed it to method.
            agrmtIds.add(agreement.Id);
            //call method to create MSPA 
            CreateOrBlockMSPA(agrmtIds,IsBlock);
            //once MSPA creation is done, redirect back to MSPA 
            return (new pagereference('/'+agreement.Id));
        } 
        
        
         /*
        @param: set of agreement Ids, string
        @This is the common method is to handle both MSPA Creation and blocking
        @pass BlockParam as 'True' for blocking action, pass BlockParam as null for MSPA creation(from trigger)
        */
        public static void CreateOrBlockMSPA(set<Id> agrmntIds,string BlockParam){
        
             map<id,list<Apttus__AgreementLineItem__c>> Agreementlinesmap=new map<id,list<Apttus__AgreementLineItem__c>>();
            list<cls_SalesDealItem> agrmtlinestopass=new list<cls_SalesDealItem>();
            list<Apttus__APTS_Agreement__c> agrmtstoupdate=new list<Apttus__APTS_Agreement__c>();
            
                //read static values from custom settings
                APTS_SAP_Integration_Tokens__c MSPACreationDataset= APTS_SAP_Integration_Tokens__c.getValues('SAP MSPA Creation Tokens');
                
                //get base address from custom setting
                String baseaddress = MSPACreationDataset.APTS_Base_Address__c;
                //get key name
                string keyname=MSPACreationDataset.APTS_Key_Name__c;
                //get key
                string key=MSPACreationDataset.APTS_Key__c;
                //get Baucode
                string Baucode=MSPACreationDataset.APTS_Bau_Code__c;
                //get response culture
                string ErpResponseCulture=MSPACreationDataset.APTS_ERP_Response_Culture__c;
                //get end point
                string endpoint=MSPACreationDataset.APTS_End_Point__c;
                //get http header key value
                string headerkey=MSPACreationDataset.APTS_Http_Header_Key__c;
                
            
            //get oAuth token
            String access_token = APTS_GenerateSecureoAuthTokenController.GetSecureOauthTokenAzure(baseaddress);
            //get sas token
            string sasToken = APTS_SAPPricingIntegrationController.GetSasToken(baseaddress, keyname, key);
            system.debug ('#### sasToken: ' + sasToken);
            
            //parent wrapper to form request body
            MSPARequestWrapper reqBody = new MSPARequestWrapper();
                      
            
           
            //get current MSPA        
            list<Apttus__APTS_Agreement__c> agreementlist=[select id,name,APTS_SAP_Customer_ID__c,APTS_SAP_Reference_No__c,Apttus__Status__c,APTS_Total_Agreement_Value__c,APTS_LP_MSPA_Type__c,APTS_LP_Local_Channel__c,APTS_LP_Max_Order_Amount__c,Apttus__Contract_End_Date__c,APTS_LP_Sales_Person__r.Name,Apttus__Contract_Start_Date__c,APTS_LP_Sales_Office__c from Apttus__APTS_Agreement__c where Id IN :agrmntIds];
           //get agreement line items to form json string to pass to SAP system.
            list<Apttus__AgreementLineItem__c> agrmtlines=[select id
                                                                  ,name
                                                                  ,currencyISOcode
                                                                  ,Apttus_CMConfig__BasePrice__c
                                                                  ,Apttus__NetPrice__c
                                                                  ,Apttus_CMConfig__LineNumber__c
                                                                  ,Apttus__Quantity__c
                                                                  ,APTS_Discount_Type__c
                                                                  ,APTS_LP_Unit_Of_Measure__c
                                                                  ,Apttus__AgreementId__c
                                                                  ,APTS_Net_Price_Override__c
                                                                  ,APTS_Discount_Percentage__c
                                                                  ,Apttus__AgreementId__r.APTS_SAP_Reference_No__c
                                                                  ,Apttus__ProductId__r.APTS_LP_Is_Hierarchy__c
                                                                  ,Apttus__ProductId__r.APTS_LP_Product_Hierarchy__c
                                                                  from Apttus__AgreementLineItem__c
                                                                  where Apttus__AgreementId__c IN :agrmntIds];
                                                                  
            //store agreements and their list of line items in a map                                                      
            for(Apttus__AgreementLineItem__c lineitem : agrmtlines){
              
             if(!Agreementlinesmap.containsKey(lineitem.Apttus__AgreementId__c)){
                         Agreementlinesmap.put(lineitem.Apttus__AgreementId__c, new List<Apttus__AgreementLineItem__c>());
             }
              Agreementlinesmap.get(lineitem.Apttus__AgreementId__c).add(lineitem); 
             }     
               
           
           for(Apttus__APTS_Agreement__c agrmt : agreementlist){
               
            cls_globalParams globalPar = new cls_globalParams();
            //assign global parameters to pass in json string
            globalPar.BauCode = Baucode;
            globalPar.Currency1= CURRENCY_EUR;
            //set customer Id
            globalPar.CustomerCode=agrmt.APTS_SAP_Customer_ID__c;// '0010009006';
            //set access token for autherization
            globalPar.AuthToken = access_token;
            reqBody.globalParams = globalPar;
            
             list<Apttus__AgreementLineItem__c> lineitemlist=Agreementlinesmap.get(agrmt.Id);
             if(Agreementlinesmap.get(agrmt.Id) != null){    
                //create  list of agreement line items to pass in json string to SAP                                                      
                for(Apttus__AgreementLineItem__c ali : lineitemlist){
                    //assign the MSPA line item field to JSON field values to be passesd to SAP
                    cls_SalesDealItem agrmtlineitem=new cls_SalesDealItem ();
                    agrmtlineitem.ItemNumber=ali.Apttus_CMConfig__LineNumber__c;
                    agrmtlineitem.DealCode=ali.Apttus__AgreementId__r.APTS_SAP_Reference_No__c;
                    //setting default value for following fields which are not required for spain
                    //since SAP expects some value for these fields we are sending default values as per json request
                    //Scenario: MSPA line items were not created in SAP due to ignoring this data, hence populating all of these values to some defaults
                    agrmtlineitem.OrderQty=0;
                    agrmtlineitem.OrderVal=0;
                    agrmtlineitem.PricingUnit='0';
                    agrmtlineitem.MinOrdVal='0';
                    agrmtlineitem.MinOrdQty='0';
                    agrmtlineitem.MaxOrdVal=0;
                    agrmtlineitem.MaxOrdQty='0';
                    agrmtlineitem.Maxconval='0';
                    agrmtlineitem.ConditionPricingUnit='0';
                    //end
                    
                    //send DealType="S" for substitute discount, "N" for net price discount and "A" for Additional discount
                    //send Deal Value=Discount% for Substiture Discount, Net Price Override for Net Price Discount
                    if(ali.APTS_Discount_Type__c=='Substitute Discount'){
                        agrmtlineitem.DealType='S';
                         agrmtlineitem.DealValue=ali.APTS_Discount_Percentage__c;
                    }else if(ali.APTS_Discount_Type__c=='Net Price Discount'){
                        agrmtlineitem.DealType='N';
                        agrmtlineitem.DealValue=ali.APTS_Net_Price_Override__c;
                    }else if(ali.APTS_Discount_Type__c=='Additional Discount'){
                        agrmtlineitem.DealType='A';
                        agrmtlineitem.DealValue=ali.APTS_Discount_Percentage__c;
                    }
                    
                    //sales organisation will be ABB always
                    agrmtlineitem.SalesOrganization='ABB';
                    //set quantity
                    agrmtlineitem.ScaleQuantity=ali.Apttus__Quantity__c;
                    agrmtlineitem.DealCurrency=ali.currencyISOcode;
                    //Since deal value is fixed amount, passing its value as 'B'
                    agrmtlineitem.DealCalculationType='B';
                    if(ali.Apttus__ProductId__r.APTS_LP_Is_Hierarchy__c){
                        agrmtlineitem.ProductHierarchy=ali.Apttus__ProductId__r.APTS_LP_Product_Hierarchy__c;
                    }
                    agrmtlinestopass.add(agrmtlineitem);
                }
             }
                //agreement line items data to pass as json body
                cls_SalesDealItems agrmtlineitems=new cls_SalesDealItems();
                agrmtlineitems.SalesDealItem=agrmtlinestopass;
                
                //pass MSPA values from salesforce to SAP      
                cls_createSalesDealRequest MSPA=new cls_createSalesDealRequest();
                if(BlockParam != null && BlockParam=='True'){
                    //for MSPA blocking, block=true
                    MSPA.Block=true;
                    system.debug('blocked status***'+BlockParam);
                }else{
                    //for MSPA creation block=false  
                    MSPA.Block=false;
                }
                //set max order value
                MSPA.MaxOrdVal= agrmt.APTS_LP_Max_Order_Amount__c; 
                //min order value will be 0
                MSPA.MinOrdVal=0;
                MSPA.SalesMan=agrmt.APTS_LP_Sales_Person__r.name;
                MSPA.SalesOffice=agrmt.APTS_LP_Sales_Office__c;
                //sales organisation will be ABB always
                MSPA.SalesOrganization='ABB';
                //MSPA start date
                Datetime startdate =agrmt.Apttus__Contract_Start_Date__c;
                //MSPA end date
                Datetime enddate =agrmt.Apttus__Contract_Start_Date__c;
                //convert dates into json format
                MSPA.ValidFrom='/Date('+startdate.getTime()+')/';
                MSPA.ValidtO='/Date('+enddate.getTime()+')/'; 
                
                if(BlockParam=='True'){
                    //action will be 'B' for blocking of MSPA
                    MSPA.Action='B';
                    system.debug('blocked***'+BlockParam);
                }else{
                    //action will be 'I' for insertion of MSPA
                    MSPA.Action='I';
                }
                
                MSPA.CustomerGroup=agrmt.APTS_LP_Local_Channel__c;
                //deal type is "Project" whose code is "2" for spain
                MSPA.DealType='2';//agrmt.APTS_LP_MSPA_Type__c;
                MSPA.DealValue=agrmt.APTS_Total_Agreement_Value__c.setscale(2);
                MSPA.DealCode=agrmt.APTS_SAP_Reference_No__c;
                //this field is not needed for spain but it cannot be null, hence passing 0 value
                MSPA.ResidualAmount=0;
                MSPA.SalesDealItems=agrmtlineitems;
                
                reqBody.createSalesDealRequest=MSPA;
                //serialize in to JSON
                string Jsonbody=JSON.serialize(reqBody);
                
                System.debug('#### Jsonbody ' + Jsonbody);
                
                //create http request to connect to SAP
                HttpRequest req = new HttpRequest();
                HttpResponse res = new HttpResponse();
                Http http = new Http();
                
                //set end point here    
                req.setEndpoint(endpoint);
                req.setMethod('POST');
                //pass sas token for authentication
                req.setHeader(headerkey,sasToken);
                req.setHeader('X-HTTP-Method','POST');
                req.setHeader('Content-Type', 'application/json');
                //pass json body with agreement and agreement line items
                req.setBody(Jsonbody);
                System.debug('#### Request Body: ' + req.getBody());
                System.debug('#### Request: ' + String.valueOf(req));
                                                
                try {
                    //here is the response from SAP
                    res = http.send(req);
                    System.debug('#### response Body: ' + res.getBody());
                    //check if blocking is success and update the status
                    if(res.getStatusCode() >= 200 && res.getStatusCode() < 300 && BlockParam=='True'){
                       //update status to blocked
                        agrmt.Apttus__Status__c=STATUS_BLOCKED;
                        agrmt.APTS_LP_Blocked__c=true;
                        agrmtstoupdate.add(agrmt);
                    } else if(res.getStatusCode() >= 300 && (BlockParam=='' || BlockParam==null)){//check if MSPA creation is not success and update status to failed
                        //update MSPA status if MSPA creation failed in SAP
                        agrmt.Apttus__Status__c=STATUS_FAILED;
                        agrmtstoupdate.add(agrmt);
                        System.debug('#### response Body in if: ' + res.getBody());
                    }else if(res.getStatusCode() >= 200 && res.getStatusCode() < 300 && (BlockParam=='' || BlockParam==null)){//check if MSPA creation is succeo approvedss and update the status t
                        agrmt.Apttus__Status__c=STATUS_APPROVED;
                        agrmtstoupdate.add(agrmt);
                    }                
                    
                    
                   
                    
              }catch(System.CalloutException ex) {
                System.debug('#### Callout error: '+ ex.getMessage());
            }
            catch (Exception ex) {
                System.debug('#### General Callout error: '+ ex.getMessage());
            } 
            
         }
         //reset static flag to stop recursiveness
          APTS_ProcessorControl.inFutureContext = true;
          
          if(!agrmtstoupdate.isEmpty()){
             update agrmtstoupdate;
          }
      }
        
        
        /*
        @This method will be called from trigger as async call
        @param: set of agreement Ids, string
        @This method is to handle both MSPA Creation and blocking
        @pass BlockParam as 'True' for blocking action, pass BlockParam as null for MSPA creation(from trigger)
        */
        @Future(callout=true) 
        public static void CreateMSPA(set<Id> agrmntIds,string BlockParam){
            //call the method to create MSPA 
            //CreateOrBlockMSPA(agrmntIds,BlockParam);
           List<Id> agrmnt = new List<Id>(agrmntIds);
           APTS_ABB_SAPIntegrationServiceBaseImpl integrationHandler = new APTS_ABB_SAPIntegrationServiceBaseImpl();
           Boolean isSuccess = integrationHandler.invoke(agrmnt[0], BlockParam);
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
                thwartedAgreement.APTS_Block_Parameter__c = BlockParam;
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
     
     //following inner classes are created from provide json string   
        //wrapper class to construct JSON body for agreement and agreement line items
        public class MSPARequestWrapper{
           public cls_globalParams globalParams;
           public cls_createSalesDealRequest createSalesDealRequest;
        }
        
        //wrapper to set global parameters for authentication
        class cls_globalParams {
            public String BauCode;  
            public string Currency1; 
            public String CustomerCode; 
            public string AuthToken;
        }
        
        //wrapper to set MSPA field from salesforce to SAP
        class cls_createSalesDealRequest {
            //For blocking Action="B", for insert, "I", for read "R", for update "U"
            public String Action; 
            //block=true for blocking else it will be false  
            public boolean Block;    
            //local channel
            public String CustomerGroup;    
            public String DealCode; 
            //MSPA type
            public String DealType;
            //total agreement value
            public decimal DealValue;  
            //maximum order value  
            public decimal MaxOrdVal;  
            //minimum order value  
            public decimal MinOrdVal;    
            //residual amount is not needed for spain
            public decimal ResidualAmount;   
            public cls_SalesDealItems SalesDealItems;
            public String SalesMan; 
            public String SalesOffice;  
            public String SalesOrganization;  
            //start date of MSPA  
            public string ValidFrom;   
            //End date of MSPA
            public string ValidTo;  ///Date(1391122800000)/
        }
        class cls_SalesDealItems {
            public cls_SalesDealItem[] SalesDealItem;
        }
        //wrapper to set MSPA line item field values
        class cls_SalesDealItem {
            public String ConditionPricingUnit; 
            public String DealCalculationType;  
            public String DealCode;
            public String DealCurrency; 
            public String DealType; 
            public decimal DealValue;  
            //line number  
            public decimal ItemNumber;   
            public String MaxOrdQty;    
            public decimal MaxOrdVal;    
            public String Maxconval;    
            public String MinOrdQty;    
            public String MinOrdVal;    
            public decimal OrderQty; 
            public decimal OrderVal; 
            //price unit
            public String PricingUnit;  
            public String ProductHierarchy; 
            //sales organization will be ABB 
            public String SalesOrganization;  
            //quantity of line item  
            public decimal ScaleQuantity;    
        }
        
    
      
        
  }