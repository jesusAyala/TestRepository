/**   
* Class - ClsAddProductCustSeg
* Controller for VF Page - AddProductCustSeg
* Take the products from product group table to show the products in the form of PIS Tree. 
* Release R5
*  
* @author  Indhu Selvi Ramalingam (Accenture)
* @created 2016-01-11
* @version 1.0
*
* - Created
*/
global with sharing class ClsAddProductCustSeg{

    /**   
    * Controller : ClsAddProductCustSeg- PISNode
    * Release R5
    *  
    * @author  Indhu Selvi Ramalingam (Accenture)
    * @created  2016-01-11
    * @version 1.0
    */  
      global class PISNode
    {
         public String cid;
         public String englishDescription;
         public String languageSpecificDescription;
    }
    
    /**   
    * Controller : ClsAddProductCustSeg- ProductResult 
    * Release R5
    *  
    * @author  Indhu Selvi Ramalingam (Accenture)
    * @created  2016-01-11 
    * @version 1.0
    */  
    global class ProductResult {
        List<PISNode> failedProducts;
        private Integer processed;
        private Integer failed;
        private Integer total;
        private  boolean success;
        private Id lineItemId;
         private String errorMsg;
       
    //    private String returnURL;
        /**   
        * Controller : ClsAddProductCustSeg- ProductResult() 
        * Release R5       
        *
        */ 
        public ProductResult() {
            this.processed = 0;
            this.failed = 0;
            this.total = 0;
      //      this.returnURL = null;
            this.failedProducts = new List<PISNode>();
        }
    }

    private final Customer_Segmentation__c custSegList;
    public String parentId {get;set;}
    public String returnURL {get;set;}
    public Boolean isProductExist{get;set;} 
    public Boolean isSubApproval{get;set;} 
    public Boolean showCanvas{get;set;}
    public Boolean showErrmsg{get;set;}
 
     
    /**   
    * Controller : ClsAddProductCustSeg- Constructor 
    * Release R5      
    */ 
    global ClsAddProductCustSeg(ApexPages.StandardController controller) {
        String controllerName = String.valueOf(controller.getRecord().getSObjectType());
        
            this.custSegList = (Customer_Segmentation__c)controller.getRecord();            
            
            returnURL = apexpages.currentpage().getparameters().get('CustSegID'); 
               
            parentId = returnURL;    
            
       
           Customer_Segmentation__c lstCustSeg = [Select id, Product__c from Customer_Segmentation__c where Customer_Segmentation__c.Id=: parentId limit 50000 ];
          
            if(lstCustSeg.Product__c != null)
            {isProductExist = True;}else {isProductExist = False;}   
     
             if(isProductExist == True )
            {showCanvas = False; showErrmsg = True;}
            
            if(isProductExist == False)
            {showCanvas = True;}                  
            
            if(isProductExist) 
            {      
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Change_Product_Button_Error_Message));                
            }
        
        }
    
    /**   
    * Controller : ClsAddProductCustSeg - GoBack() 
    * Release R5      
    */    
    public Pagereference GoBack()    
    {
        try
        {
            PageReference pageRef = new PageReference(Label.System_CL00020+parentId  );
            return pageRef;
        }
        catch(DMLException e){ return null; } 
    }
    
    /**   
    * Controller : ClsAddProductCustSeg - addProducts() 
    * Release R5      
    */  
    @RemoteAction
    global static ProductResult addProducts(ID CustSegID, List<PISNode> products) {
                
        ProductResult result = new ProductResult();
        
        List<Product2> lstPrds = new List<Product2>();
        Set<String> Pids = new Set<String>();
               
        for (PISNode product : products) {            
            Pids.add(product.cid);           
        }

        try 
        {   
            lstPrds = [Select Id, Related_Product_Group__c from Product2 where Cid__c in : Pids  limit 50000];
            
            String strCustSegID = CustSegID;       
            List<Customer_Segmentation__c> lstNewCustSeg = new List<Customer_Segmentation__c>();   
            List<Customer_Segmentation__c> lstCustSeg = [Select id,Account__c ,Account__r.Id, Product__c from Customer_Segmentation__c where Id =: CustSegID limit 50000 ];
            String strAccountid = lstCustSeg[0].Account__r.Id;
            
            
           if(strCustSegID != '' &&  strCustSegID  != null )           
           {                                
                           
                for(Product2 p : lstPrds)
               {               
                   Customer_Segmentation__c cs = new Customer_Segmentation__c(); 
                   cs.id =  strCustSegID;         
                   cs.Product__c = p.Id;                                             
                   lstNewCustSeg.add(cs);                                  
               }   
    
               Database.Update(lstNewCustSeg);  
          
           }
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
                //System.debug('Failed: [' + failedNode.cid + '] - ' + failedNode.englishDescription + '\n');
            }

        } else {
            result.success = true;
        }
        return result;
    }
    
    
}