/**
 * TriggerClass -  ClsTriggerJointBusinessPlanContactRole 
 * Release R5
 * @author  Vasanthi M(Accenture)
 * @created 2016-03-17
 * @version 1.0
 * Created 
 */
  
public without sharing class ClsTriggerJointBusinessPlanContactRole extends ClsTriggerVirtual {

     Integer remLimit; 
   
    /**
* @see IntHelper.beforeTrigger
*/  
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {               
       
        if (trgCtx.IsDelete) {
            deleteValidation(trgCtx);
        }                   
    }   
    
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {               
       
        if (trgCtx.IsInsert) {
           createRoleRecords(trgCtx);
        } 
        
        if (trgCtx.IsUpdate) {
           updateRoleRecords(trgCtx);
        }                   
    }  
    
    public void updateRoleRecords(ClsWrappers.TriggerContext trgCtx) {
        
        Set<Id> contactRoleIdSet = new Set<Id>();
        Map<ID, Joint_Business_Plan_Contact_Role__c> jbpRoleMap = new Map<Id, Joint_Business_Plan_Contact_Role__c>();
        for (Joint_Business_Plan_Contact_Role__c con : (List<Joint_Business_Plan_Contact_Role__c>) trgCtx.newList) {
            Joint_Business_Plan_Contact_Role__c oldRole = (Joint_Business_Plan_Contact_Role__c) trgCtx.oldMap.get(con.Id);
            
            if (con.Product_Lines__c != oldRole.Product_Lines__c) {
                contactRoleIdSet.add(con.Id);
                jbpRoleMap.put(con.Id, con);
            }
        }
        
        if (contactRoleIdSet.size() > 0) {
             
             List<Contact_Information_Channel_Business_Rev__c> infoList = [ SELECT Id,Product_Lines_form_ContactRole__c,Channel_Partner_Contact_Roles__c   FROM Contact_Information_Channel_Business_Rev__c 
                 WHERE Channel_Partner_Contact_Roles__c IN :contactRoleIdSet];
             
             for (Contact_Information_Channel_Business_Rev__c rev: infoList ) {
                 rev.Product_Lines_form_ContactRole__c = jbpRoleMap.get(rev.Channel_Partner_Contact_Roles__c ).Product_Lines__c;
             }
             
             try {
                 if (infoList.size() > 0) update infoList ;
             }Catch(DMLException e) {
                  for (Joint_Business_Plan_Contact_Role__c con : (List<Joint_Business_Plan_Contact_Role__c>) trgCtx.newList) {
                      con.addError(e.getDMLMessage(0));
                  }
             }
             
         }    
    }
    
    public void createRoleRecords(ClsWrappers.TriggerContext trgCtx) {
         
         List<Contact_Information_Channel_Business_Rev__c> insertList = new List<Contact_Information_Channel_Business_Rev__c>();
         Map<Id, List<Joint_Business_Plan_Contact_Role__c >> contactRoleMap = new  Map<Id, List<Joint_Business_Plan_Contact_Role__c >>();
         
         for (Joint_Business_Plan_Contact_Role__c con : (List<Joint_Business_Plan_Contact_Role__c>) trgCtx.newList) {
             
             if (!contactRoleMap.containsKey(con.Joint_Business_Plan__c)) {
                 contactRoleMap.put(con.Joint_Business_Plan__c, new List<Joint_Business_Plan_Contact_Role__c >());
             }
             contactRoleMap.get(con.Joint_Business_Plan__c).add(con);
         }
         
         if (contactRoleMap.size() > 0) {
             
             for (Channel_Business_Review__c rev: [ SELECT Id, Joint_Business_Plan__c FROM Channel_Business_Review__c WHERE Joint_Business_Plan__c IN: contactRoleMap.keyset() LIMIT 50000]) {
                 
                 for ( Joint_Business_Plan_Contact_Role__c role: contactRoleMap.get(rev.Joint_Business_Plan__c) ) {
                     
                     insertList.add( new Contact_Information_Channel_Business_Rev__c(
                         Channel_Partner_Business_Review__c = rev.Id, Channel_Partner_Contact_Roles__c = role.Id,
                          Product_Lines_form_ContactRole__c = role.Product_Lines__c));
                 }
             }
         }
         
         try {
             if (insertList.size() > 0) insert insertList;
         }Catch(DMLException e) {
              for (Joint_Business_Plan_Contact_Role__c con : (List<Joint_Business_Plan_Contact_Role__c>) trgCtx.newList) {
                  con.addError(e.getDMLMessage(0));
              }
         }
    }
   
        /**
    To prevent deletion when the account plan status is closed
    */
     Public void deleteValidation(ClsWrappers.TriggerContext trgCtx){
         Id adminProfileId = Label.CL00075;
         Set<Id> contactRoleIdSet = new Set<Id>();
         
         for (Joint_Business_Plan_Contact_Role__c con : (List<Joint_Business_Plan_Contact_Role__c>) trgCtx.oldList) {             
             if (adminProfileId != Userinfo.getProfileid() && con.Channel_Partner_Business_Plan_Status__c== Label.Closed ) {
                 con.addError(Label.Business_Visit_Report_Business_Plan_Error); //You cannot save the changes - Channel Partner Business Plan is Closed/Obsolete.
             } else {
                 contactRoleIdSet.add(con.Id);
             } 
         }   
         
         if (contactRoleIdSet.size() > 0) {
             
             List<Contact_Information_Channel_Business_Rev__c> infoList = [ SELECT Id FROM Contact_Information_Channel_Business_Rev__c 
                 WHERE Channel_Partner_Contact_Roles__c IN :contactRoleIdSet];
             
             if (infoList.size() > 0) delete infoList;
         }     
     }
}