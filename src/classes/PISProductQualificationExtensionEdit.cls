/**   
* Controller : PISProductQualificationExtensionEdit
* Release R4
*  
* @author  MohanRaj Kasinathan (Accenture)
* @created  2015-09-08* @version 1.0
*
*/ 
global with sharing class PISProductQualificationExtensionEdit {

    /**   
    * Controller : PISProductQualificationExtensionEdit - PISNode
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
    * Controller : PISProductQualificationExtensionEdit - ProductResult 
    * Release R4
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
        * Controller : PISProductQualificationExtensionEdit - ProductResult()
        * Release R4        
        */ 
        global ProductResult() {
            this.processed = 0;
            this.failed = 0;
            this.total = 0;
            this.failedProducts = new List<PISNode>();
        }
    }

    private final Qualification_Products_List__c QualificationProdList;
    public String parentId  {get;set;}
    public String returnURL {get;set;}
    public String PId{get;set;}
    public Boolean isSubApproval{get;set;} 
    public Boolean isNotQualified{get;set;} 
    public Boolean isNotMember{get;set;} 
    public Boolean showCanvas{get;set;}
    public Boolean showErrmsg{get;set;}
    
    /**   
    * Controller : PISProductQualificationExtensionEdit - constructor
    * Release R4  
          
    */
    global PISProductQualificationExtensionEdit(ApexPages.StandardController controller) {
        String controllerName = String.valueOf(controller.getRecord().getSObjectType());
        
        String id = apexpages.currentpage().getparameters().get(Label.System_CL00080); 
        
        if( id != null && id != '')
        {        
            this.QualificationProdList= (Qualification_Products_List__c)controller.getRecord();            
            
            returnURL = '/'+id;      
            parentId  = id;             
        }
        
        List<Qualification_Products_List__c> lstQualPrds = [Select id, Product_Qualification__c from Qualification_Products_List__c where Id =: parentId limit 50000 ];
        if(lstQualPrds != null && lstQualPrds.size() >0)
        {PId = lstQualPrds[0].Product_Qualification__c;}  
        
    //  Added by Abiramasundari Radha
        Set<Id> prodQualSet = new Set<Id>();
        Id currentLoggedInUserId = Userinfo.getUserid(); 
        Id systemAdminProfileId = Userinfo.getProfileid();
        Id labelId = Label.CL00075;
        for(Qualification_Products_List__c qualProd : lstQualPrds){
            prodQualSet.add(qualProd.Product_Qualification__c);            
        } 
        
      List<Product_Qualification_Team_Role__c> prodQualTeamList = [SELECT Id,User__c,Product_Qualification__c FROM Product_Qualification_Team_Role__c WHERE Product_Qualification__c IN :prodQualSet];
        isNotMember = False;       
        if(prodQualTeamList != null && prodQualTeamList.Size()>0){
            for(Product_Qualification_Team_Role__c teamMember : prodQualTeamList ){
            
                if(teamMember.User__c == currentLoggedInUserId){
                    isNotMember = True;   
                    break;    
                }            
            }        
        }
        
         List<Product_Qualification__c > listProdQual = [Select Id , Name , Initiative_Status__c,OwnerID from Product_Qualification__c where id =:PId limit 50000 ];
           
            Map<Id,Id> mapPrdQualOwnerID = new Map<Id,Id>();                               
            List<ProcessInstance> lstProcessInstance = [Select Id, Status, TargetObject.Name , TargetObjectId from ProcessInstance where TargetObjectId  =: PId and Status ='Pending'  limit 50000];
            if(lstProcessInstance != null && lstProcessInstance.size() >0)
            {isSubApproval = true;}
            else        
            {isSubApproval = False;}
            
            List<Product_Qualification__c > lstPQ = [Select Id , Name , Initiative_Status__c,OwnerID from Product_Qualification__c where Initiative_Status__c != 'Open' and id =:PId limit 50000 ];
                                    
              for(Product_Qualification__c ap : listProdQual){
                mapPrdQualOwnerID.put(ap.OwnerID,ap.ID);
              } 
            
            
            if(lstPQ != null && lstPQ.size() >0)
            { isNotQualified = True;}
            else        
            { isNotQualified = False;}
                        
            if(isSubApproval == True || isNotQualified == True )
            {showCanvas = False; showErrmsg = True;}
            
            if(isSubApproval == False && isNotQualified == False)
            {showCanvas = True;}          
                        
            if(isSubApproval )
            {     
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.System_CL00096));                
            }            
            if(isNotQualified )
            {     
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.System_CL00092));                 
            } 
            
            if((!isNotMember && !mapPrdQualOwnerID.containsKey(currentLoggedInUserId) && labelid !=systemAdminProfileId))
            {   
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CL00019));                 
            }   
            
            if(showCanvas == true && isNotMember == False && (labelid !=systemAdminProfileId && !(mapPrdQualOwnerID.containsKey(currentLoggedInUserId))))
            {
                showCanvas = False;
            }  
            
            if(showCanvas)
            {showErrmsg  = False;}
            else
            {showErrmsg  = True;}
            
            
        
        }
    
    /**   
    * Controller : PISProductQualificationExtensionEdit - GoBack()
    * Release R4  
          
    */    
    public Pagereference GoBack()    
    {
            PageReference pageRef = new PageReference(returnURL);
            return pageRef;
    }
    
    /**   
    * Controller : PISProductQualificationExtensionEdit - replaceProduct
    * Release R4  
          
    */
    @RemoteAction
    global static ProductResult replaceProduct(ID productQualificationID, PISNode newProduct) {  
        
        ProductResult result = new ProductResult();

        try 
        {   
            Product2[] Prd  = [Select Id from Product2 where Cid__c =: newProduct.cid];            
            String StrProdQualificationId = productQualificationID;                          
            Qualification_Products_List__c[] QP = [Select Id, Product__c from Qualification_Products_List__c where id =: productQualificationID limit 50000];            
            if(QP[0].Product__c != Prd[0].Id)           
            {QP[0].ABB_Location__c = null;}
            QP[0].Product__c = Prd[0].Id;   
            QP[0].Hidden_IsProductChanged__c = True;       
            Database.Update(QP);
           
        }
        catch (System.DmlException e) {            
            for (Integer i = 0; i < e.getNumDml(); i++) {
                result.failed++;
                System.debug(e.getDmlMessage(i));
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