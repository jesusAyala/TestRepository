/**
 *  batch job to update Key Account Manager on ABB ICV Account records 
 *  from associated 
 *  Account
 *
 @  author Shankar Anand
 @  created 2015-10-07
 @  version 1.0
 */
global class ClsBatch_AccountManagerUpdate implements Database.Batchable<sObject>, Database.stateful{
    global String query;
    global Set<Id> sucsIds = new Set<Id>();
    global Set<String> errIds = new Set<String>();
    global Set<Account> totalProcesd = new Set<Account>();

/**
 *  start method
 *
 @  author Shankar Anand
 @  created 2015-10-07
 @  version 1.0
 */       
global Database.QueryLocator start(Database.BatchableContext BC) {
            String icv = System.label.System_ABB_ICV_Account_RecordType_API_Name;
        query = 'Select Id,Name,Primary_Account_Manager__c,Key_Account_Manager__c From Account where RecordTypeName =: icv';
           
        return Database.getQueryLocator(query);
    }
    
/**
 *   execute method
 *
 @  author Shankar Anand
 @  created 2015-10-07
 @  version 1.0
 */        
global void execute(Database.BatchableContext BC, list<Sobject> list_sobjects){ 
      Map<Id,Account> accountMap = new Map<Id,Account>();
      Map<Id,User> userMap = new Map<Id,User>();
      Map<String,User> usrEmailMap = new Map<String,User>();
      List<Account> updatedAccounts = new List<Account>();
      List<String> emails= new List<String>();
      for(Sobject sobj : list_sobjects) {
          Account acc = (Account)sobj;
          accountMap.put(acc.Id,acc);
          emails.add(acc.Primary_Account_Manager__c);
      }
 
      userMap = new Map<Id,User>([Select Id, Name, Email from User where isActive = true and Email in:emails LIMIT 50000]);
      for(User usr:userMap.values()){
        usrEmailMap.put(usr.Email,usr);
      }
           

        for(Account accnt : accountMap.values()) {
            User usr1 = usrEmailMap.get(accnt.Primary_Account_Manager__c);
            if(usr1!= null && accnt.Primary_Account_Manager__c == usr1.Email){
                Account accnt1 = new Account(id=accnt.id,Key_Account_Manager__c=usr1.id);
                updatedAccounts.add(accnt1);
            }     
        } 
      totalProcesd.addAll(updatedAccounts);     
      Database.SaveResult[] saveRes = database.update(updatedAccounts,false);
      for(Integer i=0;i<saveRes.size();i++){
          String errDet;
          if(saveRes.get(i).isSuccess()){
            sucsIds.add(saveRes.get(i).getId()); 
          }
          else{
            Database.Error err = saveRes.get(i).getErrors().get(0);
            errDet = updatedAccounts.get(i).Id+ System.label.CL0003 +err.getMessage(); //CL0003 --> '-'
            errIds.add(errDet);
          }
       }
    }
    
/**
 *   finish method
 *
 @  author Shankar Anand
 @  created 2015-10-07
 @  version 1.0
 */     
global void finish(Database.BatchableContext BC){ 
        //System.Debug('@@@@@@@@@ EUP Batch Processed List Size @@@@@@@@@  '+totalProcesd.size());
        //System.Debug('$$$$$$$$$ Case Batch Update List Size $$$$$$$$$  '+sucsIds.size());
        //System.Debug('######### Case Batch Update Errors #########  '+errIds.size()+'--'+errIds);
    }
}