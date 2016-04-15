/**
 * Apex class - LeadNPSSurveyBatchSchedule
 * Release R5
 * @author  Sai Prasad (Accenture)
 * @version 1.0
 * Created
 */
global class LeadNPSSurveyBatchSchedule implements Schedulable {
/**
* Method execute
* Scheduler for LeadNPSSurveyBatch 
*/
    global void execute(SchedulableContext sc) {
        LeadNPSSurveyBatch batch = new LeadNPSSurveyBatch();
        Database.executeBatch(batch);  
    }
}