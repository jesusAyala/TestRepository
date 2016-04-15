/**   
* TriggerClass on the Channel Market Coverage Product Lines object to automatically populate BU, DIV, PG based on Product.
*       
* Release R5
*  
* @author  Indhu Selvi Ramalingam (Accenture)
* @created 2016-01-27
* @version 1.0
*
* - Created
*/
public without sharing class ClsTriggerChannelMarCovProductLines extends ClsTriggerVirtual {
    
/**
* @see IntHelper.beforeTrigger
*/  
public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx){        
    assignProductGroupValues(trgCtx);    
}
    
    
/**
* @see IntHelper.afterTrigger
*/   
public override void afterTrigger(ClsWrappers.TriggerContext trgCtx){        
    concatenateProductLine(trgCtx);
    concatenateBU(trgCtx);
    concatenatePG(trgCtx);                  
}

/**
* @see IntHelper.bulkBefore
*/     
public override void bulkBefore(ClsWrappers.TriggerContext trgCtx){   
        if (trgCtx.isUpdate || trgCtx.isDelete){                        
            permissionChecking(trgCtx);
        }
    }

/**
* @see IntHelper.bulkAfter
*/    
public override void bulkAfter(ClsWrappers.TriggerContext trgCtx){       
        if (trgCtx.isUpdate) {
            syncWithSalesTargetResults(trgCtx);
        }
    }

