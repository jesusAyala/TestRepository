/**
 * TriggerClass -  User will also able to copy all the existing information by using an single button click.
                   This will prefill the Focussed Industry from the Channel Market Coverage into the Joint Business Plan Market Coverage. 
 * Controller for Vf pgae - JointBusinessPlanMarketCoverage
 * 
 * Release R5
 * @author  Ayiravalli Arasu (Accenture)
 * @created 2015-12-30
 * @version 1.0
 * Created
 */ 
 public with sharing class ClsJBPMarketCoverage{
 /**
  * Constructor ClsJBPMarketCoverage
 */ 
    public ClsJBPMarketCoverage(ApexPages.StandardController controller){}
    
/**
  * Constructor ClsJBPMarketCoverage
*/ 
    public ClsJBPMarketCoverage(){}
    
    public String jbpId = Apexpages.currentPage().getParameters().get(System.label.System_CL00018);
    public Boolean isSubApproval{get;set;}
    public Boolean showErrmsg{get;set;} 

/**
  * Method createJBPMarketCoverageRec
  * craete the records for Joint_Business_Plan_Market_Coverage__c
*/     
    public pagereference createJBPMarketCoverageRec(){
                
        List<Joint_Business_Plan_Market_Coverage__c> lstInsertJBPMarketCoverage = new List<Joint_Business_Plan_Market_Coverage__c>(); //list to insert
        Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
        List<Joint_Business_Plan__c> listJBP = [select id,Channel_Market_Coverage__c from Joint_Business_Plan__c WHERE id=:jbpId  LIMIT :remLimit]; 
        List<Channel_Market_Coverage__c> channelMarkCoverage = new List<Channel_Market_Coverage__c>();
    
        if(listJBP.size()>0){
        channelMarkCoverage = [SELECT Id, Focussed_Industry1__c, Product_Line1__c FROM Channel_Market_Coverage__c 
                                            WHERE Id =: listJBP[0].Channel_Market_Coverage__c  LIMIT :remLimit];
        }
        Set<String> jbpMarkCovOldRecs =new Set<String>();
        List<Joint_Business_Plan_Market_Coverage__c> lstJBPMarkCoveOldRecords = [Select Id,Focussed_Industry1__c,Joint_Business_Plan__c FROM Joint_Business_Plan_Market_Coverage__c Where Joint_Business_Plan__c =:listJBP[0].id LIMIT :remLimit];
        if(lstJBPMarkCoveOldRecords.size() > 0){
            for(Joint_Business_Plan_Market_Coverage__c oldFocusIndustry : lstJBPMarkCoveOldRecords ){
               
                jbpMarkCovOldRecs.add(oldFocusIndustry.Focussed_Industry1__c);
            }
      
        }
        
        List<ProcessInstance> lstProcessInstance = [Select Id, Status, TargetObject.Name , TargetObjectId from ProcessInstance where
                     TargetObjectId  =: jbpId and Status ='Pending'  limit 50000];
        if(lstProcessInstance != null && lstProcessInstance.size() >0)
        {isSubApproval = true;}
        else        
        {isSubApproval = False;}
        
     if(channelMarkCoverage.size()>0){
         for(Channel_Market_Coverage__c channelMarketCov : channelMarkCoverage){ 
                if(channelMarketCov.Focussed_Industry1__c != null){
                    List<String> listFocusIndustry = new List<String>();
                    listFocusIndustry = channelMarketCov.Focussed_Industry1__c.Split(System.Label.System_CL00046);
                     for(String picklistValues : listFocusIndustry ){
                         if(jbpMarkCovOldRecs.contains(picklistValues) == FALSE){
                             Joint_Business_Plan_Market_Coverage__c newJBPMarketCoverage = new Joint_Business_Plan_Market_Coverage__c();
                             newJBPMarketCoverage.Joint_Business_Plan__c = jbpId ;
                             newJBPMarketCoverage.Focussed_Industry1__c = picklistValues;
                         //    newJBPMarketCoverage.Existing_Business__c = channelMarketCov.Existing_Business__c;
                        //     newJBPMarketCoverage.Special_Focus__c = channelMarketCov.Special_Focus__c;
                             newJBPMarketCoverage.ABB_Product_Lines__c = channelMarketCov.Product_Line1__c;
                             lstInsertJBPMarketCoverage.add(newJBPMarketCoverage); 
                         }
                     }   
                }
         } 
     }
     
     if(isSubApproval )
            {   
            showErrmsg = True;                  
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.System_CL00096));
            return null;               
            }else If(lstInsertJBPMarketCoverage.size()>0){
            Database.insert(lstInsertJBPMarketCoverage);
         }else{}
     
     
        PageReference pageRef = new PageReference(System.label.System_CL00020+jbpId); 
        return pageRef;
    }
/**
  * Method goBack
  * returns to the previous page
*/     
     public Pagereference goBack(){
            try
          {
                PageReference pageRef = new PageReference(System.label.System_CL00020+jbpId);
                return pageRef;
            }
            catch(DMLException e){ return null; } 
        }   
}