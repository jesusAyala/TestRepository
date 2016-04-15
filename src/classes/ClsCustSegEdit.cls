/**   
* Controller : ClsCustSegEdit
* VF Page : EditCustSegPIS
* Release R5
*  
* @author  Indhu Selvi Ramalingam (Accenture)
* @created  2016-01-11
*
*/ 
global with sharing class ClsCustSegEdit {

    /**   
    * Controller : ClsCustSegEdit - PISNode
    * Release R5
    *  
    * @author  Indhu Selvi Ramalingam (Accenture)
    * @created  2016-01-11
    *
    */    
    global class PISNode
    {
         public String cid;
         public String englishDescription;
         public String languageSpecificDescription;
    }
    
    /**   
    * Controller : ClsCustSegEdit - ProductResult 
    * Release R5
    *
    */  
    global class ProductResult {
        List<PISNode> failedProducts;
        private  Integer processed;
        private  Integer failed;
        private  Integer total;
        private  boolean success;
        private  Id lineItemId;
        private String errorMsg;

        /**   
        * Controller : ClsCustSegEdit - ProductResult()
        * Release R5        
        */ 
        global ProductResult() {
            this.processed = 0;
            this.failed = 0;
            this.total = 0;
            this.failedProducts = new List<PISNode>();
        }
    }

    private final Customer_Segmentation__c CustSegProduct;
    public String parentId  {get;set;}
    public String returnURL {get;set;}
    public String PId{get;set;}
    public Boolean isProductExist{get;set;} 
    public Boolean showCanvas{get;set;}
    public Boolean showErrmsg{get;set;}
    
    /**   
    * Controller : ClsCustSegEdit - constructor
    * Release R5  
          
    */
    global ClsCustSegEdit(ApexPages.StandardController controller) {
        String controllerName = String.valueOf(controller.getRecord().getSObjectType());
        
        String id = apexpages.currentpage().getparameters().get(Label.System_CL00080); 
        
        if( id != null && id != '')
        {        
            this.CustSegProduct= (Customer_Segmentation__c)controller.getRecord();            
            
            returnURL = Label.System_CL00020+id;      
            parentId  = id;             
        }
        
         Customer_Segmentation__c lstCustSeg = [Select id, Product__c from Customer_Segmentation__c where Customer_Segmentation__c.Id=: parentId limit 50000 ];
          
            if(lstCustSeg.Product__c != null)
            {isProductExist = True;}else {isProductExist = False;}   
     
             if(isProductExist == True )
            {showCanvas = True; showErrmsg = False;}
            
            if(isProductExist == False)
            {showErrmsg = True;}                  
            
            if(isProductExist == False) 
            {      
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.ChannelMarkScope_Add_Product));  // ChannelMarkScope_Add_Product -> 'Please add the Product'           
            }
        
        }
    
    /**   
    * Controller : ClsCustSegEdit - GoBack()
    * Release R5  
          
    */    
    public Pagereference GoBack()    
    {
            PageReference pageRef = new PageReference(returnURL);
            return pageRef;
    }
    
    /**   
    * Controller : ClsCustSegEdit - replaceProduct
    * Release R5  
          
    */
    @RemoteAction
    global static ProductResult replaceProduct(ID accountID, PISNode newProduct) {  
        
        ProductResult result = new ProductResult();
        Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
        try 
        {   
            Product2[] Prd  = [Select Id, Name from Product2 where Cid__c =: newProduct.cid LIMIT :remLimit];            
            String StrAccountId = accountID;                          
            Customer_Segmentation__c[] custSeg = [Select Id, Product__c from Customer_Segmentation__c where id =: accountID LIMIT :remLimit];            
        /*  if(JBP[0].Product__c != Prd[0].Id)           
            {
            JBP[0].ABB_Location__c = null;}   */
            custSeg[0].Product__c = Prd[0].Id;         
            Database.Update(custSeg);
           
        }
        catch (System.DmlException e) {            
            String error = '';
            for (Integer i = 0; i < e.getNumDml(); i++) {
                result.failed++;
                error += e.getDmlMessage(i) +' \n';
                System.debug(e.getDmlMessage(i));
            }
            
            if ( error.startsWith(Label.Sys_duplicate_Err)) {
                error = Label.Business_Add_Product_Duplicate_Err;
            } 
            
            result.errorMsg = error;
        }
        
               
        if (result.failed > 0) {
            result.success = false;
            for (PISNode failedNode:result.failedProducts) {
            }

        } else {
            result.success = true;
            result.lineItemId = accountID;
        }
        return result;
        
        
    }
    
    
    
}