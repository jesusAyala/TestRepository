/**
    @Author Rajesh K
    @name SendCaseToCCRPClass
    @CreateDate 6-Jan-2015
    @Version 1.0
    **/
global class SendCaseToCCRPClass
{
    /*  Description of the method. 
    *  @name sendtoCCRP
    *  @Description - Send case to CCRP.
    *  @return String
    */
    webservice static String sendtoCCRP(Id caseid) 
    { 
        Id complaintRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Complaint').getRecordTypeId();
        Case objcase = [Select AccountId,Account.Name, Owner_Type__c, Contact.Name, ContactId, OwnerId, Description, Category_2__c, CCRP_Status__c, RecordtypeId from Case where id=:caseid];
        if(objcase.AccountId != null && objcase.ContactId != null && objcase.Description != null
           && objcase.Category_2__c.equalsIgnoreCase('Complaints') && objcase.CCRP_Status__c == null
           && objcase.RecordtypeId != complaintRecTypeId && objcase.Owner_Type__c == 'User')
        {
            //Values send to CCRP here
             List<Case> lstcase = new List<Case>();
            lstcase.add(new Case(id = caseId, RecordtypeId = complaintRecTypeId, Status = 'Under Investigation'));
            Database.update(lstcase, false);
            
            return 'Yes';
        }  
       else
        {
            return 'No';
        }
    }    
}