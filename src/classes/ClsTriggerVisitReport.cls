/**
 * TriggerClass -  ClsTriggerVisitReport
 * Release R5
 * @author  Vasanthi M(Accenture)
 * @created 2016-03-08
 * @version 1.0
 * Created 
 */
  
public without sharing class ClsTriggerVisitReport extends ClsTriggerVirtual {
    
    
    /**
* @see IntHelper.beforeTrigger
*/  
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {               
       
        if (trgCtx.IsDelete) {
            deleteValidation(trgCtx);
        }                   
    }
    
        /**
* @see IntHelper.afterTrigger
*/  
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {               
       
        if (trgCtx.IsUpdate) {
            copyMeetingMinutes(trgCtx);
        }                   
    }
    
    /**
    To copy the Meeting minutes
    */
    public void copyMeetingMinutes(ClsWrappers.TriggerContext trgCtx) {
        
        Map<Id, Visit_Report__c> visitReportMap = new Map<Id, Visit_Report__c>();
        List<Attends_Hidden_for_Review__c> updateList = new List<Attends_Hidden_for_Review__c>();
        
        for (Visit_Report__c report : (List<Visit_Report__c>) trgCtx.newList) {  
            
            Visit_Report__c oldReport = (Visit_Report__c) trgCtx.oldMap.get(report.Id);
            
            if (report.Meeting_Minutes__c != oldReport.Meeting_Minutes__c) {
                visitReportMap.put(report.Id, report);
            }
        }
        
        if (visitReportMap.size() > 0) {
            for (Attends_Hidden_for_Review__c acc: [ SELECT Id, Visit_Attendee_Account__r.Visit_Report__c, Visit_Report_Meeting_Minutes__c 
                FROM Attends_Hidden_for_Review__c
                WHERE Visit_Attendee_Account__c != NULL AND Visit_Attendee_Account__r.Visit_Report__c IN :visitReportMap.keyset() LIMIT 50000]) {
                
                acc.Visit_Report_Meeting_Minutes__c = visitReportMap.get(acc.Visit_Attendee_Account__r.Visit_Report__c).Meeting_Minutes__c;
                updateList.add(acc);
            }
        }
        
        try {
        
            if (updateList.size() > 0) update updateList;
        } Catch (DMLEXception e) {
            for (Visit_Report__c report : (List<Visit_Report__c>) trgCtx.newList) { 
                report.addError(e.getDMLMessage(0));
            }
            
        }
    }
    
        /**
    To prevent deletion when the account plan status is closed
    */
     Public void deleteValidation(ClsWrappers.TriggerContext trgCtx){
         ID sysAdminProfileId = Label.CL00075;
         if (sysAdminProfileId  != Userinfo.getProfileid()) { //Label.CL00075 - Admin Profile ID
             for (Visit_Report__c con : (List<Visit_Report__c>) trgCtx.oldList) {             
                 if (con.Channel_Qualification_Status__c == Label.Closed ) {
                     con.addError(Label.Business_Channel_Qualification_Err); //You cannot save the changes - Channel Partner Pre Qualification is Closed.
                 } else if (con.Channel_Partner_Business_Plan_Status__c == Label.Closed ) {
                     con.addError(Label.Business_Visit_Report_Business_Plan_Error); //You cannot save the changes - Channel Partner Business Plan is Closed/Obsolete.
                 } else if (con.Channel_Business_Review_Status__c == Label.Closed ) {
                     con.addError(Label.Business_Channel_Business_Review_Err); //You cannot save the changes - Channel Partner Pre Qualification is Closed.
                 } if (con.Account_Plan_Status__c == Label.Closed ) {
                     con.addError(Label.Cannot_Save_Changes_Account_Plan_R5); //You cannot save the changes as Account Plan Status is Closed.
                 }
             }  
         }      
     }
}