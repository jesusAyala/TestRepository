/**   
* TriggerClass on the Qualification Product List which copies Product group details in to the Qualification Product List custom object.
* Also update values in Product Qualification custom object
*       
* Release R4
*  
* @author  Abiramasundari Radha (Accenture)
* @created 2015-08-21
* @version 1.0
*
* - Created
*/
public without sharing class ClsTriggerQualProdListHandler extends ClsTriggerVirtual {

/**
* @see IntHelper.beforeTrigger
*/  
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
            
        assignProductValuesInQualProd(trgCtx);                  
    } 
    
/**
* @see IntHelper.afterTrigger
*/   
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {        
            updateProdQualHeaderRecord(trgCtx);                  
    }
 
    
/**  
Method : assignProductValuesInQualProd - assign the Product group details in Qualification Product List
assign the Business Unit, Business Unit Name, Division, Division Name, Product Group 
@author  Abiramasundari Radha (Accenture)

*/ 
@TestVisible 
    private void assignProductValuesInQualProd(ClsWrappers.TriggerContext trgCtx) {   
    
        Set<String> setProductId = new Set<String>(); 
        Map <ID, Product2> productMap = new Map<Id, Product2> ();
        Map <ID, Product_Group__c> productGroupMap = new Map<Id, Product_Group__c> ();
        Map <String, Product_Group__c> productGroupNameAndPGMap = new Map<String, Product_Group__c> ();
        Set<String> setProductName = new Set<String>();
        Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows(); 
        
        if (trgCtx.isInsert || trgCtx.isUpdate) {

            for (sobject sObj : trgCtx.newList) {                   
                
                Qualification_Products_List__c newProd = (Qualification_Products_List__c) sObj;   
                Qualification_Products_List__c oldProd  = (trgCtx.isUpdate) ? (Qualification_Products_List__c)trgCtx.oldMap.get(sObj.ID) : NULL;
                
                if (newProd.Product__c != NULL)   {    
                    setProductId.add(newProd.Product__c); 
                }
            }
            
            if (setProductId.size() > 0) {
                productMap = new Map<Id, Product2> ([SELECT Id, Name,Product_Group__c FROM Product2 WHERE ID IN: setProductId AND Product_Group__c != NULL LIMIT :remLimit]);
                for (Product2 prod: productMap.Values()) {
                    setProductName.add(String.ValueOf(prod.Product_Group__c));
                }
            }
            
            if (setProductName.size() > 0) {
                productGroupMap = new Map<Id, Product_Group__c > ([ SELECT ID, Name, Business_Unit__c, Division_Name__c,Business_Unit_Name__c,Division__c
                            FROM Product_Group__c WHERE Name IN :setProductName LIMIT :remLimit]); 
                for (Product_Group__c prod: productGroupMap.Values()) {
                    productGroupNameAndPGMap.put(prod.Name, prod);                
                }                
            }
            
                       
            for (sobject sObj : trgCtx.newList) {    
                
                Qualification_Products_List__c newProd = (Qualification_Products_List__c) sObj;
                
                if (newProd.Product__c != NULL && productMap.containskey(newProd.Product__c) && 
                            productGroupNameAndPGMap.containsKey(String.valueOf(productMap.get(newProd.Product__c).Product_Group__c))) {
                    
                    Product_Group__c pg = productGroupNameAndPGMap.get(String.valueOf(productMap.get(newProd.Product__c).Product_Group__c));               
                    newProd.Business_Unit__c  = pg.Business_Unit__c;
                    newProd.Division__c  = pg.Division__c;
                    newProd.Business_Unit_Name__c  = pg.Business_Unit_Name__c;
                    newProd.Division_Name__c  = pg.Division_Name__c;
                    newProd.Product_Group__c = pg.Name;
                }
            }
        }
    }
    
