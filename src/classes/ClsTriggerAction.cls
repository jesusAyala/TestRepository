/**
 * TriggerClass -  ClsTriggerAction
 * Release R5
 * @author  Vasanthi M(Accenture)
 * @created 2016-03-08
 * @version 1.0
 * Created 
 */
  
public without sharing class ClsTriggerAction extends ClsTriggerVirtual {

    /**
* @see IntHelper.beforeTrigger
*/  
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {               
       
        if (trgCtx.IsDelete) {
            deleteValidation(trgCtx);
        }                   
    }
    
    
        /**
    To prevent deletion when the account plan status is closed
    */
     Public void deleteValidation(ClsWrappers.TriggerContext trgCtx){
         ID sysAdminProfileId = Label.CL00075;
         for (Actions__c con : (List<Actions__c>) trgCtx.oldList) {             
             if (sysAdminProfileId != Userinfo.getProfileid() && con.Account_Plan_Status__c == Label.Closed ) {
                 con.addError(Label.Cannot_Save_Changes_Account_Plan_R5); //You cannot save the changes as Account Plan Status is Closed.
             }
         }        
     }
}