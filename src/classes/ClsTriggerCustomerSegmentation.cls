/**   
* TriggerClass :  ClsTriggerCustomerSegmentation
* 
* Update the values of Division & Business Unit based on selected Product group      
* Release R5
*  
* @author  Abiramasundari Radha (Accenture)
* @created 2015-11-21
* @version 1.0
*
* - Created
*/
public without sharing class ClsTriggerCustomerSegmentation extends ClsTriggerVirtual {
    
     public Id abbBasicAdminProfileId = NULL;
     
     public ClsTriggerCustomerSegmentation(){
         
         Profile[] basicProf = [ SELECT ID, Name FROM Profile WHERE Name =: system.label.ABB_Basic_Admin_Profile_Name];
         abbBasicAdminProfileId = (basicProf != NULL && basicProf.size() > 0) ? basicProf[0].Id : NULL;
     }
   /**
* @see IntHelper.beforeTrigger
*/  
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) { 
        customerSegmentationRecordSharing(trgCtx);                       
        assignProductGroupValues(trgCtx); 
    } 
    
@TestVisible 
    private void assignProductGroupValues(ClsWrappers.TriggerContext trgCtx) {  
      
        Set<String> setProductGroupId = new Set<String>();  
        Set<String> setProductId = new Set<String>(); 
        Set<String> setProductName = new Set<String>();
        Map<Id, String> mapProductGroup = new Map<Id, String>(); 
        Map <ID, Product2> productMap = new Map<Id, Product2> ();
        Map <ID, Product_Group__c> productGroupMap = new Map<Id, Product_Group__c> ();
        Map <String, Product_Group__c> productGroupNameAndPGMap = new Map<String, Product_Group__c> ();
        Map<ID,Schema.RecordTypeInfo> MapCS = Customer_Segmentation__c.sObjectType.getDescribe().getRecordTypeInfosById();
        
        if (trgCtx.isInsert || trgCtx.isUpdate) {

            for (sobject sObj : trgCtx.newList) {                   
                // Add the Record to the List - budget     && custSeg.Product__r.Product_Group__c != NULL 
                Customer_Segmentation__c custSeg = (Customer_Segmentation__c) sObj;   
                Customer_Segmentation__c oldSeg  = (trgCtx.isUpdate) ? (Customer_Segmentation__c)trgCtx.oldMap.get(sObj.ID) : NULL; 
                
                if (trgCtx.isUpdate) {
                
                    if (custSeg.Business_Line_BU__c != oldSeg.Business_Line_BU__c && custSeg.Business_Line_BU__c == NULL) {
                        custSeg.Segment_Level__c = 'Division';
                    }
                    
                    if (custSeg.Product_Group__c  != oldSeg.Product_Group__c && custSeg.Product_Group__c == NULL ) {
                    
                        custSeg.Segment_Level__c = (custSeg.Business_Line_BU__c != NULL) ? 'Business Unit' : 'Division';
                    }
                }
                
                if ((custSeg.Product__c != NULL || custSeg.Product_Group__c != Null) && (trgCtx.isInsert || ( trgCtx.isUpdate && (custSeg.Product__c != oldSeg.Product__c || custSeg.Product_Group__c != oldSeg.Product_Group__c ||
                    custSeg.Business_Line_BU__c != oldSeg.Business_Line_BU__c || custSeg.DIV__c != oldSeg.DIV__c)))){                                    
                    if (custSeg.Product__c != NULL) setProductId.add(custSeg.Product__c); 
                    if (custSeg.Product_Group__c != NULL) setProductGroupId.add(custSeg.Product_Group__c);
                }
            }
            
            if (setProductId.size() > 0) {
                productMap = new Map<Id, Product2> ([SELECT Id, Name,Product_Group__c FROM Product2 WHERE ID IN: setProductId AND Product_Group__c != NULL]);
                for (Product2 prod: productMap.Values()) {
                    setProductName.add(String.ValueOf(prod.Product_Group__c));
                }
            }
            
            if (setProductGroupId.size() > 0 || setProductName.size() > 0) {
                productGroupMap = new Map<Id, Product_Group__c > ([ SELECT ID, Name, Business_Unit__c, Business_Unit_Name__c,Division__c
                            FROM Product_Group__c WHERE ID IN :setProductGroupId OR Name IN :setProductName]); 
                for (Product_Group__c prod: productGroupMap.Values()) {
                    productGroupNameAndPGMap.put(prod.Name, prod);
                }
                
            }
            
            for (sobject sObj : trgCtx.newList) {    
                
                Customer_Segmentation__c custSeg = (Customer_Segmentation__c) sObj;
                String Year = '';
                
                if (custSeg.Product__c != NULL && productMap.containskey(custSeg.Product__c) && 
                            productGroupNameAndPGMap.containsKey(String.valueOf(productMap.get(custSeg.Product__c).Product_Group__c))) {
                    
                    Product_Group__c pg = productGroupNameAndPGMap.get(String.valueOf(productMap.get(custSeg.Product__c).Product_Group__c));               
                    custSeg.Business_Line_BU__c = pg.Business_Unit__c;
                    custSeg.DIV__c = pg.Division__c;
                    custSeg.Product_Group__c = pg.Id;
                    
                } else if (custSeg.Product_Group__c != NULL && productGroupMap.containskey(custSeg.Product_Group__c)) {
                    custSeg.Business_Line_BU__c = productGroupMap.get(custSeg.Product_Group__c).Business_Unit__c;
                    custSeg.DIV__c = productGroupMap.get(custSeg.Product_Group__c).Division__c;
                }else{}
                
                String segment = '';
                if(MapCS.get(custSeg.RecordTypeId).getName().containsIgnoreCase(label.Customer_Segmentation_Record_Type_Name_1) && custSeg.Marketing_Segmentation_Year__c != NULL){
                    Year= custSeg.Marketing_Segmentation_Year__c;
                } else {
                    segment = custSeg.Segment_Level__c;
                }
                   
               
                custSeg.Unique_Check__c = (custSeg.DIV__c != NULL) ? custSeg.DIV__c: '';
                if (custSeg.Business_Line_BU__c != NULL) {
                custSeg.Unique_Check__c += custSeg.Business_Line_BU__c;
                }
                
                if (custSeg.Product_Group__c != NULL) {
                    custSeg.Unique_Check__c += custSeg.Product_Group__c ;
                }
                if (custSeg.Product__c != NULL) {
                    custSeg.Unique_Check__c += custSeg.Product__c;
                }
                
                if (custSeg.Account__c != NULL) {
                    custSeg.Unique_Check__c += custSeg.Account__c;
                }
                custSeg.Unique_Check__c += custSeg.RecordTypeId + Year+segment;
            }
        
        }
    }
    

