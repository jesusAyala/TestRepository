/**
    @Author Rajesh K
    @name OpportunityLineItem_ServIS_WSDL_NewOLI
    @Version 1.0
    **/
global without sharing class OpportunityLineItem_ServIS_WSDL_NewOLI {     
    /*  Description of the purpose of the method. 
    *  @name newLineItem
    *  @Description - input parameters.
    */
    global without sharing class newLineItem {
        webservice String in_oppid;
        webservice String in_CID;
        webservice Decimal in_quantity;
        webservice String in_Description;
        webservice Decimal in_Value;
        webservice String in_siteName;
        webservice String in_siteId;
        webservice String in_creatorEmail;
        webservice String in_ServISOppID;
        webservice String in_OppSource;    
    }
    /*  Description of the purpose of the method. 
    *  @name Result
    *  @Description - Result parameters.
    */
    global without sharing class Result{
        WebService String oppID;
        WebService String error;
    }
    /*  Description of the purpose of the method. 
    *  @name createOLI
    *  @Description - Create new opportunity line item using webservice.
    *  @return 'Result'
    */
    webservice static Result createOLI(list<newLineItem> lstNewLineItems) {
        Result res = new Result();        
        try{
            List<OpportunityLineItem> lstinsopplineitem = new List<OpportunityLineItem>();
            Map<id,Opportunity> mapOpportunity = new Map<id,Opportunity>();
            Map<String,Product2> mapProducts = new Map<String,Product2>();
            Map<id,List<PriceBookEntry>> mapPricebookentry = new Map<id,List<PriceBookEntry>>();
            Set<id> setProducts = new Set<id>();
            Set<id> setinOppids = new Set<id>();
            Set<String> setinCIDs = new Set<String>();
            for(newLineItem newoli : lstNewLineItems){
                setinOppids.add(newoli.in_OppId);
                setinCIDs.add(newoli.in_CID);
            }
            for(Opportunity objopp : [Select id, currencyIsoCode from Opportunity where id IN: setinOppids LIMIT 50000]){
                mapOpportunity.put(objopp.id, objopp);
            }
            for(Product2 objprod : [Select id, CID__c from Product2 where CID__c IN: setinCIDs LIMIT 50000]){
                setProducts.add(objprod.id);
                if(!mapProducts.containskey(objprod.CID__c))
                    mapProducts.put(objprod.CID__c, objprod);
            }
            for(PriceBookEntry objpBEntry : [SELECT Id, Product2Id, Product2.Id, Product2.Name, UnitPrice, CurrencyIsoCode FROM PriceBookEntry WHERE Product2Id IN: setProducts AND PriceBook2.isStandard=true LIMIT 50000]){
                if(!mapPricebookentry.ContainsKey(objpBEntry.Product2Id)){
                    mapPricebookentry.put(objpBEntry.Product2Id, new List<PriceBookEntry>());
                }
                mapPricebookentry.get(objpBEntry.Product2Id).add(objpBEntry); 
            }  
            
            for(newLineItem objnewoli : lstNewLineItems){
                if(objnewoli.in_OppId != null && mapOpportunity.containskey(objnewoli.in_OppId)){
                    if(mapProducts.containskey(objnewoli.in_CID)){                      
                        PriceBookEntry priceBookentryOpp;
                       // System.debug(mapPricebookentry.get(mapProducts.get(objnewoli.in_CID).id));
                        for(PriceBookEntry pbe: mapPricebookentry.get(mapProducts.get(objnewoli.in_CID).id)){
                            if(mapOpportunity.get(objnewoli.in_OppId).currencyIsoCode == pbe.CurrencyIsoCode){
                               priceBookentryOpp = pbe;
                            }
                        }
                        //Create Opportunity line item
                        if(priceBookentryOpp != null && objnewoli.in_quantity != null){
                            OpportunityLineItem newOLI = new OpportunityLineItem();
                            newOLI.OpportunityID = objnewoli.in_OppId;
                            newOLI.PricebookEntryId=priceBookentryOpp.Id;                   
                            newOLI.quantity= objnewoli.in_quantity;
                            newOLI.unitPrice=priceBookentryOpp.UnitPrice;
                            //newOLI.Serial_Number__c = in_serialNumber;
                            newOLI.Site_Name__c = objnewoli.in_siteName;
                            newOLI.Site_Id__c = objnewoli.in_siteId;
                            newOLI.Value__c = objnewoli.in_Value;
                            newOLI.Description__c = objnewoli.in_Description;
                            newOLI.ServIS_Opp_Id__c = objnewoli.in_ServISOppID;
                            newOLI.Opportunity_Source__c = objnewoli.in_OppSource;
                            newOLI.ServIS_Creator_Email__c = objnewoli.in_creatorEmail;
                            //newOLI.CurrencyIsoCode= priceBookList[0].CurrencyIsoCode;
                            lstinsopplineitem.add(newOLI);
                        }else{
                            res.error = System.label.INTEG_SYS_ServIS_OLI_Error1; //'No price book was found for the provided currency or no valid quantity provided';
                            return res;    
                        }
                    }else{
                            res.error = System.label.INTEG_SYS_ServIS_OLI_Error2 + objnewoli.in_CID;  //'CID is not valid:'
                            return res;    
                    }
                }else{
                    res.error = System.label.INTEG_SYS_ServIS_OLI_Error3; //'No valid parent Opportunity. Review Opp Id';
                    return res;    
                }
            }
            if(lstinsopplineitem.size()>0){
                Database.insert(lstinsopplineitem, false);
                res.oppID = System.label.INTEG_SYS_ServIS_OLI_oppID; //'OK';
                return res;
            }else{
                res.error = System.label.INTEG_SYS_ServIS_OLI_Error4; //'No records inserted';
                return res;
            }
        }
        catch(ClsTriggerException cte){
            //System.debug('Message: ' + cte.getMessage());
            res.error = cte.getMessage();
            return res;
        }
    }   
}