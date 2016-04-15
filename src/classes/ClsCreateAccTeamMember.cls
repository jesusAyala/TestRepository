/**
 * TriggerClass -  It should copy all the team members from the Account Team with the role "Account Manager & GAM/SAM Account Manager" with "Read/Write" Access 
 * Controller for Vf pgae - CreateAccountTeamMembers
 * 
 * Release R5
 * @author  Ayiravalli Arasu (Accenture)
 * @created 2015-12-31
 * @version 1.0
 * Created
 */
public with sharing class ClsCreateAccTeamMember{
/**
* Constructor
**/
    public ClsCreateAccTeamMember(ApexPages.StandardController controller){}
/**
* Constructor
**/
    public ClsCreateAccTeamMember(){}
    public Boolean isSubApproval{get;set;}
    public String AccPlanId = Apexpages.currentPage().getParameters().get(Label.System_CL0005);
    public Boolean showErrmsg{get;set;} 
    Id labelId = Label.CL00075; // System Admin profile ID
   
/**
* Method copyAccountTeamMember
* It should copy all the team members from the Account Team
**/    
    public pagereference copyAccountTeamMember(){
         Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();       
        List<Account_Plan_Team__c> lstAccPlanTeam = new List<Account_Plan_Team__c>(); //list to insert
        List<Account_Plan__c> lstAccPlans = [Select Id, Account__c,OwnerId FROM Account_Plan__c where id=:AccPlanId LIMIT :remLimit];
        //system.debug('AccPlanId------------'+AccPlanId);
        
        List<AccountTeamMember> lstAccTeamMem = new List<AccountTeamMember>();
        if(lstAccPlans.size() > 0){
            lstAccTeamMem = [Select Id, AccountId, UserId, TeamMemberRole, AccountAccessLevel From AccountTeamMember WHERE 
                        AccountId=:lstAccPlans[0].Account__c AND User.ProfileID != : labelId AND UserId !=: lstAccPlans[0].OwnerId AND User.IsActive = TRUE LIMIT :remLimit];
        }
        
        //system.debug('lstAccTeamMem------------'+lstAccTeamMem);
        Map<Id,Set<Id>> mapAccountTeam = new Map<Id,Set<Id>>();
        List<Account_Plan_Team__c> lstDuplicateCheck = [SELECT Id, Account_Plan__c, User__c,Team_Role__c, Access__c FROM 
                    Account_Plan_Team__c WHERE Account_Plan__c =: AccPlanId Limit 50000];
                    
        List<ProcessInstance> lstProcessInstance = [Select Id, Status, TargetObject.Name , TargetObjectId from ProcessInstance where
                         TargetObjectId  =: AccPlanId and Status =:Label.ProcessInstance_Status_Pending  limit 50000];
            if(lstProcessInstance != null && lstProcessInstance.size() >0)
            {isSubApproval = true;}
            else        
            {isSubApproval = False;}  
                
                     
        if(lstDuplicateCheck.size()>0){
            for(Account_Plan_Team__c dupCheck : lstDuplicateCheck){
                if(mapAccountTeam.containskey(dupCheck.Account_Plan__c) == False){
                    mapAccountTeam.put(dupCheck.Account_Plan__c, new set<Id>());                                   
                }
                mapAccountTeam.get(dupCheck.Account_Plan__c).add(dupCheck.User__c);           
            }           
        }            
         
                if(lstAccTeamMem.size() > 0){
                 
                   for(Account_Plan__c AccountPlan : lstAccPlans){  
                    for(AccountTeamMember accTeamMember : lstAccTeamMem){
                          
                             if((mapAccountTeam.containskey(AccountPlan.Id) == FALSE) ||
                              (mapAccountTeam.containskey(AccountPlan.Id) &&
                               mapAccountTeam.get(AccountPlan.Id).Contains(accTeamMember.UserId) == FALSE )){
                          
                                Account_Plan_Team__c newAccPlanTeam = new Account_Plan_Team__c();
                                newAccPlanTeam.Account_Plan__c = lstAccPlans[0].Id;
                                newAccPlanTeam.Team_Role__c= accTeamMember.TeamMemberRole;
                                newAccPlanTeam.Access__c= System.label.System_CL00035;
                                newAccPlanTeam.User__c =accTeamMember.UserId;
                                lstAccPlanTeam.add(newAccPlanTeam);
                     }  
                   }
                 }
                 }
             if(isSubApproval )
            {   
                showErrmsg = True;                  
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.System_CL00096));
                return null;                
            }else if(lstAccPlanTeam.size()>0){
                //system.debug(':::::lstAccPlanTeam:::'+lstAccPlanTeam);
                     Database.insert(lstAccPlanTeam);
                  }else{}
                  
            
         PageReference pageRef = new PageReference(Label.System_CL00020+AccPlanId ); 
         return pageRef;
    } 
/**
* returns to the previous page
*/    
    public Pagereference GoBack()    
    {
        try
        {
            PageReference pageRef = new PageReference(Label.System_CL00020+AccPlanId);
            return pageRef;
        }
        catch(DMLException e){ return null; } 
    }   
 
 }