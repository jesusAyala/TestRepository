/**
    @Author Rajesh K
    @name ClsTriggerCaptureTeamHandler
    @CreateDate 9/21/2015
    @Description To display Capture team count in End user project object
    @Version 1.0
    **/
public with sharing class ClsTriggerCaptureTeamHandler extends ClsTriggerVirtual {
        Set<Id> setEUPId = new Set<Id>();
        Set<Id> setEndUserProjId = new Set<Id>();
        List<Capture_Team__c> lstCT = new List<Capture_Team__c>();
        List<End_User_Project__c > lstEUP = new List<End_User_Project__c >();
        List<End_User_Project__c > lstUpdateEUP = new List<End_User_Project__c >();
        Map<Id,List<Opportunity>> mapEUPIdAndOpportunity = new Map<Id,List<Opportunity>>();
        Map<Id,List<Capture_Team__c>> mapEUPIdAndCapturTeam = new Map<Id,List<Capture_Team__c>>();
    /**
     * @see IntHelper.afterTrigger
    */
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
        captureTeamCreation(trgCtx);
        captureTeamDeletion(trgCtx);
        captureTeamSharingCreation(trgCtx);
    } 
    /*  Description of the purpose of the method. 
    *  @name captureTeamSharingCreation
    *  @Description - Provide the Capture Team sharing for account manager or End user project owner .
    *  @return Nothing - 
    */
    private void captureTeamSharingCreation(ClsWrappers.TriggerContext trgCtx) {
        if(Trigger.isInsert && Trigger.isAfter){            
            List<Capture_Team__Share> lstshare = new List<Capture_Team__Share>();
            Set<String> setEmail = new Set<String>();
            Set<ID> capTeamids = new Set<ID>();
            Map<String,Id> mapUserEmail = new Map<String,Id>();
            for (sobject so : trgCtx.newList) {
                Capture_Team__c ct = (Capture_Team__c)so;
                setEmail.add(ct.EndUserProject_Manager__c);
                capTeamids.add(ct.id);
            }
            for(User objuser : [Select id,Email from User where Email IN:setEmail and isActive = true LIMIT 50000]){
                mapUserEmail.put(objuser.Email,objuser.id);
            }
            List<Capture_Team__Share> sharesCaptureTeam = [SELECT Id,UserOrGroupId,ParentId,Accesslevel,RowCause FROM Capture_Team__Share WHERE ParentId IN :capTeamids AND (RowCause =: System.label.System_CL00028 OR RowCause =: System.label.System_CL00030) LIMIT 50000];    
                        
            
            for (sobject so : trgCtx.newList) {
                Capture_Team__c capteam = (Capture_Team__c)so;
                Map<String, Schema.SObjectType> tokens = Schema.getGlobalDescribe();
                if(!tokens.containsKey(System.label.System_CL00029)){   //System_CL00029 => Capture_Team__Share
                    capteam.adderror(System.label.CL00039); //CL00039 => End User Project is not enabled as private.
                }
                Boolean checkManager = false;
                Boolean checkOwner = false;
                for(Capture_Team__Share objCTShare : sharesCaptureTeam){                            
                    if(mapUserEmail.containsKey(capteam.EndUserProject_Manager__c) && mapUserEmail.get(capteam.EndUserProject_Manager__c) == objCTShare.UserOrGroupId && capteam.id == objCTShare.ParentId){
                        checkManager = true;                                       
                    }
                    if(capteam.EndUserProject_Owner__c == objCTShare.UserOrGroupId && capteam.id == objCTShare.ParentId){
                        checkOwner = true;                                       
                    }
                }               
                if(tokens.containsKey(System.label.System_CL00038) && mapUserEmail.containsKey(capteam.EndUserProject_Manager__c) && checkManager == false) {  
                    Capture_Team__Share objCTS = new Capture_Team__Share();
                    objCTS.ParentId = capteam.Id; //System_CL00023 => ParentId  
                    objCTS.UserOrGroupId = mapUserEmail.get(capteam.EndUserProject_Manager__c);//System_CL00024 => UserOrGroupId
                    objCTS.AccessLevel = System.label.System_CL00026;//System_CL00025 => AccessLevel , System_CL00026 => 'Edit'
                    objCTS.RowCause = System.label.System_CL00028;//System_CL00027 => RowCause , System_CL00028 => 'Manual'
                    lstshare.add(objCTS);
                } 
                if(tokens.containsKey(System.label.System_CL00038) && checkOwner == false) {  
                    Capture_Team__Share objCTS = new Capture_Team__Share();
                    objCTS.ParentId = capteam.Id; //System_CL00023 => ParentId  
                    objCTS.UserOrGroupId = capteam.EndUserProject_Owner__c;//System_CL00024 => UserOrGroupId
                    objCTS.AccessLevel = System.label.System_CL00026;//System_CL00025 => AccessLevel , System_CL00026 => 'Edit'
                    objCTS.RowCause = System.label.System_CL00028;//System_CL00027 => RowCause , System_CL00028 => 'Manual'
                    lstshare.add(objCTS);
                }
            }
            if(lstshare.size()>0){
                Database.insert(lstshare);
            }  
        }
    }
   
    /*  Description of the purpose of the method. 
    *  @name captureTeamCreation
    *  @Description - Provide the Capture Team Count while create a new capture team .
    *  @return Nothing - 
    */
    @TestVisible 
    private void captureTeamCreation(ClsWrappers.TriggerContext trgCtx) {
        if(Trigger.isInsert && Trigger.isAfter){
             for(sobject objCapTeam : trgCtx.newList){
             Capture_Team__c ct = (Capture_Team__c)objCapTeam ;
             setEUPId.add(ct.End_User_Project__c);
            }
            if(setEUPId !=NUll){
                lstEUP = [SELECT Id FROM End_User_Project__c WHERE Id in: setEUPId LIMIT 10000];
                //lstCT = [SELECT Id,End_User_Project__c FROM Capture_Team__c WHERE End_User_Project__c in: setEUPId LIMIT 10000];
                for(Opportunity op : [SELECT Id,Capture_Team_Indicator_Status__c,End_User_Project__c,Target__c,Technical_Amount_USD__c FROM Opportunity  where End_User_Project__c in: setEUPId LIMIT 10000] )
                {
                    List<Opportunity> lstop = new List<Opportunity>();
                    lstop.add(op);                
                    if (mapEUPIdAndOpportunity.containsKey(op.End_User_Project__c))
                    {                    
                        mapEUPIdAndOpportunity.get(op.End_User_Project__c).add(op);
                    }
                    else
                    {
                        mapEUPIdAndOpportunity.put(op.End_User_Project__c, lstop);
                    }
                }
                
                for(Capture_Team__c cpt : [SELECT Id,End_User_Project__c FROM Capture_Team__c WHERE End_User_Project__c in: setEUPId LIMIT 10000] )
                {
                    List<Capture_Team__c> lstcpt = new List<Capture_Team__c>();
                    lstcpt.add(cpt);                
                    if (mapEUPIdAndCapturTeam.containsKey(cpt.End_User_Project__c))
                    {                    
                        mapEUPIdAndCapturTeam.get(cpt.End_User_Project__c).add(cpt);
                    }
                    else
                    {
                        mapEUPIdAndCapturTeam.put(cpt.End_User_Project__c, lstcpt);
                    }
                }
                   
            }
            if(lstEUP.size() > 0){
                     for(String endusrid : setEUPId){
                        End_User_Project__c  EUPupddate= new End_User_Project__c();
                        EUPupddate.Id=endusrid;
                        List<Capture_Team__c> lstcp = mapEUPIdAndCapturTeam.get(endusrid);
                        integer cp_count;
                        if(lstcp!=null && lstcp.size()>0)
                        { cp_count = lstcp.size(); }
                        else{ cp_count = 0;}
                        EUPupddate.Capture_Team_Count__c= cp_count;
                        String EndUsrStatus = ''; 
                        Boolean isFullRequired = False;
                        Boolean isFullAvailable = False;
                        Boolean isLiteRequired = False;
                        Boolean isLiteAvailable = False;
                        Boolean isNotRequired = False;        
                        List<Opportunity> lstopty = mapEUPIdAndOpportunity.get(endusrid);
                        if(lstopty !=null)
                        for(Opportunity opp : lstopty){
                          if(opp.Technical_Amount_USD__c <= 5000000 || opp.Target__c == FALSE)
                          { isNotRequired = True;}
                          if(opp.Technical_Amount_USD__c > 15000000 && opp.Target__c == TRUE && cp_count > 0)
                          { isFullAvailable = True;}
                          if(opp.Technical_Amount_USD__c > 15000000 && opp.Target__c == TRUE && cp_count == 0)
                          { isFullRequired = True;}
                          if(opp.Technical_Amount_USD__c <= 15000000 && opp.Target__c == TRUE && cp_count > 0 && opp.Technical_Amount_USD__c > 5000000)
                          { isLiteAvailable = True;}
                          if(opp.Technical_Amount_USD__c <= 15000000 && opp.Target__c == TRUE && cp_count == 0 && opp.Technical_Amount_USD__c > 5000000)
                          { isLiteRequired = True;}
                        }
                
                        if(isFullAvailable){
                            EndUsrStatus = 'CT Full Available';
                        }
                        else if (isFullRequired){
                            EndUsrStatus = 'CT Full Required';
                        }
                        else if (isLiteAvailable){
                            EndUsrStatus = 'CT Lite Available';
                        }
                        else if (isLiteRequired){
                            EndUsrStatus = 'CT Lite Required';
                        }
                        else if(isNotRequired){
                            EndUsrStatus = 'No CT Required';
                        }
                        else{
                            EndUsrStatus = 'No CT Required';
                        }
                                          
                        EUPupddate.Capture_Team_Status__c= EndUsrStatus;
                        lstUpdateEUP.add(EUPupddate);
                    }
            }
            if(lstUpdateEUP.size() >0){
                try {
                    Database.SaveResult[] results =  database.update(lstUpdateEUP);
                    if (results != null){
                        for (Database.SaveResult result : results) {
                            if (!result.isSuccess()) {
                                Database.Error[] errs = result.getErrors();
                                for(Database.Error err : errs)
                                    System.debug(err.getStatusCode() + ' - ' + err.getMessage());
                
                            }
                        }
                    }

                } catch (Exception e) {
                        System.debug(e.getTypeName() + ' - ' + e.getCause() + ': ' + e.getMessage());
                } 
            }
        }
    }
      
      
