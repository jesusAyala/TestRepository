/*
@Name: APTS_EditAgreementSAPSettingsController
@Author: Chetan Patel
@CreateDate: 3rd Nov 2015
@Description: Extension class for APTS_EditAgreementSAPSettings VF page
              to show warning message to user before changing value
@UsedBy: Visualforce Page - APTS_EditAgreementSAPSettings
*/

public class APTS_EditAgreementSAPSettingsController {
    
    public String baseURL {get; set;}
    public String RecordId {get; set;}
    public APTS_Agreement_SAP_Setting__c record {get; set;}
    
    public APTS_EditAgreementSAPSettingsController(ApexPages.StandardController stdController){
        
        baseURL  = System.URL.getSalesforceBaseUrl().toExternalForm();
        RecordId = stdController.getId();
        record = [select id,Name,APTS_Country__c,APTS_Block_MSPA_Creation_In_SAP__c,APTS_Auto_Create_MSPA_In_SAP_On_Approval__c 
                  from APTS_Agreement_SAP_Setting__c
                  where id=:RecordId];
  
    }
    public PageReference init(){
        
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,Label.APTS_Agreement_SAP_Setting_Warning));
        return null;
    }
    
    public PageReference Save(){
        
        update record;
        String url  = baseURL + '/' +RecordId;
        system.debug('@@ url edit: '+ url);
        PageReference pgRef = new PageReference(url); 
        pgRef.setRedirect(true);
        
        return pgRef;
        
        
    }
    
    

}