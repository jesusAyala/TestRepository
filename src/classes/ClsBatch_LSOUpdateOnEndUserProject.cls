/**
 *  batch job to auto-populate LSO reference data info on End User Project record 
 *  from associated 
 *  Account End User
 *
 @  author Shankar Anand
 @  created 2015-110-07
 @  version 1.0
 */
 
global class ClsBatch_LSOUpdateOnEndUserProject implements Database.Batchable<sObject>, Database.stateful{
    global String query;
    global Set<Id> sucsIds = new Set<Id>();
    global Set<String> errIds = new Set<String>();
    global Set<End_User_Project__c> totalProcesd = new Set<End_User_Project__c>();
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        query = 'Select Id,Name,OwnerId,Account_End_User__c,Account_LSO_Reference_Data__c,End_User_Project_Status__c From End_User_Project__c';        
        return Database.getQueryLocator(query);
    }
    
        
    global void execute(Database.BatchableContext BC, list<Sobject> list_sobjects){ 
      Map<Id,End_User_Project__c> eupMap = new Map<Id,End_User_Project__c>();
      for(Sobject sobj : list_sobjects) {
          End_User_Project__c eup = (End_User_Project__c)sobj;
          eupMap.put(eup.Id,eup);
      }
 
      String userLSO;
      String userLSO1;
      String accLSO;
      List<End_User_Project__c> updatedEUPList = new List<End_User_Project__c>();
             
      Map<Id,Account> accountEndUserMap = new map<Id,Account>([Select Id, Name, (Select Id, name,LBU__c,LSO__c,LSO_ERP_Mapping_Value__c from LSO_Reference_Datas__r) from Account where id in (Select Account_End_User__c from End_User_Project__c where id in :eupMap.keySet())]);
      Map<Id,User> userMap = new map<Id,User>([Select Id, Name,Default_BU__c,Default_LSO__c,Default_Country_ISO_Code__c from User where Id in (Select ownerId from End_User_Project__c where id in :eupMap.keySet())]);          
      
      
     
        for(End_User_Project__c proj : eupMap.values()) { 
            End_User_Project__c eup = new End_User_Project__c(Id = proj.Id);
            Account eua = accountEndUserMap.get(proj.Account_End_User__c);
            User usr = userMap.get(proj.ownerid);
            if(usr!=null && usr.Default_BU__c!=null){
               userLSO = usr.Default_LSO__c+usr.Default_BU__c;
            }
            else{
               if(usr!=null)
               userLSO1 = usr.Default_LSO__c;
            }
                  
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
            updatedEUPList.add(eup);
        } 
      totalProcesd.addAll(updatedEUPList);          
      Database.SaveResult[] saveRes = database.update(updatedEUPList,false);
      for(Integer i=0;i<saveRes.size();i++){
          String errDet;
          if(saveRes.get(i).isSuccess()){
            sucsIds.add(saveRes.get(i).getId()); 
          }
          else{
            Database.Error err = saveRes.get(i).getErrors().get(0);
            errDet = updatedEUPList.get(i).Id+'-'+err.getMessage();
            errIds.add(errDet);
          }
       }
    }      
    
    
    global void finish(Database.BatchableContext BC){
        System.Debug('@@@@@@@@@ EUP Batch Processed List Size @@@@@@@@@  '+totalProcesd.size());
        System.Debug('$$$$$$$$$ EUP Batch Update List Size $$$$$$$$$  '+sucsIds.size());    
        System.Debug('######### EUP Batch Update Errors #########  '+errIds.size()+'--'+errIds);
    }
}