/**  
Method : assignProductValuesInQualProd - assign the Product group details in Qualification Product List
assign the Business Unit, Business Unit Name, Division, Division Name, Product Group 
@author  Abiramasundari Radha (Accenture)

*/ 
@TestVisible 
  private void updateProdQualHeaderRecord(ClsWrappers.TriggerContext trgCtx) {   
        
        if (trgCtx.isInsert || trgCtx.isUpdate) { 
        
            Set<String> setABBLocationId = new Set<String>();
            Set<String> setProductQualificationId = new Set<String>();
            Set<String> setProductId = new Set<String>();
            List<Product_Qualification__c> toUpdateProdQualList = new List<Product_Qualification__c>();
            Map<Id, String> mapABBIDAndCountry = new Map<Id, String>();
            Map<Id, String> mapProductName = new Map<Id, String>();
            Map<Id, String> mapProductGroup = new Map<Id, String>();
                                         
            // GET Qualification Product List RECORD INTO THE LIST
            for (sobject sObj : trgCtx.newList) {                           
                // Add the Record to the List - prodQualList     
                Qualification_Products_List__c qualProductList = (Qualification_Products_List__c)sObj;    
                if (qualProductList.ABB_Location__c != NULL || qualProductList.Product__c != NULL ){
                    setABBLocationId.add(qualProductList.ABB_Location__c); 
                    setProductId.add(qualProductList.Product__c);                                       
                }                 
            }  
  
            if(setABBLocationId != NULL && setABBLocationId.size() > 0){
                for(ABB_Location__c abbLocation :[SELECT Id, Name from ABB_Location__c WHERE ID IN: setABBLocationId LIMIT 10000]){
                    mapABBIDAndCountry.put(abbLocation.Id,abbLocation.Name);                                            
                }   
            } 
            
            if(setProductId != NULL && setProductId.size() > 0){
                for(Product2 prod :[SELECT Id, Name,Product_Group__c from Product2 WHERE ID IN: setProductId LIMIT 10000]){
                    mapProductName.put(prod.Id,prod.Name);  
                    mapProductGroup.put(prod.Id,String.ValueOf(prod.Product_Group__c));                   
                }   
            } 
                                         
            for (sobject sObj : trgCtx.newList){                      
                // Add the Record to the List - prodQualList   
                Product_Qualification__c prdQualRecord = new Product_Qualification__c();                
                Qualification_Products_List__c qualProductList = (Qualification_Products_List__c)sObj;                         
                prdQualRecord.Id = qualProductList.Product_Qualification__c;               
                prdQualRecord.Product_Commercial_Name__c = qualProductList.Commercial_Name__c;               
                prdQualRecord.Product_Name__c = mapProductName.get(qualProductList.Product__c);
                prdQualRecord.Source_Location__c = mapABBIDAndCountry.get(qualProductList.ABB_Location__c); 
                prdQualRecord.Product_Group__c = mapProductGroup.get(qualProductList.Product__c);  
                prdQualRecord.Business_Unit_name__c = qualProductList.Business_Unit__c;   
                prdQualRecord.Division__c = qualProductList.Division__c;                  
                toUpdateProdQualList.add(prdQualRecord);  
            }                                                                              
            //update the Product Qualification
            if(toUpdateProdQualList != NULL && toUpdateProdQualList.size() > 0){                                                      
                Database.update(toUpdateProdQualList); 
            }                                                                                               
        } 
      
        if (trigger.isDelete) { 
        
            Set<String> setProductQualificationId = new Set<String>();
            List<Product_Qualification__c> toUpdateProductQual = new List<Product_Qualification__c>();
            
            for (sobject sObj : trgCtx.oldList) {
                Qualification_Products_List__c qualProductList = (Qualification_Products_List__c)sObj;    
                
                if (qualProductList.Product_Qualification__c != NULL ){
                   
                    Product_Qualification__c prdNew = new Product_Qualification__c();
                    prdNew.Id = qualProductList.Product_Qualification__c;
                    prdNew.Product_Group__c = null;
                    prdNew.Product_Name__c = null;
                    prdNew.Business_Unit_name__c = null;
                    prdNew.Division__c = null;
                    prdNew.Product_Commercial_Name__c = null;
                    prdNew.Source_Location__c = null;
                    toUpdateProductQual.add(prdNew);                    
                }  
            }
            
            if(toUpdateProductQual != NULL && toUpdateProductQual.size()>0){
                Database.Update(toUpdateProductQual);
            }
            
        }
                     
     } 
 
    
 }