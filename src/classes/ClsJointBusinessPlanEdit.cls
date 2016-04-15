/**   
* Controller : ClsJointBusinessPlanEdit
* Release R5
*  
* @author  Indhu Selvi Ramalingam (Accenture)
* @created  2015-12-28
*
*/ 
global with sharing class ClsJointBusinessPlanEdit {

    /**   
    * Controller : ClsJointBusinessPlanEdit - PISNode
    * Release R5
    *  
    * @author  Indhu Selvi Ramalingam (Accenture)
    * @created  2015-12-28
    *
    */    
    global class PISNode
    {
         public String cid;
         public String englishDescription;
         public String languageSpecificDescription;
    }
    
    /**   
    * Controller : ClsJointBusinessPlanEdit - ProductResult 
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

        /**   
        * Controller : ClsJointBusinessPlanEdit - ProductResult()
        * Release R5        
        */ 
        global ProductResult() {
            this.processed = 0;
            this.failed = 0;
            this.total = 0;
            this.failedProducts = new List<PISNode>();
        }
    }

    private final Joint_Business_Plan_Product_Lines__c JBPProductLine;
    public String parentId  {get;set;}
    public String returnURL {get;set;}
    public String PId{get;set;}
 // public Boolean isSubApproval{get;set;} 
 // public Boolean isNotQualified{get;set;} 
 // public Boolean isNotMember{get;set;} 
    public Boolean showCanvas{get;set;}
    public Boolean showErrmsg{get;set;}
    
/**   
* Controller : ClsJointBusinessPlanEdit - constructor
* Release R5 
*/
global ClsJointBusinessPlanEdit(ApexPages.StandardController controller) {
        String controllerName = String.valueOf(controller.getRecord().getSObjectType());
        
        String id = apexpages.currentpage().getparameters().get(Label.System_CL00080); 
        
        if( id != null && !String.IsBlank(id))
        {        
            this.JBPProductLine= (Joint_Business_Plan_Product_Lines__c)controller.getRecord();            
            
            returnURL = Label.System_CL00020+id;      
            parentId  = id;             
        }
        
        List<Joint_Business_Plan_Product_Lines__c> lstJBPPrds = [Select id, Joint_Business_Plan__c from Joint_Business_Plan_Product_Lines__c where Id =: parentId limit 50000 ];
        if(lstJBPPrds != null && lstJBPPrds.size() >0)
 
            showCanvas  = True;      
        }
    
    /**   
    * Controller : ClsJointBusinessPlanEdit - GoBack()
    * Release R5  
          
    */    
    public Pagereference GoBack()    
    {
            PageReference pageRef = new PageReference(returnURL);
            return pageRef;
    }
    
    /**   
    * Controller : ClsJointBusinessPlanEdit - replaceProduct
    * Release R5  
          
    */
    @RemoteAction
    global static ProductResult replaceProduct(ID productQualificationID, PISNode newProduct) {  
        
        ProductResult result = new ProductResult();
        Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
        try 
        {   
            Product2[] Prd  = [Select Id from Product2 where Cid__c =: newProduct.cid LIMIT :remLimit];            
            String StrProdQualificationId = productQualificationID;                          
            Joint_Business_Plan_Product_Lines__c[] JBP = [Select Id, Product__c from Joint_Business_Plan_Product_Lines__c where id =: productQualificationID LIMIT :remLimit];            
        /*  if(JBP[0].Product__c != Prd[0].Id)           
            {
            JBP[0].ABB_Location__c = null;}   */
            JBP[0].Product__c = Prd[0].Id;         
            Database.Update(JBP);
           
        }
        catch (System.DmlException e) {            
            for (Integer i = 0; i < e.getNumDml(); i++) {
                result.failed++;
              //  System.debug(e.getDmlMessage(i));
            }
        }
        
               
        if (result.failed > 0) {
            result.success = false;
            for (PISNode failedNode:result.failedProducts) {
            }

        } else {
            result.success = true;
            result.lineItemId = productQualificationID;
        }
        return result;
        
        
    }
    
    
    
}