/**
* void method syncWithSalesTargetResults
*/     
public void syncWithSalesTargetResults(ClsWrappers.TriggerContext trgCtx) {
    
         if (trgCtx.isUpdate) {
        
            Map<String ,Channel_Market_Coverage_Product_Lines__c> cmcpToUpdateMap = new Map<String, Channel_Market_Coverage_Product_Lines__c>();
            Set<ID> channelMarketScopeIdSet = new Set<Id>();
            Set<ID> productIdSet = new Set<Id>();
            List<Joint_Business_Plan_Product_Lines__c> updateList = new List<Joint_Business_Plan_Product_Lines__c> ();
            
            for(Channel_Market_Coverage_Product_Lines__c cp : (List<Channel_Market_Coverage_Product_Lines__c>) trgCtx.newList){
                
                Channel_Market_Coverage_Product_Lines__c oldCp = (Channel_Market_Coverage_Product_Lines__c) trgCtx.oldMap.get(cp.id);
                
                if(cp.Channel_Market_Coverage__c != NULL && cp.Product__c != oldCp.Product__c 
                        || cp.Target_Lead_Times__c != oldCp.Target_Lead_Times__c
                        || //cp.Targeted_Stock__c != oldCp.Targeted_Stock__c || 
                        cp.Planned_Stock__c != oldCp.Planned_Stock__c || cp.Actual_Stock__c != oldCp.Actual_Stock__c
                        || cp.Other_Information__c != oldCp.Other_Information__c){
                    
                    if(oldCp.Product__c != null){
                        cmcpToUpdateMap.put(String.ValueOf(cp.Channel_Market_Coverage__c) + oldCp.Product__c , cp);
                        productIdSet.add(oldCp.Product__c);
                    }
                    
                    //if(cp.Product__c != null){
                       // cmcpToUpdateMap.put(String.ValueOf(cp.Channel_Market_Coverage__c) + cp.Product__c , cp);
                       // productIdSet.add(cp.Product__c);
                    //}
                    
                    ChannelMarketScopeIdSet.add(cp.Channel_Market_Coverage__c);
                }
            }
            
            Integer limitRow = Limits.getLimitQueryRows() - Limits.getQueryRows();
            
       //     List<Joint_Business_Plan_Product_Lines__c> jbppList = [SELECT Id, Product__c, Product_Group__c, Division__c, Business_Unit_Name__c, Division_Name__c, Business_Unit__c, Joint_Business_Plan__r.Channel_Market_Coverage__c, Target_Lead_Times__c,  Planned_Stock__c, Actual_Stock__c
       //         FROM Joint_Business_Plan_Product_Lines__c WHERE Joint_Business_Plan__r.Channel_Market_Coverage__c IN :channelMarketScopeIdSet AND Product__c IN :productIdSet LIMIT :limitRow];                      
            
            for (Joint_Business_Plan_Product_Lines__c lines: [SELECT Id, Product__c, 
                                                              Product_Group__c, Division__c, Business_Unit_Name__c, 
                                                              Division_Name__c, Business_Unit__c, 
                                                              Joint_Business_Plan__r.Channel_Market_Coverage__c, 
                                                              Target_Lead_Times__c,  Planned_Stock__c, Actual_Stock__c
                                                              FROM Joint_Business_Plan_Product_Lines__c 
                                                              WHERE Joint_Business_Plan__r.Channel_Market_Coverage__c IN :channelMarketScopeIdSet AND Product__c IN :productIdSet LIMIT :limitRow]) {
                
                if (cmcpToUpdateMap.containsKey(String.ValueOf(lines.Joint_Business_Plan__r.Channel_Market_Coverage__c) + lines.Product__c)) {
                
                    Channel_Market_Coverage_Product_Lines__c markCoverProds = cmcpToUpdateMap.get(String.ValueOf(lines.Joint_Business_Plan__r.Channel_Market_Coverage__c) + lines.Product__c);
                    lines.Product__c = markCoverProds.Product__c;
                    lines.Target_Lead_Times__c = markCoverProds.Target_Lead_Times__c;
                  //  lines.Targeted_Stock__c = markCoverProds.Targeted_Stock__c;
                    lines.Planned_Stock__c = markCoverProds.Planned_Stock__c;
                    lines.Product_Group__c = markCoverProds.Product_Group__c;
                    lines.Actual_Stock__c = markCoverProds.Actual_Stock__c;
                    lines.Other_Information__c = markCoverProds.Other_Information__c;
                    lines.Business_Unit__c = markCoverProds.Business_Unit__c;
                    lines.Division__c = markCoverProds.Division__c;
                    lines.Business_Unit_Name__c = markCoverProds.Business_Unit_Name__c;
                    lines.Division_Name__c = markCoverProds.Division_Name__c;
                    
                    updateList.add(lines);
                }
            }
            
            try {
               
                if (updateList.size() > 0){
                   Database.update(updateList);
                }   
            } Catch(DMLException e) {
                String error = '';
                for (Integer i = 0; i < e.getnumDML(); i++) {
                    error += e.getDMLMessage(i) + System.label.Line_Break;
                }
                
                for (Sobject sobj: trgCtx.newList) {
                    sobj.addError(error, FALSE);
                }
            }
        }
    }
   
   public Id abbBasicAdminProfileId ;
   
