/**
    @Author Rajesh K
    @name ClsTriggerAccountHandler
    @CreateDate 9/14/2015
    @Description Providing sharing permission to End user project and Capture Team objects.
    @Version 1.0
    **/
public without sharing class ClsTriggerAccountHandler extends ClsTriggerVirtual {
    
    
    public Static Set<Id> processedIdSet = new Set<Id>();
    
    /**
     * @see IntHelper.beforeTrigger
    */
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {        
      if (trgCtx.IsInsert){
          updateKeyAccManager(trgCtx);
      }
    } 
    
   
    /**
     * @see IntHelper.afterTrigger
    */
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) { 
        endUserProjectSharingUpdation(trgCtx);        
    }
    
    /*  Description of the purpose of the method. 
    *  @name EndUserProjectSharingUpdation
    *  @Description - Providing End User Project object sharing.
    *  @return Nothing - 
    */
    @TestVisible 
    private void endUserProjectSharingUpdation(ClsWrappers.TriggerContext trgCtx) {
        if (trgCtx.isUpdate && trgCtx.isAfter) {
            Set<String> accManagers = new Set<String>();
            Set<ID> accids = new Set<ID>();            
            Map<ID,List<End_User_Project__c>> mapEndUserProject = new Map<ID,List<End_User_Project__c>>();
            Map<ID,List<Capture_Team__c>> mapCaptureTeam = new Map<ID,List<Capture_Team__c>>();
            Map<ID,List<ID>> mapCaptureTeamMemb = new Map<ID,List<ID>>();
            Map<String,ID> mapUsers = new Map<String,ID>();
            for (sobject so : trgCtx.newList){
                Account acc = (Account)so;
                if(((Account)trgCtx.oldMap.get(acc.Id)).Primary_Account_Manager__c != acc.Primary_Account_Manager__c){                 
                    accids.add(acc.id);
                    accManagers.add(acc.Primary_Account_Manager__c);
                    accManagers.add(((Account)trgCtx.oldMap.get(acc.Id)).Primary_Account_Manager__c);
                }
            }
            if(accids.size()>0){
                Set<ID> endUserids = new Set<ID>();
                Set<ID> capTeamids = new Set<ID>();
                List<End_User_Project__Share> lstRemoveEndUser = new List<End_User_Project__Share>();
                List<End_User_Project__Share> lstInsertEndUser = new List<End_User_Project__Share>();
                List<Capture_Team__Share> lstRemoveCapTeam = new List<Capture_Team__Share>();
                List<Capture_Team__Share> lstInsertCapTeam = new List<Capture_Team__Share>();
                Map<End_User_Project__c,ID> mapEndUserProj = new Map<End_User_Project__c,ID>();
                List<End_User_Project__c> lstEndUserProj = new List<End_User_Project__c>();
                for(User objuser: [Select id,Email from User where Email IN:accManagers and isActive = true LIMIT 50000]){
                    mapUsers.put(objuser.Email,objuser.Id);
                }
                for(End_User_Project__c objEUP : [Select id,Account_Manager__c,Account_End_User__c,Ownerid from 
                End_User_Project__c where Account_End_User__c IN:accids LIMIT 50000]){
                    endUserids.add(objEUP.id);
                    if(mapEndUserProject.containskey(objEUP.Account_End_User__c)){
                        List<End_User_Project__c> lstEndUser = mapEndUserProject.get(objEUP.Account_End_User__c);
                        lstEndUser.add(objEUP);
                        mapEndUserProject.put(objEUP.Account_End_User__c,lstEndUser);
                    }else{
                        mapEndUserProject.put(objEUP.Account_End_User__c,new List<End_User_Project__c>{objEUP});
                    } 
                }
                for(Capture_Team__c objCT :[Select id,End_User_Project__c,Ownerid from Capture_Team__c where End_User_Project__c IN:endUserids LIMIT 50000]){
                    capTeamids.add(objCT.id);
                    if(mapCaptureTeam.containskey(objCT.End_User_Project__c)){
                        List<Capture_Team__c> lstcapTeam = mapCaptureTeam.get(objCT.End_User_Project__c);
                        lstcapTeam.add(objCT);
                        mapCaptureTeam.put(objCT.End_User_Project__c,lstcapTeam);
                    }else{
                        mapCaptureTeam.put(objCT.End_User_Project__c,new List<Capture_Team__c>{objCT});
                    }
                }  
                for(Capture_Team_Member__c objCTM :[Select id,User__c,Capture_Team__c from Capture_Team_Member__c where Capture_Team__c IN:capTeamids LIMIT 50000]){                    
                    if(mapCaptureTeamMemb.containskey(objCTM.Capture_Team__c)){
                        List<ID> lstcapTeammem = mapCaptureTeamMemb.get(objCTM.Capture_Team__c);
                        lstcapTeammem.add(objCTM.User__c);
                        mapCaptureTeamMemb.put(objCTM.Capture_Team__c,lstcapTeammem);
                    }else{
                        mapCaptureTeamMemb.put(objCTM.Capture_Team__c,new List<ID>{objCTM.User__c});
                    }
                }               
                List<End_User_Project__Share> sharesEndUser = [SELECT Id,UserOrGroupId,ParentId,Accesslevel,RowCause FROM End_User_Project__Share WHERE ParentId IN :endUserids AND (RowCause =: System.label.System_CL00028 OR RowCause =: System.label.System_CL00030) LIMIT 50000];    
                List<Capture_Team__Share> sharesCaptureTeam = [SELECT Id,UserOrGroupId,ParentId,Accesslevel,RowCause FROM Capture_Team__Share WHERE ParentId IN :capTeamids AND (RowCause =: System.label.System_CL00028 OR RowCause =: System.label.System_CL00030) LIMIT 50000];    
                Map<String, Schema.SObjectType> tokens = Schema.getGlobalDescribe();
                for(ID accid : mapEndUserProject.keyset()){
                    for(End_User_Project__c objEndUser : mapEndUserProject.get(accid)){
                        mapEndUserProj.put(objEndUser,objEndUser.Account_End_User__c);
                        Boolean check = false;
                        if(mapUsers.containsKey(((Account)trgCtx.oldMap.get(accid)).Primary_Account_Manager__c)){
                            for(End_User_Project__Share objEUShare : sharesEndUser){                            
                                if(mapUsers.get(((Account)trgCtx.oldMap.get(accid)).Primary_Account_Manager__c) == objEUShare.UserOrGroupId && objEndUser.id == objEUShare.ParentId && objEUShare.RowCause.equals(System.label.System_CL00028)){
                                    lstRemoveEndUser.add(objEUShare);
                                }
                                if(mapUsers.get(objEndUser.Account_Manager__c) == objEUShare.UserOrGroupId && objEndUser.id == objEUShare.ParentId){
                                    check = true;
                                }
                            }
                        }   
                        if(tokens.containsKey(System.label.System_CL00022) && mapUsers.containsKey(objEndUser.Account_Manager__c) && objEndUser.Ownerid != mapUsers.get(objEndUser.Account_Manager__c) && check == false){  //System_CL00022 =>  'End_User_Project__Share'                           
                            End_User_Project__Share objEUPS = new End_User_Project__Share();
                            objEUPS.ParentId = objEndUser.id; //System_CL00023 => ParentId  
                            objEUPS.UserOrGroupId = mapUsers.get(objEndUser.Account_Manager__c);//System_CL00024 => UserOrGroupId
                            objEUPS.AccessLevel = System.label.System_CL00026;//System_CL00025 => AccessLevel , System_CL00026 => 'Edit'
                            objEUPS.RowCause = System.label.System_CL00028;//System_CL00027 => RowCause , System_CL00028 => 'Manual'                           
                            lstInsertEndUser.add(objEUPS);
                        }                       
                    }
                }
                for(End_User_Project__c objEUP : mapEndUserProj.keyset()){
                    if(mapCaptureTeam.containsKey(objEUP.id)){
                        for(Capture_Team__c objCT : mapCaptureTeam.get(objEUP.id)){
                            Boolean check = false;
                            Set<ID> setCT = new Set<ID>();
                            if(mapCaptureTeamMemb.containsKey(objCT.id)){
                                setCT.addall(mapCaptureTeamMemb.get(objCT.id));
                            }
                            if(mapUsers.containskey(((Account)trgCtx.oldMap.get(mapEndUserProj.get(objEUP))).Primary_Account_Manager__c)){
                                for(Capture_Team__Share objCTShare : sharesCaptureTeam){                            
                                    if(mapUsers.get(((Account)trgCtx.oldMap.get(mapEndUserProj.get(objEUP))).Primary_Account_Manager__c) == objCTShare.UserOrGroupId && objCT.id == objCTShare.ParentId && 
                                    objCTShare.RowCause == System.label.System_CL00028 && !setCT.contains(objCTShare.UserOrGroupId)){
                                        lstRemoveCapTeam.add(objCTShare);                                           
                                    }
                                    if(mapUsers.get(objEUP.Account_Manager__c) == objCTShare.UserOrGroupId && objCT.id == objCTShare.ParentId){
                                        check = true;                                       
                                    }
                                }
                            }                           
                            if(tokens.containsKey(System.label.System_CL00029) && mapUsers.containsKey(objEUP.Account_Manager__c) && objCT.Ownerid != mapUsers.get(objEUP.Account_Manager__c) && check == false) {
                                Capture_Team__Share objCTS = new Capture_Team__Share();
                                objCTS.ParentId = objCT.id;
                                objCTS.UserOrGroupId = mapUsers.get(objEUP.Account_Manager__c);
                                objCTS.AccessLevel = System.label.System_CL00026;
                                objCTS.RowCause = System.label.System_CL00028;                       
                                lstInsertCapTeam.add(objCTS);
                            }       
                        }   
                    }                   
                }
                if(lstRemoveEndUser.size()>0){
                    Database.Delete(lstRemoveEndUser);
                }
                if(lstInsertEndUser.size()>0){
                    Database.Insert(lstInsertEndUser);
                }
                if(lstRemoveCapTeam.size()>0){
                    Database.Delete(lstRemoveCapTeam);
                }
                if(lstInsertCapTeam.size()>0){
                    Database.Insert(lstInsertCapTeam);
                }
            }            
        }   
    }
