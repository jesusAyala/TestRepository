/*
 * TriggerClass -  To Populate Proposal Number in RFQ
 * 
 * Release R5
 * @author  Aswini Arasu
 * @created 2016-02-24
 * @version 1.0
 * Created
 */ 
public class ClsTriggerProcessingHandler extends ClsTriggerVirtual {
/**
* @see IntHelper.beforeTrigger

    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
        setActualCompletionDateFromResults(trgCtx); 
    }

* @see IntHelper.afterTrigger
*/
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx){
          setProposalNumberFromProcessing(trgCtx); 
        
    }   
/*
 * Method setProposalNumberFromProcessing
 * To Populate Proposal Number in RFQ
 * 
*/    
    private void setProposalNumberFromProcessing(ClsWrappers.TriggerContext trgCtx) { 
     Map <ID, RFP__c> RfpMap = new Map<Id,RFP__c> ();
     Set<ID> RfqIds = new Set<ID>();
     List<RFP__c> updatedRFQs = new List<RFP__c>();
     Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
     if (trgCtx.isAfter && (trgCtx.isInsert || trgCtx.isUpdate)) {
      for (sobject sObj : trgCtx.newList) {                    
                Rfp_Processing__c proc = (Rfp_Processing__c) sObj; 
                RfqIds.add(proc.Rfp_Processing__c);
        }
        
      RfpMap = new Map<Id,RFP__c > ([ SELECT ID, Name,Actual_Completion_Date__c
                             FROM RFP__c WHERE ID IN :RfqIds LIMIT :remLimit]); 
       
           for (sobject sObj : trgCtx.newList) {  
                Rfp_Processing__c proc = (Rfp_Processing__c) sObj;                 
                RFP__c rfp = RfpMap.get(proc.Rfp_Processing__c);
                if(rfp!=null){
                rfp.Proposal_Number__c =  proc.Rfp_Proposal_Number__c;
                }
                updatedRFQs.add(rfp);
              }
           Database.update(updatedRFQs,false);   
       }
         
     }
     
}