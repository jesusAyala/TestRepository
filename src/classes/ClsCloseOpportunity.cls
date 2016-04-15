/**
    @Author Shankaranarayanan V
    @name ClsCloseOpportunity
    @CreateDate 1/22/2016
    @Description To close an Opportunity
    @Version 1.0
    **/
public class ClsCloseOpportunity
{
    ID oppId;
    boolean flag = false;
/**
* Constructor
*/    
    public ClsCloseOpportunity(ApexPages.StandardController controller)
    {
    oppId= ApexPages.currentPage().getParameters().get(Label.System_CL00018);  //Label.System_CL00018 => id
    }
/**
* Method updateRecordType
* To close an Opportunity
*/ 
    public pagereference updateRecordType(){

    Id closeOpportunityId= Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Close Opportunity').getRecordTypeId();
    List<Opportunity> oppUpdateList = new List<Opportunity>();
    Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
    Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([Select id, Name, Opportunity_RecordType__c, RecordTypeId,Opportunity_Value__c, CloseDate, Actual_Bid_Submission_Date_Tech__c, Actual_Bid_Submission_Date_Comm__c, 
                    Requested_Bid_Submission_Date_Tech__c, Requested_Bid_Submission_Date_Comm__c, StageName from Opportunity where id=:oppId LIMIT :remLimit]);

    for(Opportunity opp:oppMap.values())
    {    
        if( opp.StageName != 'Closed Lost' && opp.StageName != 'Closed Won')
        { 
            opp.RecordTypeId = closeOpportunityId;
            opp.Is_Cancelled__c = true;
            oppUpdateList.add(opp);
            flag = true;
        }
    }
    
    if(oppUpdateList.size()>0)
    {
        try{
        if(flag==true)
        {
        database.update(oppUpdateList); 
        Pagereference pageref = new Pagereference('/'+oppId+'/e?retURL=/'+oppId+'&saveURL=/'+oppId);
        return pageref;         
        }
        }
        
        catch(DmlException exc){
        }
    }
    if(flag==false)
        {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'The Opportunity cannot be closed since it is already closed.'));
        }
    return null;
    }
    
  
}