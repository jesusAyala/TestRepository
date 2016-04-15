/************************************************************
 * @Name : APTS_ApprovalRequestTrigger
 * @Author : Shalin Shah (sshah@apttus.com)
 * @CreateDate: 16th Sept, 2015
 * @Description: Trigger on approval request object to make the comments from user mandatory upon rejection of request
 * @UsedBy : Custom Object : Apttus_Approval__Approval_Request__c
 ************************************************************/

trigger APTS_ApprovalRequestTrigger on Apttus_Approval__Approval_Request__c (before update, before delete, after update) {//before insert, 

    public static boolean beforeUpdate = true;
    APTS_ApprovalRequestTriggerHandler handler = new APTS_ApprovalRequestTriggerHandler();
    
    private final static String OBJECTTYPE_AGREEMENT = 'Apttus__APTS_Agreement__c';
    private final static string OBJECTTYPE_PROPOSAL = 'Apttus_Proposal__Proposal__c';
    /*
        below code block added by Axay to bypass this trigger for approval request other than Agreement and Quote/Proposal
    */
    
    //by pass trigger for object other than Agreement and Quote/Proposal
    Map<Id, Apttus_Approval__Approval_Request__c> mapNewApprovalRequest = new Map<Id, Apttus_Approval__Approval_Request__c>();
    Map<Id, Apttus_Approval__Approval_Request__c> mapOldApprovalRequest = new Map<Id, Apttus_Approval__Approval_Request__c>();
    
    List<Apttus_Approval__Approval_Request__c> lstDeletedRequest = new List<Apttus_Approval__Approval_Request__c>();
    
    //because for delete trigger - Trigegr.new is not available so we need to iterate over trigger.old
    if(Trigger.isDelete){
        
        for(Apttus_Approval__Approval_Request__c aRequest : Trigger.old){
            
            if(aRequest.Apttus_Approval__Object_Type__c == OBJECTTYPE_AGREEMENT || aRequest.Apttus_Approval__Object_Type__c == OBJECTTYPE_PROPOSAL){
            
                lstDeletedRequest.add(aRequest);
            }
        }
    }
    
    if(Trigger.isUpdate){
        
        for(Apttus_Approval__Approval_Request__c aRequest : Trigger.new){
            
            if(aRequest.Apttus_Approval__Object_Type__c == OBJECTTYPE_AGREEMENT || aRequest.Apttus_Approval__Object_Type__c == OBJECTTYPE_PROPOSAL){
                mapNewApprovalRequest.put(aRequest.Id, aRequest);
                mapOldApprovalRequest.put(aRequest.Id, Trigger.oldMap.get(aRequest.Id));
            }
        }
    }
    
    /*
    below is the existing code updated by Axay - here we will pass only those Approval request which are either on Agreement or Proposal
    */
    if(Trigger.isUpdate && mapNewApprovalRequest.size() > 0){
        
        if(Trigger.isBefore){
            
            if(beforeUpdate){
                handler.handleBeforeUpdate(mapNewApprovalRequest.values(), mapOldApprovalRequest);
                beforeUpdate = false;
            }
            
            handler.giveAccesstoApprovers(mapNewApprovalRequest.values());
            handler.addApproverIdsOnParentRecord(mapNewApprovalRequest.values());
            handler.sendMailToRecordOwner(mapOldApprovalRequest.values(), mapOldApprovalRequest, mapNewApprovalRequest.values(), mapNewApprovalRequest);
        }
        
        if(Trigger.isAfter){
            handler.handleAfterUpdate(mapNewApprovalRequest.values(), mapOldApprovalRequest);
        }
    }
    
    if(Trigger.isDelete && lstDeletedRequest.size() > 0){
        
        if(Trigger.isBefore){
            handler.handleBeforeDelete(lstDeletedRequest);
            handler.removeApproverIdsOnParentRecord(lstDeletedRequest);
        }
    }
}