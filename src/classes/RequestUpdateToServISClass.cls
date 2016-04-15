/**
@Author Rajesh K
@name RequestUpdateToServISClass
@CreateDate 21-Jan-2015
@Version 1.0
**/
global without sharing class RequestUpdateToServISClass
{
    /*  Description of the method. 
    *  @name requestUpdatetoServis
    *  @Description - Request update to ServIS from SFDC.
    *  @return String
    */
    webservice static String requestUpdatetoServis(Id caseid) 
    {         
        //Send Additional product values into ServeIS here        
        String servisDivision;
        String servisBU;
        String servisProdCategory;
        String servisSitename;
        String servisSiteid;
        String servisInstallationid;
        String servisManufacturer;
        Date servisManufactDate;
        String servisManufactOrderNumber;
        Date servisCommissioningDate;
        String servisInstallationStatus;
        Date servisCustWarrantyStartDate;
        Date servisCustWarrantyEndDate;
        String servisWarrantyStatus;
        String servisSerialnumber;
        String servisPurchaseOrder;
        String servisOperatorGUID;
        String servisOperatorName;      
        String servisAddress;
        String servisCid;
        String servisCity;
        String servisCountry;
        String servisLatitude;
        String servisLongitude;
        String servisPG; 
        String reqPurchaseorder = '';
        String reqSerialnumber = '';       
        
        //String taskMsg = 'The following values were extracted from ServIS, but as the case has already some entries, the following values where not updated. \n';
        //Boolean loopcheck = false;
        
        Case objcase = [Select id, Link_to_Site_Registration__c, Owner_Type__c, Product.CID__c, Site_Address__c, Ownerid, City__c, ServIS_ProductGroup__c, Site_Country__c, Country__c, Division__c, Site_Geo_Location__Latitude__s, Site_Geo_Location__Longitude__s, Business_Unit__c, Product_category_ServIS__c, Site_Name__c, Site_Id__c, 
            Installation_ID__c,  Manufacturer__c, Manufacturing_Date__c, Manufacturing_Order_Number__c, Commissioning_Date__c, Installation_status__c, Customer_Warranty_startdate__c,
            Customer_Warranty_enddate__c, Serial_Number__c, Operator_GUID__c, Operator_Name__c, Purchase_Order_Number__c from Case where id =: caseid LIMIT 1];
        if(objcase.Purchase_Order_Number__c != null){
            reqPurchaseorder = objcase.Purchase_Order_Number__c;
        }
        if(objcase.Serial_Number__c != null){
            reqSerialnumber = objcase.Serial_Number__c;
        }
        User u = [select firstname, FederationIdentifier  from user where id=:userinfo.getuserid() LIMIT 1];
        HttpRequest req = new HttpRequest();
        String reqbody = System.label.INTEG_SYS_ServIS_URL1 + System.label.INTEG_SYS_ServIS_URL2 + reqPurchaseorder + System.label.INTEG_SYS_ServIS_URL3 + reqSerialnumber;
        //String reqbody = System.label.INTEG_SYS_ServIS_URL1 + u.FederationIdentifier  + System.label.INTEG_SYS_ServIS_URL2 + reqPurchaseorder + System.label.INTEG_SYS_ServIS_URL3 + reqSerialnumber;
        //String reqbody = 'https://www1008.abb.com/stage/servisws/sfdc/Search.svc/SearchInstallSerialRef?email='+ 'mariusz.stala@pl.abb.com' +'&purchaseorder='+reqPurchaseorder+'&serialNumber='+reqSerialnumber;
        req.setEndpoint(reqbody);
        req.setMethod(System.label.INTEG_SYS_SERVIS_Response_GET);    //'GET'
        String autorithationServIS = System.label.SYS_ServIS_Autorithation;
            //req.setHeader('Authorization', 'Basic ZmFjZTpXZWIkZXJ2I2ZhY2U0');
            req.setHeader('Authorization', autorithationServIS );
        Http http = new Http();
        HTTPResponse res = http.send(req);
        String status = res.getStatus(); 
        if(status.equals(System.label.INTEG_SYS_SERVIS_Response_Bad_Request)){
            return System.label.INTEG_SYS_ServIS_Return1;          //'Bad Request: Pelase check the values of [Purchase Order][Serial Number].'
        }
       System.debug('Result:'+ res.getBody());
        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
      // System.debug('Very first list:'+ m); 
        String result = String.valueof(m.get(System.label.INTEG_SYS_SERVIS_Response_Description));
        if(status != System.label.INTEG_SYS_SERVIS_Response_OK){
            return System.label.INTEG_SYS_ServIS_Return2 + res.getbody();  //Request error
        }else{
            if(result != System.label.INTEG_SYS_SERVIS_Response_OK){
                return System.label.INTEG_SYS_ServIS_Return2 + result;
            }else{
                List<Object> reslist = (List<Object>) m.get(System.label.INTEG_SYS_SERVIS_Response_Items);
                if(reslist.size() != 1){                    
                    if(objcase.Owner_Type__c.equals(System.label.INTEG_SYS_ServIS_User)){      //User
                        if(reslist.size() == 0){
                            Task newTask= new Task();         
                            newTask.OwnerId = objcase.Ownerid;          
                            newTask.Subject = System.label.INTEG_SYS_ServIS_Task_Subject;   //'Error while retrieving information from ServIS';      
                            newTask.Priority = System.label.INTEG_SYS_ServIS_Task_Priority;//'Normal';           
                            newTask.Status = System.label.INTEG_SYS_ServIS_Task_Status;  //'Open';          
                            newTask.Type = System.label.INTEG_SYS_ServIS_Task_Type;   //'Action';
                            newTask.Description = System.label.INTEG_SYS_ServIS_Task_Decription1 + ' ' + System.label.SYS_ServIS_SiteReg;    //'Request Error: Please correct the data and request again.\n\n ';
                            newTask.whatid = objcase.id;          
                            Database.Insert(newTask,False);                         
                            return System.label.INTEG_SYS_ServIS_Task_Return1;      //'Please correct the data and request again.'
                        }
                        if(reslist.size() > 1){
                            Task newTask= new Task();         
                            newTask.OwnerId = objcase.Ownerid;          
                            newTask.Subject = System.label.INTEG_SYS_ServIS_Task_Subject;       //'Error while retrieving information from ServIS'
                            newTask.Priority = System.label.INTEG_SYS_ServIS_Task_Priority;      //Normal      
                            newTask.Status = System.label.INTEG_SYS_ServIS_Task_Status;        //Open   
                            newTask.Type = System.label.INTEG_SYS_ServIS_Task_Type;    //Action
                            newTask.Description = System.label.INTEG_SYS_ServIS_Task_Decription2 + System.label.SYS_ServIS_SiteReg;    //'Request Error: Found Multiple entries for current Serial Number/Purchase Order.\n\n'
                            newTask.whatid = objcase.id;           
                            Database.Insert(newTask,False);                         
                            return System.label.INTEG_SYS_ServIS_Task_Return2;
                        }                        
                    }
                }
                try{
                    Map<String, Object> finalresult = new Map<String, Object>();
                    for (Object o : reslist) {
                        finalresult = (Map<String, Object>) o;
                    } 
                    servisAddress = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_Adress));
                    servisCid = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_Cid));
                    servisCity = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_City));
                    servisCountry = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_Country));
                    if(servisCountry != NULL){
                        if(servisCountry.contains('00') || servisCountry.contains('99') || servisCountry.contains('unkno')){
                            return 'No results found';
                        }
                    }
                    servisLatitude = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_Latitude));
                    servisLongitude = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_Longitude));
                    
                    servisPG = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_PG));
                    servisDivision = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_Division));
                    servisBU = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_BU));
                    
                    servisProdCategory = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_Category));
                    servisSitename = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_SiteName));
                    servisSiteid = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_SiteId));
                    servisInstallationid = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_InstallationId));
                    servisManufacturer = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_Manufacturer));
                    
                    String manuDate = String.valueOf(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_ManufacturingDate));
                    System.debug('Test'+ manuDate);
                    if(manuDate!= 'null'){
                        servisManufactDate = dateparsing(manuDate);
                    }
                    
                    //servisManufactDate = dateparsing(String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_ManufacturingDate)));
                    servisManufactOrderNumber = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_ManufacturingOrder));
                    
                    String comDate = String.valueOf(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_ManufacturingOrder));
                    System.debug('Test'+ comDate );
                    if(comDate != 'null'){
                        servisCustWarrantyStartDate = dateparsing(comDate );
                    }
                    //servisCommissioningDate = dateparsing(String.Valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_CommissioningDate)));
                    servisInstallationStatus = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_InstallationStatus));
                    
                    String warStar = String.valueOf(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_WarrantyStart));
                    System.debug('Test'+ warStar );
                    if(warStar != 'null'){
                        servisCustWarrantyStartDate = dateparsing(warStar );
                    }
                    
                    String warClose = String.valueOf(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_WarrantyEnd));
                    System.debug('Test'+ warClose );
                    if(warClose != 'null'){
                        servisCustWarrantyEndDate = dateparsing(warClose);
                    }
                    
                    //servisWarrantyStatus = finalresult.get('Division');
                    servisSerialnumber = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_SerialNumber));
                    servisPurchaseOrder = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_PurchaseOrderNumber));
                    servisOperatorGUID = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_OperatorGuid));
                    servisOperatorName = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_Operator));
                    Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();     
                    List<Product2> servISproduct = [Select id from Product2 where CID__C =:servisCid LIMIT :remLimit];
                    /*
                    Product2 updproduct = new Product2();
                    updproduct.id = objcase.Productid;
                    updproduct.CID__c = servisCid;
                    */
                    
                    Case updCase = new Case();
                    updCase.id = objcase.id;
                    updCase.Site_Address__c = servisAddress;
                    updCase.City__c = servisCity;
                    updCase.Site_Country__c = servisCountry.tolowercase().capitalize();
                    if(servisLatitude != null)
                        updCase.Site_Geo_Location__Latitude__s = Decimal.valueof(servisLatitude);
                    if(servisLongitude != null)
                        updCase.Site_Geo_Location__Longitude__s = Decimal.valueof(servisLongitude);
                    updCase.ServIS_ProductGroup__c = servisPG;
                    updCase.ServIS_Division__c= servisDivision;
                    updCase.ServIS_BU__c= servisBU;
                    updCase.Product_category_ServIS__c = servisProdCategory;
                    updCase.Site_Name__c = servisSitename;
                    updCase.Site_Id__c = servisSiteid;
                    updCase.Installation_ID__c = servisInstallationid;
                    updCase.Manufacturer__c = servisManufacturer;
                    updCase.Manufacturing_Date__c = servisManufactDate;
                    updCase.Manufacturing_Order_Number__c = servisManufactOrderNumber;
                    updCase.Commissioning_Date__c = servisCommissioningDate;
                    updCase.Installation_status__c = servisInstallationStatus;
                    updCase.Customer_Warranty_startdate__c = servisCustWarrantyStartDate;
                    updCase.Customer_Warranty_enddate__c = servisCustWarrantyEndDate;
                    updCase.Serial_Number__c = servisSerialnumber;
                    updCase.Purchase_Order_Number__c = servisPurchaseOrder;
                    updCase.Operator_GUID__c = servisOperatorGUID;
                    updCase.Operator_Name__c = servisOperatorName;
                    if(!servISproduct.isEmpty()){
                        updCase.productID = servISproduct[0].id;    
                    }
                   // System.debug('Case : '+ updCase);
                    Database.update(updCase, False);  
                    
                }Catch(Exception ex){
                    return System.label.INTEG_SYS_ServIS_Return3 + ex.getMessage() + System.label.INTEG_SYS_ServIS_Return4 + ex.getLineNumber();    //'Server Exception :'   >>> 'Line Number: '
                }
                return System.label.INTEG_SYS_ServIS_Return5;     //'Requested update has been completed successfully from ServIS.'
            }
        }
    }
    /*  Description of the method. 
    *  @name dateparsing
    *  @Description - get the value for parseddate.
    */       
    private static Date dateparsing(string strdate){
        if(strdate != null){
            List<String> dateParts = strdate.toLowerCase().replace(',','').split('-');
            System.debug('SplitDate'+ dateParts ) ;
            if(dateParts.size()>2){
                Integer month = Integer.valueof(dateParts[1]);
                Integer day = Integer.valueOf(dateParts[2]);
                Integer year = Integer.valueOf(dateParts[0]);
                Date parsedDate = Date.newInstance(year,month,day);
                return parseddate;
            }else
                return null;
        }else{
            return null;
        }
    }
}