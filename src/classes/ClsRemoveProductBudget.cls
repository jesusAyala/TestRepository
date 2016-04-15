/**   
* Class - ClsRemoveProductBudget
* Controller for VF Page - RemoveProductBudgetPIS 
* Remove only the product from record. 
* Release R5
*  
* @author  Indhu Selvi Ramalingam (Accenture)
* @created 2016-01-11
* @version 1.0
*
* - Created
*/
public with sharing class ClsRemoveProductBudget{

    public Boolean IsError {get;set;}
    
/**   
* Constructor - ClsRemoveProductBudget
*/  
    public ClsRemoveProductBudget(ApexPages.StandardController controller) {   
        IsError = FALSE; 
    }
/**   
* Constructor - ClsRemoveProductBudget
*/   
    public ClsRemoveProductBudget(){}
    
    public String stringBudgetId = Apexpages.currentPage().getParameters().get(Label.System_CL00018);   //Label.System_CL00018 => id
/**   
* Method removeProduct
* Remove the product name from Budget
*/       
    public pagereference removeProduct(){
      
       IsError = FALSE;
       Budget__c lstBudget = [Select id, Product__c, Product_Group__c, Business_Unit__c, Segment_Level__c  from Budget__c where Budget__c.Id =: stringBudgetId limit 50000 ];
         
       List<Budget__c> lstNewBudget = new List<Budget__c>();   
     
        if(stringBudgetid != '' &&  stringBudgetid  != null )
        {
            if(lstBudget.Product__c != NULL)
            {
                Budget__c budgetProduct = new Budget__c();
                budgetProduct.id = stringBudgetId ;
                budgetProduct.Product__c = Null;
                budgetProduct.Segment_Level__c = lstBudget.Segment_Level__c;
                
                budgetProduct.Segment_Level__c = (lstBudget.Product_Group__c != NULL) ? 'Product Group' : budgetProduct.Segment_Level__c;
                budgetProduct.Segment_Level__c = (lstBudget.Product_Group__c == NULL && lstBudget.Business_Unit__c != NULL) ? 'Business Unit' : budgetProduct.Segment_Level__c;
                budgetProduct.Segment_Level__c = (lstBudget.Product_Group__c == NULL && lstBudget.Business_Unit__c == NULL) ? 'Division' : budgetProduct.Segment_Level__c;
                
                lstNewBudget.add(budgetProduct);                                                                   
            } 
            try{
                Database.update(lstNewBudget);
            }Catch(DMLexception e){
                
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,e.getDMLMessage(0)));
                IsError = TRUE;
                return null;
            }      
        } 
                     
        PageReference pageRef = new PageReference(Label.System_CL00020+ stringBudgetId ); 
        return pageRef;
    } 

  }