/*   
    * Controller : SSendToNPSListController
    * Release R5
    * @author  (Rajesh Perumal)
    * @created  09-12-2015
    */ 
public with sharing class SendToNPSListController {
    List<String> leadids = new List<String>();
    public SendToNPSListController(ApexPages.StandardController controller) {
    leadids = ApexPages.currentPage().getParameters().get('lrecs').split(',',-2);
    }
    /* Method: validator
        * Release R5
        *Description : validating the records 
        */
    public pagereference validator(){
       List<Lead> lstLead = [SELECT NPS_Survey_Status__c, NPS_Ready__c from Lead where id IN:leadids LIMIT 1];
        List<Lead> lstupdLead = new List<Lead>();
        Boolean check = false;
        String npsparam = null;
        for(Lead objlead: lstLead){
            if(objlead.NPS_Survey_Status__c != null || objlead.NPS_Ready__c == false){
                check = true;
            }
        }
        if(check == true){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Qualified lead(s) for NPS Survey.'));
            return null;
        }else{          
            npsparam = '{';
            for(Lead objlead: lstLead){
                npsparam = npsparam + '\"Leadid\": \"'+ objlead.id +'\",';
                lstupdLead.add(new Lead(id = objlead.id, NPS_Survey_Status__c = 'Request Sent to NPS'));
            }
            npsparam = npsparam + '}';            
            List<Database.SaveResult> updateResults = Database.update(lstupdLead, false);
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Survey request sent to NPS Successfully for selected lead(s).'));
            //return npsparam here to NPS.
            return null;
        }
        return null;
    }
    /*  Method : back
        * Release R5
        *
        */
    public PageReference back(){   
        Schema.DescribeSObjectResult anySObjectSchema = Lead.SObjectType.getDescribe();
        String objectIdPrefix = anySObjectSchema.getKeyPrefix();
        PageReference pageReference = new PageReference('/'+objectIdPrefix+'/o');
        pageReference.setRedirect(true);
        return pageReference;
    }
}