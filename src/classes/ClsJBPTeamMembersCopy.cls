/**
 * TriggerClass - ClsJBPTeamMembersCopy 
 * Controller for Vf pgae - JBPTeamMembersCopy
 * 
 * Copy Account Team Members from the Account Team along with their roles in to the Joint Business Plan Team
      and provide "Read/Write" Access. don't copy the duplicate user names. don't copy the inactive user.
 * Release R5
 * @author  Indhu Selvi Ramalingam (Accenture)
 * @created 2016-01-06
 * @version 1.0
 * Created
 */
public with sharing class ClsJBPTeamMembersCopy{
/**
* Constructor
*/  
    public ClsJBPTeamMembersCopy(ApexPages.StandardController controller) {    
    }
/**
* Constructor
*/   
    public ClsJBPTeamMembersCopy(){}
    
    public String stringJBPId = Apexpages.currentPage().getParameters().get(Label.System_CL00018);  // Label.System_CL00018 => id
    public Boolean isSubApproval{get;set;}
    public Boolean showErrmsg{get;set;} 
/**
* @name copyAccountTeamMember
* Copy Account Team Members from the Account Team along with their roles in to the Joint Business Plan Team
*/       
    public pagereference copyAccountTeamMember(){
        String accountId;
        Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
        Set<Id> JBPId = new Set<Id>();        
        List<Joint_Business_Team__c> addteamMembersList = new List<Joint_Business_Team__c>();
        Set<Id> existingTeamMemSet = new Set<Id>();
             
        List<Joint_Business_Plan__c> lstJBP = [SELECT Id,Name,Account__c, OwnerID 
            FROM Joint_Business_Plan__c WHERE Id =: stringJBPId LIMIT :remLimit];         
        if(lstJBP.size()>0){
            accountId = lstJBP[0].Account__c;
        }
        
        
        If(lstJBP.size()>0){         
            for(Joint_Business_Plan__c oldrecords : lstJBP){
                JBPId.add(oldrecords.Id);
            }
        }
                
        List<AccountTeamMember> listAccountTeamMember = [SELECT UserId, AccountAccessLevel, TeamMemberRole, Id, AccountId From AccountTeamMember 
                        where AccountID =: accountId AND User.IsActive = TRUE AND User.Profile.Name != :Label.Sys_Admin_Profile_Name LIMIT :remLimit];
                        
        List<ProcessInstance> lstProcessInstance = [Select Id, Status, TargetObject.Name , TargetObjectId from ProcessInstance where
                     TargetObjectId  =: stringJBPId and Status ='Pending' LIMIT :remLimit];
        if(lstProcessInstance != null && lstProcessInstance.size() >0)
        {isSubApproval = true;}
        else        
        {isSubApproval = False;}
        
        List<Joint_Business_Team__c> lstDuplicateCheck = [SELECT Id,Joint_Business_Plan__c,User__c,Team_Role__c FROM 
                    Joint_Business_Team__c WHERE Joint_Business_Plan__c =: JBPId LIMIT :remLimit]; 
        if(lstDuplicateCheck.size()>0){
            for(Joint_Business_Team__c dupCheck : lstDuplicateCheck){
                existingTeamMemSet.add(dupCheck.User__c);       
            }           
        }            
        
        If(lstJBP.size()>0){
            for(Joint_Business_Plan__c JBP : lstJBP){  
                If(listAccountTeamMember.size()>0){      
                    for(AccountTeamMember accTeamMember : listAccountTeamMember){
                        if(!existingTeamMemSet.contains(accTeamMember.UserId) && JBP.OwnerId != accTeamMember.UserId){                        
                            Joint_Business_Team__c jbpTeamMember = new Joint_Business_Team__c();
                            jbpTeamMember.Joint_Business_Plan__c = JBP.Id;
                            jbpTeamMember.User__c = accTeamMember.UserId;
                            jbpTeamMember.Access__c = system.label.System_CL00110;
                            jbpTeamMember.Team_Role__c = accTeamMember.TeamMemberRole;
                            addteamMembersList.add(jbpTeamMember);   
                        }
                    }                                         
                } 
            } 
  
        }    
        
         if(isSubApproval )
            {   
            showErrmsg = True;                  
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.System_CL00096));
            return null;               
            }else  if(addteamMembersList.size()>0){
            Database.insert(addteamMembersList); 
          }else{}
            
                          
        PageReference pageRef = new PageReference('/'+ stringJBPId); 
        return pageRef;
    } 
/**
* @name GoBack
* returns to the previous page
*/
    public Pagereference GoBack(){
            try
          {
                PageReference pageRef = new PageReference('/'+stringJBPId);
                return pageRef;
            }
            catch(DMLException e){ return null; } 
        }   
}