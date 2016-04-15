/**   
* Apex Class : ClsMarketTrendList
* VF Page    : MarketTrendList
* Controller for MarketTrendList - Enable Inline Editing
* Release R5
*
*/
public with sharing class ClsMarketTrendList{

    public List<Channel_Business_Review_Market_Trend__c> CMSProdLineItems {get;set;}
    public String parentId;
/**   
* Constructor : ClsMarketTrendList
*
*/    
    public ClsMarketTrendList(ApexPages.StandardController controller) {
        
        //Channel_Business_Review_Market_Trend__c ChanMarktScope = (Channel_Business_Review_Market_Trend__c)controller.getRecord();         
        parentId = apexpages.currentpage().getparameters().get(Label.ApexClass_id);           
        
        CMSProdLineItems =[SELECT Id, Name, Channel_Business_Review__c, Feedback__c, Focussed_Industry__c, Notes__c
                           FROM Channel_Business_Review_Market_Trend__c 
                           WHERE Channel_Business_Review__c = :parentId limit 1000];
            
    }
/**   
* Method Save
*
*/     
    public PageReference save() {
        
        try {
            Database.update(CMSProdLineItems);
        } Catch(DMLEXception e) {           
            string error = '';
            for (Integer i = 0; i < e.getNumDML(); i++) {
                error += e.getDMLMessage(i)+Label.Line_Break;
            }
            apexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,error));
            return null;
        }
        
        PageReference pageRef = new PageReference(Label.System_CL00020+parentId);
        return pageRef;        
    }
/**   
* Method Save.
* returns to the previous page
*/     
    public PageReference cancel() {
        PageReference pageRef = new PageReference(Label.System_CL00020+parentId);
        return pageRef;  
    }

}