/**
* void method permissionChecking
*/    
   public void permissionChecking(ClsWrappers.TriggerContext trgCtx) {
        
        Map<Id, Set<Id>> accIdAndAccTeamMemberIdSetMap = new Map<Id, Set<Id>>();
    //    Map<Id, Id> accIdAndOwnerIdMap = new Map<Id, Id> ();
        Set<ID> accountIdSet = new Set<ID>();
        Integer limitrow =  limits.getLimitQueryRows() - limits.getQueryRows(); 
        
        List<Sobject> objList = (trgCtx.isDelete) ? trgCtx.oldList : trgCtx.newList;
        for (Sobject sobj: objList) {
            
            Channel_Market_Coverage_Product_Lines__c channel = (Channel_Market_Coverage_Product_Lines__c) sobj;
            //system.debug(':acc ID::'+channel.Account_ID__c);   
            accountIdSet.add(channel.Account_ID__c);            
        }
        
        if (accountIdSet.size() > 0) {
            
            Profile[] basicProf = [ SELECT ID, Name FROM Profile WHERE Name = :system.label.ABB_Basic_Admin_Profile_Name LIMIT :limitrow];
            abbBasicAdminProfileId = (basicProf != NULL && basicProf.size() > 0) ? basicProf[0].Id : NULL; 
            Id userProfileId = Userinfo.getProfileid();
            
        //    List<AccountTeamMember> accTeamList = [ SELECT id, UserId, AccountId FROM AccountTeamMember WHERE AccountId IN: accountIdSet];
            
            for (AccountTeamMember team: [ SELECT id, UserId, AccountId FROM AccountTeamMember WHERE AccountId IN: accountIdSet LIMIT :limitrow]) {
                
                if (!accIdAndAccTeamMemberIdSetMap.containsKey(team.AccountId)) {
                    
                    accIdAndAccTeamMemberIdSetMap.put(team.AccountId, new Set<ID>());
                }
                accIdAndAccTeamMemberIdSetMap.get(team.AccountId).add(team.USerId);
            }                                 
            
            ID currUser = UserInfo.getUSerId();
            
            for (Sobject sobj: objList) {
            
                Channel_Market_Coverage_Product_Lines__c channel = (Channel_Market_Coverage_Product_Lines__c) sobj;   
                Set<ID> setAccTeamUserIds = accIdAndAccTeamMemberIdSetMap.get(channel.Account_ID__c); 
                                
                if(channel.Account_ID__c != NULL && (setAccTeamUserIds == NULL 
                   || (setAccTeamUserIds != NULL && !setAccTeamUserIds.contains(currUser))) 
                   && currUser != channel.Account_Owner_Id__c && abbBasicAdminProfileId != userProfileId ){
                    channel.addError(System.label.System_CL00102);
                }           
            }
        }
    }

