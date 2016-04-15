/**   
* TriggerClass ClsTriggerCompetitorProdQual
* Concatenate all the Account Name in Competitor      
* Release R4
*  
* @author  Abiramasundari Radha (Accenture)
* @created 2015-09-10
* @version 1.0
*
* - Created
*/
public without sharing class ClsTriggerCompetitorProdQual extends ClsTriggerVirtual {

/**
* @see IntHelper.beforeTrigger
*/   
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {  
        checkTargetEndDate(trgCtx);      
        deleteCompetitorCheck(trgCtx);                  
    }
    
/**

* @see IntHelper.afterTrigger
*/   
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {        
        concatenateAccountName(trgCtx);                  
    }

/**  
Method : checkTargetEndDate - Shows an exception If the product qualification Target end date is past date
@author  Abiramasundari Radha (Accenture)
*/ 
 @TestVisible 
        private void checkTargetEndDate(ClsWrappers.TriggerContext trgCtx) {       
            Set<String> setProdQual = new Set<String>();            
            Date todayDate = System.today();       
            if (trgCtx.isInsert || trgCtx.isUpdate) {                
                // GET Product Qualification Level RECORD INTO THE LIST
                for (sobject sObj : trgCtx.newList) {                                                  
                    // Add the Record to the List - prodQualList     
                    Competitor_Product_Qualification__c prdQualLevel = (Competitor_Product_Qualification__c)sObj;   
                    
                    if (prdQualLevel.Product_Qualification__c != NULL){       
                        setProdQual.add(prdQualLevel.Product_Qualification__c);
                    }                    
                    if (setProdQual != NULL && setProdQual.size() > 0 ) {
                        for (Product_Qualification__c prd : [SELECT ID, Name,Target_End_Date__c FROM Product_Qualification__c 
                            WHERE ID IN: setProdQual LIMIT 10000]){
                            if(prd.Target_End_Date__c < todayDate){
                                prdQualLevel.adderror('The Product Qualification Target End Date cannot be entered as a past date');                        
                            }            
                        }                
                    }    
                }
            }
        }
    
    
    /*     
Method : Concatenate all the Account Name and Update in Product Qualification
@author  Abiramasundari Radha (Accenture)

*/ 
    @TestVisible 
    private void concatenateAccountName(ClsWrappers.TriggerContext trgCtx) { 
        
        Set<String> setProductQualificationId = new Set<String>();   
        MAP <ID,Product_Qualification__c> mapProdQualHeader = new Map <ID,Product_Qualification__c>();
        
        if (trgCtx.isInsert || trgCtx.isUpdate ) {           
            for (sobject sObj : trgCtx.newList) {                           
                // Add the Record to the List - prodQualList     
                Competitor_Product_Qualification__c compPrdQual = (Competitor_Product_Qualification__c)sObj;    
                if (compPrdQual.Product_Qualification__c != NULL ){
                    setProductQualificationId.add(compPrdQual.Product_Qualification__c);                                                         
                }
            } 
        }
        
      if (trigger.isDelete) { 
            for (sobject sObj : trgCtx.oldList) {
                Competitor_Product_Qualification__c compPrdQual = (Competitor_Product_Qualification__c)sObj;    
                if (compPrdQual.Product_Qualification__c != NULL ){

                     setProductQualificationId.add(compPrdQual.Product_Qualification__c);         
               }
            }
        } 
      
        for(Product_Qualification__c prodQual:[Select Id,Competitor_Account_Name__c FROM Product_Qualification__c WHERE Id IN : setProductQualificationId LIMIT 50000]){
            prodQual.Competitor_Account_Name__c=NULL;
            mapProdQualHeader.put(prodQual.Id,prodQual);
        }
        
        for(Competitor_Product_Qualification__c compProdQual : [Select Id,Account__r.Name,Account__c,Product_Qualification__c 
                FROM Competitor_Product_Qualification__c WHERE Product_Qualification__c IN : setProductQualificationId AND Account__r.Name != null  LIMIT 50000]){
                 
                if(mapProdQualHeader.get(compProdQual.Product_Qualification__c).Competitor_Account_Name__c == NULL)
                {
                        mapProdQualHeader.get(compProdQual.Product_Qualification__c).Competitor_Account_Name__c = compProdQual.Account__r.Name;
                }
                else if(mapProdQualHeader.get(compProdQual.Product_Qualification__c).Competitor_Account_Name__c != NULL)
                {
                        mapProdQualHeader.get(compProdQual.Product_Qualification__c).Competitor_Account_Name__c += Label.System_CL00046 + compProdQual.Account__r.Name;
                }else{}
        }
        
        for(Product_Qualification__c prodRows:mapProdQualHeader.values()){
         String strName1 = null;
         String strName2 = null;
         Product_Qualification__c iProdQual = prodRows;
         
         if(iProdQual.Competitor_Account_Name__c != NULL && iProdQual.Competitor_Account_Name__c.lastIndexOf(Label.System_CL00046) >= 0  ){
             strName1 = iProdQual.Competitor_Account_Name__c.subString(0,iProdQual.Competitor_Account_Name__c.lastIndexOf(Label.System_CL00046));
             strName2 = iProdQual.Competitor_Account_Name__c.subString(iProdQual.Competitor_Account_Name__c.lastIndexOf(Label.System_CL00046)+1);
             
             iProdQual.Competitor_Account_Name__c = strName1 + Label.System_CL00046 + strName2;
             mapProdQualHeader.put(prodRows.Id,iProdQual);
         }
       }         
               Database.Update(mapProdQualHeader.values());                     
    }   
  
/*     
* Method : To check the Initiative Status  value in Product Qulaification
* If the Product Qulaification Initiative Status is closed then it will not allow the user to delete Competitor
* @author  Abiramasundari Radha (Accenture)

*/   
    @TestVisible 
    private void deleteCompetitorCheck(ClsWrappers.TriggerContext trgCtx) { 
        Set<String> setProductQualificationId = new Set<String>();   
        ID sysAdminProfileId = Label.CL00075;
        if (trigger.isDelete) { 
            for (sobject sObj : trgCtx.oldList) {
                Competitor_Product_Qualification__c compPrdQual = (Competitor_Product_Qualification__c)sObj;    
                if (compPrdQual.Product_Qualification__c != NULL ){
                    setProductQualificationId.add(compPrdQual.Product_Qualification__c); 
                }
                                 
                //for(Product_Qualification__c cmpQual : [SELECT ID, Name, Initiative_Status__c FROM Product_Qualification__c WHERE Id IN: setProductQualificationId Limit 10000]){                                
                if(sysAdminProfileId  != Userinfo.getProfileid() && compPrdQual.Product_Qualification_Status__c == Label.Closed){    
                    compPrdQual.addError(Label.System_CL00092);    //CL00092 => You cannot save the changes as Product Qualification Status is Closed.                                               
                }   
            }
        }                        
    }    
}