/**
    @Author Rajesh K
    @name MassUncheckforNPSclass
    @CreateDate 6-Jan-2015
    @Version 1.0
    **/
global class MassUncheckforNPSclass
{
    /*  Description of the method. 
    *  @name massUnchecker
    *  @Description - Mass uncheck for Applicable for NPS Survey field.
    *  @return String
    */
   webservice static String massUnchecker(List<id> leadids) 
    { 
        List<Lead> lstLead = [SELECT NPS_ID__c, Applicable_for_NPS_Survey__c from Lead where id IN:leadids];
        List<Lead> lstupdLead = new List<Lead>();
        Boolean check = false;        
        for(Lead objlead: lstLead){
            if(objlead.NPS_ID__c != null || objlead.Applicable_for_NPS_Survey__c == false){
                check = true;
            }
        }
        if(check == true){
            return 'No';
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Selected lists of Leads cannot be unchecked.'));
            //return null;
        }else{
            for(Lead objlead: lstLead){
                if(objlead.NPS_ID__c == null && objlead.Applicable_for_NPS_Survey__c == true){
                    lstupdLead.add(new Lead(id = objlead.id, Applicable_for_NPS_Survey__c = false));
                }
            }
            if(lstupdLead.size()>0){
                Database.update(lstupdLead, false);
            }
            return 'Yes';
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Mass disable has been completed.'));
            //return null;
        }
        return 'No';
    }
}