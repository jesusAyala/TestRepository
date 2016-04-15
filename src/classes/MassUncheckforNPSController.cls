/*  Description of the method. 
    *  @name MassUncheckforNPSController
    *  @Author  Rajesh K
    *  @Description - Mass uncheck the leads for NPS.
    *  @return nothing
    */
public with sharing class MassUncheckforNPSController {   
    List<String> leadids = new List<String>();
    /*  Description of the method. 
    *  @name MassUncheckforNPSController
    *  @Description - Constructor
    */
    public MassUncheckforNPSController(ApexPages.StandardController controller) {
        leadids = ApexPages.currentPage().getParameters().get(System.label.INTEG_SYS_MassUncheck_Param).split(',',-2);  //lrecs
    }
    /*  Description of the method. 
    *  @name validator
    *  @Description - Validating the leads and uncheck.
    *  @return Pagereference
    */
    public pagereference validator(){
        List<Lead> lstLead = [SELECT NPS_Survey_Status__c, Applicable_for_NPS_Survey__c from Lead where id IN:leadids LIMIT 50000];
        List<Lead> lstupdLead = new List<Lead>();
        Boolean check = false;        
        for(Lead objlead: lstLead){
            if(objlead.NPS_Survey_Status__c != null || objlead.Applicable_for_NPS_Survey__c == false){
                check = true;
            }
        }
        if(check == true){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.label.INTEG_SYS_MassUncheck_Error1));  //'Selected lists of Leads cannot be unchecked.'
            return null;
        }else{
            for(Lead objlead: lstLead){
                if(objlead.NPS_Survey_Status__c == null || objlead.Applicable_for_NPS_Survey__c == true){
                    lstupdLead.add(new Lead(id = objlead.id, Applicable_for_NPS_Survey__c = false));
                }
            }
            if(lstupdLead.size()>0){
                Database.update(lstupdLead, false);
            }
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, System.label.INTEG_SYS_MassUncheck_Error2));     //'Mass disable has been completed.'
            return null;
        }
        return null;
    }
    /*  Description of the method. 
    *  @name back
    *  @Description - back to actual page.
    *  @return Pagereference
    */
    public PageReference back(){   
        Schema.DescribeSObjectResult anySObjectSchema = Lead.SObjectType.getDescribe();
        String objectIdPrefix = anySObjectSchema.getKeyPrefix();
        PageReference pageReference = new PageReference(System.label.INTEG_SYS_MassUncheck_Url1 + objectIdPrefix + System.label.INTEG_SYS_MassUncheck_Url2);
        pageReference.setRedirect(true);
        return pageReference;
    }
}