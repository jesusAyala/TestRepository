/*************************************************************
@Name: APTPS_AgreementApprovalController
@Author: Rushabh Acharya
@CreateDate: 5th Nov 2015
@Description: This class is to get Agreement Line Items for a specific quote 
@UsedBy: Used by a VF component 'APTPS_AgreementApprovalComponent'
******************************************************************/

global class APTPS_AgreementApprovalController{

    Public String agrmntId{get; set;}
    Public String requestID{get;set;}
    Public String agrmntName {get;set;}
    public List<Apttus__AgreementLineItem__c> lstAgrLI = new List<Apttus__AgreementLineItem__c>();
    public String agrmntURL;
    public String currCode {get; set;}
    public String percentage {get;set;}

    public APTPS_AgreementApprovalController(){
        percentage = '%';
    }
    
    /*
    @Method : Fetch all Agreement Line Items
    @Used By : Component - 'APTPS_AgreementApprovalComponent'
    */
    public List<Apttus__AgreementLineItem__c> GetlstAgrLI(){
    
        lstAgrLI =     [SELECT Apttus_CMConfig__LineNumber__c,
                       APTS_LP_Product_Hierarchy_Code__c,
                       APTS_Product_Hierarchy_Information__c,
                       APTS_new_product_code__c,
                       APTS_Product_Name__c,
                       APTS_LP_Hierarchy_Name__c,
                       APTS_Product_Code__c,
                       APTS_Product_Description__c,
                       APTS_Standard_Discount_Format__c,
                       APTS_Quantity__c,
                       Apttus_CMConfig__BasePrice__c,
                       APTS_LP_Standard_Discount__c,
                       APTS_LP_Standard_Net__c,
                       APTS_Net_Adjustment_Percentage__c,
                       APTS_Discount_Type__c,
                       APTS_Net_Price_Override__c,
                       Apttus__NetPrice__c,
                       APTS_LP_Total_Standard_Price__c,
                       APTS_LP_Unit_Of_Measure__c,
                       APTS_LP_Unit_Of_Price__c,
                       APTS_Discount_Percentage__c,
                       Apttus_CMConfig__NetAdjustmentPercent__c,
                       APTS_Total_Quote_Price__c
                       FROM Apttus__AgreementLineItem__c
                       WHERE Apttus__AgreementId__c = :agrmntId LIMIT :APTS_Constants.SELECT_SOQL_LIMIT];
        
                     
        return lstAgrLI ;
    
    }
    
    
    /*
    @Method : Fetch URL of Agreement to be used in Approval mail
    @Used By : Component - APTPS_AgreementApprovalComponent
    */
    public String GetAgrURL(){
    
        String pageURL = '';
        Apttus_Proposal__ProposalSystemProperties__c proposalSystemProperties = Apttus_Proposal__ProposalSystemProperties__c.getValues('System Properties');
        if(proposalSystemProperties != null && proposalSystemProperties.Apttus_Proposal__InstanceUrl__c != null) {
            pageURL = proposalSystemProperties.Apttus_Proposal__InstanceUrl__c + '/' + agrmntId;
        }
        
        PageReference pageRef = new PageReference(pageURL);
        
        return pageRef.getUrl();
    }

}