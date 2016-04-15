/*
 * TriggerClass -  To Populate Actual Completion date in RFQ
 * 
 * Release R5
 * @author  Aswini Arasu
 * @created 2016-02-24
 * @version 1.0
 * Created
 */ 
public with sharing class ClsTriggerResultsHandler extends ClsTriggerVirtual {
/**
* @see IntHelper.beforeTrigger

    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
        setActualCompletionDateFromResults(trgCtx); 
    }

* @see IntHelper.afterTrigger
*/
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx){
    try{
          setActualCompletionDateFromResults(trgCtx); 
        }catch(DMLException e){  string err = e.getmessage();} 
    }   
/*   
    *  @name setActualCompletionDateFromResults
*/  
    private void setActualCompletionDateFromResults(ClsWrappers.TriggerContext trgCtx) { 
     Map <ID, RFP__c> RfpMap = new Map<Id,RFP__c> ();
     Set<ID> RfqIds = new Set<ID>();
     List<RFP__c> updatedRFQs = new List<RFP__c>();
     
     if (trgCtx.isAfter && (trgCtx.isInsert || trgCtx.isUpdate)) {
      for (sobject sObj : trgCtx.newList) {                    
                Rfp_Results__c res = (Rfp_Results__c) sObj; 
                RfqIds.add(res.Rfp_Results__c);
        }
        
      RfpMap = new Map<Id,RFP__c > ([ SELECT ID, Name,Actual_Completion_Date__c
                             FROM RFP__c WHERE ID IN :RfqIds LIMIT 50000]); 
       
           for (sobject sObj : trgCtx.newList) {  
                Rfp_Results__c res = (Rfp_Results__c)sObj;                  
                RFP__c rfp = RfpMap.get(res.Rfp_Results__c);
                if(rfp!=null){
                rfp.Actual_Completion_Date__c =  res.Rfp_Actual_Completion_Date__c;
                }
                updatedRFQs.add(rfp);
              }
           database.update(updatedRFQs,false);   
       }
         
     }
     
}