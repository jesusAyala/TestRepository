/**
 * Apex Class -  ClsChannelBusinessReviewEditPage
 * Controller for Vf page - ChannelBusinessReviewEditPage
 * Class used to redirect the edit page of Channel Business Review. 
 * 
 * Release R5
 * @author  Ayiravalli Arasu (Accenture)
 * @created 2016-1-28
 * @version 1.0
 * Created
 */
public with sharing class ClsChannelBusinessReviewEditPage{
/**
* Constructor
*/    
    public ClsChannelBusinessReviewEditPage(ApexPages.StandardController controller) {    
    }
/**
* Constructor
*/   
    public ClsChannelBusinessReviewEditPage(){}
/**
* Method editPageChange - redirect the edit page of Channel Business Review. 
*/    
    public pagereference editPageChange(){
        String redirectRecordTypeId;
        Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
        String recordId = Apexpages.currentPage().getParameters().get(Label.ApexClass_id ); // Label.ApexClass_id ='Id'
        List<Channel_Business_Review__c > RecordTypeIdList = [SELECT ID, RecordType.Name, RecordTypeId FROM Channel_Business_Review__c WHERE ID=:recordId  LIMIT :remLimit];
        if(RecordTypeIdList[0].RecordType.Name == Label.End_Period_Channel_Business_Review_Name){
            redirectRecordTypeId=Label.CBR_End_Period_RecordType_Id;
        }else if(RecordTypeIdList[0].RecordType.Name == Label.Mid_Period_Channel_Business_Review_Name){
            redirectRecordTypeId=Label.CBR_Mid_Period_RecordType_Id;
        } else {
            redirectRecordTypeId = RecordTypeIdList[0].RecordTypeId;
        }
          PageReference pageRef = new PageReference(Label.System_CL00020+recordId +Label.CBR_EditPage_URL+redirectRecordTypeId+Label.System_CL0017_R4+recordId+Label.CBR_EditPage_URL1); // System_CL00020 -> '/' ; CBR_EditPage_URL -> '/e?RecordType=' 
                                                                                                                                                                                         // System_CL0017_R4 -> '&retURL=%2F' ; CBR_EditPage_URL1 -> '&nooverride=1'                                                                     
        return pageRef;
    }   
    
 }