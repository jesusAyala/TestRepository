/*************************************************************
@Name: APTS_ConfigProductsCustomController
@Author: Ganga Vemula
@CreateDate: 5th sep 2015.
@Description: This class is to implement custom product selection requirements
@UsedBy: 
******************************************************************/
   
  public with sharing class APTS_ConfigProductsCustomController{
        
       //category tree wrapper
       public list<CategoryTreeWrapper> categorytreewrapperlist {get; set;}
       //selected category Id
       public Id SelectedcategoryId {get; set;}
       //product config id
       public Id ConfigId;
       //temp obj Id
       public Id configRequestId;
       //flow name
       public string FlowName;
       //price list id
       public Id pricelistId;
       Integer queryLimit;
       Integer offset;
       public Boolean firstOff{set;get;}    // previous part
       public Boolean lastOff{set;get;}     // next part
       public String limits{set;get;}
       public Integer pageNumber{set;get;}
       //list of resulted products for selected category
       public List<ProductWrapperClass> wrapproductList {get; set;} 
       //selected product Id to add to cart
       public Id standAloneBundleId {get; set;}
       public string browsestring {get; set;}
       public string HierarchyLevel {get; set;}
       public list<Apttus_Config2__LineItem__c> Configbundlelines;
       public map<string,string> CategoryCodeMap {get; set;}
       //list of resulted products for selected category
       // search category items
       public List<SelectOption> searchCategoryItems{get; set;}
       private static string CATEGORY_ALL_PRODUCTS='All Products';
       private static string CATEGORY_ALL_CATEGORIES='All Categories';
       private static string CATEGORY_ES_HIERARCHY='ES - Hierarchy';
       private static string LOCAL_HIERARCHY='Local Hierarchy';
       private static string LOCAL_PRODUCTS='Local Products';
       private static string ID = 'Id';
       private static string COFIG_REQUEST_ID = 'configRequestId';
       private static string FLOW = 'flow';
       
       // search category 
       public String searchCategory {get; set;}
       // search text 
       private String searchText = null;
       //quote Id 
       public Id QuoteId {get; set;}
       //quote name
       public string Quotename {get; set;}
       //check if it is a place holder quote
       public boolean isPlaceHolderQuote {get; set;}
       //opportunity Id
       public Id opptyId {get; set;}
       
       //approval status
       public string ApprovalStatus{get; set;}
       public string Proposalname{get; set;}
       public Decimal CartSize{get; set;}
       //category id to be added to cart
       public string CategoryId{get; set;}
       public map<Id,Id> Selectedbundlesmap=new map<Id,Id>();
       public Apttus_Config2__ProductConfiguration__c ProdConfigSobj {get; set;}
       
       // Agreement number (MSPA identifier)
       public string agreementNumber {get; set;}
       
       
       
       //for total product size
       Integer listSize;
       String queryString;   
       set<Id> productIds=new set<Id>();    
    
        //added by Axay - Fix for 2035
        Map<String, String> mapCategoryId = new Map<String, String>();
        
        //constructor     
        public APTS_ConfigProductsCustomController(){
          
          //get configuration Id          
          ConfigId=Apexpages.Currentpage().getparameters().get(ID);
          //get temp bject Id
          configRequestId=Apexpages.Currentpage().getparameters().get(COFIG_REQUEST_ID);
          //get flow name
          FlowName=Apexpages.Currentpage().getparameters().get(FLOW);
          system.debug('config Id***'+ConfigId);
          //get product config record
          ProdConfigSobj=[select Id,Apttus_CMConfig__AgreementId__r.APTS_SAP_Reference_No__c, Apttus_CMConfig__AgreementId__r.Apttus__Status__c,Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__c,Apttus_QPConfig__Proposald__r.APTS_Is_Placeholder_Quote__c,APTS_Cart_Size__c,Apttus_CMConfig__AgreementId__r.Apttus__FF_Agreement_Number__c,Apttus_CMConfig__AgreementId__r.APTS_Hierarchy_level__c,Apttus_QPConfig__Proposald__r.APTS_Hierarchy_level__c,Apttus_CMConfig__AgreementId__r.Apttus_Approval__Approval_Status__c,Apttus_CMConfig__AgreementId__c,Apttus_CMConfig__AgreementId__r.name,Apttus_QPConfig__Proposald__r.Apttus_Proposal__Proposal_Name__c,Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c,Apttus_QPConfig__Proposald__r.name,Apttus_QPConfig__Proposald__c,Apttus_Config2__PriceListId__c from Apttus_Config2__ProductConfiguration__c where Id=:ConfigId limit 1];
          //pricelist id
          pricelistId=ProdConfigSobj.Apttus_Config2__PriceListId__c;
          
          if(!string.isEmpty(ProdConfigSobj.Apttus_QPConfig__Proposald__c)){
              //quote id
              QuoteId =ProdConfigSobj.Apttus_QPConfig__Proposald__c;
              //is place holder quote
              isPlaceHolderQuote=ProdConfigSobj.Apttus_QPConfig__Proposald__r.APTS_Is_Placeholder_Quote__c;
              //opportunity Id
              opptyId =ProdConfigSobj.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__c;
              //proposal name
              Quotename=ProdConfigSobj.Apttus_QPConfig__Proposald__r.name;
              Proposalname=ProdConfigSobj.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Proposal_Name__c;
              //proposal's approval status
              //ApprovalStatus=ProdConfigSobj.Apttus_QPConfig__Proposald__r.Apttus_QPApprov__Approval_Status__c;
              ApprovalStatus=ProdConfigSobj.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c;
              //get hierarchy level
              HierarchyLevel=ProdConfigSobj.Apttus_QPConfig__Proposald__r.APTS_Hierarchy_level__c;
          }else if(!string.isEmpty(ProdConfigSobj.Apttus_CMConfig__AgreementId__c)){
               //agreement id
              QuoteId =ProdConfigSobj.Apttus_CMConfig__AgreementId__c;
              //agreement name
              Quotename=ProdConfigSobj.Apttus_CMConfig__AgreementId__r.name;
              
              //agreementNumber = ProdConfigSobj.Apttus_CMConfig__AgreementId__r.Apttus__FF_Agreement_Number__c;
              agreementNumber = ProdConfigSobj.Apttus_CMConfig__AgreementId__r.APTS_SAP_Reference_No__c;
              Proposalname='';
              //agreement's approval status
              ApprovalStatus = ProdConfigSobj.Apttus_CMConfig__AgreementId__r.Apttus__Status__c;
              //ApprovalStatus=ProdConfigSobj.Apttus_CMConfig__AgreementId__r.Apttus_Approval__Approval_Status__c;
              //get hierarchy level
              HierarchyLevel=ProdConfigSobj.Apttus_CMConfig__AgreementId__r.APTS_Hierarchy_level__c;
          }
          //cart size
          CartSize=ProdConfigSobj.APTS_Cart_Size__c;
         
          //set pagination initial values
          firstOff = false;
          queryLimit = 100;
          offset = 0;
          limits = '100';
          pageNumber = 1;
          listSize = 100;
          //initialy check page more then 1 or not
          if(listSize > queryLimit){
             lastOff = true; 
          } else{
             lastOff = false; 
          } 
          
        }    
         
       /**
        @ Gets the search text
        @return the search text 
       */
        public String getSearchText() {
           return this.searchText;
        
        }
      
        /**
         @Sets the search text
         @param searchText the search text 
        */
        public void setSearchText(String searchText) {
           this.searchText = searchText;
        
        }
       
        /*
         @Method to get category structure
         @This method returns all levels of categories configured in system
         @We are catching all those different levels of categories from VF page and repeating them.
         @param: None
        */       
        public void setCategoryList(){
           
           set<Id> CategoryIds=new set<Id>();
           CategoryCodeMap=new map<string,string>();
           categorytreewrapperlist=new list<CategoryTreeWrapper>();
           // create category list
           searchCategoryItems=new list<selectoption>();
           
           Apttus_CPQApi.CPQ.CategorySearchResultDO result =Apttus_CPQApi.CPQWebService.getCategoriesForPriceList(pricelistid);
           
            try{  
                   //loop through parent categories that are returned by API, level 1
                   for( Apttus_CPQApi.CPQ.CategoryDO catresult : result.Categories)
                   { 
                      
                      //add category ids to get the "Hierarchy Code" to be displayed in tree structure.
                      CategoryIds.add(catresult.CategoryId);
                      //add parent categories to wrapper list which is being used in VF page
                      categorytreewrapperlist.add(new CategoryTreeWrapper(catresult,catresult.ChildCategories));
                      
                      
                       //If a category has sub categories fetch the sub-category name and id       
                       if(catresult.HasChildCategories){
                           
                           //loop through child categories, level 2
                           for( Apttus_CPQApi.CPQ.CategoryDO subcatresult : catresult.ChildCategories){
                               
                               //add category names and filter ES-Hierarchy as it is just a holder category
                               if(subcatresult.Name != CATEGORY_ES_HIERARCHY){
                                    //add category ids to get the "Hierarchy Code" to be displayed in tree structure.
                                    CategoryIds.add(subcatresult.CategoryId);
                                   //add levele 2 category names to a list to show on search browsing 
                                    searchCategoryItems.add(new SelectOption(subcatresult.Name, subcatresult.Name));
                                    mapCategoryId.put(subcatresult.Name, subcatresult.CategoryId);
                                }
                                
                                 //get level3 category ids
                                 for( Apttus_CPQApi.CPQ.CategoryDO subsubcatresult : subcatresult.ChildCategories){
                                   
                                    //add category ids to get the "Hierarchy Code" to be displayed in tree structure.
                                    CategoryIds.add(subsubcatresult.CategoryId);
                                    
                                    //get level 4 category Ids
                                    for( Apttus_CPQApi.CPQ.CategoryDO subsubsubcatresult : subsubcatresult.ChildCategories){
                                         //add category ids to get the "Hierarchy Code" to be displayed in tree structure.
                                         CategoryIds.add(subsubsubcatresult.CategoryId);
                                    }
                                    
                                 }
                                
                                system.debug('search category items***'+subcatresult.Name);
                          }
                          
                        }
                        
                     }
                  
                     
                     //get category hierarchies to retrieve Hierarchy code to show in tree structure on UI
                    list<Apttus_Config2__ClassificationHierarchy__c> CategoryHierarchies=[select Id,name,APTS_LP_Code__c from Apttus_Config2__ClassificationHierarchy__c where Id IN: CategoryIds LIMIT 1000];
                    
                    
                    //put the hierarchy code in a map and access that map from VF page to show on tree structure
                    for(Apttus_Config2__ClassificationHierarchy__c hierarchy : CategoryHierarchies){
                     
                         if(hierarchy.APTS_LP_Code__c != null){
                              CategoryCodeMap.put(hierarchy.Id,hierarchy.APTS_LP_Code__c);
                          }else{//if hierarchy code is null, put blank value to handle map error in VF page
                              CategoryCodeMap.put(hierarchy.Id,'');
                          }
                      
                    }
                    
                    
              }catch(Exception e){
                  
                  system.debug('*****some exception occured'+e.getmessage());
              }
               // All Categories
               searchCategoryItems.add(new SelectOption(CATEGORY_ALL_CATEGORIES,CATEGORY_ALL_CATEGORIES));
               // All Products
               searchCategoryItems.add(new SelectOption(CATEGORY_ALL_PRODUCTS,CATEGORY_ALL_PRODUCTS));
               system.debug('searchCategoryItems222***'+searchCategoryItems.size());
               // sort the search categories
               searchCategoryItems.sort();
              
        }
        
       
        /*
        @Get the list of products for selected category
        @This method returns, all the products of selected category
        @ Returned list will be shown on catalog page
        @Param: None
        */
        public void getCategoryProductList(){
               
               string ProductName;        
               productIds=new set<Id>();
               
               wrapproductList= new List<ProductWrapperClass>();
               //to provide tab space between product code and name on UI
               String tabSpace = '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
               wrapproductList.clear();
               
                 try{  
                       //check if selected category Id is not null
                       if(!string.isEmpty(SelectedcategoryId)){
                           
                         /*  //Pass the pricelistID and categoryID as parameters to the API to get list of products configured under it
                           Apttus_CPQApi.CPQ.ProductSearchResultDO productResult=Apttus_CPQApi.CPQWebService.getProductsForPriceListCategory(priceListId,SelectedcategoryId);*/
                           
                     // do this to get the product filter expression for the cart
                      String prodFilterExpr = Apttus_Config2.CPQWebService.createProductFilterExprForCart(configId);
                     
                      //Pass the pricelistID and categoryID as parameters to the API to get list of products configured under it
                      Apttus_CPQApi.CPQ.ProductSearchResultDO productResult = Apttus_CPQApi.CPQWebService.getProductsWithCategoryAndText (priceListId, new ID[]{SelectedcategoryId}, null, null, null, prodFilterExpr, null);

                                      
                                        
                           for(Apttus_CPQApi.CPQ.ProductDO catresult : productResult.Products){
                              system.debug('catresult.ProductId***'+catresult.ProductId);
                                  productIds.add(catresult.ProductId);
                            }
                            
                            //query string for pagination
                            queryString = 'Select Id,name,APTS_Product_ID__c from product2';
                            // fill size of all products
                            listSize = productIds.size();
                            
                            //query string with additional conditions            
                            string qrystrng=queryString+ ' where id IN: productIds ORDER BY Name ASC LIMIT '+queryLimit+' OFFSET '+offset;
                            system.debug('qry strng**'+qrystrng);
                            //get products from selected category
                            list<Product2> Resultedprdlist=database.query(qrystrng);
                           
                            for(product2 prd: Resultedprdlist) {
                                
                             //remove null value if there is no product code.
                             if(!string.isEmpty(prd.APTS_Product_ID__c)){
                                 //product name should be like [Product Id]+tab space+[Name]
                                 ProductName=prd.APTS_Product_ID__c+ tabSpace +prd.name;
                             }else{
                                 //if there is no product Id, just pass product name
                                 ProductName=prd.name;
                             }
                             
                             // As each product is processed we create a new wrapAccount object and add it to the wrapprdList
                             wrapproductList.add(new ProductWrapperClass(prd.Id,ProductName));
                            }
                            
                       } 
                   
                  }catch(exception e){
                      
                         system.debug('****some exception occured'+e.getmessage());
                  }    
                     system.debug('wraplist***'+wrapproductList.size());
                     
                     
                     //show "product selected" notification once product is added to cart on catalog page
                     SelectedNotification();
        }
        
        /*
        @Method to add multi selected products
        @User can select multiple products through catalog page, this method is to add them to cart at a time
        @param:None
        */
        public pagereference addMultiProducts(){
        
             List <Apttus_CPQApi.CPQ.SelectedProductDO> selectedProdDOList = new List<Apttus_CPQApi.CPQ.SelectedProductDO>();
             system.debug('***8wrapproductList'+wrapproductList.size());
             
             try{
                 //get all selected products through UI and add them to cart using API
                 for(ProductWrapperClass selProdWrap: wrapproductList)
                 {     
                      if(selProdWrap.IsSelected)
                      {    //make an API call for selected products to add to cart
                           Apttus_CPQApi.CPQ.SelectedProductDO selProdDO = new Apttus_CPQApi.CPQ.SelectedProductDO();
                           
                           
                           selProdDO.ProductID = selProdWrap.ProductId;
                           selectedProdDOList.add(selProdDO);
                           
                           selProdWrap.IsSelected=false;
                           
                           
                      }
                      
                 }
                 
                 //If the customer has selected one product execute the if condition
                 system.debug('***selectedProdDOList'+selectedProdDOList.size());
                 if(selectedProdDOList.size()>0)
                 {
                  
                  Apttus_CPQApi.CPQ.AddMultiProductRequestDO request = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO ();
                  request.CartId = ConfigId;
                  request.SelectedProducts = selectedProdDOList;
                  //API call to add multiple products to cart
                  Apttus_CPQApi.CPQ.AddMultiProductResponseDO response =Apttus_CPQApi.CPQWebService.addMultiProducts(request);
                  
                 }
                 //If the customer has not selected any product and clicks Add to Cart execute the else condition
                 else {      
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.warning, Label.APTS_Catalog_Product_Select));  
                    return null;
                 }
                 
                 //show "product selected" notification once product is added to cart on catalog page
                 SelectedNotification();
            }catch(exception e){
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.warning, Label.APTS_Catalog_Product_Select));  
            }
            return null;
        }
        
        /*
        @Method to add standalone products to cart
        @This method handles adding product by hitting "Add to Cart" button next to it, also to add individual category product.
        @If there are any bundles, on clicking "Configure" button we need to redirect to attribute/option selection page, system will take care of pricing.
        @param:None
        */
        public pagereference addStandaloneBundles(){
                
            Product2 categoryprdt=new Product2();
            Apttus_Config2__ClassificationHierarchy__c SelectedHierarchy;
            
            //Category id will be returned by VF page when user hit on "Add To Cart" button next to each category.
            if(!string.isEmpty(CategoryId)){
               
                //query needed to get the selected category fields to compare with corresponding product exist in system and add it to cart
                SelectedHierarchy=[select Id,name,APTS_LP_Code_Full_Hierarchy__c from Apttus_Config2__ClassificationHierarchy__c where Id=:CategoryId Limit 1];
                
                try{
                  
                       //get the product from system which is with same category name added by user
                       categoryprdt=[select Id,name from product2 where name=:SelectedHierarchy.name AND APTS_LP_Is_Hierarchy__c=True AND RecordTypeId in (SELECT Id FROM RecordType WHERE Name = 'Local Hierarchy') AND APTS_LP_Product_Hierarchy__c=:SelectedHierarchy.APTS_LP_Code_Full_Hierarchy__c limit 1];
                        
                        //Start: Added By Kruti Shah (Req#103)
                        list<Apttus_Config2__LineItem__c> ListOfLineItems = [select Id,name,Apttus_Config2__ProductId__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c=:ConfigId AND Apttus_Config2__LineType__c='Product/Service' AND Apttus_Config2__IsPrimaryLine__c=true limit 1000];
                        for(Apttus_Config2__LineItem__c line : ListOfLineItems)
                        {
                            
                            if(line.Apttus_Config2__ProductId__c == categoryprdt.ID)
                            {
                                system.debug('KS--> If condition matching');
                                ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.WARNING, categoryprdt.name+' already exist on cart');
                                ApexPages.addMessage(errMsg);
                                return null;
                            }
                        }
                        //End: Added By Kruti Shah (Req#103)
                    
                } catch (Exception e) {
                     //through an exception if selected category doesnot exist in system.
                     ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.warning, SelectedHierarchy.name+' does not exist');
                     ApexPages.addMessage(errMsg);
                     return null;
                }
            }
            
            //same condition is to handle while adding product from "Add to cart" button next to it, also to add category to cart
            //check if the category product exist in system
            if(!string.isEmpty(standAloneBundleId) || !string.isEmpty(categoryprdt.id)){
                
                Apttus_CPQApi.CPQ.AddMultiProductRequestDO requests = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO ();
                //assign cart Id
                requests.CartId = ConfigId;
                requests.SelectedProducts = new List<Apttus_CPQApi.CPQ.SelectedProductDO>();
                //get productDo
                Apttus_CPQApi.CPQ.SelectedProductDO prodDO = new Apttus_CPQApi.CPQ.SelectedProductDO();
                
                if(!string.isEmpty(standAloneBundleId)){
                    prodDO.ProductId = standAloneBundleId;
                }
                else if(!string.isEmpty(categoryprdt.id)){
                    prodDO.ProductId = categoryprdt.id;
                }
                
                requests.SelectedProducts.add(prodDO);
             
                system.debug('request****'+requests);
                //add products to cart
                Apttus_CPQApi.CPQ.AddMultiProductResponseDO response = Apttus_CPQApi.CPQWebService.addMultiProducts(requests);
            }
            
            //show information once product successfullt added to cart
            if(!string.isEmpty(categoryprdt.Id) && !string.isEmpty(SelectedHierarchy.Id)){                
                ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.info, SelectedHierarchy.name+' added to cart');
                ApexPages.addMessage(errMsg);
                return null;
             }
           
            //show selected notification on catalog page                       
             SelectedNotification();
             
             return null;
        }

     
            
        /**
        @ Performs the search prodcts with text action
        @ This method allows us to serach the products with name and code
        @ It returns list of products match the search criteria. 
        */
        public pagereference doSearchProductsWithText() {
               //query string
               //ORIGINAL queryString = 'Select Id,name,APTS_Product_ID__c,APTS_Hierarchy_Level_4_Code__c,APTS_Hierarchy_Level_3_Code__c,Recordtype.Name, APTS_LP_Distribution_Channel__c, APTS_LP_Sales_Organization__c, APTS_Hierarchy_Level__c, APTS_LP_Is_Hierarchy__c  from product2';
               
              // Added by Vamsi to support search for below mentioned fields as well - e.g. APTS_ProductType__c,APTS_Product_ID__c,APTS_Product_Type_ID__c
              queryString = 'Select Id,name,ProductCode,APTS_ProductType__c,APTS_Product_ID__c,APTS_Product_Type_ID__c,APTS_Hierarchy_Level_4_Code__c,APTS_Hierarchy_Level_3_Code__c,Recordtype.Name, APTS_LP_Distribution_Channel__c, APTS_LP_Sales_Organization__c, APTS_Hierarchy_Level__c, APTS_LP_Is_Hierarchy__c  from product2';

               set<id> prdids=new set<Id>();
               string ProductName;
               String tabSpace = '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
          
             try{
               
                   //clear wrapper list before we add new set of resulted values
                   if(wrapproductList != null){
                       wrapproductList.clear();
                   }
                   
                   //check if search text is not null
                    if (!nullOrEmpty(searchCategory) && !nullOrEmpty(searchText)) {
                      
                      //set browse string
                      browsestring='(Search: '+ searchText+')';
                      System.debug('AXAY: Cat Id: '+mapCategoryId.get(searchCategory));
                         // get products for the category with text
                          /* Apttus_CPQApi.CPQ.ProductSearchResultDO result = 
                            Apttus_CPQApi.CPQWebService.getProductsWithText(PricelistId, 
                                                    searchCategory,
                                                    searchText.trim(),
                                                    null,
                                                    null,
                                                    null,
                                                    null); */
                       /*Apttus_CPQApi.CPQ.ProductSearchResultDO result = 
                                Apttus_CPQApi.CPQWebService.getProductsForSearchText(PricelistId, searchText.trim());*/
                                
                       /*  Apttus_CPQApi.CPQ.ProductSearchResultDO result=Apttus_CPQApi.CPQWebService.getProductsForCategorySearchText(PricelistId, 
                                                                    null, 
                                                                    searchText.trim());*/
                                                                    
                      //Get pricelist category to get root category
                      Apttus_Config2__PriceListCategory__c priceListCategory=[select Id,name,Apttus_Config2__PriceListId__c,Apttus_Config2__HierarchyId__c from Apttus_Config2__PriceListCategory__c where Apttus_Config2__PriceListId__c=:priceListId limit 1];                                             
                      //get root category
                      Apttus_Config2__ClassificationHierarchy__c rootCategoryHierarchy=[select Id,Apttus_Config2__HierarchyId__c from Apttus_Config2__ClassificationHierarchy__c where Apttus_Config2__HierarchyId__c=:priceListCategory.Apttus_Config2__HierarchyId__c AND Apttus_Config2__Level__c=0 AND Apttus_Config2__AncestorId__c=NULL AND Apttus_Config2__PrimordialId__c=NULL limit 1];
                      
                      system.debug('root Id##'+rootCategoryHierarchy.Id);
                     // do this to get the product filter expression for the cart
                      String prodFilterExpr = Apttus_Config2.CPQWebService.createProductFilterExprForCart(configId);
                      
                      system.debug('###pricelistid'+priceListId+'::::'+searchText.trim()+':::'+prodFilterExpr);
                      //Pass the pricelistID and categoryID as parameters to the API to get list of products configured under it
                      
                      String categoryToLookup = mapCategoryId.get(searchCategory) != null ? mapCategoryId.get(searchCategory) : rootCategoryHierarchy.Id;
                      System.debug('categoryToLookup: '+categoryToLookup);
                        
                     //ORIGINAL Apttus_CPQApi.CPQ.ProductSearchResultDO result = Apttus_CPQApi.CPQWebService.getProductsWithCategoryAndText(priceListId, new ID[]{categoryToLookup}, searchText.trim(), null, null, prodFilterExpr, null);
                    
                     // Added by Vamsi to support search for below mentioned fields as well
                      List <String> productScopeList = new List<String>();
                      productScopeList.add('APTS_ProductType__c');
                      productScopeList.add('APTS_Product_ID__c');
                      productScopeList.add('APTS_Product_Type_ID__c');                        
                      productScopeList.add('ProductCode');
                      productScopeList.add('Name');
                      Apttus_CPQApi.CPQ.ProductSearchResultDO result = Apttus_CPQApi.CPQWebService.getProductsWithCategoryAndText(priceListId, new ID[]{categoryToLookup}, searchText.trim(), null, productScopeList, prodFilterExpr, null);
                                                                                
                                                 
                      System.debug('######## SS - Result Has Products : ' + result.HasProducts);
                      System.debug('######## SS - Price List ID : ' + pricelistId + '       Search Category : ' + searchCategory + '       Search Text : ' + searchText.trim()+';;; size'+result.Products);
                      if (result.HasProducts) {
                        wrapproductList= new List<ProductWrapperClass>();
                        
                        // add products to the collection
                        for(Apttus_CPQApi.CPQ.ProductDO productDO : result.Products) {
                          prdids.add(productDO.ProductId);
                        }
                        
                        //get products size
                        listSize=prdids.size();
                        //form query string with additional conditions
                        string qrystr=queryString+ ' where id IN:prdids ORDER BY Name ASC LIMIT '+queryLimit+' OFFSET '+offset;
                        system.debug('****qrystr'+qrystr);
                        list<Product2> Resultedprdlist=database.query(qrystr);
                        // Resultedprdlist = filterSearchedProducts(Resultedprdlist);
                        
                        for(product2 pr : Resultedprdlist){
                        
                        //check if products are of "Local Products", then display name on UI is ProductID + Productname
                        if(pr.Recordtype.Name==LOCAL_PRODUCTS){
                            
                             //product name should be displayed in the format {Product Id]+Tabspace+[Name]
                             if(!string.isEmpty(pr.APTS_Product_ID__c)){
                                 ProductName= pr.APTS_Product_ID__c+ tabSpace +pr.name;
                             }else{
                             //if product Id is null, just add product name
                                 ProductName=pr.name;
                             }
                             
                         }else if(pr.Recordtype.Name==LOCAL_HIERARCHY){//check if products are of "Local Hierarchy", then display name on UI is Level4 Code+ Productname
                             
                             if(!string.isempty(pr.APTS_Hierarchy_Level_4_Code__c)){
                                 //product name should be displayed in the format [Level4 Code]+tabspace+[Name]
                                 ProductName= pr.APTS_Hierarchy_Level_4_Code__c+ tabSpace +pr.name;
                              }else if(string.isempty(pr.APTS_Hierarchy_Level_4_Code__c) && !string.isempty(pr.APTS_Hierarchy_Level_3_Code__c)){
                                 //If level 4 code is null, product name should be displayed in the format [Level3 Code]+tabspace+[Name]
                                 ProductName= pr.APTS_Hierarchy_Level_3_Code__c+ tabSpace +pr.name;
                              }else{
                                  //if level 4 and 3 codes are null(corner case), just pass product name
                                  ProductName=pr.name;
                              }
                              
                              
                         } else{
                                  ProductName=pr.name;
                         }
                         
                          system.debug('product name**'+ProductName);
                          wrapproductList.add(new ProductWrapperClass(pr.id,ProductName));
                        }
                      
                      }
                      
                    }
                
          }catch(exception e){
          
                ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.error, e.getmessage());
                ApexPages.addMessage(errMsg);
                return null;
          }  
                  //show selected notification on catalog page
                  SelectedNotification();
            
            return null;
        }


  
    /**
     * Method to filter the searched products. Product has to be either hierarchy product and
     * its hierarchy level should be same as hierarchy level in product configuration. If product
     * is local product, its distribution channel and sales organization value has to match with
     * the respective values of product configuration.
     * 
     * @owner : Shalin Shah <sshah@apttus.com>
     */
     @TestVisible
    private List<Product2> filterSearchedProducts(List<Product2> listSearchedProducts) {
        
        // If searched product result is 0....
        if(listSearchedProducts == null || listSearchedProducts.size() == 0) {
            return listSearchedProducts;
        }
        
        Apttus_Config2__ProductConfiguration__c configuration = null;
        
        try {
            configuration = [SELECT APTS_LP_Business_Object_Record_Type__c, APTS_LP_Distribution_Channel_Product__c, APTS_LP_Sales_Organization__c, APTS_Hierarchy_Level__c  FROM Apttus_Config2__ProductConfiguration__c  WHERE id = :configId limit 1];
        } catch (Exception e) {
            System.debug('Exception generated while fetching product configuration.\nException : ' + e);
            return listSearchedProducts;
        }
        
        // If configuration object doesn't have required values...
        if(configuration == null
             || (String.valueOf(configuration.APTS_LP_Business_Object_Record_Type__c) != APTS_Constants.PROPOSAL_TYPE
                   && String.valueOf(configuration.APTS_LP_Business_Object_Record_Type__c) != APTS_Constants.MSPA_TYPE)
             || String.isBlank(String.valueOf(configuration.APTS_LP_Distribution_Channel_Product__c))
             || String.isBlank(String.valueOf(configuration.APTS_LP_Sales_Organization__c))) {
            return listSearchedProducts;
        }
        
        // Begin to filter searched products...
        List<Product2> listFilteredProduct = new List<Product2>();
        Integer count = 1;
        for(Product2 searchedProduct : listSearchedProducts) {
            
            if(searchedProduct.Recordtype.Name == LOCAL_PRODUCTS) {
                if( String.valueOf(configuration.APTS_LP_Distribution_Channel_Product__c).equals(String.valueOf(searchedProduct.APTS_LP_Distribution_Channel__c))
                      && String.valueOf(configuration.APTS_LP_Sales_Organization__c).equals(String.valueOf(searchedProduct.APTS_LP_Sales_Organization__c))) {
                    listFilteredProduct.add(searchedProduct);
                }
                
                System.debug('###### SS - ' + count + '     Conf. DC : ' + configuration.APTS_LP_Distribution_Channel_Product__c);
                System.debug('###### SS - ' + count + '     Prod. DC : ' + searchedProduct.APTS_LP_Distribution_Channel__c);
                System.debug('###### SS - ' + count + '     Conf. SO : ' + configuration.APTS_LP_Sales_Organization__c);
                System.debug('###### SS - ' + count + '     Prod. SO : ' + searchedProduct.APTS_LP_Sales_Organization__c);
                
            } else if (searchedProduct.Recordtype.Name == LOCAL_HIERARCHY) {
                if(searchedProduct.APTS_LP_Is_Hierarchy__c
                      && String.valueOf(configuration.APTS_Hierarchy_Level__c).equals(String.valueOf(searchedProduct.APTS_Hierarchy_Level__c))) {
                    listFilteredProduct.add(searchedProduct);
                }
                
                System.debug('###### SS - ' + count + '     Prod. IH : ' + searchedProduct.APTS_LP_Is_Hierarchy__c);
                System.debug('###### SS - ' + count + '     Prod. HL : ' + searchedProduct.APTS_Hierarchy_Level__c);
            }
            count++;
        }
        
        return listFilteredProduct;
    }
      
      
       /*
       @Method to redirect to pricing and cart
       */    
       public pagereference gotoCart(){
           
               
             //redirect to pricing page and then to cart.   
             PageReference pricingPage = Page.Apttus_Config2__Pricing;
             pricingPage.getParameters().put(ID, ConfigId);
             pricingPage.getParameters().put(COFIG_REQUEST_ID, configRequestId);
             pricingPage.getParameters().put(FLOW, FlowName);
             pricingPage.setRedirect(true);
             return pricingPage;
        }
        
        /*
       @Method to redirect to Bulk upload Products Page
       */  
       public pagereference bulkUpload(){
              
             //redirect to pricing page and then to cart.             
             PageReference bulkUploadProductsPage = Page.APTS_BulkUploadProducts;
             bulkUploadProductsPage.getParameters().put(ID, ConfigId);
             bulkUploadProductsPage.getParameters().put(COFIG_REQUEST_ID, configRequestId);
             bulkUploadProductsPage.getParameters().put(FLOW, FlowName);
             bulkUploadProductsPage.setRedirect(true);
             return bulkUploadProductsPage;
        }
        
        
        /*
        @Method to Abandon the cart
        */
        public pagereference doAbandon(){
          
             //delete current configuration on abandon.
             delete ProdConfigSobj;         
             //redirect quote/mspa    
             return new PageReference('/'+QuoteId);  
        } 
        
         /*
        @Method to cancel the placeholder quote
        */
        public pagereference doCancel(){
          
             //delete current configuration on abandon.
             delete ProdConfigSobj;         
             //redirect quote/mspa    
             return new PageReference('/'+opptyId);  
        } 
        
        /*
        @Method to get selected notification upon adding product to cart
        @Notification will be shown if product is added to cart
        */     
        public void selectedNotification(){            
          try{
                //get bundle lines
               Configbundlelines=[select Id,name,Apttus_Config2__ProductId__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c=:ConfigId AND Apttus_Config2__LineType__c='Product/Service' AND Apttus_Config2__IsPrimaryLine__c=true limit 1000];
               //CartSize=Configbundlelines.size();
               for( Apttus_Config2__LineItem__c line : Configbundlelines){          
                   Selectedbundlesmap.put(line.Apttus_Config2__ProductId__c,line.Id);                
               }
               
               system.debug('*****Configbundlelines'+Configbundlelines.size());
                  //show selected notification here
                  if(wrapproductList!=null && wrapproductList.size()>0){
                      
                      for(ProductWrapperClass wrp : wrapproductList){
                          
                        //check if product present on cart
                         if(Selectedbundlesmap.get(wrp.ProductId)!=null){
                           Id lineid=Selectedbundlesmap.get(wrp.ProductId);
                           system.debug('*****lineid'+lineid);
                           
                           if(lineid!=null){
                           //show notification if product is on cart
                            wrp.IsaddedtoCart=true;
                            system.debug('*****inside if'+Configbundlelines.size());
                           }
                           
                         }
                          
                      }
                  }
              }catch(Exception ex){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, ex.getMessage()));  
              }
        }
        
      //Axay- When you hit Save & Exit on on "Locale Products" flow from catalog  
      public pagereference SyncwithOppportunity(){
      
              Apttus_Config2__ProductConfiguration__c supersededconfig;
              List<Apttus_Config2__LineItem__c> lstLineItems = new List<Apttus_Config2__LineItem__c>();
              String businessObjCurrencyCode;
              
              for (Apttus_Config2__ProductConfiguration__c sConfig : [SELECT Id, Name, Apttus_QPConfig__Proposald__c,Apttus_QPConfig__Proposald__r.APTS_Is_Placeholder_Quote__c,
                                                                     Apttus_Config2__Status__c,Apttus_Config2__BusinessObjectType__c, 
                                                                     Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.CurrencyIsoCode,
                                                                     Apttus_CMConfig__AgreementId__r.Apttus__Related_Opportunity__r.CurrencyIsoCode,
                                                                     Apttus_Config2__PriceListId__r.CurrencyIsoCode,
                                                                     (SELECT Id, Name, CurrencyIsoCode, Apttus_Config2__Quantity__c, 
                                                                     Apttus_Config2__ProductId__c, Apttus_Config2__LineType__c, 
                                                                     Apttus_Config2__OptionId__c, Apttus_Config2__BasePrice__c
                                                                     FROM Apttus_Config2__LineItems__r)
                                                                     FROM  Apttus_Config2__ProductConfiguration__c
                                                                     WHERE Apttus_QPConfig__Proposald__c = :QuoteId AND
                                                                     Apttus_Config2__Status__c = 'New' LIMIT 1]){
                  supersededconfig = sConfig;
                  lstLineItems = sConfig.Apttus_Config2__LineItems__r;
              }
              
              //System.debug('supersededconfig.Apttus_Config2__BusinessObjectType__c: '+supersededconfig.Apttus_Config2__BusinessObjectType__c);
              
              if(supersededconfig.Apttus_Config2__BusinessObjectType__c == 'Proposal'){
                  businessObjCurrencyCode = supersededconfig.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.CurrencyIsoCode;
              }else{
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Cannot Sync with Opportunity, please work only on Agreement or Quote/Proposal.'));
                 return null;
              }
              
              System.debug('***businessObjCurrencyCode: '+businessObjCurrencyCode);
              System.debug('***PriceListCurrencyCode: '+supersededconfig.Apttus_Config2__PriceListId__r.CurrencyIsoCode);
              
              //Removing this code now since proposal currency will always be in sync with opportunity currency as we are setting price list using oppoertunity currency
              /*if(String.isBlank(businessObjCurrencyCode) || businessObjCurrencyCode != supersededconfig.Apttus_Config2__PriceListId__r.CurrencyIsoCode){
                 
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Opportunity and '+supersededconfig.Apttus_Config2__BusinessObjectType__c+' Currencies are different, cannot sync.'));
                 return null;
              }*/
              
              //webservice api call to finalize the cart
              Apttus_CPQApi.CPQ.FinalizeCartRequestDO request = new Apttus_CPQApi.CPQ.FinalizeCartRequestDO();
              request.CartId= ConfigId;
              Apttus_CPQApi.CPQ.FinalizeCartResponseDO result = Apttus_CPQApi.CPQWebService.finalizeCart(request);
              
              //boolean success=result.IsSuccess;
              //success=Apttus_QPConfig.QPConfigWebService.syncWithOpportunity(QuoteId,false);
              
              if(syncWithOpportunity(lstLineItems, businessObjCurrencyCode)){
                  return null;
              }
              // delete place holder quote if there is no line items in cart.
              // Added by Chetan Patel as part of R 3.1 date : 13-01-2016
              if(supersededconfig.Apttus_Config2__LineItems__r.size()==0 && supersededconfig.Apttus_QPConfig__Proposald__r.APTS_Is_Placeholder_Quote__c){
                  
                  try{
                      Apttus_Proposal__Proposal__c deleteEmptyPlaceHolderQuote = [select id from Apttus_Proposal__Proposal__c where id=:supersededconfig.Apttus_QPConfig__Proposald__c];
                      if(deleteEmptyPlaceHolderQuote != null){
                          system.debug('in side delete @@@@@@@@@@@@');
                        delete deleteEmptyPlaceHolderQuote;
                      }
                        
                  }catch(Exception exp){
                       ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Error Occured while deleting empty place holder quote, Please contact your administrator.'));
                  }
              }
              //delete place holder quote code ends
              //redirect to quote page
              return new pagereference('/'+opptyId);
        }
  
  
  
        /**
        @ Method to sync with opportunity 
        @ Param: List of line items
        ** Axay - added logic for-
            1. If the cart Item is not exist on Opty Line Items - the add it to line Item
            2. If Cart line Item is exist on Opty Line Item - then Update Opty Line Item
            3. If Opty Line Items is not exist on Cart Line Item - then delete Opty Line Item
        **/
        public Boolean syncWithOpportunity(List<Apttus_Config2__LineItem__c> lineItems, String currencyCode){
            Boolean hasError = false;
            Map<Id, OpportunityLineItem> mapProductToOptyLineItem = new Map<Id, OpportunityLineItem>();
            Map<Id, Id> mapProductToPbe = new Map<Id, Id>();
            Set<Id> productsId = new Set<Id>();
            List<OpportunityLineItem> lstOptyLineItems = new List<OpportunityLineItem>();
            String priceBookId;
            
            List<PriceBook2> lstPriceBook = [SELECT Id FROM PriceBook2 WHERE IsStandard = true];
            if(lstPriceBook.size() > 0){
                priceBookId = lstPriceBook[0].Id;
            }
            
            for(OpportunityLineItem optyLineItem : [SELECT Id, priceBookEntry.product2.Id, OpportunityId
                                                   FROM OpportunityLineItem
                                                   WHERE OpportunityId = :opptyId AND
                                                   APTS_Is_Local_Product__c = true]){
                
                mapProductToOptyLineItem.put(optyLineItem.priceBookEntry.product2.Id, optyLineItem);
                
            }
            
            for(Apttus_Config2__LineItem__c line : lineItems){
                String productId = line.Apttus_Config2__LineType__c == 'Option' ? line.Apttus_Config2__OptionId__c : line.Apttus_Config2__ProductId__c;
                productsId.add(productId);
            }
            //System.debug('***currencyCode: '+currencyCode);
            if(mapProductToOptyLineItem.size() > 0 || productsId.size() > 0){
                
                productsId.addAll(mapProductToOptyLineItem.keySet());
                
                for(PricebookEntry pbe : [SELECT Id, Product2Id
                                         FROM PricebookEntry
                                         WHERE Product2Id IN :productsId
                                         AND Pricebook2Id = :priceBookId
                                         AND CurrencyIsoCode = :currencyCode]){
                    System.debug('prod. Id > '+pbe.Product2Id+' --> Pbe Id > '+pbe.Id);
                    mapProductToPbe.put(pbe.Product2Id, pbe.Id);
                }
            }
            
            for(Apttus_Config2__LineItem__c line : lineItems){
                
                String productId = line.Apttus_Config2__LineType__c == 'Option' ? line.Apttus_Config2__OptionId__c : line.Apttus_Config2__ProductId__c;
                Decimal qunatity = line.Apttus_Config2__Quantity__c != null ? line.Apttus_Config2__Quantity__c : 1;
                Decimal basePrice = line.Apttus_Config2__BasePrice__c != null ? line.Apttus_Config2__BasePrice__c : 0;
                //update
                if(mapProductToOptyLineItem.containsKey(productId)){
                    System.debug('UPDATE:: Opty Line Id > '+mapProductToOptyLineItem.get(productId));
                    OpportunityLineItem optyLineItem = mapProductToOptyLineItem.get(productId);
                    optyLineItem.Quantity = qunatity;
                    //optyLineItem.TotalPrice = qunatity * basePrice;
                    lstOptyLineItems.add(optyLineItem);
                }
                //insert
                else{
                    System.debug('INSERT:: productId: '+productId+'  ***PricebookEntryId: '+mapProductToPbe.get(productId));
                    OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opptyId,
                    Quantity = qunatity,
                    PricebookEntryId = mapProductToPbe.get(productId),
                    //TotalPrice = qunatity * basePrice,
                    //set 0 unit price
                    UnitPrice=0.00);
                    lstOptyLineItems.add(oli);
                }
                //remove the product from Opty line item; if it is not exist on cart and exist on opty line item then delete it.
                mapProductToOptyLineItem.remove(productId);
            }
            
            
               
            try{
                
               if(lstOptyLineItems.size() > 0){
                upsert lstOptyLineItems;
               }
               if(mapProductToOptyLineItem.size() > 0){
                    System.debug('Line Items to be removed: '+mapProductToOptyLineItem.values());
                    // set isLocalProductDelete flag as false of class ClsTriggerFactory to delete opportunity line items as part of sync up with opportunity
                    // Added by Chetan Patel as part of R 3.1  Date : 13-01-2016
                    ClsTriggerFactory.isLocalProductDelete = false;
                    delete mapProductToOptyLineItem.values();
                    ClsTriggerFactory.isLocalProductDelete = true;
                }
                
            }catch(Exception exp){
               hasError = true;
               ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Error Occured while upserting Opporutiny Line Items, Please contact your administrator.'));
            }
            
            
            return hasError;
        }       
  
        
      /*
       @ Checks if the given string value is null or empty.
       @param strValue the string to check
       @return <code>true</code> if the string value is null or empty, <code>false</code> otherwise
      */
       public static Boolean nullOrEmpty(String strValue) {
             // check if null or zero length string
             return (strValue == null || strValue.trim().length() == 0);
        
       }
  
       // navigate on next page
        public void next(){
            try{
                    offset += queryLimit;
                    if(offset+queryLimit >= listSize){
                        lastOff = false;
                    } 
                    firstOff = true;
                    pageNumber++;
                    
                    //run the query string to get new list of products for pagination
                    getCategoryProductList();
                    doSearchProductsWithText();
            }catch(Exception ex){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, ex.getMessage()));  
            }
        }
        
        // navigate on previous page
        public void previous(){
            try{
                if(offset-queryLimit <= 0){
                    offset = 0;
                    firstOff = false;
                }else{
                    offset -= queryLimit; 
                } 
                lastOff = true;
                pageNumber--;
                //run the query string to get new list of products on changing the limit of pagination
                getCategoryProductList();
                doSearchProductsWithText();
           }catch(Exception ex){
               ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, ex.getMessage()));  
           }
        }
        
        // switch on first page
        public void first(){
            
            offset = 0;
            firstOff = false;
            lastOff = true;
            
            pageNumber = 1;
        }
        
        // switch on last page
        public void last(){
            
            // set page number of and offset
            if(Math.Mod(listSize,queryLimit) == 0){
                offset = listSize-queryLimit;  
                pageNumber = listSize/queryLimit;
            }else{
                offset = (listSize/queryLimit)*queryLimit;
                pageNumber = (listSize/queryLimit)+1;
            }
            
            lastOff = false;
            firstOff = true;
        }
        
        // for record limits
        public List<SelectOption> getItems(){
            
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('10','10 Per Page'));
            options.add(new SelectOption('20','20 Per Page'));
            options.add(new SelectOption('50','50 Per Page'));
            options.add(new SelectOption('100','100 Per Page'));
            return options;
        }
        
        // change query limit
        public void changeLimit(){
            try{
                // set query limit
                queryLimit = Integer.valueOf(limits);
                SYSTEM.DEBUG('****LIMIT'+queryLimit);
                offset = 0;
                firstOff = false;
                
                // initialy check page more then 1 or not
                if(listSize > queryLimit){
                    lastOff = true;
                } else{
                    lastOff = false;
                } 
                
                // set page number
                pageNumber = 1;
                //show product selected notification if product already present on cart          
                SelectedNotification();
                //run the query string to get new list of products on changing the limit of pagination
                getCategoryProductList();
                doSearchProductsWithText();
            } catch(Exception ex) {
               ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, ex.getMessage())); 
            }
        }
        
        // for show current record numbers
        public String getRecordInfo(){
            
            integer lastLimit;
            if(offset+queryLimit > listSize){
               lastLimit = listSize;
             }else{
               lastLimit = offset+queryLimit;  
             } 
             
            return (offset+1) + ' - ' + lastLimit + ' of '+listSize;
        }
        
        // return total page number
        public Integer getTotalPage(){
            
             if( Math.Mod(listSize,queryLimit) == 0) {
               return listSize/queryLimit;
            }else{ 
                return (listSize/queryLimit)+1;
            }
        }
        
        // for direct page switching
        public void pageNavigation(){
            try{
                /* if user enter more then number ot total page number than
                   set the value last page number in PageNumber. */
                if(Math.Mod(listSize,queryLimit) == 0 && pageNumber > listSize/queryLimit){
                    pageNumber = listSize/queryLimit;    
                }else if(pageNumber > (listSize/queryLimit)+1){
                    pageNumber = (listSize/queryLimit)+1;
                }
                // set offset according to pageNumber    
                if((pageNumber-1)*queryLimit < 0){
                   offset = 0; 
                } else{
                   offset = (pageNumber-1)*queryLimit; 
                }   
                
               
                if(pageNumber == 1){
                    firstOff = false;
                } else if(pageNumber == 0){
                    pageNumber = 1;
                } else if(pageNumber > 1){
                    firstOff = true;
                } 
                
                // user enter last number of pagenumber than deactive next navigator
                if(Math.Mod(listSize,queryLimit) == 0){
                    if(pageNumber == listSize/queryLimit){
                      lastOff = false;  
                    } else{
                      lastOff = true;  
                    } 
                }else{
                    if(pageNumber == (listSize/queryLimit)+1){
                       lastOff = false; 
                    }else {
                        lastOff = true;
                    }
                }
            }catch(Exception ex){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, ex.getMessage()));
            }
        }
        
        
       /*
       @Wrapper class to hold the list of products to be displayed on UI
       */
        public class ProductWrapperClass{
            
            public Product2 prdt {get; set;}
            public Boolean IsSelected {get; set;}
            public Id ProductId {get; set;}
            public string ProductName {get; set;}
            public boolean IsaddedtoCart {get; set;}
                         
            //wrapper constructor
            public ProductWrapperClass(Id prdId, string PrdName) {
                IsSelected = false;
                ProductId=prdId;
                ProductName=PrdName;
            }
      }    
      
      /* Wrapper class for tree structure*/
      public class CategoryTreeWrapper{
          
          //grand parent categorydo(level1)
          public Apttus_CPQApi.CPQ.CategoryDO grandparent {get;set;}
          //parent categorydo(level2)
          public List<Apttus_CPQApi.CPQ.CategoryDO> parents {get; set;}
          public string gparentname {get; set;}
          
          //constructor     
          public CategoryTreeWrapper(Apttus_CPQApi.CPQ.CategoryDO offeringtree, List<Apttus_CPQApi.CPQ.CategoryDO> hierarchies){
               parents= hierarchies;
               gparentname=offeringtree.name;
               grandparent= offeringtree;
           }
        } 
        
             
    
 }