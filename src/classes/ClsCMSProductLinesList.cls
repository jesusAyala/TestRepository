/**   
* Apex Class : ClsCMSProductLinesList
* VF Page    : CMSProductLinesList
* Controller for CMSProductLinesList- Enable Inline Editing for Channel Market Scope Product Lines in Channel Market Scope
* Release R5
*
*/
public with sharing class ClsCMSProductLinesList
{
    public String returnURL {get;set;}
    public String parentId {get;set;}
    Map<Id,Set<Id>> mapJBP= new Map<Id,Set<Id>>(); 
    public List<Channel_Market_Coverage_Product_Lines__c> lstDuplicateCheck {get;set;}
  //  public string productlkp {get;set;}
    public List<Channel_Market_Coverage_Product_Lines__c> CMSProdLineItems {get;set;}

/**   
* Constructor ClsCMSProductLinesList
* Release R5
*
*/    
    public ClsCMSProductLinesList(ApexPages.StandardController controller) {
        Channel_Market_Coverage__c chanMarktScope=(Channel_Market_Coverage__c)controller.getRecord();         
        returnURL = apexpages.currentpage().getparameters().get(System.label.System_CL00018);                   
        parentId = returnURL.replace(Label.System_CL00020 , '');  // System_CL00020 => /           
        parentId = parentId.substring(0,15);
        
        CMSProdLineItems =[SELECT Id, Name, Channel_Market_Coverage__c, Actual_Stock__c, Business_Unit__c, Division__c, Other_Information__c, Planned_Stock__c,Product__r.Name,
                           Product_Group__c, Product__c,  Target_Lead_Times__c FROM Channel_Market_Coverage_Product_Lines__c WHERE Channel_Market_Coverage__c =:parentId limit 10000];
            
    }
/**   
* Save method 
* Update the record Channel_Market_Coverage_Product_Lines__c 
*
*/     
     public PageReference save() {
           
        Set<Id> productIdSet = new Set<Id>();    
        String dupPrd = '';  
        
        for(Channel_Market_Coverage_Product_Lines__c dupCheck : CMSProdLineItems){
            productIdSet.add(dupCheck.Product__c);
        }
        Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
        Map<Id, Product2> productMap = new Map<Id, Product2> ([SELECT Id, Name FROM Product2 WHERE IsActive = TRUE AND Id IN: productIdSet LIMIT :remLimit]);
        
        productIdSet.clear();
        
        for(Channel_Market_Coverage_Product_Lines__c dupCheck : CMSProdLineItems){            
            if (!productIdSet.contains(dupCheck.Product__c)) {
                productIdSet.add(dupCheck.Product__c); 
            } else {
                dupPrd += (productMap.containsKey(dupCheck.Product__c)) ? productMap.get(dupCheck.Product__c).Name + System.label.CL00069 : dupCheck.Product__c + System.label.CL00069 ;
                 //system.debug('::::::'+dupCheck.Product__r.Name+':dupCheck.Product__c:::'+dupCheck.Product__c);  
            }          
        }           
           
       if (dupPrd != '') {           
           dupPrd = dupPrd.substring(0, dupPrd.length()-2);
           apexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,System.label.ChannelMarkScope_Error_Message+dupPrd));
           return null;
       } else {
       
       Database.update(CMSProdLineItems);
       }
        PageReference pageRef = new PageReference(System.label.System_CL00020+returnURL);
        return pageRef;        
    }
 
/**   
* cancel method 
* returns to the previous page
*
*/     
    public PageReference cancel() {
         PageReference pageRef = new PageReference(System.label.System_CL00020+returnURL);
        return pageRef;  
    }

}