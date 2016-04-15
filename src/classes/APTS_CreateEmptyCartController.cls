public class APTS_CreateEmptyCartController {
    
    public Id objectId{get; set;}
    public String sObjectName{get; set;}
    public Boolean bHasError{get;set;}
    
    public APTS_CreateEmptyCartController() {
        
        objectId = ApexPages.currentPage().getParameters().get('Id');
        sObjectName = ApexPages.currentPage().getParameters().get('sObject');
        this.bHasError = FALSE;
        
    }
    
    public pageReference createEmptyCart() {
        
        List<Apttus_Config2.Property> configProps = new List<Apttus_Config2.Property>();
        Apttus_Config2.Property prop = new Apttus_Config2.Property();
        prop.Name = APTS_Constants.PROPERTY_ADVANCE_APPROVAL;
        //Get the value from Custom Settings
        if(APTS_Custom_Cart_Settings__c.getValues('useAdvancedApproval') != null) {
            prop.Value = String.ValueOf(APTS_Custom_Cart_Settings__c.getValues('useAdvancedApproval').APTS_Value__c);
        }
        configProps.add(prop);
                       
        prop = new Apttus_Config2.Property();
        prop.Name = APTS_Constants.PROPERTY_DEAL_OPTIMIZER;
        //Get the value from Custom Settings
        if(APTS_Custom_Cart_Settings__c.getValues('useDealOptimizer') != null) {
            prop.Value = String.ValueOf(APTS_Custom_Cart_Settings__c.getValues('useDealOptimizer').APTS_Value__c);
        } 
        configProps.add(prop);
        PageReference pageRef;
        
        if(sObjectName == 'agreement') {
            
            try {
                Id configId = Apttus_CMConfig.CMConfigWebService.createConfigurationRequest(objectId,configProps);
                PageReference pf = Apttus_CMConfig.CMConfigWebService.startConfiguration(configId,configProps);
                pageRef = new PageReference('/apex/Apttus_XApps__EditInExcelLaunch?parentRecordId='+objectId+'&appName=MSPA Product Configuration');
                pageRef.setRedirect(true);
                       
            }catch(exception e) {
                       
                this.bHasError = true;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error Occurred. Please Contact your System Administrator');
                ApexPages.addMessage(myMsg);
                return null;
            }
        }
        
        return pageRef;
        
    }
    
    public pageReference goBack() {
        PageReference pageRef = new PageReference('/'+objectId);
        pageRef.setRedirect(true);
        return pageRef;
    }

}