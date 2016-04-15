/**
    @Author Aswini Arasu
    @name AddfpTeamClass
    @CreateDate 02/05/2016
    @Description Add multiple RFP Team members in a single shot for RFP.
    @Version 1.0
    **/
public with sharing class AddRfpTeamClass
{
    public RFP_Team__c rfpTeamMember1 {get; set;}
    public RFP_Team__c rfpTeamMember2 {get; set;}
    public RFP_Team__c rfpTeamMember3 {get; set;}
    public RFP_Team__c rfpTeamMember4 {get; set;}
    public RFP_Team__c rfpTeamMember5 {get; set;}
    public List<RFP_Team__c> RfpTeamList;
    public Id rfpId;  
    /*  Description of the purpose of the method. 
    *  @name AddRfpTeamClass
    *  @Description - Constructor for AddRfpMemberClass.
    *  @return Nothing - 
    */
    public AddRfpTeamClass(ApexPages.StandardController controller) {
        rfpTeamMember1 = new RFP_Team__c();
        rfpTeamMember2 = new RFP_Team__c();
        rfpTeamMember3 = new RFP_Team__c();
        rfpTeamMember4 = new RFP_Team__c();
        rfpTeamMember5 = new RFP_Team__c();
        rfpId = Apexpages.currentPage().getParameters().get(System.label.System_CL00018);//System.label.System_CL00018 => id
    }
    /*  Description of the purpose of the method. 
    *  @name saveRecords
    *  @Description - Save the RFP Team members.
    *  @return - Navigate to appropriate RFP record after saving 
    *  @throws exception-Method will throw DML Exception in case of any DML issues and captures in log object
    */
    public Pagereference saveRecords(){
      try{  
            RfpTeamList = new List<RFP_Team__c>();
            if(rfpTeamMember1.User__c != null){
                rfpTeamMember1.RFP__c = rfpId;
                RfpTeamList.add(rfpTeamMember1);
            }    
            if(rfpTeamMember2.User__c != null){
                rfpTeamMember2.RFP__c = rfpId;
                RfpTeamList.add(rfpTeamMember2);
            }
            if(rfpTeamMember3 .User__c != null){
                rfpTeamMember3 .RFP__c = rfpId;
                RfpTeamList.add(rfpTeamMember3);
            } 
            if(rfpTeamMember4.User__c != null){
                rfpTeamMember4.RFP__c = rfpId;
                RfpTeamList.add(rfpTeamMember4);
            }
            if(rfpTeamMember5.User__c != null){
                rfpTeamMember5.RFP__c = rfpId;
                RfpTeamList.add(rfpTeamMember5);
            } 
            if(RfpTeamList.size()>0){
                Database.Insert(RfpTeamList,False);
            }
        }
        catch(exception ex){
            if(ClsTriggerFactory.insertcheck == true)        
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.label.CL00019)); //CL00019 => Insufficient Privilege
            return null;
        }
        PageReference pageRef = new PageReference(System.label.System_CL00020 + rfpId); //System_CL00020 => '/'
        return pageRef;
    }
    /*  Description of the purpose of the method. 
    *  @name saveMoreRecords
    *  @Description - Save the RFP additional members.
    *  @return - Navigate to appropriate RFP record after saving
    *  @throws exception-Method will throw DML Exception in case of any DML issues and captures in log object
    */
    public Pagereference saveMoreRecords(){    
        try{    
            RfpTeamList = new List<RFP_Team__c>();
            if(rfpTeamMember1.User__c != null){
                rfpTeamMember1.RFP__c = rfpId;
                RfpTeamList.add(rfpTeamMember1);
            }    
            if(rfpTeamMember2.User__c != null){
                rfpTeamMember2.RFP__c = rfpId;
                RfpTeamList.add(rfpTeamMember2);
            }
            if(rfpTeamMember3.User__c != null){
                rfpTeamMember3.RFP__c = rfpId;
                RfpTeamList.add(rfpTeamMember3);
            } 
            if(rfpTeamMember4.User__c != null){
                rfpTeamMember4.RFP__c = rfpId;
                RfpTeamList.add(rfpTeamMember4);
            }
            if(rfpTeamMember5.User__c != null){
                rfpTeamMember5.RFP__c = rfpId;
                RfpTeamList.add(rfpTeamMember5);
            } 
            if(RfpTeamList.size()>0){
                Database.Insert(RfpTeamList,False);
            }
        }
        catch(exception ex){
            if(ClsTriggerFactory.insertcheck == true)
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.label.CL00019));//CL00019 => Insufficient Privilege
            return null;
        }
        PageReference pageRef = new PageReference(System.label.Rfp_Id+ rfpId); //Rfp_Id => '/apex/AddRfpTeam?id='
        pageRef.setRedirect(true);
        return pageRef;
    }
    /*  Description of the purpose of the method. 
    *  @name cancel
    *  @Description - Cancel the request.
    *  @return - Navigate to appropriate RFP record after saving. 
    *  @throws exception-Method will throw DML Exception in case of any DML issues and captures in log object
    */
    public Pagereference cancel(){    
        try{    
        PageReference pageRef = new PageReference(System.label.System_CL00020 + rfpId); //System_CL00020 => '/'
        return pageRef;
        }catch(Exception e){String err=e.getMessage();}
        return null;
    }
}