/**
 *  batch job to clone account related notes
 *
 @  author Lili Zhao
 @  created 2014-11-21
 @  version 1.0  
 @  since 30.0 (Force.com ApiVersion)
 *
 @  changelog
 *  2014-11-21 Lili Zhao <lili.zhao@itbconsult.com>
 *  - Created
 * 2015-11-17 Ishita Bhardwaj <ishita_bhardwaj@infosys.com>
 * -Changed
 */
global class ClsBatch_cloneAccountAttachments implements Database.Batchable<sObject>, Database.stateful{
    
    global String query;
    global String filter;
    global boolean reParentAttach;
    global boolean reParentNote;
    global map<String, String> map_accId_successorCompany;
           
    global Database.QueryLocator start(Database.BatchableContext BC) { 
        set<String> set_sourceIds = new set<String>();
        set_sourceIds.addAll(map_accId_successorCompany.keySet());
        if(set_sourceIds.isEmpty() || reParentAttach == false) {
            return null;
        }
        if(query == null || query == ''){            
            query = 'Select Id, Body, Name, ParentId '
                  + ' From Attachment '
                  + ' where ParentId IN : set_sourceIds ';
        }
        if(filter != null) query += filter;
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, list<Sobject> list_sobjects){ 
        list<Sobject> list_cloneList = new list<Sobject>();
        for(Sobject sobj : list_sobjects) {
            // clone the object for read only object
            //ClsAccountUtil.cloneSobject('ParentId', map_accId_successorCompany.get(String.valueof(sobj.get('ParentId'))), sobj, list_cloneList);
            Map<String, Set<String>>  lstSImap = new Map<String, Set<String>>();
 Map<String,Set<String>> lstACmap = new Map<String, Set<String>>();
            
            ClsAccountUtil.cloneSobject('ParentId', map_accId_successorCompany.get(String.valueof(sobj.get('ParentId'))), sobj, list_cloneList, 'Attachment', lstSImap,lstACmap );
        }
        database.delete(list_sobjects, false);
        database.insert(list_cloneList, false);
    }      
    
    global void finish(Database.BatchableContext BC){  
        //ClsAccountUtil.deleteSourceAccts(map_accId_successorCompany);
        //update Reassignment_Pending__c & ReAssign__c fields
        list<Account> list_updateAcc = new list<Account>();
        for(Account account : [Select ReAssign__c, Reassignment_Pending__c From Account where Id IN : map_accId_successorCompany.keySet()]) {
            account.ReAssign__c = false;
            account.Reassignment_Pending__c = false;
            list_updateAcc.add(account);
        }
        
        if(list_updateAcc.size() > 0) {
            ClsAccountUtil.isUpdate = false;
            update list_updateAcc;
            ClsAccountUtil.isUpdate = true;
        }
    }
}