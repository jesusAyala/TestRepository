/**   
* Apex Class : ClsPISProductLines
* VF Page    : ProductLinesPIS
* Controller for ProductLinesPIS - PIS Tree for Product Lines
* Release R5
* 
* @author  Indhu Selvi Ramalingam (Accenture)
* @created  29-12-2015
*
*/ 
global with sharing class ClsPISProductLines {

    /**   
    * Controller : ClsPISProductLines - PISNode
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
    * Controller : ClsPISProductLines - ProductResult 
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
        * Controller : ClsPISProductLines - ProductResult() 
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

    private final Product_Lines__c productLines;
    public String parentId {get;set;}
    public String returnURL {get;set;}
    public Boolean isProductExist{get;set;} 
    public Boolean showCanvas{get;set;}
    public String channelQualId = apexpages.currentpage().getparameters().get(Label.ApexClass_id);
    
    
 
     
    /**   
    * Controller : ClsPISQualificationProductGroup - Constructor 
    * Release R5      
    */ 
    global ClsPISProductLines (ApexPages.StandardController controller) {
        String controllerName = String.valueOf(controller.getRecord().getSObjectType());
        
            this.productLines= (Product_Lines__c)controller.getRecord();            
            
            returnURL = apexpages.currentpage().getparameters().get(Label.System_CL00045);  //  System_CL00045 => retURL     
            
            parentId = returnURL.replace(Label.System_CL00020 , '');  // System_CL00020 => /
            
            parentId = parentId.substring(0,15);     
            
            List<Product_Lines__c> lstProdLine = [Select id from Product_Lines__c where Contact__c =: parentId limit 50000 ];
            if(lstProdLine != null && lstProdLine .size() >0)
            {isProductExist = True;}else {isProductExist = False;}            
            
            if(isProductExist == True || isProductExist == False) 
            {showCanvas = True;} 
            
        }
        
        
    
    /**   
    * Controller : ClsPISProductLines - GoBack() 
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
    * Controller : ClsPISProductLines - addProducts() 
    * Release R5      
    */  
    @RemoteAction
    global static ProductResult addProducts(ID contactID, List<PISNode> products) {
                
        ProductResult result = new ProductResult();
        
        
        List<Product_Lines__c> lstProdLinePrds = new List<Product_Lines__c>();       
        List<Product2> lstPrds = new List<Product2>();
        Set<String> Pids = new Set<String>();
               
        for (PISNode product : products) {            
            Pids.add(product.cid);           
        }

        try 
        {   
            lstPrds = [Select Id, Name from Product2 where Cid__c in : Pids  limit 50000];
            
            String strProdLineId = contactID;   
            
            Set<Id> mapProdLine = new Set<Id>(); 
            
            List<Product_Lines__c> lstDuplicateCheck = [Select id, Product__c from Product_Lines__c
                                where Contact__c =: contactID limit 50000 ];
          
            if(lstDuplicateCheck.size()>0){
                for(Product_Lines__c dupCheck : lstDuplicateCheck){
                    mapProdLine.add(dupCheck.Product__c);           
                }  
              }             
                    
           if(strProdLineId != ''|| strProdLineId != null)           
           {          
                for(Product2 p : lstPrds)
               {
                   if(!mapProdLine.contains(p.id)){
                       Product_Lines__c PL = new Product_Lines__c();
                       PL.Contact__c = StrProdLineId;                   
                       PL.Product__c = p.Id;       
                       lstProdLinePrds.add(PL);   
                   }                 
               }               
               
               Database.Insert(lstProdLinePrds);  
           
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