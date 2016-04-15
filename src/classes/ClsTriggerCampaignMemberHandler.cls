/**
*  @Name: ClsTriggerCampaignMemberHandler
*  @return - void
*  @Description - This class helps to validate when campaign Member is remove
*  @Author : Rajesh Kaliyaperumal (Accenture)
*  updateLog : 24.02.16 - Nikhil - Updated logic of conditions which are allowed for a user to be eligible to delete campaign member
*/
public without sharing class ClsTriggerCampaignMemberHandler extends ClsTriggerVirtual {
    /**
     * @see IntHelper.beforeTrigger
    */
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {       
        
    }    
    /**    
     * @see IntHelper.afterTrigger
    */
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
        setValidationRemoveCampaignMember(trgCtx);       
    }  
    /**
     *Method Name: setValidationRemoveCampaignMember.
     @author  Rajesh Kaliyaperumal
     @created 2016-02-24
    */
   @TestVisible 
    private void setValidationRemoveCampaignMember(ClsWrappers.TriggerContext trgCtx) {    
        if(trgCtx.isDelete && trgCtx.isAfter) {
            for (sobject so : trgCtx.oldList) {
                CampaignMember cMemb = (CampaignMember)so;
                System.debug('UserInfo.getUserId()'+UserInfo.getUserId().substring(0, 15));
                System.debug('cMemb.Campaign_OwnerId__c'+cMemb.Campaign_OwnerId__c);
                if(cMemb.ContactId != null && 
                   ((UserInfo.getUserId().substring(0, 15) != cMemb.Contact_OwnerId__c) && (UserInfo.getUserId().substring(0, 15) != cMemb.Campaign_OwnerId__c))
                   && cMemb.Campaign_Type__c == 'Survey'){
                    cMemb.adderror('You are not authorized to remove Campaign Members which are owned by other user');
                }
            }
        } 
    }
}