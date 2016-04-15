/**
 * TriggerClass -  To share the Product Qualification
 * Release R5
 * @author  Vasanthi M(Accenture)
 * @Description Providing sharing permission to Product Qualification Team objects
 * Created
 
  Purpose: To share the Customer Segmentation
 
  */
  public without sharing class ClsTriggerProductQualificationTeam extends ClsTriggerVirtual {
    
    ID sysAdminProfileId = Label.CL00075;
    Set<Id> adminUserIdSet = new Set<Id>();
    
    /**
     * constructor
    */
    public ClsTriggerProductQualificationTeam() {
        
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
        
        List<Product_Qualification_Team_Role__c> qualList = (trgCtx.IsDelete) ? trgCtx.OldList : trgCtx.newList;
        
        List<Product_Qualification_Team_Role__c> processList = new List<Product_Qualification_Team_Role__c>();
        List<Product_Qualification__Share> tobeInsertedList = new List<Product_Qualification__Share>();
        List<Product_Qualification__Share> tobeDeletedList = new List<Product_Qualification__Share>();
        Map<String, Product_Qualification__Share> existingShareMap = new Map<String, Product_Qualification__Share>();
        Set<Id> productQualIdSet = new Set<Id>();
        Set<Id> userIdSet = new Set<Id>();
        Set<String> ParentIdAndUserIdSet = new Set<String>();
        
        for (Product_Qualification_Team_Role__c segmentTeam: qualList) {
            
            Product_Qualification_Team_Role__c oldsegmentTeam =  (trgCtx.isUpdate) ? (Product_Qualification_Team_Role__c) trgCtx.oldMap.get(segmentTeam.Id) : NULL;
            if (segmentTeam.Product_Qualification__c != NULL && segmentTeam.Access__c != NULL && (trgCtx.IsInsert || trgCtx.IsDelete || (trgCtx.IsUpdate && 
                (oldsegmentTeam.User__c != segmentTeam.User__c || oldsegmentTeam.Access__c != segmentTeam.Access__c )))) {
                
                processList.add(segmentTeam);
                
                if(sysAdminProfileId != UserInfo.getProfileID() && segmentTeam.Product_Qualification_Status__c == Label.Closed){    
                    segmentTeam.addError(Label.System_CL00092);    //CL00092 => You cannot save the changes as Product Qualification Status is Closed.                                               
                }
                if(segmentTeam.User__c != null && segmentTeam.Access__c == null){
                    ClsTriggerFactory.prodQualErrorMsg = false;
                    segmentTeam.Access__c.addError(System.label.CL00097); // CL00097 => Please select access level
                } 
                if (!trgCtx.IsUpdate) {
                    productQualIdSet.add(segmentTeam.Product_Qualification__c);
                    userIdSet.add(segmentTeam.User__c);
                }
                if (trgCtx.IsUpdate) {
                    productQualIdSet.add(oldsegmentTeam.Product_Qualification__c);
                    userIdSet.add(oldsegmentTeam.User__c);
                }
                  
                if(segmentTeam.User__c == segmentTeam.Product_Qualification_OwnerId__c){
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
                    if (ParentIdAndUserIdSet.contains(String.valueOf(segmentTeam.Product_Qualification__c) + segmentTeam.User__c )) {
                        ClsTriggerFactory.prodQualErrorMsg = TRUE;
                        segmentTeam.addError(Label.Bus_Duplicate_Team_User_Err);     //Cannot add Duplicate Users                                              
                    }
                   
                    ParentIdAndUserIdSet.add(String.valueOf(segmentTeam.Product_Qualification__c) + segmentTeam.User__c );
                }   
            }
        }
        
        if (productQualIdSet.size() > 0 && userIdSet.size() > 0) {
            Integer limitRows = Limits.getLimitQueryRows() - Limits.getQueryRows();
            
            for (Product_Qualification__Share share: [ SELECT Id,ParentId, UserOrGroupId FROM Product_Qualification__Share WHERE ParentId IN: productQualIdSet AND USerOrGroupID IN :userIDSet 
                AND RowCause = :Label.System_CL00028 LIMIT :limitRows] ) {
                existingShareMap.put(String.valueOf(share.ParentId) + share.UserOrGroupId, share);
            }
        }
        
      
        for (Product_Qualification_Team_Role__c segmentTeam: processList) {
            
            Product_Qualification_Team_Role__c oldsegmentTeam =  (trgCtx.isUpdate) ? (Product_Qualification_Team_Role__c) trgCtx.oldMap.get(segmentTeam.Id) : NULL;
            
            if ((trgCtx.isInsert || (trgCtx.IsUpdate && oldsegmentTeam.User__c != segmentTeam.User__c)) && existingShareMap.containsKey(String.valueOf(segmentTeam.Product_Qualification__c)+segmentTeam.User__c)) {
                segmentTeam.addError(Label.CL00032);   // CL00032 => You cannot add an existing User to the Qualification Team.
            } else if (trgCtx.isInsert || trgCtx.IsUpdate) {
                
                Product_Qualification__Share newShare = new Product_Qualification__Share(ParentId = segmentTeam.Product_Qualification__c, USerOrGroupId = segmentTeam.USer__c, RowCause = System.label.System_CL00028); //System_CL00027 => RowCause , System_CL00028 => 'Manual');
                if(segmentTeam.Access__c == System.label.System_CL00037){  //System_CL00037 => Read/Write
                    newShare.AccessLevel = System.label.System_CL00026;    //System_CL00025 => AccessLevel ,System_CL00026 => 'Edit'
                }
               
                tobeInsertedList.add(newShare);
            } 
            
            if (trgCtx.IsDelete && existingShareMap.containsKey(String.valueOf(segmentTeam.Product_Qualification__c)+segmentTeam.User__c)) {
                tobeDeletedList.add(existingShareMap.get(String.valueOf(segmentTeam.Product_Qualification__c)+segmentTeam.User__c));
            }
            
            if (trgCtx.IsUpdate && oldsegmentTeam.User__c != segmentTeam.User__c && existingShareMap.containsKey(String.valueOf(oldsegmentTeam.Product_Qualification__c)+oldsegmentTeam.User__c)) {
                tobeDeletedList.add(existingShareMap.get(String.valueOf(oldsegmentTeam.Product_Qualification__c)+oldsegmentTeam.User__c));
            }
        }
        
        try {
            if (tobeDeletedList.size() > 0) Database.Delete(tobeDeletedList,False);
            if (tobeInsertedList.size() > 0) Database.Upsert(tobeInsertedList,False);
            
        }Catch(DMLException de) {
            String error = '';
                
            for(Integer i=0;i<de.getNumDml();i++) {            
                error += de.getDmlMessage(i) +Label.Line_Break;
            }
            
            for (Product_Qualification_Team_Role__c segmentTeam: processList) {
                segmentTeam.addError(error, FALSE);
            }
        }
    }
}