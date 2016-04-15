/**   
* Controller : PISProductQualificationExtension 
* Release R4
*  
* @author  MohanRaj Kasinathan (Accenture)
* @created  2015-09-08* @version 1.0
*
*/ 
global with sharing class PISProductQualificationExtension {

    /**   
    * Controller : PISProductQualificationExtension - PISNode
    * Release R4
    *  
    * @author  MohanRaj Kasinathan (Accenture)
    * @created  2015-09-08* @version 1.0
    *
    */  
    global class PISNode
    {
         public String cid;
         public String englishDescription;
         public String languageSpecificDescription;
    }
    
    /**   
    * Controller : PISProductQualificationExtension - ProductResult 
    * Release R4
    *  
    * @author  MohanRaj Kasinathan (Accenture)
    * @created  2015-09-08* @version 1.0
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
        * Controller : PISProductQualificationExtension - ProductResult() 
        * Release R4        
        *
        */ 
        public ProductResult() {
            this.processed = 0;
            this.failed = 0;
            this.total = 0;
            this.failedProducts = new List<PISNode>();
        }
    }

    private final Qualification_Products_List__c QualificationProdList;
    public String parentId {get;set;}
    public String returnURL {get;set;}
    public Boolean isProductExist{get;set;} 
    public Boolean isSubApproval{get;set;} 
    public Boolean isNotQualified{get;set;} 
    public Boolean showCanvas{get;set;}
    public Boolean showErrmsg{get;set;}
 
     
    /**   
    * Controller : PISProductQualificationExtension - Constructor 
    * Release R4      
    */ 
    global PISProductQualificationExtension(ApexPages.StandardController controller) {
        String controllerName = String.valueOf(controller.getRecord().getSObjectType());
        
            this.QualificationProdList= (Qualification_Products_List__c)controller.getRecord();            
            
            returnURL = apexpages.currentpage().getparameters().get(Label.System_CL00045);         
            
            parentId = returnURL.replace(Label.System_CL00020 , '');  
            
            parentId = parentId.substring(0,15);   
           
            List<Qualification_Products_List__c> lstQualPrds = [Select id from Qualification_Products_List__c where Product_Qualification__c =: parentId limit 50000 ];
            if(lstQualPrds != null && lstQualPrds.size() >0)
            {isProductExist = True;}else {isProductExist = False;}            
            
            List<ProcessInstance> lstProcessInstance = [Select Id, Status, TargetObject.Name , TargetObjectId from ProcessInstance where TargetObjectId  =: parentId  and Status ='Pending'  limit 50000];
            if(lstProcessInstance != null && lstProcessInstance.size() >0)
            {isSubApproval = true;}
            else        
            {isSubApproval = False;}
            
            List<Product_Qualification__c > lstPQ = [Select Id , Name , Initiative_Status__c from Product_Qualification__c where Initiative_Status__c != 'Open' and id =:parentId  limit 50000 ];
            if(lstPQ != null && lstPQ.size() >0)
            { isNotQualified = True;}
            else        
            { isNotQualified = False;}
            
            if(isProductExist == True || isSubApproval == True || isNotQualified == True )
            {showCanvas = False; showErrmsg = True;}
            
            if(isProductExist == False && isSubApproval == False && isNotQualified == False )
            {showCanvas = True;}
            
            system.debug('MR::'+parentId +'::'+ isProductExist  +'::'+ isSubApproval  +'::'+ isNotQualified);
            
            if(isProductExist) 
            {      
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.System_CL00084));                
            }
            if(isSubApproval )
            {     
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.System_CL00096));                
            }            
            if(isNotQualified )
            {     
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.System_CL00092));                 
            }            
            
        }
    
    /**   
    * Controller : PISProductQualificationExtension - GoBack() 
    * Release R4      
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
    * Controller : PISProductQualificationExtension - addProducts() 
    * Release R4      
    */  
    @RemoteAction
    global static ProductResult addProducts(ID productQualificationID, List<PISNode> products) {
                
        ProductResult result = new ProductResult();
        
        List<Qualification_Products_List__c> lstQualificationPrds = new List<Qualification_Products_List__c>();       
        List<Product2> lstPrds = new List<Product2>();
        Set<String> Pids = new Set<String>();
               
        for (PISNode product : products) {            
            Pids.add(product.cid);           
        }

        try 
        {   
            lstPrds = [Select Id from Product2 where Cid__c in : Pids  limit 50000];
            
            String strProdQualificationId =productQualificationID;       
            
           if(strProdQualificationId != ''|| strProdQualificationId != null)           
           {          
                for(Product2 p : lstPrds)
               {
                   Qualification_Products_List__c  QPL = new Qualification_Products_List__c();
                   QPL.Product_Qualification__c = StrProdQualificationId;
                   QPL.Product__c = p.Id;       
                   lstQualificationPrds.add(QPL);                    
               }               
               
               Database.Insert(lstQualificationPrds);  
           
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