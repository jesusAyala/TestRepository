/**
*  This test class used to test class LeadNPSSurveyBatch. and LeadNPSSurveyBatchSchedule

*    
@author Saiprasad Telkapally   
@created 2016-03-22
@version 1.0 
* 
*/

@isTest
private class LeadNPSSurveyBatch_TEST {
    //DateTime createdDateValue = DateTime.now()+30;
    static testMethod void myTest() {
    Lead[] Leads = new Lead[0]; 
    for (Integer a = 0; a < 150; a++) {
            Leads.add(new Lead(
            Company = 'JohnMiller',
            LastName = 'Mike',
            Status = 'Open',
            Applicable_for_NPS_Survey__c = true,
            Subject__c = 'wnffnvgf',
         
            Description = 'njsdbgnmfndjfmbl'+a));
        }
            insert Leads;
            Set<Id> Ids = new Set<Id>();
            for (Lead lst : Leads) {
                Ids.add(lst.Id); 
            }
        List<Lead> queried_leads = [SELECT Applicable_for_NPS_Survey__c FROM Lead WHERE Id =: Ids];
        for (Lead ql : queried_leads) { 
            System.assertEquals(true, ql.Applicable_for_NPS_Survey__c); 
        }           
        Test.startTest();
        String CRON_EXP = '0 0 0 15 3 ?';
        LeadNPSSurveyBatch batch = new LeadNPSSurveyBatch();
        batch.query = 'SELECT id, Applicable_for_NPS_Survey__c  FROM Lead where Applicable_for_NPS_Survey__c = true';
        //batch.soql += ' WHERE LastModifiedDate <= '+createdDateValue;
        ID batch_processId = Database.executeBatch(batch); //execute the batch
        LeadNPSSurveyBatchSchedule sc = new LeadNPSSurveyBatchSchedule();
        String jobId = system.schedule('JohnMiller', CRON_EXP, sc );
                CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        Test.stopTest();
    
    }
}