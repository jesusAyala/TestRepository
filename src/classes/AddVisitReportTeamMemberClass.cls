/**
    @Author Shankaranarayanan V
    @name AddVisitReportTeamMemberClass
    @CreateDate 12/30/2015
    @Description Add multiple Visit Report Team members in a single shot for Visit Report.
    @Version 1.0
    **/
public with sharing class AddVisitReportTeamMemberClass
{
    public Visit_Report_Team_Member__c visitTeamMember1 {get; set;}
    public Visit_Report_Team_Member__c visitTeamMember2 {get; set;}
    public Visit_Report_Team_Member__c visitTeamMember3 {get; set;}
    public Visit_Report_Team_Member__c visitTeamMember4 {get; set;}
    public Visit_Report_Team_Member__c visitTeamMember5 {get; set;}
    public List<Visit_Report_Team_Member__c> visitReportTeamMemberList;
    public Id visitId;  
    /*  Description of the purpose of the method. 
    *  @name AddVisitReportTeamMemberClass
    *  @Description - Constructor for AddVisitReportTeamMemberClass.
    *  @return Nothing - 
    */
    public AddVisitReportTeamMemberClass(ApexPages.StandardController controller) {
        visitTeamMember1 = new Visit_Report_Team_Member__c();
        visitTeamMember2 = new Visit_Report_Team_Member__c();
        visitTeamMember3 = new Visit_Report_Team_Member__c();
        visitTeamMember4 = new Visit_Report_Team_Member__c();
        visitTeamMember5 = new Visit_Report_Team_Member__c();
        visitId = Apexpages.currentPage().getParameters().get(System.label.System_CL00018);//System.label.System_CL00018 => id
    }
    /*  Description of the purpose of the method. 
    *  @name saveRecords
    *  @Description - Save the Visit Report members.
    *  @return - Navigate to appropriate Visit Report record after saving 
    *  @throws exception-Method will throw DML Exception in case of any DML issues and captures in log object
    */
    public Pagereference saveRecords(){
      try{  
            visitReportTeamMemberList = new List<Visit_Report_Team_Member__c>();
            if(visitTeamMember1.User__c != null){
                visitTeamMember1.Visit_Report__c = visitId;
                visitReportTeamMemberList.add(visitTeamMember1);
            }    
            if(visitTeamMember2.User__c != null){
                visitTeamMember2.Visit_Report__c = visitId;
                visitReportTeamMemberList.add(visitTeamMember2);
            }
            if(visitTeamMember3 .User__c != null){
                visitTeamMember3 .Visit_Report__c = visitId;
                visitReportTeamMemberList.add(visitTeamMember3);
            } 
            if(visitTeamMember4.User__c != null){
                visitTeamMember4.Visit_Report__c = visitId;
                visitReportTeamMemberList.add(visitTeamMember4);
            }
            if(visitTeamMember5.User__c != null){
                visitTeamMember5.Visit_Report__c = visitId;
                visitReportTeamMemberList.add(visitTeamMember5);
            } 
            if(visitReportTeamMemberList.size()>0){
                Database.Insert(visitReportTeamMemberList);
            }
        }
        catch(exception ex){
            if(ClsTriggerFactory.insertcheck == true)        
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.label.CL00019)); //CL00019 => Insufficient Privilege
            return null;
        }
        PageReference pageRef = new PageReference(System.label.System_CL00020 + visitId); //System_CL00020 => '/'
        return pageRef;
    }
    /*  Description of the purpose of the method. 
    *  @name saveMoreRecords
    *  @Description - Save the Visit Report additional members.
    *  @return - Navigate to appropriate Visit Report record after saving
    *  @throws exception-Method will throw DML Exception in case of any DML issues and captures in log object
    */
    public Pagereference saveMoreRecords(){    
        try{    
            visitReportTeamMemberList = new List<Visit_Report_Team_Member__c>();
            if(visitTeamMember1.User__c != null){
                visitTeamMember1.Visit_Report__c = visitId;
                visitReportTeamMemberList.add(visitTeamMember1);
            }    
            if(visitTeamMember2.User__c != null){
                visitTeamMember2.Visit_Report__c = visitId;
                visitReportTeamMemberList.add(visitTeamMember2);
            }
            if(visitTeamMember3.User__c != null){
                visitTeamMember3.Visit_Report__c = visitId;
                visitReportTeamMemberList.add(visitTeamMember3);
            } 
            if(visitTeamMember4.User__c != null){
                visitTeamMember4.Visit_Report__c = visitId;
                visitReportTeamMemberList.add(visitTeamMember4);
            }
            if(visitTeamMember5.User__c != null){
                visitTeamMember5.Visit_Report__c = visitId;
                visitReportTeamMemberList.add(visitTeamMember5);
            } 
            if(visitReportTeamMemberList.size()>0){
                Database.Insert(visitReportTeamMemberList);
            }
        }
        catch(exception ex){
            if(ClsTriggerFactory.insertcheck == true)
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.label.CL00019));//CL00019 => Insufficient Privilege
            return null;
        }
        PageReference pageRef = new PageReference(System.label.CL00100+ visitId); //CL00100 => '/apex/AddVisitReportTeamMember?id='
        pageRef.setRedirect(true);
        return pageRef;
    }
    /*  Description of the purpose of the method. 
    *  @name cancel
    *  @Description - Cancel the request.
    *  @return - Navigate to appropriate Visit Report record after saving. 
    *  @throws exception-Method will throw DML Exception in case of any DML issues and captures in log object
    */
    public Pagereference cancel(){   
    try{     
        PageReference pageRef = new PageReference(System.label.System_CL00020 + visitId); //System_CL00020 => '/'
        return pageRef;
        }catch(Exception e){String err=e.getMessage();}
         return null; 
    }
}