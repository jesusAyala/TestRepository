/*************************************************************
@Name: APTS_CancelAgreementApprovalController
@Author: Chetan Patel
@CreateDate: 18 Nov 2015
@Description: This class check whether curreny user is allowed to cancel/recall approval or not
@UsedBy: VF-Page : APTS_CancelAgreementApproval
******************************************************************
@ModifiedBy: NA
@ModifiedDate: NA
@ChangeDescription: A brief description of what was modified.
**** PS: @ModifiedBy and @ChangeDescription can be repeated multiple time, based on number of changes made to the original process.
******************************************************************/

public with sharing class APTS_CancelAgreementApprovalController {
    // Apttus agreements 
    public Apttus__APTS_Agreement__c agreement {
        get;
        set;
    }
    // Boolean variable to show error message on  VF page
    public Boolean bHasErrors {
        get;
        set;
    }
    
    // Constructor
    public APTS_CancelAgreementApprovalController(ApexPages.StandardController controller) {
        agreement = (Apttus__APTS_Agreement__c) controller.getrecord();
        
        agreement = [select id,ownerid from Apttus__APTS_Agreement__c where id=:agreement.id];
        bHasErrors = false;
        
        
        
    }


    public pagereference onload() {
        // Check for Validity of agreement and agreement Values
        if (isValidagreement(agreement)) {
            // Fetch the Group Name value for Corresponding agreement Values
            
                PageReference pageRef = Page.Apttus_Approval__ApprovalContextCancel;
                pageRef.getParameters().put('sObjectType', 'Apttus__APTS_Agreement__c');
                pageRef.getParameters().put('sObjectId', agreement.id);
             
                pageRef.setredirect(true);
                return pageRef;
            
            
        } else {
            // Show information Message
            
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, Label.APTS_USER_NOT_ALLOWED_TO_CANCEL_APPROVAL));
            bHasErrors = true;
        }

        return null;
    }

    // This Method checks for Validity of agreement and agreement Values
    private Boolean isValidagreement(Apttus__APTS_Agreement__c agmt) {

        Boolean bValid = false;
        // Check for agreement validation
        if (agmt != null && agmt.id != null && String.isNotBlank(agmt.id)) {
            // Check for agreement field Validation   
            system.debug('@@  in valid if : ' );
            set<id> groupIds = new set<id>();
            Set<id> setAllowedUsers = new Set<id>();
            Set<id> setAllowedLCAUsers = new Set<id>();
            
            setAllowedUsers.add(agmt.OwnerId);
            
            groupIds = getLCAPublicGroups();
            system.debug('@@  groupIds: '+ groupIds );
            setAllowedLCAUsers = GetUserIdsFromGroup(groupIds);
            system.debug('@@  setAllowedLCAUsers: '+ setAllowedLCAUsers );
            if(setAllowedLCAUsers != null && setAllowedLCAUsers.size()>0){
                
                setAllowedUsers.addAll(setAllowedLCAUsers);
            }
            system.debug('@@  setAllowedUsers: '+ setAllowedUsers );
            
            if(setAllowedUsers != null && setAllowedUsers.size()>0){
                
                if(setAllowedUsers.contains(UserInfo.getUserId()))
                    bValid = true;
                else
                    bValid = false;
            }

        }
        system.debug('@@ bValid : ' +bValid);
        return bValid;
    }
    
    private set<id> getLCAPublicGroups(){
        
        // For R3, we are only fetching LCA users who are part of public group 'Spain Country Admin'
        // Going forward if we create another public group for other coutry, 
        // We must include that public group in below query to give access to "Recall Approvals" button to those LCA users
        
        List<group> lstLCAPublicGroups = new List<group>();
        set<id> groupIds = new set<id>();
        
        lstLCAPublicGroups = [select id,name from group where type='Regular' and name='Spain Country Admin'];
        
        if(lstLCAPublicGroups != null && lstLCAPublicGroups.size()>0){
            
            for(group g:lstLCAPublicGroups){
                groupIds.add(g.id);
            }
        }
        
        return groupIds;
        
    }
    
    private Set<id> GetUserIdsFromGroup(Set<Id> groupIds)
    {
        // store the results in a set so we don't get duplicates
        Set<Id> result=new Set<Id>();
        String userType = Schema.SObjectType.User.getKeyPrefix();
        String groupType = Schema.SObjectType.Group.getKeyPrefix();
        Set<Id> groupIdProxys = new Set<Id>();
        // Loop through all group members in a group
        
        if(groupIds != null && groupIds.size()>0)
        {
            
            for(GroupMember m : [Select Id, UserOrGroupId From GroupMember Where GroupId in :groupIds])
            {
                // If the user or group id is a user
                if(((String)m.UserOrGroupId).startsWith(userType))
                {
                    result.add(m.UserOrGroupId);
                }
                // If the user or group id is a group
                // Note: there may be a problem with governor limits if this is called too many times
                else if (((String)m.UserOrGroupId).startsWith(groupType))
                {
                    // Call this function again but pass in the group found within this group
                    groupIdProxys.add(m.UserOrGroupId);
                }
            }
        }
        if(groupIdProxys.size() > 0)
        {
            result.addAll(GetUSerIdsFromGroup(groupIdProxys));
        }
        return result;  
    }
    
}