/**
* void method assignProductGroupValues
*/     
    @TestVisible 
    private void assignProductGroupValues(ClsWrappers.TriggerContext trgCtx) {  
      
        Set<String> setProductGroupId = new Set<String>();  
        Set<String> setProductId = new Set<String>(); 
        Set<String> setProductName = new Set<String>();
   //     Map<Id, String> mapProductGroup = new Map<Id, String>(); 
        Map <ID, Product2> productMap = new Map<Id, Product2> ();
        Map <ID, Product_Group__c> productGroupMap = new Map<Id, Product_Group__c> ();
        Map <String, Product_Group__c> productGroupNameAndPGMap = new Map<String, Product_Group__c> ();
   //     Map<ID,Schema.RecordTypeInfo> MapCS = Customer_Segmentation__c.sObjectType.getDescribe().getRecordTypeInfosById();
        List<Channel_Market_Coverage_Product_Lines__c> jbpList = new List<Channel_Market_Coverage_Product_Lines__c>();
        
        if (trgCtx.isInsert || trgCtx.isUpdate) {

            for (Channel_Market_Coverage_Product_Lines__c jbp : (List<Channel_Market_Coverage_Product_Lines__c>) trgCtx.newList) {  
            
                Channel_Market_Coverage_Product_Lines__c oldJbp  = (trgCtx.isUpdate) ? (Channel_Market_Coverage_Product_Lines__c)trgCtx.oldMap.get(jbp.ID) : NULL; 
                
                if ((jbp.Product__c != NULL || jbp.Product_Group__c != Null) && (trgCtx.isInsert || ( trgCtx.isUpdate && (jbp.Product__c != oldJbp.Product__c || jbp.Product_Group__c != oldJbp.Product_Group__c)))){                                    
                    if (jbp.Product__c != NULL){
                       setProductId.add(jbp.Product__c); 
                    }    
                    if (jbp.Product__c == NULL && jbp.Product_Group__c != NULL){
                       setProductName.add(jbp.Product_Group__c);
                    }   
                    jbpList.add(jbp);
                }
            }
            
            if (setProductId.size() > 0) {
                productMap = new Map<Id, Product2> ([SELECT Id, Name,Product_Group__c FROM Product2 WHERE ID IN: setProductId LIMIT 50000]);
                for (Product2 prod: productMap.Values()) {
                    if (prod.Product_Group__c != NULL) {
                        setProductName.add(String.ValueOf(prod.Product_Group__c));
                    }
                }
            }
            
            if (setProductGroupId.size() > 0 || setProductName.size() > 0) {
                productGroupMap = new Map<Id, Product_Group__c > ([ SELECT ID, Name, Business_Unit__c, 
                                                                    Business_Unit_Name__c, Division__c, Division_Name__c 
                                                                    FROM Product_Group__c 
                                                                    WHERE ID IN :setProductGroupId OR Name IN :setProductName LIMIT 50000]); 
                for (Product_Group__c prod: productGroupMap.Values()) {
                    productGroupNameAndPGMap.put(prod.Name, prod);
                }
                
            }
            
            
            for (Channel_Market_Coverage_Product_Lines__c jbp : jbpList) {    
                
                
                if (jbp.Product__c != NULL && productMap.containskey(jbp.Product__c) && productMap.get(jbp.Product__c).Product_Group__c != NULL &&
                            productGroupNameAndPGMap.containsKey(String.valueOf(productMap.get(jbp.Product__c).Product_Group__c))) {
                    
                    Product_Group__c pg = productGroupNameAndPGMap.get(String.valueOf(productMap.get(jbp.Product__c).Product_Group__c));               
                    jbp.Business_Unit__c  = pg.Business_Unit__c;
                    jbp.Division__c  = pg.Division__c;
                    jbp.Product_Group__c = pg.Name;
                    jbp.Business_Unit_Name__c = pg.Business_Unit_Name__c;
                    jbp.Division_Name__c = pg.Division_Name__c;                
                }else if (jbp.Product__c != NULL && productMap.containskey(jbp.Product__c) && productMap.get(jbp.Product__c).Product_Group__c == NULL) {
                    jbp.Product_Group__c = '';
                    jbp.Business_Unit__c  = '';
                    jbp.Division__c  = '';
                    jbp.Business_Unit_Name__c = '';
                    jbp.Division_Name__c = ''; 
                }else if (jbp.Product__c == NULL && jbp.Product_Group__c != NULL && productGroupNameAndPGMap.containskey(jbp.Product_Group__c)) {
                    jbp.Business_Unit__c = productGroupNameAndPGMap.get(jbp.Product_Group__c).Business_Unit__c;
                    jbp.Division__c = productGroupNameAndPGMap.get(jbp.Product_Group__c).Division__c;
                    jbp.Business_Unit_Name__c = productGroupNameAndPGMap.get(jbp.Product_Group__c).Business_Unit_Name__c;
                    jbp.Division_Name__c = productGroupNameAndPGMap.get(jbp.Product_Group__c).Division_Name__c;    
                } else {}
            }
        }
    }
    
