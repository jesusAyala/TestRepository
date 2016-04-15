/**
    @Author Rajesh K
    @name AddCaptureTeamMemberClass
    @CreateDate 9/14/2015
    @Description Add multiple role Capture Team members with single shot for Capture Team.
    @Version 1.0
    **/
public with sharing class AddCaptureTeamMemberClass
{
    public Capture_Team_Member__c capTeamMember1 {get; set;}
    public Capture_Team_Member__c capTeamMember2 {get; set;}
    public Capture_Team_Member__c capTeamMember3 {get; set;}
    public Capture_Team_Member__c capTeamMember4 {get; set;}
    public Capture_Team_Member__c capTeamMember5 {get; set;}
    public List<Capture_Team_Member__c> capTeamMemberList;
    public Id capid;    
    /*  Description of the purpose of the method. 
    *  @name AddCaptureTeamMemberClass
    *  @Description - Constructor for AddCaptureTeamMemberClass.
    *  @return Nothing - 
    */
    public AddCaptureTeamMemberClass(ApexPages.StandardController controller) {
        capTeamMember1 = new Capture_Team_Member__c();
        capTeamMember2 = new Capture_Team_Member__c();
        capTeamMember3 = new Capture_Team_Member__c();
        capTeamMember4 = new Capture_Team_Member__c();
        capTeamMember5 = new Capture_Team_Member__c();
        capid = Apexpages.currentPage().getParameters().get(System.label.System_CL00018);//System.label.System_CL00018 => id
    }
    /*  Description of the purpose of the method. 
    *  @name saveRecord
    *  @Description - Save the members.
    *  @return - Navigate to appropriate capture team record after saving 
    *  @throws exception-Method will throw DML Exception in case of any DML issues and captures in log object
    */
    public Pagereference saveRecord(){
      try{  
            capTeamMemberList = new List<Capture_Team_Member__c>();
            if(capTeamMember1.User__c != null){
                capTeamMember1.Capture_Team__c = capid;
                capTeamMemberList.add(capTeamMember1);
            }    
            if(capTeamMember2.User__c != null){
                capTeamMember2.Capture_Team__c = capid;
                capTeamMemberList.add(capTeamMember2);
            }
            if(capTeamMember3 .User__c != null){
                capTeamMember3 .Capture_Team__c = capid;
                capTeamMemberList.add(capTeamMember3);
            } 
            if(capTeamMember4.User__c != null){
                capTeamMember4.Capture_Team__c = capid;
                capTeamMemberList.add(capTeamMember4);
            }
            if(capTeamMember5.User__c != null){
                capTeamMember5.Capture_Team__c = capid;
                capTeamMemberList.add(capTeamMember5);
            } 
            if(capTeamMemberList.size()>0){
                insert capTeamMemberList;
            }
        }
        catch(exception ex){
            if(ClsTriggerFactory.insertcheck == true)        
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.label.CL00019)); //CL00019 => Insufficient Privilege
            //ApexPages.addMessages(ex);
            return null;
        }
        PageReference pageRef = new PageReference(System.label.System_CL00020 + capId); //System_CL00020 => '/'
        return pageRef;
    }
    /*  Description of the purpose of the method. 
    *  @name saveMoreRecord
    *  @Description - Save the members.
    *  @return - Navigate to appropriate capture team record after saving. 
    *  @throws exception-Method will throw DML Exception in case of any DML issues and captures in log object
    */
    public Pagereference saveMoreRecord(){    
        try{    
            capTeamMemberList = new List<Capture_Team_Member__c>();
            if(capTeamMember1.User__c != null){
                capTeamMember1.Capture_Team__c = capid;
                capTeamMemberList.add(capTeamMember1);
            }    
            if(capTeamMember2.User__c != null){
                capTeamMember2.Capture_Team__c = capid;
                capTeamMemberList.add(capTeamMember2);
            }
            if(capTeamMember3 .User__c != null){
                capTeamMember3 .Capture_Team__c = capid;
                capTeamMemberList.add(capTeamMember3);
            } 
            if(capTeamMember4.User__c != null){
                capTeamMember4.Capture_Team__c = capid;
                capTeamMemberList.add(capTeamMember4);
            }
            if(capTeamMember5.User__c != null){
                capTeamMember5.Capture_Team__c = capid;
                capTeamMemberList.add(capTeamMember5);
            } 
            if(capTeamMemberList.size()>0){
                insert capTeamMemberList;
            }
        }
        catch(exception ex){
            if(ClsTriggerFactory.insertcheck == true)
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.label.CL00019));//CL00019 => Insufficient Privilege
            return null;
        }
        PageReference pageRef = new PageReference(System.label.System_CL00021 + capId); // System_CL00021 => '/apex/AddCaptureTeamMember?id='
        pageRef.setRedirect(true);
        return pageRef;
    }
    /*  Description of the purpose of the method. 
    *  @name cancel
    *  @Description - Cancel the request.
    *  @return - Navigate to appropriate capture team record after saving. 
    *  @throws exception-Method will throw DML Exception in case of any DML issues and captures in log object
    */
    public Pagereference cancel(){        
        PageReference pageRef = new PageReference(System.label.System_CL00020 + capId); //System_CL00020 => '/'
        return pageRef;
    }
}