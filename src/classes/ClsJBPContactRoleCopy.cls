/**
 * Class - ClsJBPContactRoleCopy 
 * Controller for Vf pgae - JBPContactRoleCopy
 * 
 * Copy Contact from the Account in to the Joint Business Plan Contact Role.
    Don't copy the duplicate Contacts.
 * Release R5
 * @author  Indhu Selvi Ramalingam (Accenture)
 * @created 2016-01-06
 * @version 1.0
 * Created
 */
public with sharing class ClsJBPContactRoleCopy{
/**
* Constructor
*/  
    public ClsJBPContactRoleCopy(ApexPages.StandardController controller) {    
    }
/**
* Constructor
*/     
    public ClsJBPContactRoleCopy(){}
    
    public String stringJBPId = Apexpages.currentPage().getParameters().get(Label.ApexClass_id ); // Label.ApexClass_id ='Id'
    public Boolean isSubApproval{get;set;}
    public Boolean showErrmsg{get;set;} 
 /**
* Method copyAccountContacts 
* Copy Contact from the Account in to the Joint Business Plan Contact Role.
*/        
    public pagereference copyAccountContacts(){
        String accountId;
        
        Set<Id> JBPId = new Set<Id>();        
        List<Joint_Business_Plan_Contact_Role__c> addContactsList = new List<Joint_Business_Plan_Contact_Role__c>();
        Map<Id,Set<Id>> mapJBP= new Map<Id,Set<Id>>();
         Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();     
        List<Joint_Business_Plan__c> lstJBP = [SELECT Id,Name,Account__c 
            FROM Joint_Business_Plan__c WHERE Id =: stringJBPId LIMIT :remLimit];         
        if(lstJBP.size()>0){
            accountId = lstJBP[0].Account__c;
        }
        
        
        If(lstJBP.size()>0){         
            for(Joint_Business_Plan__c oldrecords : lstJBP){
                JBPId.add(oldrecords.Id);
                
               //system.debug('-----JBPId------'+JBPId); 
            }
        }
        
        Map<Id, String> contactIdAndPrdLinesMap = new Map <Id, String>();
               
        List<Contact> listContact = [SELECT Id, Name, AccountId, ABB_Perspective_Role__c From Contact 
                        where AccountID =: accountId LIMIT :remLimit];
                        
        //List<Product_Lines__c> listProdLines = [SELECT Id, Name, Product__r.Name, Contact__c, Contact__r.ABB_Perspective_Role__c FROM Product_Lines__c
                                                //WHERE Contact__r.AccountId =: accountId AND Product__c != NULL]   ;
        for (Product_Lines__c pr : [SELECT Id, Name, Product__r.Name, Contact__c, Contact__r.ABB_Perspective_Role__c FROM Product_Lines__c
                                                WHERE Contact__r.AccountId =: accountId AND Product__c != NULL LIMIT :remLimit]) {
            
            if (!contactIdAndPrdLinesMap.containskey(pr.Contact__c)) {
                contactIdAndPrdLinesMap.put (pr.Contact__c, pr.Product__r.Name);
            } else {
                contactIdAndPrdLinesMap.put(pr.Contact__c, contactIdAndPrdLinesMap.get(pr.Contact__c) + Label.System_CL00046 + pr.Product__r.Name);
            }
        }
        List<ProcessInstance> lstProcessInstance = [Select Id, Status, TargetObject.Name , TargetObjectId from ProcessInstance where
                     TargetObjectId  =: stringJBPId and Status=:Label.ProcessInstance_Status_Pending limit 50000];
        if(lstProcessInstance != null && lstProcessInstance.size() >0)
        {isSubApproval = true;}
        else        
        {isSubApproval = False;}
        
        List<Joint_Business_Plan_Contact_Role__c> lstDuplicateCheck = [SELECT Id, Joint_Business_Plan__c, Contact__c, ABB_Perspective_Role__c FROM 
                    Joint_Business_Plan_Contact_Role__c WHERE Joint_Business_Plan__c =: JBPId Limit 50000]; 
        
        if(lstDuplicateCheck.size()>0){
            for(Joint_Business_Plan_Contact_Role__c dupCheck : lstDuplicateCheck){
                if(mapJBP.containskey(dupCheck.Joint_Business_Plan__c) == False){
                    mapJBP.put(dupCheck.Joint_Business_Plan__c, new set<Id>());                                   
                }
                mapJBP.get(dupCheck.Joint_Business_Plan__c).add(dupCheck.Contact__c);     
                
                //system.debug('-----mapJBP------'+mapJBP);      
            }           
        }            
        
         If(lstJBP.size() > 0 && listContact.size() > 0){
          
                for(Contact accContact : listContact){
                    
                    if((mapJBP.containskey(lstJBP[0].Id) == FALSE) || (mapJBP.containskey(lstJBP[0].Id) && mapJBP.get(lstJBP[0].Id).Contains(accContact.Id) == FALSE)){                        
                        Joint_Business_Plan_Contact_Role__c jbpContact = new Joint_Business_Plan_Contact_Role__c();                          
                        jbpContact.Joint_Business_Plan__c = lstJBP[0].Id;
                        jbpContact.Contact__c = accContact.Id;
                        jbpContact.ABB_Perspective_Role__c = accContact.ABB_Perspective_Role__c;  
                        jbpContact.Product_Lines__c = (contactIdAndPrdLinesMap.containskey(accContact.Id)) ? contactIdAndPrdLinesMap.get(accContact.Id): '';                                                                          
                        addContactsList.add(jbpContact);   
                    }
                }                                         
            } 
        
  
          
        
         if(isSubApproval )
            {   
            showErrmsg = True;                  
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.System_CL00096));
            return null;               
            }else  if(addContactsList.size()>0){
            
            try {
            Database.insert(addContactsList); 
            } Catch (DMLEXception e) {
                showErrmsg = TRUE;
                String error = '';
                for (Integer i= 0; i < e.getNumDML(); i++) {
                    error += e.getDMLMessage(i) +Label.Line_Break;                    
                }
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, error ));
                return null;
            }
          }else{}
            
                          
        PageReference pageRef = new PageReference(Label.System_CL00020+stringJBPId); 
        return pageRef;
    }
 /**
* Method GoBack
* returns to the previous page
*/ 
    public Pagereference goBack(){
            try
          {
                PageReference pageRef = new PageReference(Label.System_CL00020+stringJBPId); //Label.System_CL00020 = '/'
                return pageRef;
            }
            catch(DMLException e){ return null; } 
        }   
}