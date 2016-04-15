/**   
* Apex Class : ClsPISChannelMarketCoverageProdLine
* VF Page    : ChannelMarketCoverageProdLinePIS
* Controller for ChannelMarketCoverageProdLinePIS - PIS Tree for Channel Market Coverage Product Line
* Release R5
* 
* @author  Indhu Selvi Ramalingam (Accenture)
* @created  29-12-2015
*
*/ 
global with sharing class ClsPISChannelMarketCoverageProdLine {

    /**   
    * Controller : ClsPISChannelMarketCoverageProdLine - PISNode
    * Release R5
    *  
    * @author  Indhu Selvi Ramalingam (Accenture)
    * @created  29-12-2015
    *
    */  
    global class PISNode
    {
         public String cid;
         public String englishDescription;
         public String languageSpecificDescription;
    }
    
    /**   
    * Controller : ClsPISChannelMarketCoverageProdLine - ProductResult 
    * Release R5
    *  
    * @author  Indhu Selvi Ramalingam (Accenture)
    * @created  29-12-2015
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
        * Controller : ClsPISChannelMarketCoverageProdLine - ProductResult() 
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

    private final Channel_Market_Coverage_Product_Lines__c CMCProductLine;
    public String parentId {get;set;}
    public String returnURL {get;set;}
    public Boolean isProductExist{get;set;} 
    public Boolean showCanvas{get;set;}
    public String channelQualId = apexpages.currentpage().getparameters().get(System.label.System_CL00018);
     
    
    /**   
    * Controller : ClsPISQualificationProductGroup - Constructor 
    * Release R5      
    */ 
    global ClsPISChannelMarketCoverageProdLine (ApexPages.StandardController controller) {
        String controllerName = String.valueOf(controller.getRecord().getSObjectType());
        
            this.CMCProductLine= (Channel_Market_Coverage_Product_Lines__c)controller.getRecord();            
            
            returnURL = apexpages.currentpage().getparameters().get(Label.System_CL00045);  //  System_CL00045 => retURL     
            
            parentId = returnURL.replace(Label.System_CL00020 , '');  // System_CL00020 => /
            
            parentId = parentId.substring(0,15);     
                   
                               
      List<Channel_Market_Coverage_Product_Lines__c> lstCMC = [Select id from Channel_Market_Coverage_Product_Lines__c where Channel_Market_Coverage__c=: parentId limit 50000 ];
            if(lstCMC != null && lstCMC .size() >0)
            {isProductExist = True;}else {isProductExist = False;}            
            
            if(isProductExist == True || isProductExist == False) 
            {showCanvas = True;} 
            
     }   
        
  
    /**   
    * Controller : ClsPISChannelMarketCoverageProdLine - GoBack() 
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
    * Controller : ClsPISChannelMarketCoverageProdLine - addProducts() 
    * Release R5      
    */  
    @RemoteAction
    global static ProductResult addProducts(ID channelMarketCoverageID, List<PISNode> products) {
                
        ProductResult result = new ProductResult();
               
        List<Channel_Market_Coverage_Product_Lines__c> lstCMCPrds = new List<Channel_Market_Coverage_Product_Lines__c>();       
        List<Product2> lstPrds = new List<Product2>();
        Set<String> Pids = new Set<String>();
                       
        for (PISNode product : products) {            
            Pids.add(product.cid);           
        }
                          
        try 
        {   
       //     lstPrds = [Select Id, Name from Product2 where Cid__c in : Pids  limit 50000];
            
            String strCMCId = channelMarketCoverageID;  
             Set<Id> mapChannelPreQual = new Set<Id>(); 
            
            List<Channel_Market_Coverage_Product_Lines__c> lstDuplicateCheck = [Select id,Product__c from Channel_Market_Coverage_Product_Lines__c 
                                where Channel_Market_Coverage__c =: channelMarketCoverageID limit 50000 ];
           //system.debug('----------'+channelMarketCoverageID);
            if(lstDuplicateCheck.size()>0){
                for(Channel_Market_Coverage_Product_Lines__c dupCheck : lstDuplicateCheck){
                    mapChannelPreQual.add(dupCheck.Product__c);           
                }           
            }   
            
           if(strCMCId != ''|| strCMCId != null)           
           {             
                for(Product2 p : [Select Id, Name from Product2 where Cid__c in : Pids  limit 50000])
               {   
                   if(!mapChannelPreQual.contains(p.id)){
                       Channel_Market_Coverage_Product_Lines__c CMC = new Channel_Market_Coverage_Product_Lines__c();               
                       CMC.Channel_Market_Coverage__c = StrCMCId;
                       CMC.Product__c = p.Id;       
                       lstCMCPrds.add(CMC);  
                   }                  
               }                     
               Database.Insert(lstCMCPrds);             
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