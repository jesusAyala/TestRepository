/**   
* Class - ClsRemoveProductCustSeg
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
public with sharing class ClsRemoveProductCustSeg{

    public Boolean IsError {get;set;}
/**
* Constructor
*/  
    public ClsRemoveProductCustSeg(ApexPages.StandardController controller) { 
        IsError = FALSE;   
    }
/**
* Construtor
*/   
    public ClsRemoveProductCustSeg(){}
    
    public String stringCustSegId = Apexpages.currentPage().getParameters().get(Label.ApexClass_id);   
/**
* Method removeProduct
* Remove only the product from record. 
*/        
    public pagereference removeProduct(){
        
       IsError = FALSE;
       Customer_Segmentation__c lstCustSeg = [Select id, Product__c, Product_Group__c, Segment_Level__c, Business_Unit__c from Customer_Segmentation__c where Customer_Segmentation__c.Id =: stringCustSegId limit 50000 ];
         

       List<Customer_Segmentation__c> lstNewCustSeg = new List<Customer_Segmentation__c>();   
     
        if(stringCustSegId != '' &&  stringCustSegId  != null )
        {
            if(lstCustSeg.Product__c != NULL)
            {
                Customer_Segmentation__c custSegProduct = new Customer_Segmentation__c();
                custSegProduct.id = stringCustSegId ;
                custSegProduct.Product__c = Null;
                custSegProduct.Segment_Level__c = lstCustSeg.Segment_Level__c;
                custSegProduct.Segment_Level__c = (lstCustSeg.Product_Group__c != NULL) ? 'Product Group' : custSegProduct.Segment_Level__c;
                custSegProduct.Segment_Level__c = (lstCustSeg.Product_Group__c == NULL && lstCustSeg.Business_Unit__c != NULL) ? 'Business Unit' : custSegProduct.Segment_Level__c;
                custSegProduct.Segment_Level__c = (lstCustSeg.Product_Group__c == NULL && lstCustSeg.Business_Unit__c == NULL) ? 'Division' : custSegProduct.Segment_Level__c;
                
                lstNewCustSeg.add(custSegProduct);                                                                   
            } 
            try{
            Database.update(lstNewCustSeg);
            }Catch(DMLexception e){
                IsError = TRUE;
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,e.getDMLMessage(0)));
                return null;
            }
        } 
                     
        PageReference pageRef = new PageReference(Label.System_CL00020 + stringCustSegId ); 
        return pageRef;
    } 
  
}