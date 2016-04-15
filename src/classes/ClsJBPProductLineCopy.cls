/**
 * TriggerClass -  Copy all the Product Lines from Channel Market Coverage in to Joint Business Plan Product Line.
 * Don't copy the duplicate product lines. 
 * Controller for Vf pgae - JBPProductLineCopy
 * 
 * Release R5
 * @author  Indhu Selvi Rmalingam (Accenture)
 * @created 2015-12-31
 * @version 1.0
 * Created
 */ 
public with sharing class ClsJBPProductLineCopy {
/**
 * Constructor ClsJBPProductLineCopy
 */     
    public ClsJBPProductLineCopy(ApexPages.StandardController controller){}
/**
 * Constructor ClsJBPProductLineCopy
 */     
    public ClsJBPProductLineCopy(){}
    public String JBPId=Apexpages.currentPage().getParameters().get(Label.ApexClass_id);
    public Boolean isSubApproval{get;set;}
    public Boolean showErrmsg{get;set;} 
/**
 * Method copyChanMarCovProductLine
 * Copy the Joint Business Plan Product Lines 
 */     
    public pagereference copyChanMarCovProductLine(){
        Integer limitRow = Limits.getLimitQueryRows() - Limits.getQueryRows();
        List<Joint_Business_Plan_Product_Lines__c> listJBPProds = new List<Joint_Business_Plan_Product_Lines__c>(); //list to insert
        
        List<Joint_Business_Plan__c> lstJBPRecs=[select id,Start_Date__c,Channel_Market_Coverage__c from Joint_Business_Plan__c where id =:JBPId LIMIT :limitRow];
        
        List<Channel_Market_Coverage_Product_Lines__c> listChanMarkCovProds = new List<Channel_Market_Coverage_Product_Lines__c>();
        
        
        
        if(lstJBPRecs != NULL && lstJBPRecs.size()>0 &&  lstJBPRecs[0].Channel_Market_Coverage__c != NULL){
            
            listChanMarkCovProds = [SELECT Id, Name, Product__c, Target_Lead_Times__c, Product_Group__c, Planned_Stock__c, Business_Unit__c, Business_Unit_Name__c, Division__c, Division_Name__c,
                                        Actual_Stock__c, Other_Information__c, Channel_Market_Coverage__c FROM Channel_Market_Coverage_Product_Lines__c 
                                    WHERE Channel_Market_Coverage__c =: lstJBPRecs[0].Channel_Market_Coverage__c LIMIT :limitRow];            
            
            
            //system.debug('::::listChanMarkCovProds:::'+listChanMarkCovProds );
        }
        
        
        
        List<ProcessInstance> lstProcessInstance = [Select Id, Status, TargetObject.Name , TargetObjectId from ProcessInstance where
                     TargetObjectId  =: JBPId and Status =:Label.ProcessInstance_Status_Pending  LIMIT :limitRow];
                     
        if(lstProcessInstance != null && lstProcessInstance.size() >0)
        {isSubApproval = true;}
        else        
        {isSubApproval = False;}
            
        //system.debug('JBPId----'+JBPId);
     
            Set<Id> mapJBP = new Set<Id>(); 
            
            List<Joint_Business_Plan_Product_Lines__c> lstDuplicateCheck = [Select id,Product__c from Joint_Business_Plan_Product_Lines__c 
                                where Joint_Business_Plan__c  =: JBPId LIMIT :limitRow];
          
            if(lstDuplicateCheck.size()>0){
                for(Joint_Business_Plan_Product_Lines__c dupCheck : lstDuplicateCheck){
                    mapJBP.add(dupCheck.Product__c);           
                }  
                
            }   
        
        
        if(lstJBPRecs != NULL && lstJBPRecs.size() > 0){
            for(Channel_Market_Coverage_Product_Lines__c MarkCoverProds : listChanMarkCovProds){
            
                if(!mapJBP.contains(MarkCoverProds.Product__c)){
                
                    String yearVal = (lstJBPRecs[0].Start_Date__c != NULL ) ? String.ValueOf(lstJBPRecs[0].Start_Date__c.Year()) : '';
                    Joint_Business_Plan_Product_Lines__c newJBPProds = new Joint_Business_Plan_Product_Lines__c();
                    newJBPProds.Joint_Business_Plan__c = lstJBPRecs[0].id;
                    newJBPProds.Product__c = MarkCoverProds.Product__c; 
                    newJBPProds.Product_Mix__c = MarkCoverProds.Product__c;                    
                    newJBPProds.Product_Group__c = MarkCoverProds.Product_Group__c;
                    newJBPProds.Target_Lead_Times__c = MarkCoverProds.Target_Lead_Times__c;
                    //newJBPProds.Targeted_Stock__c = MarkCoverProds.Targeted_Stock__c;
                    newJBPProds.Business_Unit__c = MarkCoverProds.Business_Unit__c;
                    newJBPProds.Division__c = MarkCoverProds.Division__c;
                    newJBPProds.Business_Unit_Name__c = MarkCoverProds.Business_Unit_Name__c;
                    newJBPProds.Division_Name__c = MarkCoverProds.Division_Name__c;
                    newJBPProds.Planned_Stock__c = MarkCoverProds.Planned_Stock__c;
                    newJBPProds.Actual_Stock__c = MarkCoverProds.Actual_Stock__c;
                    newJBPProds.Other_Information__c = MarkCoverProds.Other_Information__c;
                    newJBPProds.Starting_Year__c = yearVal;
                    listJBPProds.add(newJBPProds);              
                }
            }
        }
        
          if(isSubApproval )
            {   
                showErrmsg = True;                  
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.System_CL00096));
                return null;                
            }else if(listJBPProds.size()>0){
                 try {
                 //system.debug(':::listJBPProds:::'+listJBPProds);
                
                 Database.insert(listJBPProds);
                 }    Catch(DMLException e) {
                     showErrmsg = TRUE;
                     string error = '';
                     for (Integer i = 0; i < e.getNumDml(); i++) {
                        // Process exception here
                       error += (e.getDmlMessage(i)) +Label.Line_Break; 
                    }
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, error));
                    return null;   
                }
            }else{}
        
        PageReference pageRef = new PageReference(Label.System_CL00020+JBPId); 
        return pageRef;
       }
/**
 * Method GoBack
 * GoBack to the previous page
 */        
         public Pagereference GoBack(){
            try
            {
                PageReference pageRef = new PageReference(Label.System_CL00020+JBPId);
                return pageRef;
            }
            catch(DMLException e){ return null; } 
        }  
        
    
    
}