/*     
Method : Concatenate all the Product Line and Update in Channel Market Coverage
@author  Indhu Selvi Ramalingam (Accenture)
*/ 
    @TestVisible 
    private void concatenateProductLine(ClsWrappers.TriggerContext trgCtx) { 
        
        Set<String> setCMCId = new Set<String>();   
        MAP <ID,Channel_Market_Coverage__c> mapCMCHeader = new Map <ID,Channel_Market_Coverage__c>();
        
        if (trgCtx.isInsert || trgCtx.isUpdate ) {           
            for (sobject sObj : trgCtx.newList) {                           
                // Add the Record to the List   
                Channel_Market_Coverage_Product_Lines__c compCMC = (Channel_Market_Coverage_Product_Lines__c)sObj;    
                if (compCMC.Channel_Market_Coverage__c != NULL ){
                    setCMCId.add(compCMC.Channel_Market_Coverage__c);                                                                 
                }
            } 
        }
        
      if (trigger.isDelete) { 
            for (sobject sObj : trgCtx.oldList) {
                Channel_Market_Coverage_Product_Lines__c compCMC = (Channel_Market_Coverage_Product_Lines__c)sObj;    
                if (compCMC.Channel_Market_Coverage__c != NULL ){

                     setCMCId.add(compCMC.Channel_Market_Coverage__c);                        
               }
            }
        } 
      
        for(Channel_Market_Coverage__c channelMarCov:[Select Id, Product_Line1__c 
                                                      FROM Channel_Market_Coverage__c 
                                                      WHERE Id IN : setCMCId LIMIT 50000]){
            channelMarCov.Product_Line1__c=NULL;
            mapCMCHeader.put(channelMarCov.Id,channelMarCov);
        }
        
        for(Channel_Market_Coverage_Product_Lines__c compProdQual : [Select Id, Product__r.Name, Product__c, 
                                                                     Channel_Market_Coverage__c 
                                                                     FROM Channel_Market_Coverage_Product_Lines__c 
                                                                     WHERE Channel_Market_Coverage__c IN : setCMCId AND Product__r.Name != null  LIMIT 50000]){
                 
                if(mapCMCHeader.get(compProdQual.Channel_Market_Coverage__c).Product_Line1__c == NULL)
                {
                        mapCMCHeader.get(compProdQual.Channel_Market_Coverage__c).Product_Line1__c = compProdQual.Product__r.Name;                       
                }
                else if(mapCMCHeader.get(compProdQual.Channel_Market_Coverage__c).Product_Line1__c != NULL)
                {
                        mapCMCHeader.get(compProdQual.Channel_Market_Coverage__c).Product_Line1__c += Label.System_CL00046 + compProdQual.Product__r.Name;                        
                }else{}
        }
        
        for(Channel_Market_Coverage__c prodRows:mapCMCHeader.values()){
         String strName1 = null;
         String strName2 = null;
         Channel_Market_Coverage__c iChannelMar = prodRows;
         
         if(iChannelMar.Product_Line1__c != NULL && iChannelMar.Product_Line1__c.lastIndexOf(Label.System_CL00046) >= 0  ){
             strName1 = iChannelMar.Product_Line1__c.subString(0,iChannelMar.Product_Line1__c.lastIndexOf(Label.System_CL00046));
             strName2 = iChannelMar.Product_Line1__c.subString(iChannelMar.Product_Line1__c.lastIndexOf(Label.System_CL00046)+1);
          
             iChannelMar.Product_Line1__c = strName1 + Label.System_CL00046 + strName2;
             mapCMCHeader.put(prodRows.Id,iChannelMar);
              
         }
       }         
               Database.Update(mapCMCHeader.values());                     
    }   

