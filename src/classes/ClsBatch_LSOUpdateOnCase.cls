/**
 *  batch job to auto-populate LSO reference data info on Case record 
 *  from associated 
 *  Account
 *
 @  author Shankar Anand
 @  created 2015-10-07
 @  version 1.0
 */
 
global class ClsBatch_LSOUpdateOnCase implements Database.Batchable<sObject>, Database.stateful{
    global String query;
    global Set<Id> sucsIds = new Set<Id>();
    global Set<String> errIds = new Set<String>();
     global Set<Case> totalProcesd = new Set<Case>();
     
    global Database.QueryLocator start(Database.BatchableContext BC) {
        query = 'Select Id,CaseNumber,OwnerId,AccountId,Account_LSO_Case__c From Case';
           
        return Database.getQueryLocator(query);
    }
    
        
    global void execute(Database.BatchableContext BC, list<Sobject> list_sobjects){ 
      Map<Id,Case> caseMap = new Map<Id,Case>();
      for(Sobject sobj : list_sobjects) {
          Case cse = (Case)sobj;
          caseMap.put(cse.Id,cse);
      }
 
      String userLSO;
      String userLSO1;
      String accLSO;
      List<Case> updatedCaseList = new List<Case>();
             
      Map<Id,Account> accountMap = new map<Id,Account>([Select Id, Name, (Select Id, name,LBU__c,LSO__c,LSO_ERP_Mapping_Value__c from LSO_Reference_Datas__r) from Account where Id in (Select accountId from Case where Id in :caseMap.keySet())]);
      Map<Id,User> userMap = new map<Id,User>([Select Id, Name,Default_BU__c,Default_LSO__c,Default_Country_ISO_Code__c from User where Id in (Select ownerId from Case where Id in :caseMap.keySet())]);          
       
           

        for(Case cas : caseMap.values()) {
            Case cse = new Case(Id = cas.Id);
            Account eua = accountMap.get(cas.AccountId);
            User usr = userMap.get(cas.ownerid);
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
                            if(usr!=null && usr.Default_BU__c!=null &&  lrd.LBU__c!= null && userLSO !=null && accLSO!=null && userLSO.equalsIgnorecase(accLSO)){ 
                                cse.Account_LSO_Case__c = lrd.id;
                                break;
                            }
                            else if(usr!=null && usr.Default_BU__c==null &&  lrd.LBU__c == null && userLSO1!=null && userLSO1.equalsIgnorecase(String.valueof(lrd.LSO__c))){
                                cse.Account_LSO_Case__c = lrd.id;
                                break;
                            }
                            else{
                                cse.Account_LSO_Case__c  = null;
                            }
                        }
                    }
                    else{
                        cse.Account_LSO_Case__c  = null;
                    }
            }
        updatedCaseList.add(cse);           
        } 
      totalProcesd.addAll(updatedCaseList);     
      Database.SaveResult[] saveRes = database.update(updatedCaseList,false);
      for(Integer i=0;i<saveRes.size();i++){
          String errDet;
          if(saveRes.get(i).isSuccess()){
            sucsIds.add(saveRes.get(i).getId()); 
          }
          else{
            Database.Error err = saveRes.get(i).getErrors().get(0);
            errDet = updatedCaseList.get(i).Id+'-'+err.getMessage();
            errIds.add(errDet);
          }
       }
    }
    
    
    global void finish(Database.BatchableContext BC){ 
        System.Debug('@@@@@@@@@ EUP Batch Processed List Size @@@@@@@@@  '+totalProcesd.size());
        System.Debug('$$$$$$$$$ Case Batch Update List Size $$$$$$$$$  '+sucsIds.size());
        System.Debug('######### Case Batch Update Errors #########  '+errIds.size()+'--'+errIds);
    }
}