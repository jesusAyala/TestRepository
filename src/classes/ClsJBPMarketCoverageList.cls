/**   
* Apex Class : ClsJBPMarketCoverageList
* VF Page    : JBPMarketCoverageList
* Controller for JBPMarketCoverageList - Enable Inline Editing for Joint Business Plan Market Coverage in Joint Business Plan
* Release R5
*
*/
public with sharing class ClsJBPMarketCoverageList
{
    public String returnURL {get;set;}
    public String parentId {get;set;}
    Map<Id,Set<Id>> mapJBP= new Map<Id,Set<Id>>(); 
    public List<Joint_Business_Plan_Market_Coverage__c> lstDuplicateCheck {get;set;}   
    public List<Joint_Business_Plan_Market_Coverage__c> JBPMarketCoverage {get;set;}
/**   
* Constructor ClsJBPMarketCoverageList
*/    
    public ClsJBPMarketCoverageList(ApexPages.StandardController controller) {
        Joint_Business_Plan__c jointBussPlan=(Joint_Business_Plan__c)controller.getRecord();         
        returnURL = apexpages.currentpage().getparameters().get(Label.ApexClass_id);                   
        parentId = returnURL.replace(Label.System_CL00020 , '');  // System_CL00020 => /           
        parentId = parentId.substring(0,15);    
                      
        JBPMarketCoverage = [SELECT Id, Name,Joint_Business_Plan__c, Market_Position__c,
                    Focussed_Industry1__c, Special_Focus__c, Strength__c, 
                    Targeted_ABB_this_year_sales__c, Other_Details__c, Targeted_Sales_this_year__c, 
                    Sales_Today__c, Annual_Growth_Potential__c, Current_Business__c, ABB_Product_Lines__c
                      from Joint_Business_Plan_Market_Coverage__c WHERE Joint_Business_Plan__c =: parentid limit 10000];                  
    } 
/**   
* Save method for Joint_Business_Plan_Market_Coverage__c
*/    
    public PageReference save() {
       Map<Id, Joint_Business_Plan_Market_Coverage__c> industryMap = new Map<Id, Joint_Business_Plan_Market_Coverage__c> ([SELECT Focussed_Industry1__c FROM Joint_Business_Plan_Market_Coverage__c WHERE Joint_Business_Plan__c =: parentid LIMIT 50000]);      
        Set<String> productIdSet = new Set<String>();    
        String dupPrd = '';  
          
       for(Joint_Business_Plan_Market_Coverage__c dupCheck : JBPMarketCoverage ){  
                      
            if (dupCheck.Focussed_Industry1__c != NULL) {
            
                List<String> str = dupCheck.Focussed_Industry1__c.split(Label.System_CL00046);
                
                for (String st: str) {
                    if (!productIdSet.contains(st)) {
                    
                        productIdSet.add(st); 
                    } else {
                        dupPrd += st +Label.CL00069; // comma
                    }
                }              
            }            
        }
                  
       if (!String.isBlank(dupPrd)) {           
           dupPrd = dupPrd.substring(0, dupPrd.length()-2);
           apexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, Label.Focussed_Industry_Error_Msg + dupPrd));
           return null;
       } else {      
           Database.update(JBPMarketCoverage);
       }
        PageReference pageRef = new PageReference(Label.System_CL00020+returnURL);
        return pageRef;        
    }
/**   
* cancel Method 
* redirect to the parent detail page
*/      
    public PageReference cancel() {
        PageReference pageRef = new PageReference(Label.System_CL00020+returnURL);
        return pageRef;  
    }
}