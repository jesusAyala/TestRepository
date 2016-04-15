/*************************************************************
@Name: APTS_ApprovalSubmitController
@Author: Hardik Shah
@CreateDate: 07 Sep 2015
@Description: This class fetches Group-Name for Corresponding Agreement 
@UsedBy: VF-Page : APTS_ApprovalSubmit
******************************************************************
@ModifiedBy: NA
@ModifiedDate: NA
@ChangeDescription: A brief description of what was modified.
**** PS: @ModifiedBy and @ChangeDescription can be repeated multiple time, based on number of changes made to the original process.
******************************************************************/

public with sharing class APTS_ApprovalSubmitController {
    // Apttus Agreemet 
    public Apttus__APTS_Agreement__c agreement {
        get;
        set;
    }
    // Boolean variable to show error message on  VF page
    public Boolean bHasErrors {
        get;
        set;
    }
    public boolean bIsARMActive;
    public boolean bIsARMApprovalLevelsCorrect;
    public static final String MAX_APPROVAL_LEVELS = 'APTS_MaxApprovalRuleMatrixLevels';
    
    // Constructor to initialize agreement
    public APTS_ApprovalSubmitController(ApexPages.StandardController controller) {
        agreement = (Apttus__APTS_Agreement__c) controller.getrecord();
        
        agreement = [Select id,APTS_CH_AQ__c,APTS_LP_No_Approval_Rule_Matched__c,APTS_Sales_Office__c, APTS_Local_Channel__r.APTs_Code__c, APTS_GTV_Code__c,APTS_Approval_Required__c from Apttus__APTS_Agreement__c where id=:agreement.id];
        bHasErrors = false;
        bIsARMActive = false;
        bIsARMApprovalLevelsCorrect = true;
    }


    public pagereference onload() {
        // Check for Validity of Agreement and Agreement Values
        if (isValidAgreement(agreement)) {
           
            PageReference pageRef = Page.Apttus_Approval__ApprovalContextPreview;
            pageRef.getParameters().put('sObjectType', 'Apttus__APTS_Agreement__c');
            pageRef.getParameters().put('sObjectId', agreement.id);
            pageRef.getParameters().put('CancelPendingProcess', 'false');
            pageRef.setredirect(true);
            return pageRef;            
        } else {
            // Show Error Message
            if(agreement.APTS_LP_No_Approval_Rule_Matched__c || bIsARMActive==false){
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, Label.APTS_NO_APPROVAL_RULE_MATRIX));
            }else if(bIsARMActive ==true && bIsARMApprovalLevelsCorrect==false){
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, Label.APTS_ARM_APPROVAL_LEVELS_NOT_CORRECT));
            }else
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, Label.APTS_APPROVAL_PROCESS_ENTRY_CRITERIA));
            bHasErrors = true;
        }

        return null;
    }

    // This Method checks for Validity of Agreement and Agreement Values
    private Boolean isValidAgreement(Apttus__APTS_Agreement__c agr) {

        Boolean bValid = false;
        // Check for Agreement validation
        system.debug('@@ agr.APTS_Sales_Office__c :'+ agr.APTS_Sales_Office__c);
      //  system.debug('@@ agr.APTS_LP_Local_Channel__c :'+ agr.APTS_LP_Local_Channel__c);
        system.debug('@@ agr.APTS_GTV_Code__c :'+ agr.APTS_GTV_Code__c);
        system.debug('@@ agr.id :'+ agr.id);
        if (agr != null && agr.id != null && String.isNotBlank(agr.id)) {
            // Check for Agreement field Validation   
            if (((agr.APTS_Sales_Office__c != null && String.isNotBlank(agr.APTS_Sales_Office__c))

          //  && (agr.APTS_LP_Local_Channel__c != null && String.isNotBlank(agr.APTS_LP_Local_Channel__c))

            && (agr.APTS_GTV_Code__c != null && String.isNotBlank(agr.APTS_GTV_Code__c)))) {

                // added by chetan 02-12-2015 ,to check ARM active flag before submit
                // Also check for Approval levels in ARM are in correct sequence or not.
                List<APTS_Approval_Rule_Matrix__c> lstApprovalRuleMatrix = new List<APTS_Approval_Rule_Matrix__c>(); 
                lstApprovalRuleMatrix = [select id,APTS_Approval_Level__c from APTS_Approval_Rule_Matrix__c where APTS_Is_Active__c =true and APTS_CHF__c = :agr.APTS_CH_AQ__c];
                
                if(lstApprovalRuleMatrix != null && lstApprovalRuleMatrix.size()>0){
                    
                    bIsARMActive = true;
                    set<Decimal> setApprovalLevels = new set<Decimal>();
                    
                    for(APTS_Approval_Rule_Matrix__c rule :lstApprovalRuleMatrix){
                            setApprovalLevels.add(rule.APTS_Approval_Level__c);
                    }
                    if(lstApprovalRuleMatrix.size()!=setApprovalLevels.size()){
                        bIsARMApprovalLevelsCorrect=false;
                    }
                    /* Removing this else part due to R3.1 change in Approval Rule Matrix - Removal of place holder records 
                       By Chetan Patel Date : 31/12/2015
                    else{
                        
                        List<Apttus__APTS_Admin__c> lstAdmin = new List<Apttus__APTS_Admin__c>();
                        Decimal MaxARMsAllowed=0;
                        lstAdmin = [select id,Apttus__Value__c from Apttus__APTS_Admin__c where name=:MAX_APPROVAL_LEVELS LIMIT :APTS_Constants.SELECT_SOQL_LIMIT];
                        if(lstAdmin != null && lstAdmin.size()>0){
                            
                            MaxARMsAllowed = Decimal.valueOf(lstAdmin[0].Apttus__Value__c);
                        }
                        for(Decimal d=1;d<=MaxARMsAllowed;d++){
                            
                            if(!setApprovalLevels.contains(d))
                                bIsARMApprovalLevelsCorrect =false;
                        }
                    }
                    */
                        
                    if(bIsARMApprovalLevelsCorrect)
                        bValid = true;
                    
                }

            }
            
            system.debug('@@ bValid :'+ bValid);

        }
        return bValid;
    }
}