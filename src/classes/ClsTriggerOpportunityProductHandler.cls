/**
*  @Name: ClsTriggerOpportunityProductHandler
*  @return - void
*  @Description - This class helps to control the Opportunity Product Trigger logic
*  @Author : Rajesh Kaliyaperumal (Accenture)
*/
public without Sharing class ClsTriggerOpportunityProductHandler extends ClsTriggerVirtual {
    /**
     * @see IntHelper.beforeTrigger
    */    
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
       setValidation(trgCtx);
    }    
    /**
     * @see IntHelper.afterTrigger
    */
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {      
        setOpportunityProductPrimaryPGonInsert(trgCtx); 
        setOpportunityPrimaryProductGroup(trgCtx); 
        setOpportunityProductPrimaryPGonDelete(trgCtx);
    }
    @TestVisible 
    private void setValidation(ClsWrappers.TriggerContext trgCtx) {    
        if(trgCtx.isUpdate)
        {             
            for (sobject so : trgCtx.newList) {
                OpportunityLineItem oppli = (OpportunityLineItem)so;                
                if(oppli.Opportunity_Close_Date__c < system.today()){
                    oppli.Primary_Product_Group__c.addError('Opportunity expected award date cannot be past date.');
                }         
            }
        }   
    }
    /**
    *  @Name: setOpportunityProductPrimaryPGonInsert
    *  @return - void
    *  @Description - Method to set Opportunity Primary Product Group while insert DML operation
    */
    @TestVisible 
    private void setOpportunityProductPrimaryPGonInsert(ClsWrappers.TriggerContext trgCtx) {        
         
        if(trgCtx.isAfter && trgCtx.isInsert)
        {
            List<Opportunity> lstupdOpportunity = new List<Opportunity>();
            List<OpportunityLineItem> lstupdOpportunityLineItem = new List<OpportunityLineItem>();
            Map<String, Product_Group__c> mapProductGroups = new Map<String, Product_Group__c>();   
            Map<ID, String> mapProducts = new Map<ID, String>();
            Map<Id, List<OpportunityLineItem>> mapOppLineItems = new Map<Id, List<OpportunityLineItem>>(); 
            Map<String,CurrencyType> conversion_rates = new Map<String,CurrencyType>();
            Set<Id> oppIds = new Set<Id>(); 
            Set<Id> prodIds = new Set<Id>();
            Set<String> productGroups = new Set<String>();          
            for (sobject so : trgCtx.newList) {         
                OpportunityLineItem oppli = (OpportunityLineItem)so;
                if(oppli.APTS_Is_Local_Product__c <> true){
                    oppIds.add(oppli.OpportunityId);           
                }
            }               
            mapOppLineItems = buildOpportunitylineitem(oppIds); 
            for(ID oppId : mapOppLineItems.Keyset())  
            { 
                for(OpportunityLineItem opplineRec : mapOppLineItems.get(oppId)){                   
                    prodIds.add(opplineRec.Product2id);
                }
            }
            for(Product2 prod : [Select id,Product_Group__c from Product2 where id in:prodIds LIMIT 50000]){                
                productGroups.add(String.valueof(prod.Product_Group__c));
                mapProducts.put(prod.id,String.valueof(prod.Product_Group__c));
            } 
            for(CurrencyType curr : [SELECT ISOCode, ConversionRate FROM CurrencyType WHERE IsActive=TRUE LIMIT 50000]){
                conversion_rates.put(curr.ISOCode,curr);
            }        
            mapProductGroups = buildProductGroups(productGroups);
            for(ID oppId : mapOppLineItems.Keyset())  
            {               
                Boolean opplineCheck = false; 
                Boolean opplineRegular = false;
                String primaryPG = null;
                Decimal minThresholdvalue = 0;
                List<Decimal> minThreshold = new List<Decimal>();
                List<OpportunityLineItem> lstopplineitem = mapOppLineItems.get(oppId);              
                for(OpportunityLineItem opplineRec : mapOppLineItems.get(oppId)){                   
                    if(opplineRec.Primary_Product_Group__c == true){
                        opplineCheck = true;
                        if(mapProductGroups.containskey(mapProducts.get(opplineRec.Product2id)))
                            primaryPG = mapProductGroups.get(mapProducts.get(opplineRec.Product2id)).Name;
                    }
                    if(mapProductGroups.containskey(mapProducts.get(opplineRec.Product2id)))
                        minThreshold.add(mapProductGroups.get(mapProducts.get(opplineRec.Product2id)).Opportunity_Threshold__c/conversion_rates.get(mapProductGroups.get(mapProducts.get(opplineRec.Product2id)).CurrencyIsoCode).ConversionRate);
                    if(mapProductGroups.containskey(mapProducts.get(opplineRec.Product2id)) && mapProductGroups.get(mapProducts.get(opplineRec.Product2id)).Opportunity_Default_Type__c == 'Regular'){
                        opplineRegular = true;
                    }
                }
                if(minThreshold.size()>0){
                    minThreshold.sort();
                    minThresholdvalue = minThreshold[0];
                }
                if(opplineCheck == false && lstopplineitem.size() > 0){
                    lstopplineitem.sort();                  
                    lstupdOpportunityLineItem.add(new OpportunityLineItem(id = lstopplineitem[0].id, Primary_Product_Group__c = true));
                    if(mapProductGroups.containskey(mapProducts.get(lstopplineitem[0].Product2id))){
                        lstupdOpportunity.add(new Opportunity(id = oppId, Is_Product_Available__c = true, If_any_PG_Regular__c = opplineRegular, Min_Product_Group_Threshold__c = minThresholdvalue,Product_Primary_PG__c = mapProductGroups.get(mapProducts.get(lstopplineitem[0].Product2id)).Name));
                    }else{
                        lstupdOpportunity.add(new Opportunity(id = oppId, Is_Product_Available__c = true, If_any_PG_Regular__c = opplineRegular, Min_Product_Group_Threshold__c = minThresholdvalue,Product_Primary_PG__c = null));
                    }  
                }
                if(opplineCheck == true){
                    lstupdOpportunity.add(new Opportunity(id = oppId, Is_Product_Available__c = true, If_any_PG_Regular__c = opplineRegular, Min_Product_Group_Threshold__c = minThresholdvalue,Product_Primary_PG__c = primaryPG));
                }
            } 
            ClsTriggerFactory.isSkipRecursiveTrigger = false;
            if(lstupdOpportunityLineItem.size()>0){
                Database.update(lstupdOpportunityLineItem, false);
            } 
            if(lstupdOpportunity.size()>0){
                Database.update(lstupdOpportunity, false);
            }          
        }
    }
    /**
    *  @Name: setOpportunityPrimaryProductGroup
    *  @return - void
    *  @Description - Method to set Opportunity Primary Product Group while update DML operation
    */
    @TestVisible 
    private void setOpportunityPrimaryProductGroup(ClsWrappers.TriggerContext trgCtx) {
        
        if(trgCtx.isAfter && trgCtx.isUpdate && ClsTriggerFactory.isSkipRecursiveTrigger == true)
        { 
            List<Opportunity> lstupdOpportunity = new List<Opportunity>();
            List<OpportunityLineItem> lstupdOpportunityLineItem = new List<OpportunityLineItem>();
            Map<Id, List<OpportunityLineItem>> mapOppLineItems = new Map<Id, List<OpportunityLineItem>>();
            Map<String, Product_Group__c> mapProductGroups = new Map<String, Product_Group__c>();
            Set<Id> oppIds = new Set<Id>();
            Set<Id> prodIds = new Set<Id>();
            Set<String> productGroups = new Set<String>();
            Map<String,CurrencyType> conversion_rates = new Map<String,CurrencyType>();
            for (sobject so : trgCtx.newList) {
                OpportunityLineItem oppli = (OpportunityLineItem)so;                
                if(((OpportunityLineItem)trgCtx.oldMap.get(oppli.Id)).Primary_Product_Group__c != oppli.Primary_Product_Group__c && oppli.APTS_Is_Local_Product__c <> true){
                    oppIds.add(oppli.OpportunityId);
                }
            } 
            mapOppLineItems = buildOpportunitylineitem(oppIds);
            
            for(CurrencyType curr : [SELECT ISOCode, ConversionRate FROM CurrencyType WHERE IsActive=TRUE LIMIT 50000]){
                conversion_rates.put(curr.ISOCode,curr);
            }
            System.debug('Logging8989:'+oppIds);
            
            for(ID oppId : mapOppLineItems.Keyset()){
                for(OpportunityLineItem oppline : mapOppLineItems.get(oppId)){
                    productGroups.add(String.valueof(oppline.Product_Group__c));
                }
            }
            mapProductGroups = buildProductGroups(productGroups);
             
            for(ID oppId : mapOppLineItems.Keyset())  
            { 
                Boolean opplineCheck = false;
                Boolean opplineRegular = false;
                Decimal minThresholdvalue = 0;
                List<Decimal> minThreshold = new List<Decimal>();
                String primaryPG = null;
                for(OpportunityLineItem opplineRec : mapOppLineItems.get(oppId)){
                    if(mapProductGroups.containskey(String.valueof(opplineRec.Product_Group__c))){
                        minThreshold.add(mapProductGroups.get(String.valueof(opplineRec.Product_Group__c)).Opportunity_Threshold__c/conversion_rates.get(mapProductGroups.get(String.valueof(opplineRec.Product_Group__c)).CurrencyIsoCode).ConversionRate);
                    }
                    if(mapProductGroups.containskey(String.valueof(opplineRec.Product_Group__c)) && mapProductGroups.get(String.valueof(opplineRec.Product_Group__c)).Opportunity_Default_Type__c == 'Regular'){
                        opplineRegular = true;
                    }
                }               
                if(minThreshold.size()>0){
                    minThreshold.sort();
                    minThresholdvalue = minThreshold[0];
                }
                for(OpportunityLineItem opplineRec : mapOppLineItems.get(oppId))
                {                   
                    if(trgCtx.oldMap.containskey(opplineRec.id) && ((OpportunityLineItem)trgCtx.oldMap.get(opplineRec.Id)).Primary_Product_Group__c != opplineRec.Primary_Product_Group__c && 
                    opplineRec.Primary_Product_Group__c == true){ 
                        if(mapProductGroups.containskey(String.valueof(opplineRec.Product_Group__c))){
                            primaryPG = mapProductGroups.get(String.valueof(opplineRec.Product_Group__c)).Name;
                            //lstupdOpportunity1.add(new Opportunity(id = opplineRec.OpportunityId, Is_Product_Available__c = true, Product_Primary_PG__c = mapProductGroups.get(String.valueof(opplineRec.Product_Group__c)).Name));                         
                        }
                        opplineCheck = true;
                    }
                    if(!trgCtx.oldMap.containskey(opplineRec.id) && opplineRec.Primary_Product_Group__c == true){
                    system.debug('@@@@@@'+opplineRec);
                        lstupdOpportunityLineItem.add(new OpportunityLineItem(id = opplineRec.id, Primary_Product_Group__c = false));
                    }
                }
                if(opplineCheck == false){
                    List<OpportunityLineItem> lstopplineitem = mapOppLineItems.get(oppId);
                    if(lstopplineitem.size()>0){
                        lstopplineitem.sort();
                        lstupdOpportunityLineItem.add(new OpportunityLineItem(id = lstopplineitem[0].id, Primary_Product_Group__c = true));
                        if(mapProductGroups.containskey(String.valueof(lstopplineitem[0].Product_Group__c))){
                            //lstupdOpportunity2.add(new Opportunity(id = oppId, Is_Product_Available__c = true, Product_Primary_PG__c = mapProductGroups.get(String.valueof(lstopplineitem[0].Product_Group__c)).Name));
                            primaryPG = mapProductGroups.get(String.valueof(lstopplineitem[0].Product_Group__c)).Name;
                        }                  
                    }
                    system.debug('&&&&&&'+lstupdOpportunityLineItem);                    
                }
                System.debug('Logging0000:'+primaryPG);
                lstupdOpportunity.add(new Opportunity(id = oppId, Is_Product_Available__c = true, If_any_PG_Regular__c = opplineRegular, Product_Primary_PG__c = primaryPG, Min_Product_Group_Threshold__c = minThresholdvalue));
                System.debug('lstupdOpportunity:'+lstupdOpportunity);
            }
            ClsTriggerFactory.isSkipRecursiveTrigger = false; 
            if(lstupdOpportunity.size()>0){
                try{
                    update lstupdOpportunity;  
                   }
                catch(Exception exc){
                     String error ='';
                           String errMsgs  = '';
                           Integer numErrors = exc.getNumDml();
                           //String genErr = System.label.System_Oppty_Label1+ System.label.Line_Break;
                           for(Integer i=0;i<numErrors;i++) {
                              if(exc.getDmlMessage(i).equalsIgnoreCase(System.label.Primary_Line_Item_ValMsg)){ 
                              errMsgs +=  System.label.Primary_Line_Item_CorrectMsg +System.label.Line_Break; 
                              }
                              else{
                              errMsgs +=  exc.getDmlMessage(i) +System.label.Line_Break;    
                              }             
                           }
                           error = errMsgs ;  
                           for (sobject sob : trgCtx.newList){
                              OpportunityLineItem oppli = (OpportunityLineItem)sob;
                              oppli.addError(error, false); 
                          }  
                }     
            }
            if(lstupdOpportunityLineItem.size()>0){
            system.debug('AAAAAAA'+lstupdOpportunityLineItem);
                Database.update(lstupdOpportunityLineItem, false);
            }    
        }  
    }
    /**
    *  @Name: setOpportunityProductPrimaryPGonDelete
    *  @return - void
    *  @Description - Method to set validation while delete primary product Group's Product
    */
    @TestVisible 
    private void setOpportunityProductPrimaryPGonDelete(ClsWrappers.TriggerContext trgCtx) {        
         
        if(trgCtx.isAfter && trgCtx.isDelete)
        {   
            List<Opportunity> lstupdOpportunity = new List<Opportunity>();
            Map<Id, List<OpportunityLineItem>> mapOppLineItems = new Map<Id, List<OpportunityLineItem>>();
            Map<String, Product_Group__c> mapProductGroups = new Map<String, Product_Group__c>();
            Set<Id> oppIds = new Set<Id>();
            Set<Id> prodIds = new Set<Id>();
            Set<String> productGroups = new Set<String>();
            Map<String,CurrencyType> conversion_rates = new Map<String,CurrencyType>();
            for (sobject so : trgCtx.oldList) {
                OpportunityLineItem oppli = (OpportunityLineItem)so; 
                if(oppli.APTS_Is_Local_Product__c <> true){
                    oppIds.add(oppli.OpportunityId);
                }
                if(oppli.APTS_Is_Local_Product__c == true && ClsTriggerFactory.isLocalProductDelete == true){
                    oppli.addError(System.label.CL00100);
                }
                if(oppli.Primary_Product_Group__c == true && oppli.APTS_Is_Local_Product__c <> true){
                    oppli.addError(System.label.OpportunityProductTriggerError);
                } 
            } 
            
            mapOppLineItems = buildOpportunitylineitem(oppIds);
            System.debug('Logging8787:'+mapOppLineItems);
            for(ID oppId : mapOppLineItems.Keyset()){
                for(OpportunityLineItem oppline : mapOppLineItems.get(oppId)){
                    productGroups.add(String.valueof(oppline.Product_Group__c));
                }
            }
            for(CurrencyType curr : [SELECT ISOCode, ConversionRate FROM CurrencyType WHERE IsActive=TRUE LIMIT 50000]){
                conversion_rates.put(curr.ISOCode,curr);
            }
            mapProductGroups = buildProductGroups(productGroups);
             
            for(ID oppId : mapOppLineItems.Keyset())  
            { 
                Boolean opplineCheck = false; 
                Boolean opplineRegular = false;
                String primaryPG = null;
                Decimal minThresholdvalue = 0;
                List<Decimal> minThreshold = new List<Decimal>();
                for(OpportunityLineItem opplineRec : mapOppLineItems.get(oppId))
                {
                    if(opplineRec.Primary_Product_Group__c == true){
                        primaryPG = String.valueof(opplineRec.Product_Group__c);
                    }
                    if(mapProductGroups.containskey(String.valueof(opplineRec.Product_Group__c)))
                        minThreshold.add(mapProductGroups.get(String.valueof(opplineRec.Product_Group__c)).Opportunity_Threshold__c/conversion_rates.get(mapProductGroups.get(String.valueof(opplineRec.Product_Group__c)).CurrencyIsoCode).ConversionRate);
                    if(mapProductGroups.containskey(String.valueof(opplineRec.Product_Group__c)) && mapProductGroups.get(String.valueof(opplineRec.Product_Group__c)).Opportunity_Default_Type__c == 'Regular'){
                        opplineRegular = true;
                    }
                }
                if(minThreshold.size()>0){
                    minThreshold.sort();
                    minThresholdvalue = minThreshold[0];
                }               
                lstupdOpportunity.add(new Opportunity(id = oppId, If_any_PG_Regular__c = opplineRegular, Min_Product_Group_Threshold__c = minThresholdvalue,Product_Primary_PG__c = primaryPG));                   
                
            }
            if(lstupdOpportunity.size()>0){
                Database.update(lstupdOpportunity, false);
            }
        }
    }
    
    /**
    *  @Name: buildOpportunitylineitem
    *  @return - void
    *  @Description - Method to build the map opportunity with opportunity line item
    */
    public Map<Id, List<OpportunityLineItem>> buildOpportunitylineitem(set<ID> oppIds){
        try{
            Map<Id, List<OpportunityLineItem>> mapOppLineItems = new Map<Id, List<OpportunityLineItem>>();
            for(OpportunityLineItem oppline :[SELECT id, Product2id, Opportunity.isPGManualUpdate__c, Product_Group__c, Opportunity.Product_Group__c, Primary_Product_Group__c,
            OpportunityId,Opportunity.Opportunity_Value__c,Opportunity.CurrencyIsoCode FROM OpportunityLineItem where OpportunityId IN:oppIds and APTS_Is_Local_Product__c = false LIMIT 50000]){
                List<OpportunityLineItem> opptemplist = new List<OpportunityLineItem>();
                if(mapOppLineItems.containskey(oppline.OpportunityId))
                {
                    opptemplist = mapOppLineItems.get(oppline.OpportunityId);
                    opptemplist.add(oppline);
                    mapOppLineItems.put(oppline.OpportunityId,opptemplist);
                }  
                else
                {
                    opptemplist.add(oppline);
                    mapOppLineItems.put(oppline.OpportunityId,opptemplist);
                }               
            }       
            return mapOppLineItems;
        }catch(Exception ex){return null;}
    }
    /**
    *  @Name: buildProductGroups
    *  @return - void
    *  @Description - Method to build the Product Group maps
    */
    @TestVisible
    public Map<String, Product_Group__c> buildProductGroups(set<String> productGroups){     
        Map<String, Product_Group__c> mapProductGroups = new Map<String, Product_Group__c>();
        try{
            for(Product_Group__c objPG :[SELECT id, Name, Opportunity_Default_Type__c, CurrencyIsoCode, 
            Opportunity_Threshold__c from Product_Group__c where Name IN: productGroups LIMIT 50000]){
                    mapProductGroups.put(objPG.Name,objPG);
            }
        }catch(Exception ex){return null;}
        return mapProductGroups;
    }
}