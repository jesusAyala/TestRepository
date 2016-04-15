/**   
* TriggerClass :  ClsTriggerPlanAction
* 
* To create Action_Information_Channel_Business_Revi__c
* Release R5
*  
* @author  Indhu Ramalingam (Accenture)
* @created 2016-3-25
* @version 1.0
*
* - Created
*/
public without sharing class ClsTriggerPlanAction extends ClsTriggerVirtual {
        
   
    Integer remLimit;     
    
    
/**
* @see IntHelper.AfterTrigger
*To copy the Action from Channel Partner Business Plan
*/  
    public override void bulkAfter(ClsWrappers.TriggerContext trgCtx) {
        if (trgCtx.isInsert) {
            copyPlanAction(trgCtx);
        }     
        if (trgCtx.isUpdate) {
            updatePlanAction(trgCtx);
        }
    }
/**    
*To copy Actions from Channel Partner Business Plan to Channel Partner Business Review
*/  
    public void copyPlanAction(ClsWrappers.TriggerContext trgCtx){
        
        List<Action_Information_Channel_Business_Revi__c> actionReviewList = new List<Action_Information_Channel_Business_Revi__c>();
        Map<Id, List<Joint_Business_Plan_Actions__c >> planIDActionListMap  = new Map<Id, List<Joint_Business_Plan_Actions__c >>();
        
        for (Sobject sobj : trgCtx.newList) {
        
            Joint_Business_Plan_Actions__c planAction = (Joint_Business_Plan_Actions__c)sObj;            
            if (planAction.Joint_Business_Plan__c != NULL) {
                if (!planIDActionListMap.containsKey(planAction.Joint_Business_Plan__c)) {
                    planIDActionListMap.put(planAction.Joint_Business_Plan__c, new List<Joint_Business_Plan_Actions__c>());
                }
                planIDActionListMap.get(planAction.Joint_Business_Plan__c).add(planAction);
            }
        }
        
        if (!planIDActionListMap.isEmpty()) {
            
            remLimit =  limits.getLimitQueryRows() - limits.getQueryRows(); 
            
            for (Channel_Business_Review__c channel : [SELECT Id, Joint_Business_Plan__c FROM Channel_Business_Review__c WHERE Joint_Business_Plan__c IN : planIDActionListMap.KeySet() LIMIT :remLimit ] ) {
                
                for (Joint_Business_Plan_Actions__c actionPlan: planIDActionListMap.get(channel.Joint_Business_Plan__c)) {
                    
                    Action_Information_Channel_Business_Revi__c actionReview = new Action_Information_Channel_Business_Revi__c();
                    actionReview.Channel_Partner_Business_Review__c = channel.Id;
                    actionReview.Action__c = actionPlan.Id;
                    actionReview.Action_Description__c = actionPlan.Action_Description__c;
                    actionReview.Comments__c = actionPlan.Comments__c;
                    actionReviewList.add(actionReview);
                }
            }
        }
        
        try {
            if (actionReviewList.size() > 0) {
                insert actionReviewList;
            }
        } Catch(DMLException e) {
            String err = '';
            for (Integer i = 0; i < e.getNumDML(); i++) {
                err += e.getDMLMessage(i) +Label.Line_Break;
            }
            
            for (Sobject sobj : trgCtx.newList) {
                sobj.addError(err, false);
            }
        }
    }
    
    public void updatePlanAction(ClsWrappers.TriggerContext trgCtx) {
        
        Set<Id> planActionIdSet = new Set<Id>();
        Map<ID, Joint_Business_Plan_Actions__c> jbpActionMap = new Map<Id, Joint_Business_Plan_Actions__c>();
        for (Joint_Business_Plan_Actions__c action : (List<Joint_Business_Plan_Actions__c>) trgCtx.newList) {
            Joint_Business_Plan_Actions__c oldAction = (Joint_Business_Plan_Actions__c) trgCtx.oldMap.get(action.Id);
            
            if (action.Action_Description__c != oldAction.Action_Description__c || action.Comments__c != oldAction.Comments__c) {
                planActionIdSet.add(action.Id);
                jbpActionMap.put(action.Id, action);
            }
        }
        
        if (planActionIdSet.size() > 0) {
             
             List<Action_Information_Channel_Business_Revi__c> infoList = [ SELECT Id, Action_Description__c, Comments__c, Channel_Partner_Business_Review__c, Action__c  FROM Action_Information_Channel_Business_Revi__c 
                 WHERE Action__c IN :planActionIdSet];
             
             for (Action_Information_Channel_Business_Revi__c rev: infoList ) {
                 rev.Action_Description__c = jbpActionMap.get(rev.Action__c).Action_Description__c;
                 rev.Comments__c = jbpActionMap.get(rev.Action__c).Comments__c;
             }
             
             try {
                 if (infoList.size() > 0) update infoList ;
             }Catch(DMLException e) {
                  for (Joint_Business_Plan_Actions__c action : (List<Joint_Business_Plan_Actions__c>) trgCtx.newList) {
                      action.addError(e.getDMLMessage(0));
                  }
             }
             
         }    
    }
    
}