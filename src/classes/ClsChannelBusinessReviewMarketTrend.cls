/**
 * Apex Class - ClsChannelBusinessReviewMarketTrend 
 * Controller for Vf pgae - ChannelBusinessReviewMarketTrend
 * 
 * User able to copy all the existing information by using an single button click.
   This will prefill the Focussed Industry from the Channel Market Coverage into the Channel Business Review Market Trend.
 * Release R5
 * @author  Abiramasundari Radha (Accenture)
 * @created 2015-12-29
 * @version 1.0
 * Created
 */
public with sharing class ClsChannelBusinessReviewMarketTrend{
    
    public Boolean isSubApproval{get;set;}
    public Boolean showErrmsg{get;set;}    
    public String channelBusinessReviewId; 
/**
* Constructor
*/    
    public ClsChannelBusinessReviewMarketTrend(ApexPages.StandardController controller) {
    
         channelBusinessReviewId = Apexpages.currentPage().getParameters().get(Label.System_CL00018);    
    }
   
/**
* Method createChannelBusinessReviewMarketTrend
* User able to copy all the existing information by using an single button click.
   This will prefill the Focussed Industry from the Channel Market Coverage into the Channel Business Review Market Trend.
*/       
    public pagereference createChannelBusinessReviewMarketTrend(){
        
        List<Channel_Business_Review_Market_Trend__c> insertCBRMarketTrends = new List<Channel_Business_Review_Market_Trend__c>();        
        Map<Id,Set<String>> mapCBR= new Map<Id,Set<String>>();  
        Set<String> existingFocusIndustrySet = new Set<String>();
        Channel_Market_Coverage__c channelMarkCoverage = NULL;
        String accountId;
        Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
        List<Channel_Business_Review__c> listChannelBusReview = [SELECT Id,Joint_Business_Plan__c, Joint_Business_Plan__r.Channel_Market_Coverage__c FROM Channel_Business_Review__c 
                                            WHERE Id =: channelBusinessReviewId  LIMIT :remLimit];
            
        
        if (listChannelBusReview.size() > 0 && listChannelBusReview[0].Joint_Business_Plan__c != NULL && listChannelBusReview[0].Joint_Business_Plan__r.Channel_Market_Coverage__c != NULL) {
            Channel_Market_Coverage__c[] channelCoverageList = [SELECT Id, Focussed_Industry1__c FROM Channel_Market_Coverage__c 
                                                WHERE Id =: listChannelBusReview[0].Joint_Business_Plan__r.Channel_Market_Coverage__c LIMIT :remLimit];     
            channelMarkCoverage  = (channelCoverageList != NULL && channelCoverageList.size() > 0) ? channelCoverageList[0] : NULL;
        }
        
        List<ProcessInstance> lstProcessInstance = [Select Id, Status, TargetObject.Name , TargetObjectId from ProcessInstance where
                         TargetObjectId  =: channelBusinessReviewId and Status =: Label.ProcessInstance_Status_Pending limit 50000];  // ProcessInstance_Status_Pending -> 'Pending'
                         
        isSubApproval = (lstProcessInstance != null && lstProcessInstance.size() > 0) ? TRUE : FALSE;
          
            
          
        List<Channel_Business_Review_Market_Trend__c> lstDuplicateCheck = [SELECT Id,Channel_Business_Review__c,Focussed_Industry__c FROM 
                        Channel_Business_Review_Market_Trend__c WHERE Channel_Business_Review__c=: channelBusinessReviewId Limit 50000]; 
            
        if(lstDuplicateCheck.size()>0){
            
            for(Channel_Business_Review_Market_Trend__c dupCheck : lstDuplicateCheck){
                existingFocusIndustrySet.add(dupCheck.Focussed_Industry__c );         
            }           
        }  
                
        if (channelMarkCoverage != NULL && channelMarkCoverage.Focussed_Industry1__c!= NULL) {        
            
           List<String> industryList = channelMarkCoverage.Focussed_Industry1__c.split(Label.System_CL00046);  // System_CL00046 -> ';'
           
           for (String industry: industryList) {
               
               if (!existingFocusIndustrySet.contains(industry)){
                    insertCBRMarketTrends.add( new Channel_Business_Review_Market_Trend__c(Focussed_Industry__c= industry, 
                        Channel_Business_Review__c = channelBusinessReviewId)); 
               }
           }        
        }     
        
        if (isSubApproval) {   
            showErrmsg = True;                  
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.System_CL00096));
            return null;               
        } else If (insertCBRMarketTrends.size() > 0) {
            Database.insert(insertCBRMarketTrends);
        }else{}
        
        PageReference pageRef = new PageReference(Label.System_CL00020+ channelBusinessReviewId); 
        return pageRef;
    }
/**
* Method GoBack
* Returns to previous page
*/    
    public Pagereference GoBack() {
           
        PageReference pageRef = (channelBusinessReviewId != NULL && channelBusinessReviewId != '') ? new PageReference(Label.System_CL00020+channelBusinessReviewId) : NULL;
        return pageRef;          
    }   
}