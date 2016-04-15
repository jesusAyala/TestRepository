/**   
    * This updates the main opportunity on the alternative opportunities
    * Release R5
    *  
    * @author  Shankar Anand (Accenture)
    * @created  2015-16-12* @version 1.0
    *
    */   
public without sharing class ClsTriggerAlternativeOpptyHandler{

   public Static Set<Id> processedOppIdSet = new Set<Id>();
    /**   
    * This method updates the main opportunity on the alternative opportunities
    
    */    
     @TestVisible 
    public static void updateMainOpportunity(ClsWrappers.TriggerContext trgCtx) {

         Set<Id> altOpportunityIdSet = new Set<Id>();
        Set<Id> opportunityIdSet = new Set<Id>();
        List<Opportunity> updatedOppList = new List<Opportunity>();
        Map<Id, List<Opportunity>> oppIdAndRelatedChildOppMap = new Map<Id, List<Opportunity>>();
        Map<Id, Set<Id>> oppIdAndChildIdSetMap = new Map<Id, Set<Id>>(); 
        Map<Id,Opportunity> alternativeOpptyMap = new Map<Id, Opportunity>();
        Map<Id,Opportunity> childOpptyMap = new Map<Id, Opportunity>();
        List<Opportunity> toBeUpdatedOppList = new List<Opportunity>();
        //Integer limitNo = Limits.getLimitQueryRows() - Limits.getQueryRows();
        
        if (trgCtx.isBefore && trgCtx.isUpdate) {
            
            for (sobject so : trgCtx.newList) {
            
                Opportunity newOppty = (Opportunity)so;
                Opportunity oldOppty = (Opportunity) trgCtx.oldMap.get(so.Id);
                
                //We have to process only if the previous alt opportunity value is blank 
                if (!processedOppIdSet.contains(newOppty.Id) && newOppty.Alternative_Opportunity_To__c != NULL && oldOppty.Alternative_Opportunity_To__c == NULL && newOppty.Alternative_Opportunity_To__c != oldOppty.Alternative_Opportunity_To__c ) {
                    
                    altOpportunityIdSet.add(newOppty.Alternative_Opportunity_To__c);
                    opportunityIdSet.add(newOppty.Id);
                    updatedOppList.add(newOppty);
                    processedOppIdSet.add(newOppty.Id);
                }
                
                if (!processedOppIdSet.contains(newOppty.Id) && oldOppty.Alternative_Opportunity_To__c != newOppty.Alternative_Opportunity_To__c && newOppty.Alternative_Opportunity_To__c != NULL && oldOppty.Alternative_Opportunity_To__c != NULL) {
                    newOppty.addError(System.Label.Update_Main_Oppty_Error_Message);
                }
            }
            
            
            if (altOpportunityIdSet.size() > 0) {
                
                //To retrieve alternative opportunity records and related(child-Alternative) Opportunity records of updated opportunity records
                List<Opportunity> oppList = [  SELECT Id, Name, Alternative_Opportunity_To__c, Alternative_Opportunity_To__r.Alternative_Opportunity_To__c
                                               FROM Opportunity WHERE (Id IN :altOpportunityIdSet) OR
                                                (Alternative_Opportunity_To__c IN : opportunityIdSet) LIMIT 50000];
                
                
                for (Opportunity opp: oppList) {
                    
                    if (opp.Alternative_Opportunity_To__c != NULL && opportunityIdSet.contains(opp.Alternative_Opportunity_To__c)) { //Updated(incoming) opportunity record 
                        
                        if (!oppIdAndRelatedChildOppMap.containsKey(opp.Alternative_Opportunity_To__c)) {
                            oppIdAndRelatedChildOppMap.put(opp.Alternative_Opportunity_To__c, new List<Opportunity>());
                        }                   
                        oppIdAndRelatedChildOppMap.get(opp.Alternative_Opportunity_To__c).add(opp);  //Added Main opportunity with childs
                        
                        if (!oppIdAndChildIdSetMap.containsKey(opp.Alternative_Opportunity_To__c)) {
                            oppIdAndChildIdSetMap.put(opp.Alternative_Opportunity_To__c, new Set<Id>());
                        }                   
                        oppIdAndChildIdSetMap.get(opp.Alternative_Opportunity_To__c).add(opp.Id);  //Added Main opportunity with childs
                        
                        childOpptyMap.put(opp.Id, opp);
                    }
                    
                    if (altOpportunityIdSet.contains(opp.Id)) {
                        alternativeOpptyMap.put(opp.Id, opp);
                    }       
                }        
                
                //Parent: Main 1, Child: A, B, C 
                //Parent: Main 2, Child: D 
                
                //To populate Alternative_Opportunity for child records
                for (Opportunity opp: updatedOppList) {
                    
                    Set<Id> childIdSet = oppIdAndChildIdSetMap.containsKey(opp.Id) ? oppIdAndChildIdSetMap.get(opp.Id) : NULL;                    
                    
                    
                    //Check whether the selected Alternative Opp has (parent by) Alternative look up value and Alternative.Alternative.Alternative Opp is blank 
                    if (alternativeOpptyMap.get(opp.Alternative_Opportunity_To__c).Alternative_Opportunity_To__c != NULL &&  alternativeOpptyMap.get(opp.Alternative_Opportunity_To__c).Alternative_Opportunity_To__r.Alternative_Opportunity_To__c == NULL && (childIdSet == NULL || (childIdSet != NULL && !childIdSet.contains(opp.Alternative_Opportunity_To__c)) )) {
                        
                        //Scenario 4:On updating Main 2 Alternative field to Opportunity B, O/P: Parent Main 1, Child: Main 2, A, B, C, D 
                        
                        //Assign the selected Alternative_Opportunity.Alternative_Opportunity and assign the same to related childs
                        opp.Alternative_Opportunity_To__c = alternativeOpptyMap.get(opp.Alternative_Opportunity_To__c).Alternative_Opportunity_To__c;
                        
                        if (oppIdAndRelatedChildOppMap.containsKey(opp.Id)) {
                        
                            for (Opportunity childOpp: oppIdAndRelatedChildOppMap.get(opp.Id)) {                           
                                
                                childOpp.Alternative_Opportunity_To__c = opp.Alternative_Opportunity_To__c; 
                                toBeUpdatedOppList.add(childOpp);
                                processedOppIdSet.add(childOpp.Id);
                            }                           
                        }
                    }  else {
                        if (oppIdAndRelatedChildOppMap.containsKey(opp.Id)) {
                            
                            //Scenario 1: On updating Main 1 Alternative to field to Opportunity B,  O/P: Parent B, Child: Main 1, A, C 
                            //Scenario 2: On updating Main 2 Alternative field to Opportunity Main 1, O/P: Parent Main 1, Child: A, B, C, D 
                             
                            for (Opportunity childOpp: oppIdAndRelatedChildOppMap.get(opp.Id)) {  // related childs                         
                                
                                Opportunity altOpp =  alternativeOpptyMap.get(opp.Alternative_Opportunity_To__c);                                
                                String oldParentId = childOpp.Alternative_Opportunity_To__c;
                                
                                if (childOpp.Id != opp.Alternative_Opportunity_To__c || ( altOpp.Alternative_Opportunity_To__c != opp.id && altOpp.Alternative_Opportunity_To__c == null)) {
                                  
                                    childOpp.Alternative_Opportunity_To__c = opp.Alternative_Opportunity_To__c;
                                } 
                                else if(childOpp.Id == opp.Alternative_Opportunity_To__c) {
                                 
                                    childOpp.Alternative_Opportunity_To__c = null;
                                }
                                else {
                                    // do nothing
                                }  

                                if (oldParentId != childOpp.Alternative_Opportunity_To__c){
                                    toBeUpdatedOppList.add(childOpp);
                                    processedOppIdSet.add(childOpp.Id);
                                }                           
                            }
                        }
                    }
                }             
                
                if (toBeUpdatedOppList.size() > 0) {
                    
                    try {
                        
                        update toBeUpdatedOppList;
                    } catch (DmlException exc) {
                    
                        String errMsgs  = '';
                        Integer numErrors = exc.getNumDml();
                        
                        for(Integer i = 0; i < numErrors; i++) { 
                            errMsgs +=  childOpptyMap.get(exc.getDmlId(i)).Name +System.label.CL00200+ exc.getDmlMessage(i) +System.label.Line_Break;              
                        }                        
                        String error = System.label.System_Oppty_Label1+ System.label.Break + errMsgs ;
                        for (sobject sob : trgCtx.newList) {
                            Opportunity oppty1 = (Opportunity)sob;
                            oppty1.addError(error, false); 
                        }  
                    }
                }
            }
        }
     }

}