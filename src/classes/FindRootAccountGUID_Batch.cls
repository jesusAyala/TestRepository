/**
 * ApexClass -  FindRootAccountGUID_Batch 
 * Release R5
 * @author  Vasanthi (Accenture)
 * @created 2016-2-8
 * @version 1.0
 * Description: As per Req #2737(KAD-00821) To find root account GUID. 
 * Created 
  */
global class FindRootAccountGUID_Batch implements Database.Batchable<sObject> {
    
    global String query;
    public Map<Id, String> accErrorMap = new Map<Id, String>();

/**
 * Constructor FindRootAccountGUID_Batch 
 * Release R5
*/     
    global FindRootAccountGUID_Batch(){
     
         query = 'SELECT Id, Name, ParentId, GUID__c, Root_Account_GUID__c, Parent.ParentId, parent.parent.parentId, parent.parent.parent.parentId,';
         query += 'parent.parent.parent.parent.parentId, parent.parent.parent.parent.parent.parentId FROM Account WHERE RecordType.Name = \'GIS Approved\'';
    }
    
/**
 * start Method 
 * Release R5
*/    
    global Database.QueryLocator start(Database.BatchableContext BC){
    
      return Database.getQueryLocator(query);
    }

/**
 * execute Method 
 * Release R5
*/
   global void execute(Database.BatchableContext BC, List<Account> accountList){
        
        Map<Id, Id> parentChildMap = new Map<Id, Id>();
        Map<Id, Id> accIdAndTopParIdMap = new Map<Id, Id>();
        Set<Id> routeIdSet = new Set<Id>();
        Set<Id> needToQueryAgainAccIdSet = new Set<Id>();
        FindRootAccountClass fc = new FindRootAccountClass();
        
        List<Account> toBeUpdatedAccountList = new List<Account>();
        Map<Id, Id> accIdAndParIdMap = new Map<Id, Id>();
        Map<Id, String> accIDAndNameMap = new Map <Id, String>();
        
        for (Account acc: AccountList) {            
            
            accIDAndNameMap.put(acc.ID, acc.Name);
            
            Boolean needRecursive = FALSE;
            
            Id parentId = null;
            if(acc.parent.parent.parent.parent.parent.parentId != null) {
                parentId = acc.parent.parent.parent.parent.parent.parentId;
                needToQueryAgainAccIdSet.add(parentId);
                needRecursive = TRUE;
            } else if(acc.parent.parent.parent.parent.parentId != null) {
                parentId =  acc.parent.parent.parent.parent.parentId;
            } else if(acc.parent.parent.parent.parentId != null) {
                parentId = acc.parent.parent.parent.parentId;
            } else if(acc.parent.parent.parentId != null) {
                parentId = acc.parent.parent.parentId;
            } else if(acc.parent.parentId != null) {
                parentId = acc.parent.parentId;
            } else if(acc.parentId != null) {
                parentId = acc.parentId;
            } else {
                parentId = acc.id;
            }
            if (needRecursive) {
                parentChildMap.put(parentId, acc.Id);
                accIdAndTopParIdMap.put(acc.Id, parentId);
            } else {
                routeIdSet.add(parentId);
                accIdAndParIdMap.put(acc.Id, parentId);
            }           
        }
        
        if (needToQueryAgainAccIdSet.size() > 0) {
        
            Map<Id, Id> rootMap = fc.findTopMostParent( needToQueryAgainAccIdSet, accIdAndTopParIdMap, parentChildMap );
            
            for (Id accId : rootMap.keySet()) {
                accIdAndParIdMap.put(accId, rootMap.get(accId));
            }       
        }
        Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, GUID__c FROM Account WHERE ID IN :accIdAndParIdMap.values() LIMIT :remLimit]);
        
        for (Account acc: AccountList) {
            
            if (accIdAndParIdMap.containsKey(acc.Id) && acc.Root_Account_GUID__c != accountMap.get(accIdAndParIdMap.get(acc.Id)).GUID__c) {
            
                acc.Root_Account_GUID__c = accountMap.get(accIdAndParIdMap.get(acc.Id)).GUID__c;
                toBeUpdatedAccountList.add(acc);
            }
        }
        
         try {
            if (toBeUpdatedAccountList != NULL && toBeUpdatedAccountList.size() > 0) {
                
                //system.debug('::toBeUpdatedAccountList::'+toBeUpdatedAccountList);
                
                Database.SaveResult[] ds = Database.Update(toBeUpdatedAccountList, FALSE);
                Integer j = 0;
                for (Database.SaveResult res: ds) {
                   
                    if (!res.IsSuccess()) {                    
                        //system.debug(':::Error:::'+res.getErrors().get(0).getMessage());
                        //if (toBeUpdatedAccountList[j].Id != NULL && res.getErrors() != NULL) {                    
                        //accErrorMap.put(toBeUpdatedAccountList[j].Id, accIDAndNameMap.get(toBeUpdatedAccountList[j].Id) +'~'+ res.getErrors().get(0).getMessage());
                        //}
                    }
                    j++;
                }
            }
        } Catch(Exception e) {
          // system.debug('::::exception::'+e);
        }
        
    }

/**
 * finish Method 
 * Release R5
*/
    global void finish(Database.BatchableContext BC){
       
    }
}