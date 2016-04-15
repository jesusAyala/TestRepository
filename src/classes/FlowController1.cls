public class FlowController1 {
    public Flow.Interview.Visit_report_from_Event myflow { get; set; }

    public PageReference getReturnURL() {
        String s_PageRef;
        s_PageRef = '';
        if (myflow != null){
            if (myflow.newVisitReportID != null){
               s_PageRef = myflow.newVisitReportID;          
            }
        }
        return new PageReference('/'+s_PageRef);                
    }

    public String getApexNewVisitReportID() {
        return myflow.newVisitReportID;
    }
    
    public Visit_Report__c getApexNewVisitReport() {
        return myflow.newVisitReport;
    }

}