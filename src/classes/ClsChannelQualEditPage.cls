/**
 * Apex Class -  ClsChannelQualEditPage
 * Controller for Vf page - ChannelQualEditPage
 * Class used to redirect the edit page of Channel Pre Qualification. 
 * 
 * Release R5
 * @author  Abiramasundari Radha (Accenture)
 * @created 2015-12-16
 * @version 1.0
 * Created
 */
public with sharing class ClsChannelQualEditPage{
 /**
 * Constructor
 */   
    public ClsChannelQualEditPage(ApexPages.StandardController controller) {    
    }
 /**
 * Constructor
 */   
    public ClsChannelQualEditPage(){}
 /**
 * Method editPageChange
 * Class used to redirect the edit page of Channel Pre Qualification. 
 */   
    public pagereference editPageChange(){
        String redirectRecordTypeId=Label.Channel_Qualification_RecordTypeId;
        Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
        String recordId = Apexpages.currentPage().getParameters().get(Label.ApexClass_id ); // Label.ApexClass_id ='Id'
        List<Channel_Qualifications__c> ListCQ = [select id,RecordType.Name from Channel_Qualifications__c where id =:recordId LIMIT :remLimit];  
        //System.debug('***********'+ListCQ[0].RecordType.Name +'***********');   
        PageReference pageRef = new PageReference(Label.System_CL00020+recordId +Label.CBR_EditPage_URL+redirectRecordTypeId+Label.System_CL0017_R4+recordId+Label.CBR_EditPage_URL1); 
        return pageRef;
    }   
    
/*    public pagereference copyAccountTeamMember(){
    return null;
    } */
}