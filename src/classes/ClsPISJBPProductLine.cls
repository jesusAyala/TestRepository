/**   
* Apex Class : ClsPISJBPProductLine
* VF Page    : PISJBPProductLine
* Controller for PISJBPProductLine - PIS Tree for Joint Business Plan Product Line
* Release R5
* 
* @author  Indhu Selvi Ramalingam (Accenture)
* @created  24-12-2015
*
*/ 
global with sharing class ClsPISJBPProductLine {

    /**   
    * Controller : ClsPISJBPProductLine - PISNode
    * Release R5
    * 
    */  
    global class PISNode
    {
         public String cid;
         public String englishDescription;
         public String languageSpecificDescription;
    }
    
    /**   
    * Controller : ClsPISJBPProductLine - ProductResult 
    * Release R5
    *  
    */  
    global class ProductResult {
        List<PISNode> failedProducts;
        private Integer processed;
        private Integer failed;
        private Integer total;
        private  boolean success;
        private Id lineItemId;
        /**   
        * Controller : ClsPISJBPProductLine - ProductResult() 
        * Release R5        
        *
        */ 
        public ProductResult() {
            this.processed = 0;
            this.failed = 0;
            this.total = 0;
            this.failedProducts = new List<PISNode>();
        }
    }

    private final Joint_Business_Plan_Product_Lines__c JBPProductLine;
    public String parentId {get;set;}
    public String returnURL {get;set;}
    public Boolean isProductExist{get;set;} 
    public Boolean isSubApproval{get;set;}
    public Boolean showErrmsg{get;set;}
    public Boolean showCanvas{get;set;}
    public String channelQualId = apexpages.currentpage().getparameters().get(System.label.ApexClass_id); // ApexClass_id => 'id'
    
    
 
     
    /**   
    * Controller : ClsPISQualificationProductGroup - Constructor 
    * Release R5      
    */ 
    global ClsPISJBPProductLine (ApexPages.StandardController controller) {
        String controllerName = String.valueOf(controller.getRecord().getSObjectType());
        
            this.JBPProductLine= (Joint_Business_Plan_Product_Lines__c)controller.getRecord();            
            
            returnURL = apexpages.currentpage().getparameters().get(Label.System_CL00045);  //  System_CL00045 => retURL     
            
            parentId = returnURL.replace(Label.System_CL00020 , '');  // System_CL00020 => /
            
            parentId = parentId.substring(0,15);     
            
            List<Joint_Business_Plan_Product_Lines__c> lstJBP = [Select id from Joint_Business_Plan_Product_Lines__c where Joint_Business_Plan__c=: parentId limit 50000 ];
            if(lstJBP != null && lstJBP .size() >0)
            {isProductExist = True;}else {isProductExist = False;}            
            
            List<ProcessInstance> lstProcessInstance = [Select Id, Status, TargetObject.Name , TargetObjectId from ProcessInstance where TargetObjectId  =: parentId and Status =: System.label.ProcessInstance_Status_Pending limit 50000]; // ProcessInstance_Status_Pending => 'Pending'
            if(lstProcessInstance != null && lstProcessInstance.size() >0)
            {isSubApproval = true;}
            else        
            {isSubApproval = False;}
            
            
            if((isProductExist == True || isProductExist == False) && isSubApproval == False )
            {showCanvas = True; showErrmsg = False;}
            
            if((isProductExist == True || isProductExist == False) && isSubApproval == True )
            {showCanvas = False; showErrmsg = True;}
           
            if(isSubApproval )
            {                     
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.System_CL00096));   
            }
        }
        
        
    
    /**   
    * Controller : ClsPISJBPProductLine - GoBack() 
    * Release R5      
    */    
    public Pagereference GoBack()    
    {
        try
        {
            PageReference pageRef = new PageReference(returnURL);
            return pageRef;
        }
        catch(DMLException e){ return null; } 
    }
    
    /**   
    * Controller : ClsPISJBPProductLine - addProducts() 
    * Release R5      
    */  
    @RemoteAction
    global static ProductResult addProducts(ID productQualificationID, List<PISNode> products) {
                
        ProductResult result = new ProductResult();
        
        
        List<Joint_Business_Plan_Product_Lines__c> lstJBPPrds = new List<Joint_Business_Plan_Product_Lines__c>();       
        List<Product2> lstPrds = new List<Product2>();
        Set<String> Pids = new Set<String>();
               
        for (PISNode product : products) {            
            Pids.add(product.cid);           
        }

        try 
        {   
            lstPrds = [Select Id from Product2 where Cid__c in : Pids  limit 50000];
            
            String strJBPId = productQualificationID;  
            
            Set<Id> mapJBP = new Set<Id>(); 
            
            List<Joint_Business_Plan_Product_Lines__c> lstDuplicateCheck = [Select id,Product__c from Joint_Business_Plan_Product_Lines__c
                                where Joint_Business_Plan__c =: productQualificationID limit 50000 ];
           
            if(lstDuplicateCheck.size()>0){
                for(Joint_Business_Plan_Product_Lines__c dupCheck : lstDuplicateCheck){
                    mapJBP.add(dupCheck.Product__c);           
                }           
          }      
            
           if(strJBPId != ''|| strJBPId != null)           
           {          
                for(Product2 p : lstPrds)
               {
                   if(!mapJBP.contains(p.id)){
                       Joint_Business_Plan_Product_Lines__c JBP = new Joint_Business_Plan_Product_Lines__c();
                       JBP.Joint_Business_Plan__c = StrJBPId;
                       JBP.Product__c = p.Id;       
                       lstJBPPrds.add(JBP);                    
                   }
               }               
               
               Database.Insert(lstJBPPrds);  
           
           }
        }
        catch (System.DmlException e) {            
            for (Integer i = 0; i < e.getNumDml(); i++) {
                result.failed++;
                //System.debug(e.getDmlMessage(i));
            }
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