/*************************************************************
@Name: APTS_MaxCriticalDiscountController
@Author: Rushabh Acharya
@CreateDate: 27th Nov 2015
@Description: This class is to get Agreement Line Item with maximum critical discount 
@UsedBy: Used by a VF component 'APTS_MaxCriticalDiscountComponent'
******************************************************************/



public with sharing class APTS_MaxCriticalDiscountController{

    public Apttus__APTS_Agreement__c agrmntSO {get;set;}
    
    public APTS_MaxCriticalDiscountController(){
        
    }
    
    public String getAgreementUrl() {
        String pageURL = '';
        Apttus_Proposal__ProposalSystemProperties__c proposalSystemProperties = Apttus_Proposal__ProposalSystemProperties__c.getValues('System Properties');
        if(proposalSystemProperties != null && proposalSystemProperties.Apttus_Proposal__InstanceUrl__c != null) {
            pageURL = proposalSystemProperties.Apttus_Proposal__InstanceUrl__c + '/' + agrmntSO.Id;
        }
        PageReference pageRef = new PageReference(pageURL);
        
        return pageRef.getUrl();
    }
    
    public Apttus__AgreementLineItem__c getAgreementLI(){
    
       List<Apttus__AgreementLineItem__c> listOfAgrLI = [SELECT Apttus_CMConfig__LineNumber__c,
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
                                                 WHERE Apttus__AgreementId__c = :agrmntSO.Id 
                                                 AND 
                                                 APTS_Is_Critical_Discount__c = True];
           
           if(listOfAgrLI.size()>0){
               return listOfAgrLI.get(0);
           }
           else{
               return null;
           } 
       /*    if(null != agrLI){
               displayTable = true;
           }
           else{
               displayTable = false;
           }      */
            
                                               
    }

}