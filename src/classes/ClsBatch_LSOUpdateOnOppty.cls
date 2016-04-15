/**
 *  batch job to auto-populate LSO reference data info on Opportunity record 
 *  from associated 
 *  Account Customer, Account End User and Primary Partner Account
 *
 @  author Shankar Anand
 @  created 2015-110-07
 @  version 1.0
 */
 
global class ClsBatch_LSOUpdateOnOppty implements Database.Batchable<sObject>, Database.stateful{
    global String query;
    global Set<Id> sucsIds = new Set<Id>();
    global Set<String> errIds = new Set<String>();
    global Set<Opportunity> totalProcesd = new Set<Opportunity>();
           
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        if(!Test.isRunningTest()){
        query = 'Select Id,Name,OwnerId,AccountId,Account_End_User__c,Account_Customer_LSO_Reference_Data__c,End_User_LSO_Reference_Data__c,Primary_Partner_LSO_Reference_Data__c From Opportunity';
            }
        else{
            query = 'Select Id,Name,OwnerId,AccountId,Account_End_User__c,Account_Customer_LSO_Reference_Data__c,End_User_LSO_Reference_Data__c,Primary_Partner_LSO_Reference_Data__c From Opportunity LIMIT 1';
            }
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, list<Sobject> list_sobjects){ 
      Map<Id,Opportunity> opptyMap = new Map<Id,Opportunity>();
      for(Sobject sobj : list_sobjects) {
          Opportunity oppty = (Opportunity)sobj;
          opptyMap.put(oppty.Id,oppty);
      }
      
      String userLSO;
      String userLSO1;
      String accLSO;
      String primPartnerLSO;
      List<Opportunity> updatedOpptyList = new List<Opportunity>();
            
      Map<Id,OpportunityPartner> partnerMap = new Map<Id,OpportunityPartner>();     
      Map<Id,Opportunity> oldOpptyMap = new map<Id,Opportunity>();
      Map<Id,Account> accountCustMap = new map<Id,Account>([Select Id, Name, (Select Id, name,LBU__c,LSO__c,LSO_ERP_Mapping_Value__c from LSO_Reference_Datas__r) from Account where id in (Select accountId from Opportunity where id in :opptyMap.keySet())]);
      Map<Id,Account> accountEndUserMap = new map<Id,Account>([Select Id, Name, (Select Id, name,LBU__c,LSO__c,LSO_ERP_Mapping_Value__c from LSO_Reference_Datas__r) from Account where id in (Select Account_End_User__c from Opportunity where id in :opptyMap.keySet())]);
      Map<Id,User> userMap = new map<Id,User>([Select Id, Name,Default_BU__c,Default_LSO__c,Default_Country_ISO_Code__c from User where Id in (Select ownerId from Opportunity where id in :opptyMap.keySet())]);          
      Map<Id,OpportunityPartner> primPartners= new map<Id,OpportunityPartner>([Select Id,role,isPrimary,OpportunityId,accountToId from OpportunityPartner where isPrimary = true and OpportunityId in :opptyMap.keySet() LIMIT 50000]);
      Map<Id,Account> primPartnerAccnts = new map<Id,Account>([Select Id, Name, (Select Id, name,LBU__c,LSO__c,LSO_ERP_Mapping_Value__c from LSO_Reference_Datas__r) from Account where id in (Select accountToId from OpportunityPartner where id in :primPartners.keySet()) LIMIT 50000]);
     
        for(Opportunity oppty : opptyMap.values()) { 
            Opportunity oppy = new Opportunity(Id = oppty.Id);
            Account act = accountCustMap.get(oppty.accountId);
            Account eua = accountEndUserMap.get(oppty.Account_End_User__c);
               
            for(OpportunityPartner prtnr:primPartners.values()){
               if(prtnr.opportunityId == oppty.id){
                  partnerMap.put(oppty.Id,prtnr);
                  }
              }
                
            User usr = userMap.get(oppty.ownerid);
            if(usr!=null && usr.Default_BU__c!=null){
              userLSO = usr.Default_LSO__c+usr.Default_BU__c;
            }
            else{
              if(usr!=null)
              userLSO1 = usr.Default_LSO__c;
            }
                
            if(act!=null){  
              List<ERP_Reference_Data__c> acLsoRefList = new List<ERP_Reference_Data__c>();
              acLsoRefList.addall(act.LSO_Reference_Datas__r);
                
              if(acLsoRefList.size()>0){
                for(ERP_Reference_Data__c lrd:act.LSO_Reference_Datas__r){
                    accLSO = String.valueof(lrd.LSO__c)+String.valueof(lrd.LBU__c);
                    if(usr!= null && usr.Default_BU__c!=null && lrd.LBU__c!= null && userLSO!=null && userLSO.equalsIgnoreCase(accLSO)){
                        oppy.Account_Customer_LSO_Reference_Data__c = lrd.id;
                        break;
                    }
                    else if(usr!= null && usr.Default_BU__c == null && lrd.LBU__c == null && userLSO1!=null && userLSO1.equalsIgnoreCase(String.valueof(lrd.LSO__c))){
                        oppy.Account_Customer_LSO_Reference_Data__c = lrd.id;
                        break;
                    }
                    else{
                    oppy.Account_Customer_LSO_Reference_Data__c = null;
                    }
                }
               }
              else{
                oppy.Account_Customer_LSO_Reference_Data__c = null;
              }
            }
                
                
            if(eua!=null){
                List<ERP_Reference_Data__c> aeuLsoRefList = new List<ERP_Reference_Data__c>();
                aeuLsoRefList.addall(eua.LSO_Reference_Datas__r);
           
              if(aeuLsoRefList.size()>0){
                for(ERP_Reference_Data__c lrd:eua.LSO_Reference_Datas__r){
                    accLSO = String.valueof(lrd.LSO__c)+String.valueof(lrd.LBU__c);
                    if(usr!= null && usr.Default_BU__c!=null &&  lrd.LBU__c!= null && userLSO!=null && userLSO.equalsIgnoreCase(accLSO)){
                        oppy.End_User_LSO_Reference_Data__c = lrd.id;
                        break;
                    }
                    else if(usr!= null && usr.Default_BU__c==null &&  lrd.LBU__c == null && userLSO1!=null && userLSO1.equalsIgnoreCase(String.valueof(lrd.LSO__c))){
                        oppy.End_User_LSO_Reference_Data__c = lrd.id;
                        break;
                    }
                    else{
                    oppy.End_User_LSO_Reference_Data__c  = null;
                    }
                }
               }
              else{
                oppy.End_User_LSO_Reference_Data__c  = null;
              }
            }
        
            
            if(partnerMap!=null){
                OpportunityPartner op = partnerMap.get(oppy.id);
                List<ERP_Reference_Data__c> partnerLsoRefList = new List<ERP_Reference_Data__c>();
                if(primPartnerAccnts!=null && op!=null && primPartnerAccnts.get(op.accountToId)!=null)
                    partnerLsoRefList.addall(primPartnerAccnts.get(op.accountToId).LSO_Reference_Datas__r);
                    if(partnerLsoRefList.size()>0){  
                            for(ERP_Reference_Data__c lrd:primPartnerAccnts.get(op.accountToId).LSO_Reference_Datas__r){
                                primPartnerLSO = String.valueof(lrd.LSO__c)+String.valueof(lrd.LBU__c);
                                if(usr!= null && usr.Default_BU__c!=null &&  lrd.LBU__c!= null && userLSO!=null && userLSO.equalsIgnorecase(primPartnerLSO) &&  op.isPrimary == true){
                                   oppy.Primary_Partner_LSO_Reference_Data__c  = lrd.id;
                                   break;
                                }
                                else if(usr!= null && usr.Default_BU__c ==null &&  lrd.LBU__c == null && userLSO1!=null && userLSO1.equalsIgnorecase(String.valueof(lrd.LSO__c))  &&  op.isPrimary == true){
                                   oppy.Primary_Partner_LSO_Reference_Data__c = lrd.id;
                                   break;
                                }
                                else{
                                   oppy.Primary_Partner_LSO_Reference_Data__c = null;
                                }
                            }
                    }
                    else{
                        oppy.Primary_Partner_LSO_Reference_Data__c = null;
                    }           
            }
            updatedOpptyList.add(oppy);         
        }   
      totalProcesd.addAll(updatedOpptyList);  
      Database.SaveResult[] saveRes = database.update(updatedOpptyList, false);
      for(Integer i=0;i<saveRes.size();i++){
          String errDet;
          if(saveRes.get(i).isSuccess()){
            sucsIds.add(saveRes.get(i).getId()); 
          }
          else{
            Database.Error err = saveRes.get(i).getErrors().get(0);
            errDet = updatedOpptyList.get(i).Id+'-'+err.getMessage()+'/n';
            errIds.add(errDet);
          }
       }
    }      
    
    global void finish(Database.BatchableContext BC){
        System.Debug('@@@@@@@@@ Opportunity Batch Processed List Size @@@@@@@@@  '+totalProcesd.size());
        System.Debug('$$$$$$$$$ Opportunity Batch Update List Size $$$$$$$$$  '+sucsIds.size());    
        System.Debug('######### Opportunity Batch Update Errors #########  '+errIds.size()+'--'+errIds);
    }
}