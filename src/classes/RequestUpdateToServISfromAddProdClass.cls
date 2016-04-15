/**
@Author Rajesh K
@name RequestUpdateToServISfromAddProdClass
@CreateDate 21-Jan-2015
@Version 1.0
**/
global without sharing class RequestUpdateToServISfromAddProdClass
{
    /*  Description of the method. 
    *  @name requestUpdatetoServis
    *  @Description - Request update to ServIS from SFDC.
    *  @return String
    */
    webservice static String requestUpdatetoServis(Id addProdId) 
    {  
        //Service call here
        
        //Send Additional product values into ServeIS here
        
        String servisAddress ='';
        String servisCity ='';
        String servisCountry ='';
        String servisLatitude ='';
        String servisLongitude='';
        
        String servisCid;
        
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
        String servisSerialnumber;
        String servisPurchaseOrder;
        String servisOperatorGUID;
        String servisOperatorName;
        //String taskMsg = 'The following values were extracted from ServIS, but as the case has already some entries, the following values where not updated. \n';
        String reqPurchaseorder = '';
        String reqSerialnumber = '';
        
        Additional_Product__c objAddProd = [Select id,  case__r.Link_to_site_Registration__c, Case__r.ownerid, Case__c, Product_category_ServIS__c, Site_Name__c, Site_Id__c, 
                                                Installation_ID__c, Manufacturer__c, Manufacturing_Date__c, Manufacturing_Order_Number__c, Commissioning_Date__c, Installation_status__c, Customer_Warranty_startdate__c,
                                                Customer_Warranty_enddate__c, Serial_Number__c, Operator_GUID__c, Operator_Name__c, Purchase_Order__c from Additional_Product__c where id =: addProdId LIMIT 1];
        if(objAddProd.Purchase_Order__c != null){
            reqPurchaseorder = objAddProd.Purchase_Order__c ;
        }
        if(objAddProd.Serial_Number__c != null){
            reqSerialnumber = objAddProd.Serial_Number__c;
        }
        User u = [select firstname, FederationIdentifier  from user where id=:userinfo.getuserid() LIMIT 1];
        HttpRequest req = new HttpRequest();
        String reqbody = System.label.INTEG_SYS_ServIS_URL1 +  System.label.INTEG_SYS_ServIS_URL2 + reqPurchaseorder + System.label.INTEG_SYS_ServIS_URL3 +reqSerialnumber;
        //String reqbody = System.label.INTEG_SYS_ServIS_URL1 + u.FederationIdentifier + System.label.INTEG_SYS_ServIS_URL2 + reqPurchaseorder + System.label.INTEG_SYS_ServIS_URL3 +reqSerialnumber;
        //String reqbody = 'https://www1008.abb.com/stage/servisws/sfdc/Search.svc/SearchInstallSerialRef?email='+ 'mariusz.stala@pl.abb.com' +'&purchaseorder='+reqPurchaseorder+'&serialNumber='+reqSerialnumber;
        req.setEndpoint(reqbody);
        req.setMethod(System.label.INTEG_SYS_SERVIS_Response_GET);    // INTEG_SYS_SERVIS_Response_GET = GET
        String autorithationServIS = System.label.SYS_ServIS_Autorithation;
            //req.setHeader('Authorization', 'Basic ZmFjZTpXZWIkZXJ2I2ZhY2U0');
            req.setHeader('Authorization', autorithationServIS );
        Http http = new Http();
        HTTPResponse res = http.send(req);
        String status = res.getStatus(); 
        //System.debug('Request Body: '+ reqbody);
        if(status.equals(System.label.INTEG_SYS_SERVIS_Response_Bad_Request)){   // 'Bad Request'
            return System.label.INTEG_SYS_ServIS_Return1;    //INTEG_SYS_ServIS_Return1 = 'Bad Request: Please check the values of [Purchase Order][Serial Number].'
        }
        System.debug('Result:'+ res.getBody());
        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        String result = String.valueof(m.get(System.label.INTEG_SYS_SERVIS_Response_Description));  //NTEG_SYS_SERVIS_Response_Description = Description
        if(status != System.label.INTEG_SYS_SERVIS_Response_OK){
            return System.label.INTEG_SYS_ServIS_Return2 + res.getbody();  //INTEG_SYS_ServIS_Return2 = Request Error:
        }else{
            if(result != System.label.INTEG_SYS_SERVIS_Response_OK){    // INTEG_SYS_SERVIS_Response_OK = OK
                return System.label.INTEG_SYS_ServIS_Return2 + result;
            }else{
                List<Object> reslist = (List<Object>) m.get(System.label.INTEG_SYS_SERVIS_Response_Items);    //INTEG_SYS_SERVIS_Response_Items = Items
                if(reslist.size() != 1){                        
                    String ownerAddProd = objAddProd.Case__r.ownerid;
                    if(ownerAddProd.startswith('005')){
                        if(reslist.size() == 0){
                            Task newTask= new Task();         
                            newTask.OwnerId = objAddProd.Case__r.ownerid;          
                            newTask.Subject = System.label.INTEG_SYS_ServIS_Task_Subject;   //'Error while retrieving information from ServIS';      
                            newTask.Priority = System.label.INTEG_SYS_ServIS_Task_Priority; //'Normal';           
                            newTask.Status = System.label.INTEG_SYS_ServIS_Task_Status; //'Open';          
                            newTask.Type = System.label.INTEG_SYS_ServIS_Task_Type;  //'Action';
                            newTask.Description = System.label.INTEG_SYS_ServIS_Task_Decription1 + System.label.SYS_ServIS_SiteReg; //'Request Error: Please correct the data and request again. \n\n'
                            newTask.whatid = objAddProd.id;          
                            Database.Insert(newTask,False);                         
                            return System.label.INTEG_SYS_ServIS_Task_Return1;   //'Please correct the data and request again.';
                        }
                        if(reslist.size() > 1){
                            Task newTask= new Task();         
                            newTask.OwnerId = objAddProd.Case__r.ownerid;          
                            newTask.Subject = System.label.INTEG_SYS_ServIS_Task_Subject;
                            newTask.Priority = System.label.INTEG_SYS_ServIS_Task_Priority;         
                            newTask.Status = System.label.INTEG_SYS_ServIS_Task_Status;     
                            newTask.Type = System.label.INTEG_SYS_ServIS_Task_Type;
                            newTask.Description = System.label.INTEG_SYS_ServIS_Task_Decription2 + System.label.SYS_ServIS_SiteReg;   //'Request Error: Found Multiple entries for current Serial Number/Purchase Order. \n\n'
                            newTask.whatid = objAddProd.id;          
                            Database.Insert(newTask,False);                      
                            return System.label.INTEG_SYS_ServIS_Task_Return2; //'Found Multiple entries for current Serial Number/Purchase Order.';
                        }
                    }
                }          
            try{ 
                    Map<String, Object> finalresult = new Map<String, Object>();
                    for (Object o : reslist) {
                        finalresult = (Map<String, Object>) o;
                    }
                    //Map<String, Object>  finalresult = (Map<String, Object>)m.get('Items');
                    /*for(String s: finalresult.keyset()){
                        system.debug(m.get(s));
                    }*/ 
                    servisAddress = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_Adress));  //INTEG_SYS_SERVIS_Response_Adress = Adress
                    servisCid = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_Cid));    //INTEG_SYS_SERVIS_Response_Cid = Cid
                    servisCity = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_City));   
                    servisCountry = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_Country));
                    if(servisCountry != NULL){
                        if(servisCountry.contains('00') || servisCountry.contains('99') || servisCountry.contains('unkno')){
                            return 'No results found';
                        }
                    }
                    servisLatitude = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_Latitude));
                    servisLongitude = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_Longitude));
                    servisProdCategory = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_Category));
                    servisSitename = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_SiteName));
                    servisSiteid = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_SiteId));
                    servisInstallationid = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_InstallationId));
                    servisManufacturer = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_Manufacturer));
                    servisManufactDate = dateparsing(String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_ManufacturingDate)));
                    servisManufactOrderNumber = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_ManufacturingOrder));
                    servisCommissioningDate = dateparsing(String.Valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_CommissioningDate)));
                    servisInstallationStatus = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_InstallationStatus));
                    servisCustWarrantyStartDate = dateparsing(String.valueOf(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_WarrantyStart)));
                    servisCustWarrantyEndDate = dateparsing(String.valueOf(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_WarrantyEnd)));
                    servisSerialnumber = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_SerialNumber));
                    servisPurchaseOrder = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_PurchaseOrderNumber));
                    servisOperatorGUID = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_OperatorGuid));
                    servisOperatorName = String.valueof(finalresult.get(System.label.INTEG_SYS_SERVIS_Response_Operator));
                         
                    List<Product2> servISproduct = [Select id from Product2 where CID__C =:servisCid LIMIT 1];
                    
                    Additional_Product__c updProd = new Additional_Product__c();
                    updProd.id = objAddProd.id;
                    updProd.Site_Address__c = servisAddress;
                    updProd.City__c = servisCity;
                    updProd.Country__c = servisCountry.tolowercase().capitalize();
                    if(servisLatitude != null){
                        updProd.Site_Geo_Location__Latitude__s = Decimal.valueof(servisLatitude);
                    }
                    if(servisLongitude != null){
                        updProd.Site_Geo_Location__Longitude__s = Decimal.valueof(servisLongitude);
                    }
                    updProd.Product_category_ServIS__c = servisProdCategory;
                    updProd.Site_Name__c = servisSitename;
                    updProd.Site_Id__c = servisSiteid;
                    updProd.Installation_ID__c = servisInstallationid;
                    updProd.Manufacturer__c = servisManufacturer;
                    updProd.Manufacturing_Date__c = servisManufactDate;
                    updProd.Manufacturing_Order_Number__c = servisManufactOrderNumber;
                    updProd.Commissioning_Date__c = servisCommissioningDate;
                    updProd.Installation_status__c = servisInstallationStatus;
                    updProd.Customer_Warranty_startdate__c = servisCustWarrantyStartDate;
                    updProd.Customer_Warranty_enddate__c = servisCustWarrantyEndDate;
                    updProd.Serial_Number__c = servisSerialnumber;
                    updProd.Purchase_Order__c = servisPurchaseOrder;
                    updProd.Operator_GUID__c = servisOperatorGUID;
                    updProd.Operator_Name__c = servisOperatorName;
                    if(!servISproduct.isEmpty()){
                        updProd.product__c = servISproduct[0].id;    
                    }
                    //System.debug('Product: '+ updProd);
                    Database.update(updProd, false); 
                    }Catch(Exception ex){
                    return System.label.INTEG_SYS_ServIS_Return3 + ex.getMessage() + System.label.INTEG_SYS_ServIS_Return4 + ex.getLineNumber();
                }
                return System.label.INTEG_SYS_ServIS_Return5;   //'Requested update has been completed successfully from ServIS.';
            }
        }
    }   
    /*  Description of the method. 
    *  @name dateparsing
    *  @Description - Change the date format
    *  @return Date
    */  
    private static Date dateparsing(string strdate){
        if(strdate != null){
            List<String> dateParts = strdate.toLowerCase().replace(',','').split('-');
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