/**
 @name  updateKeyAccManager
 Update the key accoutn manager
*/
    @TestVisible
    private void updateKeyAccManager(ClsWrappers.TriggerContext trgCtx) {
    
       // system.debug(':::beforeTrigger:::');
    
        if(trgCtx.isInsert || trgCtx.isUpdate) {
            Set<ID> setAccountId = new Set<ID>();
            Set<string> setEmailId = new Set<string>();
            Map<String,Id> mapUserEmail = new Map<String,Id>();
            List<Account> acc1 = new List<Account>();
            
          // system.debug('::::trgCtx.newList'+trgCtx.newList);
            
            for(sobject so : trgCtx.newList) {
                
             //   system.debug('::::inside for'+so);
                Account acc = (Account)so;
                Account oldAcc = (trgCtx.isUpdate) ? (Account) trgCtx.oldmap.get(acc.Id) : null;

                if(trgCtx.isInsert || (trgCtx.isUpdate &&  acc.Primary_Account_Manager__c != oldAcc.Primary_Account_Manager__c)) {
                    setAccountId.add(acc.Id);
                    setEmailId.add(acc.Primary_Account_Manager__c);
                    acc1.add((Account)so);
                  //  system.debug(':::setEmailId:::'+setEmailId);
                }
            }
            Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
            if(setEmailId.size() > 0) {
               
                for(User usr : [SELECT Id, Name, Email, isActive FROM User WHERE Email IN :setEmailId LIMIT :remLimit]) {
                    if(usr.isActive){
                        mapUserEmail.put(usr.Email,usr.Id);
                    }                    
                 // system.debug(':::mapUserEmail:::'+mapUserEmail);
                }
                
                
                for(Account accList : acc1) {
                    if(accList.Primary_Account_Manager__c == NULL || (!mapUserEmail.containsKey(accList.Primary_Account_Manager__c))) {
                        accList.Key_Account_Manager__c = NULL;
                        
                   // system.debug(':::accList.Key_Account_Manager__c:::'+accList.Key_Account_Manager__c);
                    }
                    else
                    {
                        if(mapUserEmail.containsKey(accList.Primary_Account_Manager__c)) {
                            accList.Key_Account_Manager__c = mapUserEmail.get(accList.Primary_Account_Manager__c);
                            
                       // system.debug(':::accList.Key_Account_Manager__c:::'+accList.Key_Account_Manager__c);
                        }                    
                    }
                }  
                            
            }
            
        }

    }
 
    
}