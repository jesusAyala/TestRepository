/**
 *  Call batch job ClsBatch_reAssignAccount
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
global class ClsScheduled_reAssignAccount implements Schedulable{
global string status;
global Set<Id> SafeIsland;
global ClsScheduled_reAssignAccount(String status, Set<Id> SafeIsland)
{
this.status=status;
this.SafeIsland = SafeIsland;
}
    global void execute(SchedulableContext sc) {   
        
        String BatchNUm = '';        
        if(ReAssigning_Related_Records__c.getInstance('BatchNum') != null && ReAssigning_Related_Records__c.getInstance('BatchNum').value__c != null) {
            BatchNum = ReAssigning_Related_Records__c.getInstance('BatchNum').value__c;
        }         
        BatchNum = (BatchNUm == '' ? String.valueOf(10) : BatchNUm);
        
        ClsBatch_reAssignAccount batchJob = new ClsBatch_reAssignAccount(status, SafeIsland);
        if(!test.isRunningTest()) {
            Database.executeBatch(batchJob, Integer.valueOf(BatchNum)); 
        }       
    }
}