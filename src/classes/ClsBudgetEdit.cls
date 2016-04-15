/**   
* Controller : ClsBudgetEdit
* VF Page : EditBudgetPIS
* Release R5
*  
* @author  Indhu Selvi Ramalingam (Accenture)
* @created  2016-01-11
*
*/ 
global with sharing class ClsBudgetEdit {

    /**   
    * Controller : ClsBudgetEdit - PISNode
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
    * Controller : ClsBudgetEdit - ProductResult 
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
        * Controller : ClsBudgetEdit - ProductResult()
        * Release R5        
        */ 
        global ProductResult() {
            this.processed = 0;
            this.failed = 0;
            this.total = 0;
            this.failedProducts = new List<PISNode>();
        }
    }

    private final Budget__c BudProductLine;
    public String parentId  {get;set;}
    public String returnURL {get;set;}
    public String PId{get;set;}
    public Boolean isProductExist{get;set;} 
    public Boolean showCanvas{get;set;}
    public Boolean showErrmsg{get;set;}
    Public Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
    /**   
    * Controller : ClsBudgetEdit - constructor
    * Release R5  
          
    */
    global ClsBudgetEdit(ApexPages.StandardController controller) {
        String controllerName = String.valueOf(controller.getRecord().getSObjectType());
        
        String id = apexpages.currentpage().getparameters().get(Label.System_CL00080); 
        
        if( id != null && id != '')
        {        
            this.BudProductLine= (Budget__c)controller.getRecord();            
            
            returnURL = Label.System_CL00020+id;      
            parentId  = id;             
        }
        
         Budget__c lstBudget = [Select id, Product__c from Budget__c where Budget__c.Id=: parentId LIMIT :remLimit];
          
            if(lstBudget.Product__c != null)
            {isProductExist = True;}else {isProductExist = False;}   
     
             if(isProductExist == True )
            {showCanvas = True; showErrmsg = False;}
            
            if(isProductExist == False)
            {showErrmsg = True;}                  
            
            if(isProductExist == False) 
            {      
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.ChannelMarkScope_Add_Product));                
            }
        
        }
    
    /**   
    * Controller : ClsBudgetEdit - GoBack()
    * Release R5  
          
    */    
    public Pagereference GoBack()    
    {
            PageReference pageRef = new PageReference(returnURL);
            return pageRef;
    }
    
    /**   
    * Controller : ClsBudgetEdit - replaceProduct
    * Release R5  
          
    */
    @RemoteAction
    global static ProductResult replaceProduct(ID accountPlanID, PISNode newProduct) {  
        Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
        ProductResult result = new ProductResult();

        try 
        {   
            Product2[] Prd  = [Select Id, Name from Product2 where Cid__c =: newProduct.cid];            
            String StrAccountPlanId = accountPlanID;                          
            Budget__c[] budget = [Select Id, Product__c from Budget__c where id =: accountPlanID LIMIT :remLimit];            
        /*  if(JBP[0].Product__c != Prd[0].Id)           
            {
            JBP[0].ABB_Location__c = null;}   */
            budget[0].Product__c = Prd[0].Id;         
            Database.Update(budget);
           
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
            result.lineItemId = accountPlanID;
        }
        return result;
        
        
    }
    
    
    
}