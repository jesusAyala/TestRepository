/**   
* Apex class - LookupPopupController
* Release R5
* Author -  Shankar Anand
* custom lookup for adding Quote competitors which are not available on the Quotes' parent opportunity
* user can lookup a competitor
*/
public without sharing class LookupPopupController 
{
    public String query {get; set;}
    public List<Account> competitors{get; set;}
    Public Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
     public Boolean empAcc {get;set;}
     
     /**   
* Constructor
*/  
     public LookupPopupController () {
         empAcc = FALSE;
     }
/**   
* Method  runQuery
*/    
    public PageReference runQuery()
    {   
        empAcc = false;
        if(query == '' || query == null){
            empAcc = true;
            return null;
        }
        else{
        String searchAccount = '%'+query+'%';
        competitors =[Select Id,name,BillingStreet, BillingCity, BillingState, BillingPostalCode,BillingCountry,RecordType.Name from Account where name LIKE :searchAccount LIMIT :remLimit];
        return null;
        }
    }
}