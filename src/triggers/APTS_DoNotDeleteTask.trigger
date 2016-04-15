trigger APTS_DoNotDeleteTask on Task (before delete)
{ 
   Map<Id, List<task>> quoteIdTaskMap = new Map<Id, List<task>>{};
   Map<Id, List<task>> agrmtIdTaskMap= new Map<Id, List<task>>{};
   
   //Added by Axay to remove keyPrefix hard coding-
   String agreementKeyPrefix = Apttus__APTS_Agreement__c.sObjectType.getDescribe().getKeyPrefix(),
   quoteKeyPrefix = Apttus_Proposal__Proposal__c.sObjectType.getDescribe().getKeyPrefix();
   //a01 - Agreement prefix & a1K - Proposal Prefix for SF1
   
   for (Task tsk : Trigger.old)      
   {   
   
        //convert id into string
        string whatId=tsk.WhatId;
   
        if(tsk.WhatId == null || (!whatId.startsWith(quoteKeyPrefix) && !whatId.startsWith(agreementKeyPrefix))){
            continue;
        }
       
        //check if relatedto on task is a quote(quote's unique id across Salesforce is 'a1k')
        if(whatId.startsWith(quoteKeyPrefix)){
            
            if(quoteIdTaskMap.get(tsk.WhatId) == null){
                quoteIdTaskMap.put(tsk.whatId, new list<task>());
            }
            
            quoteIdTaskMap.get(tsk.WhatId).add(tsk);
        
        }else if(whatId.startsWith(agreementKeyPrefix)){//check if relatedto of task is agreement(agreement's unique id across Salesforce is 'a01')
            
            if(agrmtIdTaskMap.get(tsk.WhatId) == null){
                agrmtIdTaskMap.put(tsk.whatId, new list<task>());
            }
            
            agrmtIdTaskMap.get(tsk.WhatId).add(tsk);
            
        }
        
        
    }

   //check if quote list is not null
  if(!quoteIdTaskMap.keySet().isEmpty()){
  
    for (Apttus_Proposal__Proposal__c quote : [Select Id, Name,APTS_Record_Type_Name__c from Apttus_Proposal__Proposal__c where Id in :quoteIdTaskMap.keySet()]){
       
        for(task quoteTask : quoteIdTaskMap.get(quote.id)){
           //if quote's record type is 'LP', through an error message
           if(quote.APTS_Record_Type_Name__c==APTS_Constants.PROPOSAL_TYPE){
               quoteTask.addError(Label.APTS_Task_Deletion_Error);
           }
        }
    }
 }   
 
 //check if agreement list is not null
 if(!agrmtIdTaskMap.keySet().isEmpty()){
 
    for (Apttus__APTS_Agreement__c agrmt : [Select Id, Name,APTS_LP_MSPA_Type__c from Apttus__APTS_Agreement__c where Id in :agrmtIdTaskMap.keySet()]){
       
        for(task agrmtTask : agrmtIdTaskMap.get(agrmt.id)){
           //through an error, if agreement's record type is 'MSPA'
           if(agrmt.APTS_LP_MSPA_Type__c==APTS_Constants.MSPA_TYPE){
               agrmtTask.addError(Label.APTS_Task_Deletion_Error_MSPA);
           } 
        }
    }
 }  
 
 
 
    /*  
    for (Task t : Trigger.old)      
    {   
      string whatId=t.WhatId;
      //check if the task is related to quote(a1k) or MSPA(a01)
       if(whatId !=null && (whatId.startsWith('a1K') || whatId.startsWith('a01'))){ 
          //through an error message
          tsk.addError(Label.APTS_Task_Deletion_Error);
       }
     }     
    */        
   
}