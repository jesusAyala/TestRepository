/**
 * BatchClass - Delete the records from Local ERP Loader 
 *       
 * Release R3
 *  
 * @author  Vinodh Kumar (Accenture)
 * @created 2015-07-22
 * @version 1.0
 *
 * - Created
 */
global class BatchDeleteLocalErpLoader implements Database.Batchable<sObject>{

    Public Datetime todayDate = system.now();
    Public DateTime lastThreeMonthDateTime = todayDate.addMonths(-3);       
    Public String query = 'SELECT Id, Name FROM Local_ERP_Loader__c WHERE CreatedDate <= :lastThreeMonthDateTime';
/**
 *  Method - start
 *  get the record to process      
 *  
 */    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

/**
 *  Method - execute
 *  delete the records      
 *  
 */   
    global void execute(Database.BatchableContext BC, List<Local_ERP_Loader__c> erpLoadList){
                 
        try {             
            Database.Delete(erpLoadList);   
        }catch(Exception e) {        
            Log__c log = new Log__c(Class_Name__c = System.Label.System_BatchDeleteLocalErpLoader, Error_Line__c = String.valueof(e.getLineNumber()), Full_Error__c = String.valueof(e));
            Database.insert(log);
        }  
    }   
/**
 *  Method - finish      
 *  
 */    
    global void finish(Database.BatchableContext BC){
    }
}