/*
 *  Call batch ClsBatch_reAssignAccount
 *
 @  author Lili Zhao
 @  created 2014-11-21
 @  version 1.0
 @  since 30.0 (Force.com ApiVersion)
 *
 @  changelog
 *  2014-11-21 Lili Zhao <lili.zhao@itbconsult.com>
 *  - Created
 */
global class ClsBatch_reAssignAccount implements Database.Batchable<sObject>, Database.stateful{
static boolean recursive=false;
  global String query;
    global String filter;
       global String status; 
       global Set<Id> SafeIsland;
       private map<String, String> map_accId_successorCompany = new map<String, String>();
        private  Map<String,STring>map_accId_successorCompanyOut=new Map<String,String>();
       global   ClsBatch_reAssignAccount (String status, Set<Id> SafeIsland)
       {
       system.debug('***************Inside Batch constructor****************');
       this.status=status;
       this.SafeIsland = SafeIsland;
       } 
    global Database.QueryLocator start(Database.BatchableContext BC){ 

system.debug('***************Inside start****************');
        if(query == null || query == '')
        {   
        if(status.contains('Out Of Business'))         
           { 
           system.debug('***************Inside Out Query***************');
           query = 'Select Id,name, ReAssign__c, Successor_Company__c From Account where ReAssign__c = true And Successor_Company__c != null and  company_status__c =\'Out Of Business\'';
            }
        else if(status.contains('Duplicate'))
          {  
           query = 'Select Id,name, ReAssign__c, Successor_Company__c From Account where ReAssign__c = true And Successor_Company__c != null and  company_status__c=\'Duplicate\'';
            }
        }
        if(filter != null) query += filter;
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, list<Account> list_accounts){ 
    system.debug('***************Inside execute****************');
      
    for(Account account : list_accounts) {
      if(!map_accId_successorCompany.containsKey(account.Id) && account.Id != account.Successor_Company__c) {
        map_accId_successorCompany.put(account.Id, account.Successor_Company__c);
      }
    }
   
    
    }      
    
    global void finish(Database.BatchableContext BC){  
    if(!recursive){
    recursive=true;
       system.debug('***************Finish Method****************');
       try{
           System.debug('-------------------------------In Try-------------------------------------');
           if(status.contains('Duplicate'))
            {
            system.debug('***************Method called for Dup from batch****************');            
            ClsAccountUtil.setSuccessorCompany(map_accId_successorCompany,map_accId_successorCompanyOut, SafeIsland );
            }
           else if(status.contains('Out Of Business'))
            {
            system.debug('***************Method called for out from batch****************');            
            ClsAccountUtil.setSuccessorCompany(map_accId_successorCompanyOut,map_accId_successorCompany,SafeIsland );
            
            }
            System.debug('------------------------------ Try Succesfully End-------------------------------------');
          }
       catch(Exception e)
        {
            System.debug('-------------------------------In Catch-------------------------------------');
            System.debug('-------------------------------'+e.getMessage()+'-------------------------------------');
        }
       finally
       {
               
               list<Account> list_updateAccFields = new list<Account>();
                system.debug('-------------------------------In Finally-------------------------------------');
                
                for(Account account : [Select ReAssign__c, Reassignment_Pending__c From Account where ReAssign__c=true OR Reassignment_Pending__c=true ]) 
                {
                system.debug('----------------------------before resetting--------------------'+account.Reassignment_Pending__c+account.ReAssign__c);
                
                account.ReAssign__c = false;
                account.Reassignment_Pending__c = false;
                system.debug('----------------------------after resetting--------------------'+account.Reassignment_Pending__c+account.ReAssign__c);
                
                list_updateAccFields.add(account);
                }
                if(list_updateAccFields.size() > 0) {
                  ClsAccountUtil.isUpdate = false;
                  update list_updateAccFields;
                  system.debug('----------------------------after updating in finally--------------------');
                }
           
       }
      String BatchNUm = '';   
      String finishQuery = query + ' limit 1';     
        if(ReAssigning_Related_Records__c.getInstance('BatchNum') != null && ReAssigning_Related_Records__c.getInstance('BatchNum').value__c != null) {
          BatchNum = ReAssigning_Related_Records__c.getInstance('BatchNum').value__c;
        }         
        BatchNum = (BatchNUm == '' ? String.valueOf(10) : BatchNUm);
       list<Account> list_accs = new list<Account>();
      for(Account account : Database.query(finishQuery)) {
        list_accs.add(account);
      } 
      if(list_accs.size() > 0) {
        ClsBatch_reAssignAccount batchJob = new ClsBatch_reAssignAccount(status,SafeIsland);
       Database.executeBatch(batchJob, Integer.valueOf(BatchNum));
      }
      ClsAccountUtil.abortScheduledJobToReAssignAccount();
      }
    }
}