/**
*  Created By: Shahid Ali (sale@apttus.com)
*  Created Date: 29 January 2016
*  Description:  This class is used to 1. Set flag and store parent quote while cloning.
*   
*/
  global with sharing class APTS_CustomQuoteLifecycleCallback 
      implements Apttus_Proposal.CustomClass.IQuoteLifecycleCallback2 {
      
    /**
     * Callback invoked after a quote/proposal is created from an account
     * @param quoteSO the new quote sobject 
     */
    global void afterCreateFromAccount(Apttus_Proposal__Proposal__c quoteSO) {
      
    }
    
    /**
     * Callback invoked after a quote/proposal is created from an opportunity
     * @param quoteSO the new quote sobject 
     */
    global void afterCreateFromOpportunity(Apttus_Proposal__Proposal__c quoteSO) {
      
    }
    
    /**
     * Callback invoked after an agreement is created from a quote/proposal
     * @param quoteSO the quote sobject 
       * @param agreementSO the new agreement sobject 
     */
    global void afterCreateAgreement(Apttus_Proposal__Proposal__c quoteSO, Apttus__APTS_Agreement__c agreementSO) {
    
    
    }
    
    /**
     * Callback invoked after a quote/proposal is cloned
     * @param originalSO the original quote sobject 
     * @param cloneSO the clone quote sobject
     */
    global void afterClone(Apttus_Proposal__Proposal__c originalSO, Apttus_Proposal__Proposal__c cloneSO) {
        cloneSO.APTS_Cloned_From_ID__c =originalSO.Id;
        cloneSO.APTS_Is_Clone__c = true;
    }
    
     /**
     * Callback invoked before a quote/proposal is cloned
     * @param originalSO the original quote sobject 
     * @param cloneSO the clone quote sobject
     */
    global void beforeClone(Apttus_Proposal__Proposal__c originalSO, Apttus_Proposal__Proposal__c cloneSO) {

    }
    
    /**
     * Callback invoked after the completion of a lifecycle action
     * @param quoteSO the quote sobject 
     * @PARAM actionType the lifecycle action type
     */
    global void afterComplete(Apttus_Proposal__Proposal__c quoteSO, Apttus_Proposal.CustomClass.ActionType actionType) {
      
      
    }
    
    /**
     * Callback invoked after the completion of a lifecycle action
     * @param agreementSO the agreement sobject 
     * @PARAM actionType the lifecycle action type
     */
    global void afterComplete(Apttus__APTS_Agreement__c agreementSO, Apttus_Proposal.CustomClass.ActionType actionType) {
      
      
    }       
}