/*************************************************************
@Name: APTS_SaveDraftCartController
@Author: Shahid Ali
@CreateDate: 27th Nov 2015.
@Description: This class is serves as controller for APTS_SaveDraftPage. Save the cart without triggering approvals etc.
@UsedBy: APTS_SaveDraftPage
******************************************************************/
   
  public with sharing class APTS_SaveDraftCartController{
      //Variable to store current config sObject
      private Apttus_Config2__ProductConfiguration__c currentConfigSO;
      //Variable to store current config ID
      private String configID;
      //Variable to store quote/proposal record
      private Apttus_Proposal__Proposal__c quoteProposalSO;
      //Variable to store agreement SO
      private Apttus__APTS_Agreement__c agreementSO;
      
    public APTS_SaveDraftCartController(){
          //get configuration Id          
          configID=Apexpages.Currentpage().getparameters().get('Id');
    }   
    
    /* Method to save draft quote */
    public pagereference saveDraftMethod(){
        //Get quote Id from current cart ID
        List<Apttus_Config2__ProductConfiguration__c> listConfig = [SELECT Id,Name,Apttus_QPConfig__Proposald__c, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__c,Apttus_Config2__Status__c
                                                                           ,Apttus_CMConfig__AgreementId__c
                                                                    FROM   Apttus_Config2__ProductConfiguration__c 
                                                                    WHERE  Id =: configID  limit 1];
        if(listConfig != null && !listConfig.isEmpty()){
            currentConfigSO = listConfig[0];
        }
        
        if(currentConfigSO != null){
            //get quote id
            Id quoteId = currentConfigSO.Apttus_QPConfig__Proposald__c;
            //get oppty id
            Id opptyId = currentConfigSO.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__c;
            //Boolean success
            Boolean success = false;
            if(currentConfigSO.Apttus_QPConfig__Proposald__c != null){   
                for (Apttus_Proposal__Proposal__c qProposal : [SELECT Id,Name,Apttus_QPConfig__ConfigurationFinalizedDate__c,APTS_Is_Placeholder_Quote__c
                                               FROM  Apttus_Proposal__Proposal__c 
                                               WHERE Id =: currentConfigSO.Apttus_QPConfig__Proposald__c]){
                    quoteProposalSO = qProposal;
                }
                
            }
            
            if(currentConfigSO.Apttus_CMConfig__AgreementId__c != null){
                for (Apttus__APTS_Agreement__c agreement : [SELECT Id,Name,Apttus_CMConfig__ConfigurationFinalizedDate__c 
                                                                FROM  Apttus__APTS_Agreement__c 
                                                                WHERE Id =: currentConfigSO.Apttus_CMConfig__AgreementId__c]){
                    agreementSO = agreement;
                }
            }

            
            if(quoteProposalSO != null){
                quoteProposalSO.Apttus_QPConfig__ConfigurationFinalizedDate__c = null;
                try{
                    update quoteProposalSO;
                    success = true;
                }catch(Exception ex){
                    success = false;
                }
            }
            
            if(agreementSO != null){
                agreementSO.Apttus_CMConfig__ConfigurationFinalizedDate__c = null;
                try{
                    update agreementSO;
                    success = true;
                }catch(Exception ex){
                    success = false;
                }
            }
            
            if(currentConfigSO != null){
                currentConfigSO.Apttus_Config2__Status__c = 'Saved';
                try{
                    update currentConfigSO;
                    success = true;
                }catch(Exception ex){
                    success = false;
                }
            }
            
            //redirect to quote page
            pagereference page;
            if(agreementSO != null){
                page=new pagereference('/'+agreementSO.Id);
            }else if(quoteProposalSO != null){
                   //added by Ganga as part of place holder quote implementation.
                   if(!quoteProposalSO.APTS_Is_Placeholder_Quote__c){
                      page=new pagereference('/'+quoteId);
                   }else{
                      page=new pagereference('/'+opptyId);
                   }
            }
            
            
            if(success){
                return page;
            }
        }
            return null;
        }
  }