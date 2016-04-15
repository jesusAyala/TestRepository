/**
 * TriggerClass -  To share the Customer Segmentation
 * Release R5
 * @author  Vasanthi M(Accenture)
 * @created 2016-03-08
 * @version 1.0
 * Created
 
  Purpose: To share the Customer Segmentation
 
  */
  public without sharing class ClsTriggerCustomerSegmentTeam extends ClsTriggerVirtual {
    
    
    Set<Id> adminUserIdSet = new Set<Id>();
    
    /**
     * constructor
    */
    public ClsTriggerCustomerSegmentTeam() {
        
        Map<Id, User> adminUserMap = new Map<Id, User> ([ SELECT Id, Name FROM User WHERE Profile.Name =: Label.Sys_Admin_Profile_Name AND IsActive = TRUE LIMIT 50000]);
        adminUserIdSet.addAll(adminUserMap.KeySet());
    }   
    
        
    /**
     * @see IntHelper.afterTrigger
    */
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
        createOrRemoveShare(trgCtx);
    }
    
/**    
 * To grant/revoke access
*/ 
    public void createOrRemoveShare(ClsWrappers.TriggerContext trgCtx) {
        
        system.debug(':::trgCtx:::'+trgCtx);
        List<Customer_Segmentation_Team__c> qualList = (trgCtx.IsDelete) ? trgCtx.OldList : trgCtx.newList;
        
        List<Customer_Segmentation_Team__c> processList = new List<Customer_Segmentation_Team__c>();
        List<Customer_Segmentation__Share> tobeInsertedList = new List<Customer_Segmentation__Share>();
        List<Customer_Segmentation__Share> tobeDeletedList = new List<Customer_Segmentation__Share>();
        Map<String, Customer_Segmentation__Share> existingShareMap = new Map<String, Customer_Segmentation__Share>();
        Set<Id> segmentIDSet = new Set<Id>();
        Set<Id> userIdSet = new Set<Id>();
        Set<String> ParentIdAndUserIdSet = new Set<String>();  
        
        for (Customer_Segmentation_Team__c segmentTeam: qualList) {
            
            Customer_Segmentation_Team__c oldsegmentTeam =  (trgCtx.isUpdate) ? (Customer_Segmentation_Team__c) trgCtx.oldMap.get(segmentTeam.Id) : NULL;
            if (segmentTeam.Customer_Segmentation__c != NULL && segmentTeam.Access__c != NULL && (trgCtx.IsInsert || trgCtx.IsDelete || (trgCtx.IsUpdate && 
                (oldsegmentTeam.User__c != segmentTeam.User__c || oldsegmentTeam.Access__c != segmentTeam.Access__c )))) {
                
                processList.add(segmentTeam);
                
                if(segmentTeam.User__c != null && segmentTeam.Access__c == null){
                    ClsTriggerFactory.prodQualErrorMsg = false;
                    segmentTeam.Access__c.addError(System.label.CL00097); // CL00097 => Please select access level
                } 
                if (!trgCtx.IsUpdate) {
                    segmentIDSet.add(segmentTeam.Customer_Segmentation__c);
                    userIdSet.add(segmentTeam.User__c);
                }
                if (trgCtx.IsUpdate) {
                    segmentIDSet.add(oldsegmentTeam.Customer_Segmentation__c);
                    userIdSet.add(oldsegmentTeam.User__c);
                }
                  
                if(segmentTeam.User__c == segmentTeam.Customer_Segment_Owner_ID__c){
                    ClsTriggerFactory.prodQualErrorMsg = TRUE;
                    segmentTeam.addError(System.label.CL00031); // CL00031=> Record Owner has access already.
                }
                
                if (!trgCtx.IsDelete) {
                    if(segmentTeam.User__c != null && adminUserIdSet.contains(segmentTeam.User__c)){
                        ClsTriggerFactory.prodQualErrorMsg = TRUE;
                        segmentTeam.addError(Label.System_CL00094); // System_CL00094 = > Cannot add System Administrator as a User 
                    }   
                }
                
                if( segmentTeam.User__c == Userinfo.getUserid() && !trgCtx.isInsert){    
                    ClsTriggerFactory.prodQualErrorMsg = TRUE;
                    segmentTeam.adderror(Label.System_CL00095);   //System_CL00095 => Cannot edit/delete yourself. Please contact Record owner or System Administrator. 
                }
                
                if(segmentTeam.User__c != null) {
                    if (ParentIdAndUserIdSet.contains(String.valueOf(segmentTeam.Customer_Segmentation__c) + segmentTeam.User__c )) {
                        ClsTriggerFactory.prodQualErrorMsg = TRUE;
                        segmentTeam.addError(Label.Bus_Duplicate_Team_User_Err);     //Cannot add Duplicate Users                                              
                    }
                   
                    ParentIdAndUserIdSet.add(String.valueOf(segmentTeam.Customer_Segmentation__c) + segmentTeam.User__c );
                }   
            }
        }
        
        if (segmentIDSet.size() > 0 && userIdSet.size() > 0) {
            Integer limitRows = Limits.getLimitQueryRows() - Limits.getQueryRows();
            
            for (Customer_Segmentation__Share share: [ SELECT Id,ParentId, UserOrGroupId FROM Customer_Segmentation__Share WHERE ParentId IN: segmentIDSet AND USerOrGroupID IN :userIDSet 
                AND RowCause = :Label.System_CL00028 LIMIT :limitRows] ) {
                existingShareMap.put(String.valueOf(share.ParentId) + share.UserOrGroupId, share);
            }
        }
        
      
        for (Customer_Segmentation_Team__c segmentTeam: processList) {
            
            Customer_Segmentation_Team__c oldsegmentTeam =  (trgCtx.isUpdate) ? (Customer_Segmentation_Team__c) trgCtx.oldMap.get(segmentTeam.Id) : NULL;
            
            if ((trgCtx.isInsert || (trgCtx.IsUpdate && oldsegmentTeam.User__c != segmentTeam.User__c)) && existingShareMap.containsKey(String.valueOf(segmentTeam.Customer_Segmentation__c)+segmentTeam.User__c)) {
                segmentTeam.addError(Label.Cannot_add_an_Existing_User_R5); //You cannot add an existing User to the Team
            } else if (trgCtx.isInsert || trgCtx.IsUpdate) {
                
                Customer_Segmentation__Share newShare = new Customer_Segmentation__Share(ParentId = segmentTeam.Customer_Segmentation__c, USerOrGroupId = segmentTeam.USer__c, RowCause = System.label.System_CL00028); //System_CL00027 => RowCause , System_CL00028 => 'Manual');
                if(segmentTeam.Access__c == System.label.System_CL00037){  //System_CL00037 => Read/Write
                    newShare.AccessLevel = System.label.System_CL00026;    //System_CL00025 => AccessLevel ,System_CL00026 => 'Edit'
                }
               
                tobeInsertedList.add(newShare);
            } 
            
            if (trgCtx.IsDelete && existingShareMap.containsKey(String.valueOf(segmentTeam.Customer_Segmentation__c)+segmentTeam.User__c)) {
                tobeDeletedList.add(existingShareMap.get(String.valueOf(segmentTeam.Customer_Segmentation__c)+segmentTeam.User__c));
            }
            
            if (trgCtx.IsUpdate && oldsegmentTeam.User__c != segmentTeam.User__c && existingShareMap.containsKey(String.valueOf(oldsegmentTeam.Customer_Segmentation__c)+oldsegmentTeam.User__c)) {
                tobeDeletedList.add(existingShareMap.get(String.valueOf(oldsegmentTeam.Customer_Segmentation__c)+oldsegmentTeam.User__c));
            }
        }
        
        try {
            if (tobeDeletedList.size() > 0) delete tobeDeletedList;
            if (tobeInsertedList.size() > 0)  Upsert tobeInsertedList;
            
        }Catch(DMLException de) {
            String error = '';
                
            for(Integer i=0;i<de.getNumDml();i++) {            
                error += de.getDmlMessage(i) +Label.Line_Break;
            }
            
            for (Customer_Segmentation_Team__c segmentTeam: processList) {
                segmentTeam.addError(error, FALSE);
            }
        }
    }
}