/**
    @Author Shankaranarayanan V
    @name ClsAddAccountTeamToVisitTeam
    @CreateDate 2/12/2016
    @Description To add Account Team Members of a Visit Report's Account to Visit Report Team
    @Version 1.0
    **/
public without sharing class ClsAddAccountTeamToVisitTeam 
{
    ID vrID;
    boolean flag = false; 
    boolean accessDenied = false;
 /*  Description of the purpose of the method. 
    *  @name ClsAddAccountTeamToVisitTeam
    *  @Description -Adds Account team members to visit team.
 */    
    public ClsAddAccountTeamToVisitTeam(ApexPages.StandardController controller)
    {
    vrId= ApexPages.currentPage().getParameters().get(System.label.ApexClass_id);
    }
/*  Description of the purpose of the method. 
    *  @name updateVisitTeam
    *  @Description -Adds Account team members to visit team.
 */    
    public pagereference updateVisitTeam(){
    List<Id> memberIds = new List<Id>();
    List<Visit_Report_Team_Member__c> vrUpdateList = new List<Visit_Report_Team_Member__c>();
    List<Visit_Report__c> visitReportList = [Select id, Account__c, Name,ownerId from Visit_Report__c where id=:vrId  LIMIT 50000];
    /*List<AccountTeamMember> accountTeamList = [Select Id, AccountId, UserId, TeamMemberRole, AccountAccessLevel From AccountTeamMember WHERE 
                        AccountId=:visitReportList[0].Account__c  LIMIT 50000]; 
    List<Visit_Report_Team_Member__c> vrMemberList = [Select Id, Access_Level__c, Team_Role__c, User__c, Visit_Report__c from Visit_Report_Team_Member__c
                        WHERE Visit_Report__c=:vrId LIMIT 50000]; */
    Set<Id> vrMemberSet = new Set<Id>();
    Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
    
    User currentuser=[Select Id,Name,Email from User where Id=:userinfo.getuserId() LIMIT :remLimit];
    
    for(Visit_Report_Team_Member__c vrTeamMember1: [Select Id, Access_Level__c, Team_Role__c, User__c, Visit_Report__c from Visit_Report_Team_Member__c
                        WHERE Visit_Report__c=:vrId LIMIT :remLimit])
    {
        vrMemberSet.add(vrTeamMember1.User__c);
        if(currentuser.id == vrTeamMember1.User__c && vrTeamMember1.Access_Level__c == System.label.Read_only)
        {
            accessDenied = true;
        }
    }
    
        for(AccountTeamMember accTeamMember : [Select Id, AccountId, UserId, TeamMemberRole, AccountAccessLevel From AccountTeamMember WHERE 
                        AccountId=:visitReportList[0].Account__c LIMIT :remLimit])
        {
                memberIds.add(accTeamMember.UserId);        
        }
        
        Map<Id,User> memberMap = new Map<Id,User>([Select Id,Name, Profile.Name from User WHERE 
                        Id in :memberIds LIMIT :remLimit]);
                        
        if(accessDenied == false)
        {
            for(AccountTeamMember accTeamMember : [Select Id, AccountId, UserId, TeamMemberRole, AccountAccessLevel From AccountTeamMember WHERE 
                            AccountId=:visitReportList[0].Account__c LIMIT 50000])
            {
                if(!vrMemberSet.contains(accTeamMember.UserId) && visitReportList[0].ownerId != accTeamMember.UserId && (memberMap.get(accTeamMember.UserId)!=null && memberMap.get(accTeamMember.UserId).Profile.Name != 'System Administrator'))
                { 
                    Visit_Report_Team_Member__c vrMember = new Visit_Report_Team_Member__c();
                    vrMember.Access_Level__c = System.label.Read_only;
                    vrMember.Team_Role__c = accTeamMember.TeamMemberRole;
                    vrMember.Visit_Report__c = vrId;
                    vrMember.User__c = accTeamMember.UserId;
                    vrUpdateList.add(vrMember);
                    flag=true;
                }
            }
        }

    if(vrUpdateList.size()>0)
    {
    try{
        database.insert(vrUpdateList); 
        Pagereference pageref = new Pagereference(System.label.CL0001+vrID);
        return pageref;
    }
    catch(DmlException exc){
        string err = exc.getmessage();
    }
    }  
    else if(visitReportList[0].Account__c == null)
    {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,System.label.Visitteam_Label1));
    }
    else if(accessDenied == true)
    {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,System.label.System_CL00093));
    }
    else 
    {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,System.label.Visitteam_Label));
    } 
    return null; 
    }
}