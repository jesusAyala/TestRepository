/**
 * TriggerClass -  ClsTriggerIssuesAndChallenges
 * Release R5
 * @author  Vasanthi M(Accenture)
 * @created 2016-03-08
 * @version 1.0
 * Created 
 */
  
public without sharing class ClsTriggerIssuesAndChallenges extends ClsTriggerVirtual {
    
       Set<Id> adminUserIdSet = new Set<Id>();
    
    /**
     * constructor
    */
    public ClsTriggerIssuesAndChallenges() {
        
        Map<Id, User> adminUserMap = new Map<Id, User> ([ SELECT Id, Name FROM User WHERE Profile.Name =: Label.Sys_Admin_Profile_Name AND IsActive = TRUE LIMIT 50000]);
        adminUserIdSet.addAll(adminUserMap.KeySet());
    }    
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
         
         for (Issues_and_Challenges__c con : (List<Issues_and_Challenges__c>) trgCtx.oldList) {     
             
             if (!adminUserIdSet.contains(UserInfo.getUSerId()) && con.Account_Plan_Status__c == Label.Closed ) {
                 con.addError(Label.Cannot_Save_Changes_Account_Plan_R5); //You cannot save the changes as Account Plan Status is Closed.
             }
         }        
     }
}