/*     
Method : Concatenate all the BU and Update in Channel Market Coverage.
@author  Indhu Selvi Ramalingam (Accenture)
*/ 
    @TestVisible 
    private void concatenateBU(ClsWrappers.TriggerContext trgCtx) { 
        
        Set<String> setChanMarCovId = new Set<String>();   
        MAP <ID,Channel_Market_Coverage__c> mapChanMarCovHeader = new Map <ID,Channel_Market_Coverage__c>();
        
        if (trgCtx.isInsert || trgCtx.isUpdate ) {           
            for (sobject sObj : trgCtx.newList) {                           
                // Add the Record to the List   
                Channel_Market_Coverage_Product_Lines__c sobjCMC = (Channel_Market_Coverage_Product_Lines__c)sObj;    
                if (sobjCMC.Channel_Market_Coverage__c != NULL ){
                    setChanMarCovId.add(sobjCMC.Channel_Market_Coverage__c);                                                                 
                }
            } 
        }
        
      if (trigger.isDelete) { 
            for (sobject sObj : trgCtx.oldList) {
                Channel_Market_Coverage_Product_Lines__c sobjCMC = (Channel_Market_Coverage_Product_Lines__c)sObj;    
                if (sobjCMC.Channel_Market_Coverage__c != NULL ){

                     setChanMarCovId.add(sobjCMC.Channel_Market_Coverage__c);                        
               }
            }
        } 
      
        for(Channel_Market_Coverage__c chanMarCov:[Select Id, BU_Covered__c 
                                                   FROM Channel_Market_Coverage__c 
                                                   WHERE Id IN : setChanMarCovId LIMIT 50000]){
            chanMarCov.BU_Covered__c = NULL;
            mapChanMarCovHeader.put(chanMarCov.Id,chanMarCov);
        }
        
        for(Channel_Market_Coverage_Product_Lines__c chanMarCov1 : [Select Id, Channel_Market_Coverage__c, 
                                                                    Business_Unit__c 
                                                                    FROM Channel_Market_Coverage_Product_Lines__c 
                                                                    WHERE Channel_Market_Coverage__c IN : setChanMarCovId AND Business_Unit__c != null  LIMIT 50000]){
                 
                if(mapChanMarCovHeader.get(chanMarCov1.Channel_Market_Coverage__c).BU_Covered__c == NULL)
                {                    
                        mapChanMarCovHeader.get(chanMarCov1.Channel_Market_Coverage__c).BU_Covered__c = chanMarCov1.Business_Unit__c;                       
                }
                else if(mapChanMarCovHeader.get(chanMarCov1.Channel_Market_Coverage__c).BU_Covered__c != NULL)
                {
                    //Checking duplicate BU values
                    String mapBUValues = mapChanMarCovHeader.get(chanMarCov1.Channel_Market_Coverage__c).BU_Covered__c;
                    if(mapBUValues.contains(Label.System_CL00046)){
                        List<String> splitBUValues= mapBUValues.split(System.label.System_CL00046);
                        Set<String> setBUValues = new Set<String>();
                        
                        setBUValues.addall(splitBUValues);
                        
                        if(!setBUValues.contains(chanMarCov1.Business_Unit__c)){
                             mapChanMarCovHeader.get(chanMarCov1.Channel_Market_Coverage__c).BU_Covered__c += Label.System_CL00046 + chanMarCov1.Business_Unit__c;  
                        }
                    } else {
                        if(!mapBUValues.contains(chanMarCov1.Business_Unit__c)){
                             mapChanMarCovHeader.get(chanMarCov1.Channel_Market_Coverage__c).BU_Covered__c += Label.System_CL00046 + chanMarCov1.Business_Unit__c;  
                        }                                          
                     } 
               }  
               if ( mapChanMarCovHeader.get(chanMarCov1.Channel_Market_Coverage__c).BU_Covered__c != NULL) {
                   mapChanMarCovHeader.get(chanMarCov1.Channel_Market_Coverage__c).BU_Count__c = mapChanMarCovHeader.get(chanMarCov1.Channel_Market_Coverage__c).BU_Covered__c.split(Label.System_CL00046).size(); 
               }else{}     
         }   
       
        for(Channel_Market_Coverage__c prodRows:mapChanMarCovHeader.values()){
            String strName1 = null;
            String strName2 = null;
            Channel_Market_Coverage__c iChannelMar = prodRows;
            
            if(iChannelMar.BU_Covered__c != NULL && iChannelMar.BU_Covered__c.lastIndexOf(Label.System_CL00046) >= 0  ){
                strName1 = iChannelMar.BU_Covered__c.subString(0,iChannelMar.BU_Covered__c.lastIndexOf(Label.System_CL00046));
                strName2 = iChannelMar.BU_Covered__c.subString(iChannelMar.BU_Covered__c.lastIndexOf(Label.System_CL00046)+1);
                
                iChannelMar.BU_Covered__c = strName1 + Label.System_CL00046 + strName2;
                iChannelMar.BU_Count__c = iChannelMar.BU_Covered__c.split(Label.System_CL00046).size();
                
                mapChanMarCovHeader.put(prodRows.Id,iChannelMar);             
             }
        }         
        Database.Update(mapChanMarCovHeader.values());                     
    } 
    
