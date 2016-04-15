/*************************************************************
@Name: APTS_MSPAWithoutChangesController
@Author: Nishi Kushwaha
@CreateDate: 29/08/2015
@Description: This controller Updates the value of Field "MSPA without Changes" on Quotation Object based on the flag passed as parameter.
@UsedBy: Page APTS_MSPAWithoutChangesPage
******************************************************************/

public class APTS_MSPAWithoutChangesController {
    
    Id quotationId{get;set;}
    String sFlag{get;set;}
    String sFromScratch{get;set;}

    public APTS_MSPAWithoutChangesController(){
        
        quotationID = ApexPages.currentPage().getParameters().get('Id');
        sFlag = ApexPages.currentPage().getParameters().get('Flag');
        sFromScratch = ApexPages.currentPage().getParameters().get('NewMSPAOnly');
    }
    
    public pageReference createMSPAWithoutChanges(){
    
        Apttus_Proposal__Proposal__c oProposal = [Select Id,APTS_MSPA_From_Quote__c from Apttus_Proposal__Proposal__c where Id =: quotationID] ;
        PageReference pageRef;
        
        if(String.isNotBlank(sFromScratch) && sFromScratch=='true' ){
            pageRef = new PageReference('/apex/Apttus_Proposal__ProposalAgreementCreate?id=' + quotationId);
        }else{
            if(sFlag == 'true'){
                oProposal.APTS_MSPA_From_Quote__c = 'Without Changes';
                oProposal.APTS_MSPA_without_Changes__c = TRUE;
                update oProposal;
            }else {
                oProposal.APTS_MSPA_From_Quote__c = 'With Changes';
                oProposal.APTS_MSPA_without_Changes__c = FALSE;
                oProposal.APTS_Is_MSPA_Created_Non_Buying_Qoute__c  = true;
            }
            pageRef = new PageReference('/apex/Apttus_QPComply__ProposalAgreementCreate?id=' + quotationId+'&flag=true');
        }
        
        //Setting the flag to true so that multiple MSPA cannot be created from same quote
        oProposal.APTS_Is_MSPA_Created_Non_Buying_Qoute__c  = true;
        update oProposal;
        //PageReference pageRef = new PageReference('/apex/Apttus_QPComply__ProposalAgreementCreate?id=' + quotationId+'&flag=true');
        pageRef.setRedirect(true);
        
        return pageRef;
    }
}