/**     
Method : customerSegmentationRecordSharing - Method to create/view the customer segmentation record only by Account team member
@author  Ayiravalli Arasu(Accenture)
*/
@TestVisible   
    private void customerSegmentationRecordSharing(ClsWrappers.TriggerContext trgCtx) {
      if(trgCtx.isInsert && trgCtx.isBefore){
            Set<ID> setAccTeamUserIds = new Set<ID>(); //capture the Account team users ids
            Set<ID> setAccIds = new Set<ID>(); //capture the Account Ids
            Map<ID, Set<Id>> mapUsersId = new Map<ID, Set<Id>>();
            Id labelId = Label.CL00075;
            Id userProfileId = Userinfo.getProfileid();
            Id currUser = UserInfo.getUserId();
            
            for(sobject so :trgCtx.newList){
                Customer_Segmentation__c CS = (Customer_Segmentation__c)so;
                setAccIds.add(CS.Account__c);
            }
            for(AccountTeamMember atm : [SELECT id, UserId, AccountId FROM AccountTeamMember where AccountId IN:setAccIds ]){
                if(!mapUsersId.containsKey(atm.AccountId)){
                    mapUsersId.put(atm.AccountId, new Set<ID>());
                }
                mapUsersId.get(atm.AccountId).add(atm.UserId);
            } 
            
            Map<ID, Account> accMap = new Map <Id, Account> ([SELECT ID, OwnerID FROM Account WHERE ID IN :setAccIds]);
             
            for(sobject so : trgCtx.newList){
                Customer_Segmentation__c CS = (Customer_Segmentation__c)so;
                if(CS.Account__c != NULL && mapUsersId.containsKey(CS.Account__c)){
                    setAccTeamUserIds = mapUsersId.get(CS.Account__c);                  
                }
                if(CS.Account__c != NULL && !setAccTeamUserIds.contains(currUser) && currUser != accMap.get(CS.Account__c).OwnerId && abbBasicAdminProfileId != userProfileId)
                {
                so.addError(System.label.Customer_Segmentation_Error_Message);
                }
            }
           
        } 
     }  
 }