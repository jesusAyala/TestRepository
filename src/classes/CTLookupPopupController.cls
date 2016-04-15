/**
    @Author Shankaranarayanan V
    @name CTLookupPopupController 
    @CreateDate 01/07/2016
    @Version 1.0
    **/
public without sharing class CTLookupPopupController 
{
    public String query {get; set;}
    public List<Account> competitors{get; set;}
    public Boolean empAcc {get;set;}
    
    
    /*Constructor*/
     public CTLookupPopupController () {
         empAcc = FALSE;
     }
     
     /*  Description of the purpose of the method. 
     *  @name runQuery
     */    
    public PageReference runQuery()
    {
        empAcc = false;
        if(query == '' || query == null){
            empAcc = true;
            return null;
        }
        else{
        try{    
           String searchAccount = System.label.CL00201+query+System.label.CL00201;
           competitors=[Select Id,name,BillingStreet, BillingCity, BillingState, BillingPostalCode,BillingCountry,RecordType.Name from Account where name LIKE :searchAccount LIMIT 50000];
        }catch(Exception e){String err=e.getMessage();}
        }
        return null;
    }
}