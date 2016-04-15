/**
 * TriggerClass -  ClsTriggerCompetitors
 * Release R5
 * @author  Vasanthi M(Accenture)
 * @created 2016-03-17
 * @version 1.0
 * Created 
 */
  
public without sharing class ClsTriggerCompetitors extends ClsTriggerVirtual {

    
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
         for (Competitors__c con : (List<Competitors__c>) trgCtx.oldList) {  
             if (sysAdminProfileId != Userinfo.getProfileid() && con.Channel_Partner_Business_Plan_Status__c == Label.Closed ) {
                 con.addError(Label.Business_Visit_Report_Business_Plan_Error); //You cannot save the changes - Channel Partner Business Plan is Closed/Obsolete.
             } 
         }  
              
     }
 }