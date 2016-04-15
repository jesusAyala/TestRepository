/**
 * Schedulable BatchClass - Delete the records from Local ERP Loader 
 *       
 * Release R3
 *  
 * @author  Vinodh Kumar (Accenture)
 * @created 2015-07-22
 * @version 1.0
 *
 * - Created
 */
global class BatchDeleteLocalErpLoaderSchedule implements Schedulable {

/**
* Method - execute
* Description - Execute method to initiate the batch class
 */
    global void execute(SchedulableContext sc) {

        BatchDeleteLocalErpLoader batch = new BatchDeleteLocalErpLoader();
        Database.executeBatch(batch);  
    }
}