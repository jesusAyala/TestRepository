/**   
* Apex Class : ClsJBPProductLinesList
* VF Page    : JBPProductLinesList
* Controller for JBPProductLinesList - Enable Inline Editing for Joint Business Plan Product Lines in Joint Business Plan
* Release R5
*
*/
public with sharing class ClsJBPProductLinesList
{
    public String returnURL {get;set;}
    public String parentId {get;set;}
    Map<Id,Set<Id>> mapJBP= new Map<Id,Set<Id>>(); 
    public List<Joint_Business_Plan_Product_Lines__c> lstDuplicateCheck {get;set;}
    
    public String currencyCode {get;set;}
    public string productlkp {get;set;}
    public List<Joint_Business_Plan_Product_Lines__c> JBPProdLineItems {get;set;}
/**
* Constructor 
*/    
    public ClsJBPProductLinesList(ApexPages.StandardController controller) {
    
        Joint_Business_Plan__c jointBussPlan=(Joint_Business_Plan__c)controller.getRecord();         
        returnURL = apexpages.currentpage().getparameters().get('id');                   
        parentId = returnURL.replace(Label.System_CL00020 , '');  // System_CL00020 => /           
        parentId = parentId.substring(0,15);    
                      
        JBPProdLineItems = [SELECT Id, Name,currencyISOCode,Joint_Business_Plan__c,Joint_Business_Plan__r.Status__C, Product__c,Product__r.Name,Product__r.Id,
                Forecast_Ongoing_Year__c,Current_Ongoing_Year__c, Previous_Year__c, Previous_Year_Currency__c, Actual_Year_to_Date_Changed_on__c,
                Run_Rate_On__c, Starting_Year__c, Current_Year_Currency__c, Second_Year__c, Second_Year_Currency__c,
                Third_Year__c, Third_Year_Currency__c 
            FROM Joint_Business_Plan_Product_Lines__c 
            WHERE Joint_Business_Plan__c =: parentid 
            ORDER BY Starting_Year__c limit 1000 ]; 
        
        if (JBPProdLineItems != NULL && JBPProdLineItems.size() > 0) currencyCode = JBPProdLineItems[0].currencyISOCode;                 
    } 
/**
* Save method
* save the record value after editing
*/   
    public PageReference save() {
       
        
        Set<String> productIdSet = new Set<String>();    
        String dupPrd = '';  
        Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
          
        for(Joint_Business_Plan_Product_Lines__c dupCheck : JBPProdLineItems ){
            productIdSet.add(dupCheck.Product__c);
        }
        
        Map<Id, Product2> productMap = new Map<Id, Product2> ([SELECT Id, Name FROM Product2 WHERE IsActive = TRUE AND Id IN: productIdSet LIMIT :remLimit]);
        
        productIdSet.clear();
        
        for(Joint_Business_Plan_Product_Lines__c dupCheck : JBPProdLineItems ){            
            if (!productIdSet.contains(dupCheck.Product__c+dupCheck.Starting_Year__c)) {
                productIdSet.add(dupCheck.Product__c+dupCheck.Starting_Year__c); 
            } else {
                dupPrd += (productMap.containsKey(dupCheck.Product__c+dupCheck.Starting_Year__c)) ? productMap.get(dupCheck.Product__c).Name+ System.label.CL00069 : dupCheck.Product__c +System.label.CL00069; //CL00069 => ','
                 //system.debug('::::::'+dupCheck.Product__r.Name+':dupCheck.Product__c:::'+dupCheck.Product__c);  
            }  
            
                         
        }           
           
       if (dupPrd != '') {           
           dupPrd = dupPrd.substring(0, dupPrd.length()-2);
           apexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,System.label.ChannelMarkScope_Error_Message+dupPrd));
           return null;
       } else {
       
       Database.Update(JBPProdLineItems,False);
       }
        PageReference pageRef = new PageReference(System.label.System_CL00020+returnURL); //System_CL00020 => '/'
        return pageRef;        
    }
 /**
* Cancel method
* returns to the previous page
*/     
    public PageReference cancel() {
       PageReference pageRef = new PageReference(System.label.System_CL00020+returnURL); //System_CL00020 => '/'
       return pageRef; 
    }
}