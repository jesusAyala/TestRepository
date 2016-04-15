public class APTS_LocalCountryAdminConsoleController {
    
    public String discountsConfigKeyPrefix {get; set;}
    public String delegateApproverKeyPrefix {get; set;}
    public String templateKeyPrefix {get; set;}
    public String masterPicklistTableKeyPrefix {get; set;}
    public String approvalRuleMatrixKeyPrefix {get; set;}
    public String agreementSAPSettingKeyPrefix {get; set;}
    public String baseUrl {get; set;}
    
    public String discountsConfigURL {get; set;}
    public String delegateApproverURL {get; set;}
    public String templateURL {get; set;}
    public String masterPicklistTableURL {get; set;}
    public String approvalRuleMatrixURL {get; set;}
    public String agreementSAPSettingURL {get; set;}
    
    public APTS_LocalCountryAdminConsoleController(){
        
        
        try {
            baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
            
            Schema.DescribeSObjectResult r = APTS_Discounts_Config__c.sObjectType.getDescribe();
            discountsConfigKeyPrefix = r.getKeyPrefix();
            System.debug('Printing --'+discountsConfigKeyPrefix );
            
            Schema.DescribeSObjectResult r1 = Apttus_Approval__Backup_Approver__c.sObjectType.getDescribe();
            delegateApproverKeyPrefix = r1.getKeyPrefix();
            System.debug('Printing --'+delegateApproverKeyPrefix );
            
            Schema.DescribeSObjectResult r2 = Apttus__APTS_Template__c.sObjectType.getDescribe();
            templateKeyPrefix = r2.getKeyPrefix();
            System.debug('Printing --'+templateKeyPrefix );
            
            Schema.DescribeSObjectResult r3 = APTS_Master_Picklist_Table__c.sObjectType.getDescribe();
            masterPicklistTableKeyPrefix = r3.getKeyPrefix();
            System.debug('Printing --'+masterPicklistTableKeyPrefix );
            
            Schema.DescribeSObjectResult r4 = APTS_Approval_Rule_Matrix__c.sObjectType.getDescribe();
            approvalRuleMatrixKeyPrefix = r4.getKeyPrefix();
            System.debug('Printing --'+approvalRuleMatrixKeyPrefix );
            
            Schema.DescribeSObjectResult r5 = APTS_Agreement_SAP_Setting__c.sObjectType.getDescribe();
            agreementSAPSettingKeyPrefix = r5.getKeyPrefix();
            System.debug('Printing --'+approvalRuleMatrixKeyPrefix );
            
            
            discountsConfigURL      = baseUrl + '/' + discountsConfigKeyPrefix      ;
            delegateApproverURL     = baseUrl + '/' + delegateApproverKeyPrefix     ;
            templateURL             = baseUrl + '/' + templateKeyPrefix             ;
            masterPicklistTableURL  = baseUrl + '/' + masterPicklistTableKeyPrefix  ;
            approvalRuleMatrixURL   = baseUrl + '/' + approvalRuleMatrixKeyPrefix   ;
            agreementSAPSettingURL  = baseUrl + '/' + agreementSAPSettingKeyPrefix  ;
            
        }
        catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'An error occured while rendering this page. Please contact your administrator.'));
            System.debug('@@ The following exception has occurred: ' + e.getMessage());
        }
        
    }

}