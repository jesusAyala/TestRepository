public with sharing class APTS_ABB_LP_PushFailedMSPAtoSAP implements Schedulable, Database.AllowsCallouts {
    
    private String sObjectId;
    
    public APTS_ABB_LP_PushFailedMSPAtoSAP(String sObjectId){
        this.sObjectId = sObjectId;
    }
    
    public void execute(SchedulableContext SC) {    
        
        List<APTS_ABB_LP_Thwarted_Agreement__c> lstThwartedAgreement = new List<APTS_ABB_LP_Thwarted_Agreement__c>();
        
        if(sObjectId != null && sObjectId != ''){
            
            lstThwartedAgreement = [SELECT Id, APTS_Object_Id__c, APTS_Agreement_Status__c, 
                                   APTS_Block_Parameter__c, APTS_Job_execution_Count__c, APTS_Cron_Job_Id__c
                                   FROM APTS_ABB_LP_Thwarted_Agreement__c
                                   WHERE APTS_Object_Id__c = :sObjectId];
                                   
            List<Apttus__APTS_Agreement__c> lstAgreement = [SELECT Id, Apttus__Status__c FROM Apttus__APTS_Agreement__c WHERE Id = :sObjectId];
            
            //This is to make sure if the job is schdeuled and the agreement is approved through some other mechanishm then we need to abort existing job
            if(lstAgreement.size() > 0){
                
                if(lstAgreement[0].Apttus__Status__c == 'Approved'){
                    
                    System.abortJob(SC.getTriggerId());
                    
                    if(lstThwartedAgreement.size() > 0){
                        APTS_ABB_LP_Thwarted_Agreement__c thwartedAgreement = lstThwartedAgreement[0];
                        thwartedAgreement.APTS_Agreement_Status__c = 'Success';
                        thwartedAgreement.APTS_Description__c = 'MSPA created in SAP successfully.';
                        update thwartedAgreement;
                    }
                    
                    return;
                }
            }
        }
        
        
        if(lstThwartedAgreement.size() > 0){
            
            APTS_ABB_LP_Thwarted_Agreement__c thwartedAgreement = lstThwartedAgreement[0];
            Set<Id> agreementIds = new Set<Id>{thwartedAgreement.APTS_Object_Id__c};
            APTS_MSPACreatorInSAPController.createMSPA(agreementIds, thwartedAgreement.APTS_Block_Parameter__c);
        }
    }
}