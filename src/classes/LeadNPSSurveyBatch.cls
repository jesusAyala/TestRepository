global class LeadNPSSurveyBatch implements Database.Batchable<sObject>, Database.Stateful
{      
    Public String query = 'SELECT ID, Applicable_for_NPS_Survey__c,lastmodifieddate From Lead where NPS_Ready__c = true and LastModifiedDate < LAST_N_DAYS:'+ System.Label.NPS_Survey_Batch_Last_Modified;
       
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
          return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<SObject>LeadRecords)
    {
        List<Lead> LeadsToUpdate = new List<Lead>();
        
        try
        {
            for(SObject c : LeadRecords)
            {
                Lead LeadRec = (Lead) c;                 
                LeadRec.Applicable_for_NPS_Survey__c= true;
                LeadsToUpdate.add(LeadRec);           
            }
            
            if(!LeadsToUpdate.isEmpty())
            {
                update LeadsToUpdate;
            }           
        }
        Catch(Exception ex)
        { 
            Throw ex;
        }                
        
    }
 global void finish(Database.BatchableContext BC)
 {
 }
 }