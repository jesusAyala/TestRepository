/*************************************************************
@Name: APTPS_CustomApprovalController
@Author: Rushabh Acharya
@CreateDate: 4th Nov 2015
@Description: This class is to get Proposal Line Items for a specific quote 
@UsedBy: Used by a VF component 'APTPS_CustomApprovalComponent'
******************************************************************/

global class APTPS_CustomApprovalController{

    Public String ProposalId{get; set;}
    Public String RequestID{get;set;}
    Public String proposalName {get;set;}
    public List<Apttus_Proposal__Proposal_Line_Item__c> lstPropLI = new List<Apttus_Proposal__Proposal_Line_Item__c>();
    public String propURL;
    public String currCode {get; set;}
    public String percentage {get;set;}
    
    public APTPS_CustomApprovalController(){
        percentage = '%';
    }
    
    
    /*    
    public String GetcurrencyCode(){
    
        Apttus_Proposal__Proposal__c propSO = [SELECT CurrencyIsoCode
                                              from Apttus_Proposal__Proposal__c
                                              WHERE Id = :ProposalId LIMIT 1];
        return  propSO.CurrencyIsoCode;                                                     
    }*/
        
    /*
    @Method : Fetch all Proposal Line Items
    @Used By : Component - 'APTPS_CustomApprovalComponent'
    */
    public List<Apttus_Proposal__Proposal_Line_Item__c> GetlstPropLI(){
    
        lstPropLI = [SELECT Apttus_QPConfig__LineNumber__c,
                       APTS_Product_Hierarchy_Code__c,
                       APTS_Product_Hierarchy_Information__c,
                       APTS_new_product_code__c,
                       APTS_Standard_Discount_Format__c,
                       APTS_Hierarchy_Name__c,
                       APTS_LP_Standard_Discount__c,
                       APTS_LP_Standard_Net__c,
                       APTS_Local_Product_Code__c,
                       APTS_Product_Description__c,
                       Apttus_QPConfig__Quantity2__c,
                       Apttus_QPConfig__BasePrice__c,
                       APTS_Discount_Type__c,
                       APTS_Net_Adjustment__c,
                       APTS_Net_Price_Override__c,
                       Apttus_QPConfig__NetPrice__c,
                       APTS_Net_Adjustment_Percentage__c,
                       APTS_LP_Total_Standard_Price__c,
                       APTS_LP_Unit_Of_Price__c,
                       APTS_LP_Unit_Of_Measure__c,
                       APTS_Discount_Percentage__c,
                       Apttus_QPConfig__NetAdjustmentPercent__c,
                       APTS_Total_Quote_Price__c
                       FROM Apttus_Proposal__Proposal_Line_Item__c
                       WHERE Apttus_Proposal__Proposal__c = :ProposalId ];
        
                     
        return lstPropLI ;
    
    }
    
    
    
    /*
    @Method : Fetch URL of Proposal to be used in Approval mail
    @Used By : Component - 'APTPS_CustomApprovalComponent'
    */
    public String GetPropURL(){
    
        String pageURL = '';
        Apttus_Proposal__ProposalSystemProperties__c proposalSystemProperties = Apttus_Proposal__ProposalSystemProperties__c.getValues('System Properties');
        if(proposalSystemProperties != null && proposalSystemProperties.Apttus_Proposal__InstanceUrl__c != null) {
            pageURL = proposalSystemProperties.Apttus_Proposal__InstanceUrl__c + '/' + ProposalId;
        }
        
        PageReference pageRef = new PageReference(pageURL);
        
        return pageRef.getUrl();
    }
    
    
    
}