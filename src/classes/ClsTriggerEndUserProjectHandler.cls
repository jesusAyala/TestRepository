/**
 * Trigger handler class for End_User_Project__c which does following actions
 * - 1. TBD
 * - 2. insert, undelete, update TargetGroupShare.
 *
 * @author Sherlock Feng
 * @created 2015-03-24
 * @version 1.0
 * @since 29.0 (Force.com ApiVersion)
 * 2015-03-24 Sherlock Feng <sherlock.feng@itbconsult.com>
 * - Created
 */
public class ClsTriggerEndUserProjectHandler extends ClsTriggerVirtual {
    
    /**
     * @see IntHelper.beforeTrigger
    */
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
        preventCloseProjectWithOpenOpp(trgCtx);
         
        //Req 2168 - Local reference data auto population on End User Project
        setLSORefDatafromAccount(trgCtx);
  }  
  /**
   * @see IntHelper.afterTrigger
  */
  public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
      endUserProjectSharingCreation(trgCtx);
  }
   /*  Description of the purpose of the method. 
    *  @name endUserProjectSharingCreation
    *  @Description - Create Capture Team permission while create End user project.
    *  @return Nothing - 
    */
  @TestVisible 
    private void endUserProjectSharingCreation(ClsWrappers.TriggerContext trgCtx) {
        if(Trigger.isInsert && Trigger.isAfter){
            ID captureTeamId;
            ID ctLeader = null;
            List<End_User_Project__Share> lstshare = new List<End_User_Project__Share>();
            Set<String> setEmail = new Set<String>();
            Map<String,Id> mapUserEmail = new Map<String,Id>();
            for (sobject so : trgCtx.newList) {
                End_User_Project__c endUserP = (End_User_Project__c)so;
                setEmail.add(endUserP.Account_Manager__c);
            }
            for(User objuser : [Select id,Email from User where Email IN:setEmail and isActive = true LIMIT 50000]){
                mapUserEmail.put(objuser.Email,objuser.id);
            }
            for (sobject so : trgCtx.newList) {
                End_User_Project__c endUserP = (End_User_Project__c)so;
                Map<String, Schema.SObjectType> tokens = Schema.getGlobalDescribe();
                if(!tokens.containsKey(System.label.System_CL00038)){   //System_CL00038 => End_User_Project__Share
                    endUserP.adderror(System.label.CL00039); //CL00039 => End User Project is not enabled as private.
                }
                if(tokens.containsKey(System.label.System_CL00038) && mapUserEmail.containsKey(endUserP.Account_Manager__c) && UserInfo.getUserId() <> mapUserEmail.get(endUserP.Account_Manager__c)) {  
                    End_User_Project__Share objEUPS = new End_User_Project__Share();
                    objEUPS.ParentId = endUserP.Id; //System_CL00023 => ParentId  
                    objEUPS.UserOrGroupId = mapUserEmail.get(endUserP.Account_Manager__c);//System_CL00024 => UserOrGroupId
                    objEUPS.AccessLevel = System.label.System_CL00026;//System_CL00025 => AccessLevel , System_CL00026 => 'Edit'
                    objEUPS.RowCause = System.label.System_CL00028;//System_CL00027 => RowCause , System_CL00028 => 'Manual'
                    lstshare.add(objEUPS);
                } 
            }
            if(lstshare.size()>0){
                Database.insert(lstshare);
            }  
        }
    }   
  /**
   *  This trigger is used to update Case Inquiry Number.
   *
   @author  Sherlock Feng
   @created 2015-03-19
   @version 1.0
   @since   30.0 (Force.com ApiVersion)
   *
   @changelog
   * 2015-03-19 Sherlock Feng <sherlock.feng@itbconsult.com>
   * - Created
  */
  @TestVisible
  private void preventCloseProjectWithOpenOpp(ClsWrappers.TriggerContext trgCtx) {
    
    // Check trigger event
    if (trgCtx.isAfter) return;
    
    if (trgCtx.isUpdate) {
      set<Id> set_eupId = new set<Id>();
      for (SObject sobj : trgCtx.newList) {
        End_User_Project__c eup = (End_User_Project__c)sobj;
        if(trgCtx.oldMap.get(eup.Id).get(System.label.System_CL00040) != eup.End_User_Project_Status__c) {  //System_CL00040 => End_User_Project_Status__c
          if(eup.End_User_Project_Status__c == System.label.System_CL00041 || eup.End_User_Project_Status__c == System.label.System_CL00042) {  //System_CL00041 => Closed, System_CL00042 => Cancelled
            set_eupId.add(eup.Id);
          }
        }
      }
      Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
      for(Opportunity opp : [SELECT End_User_Project__c, IsClosed FROM Opportunity where End_User_Project__c IN :set_eupId LIMIT :remLimit]){
        if(opp.IsClosed==false){
          trgCtx.newMap.get(opp.End_User_Project__c).addError(System.label.CL00043); //CL00043=>An End User Project can only set to Closed / Cancelled if all related opportunities are Closed.
        }
        
    }

    }
}
    
 /*  Description of the purpose of the method. 
    *  @name setLSORefDatafromAccount
    *  @Description - Req -2168. Auto populates the Local Reference Data from associated Accounts while creating or updating an End User Project.
    *  @return - void
    *  @created by - Shankar Anand
    */
    private void setLSORefDatafromAccount(ClsWrappers.TriggerContext trgCtx) {
    
      Set<Id> accountEndUserIds = new Set<Id>();
      Set<Id> eupOwnerIds = new Set<Id>(); 
      Set<id> opptyIds = new Set<id>(); 
      String userLSO;
      String userLSO1;
      String accLSO;
      Map<Id,End_User_Project__c> oldEUPMap = new map<Id,End_User_Project__c>();
      Map<Id,Account> accountEndUserMap = new map<Id,Account>();
      Map<Id,User> userMap = new map<Id,User>();
      
     
      if(trgCtx!=null && trgCtx.isBefore && (trgCtx.isInsert || trgCtx.isUpdate)){
        for(sobject so : trgCtx.newList) {
                End_User_Project__c eup = (End_User_Project__c)so;
                accountEndUserIds.add(eup.Account_End_User__c);
                eupOwnerIds.add(eup.ownerId);
            }
            
      Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
      accountEndUserMap = new map<Id,Account>([Select Id, Name, (Select Id, name,LBU__c,LSO__c,LSO_ERP_Mapping_Value__c from LSO_Reference_Datas__r) from Account where id in:accountEndUserIds LIMIT :remLimit]);
      userMap = new map<Id,User>([Select Id, Name,Default_BU__c,Default_LSO__c,Default_Country_ISO_Code__c from User where Id in:eupOwnerIds LIMIT :remLimit]);          
      }
                  
            if(trgCtx!=null && trgCtx.isBefore && trgCtx.isInsert){ 
               for(sobject so : trgCtx.newList) {
                End_User_Project__c eup = (End_User_Project__c)so;                 
                Account eua = accountEndUserMap.get(eup.Account_End_User__c);
                User usr = userMap.get(eup.ownerid);
                   if(usr!=null && usr.Default_BU__c!=null){
                      userLSO = usr.Default_LSO__c+usr.Default_BU__c;
                     }
                   else{
                    if(usr!=null)
                      userLSO1 = usr.Default_LSO__c;
                     }
              
                 if(eua!=null){
                  for(ERP_Reference_Data__c lrd:eua.LSO_Reference_Datas__r){
                    accLSO = String.valueof(lrd.LSO__c)+String.valueof(lrd.LBU__c);
                    if(usr!=null && usr.Default_BU__c!=null &&  lrd.LBU__c!= null && userLSO!=null && accLSO!=null && userLSO.equalsIgnorecase(accLSO)){
                        eup.Account_LSO_Reference_Data__c = lrd.id;
                    }
                    else if(usr!=null && usr.Default_BU__c ==null &&  lrd.LBU__c == null && userLSO1!=null && userLSO1.equalsIgnorecase(String.valueof(lrd.LSO__c))){    
                        eup.Account_LSO_Reference_Data__c = lrd.id;
                    }
                  }
                }
               }
            }
            
            
            
            
            if(trgCtx!=null && trgCtx.isBefore && trgCtx.isUpdate){ 
    
                for(sobject so : trgCtx.oldList){
                    End_User_Project__c eup = (End_User_Project__c)so;
                    oldEUPMap.put(eup.id,eup);       
                } 
       

                for(sobject so : trgCtx.newList) {
                    End_User_Project__c eup = (End_User_Project__c)so;
                    Account eua = accountEndUserMap.get(eup.Account_End_User__c);
                    User usr = userMap.get(eup.ownerid);
                    if(usr!=null && usr.Default_BU__c!=null){
                        userLSO = usr.Default_LSO__c+usr.Default_BU__c;
                    }
                    else{
                     if(usr!=null)
                        userLSO1 = usr.Default_LSO__c;
                    }
                
             
                if(((End_User_Project__c)trgCtx.oldMap.get(eup.id)).Account_End_User__c != eup.Account_End_User__c || ((End_User_Project__c)trgCtx.oldMap.get(eup.id)).ownerId != eup.ownerId){ 
                if(eua!=null){
                    List<ERP_Reference_Data__c> aeuLsoRefList = new List<ERP_Reference_Data__c>();
                    aeuLsoRefList.addall(eua.LSO_Reference_Datas__r);
           
                    if(aeuLsoRefList.size()>0){
                        for(ERP_Reference_Data__c lrd:eua.LSO_Reference_Datas__r){
                            accLSO = String.valueof(lrd.LSO__c)+String.valueof(lrd.LBU__c);
                            if(usr!=null && usr.Default_BU__c!=null &&  lrd.LBU__c!= null && userLSO!=null && accLSO!=null && userLSO.equalsIgnorecase(accLSO)){
                                eup.Account_LSO_Reference_Data__c = lrd.id;
                                break;
                            }
                            else if(usr!=null && usr.Default_BU__c==null &&  lrd.LBU__c == null && userLSO1!=null && userLSO1.equalsIgnorecase(String.valueof(lrd.LSO__c))){
                                eup.Account_LSO_Reference_Data__c = lrd.id;
                                break;
                            }
                            else{
                                eup.Account_LSO_Reference_Data__c  = null;
                            }
                        }
                    }
                    else{
                        eup.Account_LSO_Reference_Data__c  = null;
                    }
                }
                }    
                }         
            }
            
           
}         
     
    
}