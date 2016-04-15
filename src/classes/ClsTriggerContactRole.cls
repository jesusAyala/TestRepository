/**   
* TriggerClass ClsTriggerContactRole
* To check the Initiative Status value       
* Release R4
*  
* @author  Abiramasundari Radha (Accenture)
* @created 2015-09-22
* @version 1.0
*
* - Created
*/
public without sharing class ClsTriggerContactRole extends ClsTriggerVirtual {
   
/**
* @see IntHelper.beforeTrigger
*/   
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {        
        deleteContactRole(trgCtx);                  
    }
        
/*     
* Method : To check the Initiative Status  value in Product Qulaification
* If the Product Qulaification Initiative Status is closed then it will not allow the user to delete Contact Role
* @author  Abiramasundari Radha (Accenture)
*/    
    @TestVisible 
    private void deleteContactRole(ClsWrappers.TriggerContext trgCtx) { 
    
        Set<String> setProductQualificationId = new Set<String>();  
        ID sysAdminProfileId = Label.CL00075;
         
        if (trigger.isDelete && trigger.isBefore) { 
            for (sobject sObj : trgCtx.oldList) {
                Contact_Role__c contRole = (Contact_Role__c)sObj;    
               
                 //Id systemAdminProfileId = Userinfo.getProfileid();               
                //for(Product_Qualification__c cmpQual : [SELECT ID, Name, Initiative_Status__c FROM Product_Qualification__c WHERE Id IN: setProductQualificationId Limit 10000]){                                
                 if(sysAdminProfileId != Userinfo.getProfileid() && contRole.Product_Qualification_Status__c == Label.Closed ){    
                        contRole.addError(Label.System_CL00092);  //CL00092 => You cannot save the changes as Product Qualification Status is Closed.                                                 
                    }                   
                }
            }
        }                        
        
    }