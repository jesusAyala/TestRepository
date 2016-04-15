/**   
* Class - ClsAddProductBudget
* Controller for VF Page - AddProductBudgetPIS 
* Take the products from product group table to show the products in the form of PIS Tree. 
* Release R5
*  
* @author  Indhu Selvi Ramalingam (Accenture)
* @created 2016-01-11
* @version 1.0
*
* - Created
*/
global with sharing class ClsAddProductBudget{

/**   
* Controller : ClsAddProductBudget- PISNode
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
    * Controller : ClsAddProductBudget- ProductResult 
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
* Controller : ClsAddProductBudget- ProductResult() 
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

    private final Budget__c budList;
    public String parentId {get;set;}
    public String returnURL {get;set;}
    public Boolean isProductExist{get;set;} 
    public Boolean isSubApproval{get;set;} 
    public Boolean showCanvas{get;set;}
    public Boolean showErrmsg{get;set;}
     
/**   
* Controller : ClsAddProductBudget- Constructor 
* Release R5      
*/ 
    global ClsAddProductBudget(ApexPages.StandardController controller) {
        String controllerName = String.valueOf(controller.getRecord().getSObjectType());
        
            this.budList = (Budget__c)controller.getRecord();            
            
            returnURL = apexpages.currentpage().getparameters().get(Label.Budget_Add_Product_ID); 
               
            parentId = returnURL;    
            
       
           Budget__c lstBudget = [Select id, Product__c from Budget__c where Budget__c.Id=: parentId limit 50000 ];
          
            if(lstBudget.Product__c != null)
            {isProductExist = True;}else {isProductExist = False;}   
     
             if(isProductExist == True )
            {showCanvas = False; showErrmsg = True;}
            
            if(isProductExist == False)
            {showCanvas = True;}                  
            
            if(isProductExist) 
            {      
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Change_Product_Button_Error_Message)); // Change_Product_Button_Error_Message -> Product already exists.Please use Change Product Button             
            }
        
        }
    
/**   
* Controller : ClsAddProductBudget - GoBack() 
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
* Controller : ClsAddProductBudget - addProducts() 
* Release R5      
*/  
    @RemoteAction
    global static ProductResult addProducts(ID BudgetID, List<PISNode> products) {
                
        ProductResult result = new ProductResult();
        result.errorMsg = '';
        List<Product2> lstPrds = new List<Product2>();
        Set<String> Pids = new Set<String>();
               
        for (PISNode product : products) {            
            Pids.add(product.cid);           
        }

        try 
        {   
         //   lstPrds = [Select Id, Related_Product_Group__c from Product2 where Cid__c in : Pids  limit 50000];
            
            String strBudgetid = BudgetID;       
            List<Budget__c> lstNewBudget = new List<Budget__c>();   
            List<Budget__c> lstBudget = [Select id,Account_Plan__c ,Account_Plan__r.Id, Product__c from Budget__c where Id =: Budgetid limit 50000 ];
            String strAccountPlanid = lstBudget[0].Account_Plan__r.Id;
            
            
           if(strBudgetid != '' &&  strBudgetid  != null )           
           {                                
                           
                for(Product2 p : [Select Id, Related_Product_Group__c from Product2 where Cid__c in : Pids  limit 50000])
               {               
                   Budget__c bg = new Budget__c(); 
                   bg.id =  strBudgetid;         
                   bg.Product__c = p.Id;                                             
                   lstNewBudget.add(bg);                                  
               }   
    
               Database.Update(lstNewBudget);  
          
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