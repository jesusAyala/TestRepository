/**
 * VF Page - AddChannelPreQualTeam
 * Trigger Class - ClsAddChannelPreQualTeam
 * 
 * Release R5
 * @author  Indhu Selvi Ramalingam (Accenture)
 * @created 2016-01-19
 * @version 1.0
 * Created
 */
public with sharing class ClsAddChannelPreQualTeam
{
    public Channel_Pre_Qualification_Team__c channelPreQualTeam1 {get; set;}
    public Channel_Pre_Qualification_Team__c channelPreQualTeam2 {get; set;}
    public Channel_Pre_Qualification_Team__c channelPreQualTeam3 {get; set;}
    public Channel_Pre_Qualification_Team__c channelPreQualTeam4 {get; set;}
    public Channel_Pre_Qualification_Team__c channelPreQualTeam5 {get; set;}
    public List<Channel_Pre_Qualification_Team__c> channelPreQualTeamList = new List<Channel_Pre_Qualification_Team__c>() ;
    public Id channelPreQualId;
    public Boolean isNotQualified{get;set;}   
    public Boolean showBack{get;set;}
    public Boolean showCanvas{get;set;}
    public Boolean isSubApproval{get;set;} 
 
  /*  Description of the purpose of the method. 
    *  @name AddChannelPreQualTeam
    *  @Description - Constructor for AddChannelPreQualTeam.
    *  @return Nothing - 
    */
   public ClsAddChannelPreQualTeam(ApexPages.StandardController controller) {
        
        channelPreQualTeam1 = new Channel_Pre_Qualification_Team__c();
        channelPreQualTeam2 = new Channel_Pre_Qualification_Team__c();
        channelPreQualTeam3 = new Channel_Pre_Qualification_Team__c();
        channelPreQualTeam4 = new Channel_Pre_Qualification_Team__c();
        channelPreQualTeam5 = new Channel_Pre_Qualification_Team__c();
        channelPreQualId = Apexpages.currentPage().getParameters().get(Label.ApexClass_id); 
  
  
   showCanvas = True;
    }

    /*  Description of the purpose of the method. 
    *  @name saveRecord
    *  @Description - Save the members.
    *  @return - Navigate to appropriate Channel Pre-Qualification team record after saving 
    *  @throws exception-Method will throw DML Exception in case of any DML issues and captures in log object
    */   
    public Pagereference saveRecord(){
      try{  
     // system.debug('HAIII------------');
            channelPreQualTeamList = new List<Channel_Pre_Qualification_Team__c>();
            if(channelPreQualTeam1.User__c != null){
                channelPreQualTeam1.Channel_Pre_Qualification__c = channelPreQualId;
                channelPreQualTeamList.add(channelPreQualTeam1);
            }    
            if(channelPreQualTeam2.User__c != null){
                channelPreQualTeam2.Channel_Pre_Qualification__c = channelPreQualId;
                channelPreQualTeamList.add(channelPreQualTeam2);
            }
            if(channelPreQualTeam3 .User__c != null){
                channelPreQualTeam3 .Channel_Pre_Qualification__c = channelPreQualId;
                channelPreQualTeamList.add(channelPreQualTeam3);
            } 
            if(channelPreQualTeam4.User__c != null){
                channelPreQualTeam4.Channel_Pre_Qualification__c = channelPreQualId;
                channelPreQualTeamList.add(channelPreQualTeam4);
            }
            if(channelPreQualTeam5.User__c != null){
                channelPreQualTeam5.Channel_Pre_Qualification__c = channelPreQualId;
                channelPreQualTeamList.add(channelPreQualTeam5);
            } 
            
            if(channelPreQualTeamList.size()>0){
                Database.Insert(channelPreQualTeamList);
            }
        }
     catch(exception ex){
      if(ClsTriggerFactory.prodQualErrorMsg == true)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.label.CL00019)); //System_CL00019 - Insufficient Privilege. 
            return null;
        }
        PageReference pageRef = new PageReference(System.label.System_CL00020+channelPreQualId); //System_CL00020 => '/'
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
            channelPreQualTeamList = new List<Channel_Pre_Qualification_Team__c>();
            if(channelPreQualTeam1.User__c != null){
                channelPreQualTeam1.Channel_Pre_Qualification__c = channelPreQualId;
                channelPreQualTeamList.add(channelPreQualTeam1);
            }    
            if(channelPreQualTeam2.User__c != null){
                channelPreQualTeam2.Channel_Pre_Qualification__c = channelPreQualId;
                channelPreQualTeamList.add(channelPreQualTeam2);
            }
            if(channelPreQualTeam3 .User__c != null){
                channelPreQualTeam3 .Channel_Pre_Qualification__c = channelPreQualId;
                channelPreQualTeamList.add(channelPreQualTeam3);
            } 
            if(channelPreQualTeam4.User__c != null){
                channelPreQualTeam4.Channel_Pre_Qualification__c = channelPreQualId;
                channelPreQualTeamList.add(channelPreQualTeam4);
            }
            if(channelPreQualTeam5.User__c != null){
                channelPreQualTeam5.Channel_Pre_Qualification__c = channelPreQualId;
                channelPreQualTeamList.add(channelPreQualTeam5);
            } 
            if(channelPreQualTeamList.size()>0){
                Database.Insert(channelPreQualTeamList);
            }
        }
        catch(exception ex){
        if(ClsTriggerFactory.prodQualErrorMsg == true)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.label.CL00019));  //System_CL00019 - Insufficient Privilege. 
            return null;
        }
      PageReference pageRef = new PageReference(System.label.System_Add_Customer_Segmentation_Team_Id_R5+channelPreQualId); // System_Add_Customer_Segmentation_Team_Id_R5 => '/apex/AddchannelPreQualmentTeam?id='
      pageRef.setredirect(true);
      return pageRef;
    }
    
    /*  Description of the purpose of the method. 
    *  @name cancel
    *  @Description - Cancel the request.
    *  @return - Navigate to appropriate capture team record after saving. 
    *  @throws exception-Method will throw DML Exception in case of any DML issues and captures in log object
    */   
    public Pagereference cancel(){        
        PageReference pageRef = new PageReference(System.label.System_CL00020+channelPreQualId);
        return pageRef;
    }
/**    
 * back to channel pre qualification
 */
     public Pagereference GoBack(){
        try{
                     
           PageReference pageRef = new PageReference(Label.CL0001+channelPreQualId); 
           return pageRef;                                           
        }catch(DMLException e){ 
            return null; 
        } 
    }
    
}