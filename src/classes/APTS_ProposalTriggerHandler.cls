/*************************************************************
@Name: APTS_ProposalTriggerHandler
@Author: Hardik Shah
@CreateDate: 02/09/2015
@Description: Handler class for Trigger on Proposal Object.
@UsedBy: Trigger APTS_ProposalTrigger
******************************************************************
@ModifiedBy: Kruti Shah
@ModifiedDate: 10/09/2015
@ChangeDescription: Added another method call GetAvailableDiscounts for Req# 83
******************************************************************
@ModifiedBy: Nishi Kushwaha
@ModifiedDate: 14/09/2015
@ChangeDescription: Added another method call CreateEmptyCart when Product Configuration checkbox is checked.
******************************************************************
@ModifiedBy: Shahid Ali
@ModifiedDate: 04/11/2015
@ChangeDescription: Added call to method call syncQuoteOnFinDateChange from helper class.
******************************************************************/

public class APTS_ProposalTriggerHandler {
    
    private static Boolean isMSPARefIDFetched = false;
    
    public void onBeforeInsert(List<Apttus_Proposal__Proposal__c> listProposal){
       
        List<Apttus_Proposal__Proposal__c> listProposalForLPSpain = APTS_LP_CommonUtil.isProposalApplicableFOrLP(listProposal);
        
        if(listProposalForLPSpain.size() > 0){ 
            // auto populates MSPA Ref Number on Proposal
            APTS_ProposalTriggerHelper.autopopulateMSPARefNumber(listProposalForLPSpain);
            // auto Populate Primary Partner Account related to Opportunity
            APTS_ProposalTriggerHelper.autopopulatePrimaryPartnerCustomer(listProposalForLPSpain);
            // auto populate Account Customer on Account (OOB) field and Proposal Expiration Date on Valid Until Date
            // Commented on 15 Dec'15 as a part of fix for UAT issue # 2291
            //APTS_ProposalTriggerHelper.populateAccountCustomerAndExpirationDate(listProposalForLPSpain);
            // Set sales office code
            APTS_ProposalTriggerHelper.setSalesOfficeCode(listProposalForLPSpain);
            // Locale's Field value will be autopopulate based on User's locale or organization locale
            APTS_ProposalTriggerHelper.autoPopulateDefaultValues(listProposalForLPSpain);
            
            
        }else{
            //TODO - Replace system.debug with logging framework
            system.debug('Proposal is not LP Specific');
        }
    }
    
    public void onAfterInsert(List<Apttus_Proposal__Proposal__c> listProposal){
        
        List<Apttus_Proposal__Proposal__c> listProposalForLPSpain = APTS_LP_CommonUtil.isProposalApplicableFOrLP(listProposal);
        
        if(listProposalForLPSpain.size() > 0){ 
            // Added as part of R3.1 as needed to Share access of opportunity and place holder quote with opportunity team 
            APTS_ProposalTriggerHelper.shareAccesswithOpportunityTeam(listProposalForLPSpain);
        }else{
            //TODO - Replace system.debug with logging framework
            system.debug('Proposal is not LP Specific');
        }
        
    }
    
    
  
    /*
    @Addedby: Nishi Kushwaha
    @Method: calls a method CreateEmptyCart when Product Configuration checkbox is checked.
    @param:Quotations
    */
    public void OnBeforeUpdate(Map<Id,Apttus_Proposal__Proposal__c> mapOldProposal,Map<Id,Apttus_Proposal__Proposal__c> mapNewProposal){
        
        Map<Id,Apttus_Proposal__Proposal__c> mapProposalForLPSpain = APTS_LP_CommonUtil.isProposalApplicableFOrLP(mapNewProposal);
        
        if(mapProposalForLPSpain.size() > 0){
            
            
            APTS_ProposalTriggerHelper.readOnlyQuotationValidation(mapOldProposal, mapNewProposal);
            
            // Validate Input - Commented by JS as this is the wrong place to check this. - 10-Nov-2015
            //APTS_ProposalTriggerHelper.validateQuotationData(mapOldProposal,mapNewProposal);
            
            // automate PriceList when Proposal is created
            APTS_ProposalTriggerHelper.automatePriceListonProposal(mapProposalForLPSpain.values());
            // auto Populate Primary Partner Account related to Opportunity
            APTS_ProposalTriggerHelper.autopopulatePrimaryPartnerCustomer(mapProposalForLPSpain.values());
            // auto populate Account Customer on Account (OOB) field and Proposal Expiration Date on Valid Until Date
            // Commented on 15 Dec'15 as a part of fix for UAT issue # 2291
            //APTS_ProposalTriggerHelper.populateAccountCustomerAndExpirationDate(mapProposalForLPSpain.values());
            //Added By Kruti Shah           
            //This method will populate agreement header field(like ProductDiscounts, HierarchyDiscounts,Hierarchylevel)
            APTS_ProposalTriggerHelper.GetAvailableDiscounts(mapProposalForLPSpain);
            
            //Axay - commented below method call- AS per Nishi it is not being used
            // Create Configuration when "Product Configuration" field in MSPA is True
            //APTS_ProposalTriggerHelper.createEmptyCart(mapOldProposal,mapProposalForLPSpain);
            
            /* Commented by Axay for ABBLP-308 - as per subbu's suggestion - as Max Order Amount will be manualy entered by user & hence we dont need this to auto-populated
            // Max order amount on quotations need to be a copy Amount (Roll up Summary of Proposal Line Item: Total Quote Price) Field 
            APTS_ProposalTriggerHelper.autoPopulateMaxOrderAmount(mapOldProposal,mapProposalForLPSpain);
            */
            // Set SAP Customer Id on Change in Fields like Distribution Channel, Local Channel, Incoterm, Payment Term.
            APTS_ProposalTriggerHelper.setSAPIdOnChangeInQuoteFields(mapOldProposal,mapNewProposal);
            
            // Set defaulf values on Quotation
            APTS_ProposalTriggerHelper.populateFieldsOnQuote(mapNewProposal);
            
        
        }else{
              //TODO - Replace system.debug with logging framework
            system.debug('Proposal is not LP Specific');
        }
         
    }
}