/*     
Method : Concatenate all the Product Groups and Update in Channel Market Coverage
@author  Indhu Selvi Ramalingam (Accenture)
*/ 
    @TestVisible 
    private void concatenatePG(ClsWrappers.TriggerContext trgCtx) { 
        
        Set<String> setCMCId = new Set<String>();   
        MAP <ID,Channel_Market_Coverage__c> mapCMCHeader = new Map <ID,Channel_Market_Coverage__c>();
        
        if (trgCtx.isInsert || trgCtx.isUpdate ) {           
            for (sobject sObj : trgCtx.newList) {                           
                // Add the Record to the List   
                Channel_Market_Coverage_Product_Lines__c compCMC = (Channel_Market_Coverage_Product_Lines__c)sObj;    
                if (compCMC.Channel_Market_Coverage__c != NULL ){
                    setCMCId.add(compCMC.Channel_Market_Coverage__c);                                                                 
                }
            } 
        }
        
      if (trigger.isDelete) { 
            for (sobject sObj : trgCtx.oldList) {
                Channel_Market_Coverage_Product_Lines__c compCMC = (Channel_Market_Coverage_Product_Lines__c)sObj;    
                if (compCMC.Channel_Market_Coverage__c != NULL ){

                     setCMCId.add(compCMC.Channel_Market_Coverage__c);                        
               }
            }
        } 
      
        for(Channel_Market_Coverage__c channelMarCov:[Select Id, PG_Covered__c FROM Channel_Market_Coverage__c WHERE Id IN : setCMCId LIMIT 50000]){
            channelMarCov.PG_Covered__c = NULL;
            mapCMCHeader.put(channelMarCov.Id,channelMarCov);
        }
        
        for(Channel_Market_Coverage_Product_Lines__c compProdQual : [Select Id, Product_Group__c, Channel_Market_Coverage__c 
                                                                     FROM Channel_Market_Coverage_Product_Lines__c 
                                                                     WHERE Channel_Market_Coverage__c IN : setCMCId AND Product_Group__c != null  LIMIT 50000]){
                 
                if(mapCMCHeader.get(compProdQual.Channel_Market_Coverage__c).PG_Covered__c == NULL)
                {
                        mapCMCHeader.get(compProdQual.Channel_Market_Coverage__c).PG_Covered__c = compProdQual.Product_Group__c;                       
                }
                else if(mapCMCHeader.get(compProdQual.Channel_Market_Coverage__c).PG_Covered__c != NULL)
                {
                    
                    //Checking duplicate PG values
                    String mapPGValues = mapCMCHeader.get(compProdQual.Channel_Market_Coverage__c).PG_Covered__c;
                    if(mapPGValues.contains(Label.System_CL00046)){
                        List<String> splitPGValues= mapPGValues.split(System.label.System_CL00046);
                        Set<String> setPGValues = new Set<String>();
                    
                        setPGValues.addall(splitPGValues);
                        
                           if(!setPGValues.contains(compProdQual.Product_Group__c)){
                                mapCMCHeader.get(compProdQual.Channel_Market_Coverage__c).PG_Covered__c += Label.System_CL00046 + compProdQual.Product_Group__c;                        
                           }
                   } else {
                        if(!mapPGValues.contains(compProdQual.Product_Group__c)){
                                mapCMCHeader.get(compProdQual.Channel_Market_Coverage__c).PG_Covered__c += Label.System_CL00046 + compProdQual.Product_Group__c;                        
                        }else{}
                     }
                }
        }
        
        for(Channel_Market_Coverage__c prodRows:mapCMCHeader.values()){
         String strName1 = null;
         String strName2 = null;
         Channel_Market_Coverage__c iChannelMar = prodRows;
         
         if(iChannelMar.PG_Covered__c != NULL && iChannelMar.PG_Covered__c.lastIndexOf(Label.System_CL00046) >= 0  ){
             strName1 = iChannelMar.PG_Covered__c.subString(0,iChannelMar.PG_Covered__c.lastIndexOf(Label.System_CL00046));
             strName2 = iChannelMar.PG_Covered__c.subString(iChannelMar.PG_Covered__c.lastIndexOf(Label.System_CL00046)+1);
          
             iChannelMar.PG_Covered__c = strName1 + Label.System_CL00046 + strName2;
             mapCMCHeader.put(prodRows.Id,iChannelMar);
              
         }
       }         
               Database.Update(mapCMCHeader.values());                     
    }               
    
}