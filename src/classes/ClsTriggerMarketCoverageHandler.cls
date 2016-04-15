/**   
* TriggerClass on the Joint_Business_Plan__c object to
    1. To populate the Joint Business Plan currency
*       
* Release - R5 
 *  
 * @author  - Vasanthi (Accenture)
 * @created - 2016-3-7
 * @version - 1.0
 * @Description -To populate the Joint Business Plan currency
   
* - Created
*/
public without sharing class ClsTriggerMarketCoverageHandler extends ClsTriggerVirtual {
  
   
/**
* @see bulkBefore
*/   
    public override void bulkBefore(ClsWrappers.TriggerContext trgCtx) {
        if (trgCtx.isInsert) {
            assingnCurrency (trgCtx);           
        }
        
        if (trgCtx.IsDelete) {
            deleteValidation(trgCtx);
        } 
    }
    
    
     
        /**
    To prevent deletion when the account plan status is closed
    */
     Public void deleteValidation(ClsWrappers.TriggerContext trgCtx){
         ID sysAdminProfileId = Label.CL00075;
         for (Joint_Business_Plan_Market_Coverage__c con : (List<Joint_Business_Plan_Market_Coverage__c>) trgCtx.oldList) {             
             if (sysAdminProfileId != Userinfo.getProfileid() && con.Channel_Partner_Business_Plan_Status__c== Label.Closed ) {
                 con.addError(Label.Business_Visit_Report_Business_Plan_Error); //You cannot save the changes - Channel Partner Business Plan is Closed/Obsolete.
             }
         }        
     }
     
/**    
  * Req #1960 (Update Joint Business Plan currency to Market Coverage).     
*/  
    public void assingnCurrency(ClsWrappers.TriggerContext trgCtx) {
        
        Set<Id> parentIdSet = new Set<Id>();
        
        for (Sobject sobj : trgCtx.newList) {
            Joint_Business_Plan_Market_Coverage__c sobjJBP = (Joint_Business_Plan_Market_Coverage__c)sObj;
            parentIdSet.add(sobjJBP.Joint_Business_Plan__c);
        }
        
        if (parentIdSet.size() > 0) {
            
            Integer limitRows = Limits.getLimitQueryRows() - Limits.getQueryRows();
            Map<Id, Joint_Business_Plan__c> jointBusPlanMap = new Map<Id, Joint_Business_Plan__c> ([ SELECT Id, CurrencyISOCode FROM Joint_Business_Plan__c WHERE Id IN :parentIdSet LIMIT :limitRows ] );
            
            for (Sobject sobj : trgCtx.newList) {
                Joint_Business_Plan_Market_Coverage__c sobjJBP = (Joint_Business_Plan_Market_Coverage__c )sObj;
                sobjJBP.CurrencyISOCode = jointBusPlanMap.get(sobjJBP.Joint_Business_Plan__c).CurrencyISOCode;
            }
        }
    }
}