/**   
* TriggerClass on the Budget object to automatically populate BU and DIV based on PG
*       
* Release R5
*  
* @author  Indhu Selvi Ramalingam (Accenture)
* @created 2015-11-21
* @version 1.0
*
* - Created
*/
public without sharing class ClsTriggerBudget extends ClsTriggerVirtual {
     
     Set<Id> adminUserIdSet = new Set<Id>();
    
    /**
     * constructor
    */
    public ClsTriggerBudget() {
        
        Map<Id, User> adminUserMap = new Map<Id, User> ([ SELECT Id, Name FROM User WHERE Profile.Name =: Label.Sys_Admin_Profile_Name AND IsActive = TRUE LIMIT 50000]);
        adminUserIdSet.addAll(adminUserMap.KeySet());
    } 
        
   /**
* @see IntHelper.beforeTrigger
*/  
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {        
        assignProductGroupValues(trgCtx);   
        if (trgCtx.IsDelete) {
            deleteValidation(trgCtx);
        }                 
    } 
    
      /**
* @see IntHelper.afterTrigger
*/   
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {        
        concatenateDIV(trgCtx);                
    }
    
        
        /**
    To prevent deletion when the account plan status is closed
    */
     Public void deleteValidation(ClsWrappers.TriggerContext trgCtx){
         
         for (Budget__c con : (List<Budget__c>) trgCtx.oldList) {             
             if (!adminUserIdSet.contains(UserInfo.getUSerId()) && con.Account_Plan_Status__c == Label.Closed ) {
                 con.addError(Label.Cannot_Save_Changes_Account_Plan_R5);
             }
         }        
     }

/**
* Assign the value to BU , DIV, Product Name / Product Group from the selected Product/Product Group
*/      
    @TestVisible 
    private void assignProductGroupValues(ClsWrappers.TriggerContext trgCtx) {    
        String productGroupId = null;
        String businessUnit = null;
        String division = null;
        String productName = null;
        Set<String> setProductId = new Set<String>(); 
        Set<String> setProductGroupId = new Set<String>(); 
        String productGroupValue = null;
        Map<Id, String> mapProductGroup = new Map<Id, String>(); 
        Map <ID, Product2> productMap = new Map<Id, Product2> ();
        Map <ID, Product_Group__c> productGroupMap = new Map<Id, Product_Group__c> ();
        Map <String, Product_Group__c> productGroupNameAndPGMap = new Map<String, Product_Group__c> ();
        Set<String> setProductName = new Set<String>();
        Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows(); 
        if (trgCtx.isInsert || trgCtx.isUpdate) {

            for (sobject sObj : trgCtx.newList) {                   
                // Add the Record to the List - budget     && sobjBudget.Product__r.Product_Group__c != NULL 
                Budget__c sobjBudget = (Budget__c) sObj;   
                Budget__c oldBudget  = (trgCtx.isUpdate) ? (Budget__c)trgCtx.oldMap.get(sObj.ID) : NULL; 
                
                if (trgCtx.isUpdate) {
                
                    if (sobjBudget.Business_Unit__c != oldBudget.Business_Unit__c && sobjBudget.Business_Unit__c == NULL) {
                        sobjBudget.Segment_Level__c = 'Division';
                    }
                    
                    if (sobjBudget.Product_Group__c != oldBudget.Product_Group__c && sobjBudget.Product_Group__c == NULL) {
                    
                        sobjBudget.Segment_Level__c = (sobjBudget.Business_Unit__c != NULL) ? 'Business Unit' : 'Division';
                    }
                }
                
                if ((sobjBudget.Product__c != NULL || sobjBudget.Product_Group__c != Null) && (trgCtx.isInsert || ( trgCtx.isUpdate && (sobjBudget.Business_Unit__c != oldBudget.Business_Unit__c|| sobjBudget.Division__c != oldBudget.Division__c ||
                    sobjBudget.Product__c != oldBudget.Product__c || sobjBudget.Product_Group__c != oldBudget.Product_Group__c)))){                                    
                    if (sobjBudget.Product__c != NULL) setProductId.add(sobjBudget.Product__c); 
                    if (sobjBudget.Product_Group__c != NULL) setProductGroupId.add(sobjBudget.Product_Group__c);
                }
            }
            
            if (setProductId.size() > 0) {
                productMap = new Map<Id, Product2> ([SELECT Id, Name,Product_Group__c FROM Product2 WHERE ID IN: setProductId AND Product_Group__c != NULL LIMIT :remLimit]);
                for (Product2 prod: productMap.Values()) {
                    setProductName.add(String.ValueOf(prod.Product_Group__c));
                }
            }
            
            if (setProductGroupId.size() > 0 || setProductName.size() > 0) {
                productGroupMap = new Map<Id, Product_Group__c > ([ SELECT ID, Name, Business_Unit__c, Business_Unit_Name__c,Division__c
                            FROM Product_Group__c WHERE ID IN :setProductGroupId OR Name IN :setProductName LIMIT :remLimit]); 
                for (Product_Group__c prod: productGroupMap.Values()) {
                    productGroupNameAndPGMap.put(prod.Name, prod);
                }
                
            }
            
                       
            for (sobject sObj : trgCtx.newList) {    
                
                Budget__c sobjBudget = (Budget__c) sObj;
               
                if (sobjBudget.Product__c != NULL && productMap.containskey(sobjBudget.Product__c) && 
                            productGroupNameAndPGMap.containsKey(String.valueOf(productMap.get(sobjBudget.Product__c).Product_Group__c))) {
                    
                    Product_Group__c pg = productGroupNameAndPGMap.get(String.valueOf(productMap.get(sobjBudget.Product__c).Product_Group__c));               
                    sobjBudget.Business_Unit__c  = pg.Business_Unit__c;
                    
                    if (pg.Business_Unit_Name__c != '' && pg.Business_Unit_Name__c != NULL) {
                        sobjBudget.Business_Unit__c = (sobjBudget.Business_Unit__c == null) ? '': sobjBudget.Business_Unit__c;
                        sobjBudget.Business_Unit__c += ' - ' + pg.Business_Unit_Name__c;
                    }
                    
                    sobjBudget.Division__c  = pg.Division__c;
                    sobjBudget.Product_Group__c = pg.Id;
                    
                } else if (sobjBudget.Product__c == NULL && sobjBudget.Product_Group__c != NULL && productGroupMap.containskey(sobjBudget.Product_Group__c)) {
                    
                    sobjBudget.Business_Unit__c = productGroupMap.get(sobjBudget.Product_Group__c).Business_Unit__c;
                    if (productGroupMap.get(sobjBudget.Product_Group__c).Business_Unit_Name__c != '' && productGroupMap.get(sobjBudget.Product_Group__c).Business_Unit_Name__c != NULL) {
                        sobjBudget.Business_Unit__c = (sobjBudget.Business_Unit__c == null) ? '': sobjBudget.Business_Unit__c;
                        sobjBudget.Business_Unit__c += ' - ' + productGroupMap.get(sobjBudget.Product_Group__c).Business_Unit_Name__c;
                    }
                    sobjBudget.Division__c = productGroupMap.get(sobjBudget.Product_Group__c).Division__c;
                }else{}
                
                //system.debug('::::sobjBudget::'+sobjBudget);
                
                sobjBudget.Unique_Check__c = (sobjBudget.Division__c != NULL) ? sobjBudget.Division__c: '';
                sobjBudget.Unique_Check__c += (sobjBudget.Business_Unit__c != NULL) ? sobjBudget.Business_Unit__c: '';
                
                if (sobjBudget.Product_Group__c != NULL) {
                    sobjBudget.Unique_Check__c += sobjBudget.Product_Group__c ;
                }
                if (sobjBudget.Product__c != NULL) {
                    sobjBudget.Unique_Check__c += sobjBudget.Product__c;
                }
                sobjBudget.Unique_Check__c += (sobjBudget.Account_Plan__c != NULL) ? sobjBudget.Account_Plan__c: '';
                sobjBudget.Unique_Check__c += (sobjBudget.Account_Plan_Year__c != NULL) ? String.valueOf(sobjBudget.Account_Plan_Year__c): '';
                
                if ( sobjBudget.Segment_Level__c != NULL) sobjBudget.Unique_Check__c += sobjBudget.Segment_Level__c;
                //sobjBudget.Unique_Check__c += (sobjBudget.Start_Date__c != NULL) ? String.valueOf(sobjBudget.Start_Date__c): '';
               // sobjBudget.Unique_Check__c += (sobjBudget.End_Date__c != NULL) ? String.valueOf(sobjBudget.End_Date__c): '';
            }
        }
    }
        /*     
Method : Concatenate all the DIV and Update in Account Plan
@author  Indhu Selvi Ramalingam (Accenture)

*/ 
         @TestVisible 
        private void concatenateDIV(ClsWrappers.TriggerContext trgCtx) { 
            
            Set<String> setAccPlanId = new Set<String>();   
            MAP <ID,Account_Plan__c> mapAccPlanHeader = new Map <ID,Account_Plan__c>();
            List<Budget__c> budgetList = new List<Budget__c>();
            
            if (trgCtx.isInsert || trgCtx.isUpdate ) {           
                for (sobject sObj : trgCtx.newList) {                           
                    // Add the Record to the List   
                    Budget__c compBudget = (Budget__c)sObj;   
                    Budget__c oldBudget  = (trgCtx.isUpdate) ? (Budget__c)trgCtx.oldMap.get(sObj.ID) : NULL; 
                                  
                    if ((trgCtx.isInsert || ( trgCtx.isUpdate && (compBudget.Account_Plan__c != oldBudget.Account_Plan__c || compBudget.Product__c != oldBudget.Product__c ||
                     compBudget.Division__c != oldBudget.Division__c || compBudget.Product_Group__c != oldBudget.Product_Group__c || compBudget.Business_Unit__c != oldBudget.Business_Unit__c)) ) && compBudget.Account_Plan__c != NULL  ){
                        setAccPlanId.add(compBudget.Account_Plan__c);  
                    }
                } 
            }
            
            if (trigger.isDelete) { 
                for (sobject sObj : trgCtx.oldList) {
                    Budget__c compBudget = (Budget__c)sObj;    
                    if (compBudget.Account_Plan__c != NULL ){
                        setAccPlanId.add(compBudget.Account_Plan__c);
                    }
                }
            } 
           
            if (setAccPlanId.size() > 0) {
                
                Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
                  
                for(Budget__c compProdQual : [Select Id, Product__r.Name, PRoduct_Group__r.NAme, Business_Unit__c, Account_Plan__r.DIV__c, Product__c, Account_Plan__c, Division__c 
                        FROM Budget__c WHERE Account_Plan__c IN : setAccPlanId AND (Division__c != null OR Business_Unit__c != NULL) LIMIT :remLimit ]) {
                                             
                         
                    if(!mapAccPlanHeader.containsKey(compProdQual.Account_Plan__c)) {
                        
                        Account_Plan__c acp = compProdQual.Account_Plan__r;
                        acp.DIV__c = (compProdQual.Division__c != NULL && compProdQual.Division__c != '') ? compProdQual.Division__c : '';
                        acp.PG__c = '';
                        acp.Product_Lines__c = '';
                        acp.BU__c = '';
                        
                        if (compProdQual.Business_Unit__c != NULL && compProdQual.Business_Unit__c != '') {
                            
                            acp.BU__c = compProdQual.Business_Unit__c;
                            if (compProdQual.Business_Unit__c.contains(Label.CL0003) ){
                                List<String> listBUShortName = compProdQual.Business_Unit__c.Split(Label.CL0003); //Label.CL0003 => -
                                acp.BU__c = listBUShortName[0].trim(); 
                            }
                        }
                        
                      
                        if (compProdQual.Product_Group__c != NULL) {
                            acp.PG__c = compProdQual.Product_Group__r.Name;
                        }
                        
                        if (compProdQual.Product__c != NULL) {
                            acp.Product_Lines__c= compProdQual.Product__r.Name;
                        }
                       
                        
                        mapAccPlanHeader.put(compProdQual.Account_Plan__c, acp);
                    } else {
                        
                        Account_Plan__c acp = mapAccPlanHeader.get(compProdQual.Account_Plan__c);
                        if (compProdQual.Division__c != NULL && compProdQual.Division__c != '') {
                            
                            String mapDivValues = (acp.DIV__c != NULL) ? acp.DIV__c : '';
                            
                            if(mapDivValues.contains(Label.System_CL00046)){
                                List<String> SplittedDivValues= mapDivValues.split(Label.System_CL00046); //Label.System_CL00046=>;
                                Set<String> setDivValues = new Set<String>();
                                
                                setDivValues.addAll(SplittedDivValues);
                                
                                if(!setDivValues.Contains(compProdQual.Division__c)){
                                    
                                     mapAccPlanHeader.get(compProdQual.Account_Plan__c).DIV__c += Label.System_CL00046 + compProdQual.Division__c;  
                                }
                            }else {
                                
                                if(!mapDivValues.contains(compProdQual.Division__c)){
                                
                                    if (acp.DIV__c != NULL && acp.DIV__c != '') {
                                        mapAccPlanHeader.get(compProdQual.Account_Plan__c).DIV__c += Label.System_CL00046;
                                    }
                                    mapAccPlanHeader.get(compProdQual.Account_Plan__c).DIV__c += compProdQual.Division__c;
                                }
                            }      
                        }
                        
                        if (compProdQual.Product_Group__c != NULL) {
                            
                            String mapDivValues = (acp.PG__c != NULL && acp.PG__c != '') ? acp.PG__c : '';
                            
                            if (mapDivValues == '') {
                                 mapAccPlanHeader.get(compProdQual.Account_Plan__c).PG__c = compProdQual.Product_Group__r.NAme;
                            } else {
                            
                                if(mapDivValues.contains(Label.System_CL00046)){
                                    List<String> splittedDivValues= mapDivValues.split(Label.System_CL00046); //Label.System_CL00046 => ;
                                    Set<String> setDivValues = new Set<String>();
                                    
                                    setDivValues.addAll(splittedDivValues);
                                    
                                    if(!setDivValues.Contains(compProdQual.Product_Group__r.NAme)){
                                         mapAccPlanHeader.get(compProdQual.Account_Plan__c).PG__c += Label.System_CL00046 + compProdQual.Product_Group__r.NAme;  
                                    }
                                }else{
                                    if(!mapDivValues.contains(compProdQual.Product_Group__r.NAme)){
                                        mapAccPlanHeader.get(compProdQual.Account_Plan__c).PG__c += Label.System_CL00046 + compProdQual.Product_Group__r.NAme;
                                    }
                                } 
                            }     
                        }
                            
                        if (compProdQual.Product__c != NULL) {
                        
                            String mapDivValues = (acp.Product_Lines__c != NULL && acp.Product_Lines__c != '') ? acp.Product_Lines__c: '';
                            if (mapDivValues == '') {
                                 mapAccPlanHeader.get(compProdQual.Account_Plan__c).Product_Lines__c = compProdQual.Product__r.NAme;
                            } else {
                                if(mapDivValues.contains(Label.System_CL00046)){
                                    List<String> splittedDivValues= mapDivValues.split(Label.System_CL00046);
                                    Set<String> setDivValues = new Set<String>();
                                    
                                    setDivValues.addAll(splittedDivValues);
                                    
                                    if(!setDivValues.Contains(compProdQual.Product__r.NAme)){
                                         mapAccPlanHeader.get(compProdQual.Account_Plan__c).Product_Lines__c += Label.System_CL00046 + compProdQual.Product__r.NAme;  
                                    }
                                }else{
                                    if(!mapDivValues.contains(compProdQual.Product__r.NAme)){
                                        mapAccPlanHeader.get(compProdQual.Account_Plan__c).Product_Lines__c += Label.System_CL00046 + compProdQual.Product__r.NAme;
                                    }
                                }
                            }     
                        }
                        
                        if (compProdQual.Business_Unit__c != NULL && compProdQual.Business_Unit__c != '') {
                            
                            String mapBUValues = (acp.BU__c != NULL) ? acp.BU__c : '';
                            
                            String bu = compProdQual.Business_Unit__c;
                            
                            if (compProdQual.Business_Unit__c.contains(Label.CL0003)) {
                                bu = compProdQual.Business_Unit__c.Split(Label.CL0003).get(0).trim(); //Label.CL0003 => -
                            }
                            
                            if(mapBUValues.contains(Label.System_CL00046)){
                                List<String> splittedBUValues= mapBUValues.split(Label.System_CL00046); //Label.System_CL00046 => ;
                                Set<String> setBUValues = new Set<String>();
                                
                                setBUValues.addAll(splittedBUValues);
                                
                                if(!setBUValues.Contains(bu)){
                                     mapAccPlanHeader.get(compProdQual.Account_Plan__c).BU__c += Label.System_CL00046 + bu;  
                                }
                            }else{
                            
                                if(!mapBUValues.contains(bu)){
                                    if (acp.BU__c != NULL && acp.BU__c != '') {
                                        mapAccPlanHeader.get(compProdQual.Account_Plan__c).BU__c += Label.System_CL00046;
                                    }
                                    mapAccPlanHeader.get(compProdQual.Account_Plan__c).BU__c += bu;
                                }
                            }      
                        }
                    }
                }
                        
                for (Id accPlanId : setAccPlanId) {
                    
                    if (!mapAccPlanHeader.containsKey(accPlanId)) {
                        mapAccPlanHeader.put(accPlanId, new Account_Plan__c ( Id = AccPlanId, BU__c = '', DIV__c = '', PG__c = '', Product_Lines__c = ''));
                    }
                }
                
                try {
                    
                   
                    if (mapAccPlanHeader.size() > 0) Database.Update(mapAccPlanHeader.values());    
                }  Catch (DMLException e) {   
                    
                    List<Sobject> objList = (trgCtx.isdelete) ? trgCtx.oldList : trgCtx.newList;
            
                    String error = '';
                    
                    for (Integer i=0; i < e.getNumDML(); i++) {
                        error += e.getDmlMessage(i) + Label.Line_Break;
                        //system.debug(':::'+e.getDmlFieldNames(i));
                    }
                    for (Sobject obj: objList) {                
                        Budget__c qtm = (Budget__c ) obj;
                        qtm.addError(error, false);            
                    }            
                }
            }         
       }        
               
}