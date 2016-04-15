/*************************************************************
@Name: APTS_SaveAndExitCartController
@Author: Shahid Ali
@CreateDate: 12th Nov 2015.
@Description: This class is serves as controller for APTS_SaveAndExitCartPage. Redirects the user after finalizing cart.
@UsedBy: APTS_SaveAndExitCartPage
******************************************************************/
   
  public with sharing class APTS_SaveAndExitCartController{
      //Variable to store current config sObject
      private Apttus_Config2__ProductConfiguration__c currentConfigSO;
      //Variable to store current config ID
      private String configID;
      
    public APTS_SaveAndExitCartController(){
          //get configuration Id          
          configID=Apexpages.Currentpage().getparameters().get('Id');
    }      
    public pagereference syncwithOppportunity(){
        //Get quote Id from current cart ID
        List<Apttus_Config2__ProductConfiguration__c> listConfig = [SELECT Id,Name,Apttus_QPConfig__Proposald__c, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__c,Apttus_Config2__Status__c 
                                                                    FROM   Apttus_Config2__ProductConfiguration__c 
                                                                    WHERE  Id =: configID  limit 1];
        
        if(listConfig != null && !listConfig.isEmpty()){
            currentConfigSO = listConfig[0];
        }
        
        if(currentConfigSO != null){
            Apttus_Config2__ProductConfiguration__c supersededconfig;
            //get quote id
            Id quoteId = currentConfigSO.Apttus_QPConfig__Proposald__c;
            //get oppty id
            Id opptyId = currentConfigSO.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__c;
            
            for (Apttus_Config2__ProductConfiguration__c sConfig : [select Id,Name,Apttus_QPConfig__Proposald__c,Apttus_Config2__Status__c from  Apttus_Config2__ProductConfiguration__c where Apttus_Config2__Status__c='Finalized' AND Apttus_QPConfig__Proposald__c=:QuoteId limit 1]){
            supersededconfig = sConfig;
            }
            
            if(supersededconfig<>null){
            supersededconfig.Apttus_Config2__Status__c='Superseded';
            update supersededconfig;
            }
            
            //webservice api call to finalize the cart
            Apttus_CPQApi.CPQ.FinalizeCartRequestDO request = new Apttus_CPQApi.CPQ.FinalizeCartRequestDO();
            request.CartId= ConfigId;
            Apttus_CPQApi.CPQ.FinalizeCartResponseDO result = Apttus_CPQApi.CPQWebService.finalizeCart(request);
            boolean success=result.IsSuccess;
            success=Apttus_QPConfig.QPConfigWebService.syncWithOpportunity(QuoteId,false);
            //redirect to quote page
            pagereference page=new pagereference('/'+opptyId);
            
            if(success){
            return page;
            }
        }
            return null;
        }
  }