/*  Description of the purpose of the method. 
    *  @name captureTeamDeletion
    *  @Description - Provide the Capture Team Count while deleting capture team .
    *  @return Nothing - 
    */
    @TestVisible 
    private void captureTeamDeletion(ClsWrappers.TriggerContext trgCtx) {
        if(Trigger.isDelete && Trigger.isAfter){  
            for(sobject objCapTeam : trgCtx.oldList){
                Capture_Team__c ct = (Capture_Team__c)objCapTeam ;
                setEUPId.add(ct.End_User_Project__c);
            }
            if(setEUPId !=NUll){
                lstEUP = [SELECT Id FROM End_User_Project__c WHERE Id in: setEUPId LIMIT 10000];
                //lstCT = [SELECT Id,End_User_Project__c FROM Capture_Team__c WHERE End_User_Project__c in: setEUPId LIMIT 10000];
                System.debug('------------lstCT'+lstCT.size()+'---------------lstEUP '+lstEUP.size() );
                for(Opportunity op : [SELECT Id,Capture_Team_Indicator_Status__c,End_User_Project__c,Target__c,Technical_Amount_USD__c FROM Opportunity  where End_User_Project__c in: setEUPId LIMIT 10000] )
                {
                    List<Opportunity> lstop = new List<Opportunity>();
                    lstop.add(op);
                    
                    if (mapEUPIdAndOpportunity.containsKey(op.End_User_Project__c))
                    {                    
                        mapEUPIdAndOpportunity.get(op.End_User_Project__c).add(op);
                    }
                    else
                    {
                        mapEUPIdAndOpportunity.put(op.End_User_Project__c, lstop);
                    }
                
                }
                
                for(Capture_Team__c cpt : [SELECT Id,End_User_Project__c FROM Capture_Team__c WHERE End_User_Project__c in: setEUPId LIMIT 10000] )
                {
                    List<Capture_Team__c> lstcpt = new List<Capture_Team__c>();
                    lstcpt.add(cpt);                
                    if (mapEUPIdAndCapturTeam.containsKey(cpt.End_User_Project__c))
                    {                    
                        mapEUPIdAndCapturTeam.get(cpt.End_User_Project__c).add(cpt);
                    }
                    else
                    {
                        mapEUPIdAndCapturTeam.put(cpt.End_User_Project__c, lstcpt);
                    }
                }
                
            }
            
            if(lstEUP.size() > 0){
                for(String endusrid : setEUPId){
                    List<Capture_Team__c> lstcp = mapEUPIdAndCapturTeam.get(endusrid);
                    End_User_Project__c  EUPupddate= new End_User_Project__c();
                    EUPupddate.Id=endusrid;
                    
                    integer cp_count;
                    if(lstcp!=null && lstcp.size()>0){ 
                        cp_count = lstcp.size(); 
                    }
                    else{ 
                        cp_count = 0;
                    }
                    EUPupddate.Capture_Team_Count__c=cp_count;
                    
                    String EndUsrStatus = ''; 
                    Boolean isFullRequired = False;
                    Boolean isFullAvailable = False;
                    Boolean isLiteRequired = False;
                    Boolean isLiteAvailable = False;
                    Boolean isNotRequired = False;        
                    List<Opportunity> lstopty = mapEUPIdAndOpportunity.get(endusrid);
                if(lstopty !=null)
                for(Opportunity opp : lstopty)
                {
                      System.debug('&&&&&&&&&&&&&&'+opp.Capture_Team_Indicator_Status__c);
                      if(opp.Technical_Amount_USD__c <= 5000000 || opp.Target__c == FALSE)
                      { isNotRequired = True;}
                      if(opp.Technical_Amount_USD__c > 15000000 && opp.Target__c == TRUE && cp_count  > 0)
                      { isFullAvailable = True;}
                      if(opp.Technical_Amount_USD__c > 15000000 && opp.Target__c == TRUE && cp_count  == 0)
                      { isFullRequired = True;}
                      if(opp.Technical_Amount_USD__c <= 15000000 && opp.Target__c == TRUE && cp_count  > 0 && opp.Technical_Amount_USD__c > 5000000)
                      { isLiteAvailable = True;}
                      if(opp.Technical_Amount_USD__c <= 15000000 && opp.Target__c == TRUE && cp_count  == 0 && opp.Technical_Amount_USD__c > 5000000)
                      { isLiteRequired = True;}
                }
                
                if(isFullAvailable){
                    EndUsrStatus = 'CT Full Available';
                }
                else if (isFullRequired){
                    EndUsrStatus = 'CT Full Required';
                }
                else if (isLiteAvailable){
                    EndUsrStatus = 'CT Lite Available';
                }
                else if (isLiteRequired){
                    EndUsrStatus = 'CT Lite Required';
                }
                else if(isNotRequired){
                    EndUsrStatus = 'No CT Required';
                }
                else{
                    EndUsrStatus = 'No CT Required';
                }
                    
                    EUPupddate.Capture_Team_Status__c=EndUsrStatus;
                    lstUpdateEUP.add(EUPupddate);
                    }
                 } 
            if(lstUpdateEUP.size() >0){
                try {
                    Database.SaveResult[] results =  database.update(lstUpdateEUP);
                    if (results != null){
                        for (Database.SaveResult result : results) {
                            if (!result.isSuccess()) {
                                Database.Error[] errs = result.getErrors();
                                for(Database.Error err : errs)
                                    System.debug(err.getStatusCode() + ' - ' + err.getMessage());
                
                            }
                        }
                    }

                } catch (Exception e) {
                        System.debug(e.getTypeName() + ' - ' + e.getCause() + ': ' + e.getMessage());
                }
               
            }
            
        }
    }
}