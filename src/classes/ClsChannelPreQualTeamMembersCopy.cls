/**
 * TriggerClass - ClsChannelPreQualTeamMembersCopy 
 * Controller for Vf pgae - ChannelPreQualTeamMembersCopy
 * 
 * Copy Account Team Members from the Account Team along with their roles in to the Channel Pre-Qualification Team
      and provide "Read/Write" Access. don't copy the duplicate user names. don't copy the inactive user.
 * Release R5
 * @author  Abiramasundari Radha (Accenture)
 * @created 2015-12-29
 * @version 1.0
 * Created
 */
public with sharing class ClsChannelPreQualTeamMembersCopy{
 /**
 * Constructor
 */ 
    public ClsChannelPreQualTeamMembersCopy(ApexPages.StandardController controller) {    
    }
 /**
 * Constructor
 */    
    public ClsChannelPreQualTeamMembersCopy(){}
    
    public String stringChannelPreQualId = Apexpages.currentPage().getParameters().get(Label.System_CL00018);   
    public Boolean isSubApproval{get;set;}
    public Boolean showErrmsg{get;set;} 
 /**
 * @name copyAccountTeamMember
 * Copy Account Team Members from the Account Team along with their roles in to the Channel Pre-Qualification Team
 */       
    public pagereference copyAccountTeamMember(){
        String accountId;
         showErrmsg = false;
        Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
        Set<Id> channelPreQualId = new Set<Id>();        
        List<Channel_Pre_Qualification_Team__c> addteamMembersList = new List<Channel_Pre_Qualification_Team__c>();
        Set<Id> ChannelPreQualSet = new Set<Id>();
             
        List<Channel_Qualifications__c> lstChannelPreQual = [SELECT Id,Name,Account__c, OwnerID
            FROM Channel_Qualifications__c WHERE Id =: stringChannelPreQualId LIMIT :remLimit];         
        if(lstChannelPreQual.size()>0){
            accountId = lstChannelPreQual[0].Account__c;
        }
        
        
        If(lstChannelPreQual.size()>0){         
            for(Channel_Qualifications__c oldrecords : lstChannelPreQual){
                channelPreQualId.add(oldrecords.Id);
            }
        }
                
        List<AccountTeamMember> listAccountTeamMember = [SELECT UserId, AccountAccessLevel, TeamMemberRole, Id, AccountId From AccountTeamMember 
                        where AccountID =: accountId AND User.IsActive = TRUE AND User.Profile.Name != :Label.Sys_Admin_Profile_Name LIMIT :remLimit];
                        
        List<ProcessInstance> lstProcessInstance = [Select Id, Status, TargetObject.Name , TargetObjectId from ProcessInstance where
                     TargetObjectId  =: stringChannelPreQualId and Status =: Label.ProcessInstance_Status_Pending LIMIT :remLimit];   // ProcessInstance_Status_Pending -> 'Pending'
        if(lstProcessInstance != null && lstProcessInstance.size() >0)
        {isSubApproval = true;}
        else        
        {isSubApproval = False;}
        
       
        for(Channel_Pre_Qualification_Team__c dupCheck : [SELECT Id,Channel_Pre_Qualification__c,User__c,Team_Role__c FROM 
                Channel_Pre_Qualification_Team__c WHERE Channel_Pre_Qualification__c IN: channelPreQualId LIMIT :remLimit]){
           
            ChannelPreQualSet.add(dupCheck.User__c);           
        }           
                
        
        If(lstChannelPreQual.size()>0){
            for(Channel_Qualifications__c ChannelPreQual : lstChannelPreQual){  
                If(listAccountTeamMember.size()>0){      
                    for(AccountTeamMember accTeamMember : listAccountTeamMember){
                        if(ChannelPreQual.OwnerID != accTeamMember.UserId && !ChannelPreQualSet.contains(accTeamMember.UserId)) {
                            Channel_Pre_Qualification_Team__c channelTeamMember = new Channel_Pre_Qualification_Team__c();
                            channelTeamMember.Channel_Pre_Qualification__c = ChannelPreQual.Id;
                            channelTeamMember.User__c = accTeamMember.UserId;
                            channelTeamMember.Access__c = Label.System_CL00037;              //  System_CL00037 -> 'Read/Write'
                            channelTeamMember.Team_Role__c = accTeamMember.TeamMemberRole;
                            addteamMembersList.add(channelTeamMember);   
                        }
                    }                                         
                } 
            } 
  
        }    
        
        try {
         if(isSubApproval )
            {   
            showErrmsg = True;                  
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.System_CL00096));
            return null;               
            }else  if(addteamMembersList.size()>0){
               // system.debug(addteamMembersList);
            Database.insert(addteamMembersList); 
          }else{}
            
        } Catch(DMLException e) {
            showErrmsg = True;
            
            String error = e.getDMLMEssage(0);
            
            if (System.label.cross_reference_error != '' && error.contains(System.label.cross_reference_error)){
                error = system.label.cross_reference_alt_message;
            } 

            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, error));
            return null;   
        }
                          
        PageReference pageRef = new PageReference(Label.System_CL00020+ stringChannelPreQualId); 
        return pageRef;
    } 
/**
 * @name GoBack
 * returns to the previous page
 */ 
    public Pagereference GoBack(){
            try
          {
                PageReference pageRef = new PageReference(Label.System_CL00020+stringChannelPreQualId);
                return pageRef;
            }
            catch(DMLException e){ return null; } 
        }   
}