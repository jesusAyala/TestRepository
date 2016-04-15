/**
 * VF Page - AddJointBusinessTeam
 * Trigger Class - ClsAddJointBusinessTeam
 * 
 * Release R5
 * @author  Indhu Selvi Ramalingam (Accenture)
 * @created 2016-01-22
 * @version 1.0
 * Created
 */
public with sharing class ClsAddJointBusinessTeam
{
    public Joint_Business_Team__c jointBusinessTeam1 {get; set;}
    public Joint_Business_Team__c jointBusinessTeam2 {get; set;}
    public Joint_Business_Team__c jointBusinessTeam3 {get; set;}
    public Joint_Business_Team__c jointBusinessTeam4 {get; set;}
    public Joint_Business_Team__c jointBusinessTeam5 {get; set;}
    public List<Joint_Business_Team__c> jointBusinessTeamList = new List<Joint_Business_Team__c>() ;
    public Id jointBusinessId;
    public Boolean isNotQualified{get;set;}   
    public Boolean showBack{get;set;}
    public Boolean showCanvas{get;set;}
    public Boolean isSubApproval{get;set;} 
 
  /*  Description of the purpose of the method. 
    *  @name ClsAddJointBusinessTeam
    *  @Description - Constructor for AddJointBusinessTeam.
    *  @return Nothing - 
    */
   public ClsAddJointBusinessTeam(ApexPages.StandardController controller) {
        
        jointBusinessTeam1 = new Joint_Business_Team__c();
        jointBusinessTeam2 = new Joint_Business_Team__c();
        jointBusinessTeam3 = new Joint_Business_Team__c();
        jointBusinessTeam4 = new Joint_Business_Team__c();
        jointBusinessTeam5 = new Joint_Business_Team__c();
        jointBusinessId = Apexpages.currentPage().getParameters().get(System.label.System_CL00018);   
  
   showCanvas = True;
    }

    /*  Description of the purpose of the method. 
    *  @name saveRecord
    *  @Description - Save the members.
    *  @return - Navigate to appropriate Channel Pre-Qualification team record after saving 
    */   
    public Pagereference saveRecord(){
      try{  
      //system.debug('HAIII------------');
            jointBusinessTeamList = new List<Joint_Business_Team__c>();
            if(jointBusinessTeam1.User__c != null){
                jointBusinessTeam1.Joint_Business_Plan__c = jointBusinessId;
                jointBusinessTeamList.add(jointBusinessTeam1);
            }    
            if(jointBusinessTeam2.User__c != null){
                jointBusinessTeam2.Joint_Business_Plan__c = jointBusinessId;
                jointBusinessTeamList.add(jointBusinessTeam2);
            }
            if(jointBusinessTeam3 .User__c != null){
                jointBusinessTeam3 .Joint_Business_Plan__c = jointBusinessId;
                jointBusinessTeamList.add(jointBusinessTeam3);
            } 
            if(jointBusinessTeam4.User__c != null){
                jointBusinessTeam4.Joint_Business_Plan__c = jointBusinessId;
                jointBusinessTeamList.add(jointBusinessTeam4);
            }
            if(jointBusinessTeam5.User__c != null){
                jointBusinessTeam5.Joint_Business_Plan__c = jointBusinessId;
                jointBusinessTeamList.add(jointBusinessTeam5);
            } 
            
            //system.debug('jointBusinessTeamList------------'+jointBusinessTeamList);
            if(jointBusinessTeamList.size()>0){
                Database.Insert(jointBusinessTeamList);
            }
        }
     catch(exception ex){
      if(ClsTriggerFactory.prodQualErrorMsg == true)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.label.CL00019)); //System_CL00019 - Insufficient Privilege. 
            return null;
        }
        PageReference pageRef = new PageReference(System.label.System_CL00020+jointBusinessId); //System_CL00020 => '/'
        return pageRef;
    }

 /*  Description of the purpose of the method. 
    *  @name saveMoreRecord
    *  @Description - Save the members.
    *  @return - Navigate to appropriate team record after saving. 
    */   
    public Pagereference saveMoreRecord(){    
        try{    
            jointBusinessTeamList = new List<Joint_Business_Team__c>();
            if(jointBusinessTeam1.User__c != null){
                jointBusinessTeam1.Joint_Business_Plan__c = jointBusinessId;
                jointBusinessTeamList.add(jointBusinessTeam1);
            }    
            if(jointBusinessTeam2.User__c != null){
                jointBusinessTeam2.Joint_Business_Plan__c = jointBusinessId;
                jointBusinessTeamList.add(jointBusinessTeam2);
            }
            if(jointBusinessTeam3 .User__c != null){
                jointBusinessTeam3 .Joint_Business_Plan__c = jointBusinessId;
                jointBusinessTeamList.add(jointBusinessTeam3);
            } 
            if(jointBusinessTeam4.User__c != null){
                jointBusinessTeam4.Joint_Business_Plan__c = jointBusinessId;
                jointBusinessTeamList.add(jointBusinessTeam4);
            }
            if(jointBusinessTeam5.User__c != null){
                jointBusinessTeam5.Joint_Business_Plan__c = jointBusinessId;
                jointBusinessTeamList.add(jointBusinessTeam5);
            } 
            if(jointBusinessTeamList.size()>0){
                Database.Insert(jointBusinessTeamList);
            }
        }
        catch(exception ex){
        if(ClsTriggerFactory.prodQualErrorMsg == true)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.label.CL00019));  //System_CL00019 - Insufficient Privilege. 
            return null;
        }
      PageReference pageRef = new PageReference(System.label.System_Add_Joint_Business_Team_Id+jointBusinessId); // => '/apex/AddjointBusinessmentTeam?id='
      pageRef.setredirect(true);
      return pageRef;
    }
    
    /*  Description of the purpose of the method. 
    *  @name cancel
    *  @Description - Cancel the request.
    *  @return - Navigate to appropriate team record after saving. 
    */   
    public Pagereference cancel(){        
        PageReference pageRef = new PageReference(System.label.System_CL00020+jointBusinessId);
        return pageRef;
    }

    /*  Description of the purpose of the method. 
    *  @name GoBack
    *  @Description - GoBack to the detail page.
    */      
     public Pagereference goBack(){
        try{
                     
           PageReference pageRef = new PageReference(Label.CL0001+jointBusinessId); 
           return pageRef;                                           
        }catch(DMLException e){ 
            return null; 
        } 
    }
    
}