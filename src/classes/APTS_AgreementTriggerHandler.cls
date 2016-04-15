/*************************************************************
@Name: APTS_AgreementTriggerHandler
@Author: Nishi Kushwaha
@CreateDate: 29/08/2015
@Description: This class acts as a handler for various events on Agreement Object
@UsedBy: Trigger APTS_AgreementTrigger
******************************************************************
@ModifiedBy: Nishi Kushwaha,Hardik Shah
@ModifiedDate: 02/09/2015
@ChangeDescription: Created a method "OnBeforeUpdate()" which calls API to create Empty cart when Product Configuration Checkbox = True
@ChangeDescription: Created a method "OnBeforeUpdate()" which automates PriceList based on account customer
@ChangeDescription: Created a method autopopulateMSPARefNumber,updateMSPARefNumber which is  pre-populated in Agreement-Header
PS: @ModifiedBy and @ChangeDescription can be repeated multiple time, based on number of changes made to the original process.
******************************************************************/

public with sharing class APTS_AgreementTriggerHandler {
    private static Boolean bIsMSPARefIDFetched = false;
    
    public APTS_AgreementTriggerHandler() {
    }
   
    public void onBeforeInsert(List<Apttus__APTS_Agreement__c> listNewAgreement){
        // Fetch only those Agreement that are specific to LP-Spain
        List<Apttus__APTS_Agreement__c> listAgreement = APTS_LP_CommonUtil.isApplicableFOrLP(listNewAgreement);
        //system.debug('******listagrmts'+listAgreement[0].Id);
        if(listAgreement.size() > 0){
            
            // auto Populates MSPA ref number when Agreement is created
            APTS_AgreementTriggerHelper.autopopulateMSPARefNumber(listAgreement);
            // auto Populate Primary Partner Account related to Opportunity
            APTS_AgreementTriggerHelper.autopopulatePrimaryPartnerCustomer(listAgreement);
            // auto populate the selected Account Customer in Account (OOB) field.
            APTS_AgreementTriggerHelper.populateAccountCustomerInAccount(listAgreement);
            //add LOD data when agreement is created from non buying quotes
            APTS_AgreementTriggerHelper.updateLODForNonBuyingAgreement(listAgreement);
            
        }else{
            
            //TODO - Replace system.debug with logging framework
            system.debug('Agreement is not LP Specific');
            
        }
       
    }
    
    public void OnBeforeUpdate(Map<Id,Apttus__APTS_Agreement__c> mapOldAgreement, Map<Id,Apttus__APTS_Agreement__c> mapNewAgreement){
   
        //system.debug('Entered before update:APTS_AgreementTriggerHandler');
        
        Map<Id,Apttus__APTS_Agreement__c> mapAgreement = APTS_LP_CommonUtil.isApplicableFOrLP(mapNewAgreement);
        Map<Id,Apttus__APTS_Agreement__c> agreementsToProcess = new Map<Id,Apttus__APTS_Agreement__c>();
        
        if(mapAgreement.size() > 0){
            APTS_AgreementTriggerHelper.readOnlyMSPAValidation(mapOldAgreement, mapAgreement);
            // Added by Hardik Shah.
            // This method auto populates pricelist when new Agreement/MSPA is created
            APTS_AgreementTriggerHelper.automatePriceList(mapAgreement);
            // Create Configuration when "Product Configuration" field in MSPA is True
            // Commented by Nishi as it is not needed anymore
            //APTS_AgreementTriggerHelper.createEmptyCart(mapOldAgreement,mapAgreement);
            
            //Added By Kruti Shah
            //This method will populate agreement header field(like ProductDiscounts, HierarchyDiscounts,Hierarchylevel)
            APTS_AgreementTriggerHelper.GetAvailableDiscounts(mapAgreement);
            
            // auto Populate Primary Partner Account related to Opportunity
            APTS_AgreementTriggerHelper.autopopulatePrimaryPartnerCustomer(mapAgreement.values());
            //auto populate the selected Account Customer in Account (OOB) field.
            APTS_AgreementTriggerHelper.populateAccountCustomerInAccount(mapAgreement.values());
            
            //Added By: Axay - to set Status/Status Category post Generate
            APTS_AgreementTriggerHelper.changeAgreementStatusAfterGenerate(mapOldAgreement, mapAgreement);
            
        }else{
            
            //TODO - Replace system.debug with logging framework
            system.debug('Agreement is not LP Specific');
         }
        
         if(Trigger.size == 1){
            
            for(Apttus__APTS_Agreement__c newAgreement : mapAgreement.values()){
                
                //System.debug('##### In Update - old integration status of MSPA #### '+mapOldAgreement.get(newAgreement.Id).APTS_Integration_Status__c);
                //System.debug('##### In Update -  old status of MSPA #### '+mapOldAgreement.get(newAgreement.Id).Apttus__Status__c);
                
                if((newAgreement.Apttus__Status__c == APTS_Constants.STATUS_APPROVED_ACTION_REQ && newAgreement.APTS_Integration_Status__c != 'Sent' 
                && newAgreement.Apttus_CMConfig__ConfigurationFinalizedDate__c !=  mapOldAgreement.get(newAgreement.Id).Apttus_CMConfig__ConfigurationFinalizedDate__c) || 
                
                   (newAgreement.Apttus__Status__c == APTS_Constants.STATUS_APPROVED_ACTION_REQ && mapOldAgreement.get(newAgreement.Id).Apttus__Status__c == 'Approval In Progress'
                   && newAgreement.APTS_Integration_Status__c != 'Sent') || 
                   
                   (newAgreement.Apttus__Status__c == APTS_Constants.STATUS_APPROVED_ACTION_REQ && newAgreement.APTS_Related_Quotation_Status__c == 'Approved' 
                   && newAgreement.APTS_Integration_Status__c != 'Sent' && newAgreement.APTS_MSPA_From_Quote__c == 'Without Changes' ) )
                {
           
                    //agreementsToProcess.put(newAgreement.Id, newAgreement);
                    newAgreement.APTS_Integration_Status__c = 'Sent';
                }
                
                //system.debug('#### In Update - new status #### '+newAgreement.APTS_Integration_Status__c +' #### '+newAgreement.Apttus__Status__c);
            }
            
           
        }
     }
    
    public void OnAfterUpdate(Map<Id,Apttus__APTS_Agreement__c> mapOldAgreement, Map<Id,Apttus__APTS_Agreement__c> mapNewAgreement){
        
        Map<Id,Apttus__APTS_Agreement__c> mapAgreement = APTS_LP_CommonUtil.isApplicableFOrLP(mapNewAgreement);
        Map<Id,Apttus__APTS_Agreement__c> agreementsToProcess = new Map<Id,Apttus__APTS_Agreement__c>();
        
        //Because I can see queries in loop; This would not worlk on bulk
        
        if(Trigger.size == 1){
            
            for(Apttus__APTS_Agreement__c newAgreement : mapAgreement.values()){
                
                if ((newAgreement.Apttus__Status__c == APTS_Constants.STATUS_APPROVED_ACTION_REQ && newAgreement.APTS_Integration_Status__c == 'Sent' 
                && newAgreement.Apttus_CMConfig__ConfigurationFinalizedDate__c !=  mapOldAgreement.get(newAgreement.Id).Apttus_CMConfig__ConfigurationFinalizedDate__c) || 
                   (newAgreement.Apttus__Status__c == APTS_Constants.STATUS_APPROVED_ACTION_REQ && mapOldAgreement.get(newAgreement.Id).Apttus__Status__c == 'Approval In Progress'
                   && newAgreement.APTS_Integration_Status__c == 'Sent') || (newAgreement.Apttus__Status__c == APTS_Constants.STATUS_APPROVED_ACTION_REQ && newAgreement.APTS_Related_Quotation_Status__c == 'Approved' 
                   && newAgreement.APTS_Integration_Status__c == 'Sent')){
                   
                    agreementsToProcess.put(newAgreement.Id, newAgreement);
                }
            }
            
            if(agreementsToProcess.size() > 0){
                APTS_AgreementTriggerHelper.CreateMSPAInSAP(mapOldAgreement, agreementsToProcess);
            }
        }
       
    }
}