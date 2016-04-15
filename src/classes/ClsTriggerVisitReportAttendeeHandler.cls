/**   
* TriggerClass on the Visit Report Attendee object
*       
* Release - R5 
 *  
 * @author  - Vasanthi (Accenture)
 * @created - 2016-03-28
 * @version - 1.0
*/
public without sharing class ClsTriggerVisitReportAttendeeHandler extends ClsTriggerVirtual {
     
    /**   
    * Constructor       
    * Release - R5 
     *  
    */    
    public ClsTriggerVisitReportAttendeeHandler  () {
    
    }

    /**   
    * bulkBefore 
    * Release - R5 
     *  
    */       
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {   
        
        if (trgCtx.isInsert) {                       
            copyInfo(trgCtx);
        }
        
        if (trgCtx.IsDelete) {
            deleteInfo(trgCtx);
        }
    }
   
    
    public void copyInfo(ClsWrappers.TriggerContext trgCtx) {
        
        List<Attends_Hidden_for_Review__c> tobeInsertedList = new List<Attends_Hidden_for_Review__c>();
        Map<Id, Visit_Report__c> visitReportMap = new Map<Id, Visit_Report__c>();
        Set<Id> visitReportIdSet = new Set<Id>();
        
        for (Visit_Attendee__c attendee: (List<Visit_Attendee__c>)trgCtx.newList) {
            
            if (attendee.Visit_Report__c != NULL) {
                visitReportIdSet.add(attendee.Visit_Report__c);
            }
            
        }      
        
        if (visitReportIdSet.size() > 0) {
            visitReportMap = new Map<Id, Visit_Report__c> ([SELECT Id, Meeting_Minutes__c FROM Visit_Report__c WHERE Id IN :visitReportIdSet]);
        }
        
        for (Visit_Attendee__c attendee: (List<Visit_Attendee__c>)trgCtx.newList) {            
           
            if (attendee.Channel_Partner_Business_Review_ID__c != '' && attendee.Channel_Partner_Business_Review_ID__c != NULL) {
                
                Attends_Hidden_for_Review__c rev = new Attends_Hidden_for_Review__c(Channel_Partner_Business_Review__c = attendee.Channel_Partner_Business_Review_ID__c, 
                Visit_Attendee_Account__c = attendee.Id);
                
                if (attendee.Visit_Report__c != NULL) {
                    rev.Visit_Report_Meeting_Minutes__c = visitReportMap.get(attendee.Visit_Report__c).Meeting_Minutes__c ;
                }
                
                tobeInsertedList.add (rev);
            }
        }       
         
        if (tobeInsertedList.size() > 0) insert tobeInsertedList;
    }
    
    public void deleteInfo(ClsWrappers.TriggerContext trgCtx) {
        
        Set<Id> attendeeIdSet = new Set<Id>();
        
        for (Visit_Attendee__c attendee: (List<Visit_Attendee__c>) trgCtx.oldList) {
            
            attendeeIdSet.add (attendee.Id);
        }       
        if (attendeeIdSet.size() > 0) {
            List<Attends_Hidden_for_Review__c> infoList = [ SELECT ID FROM Attends_Hidden_for_Review__c WHERE Visit_Attendee_Account__c IN :attendeeIdSet ];
            if (infoList.size() > 0) delete infoList;
        }
    }
}