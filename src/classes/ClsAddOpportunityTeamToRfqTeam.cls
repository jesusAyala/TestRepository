/**
    @Author Aswini
    @name ClsAddOpportunityTeamToRfqTeam
    @CreateDate 2/12/2016
    @Description To add Opportunity Team Members to RFQ Team
    @Version 1.0
    **/
public without sharing class ClsAddOpportunityTeamToRfqTeam
{
    ID rfqID;
    boolean flag = false;
 /*  Description of the purpose of the method. 
    *  @name ClsAddOpportunityTeamToRfqTeam
    *  @Description -Adds RFQ Team members to RFQ.
 */    
    public ClsAddOpportunityTeamToRfqTeam(ApexPages.StandardController controller)
    {
         rfqID = ApexPages.currentPage().getParameters().get(System.label.ApexClass_id);     
    } 
 /*  Description of the purpose of the method. 
    *  @name updateRfqTeam
    *  @Description -Adds RFQ Team members to RFQ.
 */  
   public pagereference updateRfqTeam(){
    List<Id> memberIds = new List<Id>();
    List<RFP_Team__c> rfqUpdateList = new List<RFP_Team__c>();
    List<RFP__c> rfqList = [Select id, Rfp_Opportunity__c, Name, ownerId from RFP__c where id=:rfqID LIMIT 50000];
    /*List<OpportunityTeamMember> opportunityTeamList = [Select Id, OpportunityId, UserId, TeamMemberRole, OpportunityAccessLevel From OpportunityTeamMember WHERE 
                        OpportunityId=:rfqList[0].Rfp_Opportunity__c LIMIT 50000];*/
                        
    //system.debug(':::rfqList:::'+rfqList);
   // system.debug(':::opportunityTeamList:::'+opportunityTeamList);                    
                        
    /*List<RFP_Team__c> rfqMemberList = [Select Id, Access_Level__c, Team_Role__c, User__c, RFP__c from RFP_Team__c
                        WHERE RFP__c=:rfqID LIMIT 50000]; */
                        
     //system.debug(':::rfqMemberList:::'+rfqMemberList);                   
                        
    Set<Id> rfqMemberSet = new Set<Id>();
             
    for(RFP_Team__c rfqTeamMember1: [Select Id, Access_Level__c, Team_Role__c, User__c, RFP__c from RFP_Team__c
                        WHERE RFP__c=:rfqID limit 50000])
    {
        rfqMemberSet.add(rfqTeamMember1.User__c);
    }
    
    for(OpportunityTeamMember oppTeamMember : [Select Id, OpportunityId, UserId, TeamMemberRole, OpportunityAccessLevel From OpportunityTeamMember WHERE 
                        OpportunityId=:rfqList[0].Rfp_Opportunity__c LIMIT 50000])
        {
                memberIds.add(oppTeamMember.UserId);        
        }
        Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
        Map<Id,User> memberMap = new Map<Id,User>([Select Id,Name, Profile.Name from User WHERE 
                        Id in :memberIds LIMIT :remLimit]);
        
        for(OpportunityTeamMember oppTeamMember : [Select Id, OpportunityId, UserId, TeamMemberRole, OpportunityAccessLevel From OpportunityTeamMember WHERE 
                        OpportunityId=:rfqList[0].Rfp_Opportunity__c LIMIT 50000] )
        {
            if(!rfqMemberSet.contains(oppTeamMember.UserId)&& rfqList[0].ownerId != oppTeamMember.UserId && (memberMap.get(oppTeamMember.UserId)!=null && memberMap.get(oppTeamMember.UserId).Profile.Name != 'System Administrator'))
            { 
                RFP_Team__c rfpMember = new RFP_Team__c();
                rfpMember.Access_Level__c = oppTeamMember.OpportunityAccessLevel;
                rfpMember.Team_Role__c = oppTeamMember.TeamMemberRole;
                rfpMember.RFP__c = rfqID;
                rfpMember.User__c = oppTeamMember.UserId;
                rfqUpdateList.add(rfpMember);
                flag=true;
                
               // system.debug(':::rfqUpdateList:::'+rfqUpdateList);
            }
        }
    
    if(rfqUpdateList.size()>0)
    {
    try{
        database.insert(rfqUpdateList); 
        Pagereference pageref = new Pagereference(System.label.CL0001+rfqID);
        return pageref;
    }
    catch(DmlException exc){
        String err= exc.getMessage();
    }
    }
    /*}  
    else if(rfqList[0].Rfp_Opportunity__c == null)
    {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select an Opportunity.'));
    }
    else
    {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'All the members are already added to the RFQ Team'));
    }*/ 
    return null; 
    }
    
    
    
}