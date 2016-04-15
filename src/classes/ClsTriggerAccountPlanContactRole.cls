/**   
* TriggerClass on the Account Plan Contact Role object to automatically populate ABB Perspective Role field based on the contact selected.
* As part of Req- 1708     
* Release R5
*  
* @author  Ayiravalli Arasu (Accenture)
* @created 2016-02-02
* @version 1.0
*
* - Created
*/
public without sharing class ClsTriggerAccountPlanContactRole extends ClsTriggerVirtual{

        
/**
* @see IntHelper.beforeTrigger
*/  
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {               
        if (trgCtx.isInsert) {
            accountPlanContactRoleRecords(trgCtx);   
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
         for (Contact_Roles__c con : (List<Contact_Roles__c>) trgCtx.oldList) {
             
             if (sysAdminProfileId  != UserInfo.getProfileId() && con.Account_Plan_Status__c == Label.Closed ) {
                 con.addError(Label.Cannot_Save_Changes_Account_Plan_R5);
             }
         }
        
     }

/**
Method: accountPlanContactRoleRecords
Description: Method will display the selected contact's ABB Perspetive Role in Account Plan contact Role(object)-ABB Perspective Role (field)
*/
    Public void accountPlanContactRoleRecords(ClsWrappers.TriggerContext trgCtx){
           Set<Id> setContactId = new Set<Id>();
           Map<Id, String> mapContactPerspectiveRole = new Map<Id, String>();
           Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
        
           for (sobject so :trgCtx.newList){
                Contact_Roles__c sobjAccPlanContactRole = (Contact_Roles__c)so;
                
                if(sobjAccPlanContactRole.Contact__c != Null){
                    setContactId.add(sobjAccPlanContactRole.Contact__c);
                }
           }         
          if(setContactId.size() > 0){ 
              for(Contact cont : [SELECT ID,ABB_Perspective_Role__c FROM Contact WHERE Id IN :setContactId LIMIT :remLimit]){
                  mapContactPerspectiveRole.put(cont.ID,cont.ABB_Perspective_Role__c);
              }
          }         
          for (sobject so :trgCtx.newList) {          
              Contact_Roles__c sobjAccPlanContactRole = (Contact_Roles__c)so;
              
              if(sobjAccPlanContactRole.Contact__c != Null && mapContactPerspectiveRole.containsKey(sobjAccPlanContactRole.Contact__c)){
                  sobjAccPlanContactRole.ABB_Perspective_Role__c = mapContactPerspectiveRole.get(sobjAccPlanContactRole.Contact__c);                
              }
          } 
    }   
}