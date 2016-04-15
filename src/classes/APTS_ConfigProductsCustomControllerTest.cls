/*************************************************************
@Name: APTS_ConfigProductsCustomControllerTest
@Author: Ganga Vemula
@CreateDate: 5th sep 2015.
@Description: This is test clas for APTS_ConfigProductsCustomController
@UsedBy: 
******************************************************************/
@IsTest(SeeAllData=false)
Public class APTS_ConfigProductsCustomControllerTest {
    
     private static User user;
     private static APTS_Capture_LSO_Input_Config_Settings__c lodConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();
     //for agreement   
     static testMethod void testMethod1() {


        user  = APTS_LP_TestUtility.getUser();
        
        System.runAs(user) { 
            /*
            APTS_Agreement_Record_Type__c custSettingAgr = new APTS_Agreement_Record_Type__c(
                SetupOwnerId = UserInfo.getOrganizationId(),
                APTS_Default_Record_Type__c = 'MSPA');
            insert custSettingAgr;
            
            APTS_Proposal_Record_Type__c custSettingQuote = new APTS_Proposal_Record_Type__c(SetupOwnerId = UserInfo.getOrganizationId(),
                APTS_Default_Record_Type__c = 'LP'); 
            insert custSettingQuote;
            */
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal(); 
            Account acc=APTS_LP_TestUtility.getNewAccount('Apttus Inc','Spain');
            insert acc;
            APTS_Capture_LSO_Input_Config_Settings__c LSOInputSetting = APTS_LP_TestUtility.getLODConfigSetting();
            APTS_Master_PickList_Table__c mpt = APTS_LP_TestUtility.getMasterPickListTableLocalChannelWithInsert();
            APTS_LP_TestUtility.getDiscountConfig();
            
            Apttus__APTS_Agreement__c agreement =  APTS_LP_TestUtility.getAgreement('Test Agreement');
            insert agreement;
            
            
            Apttus_Proposal__Proposal__c quote=APTS_LP_TestUtility.getProposal('Apttus quote');
            quote.APTS_Locale__c = 'es_ES';
            insert quote;
            
            Apttus_Config2__PriceList__c pricelist=APTS_LP_TestUtility.getPriceList(acc,'Spain');
            insert pricelist;
            
            Apttus_Config2__ProductConfiguration__c productConfig = APTS_LP_TestUtility.getProductConfiguration('TestProductConfiguration');
            productConfig.Apttus_QPConfig__Proposald__c = quote.ID;
            productConfig.Apttus_Config2__PriceListId__c = pricelist.ID;
            
            insert productConfig;
            Apttus_Config2__TempObject__c tempObj = new Apttus_Config2__TempObject__c();
            tempObj.Apttus_Config2__ConfigurationId__c = productConfig.ID;
            insert tempObj;
            
            Test.startTest();
            ApexPages.currentPage().getParameters().put('Id', productConfig.Id);
            ApexPages.currentPage().getParameters().put('configRequestId', tempObj.Id);
            ApexPages.currentPage().getParameters().put('flow', 'LP_Spain');
            
            APTS_ConfigProductsCustomController instance=new APTS_ConfigProductsCustomController();
            Test.stopTest();
        }
     }
   
     static testMethod void testMethod2() { 

         user  = APTS_LP_TestUtility.getUser();
         System.runAs(user) { 
            Account acc=APTS_LP_TestUtility.getNewAccount('Apttus Inc','Spain');
            insert acc;
            APTS_Capture_LSO_Input_Config_Settings__c LSOInputSetting = APTS_LP_TestUtility.getLODConfigSetting();
            APTS_Master_PickList_Table__c mpt = APTS_LP_TestUtility.getMasterPickListTableLocalChannelWithInsert();
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal(); 
            
            Apttus__APTS_Agreement__c agreement =  APTS_LP_TestUtility.getAgreement('Test Agreement');
            insert agreement;
            
            Apttus_Proposal__Proposal__c quote=APTS_LP_TestUtility.getProposal('Apttus quote');
            quote.APTS_Locale__c = 'es_ES';
            insert quote;
            
            Apttus_Config2__PriceList__c pricelist=APTS_LP_TestUtility.getPriceList(acc,'Spain');
            insert pricelist;
            Apttus_Config2__ProductConfiguration__c productConfig = APTS_LP_TestUtility.getProductConfiguration('TestProductConfiguration');
            productConfig.Apttus_CMConfig__AgreementId__c = agreement.ID;
            
            productConfig.Apttus_Config2__PriceListId__c = pricelist.ID;
            
            insert productConfig;
            Apttus_Config2__TempObject__c tempObj = new Apttus_Config2__TempObject__c();
            tempObj.Apttus_Config2__ConfigurationId__c = productConfig.ID;
            insert tempObj;
            
             Apttus_Config2__ClassificationName__c  category = new Apttus_Config2__ClassificationName__c();
             category.Name = 'test- Category';
             category.Apttus_Config2__HierarchyLabel__c = 'test- Category';
             category.Apttus_Config2__Type__c = 'Offering';
             category.Apttus_Config2__Active__c = true;
             insert category;
             
             Apttus_Config2__ClassificationHierarchy__c classificationOBJ = new Apttus_Config2__ClassificationHierarchy__c();
             classificationOBJ.Apttus_Config2__HierarchyId__c = category.ID;
             classificationOBJ.Apttus_Config2__Level__c = 1;
             classificationOBJ.Apttus_Config2__Label__c = 'Test Category';
             classificationOBJ.APTS_LP_Code_Full_Hierarchy__c = 'Test Code';
             classificationOBJ.Name = 'Test';
             insert classificationOBJ;
             
             Apttus_Config2__PriceListCategory__c priceListCategory = new Apttus_Config2__PriceListCategory__c();
             priceListCategory.Apttus_Config2__HierarchyId__c = category.id;
             priceListCategory.Apttus_Config2__PriceListId__c = pricelist.Id;
             priceListCategory.Apttus_Config2__Sequence__c = 1;
             insert priceListCategory;
             Product2 testProduct = APTS_LP_TestUtility.getProduct();
             testProduct.Name = 'test- Category';
             testProduct.APTS_LP_Is_Hierarchy__c=True;
             testProduct.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Local Hierarchy').getRecordTypeId();
    		 testProduct.APTS_LP_Product_Hierarchy__c = 'Test Code';
             insert testProduct;
             
             Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c();
             lineItem.Apttus_Config2__BillToAccountId__c = acc.ID;
             lineItem.Apttus_Config2__ClassificationId__c = classificationOBJ.ID;
             lineItem.Apttus_Config2__ConfigurationId__c = productConfig.ID;
             lineItem.Apttus_Config2__PriceListId__c = pricelist.Id;
             lineItem.Apttus_Config2__ProductId__c = testProduct.ID;
             lineItem.Apttus_Config2__LineType__c='Product/Service';
             lineItem.Apttus_Config2__IsPrimaryLine__c=true;
             lineItem.Apttus_Config2__ItemSequence__c = 1;
             lineItem.Apttus_Config2__LineNumber__c = 1;
             lineItem.Apttus_Config2__PrimaryLineNumber__c = 1;
             insert lineItem;
             
             Test.startTest();
             ApexPages.currentPage().getParameters().put('Id', productConfig.Id);
             ApexPages.currentPage().getParameters().put('configRequestId', tempObj.Id);
             ApexPages.currentPage().getParameters().put('flow', 'LP_Spain');
             APTS_ConfigProductsCustomController instance=new APTS_ConfigProductsCustomController();
             list<APTS_ConfigProductsCustomController.ProductWrapperClass> productWrapperList = new list<APTS_ConfigProductsCustomController.ProductWrapperClass>();
             APTS_ConfigProductsCustomController.ProductWrapperClass productWrapper = new APTS_ConfigProductsCustomController.ProductWrapperClass(testProduct.Id, testProduct.Name);
             
             productWrapper.prdt = testProduct;
             productWrapper.IsSelected = true;
             productWrapperList.add(productWrapper);
             
             instance.wrapproductList = productWrapperList;
             instance.pricelistid=pricelist.Id;
             instance.setCategoryList();
             instance.getCategoryProductList();
             
             instance.wrapproductList = productWrapperList;
             instance.addMultiProducts();
             instance.CategoryId = classificationOBJ.ID;
             instance.standAloneBundleId = testProduct.ID;
             //instance.categoryprdt = testProduct.ID;
             instance.addStandaloneBundles();
             
             instance.getSearchText();
             instance.setSearchText('test- Category');
             instance.searchCategory = 'test- Category';
             
             instance.doSearchProductsWithText();
             instance.GotoCart();
             instance.DoAbandon();
             instance.SelectedNotification();
             
             
             APTS_ConfigProductsCustomController.nullOrEmpty('test- Category');
             
             //
             instance.ConfigId=productConfig.id;
             instance.configRequestId=productConfig.id;
             instance.FlowName='ABC';
             instance.pricelistid=pricelist.id;
             //instance.queryLimit=5;
            // instance.offset=0;
            // instance.listSize=0;
            // instance.queryString='';
             //
             instance.getRecordInfo();
             instance.next();
             instance.getRecordInfo();         
             instance.previous();         
             instance.first();
             instance.last();
             instance.getItems();
             instance.changeLimit();         
             instance.getRecordInfo();
             instance.getTotalPage();
             
             instance.pageNumber = 0;
             instance.pageNavigation();
             
             instance.pageNumber = 1;
             instance.pageNavigation();
             
             instance.pageNumber = 2;
             instance.pageNavigation();
             List<Product2> prodList = new List<Product2>();
             prodList.add(testProduct);
             instance.filterSearchedProducts(prodList);
             //instance.SyncwithOppportunity();
            Test.stopTest();
        }
     }

     public static testMethod void bulkUpload(){

        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) { 
              Account acc=APTS_LP_TestUtility.getNewAccount('Apttus Inc','Spain');
            insert acc;
            APTS_Capture_LSO_Input_Config_Settings__c LSOInputSetting = APTS_LP_TestUtility.getLODConfigSetting();
            APTS_Master_PickList_Table__c mpt = APTS_LP_TestUtility.getMasterPickListTableLocalChannelWithInsert();
            
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal(); 
            
            Apttus__APTS_Agreement__c agreement =  APTS_LP_TestUtility.getAgreement('Test Agreement');
            insert agreement;
            Apttus_Proposal__Proposal__c quote=APTS_LP_TestUtility.getProposal('Apttus quote');
           
            quote.APTS_Locale__c = 'es_ES';
            insert quote;
            
            Apttus_Config2__PriceList__c pricelist=APTS_LP_TestUtility.getPriceList(acc,'Spain');
            insert pricelist;
            Apttus_Config2__ProductConfiguration__c productConfig = APTS_LP_TestUtility.getProductConfiguration('TestProductConfiguration');
            //productConfig.Apttus_CMConfig__AgreementId__c = agreement.ID;
            productConfig.Apttus_QPConfig__Proposald__c = quote.ID;
            productConfig.Apttus_Config2__PriceListId__c = pricelist.ID;
            insert productConfig;
            Apttus_Config2__TempObject__c tempObj = new Apttus_Config2__TempObject__c();
            tempObj.Apttus_Config2__ConfigurationId__c = productConfig.ID;
            insert tempObj;
            
            ApexPages.currentPage().getParameters().put('Id', productConfig.Id);
            ApexPages.currentPage().getParameters().put('configRequestId', tempObj.Id);
            ApexPages.currentPage().getParameters().put('flow', 'LP_Spain');

            
          
            Apttus_Config2__ClassificationName__c  category = new Apttus_Config2__ClassificationName__c();
             category.Name = 'test- Category';
             category.Apttus_Config2__HierarchyLabel__c = 'test- Category';
             category.Apttus_Config2__Type__c = 'Offering';
             category.Apttus_Config2__Active__c = true;
             insert category;
             Apttus_Config2__ClassificationHierarchy__c classificationOBJ = new Apttus_Config2__ClassificationHierarchy__c();
             classificationOBJ.Apttus_Config2__HierarchyId__c = category.ID;
             classificationOBJ.Apttus_Config2__Level__c = 1;
             classificationOBJ.Apttus_Config2__Label__c = 'Test Category';
             classificationOBJ.APTS_LP_Code_Full_Hierarchy__c = 'Test Code';
             classificationOBJ.Name = 'Test';
             insert classificationOBJ;
             Apttus_Config2__PriceListCategory__c priceListCategory = new Apttus_Config2__PriceListCategory__c();
             priceListCategory.Apttus_Config2__HierarchyId__c = category.id;
             priceListCategory.Apttus_Config2__PriceListId__c = pricelist.Id;
             priceListCategory.Apttus_Config2__Sequence__c = 1;
             insert priceListCategory;
             Product2 testProduct = APTS_LP_TestUtility.getProduct();
             testProduct.Name = 'test- Category';
             testProduct.APTS_LP_Is_Hierarchy__c=True;
             testProduct.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Local Hierarchy').getRecordTypeId();
             testProduct.APTS_LP_Product_Hierarchy__c = 'Test Code';
             insert testProduct;
             Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c();
             lineItem.Apttus_Config2__BillToAccountId__c = acc.ID;
             lineItem.Apttus_Config2__ClassificationId__c = classificationOBJ.ID;
             lineItem.Apttus_Config2__ConfigurationId__c = productConfig.ID;
             lineItem.Apttus_Config2__PriceListId__c = pricelist.Id;
             lineItem.Apttus_Config2__ProductId__c = testProduct.ID;
             lineItem.Apttus_Config2__LineType__c='Product/Service';
             lineItem.Apttus_Config2__IsPrimaryLine__c=true;
             lineItem.Apttus_Config2__ItemSequence__c = 1;
             lineItem.Apttus_Config2__LineNumber__c = 1;
             lineItem.Apttus_Config2__PrimaryLineNumber__c = 1;
             insert lineItem;

             Test.startTest();

              APTS_ConfigProductsCustomController instance=new APTS_ConfigProductsCustomController();

             instance.ConfigId=productConfig.id;
             instance.configRequestId=productConfig.id;
             instance.FlowName='ABC';
             instance.pricelistid=pricelist.id;
             pagereference pgref = instance.bulkUpload();

             Test.stopTest();
        }



     }


      public static testMethod void docancel(){

        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) { 
             
            Account acc=APTS_LP_TestUtility.getNewAccount('Apttus Inc','Spain');
            insert acc;
            APTS_Capture_LSO_Input_Config_Settings__c LSOInputSetting = APTS_LP_TestUtility.getLODConfigSetting();
            APTS_Master_PickList_Table__c mpt = APTS_LP_TestUtility.getMasterPickListTableLocalChannelWithInsert();
            
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal(); 
            Apttus__APTS_Agreement__c agreement =  APTS_LP_TestUtility.getAgreement('Test Agreement');
           
            insert agreement;
            
            Apttus_Proposal__Proposal__c quote=APTS_LP_TestUtility.getProposal('Apttus quote');
            
            quote.APTS_Locale__c = 'es_ES';
            insert quote;
            
            Apttus_Config2__PriceList__c pricelist=APTS_LP_TestUtility.getPriceList(acc,'Spain');
            insert pricelist;
            Apttus_Config2__ProductConfiguration__c productConfig = APTS_LP_TestUtility.getProductConfiguration('TestProductConfiguration');
            productConfig.Apttus_CMConfig__AgreementId__c = agreement.ID;
            //productConfig.Apttus_QPConfig__Proposald__c = quote.ID;
            productConfig.Apttus_Config2__PriceListId__c = pricelist.ID;
            insert productConfig;
            Apttus_Config2__TempObject__c tempObj = new Apttus_Config2__TempObject__c();
            tempObj.Apttus_Config2__ConfigurationId__c = productConfig.ID;
            insert tempObj;
            Apttus_Config2__ClassificationName__c  category = new Apttus_Config2__ClassificationName__c();
             category.Name = 'test- Category';
             category.Apttus_Config2__HierarchyLabel__c = 'test- Category';
             category.Apttus_Config2__Type__c = 'Offering';
             category.Apttus_Config2__Active__c = true;
             insert category;
             Apttus_Config2__ClassificationHierarchy__c classificationOBJ = new Apttus_Config2__ClassificationHierarchy__c();
             classificationOBJ.Apttus_Config2__HierarchyId__c = category.ID;
             classificationOBJ.Apttus_Config2__Level__c = 1;
             classificationOBJ.Apttus_Config2__Label__c = 'Test Category';
             classificationOBJ.APTS_LP_Code_Full_Hierarchy__c = 'Test Code';
             classificationOBJ.Name = 'Test';
             insert classificationOBJ;
             Apttus_Config2__PriceListCategory__c priceListCategory = new Apttus_Config2__PriceListCategory__c();
             priceListCategory.Apttus_Config2__HierarchyId__c = category.id;
             priceListCategory.Apttus_Config2__PriceListId__c = pricelist.Id;
             priceListCategory.Apttus_Config2__Sequence__c = 1;
             insert priceListCategory;
             Product2 testProduct = APTS_LP_TestUtility.getProduct();
             testProduct.Name = 'test- Category';
             testProduct.APTS_LP_Is_Hierarchy__c=True;
             testProduct.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Local Hierarchy').getRecordTypeId();
             testProduct.APTS_LP_Product_Hierarchy__c = 'Test Code';
             insert testProduct;
             Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c();
             lineItem.Apttus_Config2__BillToAccountId__c = acc.ID;
             lineItem.Apttus_Config2__ClassificationId__c = classificationOBJ.ID;
             lineItem.Apttus_Config2__ConfigurationId__c = productConfig.ID;
             lineItem.Apttus_Config2__PriceListId__c = pricelist.Id;
             lineItem.Apttus_Config2__ProductId__c = testProduct.ID;
             lineItem.Apttus_Config2__LineType__c='Product/Service';
             lineItem.Apttus_Config2__IsPrimaryLine__c=true;
             lineItem.Apttus_Config2__ItemSequence__c = 1;
             lineItem.Apttus_Config2__LineNumber__c = 1;
             lineItem.Apttus_Config2__PrimaryLineNumber__c = 1;
             insert lineItem;
            ApexPages.currentPage().getParameters().put('Id', productConfig.Id);
            ApexPages.currentPage().getParameters().put('configRequestId', tempObj.Id);
            ApexPages.currentPage().getParameters().put('flow', 'LP_Spain');

            APTS_ConfigProductsCustomController instance=new APTS_ConfigProductsCustomController();
             instance.ConfigId=productConfig.id;
             instance.configRequestId=productConfig.id;
             instance.FlowName='ABC';
             instance.pricelistid=pricelist.id;
             Test.startTest();
             pagereference pgref = instance.docancel();
             Test.stopTest();
        }



     }



      public static testMethod void SyncwithOppportunity(){
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) { 
             
            
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal(); 
            Account acc  = APTS_LP_TestUtility.getNewAccount('Test','Spain');
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ABB ICV').getRecordTypeId();
            insert acc;

            Opportunity opp = APTS_LP_TestUtility.getOpportunity('Test Opp');
            opp.AccountId = acc.id;
            insert opp;
            
            Apttus__APTS_Agreement__c agreement = APTS_LP_TestUtility.getAgreement('TestAgreement');
            APTS_LP_TestUtility.getDiscountConfig();
            
            agreement.Apttus__Account__c = acc.id;
            agreement.Apttus__Related_Opportunity__c = opp.id;
            APTS_LP_TestUtility.getApproalRuleMatrix();
            insert agreement;
            
            
            List<Product2> productList =  APTS_LP_TestUtility.getProductList(3);
            Apttus_Proposal__Proposal__c proposal = APTS_LP_TestUtility.getProposal('Test Proposal');
                        
            
		Test.startTest();
            
            insert productList;
            //APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getApproalRuleMatrix();
            
            proposal.APTS_LP_AccountCustomer__c = acc.id;
            proposal.Apttus_Proposal__Opportunity__c = opp.id;
            insert proposal;
            Apttus_Config2__ProductConfiguration__c productConfig = APTS_LP_TestUtility.getProductConfiguration('TestProductConfiguration');
            productConfig.Apttus_QPConfig__Proposald__c = proposal.id;
            insert productConfig;

            System.debug('--> pc id :'+productConfig.id);
            
            Apttus_Config2__ProductConfiguration__c hierarchyProductConfig = APTS_LP_TestUtility.getProductConfiguration('TestHierarchyProductConfiguration');
            hierarchyProductConfig.Apttus_QPConfig__Proposald__c = proposal.id;
            insert hierarchyProductConfig;
            
            List<Apttus_Config2__LineItem__c> listLineItem = new List<Apttus_Config2__LineItem__c>();
            listLineItem.addAll(APTS_LP_TestUtility.getLineItemListWithDiscount(productConfig.ID, 2, productList[0],5));
            listLineItem.addAll(APTS_LP_TestUtility.getLineItemListWithDiscount(productConfig.ID, 5, productList[1],9));
            listLineItem.addAll(APTS_LP_TestUtility.getLineItemListWithPriceOveride(productConfig.ID, 5, productList[2],10));
            listLineItem.addAll(APTS_LP_TestUtility.getLineItemListWithDiscount(hierarchyProductConfig.ID, 2, productList[3],5));
            listLineItem.addAll(APTS_LP_TestUtility.getLineItemListWithDiscount(hierarchyProductConfig.ID, 5, productList[4],9));
            listLineItem.addAll(APTS_LP_TestUtility.getLineItemListWithPriceOveride(hierarchyProductConfig.ID, 5, productList[5],10));
            insert listLineItem;

            productConfig.Apttus_Config2__Status__c = 'Finalized';
            update productConfig;
            hierarchyProductConfig.Apttus_Config2__Status__c = 'Finalized';
            update hierarchyProductConfig;

             Apttus_Config2__TempObject__c tempObj = new Apttus_Config2__TempObject__c();
            tempObj.Apttus_Config2__ConfigurationId__c = productConfig.ID;
            insert tempObj;
         
              ApexPages.currentPage().getParameters().put('Id', productConfig.Id);
            ApexPages.currentPage().getParameters().put('configRequestId', tempObj.Id);
            ApexPages.currentPage().getParameters().put('flow', 'LP_Spain');
            APTS_ConfigProductsCustomController instance=new APTS_ConfigProductsCustomController();
             instance.ConfigId=productConfig.id;
             instance.configRequestId=productConfig.id;
             instance.FlowName='ABC';
             //instance.pricelistid=pricelist.id;
           //  instance.queryLimit=5;
           //  instance.offset=0;
            // instance.listSize=0;
           //  instance.queryString='';
             try{
             pagereference pgref = instance.SyncwithOppportunity();
         }
         catch(Exception e){
            system.debug(e.getMessage());
         }
         // gracefully ended as it will require assistance to cover the api 
        }


		Test.stopTest();
     }


     static testMethod void testMethod2Negative() { 

         user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) { 

            Account acc=APTS_LP_TestUtility.getNewAccount('Apttus Inc','Spain');
            insert acc;
            APTS_Capture_LSO_Input_Config_Settings__c LSOInputSetting = APTS_LP_TestUtility.getLODConfigSetting();
            APTS_Master_PickList_Table__c mpt = APTS_LP_TestUtility.getMasterPickListTableLocalChannelWithInsert();
            
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal(); 
            Apttus__APTS_Agreement__c agreement =  APTS_LP_TestUtility.getAgreement('Test Agreement');
            insert agreement;
            
            Apttus_Proposal__Proposal__c quote=APTS_LP_TestUtility.getProposal('Apttus quote');
            quote.APTS_Locale__c = 'es_ES';
            insert quote;
            
            Apttus_Config2__PriceList__c pricelist=APTS_LP_TestUtility.getPriceList(acc,'Spain');
            insert pricelist;
            
            Apttus_Config2__ProductConfiguration__c productConfig = APTS_LP_TestUtility.getProductConfiguration('TestProductConfiguration');
            insert productConfig;
            Apttus_Config2__TempObject__c tempObj = new Apttus_Config2__TempObject__c();
            tempObj.Apttus_Config2__ConfigurationId__c = productConfig.ID;
            insert tempObj;

            Test.startTest();
            ApexPages.currentPage().getParameters().put('Id', productConfig.Id);
            ApexPages.currentPage().getParameters().put('configRequestId', tempObj.Id);
            ApexPages.currentPage().getParameters().put('flow', 'LP_Spain');
            APTS_ConfigProductsCustomController instance=new APTS_ConfigProductsCustomController();
            instance.pricelistid=pricelist.Id;
            
             APTS_ConfigProductsCustomController.nullOrEmpty('test- Category');
             
              Product2 testProduct = APTS_LP_TestUtility.getProduct();
             testProduct.Name = 'test- Category';
             testProduct.APTS_LP_Is_Hierarchy__c=True;
             testProduct.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Local Hierarchy').getRecordTypeId();
             testProduct.APTS_LP_Product_Hierarchy__c = 'Test Code';
             insert testProduct;
             List<Product2> prodList = new List<Product2>();
             prodList.add(testProduct);
             instance.filterSearchedProducts(prodList);
            
            Test.stopTest();
        }
     }


      static testMethod void testMethod2Negative2() { 

         user  = APTS_LP_TestUtility.getUser();
         System.runAs(user) { 

             Account acc=APTS_LP_TestUtility.getNewAccount('Apttus Inc','Spain');
            insert acc;
            APTS_Capture_LSO_Input_Config_Settings__c LSOInputSetting = APTS_LP_TestUtility.getLODConfigSetting();
            APTS_Master_PickList_Table__c mpt = APTS_LP_TestUtility.getMasterPickListTableLocalChannelWithInsert();
                        
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal(); 
            Apttus__APTS_Agreement__c agreement =  APTS_LP_TestUtility.getAgreement('Test Agreement');
           
            insert agreement;
            Apttus_Proposal__Proposal__c quote=APTS_LP_TestUtility.getProposal('Apttus quote');
            quote.APTS_Locale__c = 'es_ES';
            insert quote;
            
            Apttus_Config2__PriceList__c pricelist=APTS_LP_TestUtility.getPriceList(acc,'Spain');
            insert pricelist;
            Apttus_Config2__ProductConfiguration__c productConfig = APTS_LP_TestUtility.getProductConfiguration('TestProductConfiguration');
           
            productConfig.Apttus_Config2__PriceListId__c = pricelist.ID;
           
            insert productConfig;
            Apttus_Config2__TempObject__c tempObj = new Apttus_Config2__TempObject__c();
            tempObj.Apttus_Config2__ConfigurationId__c = productConfig.ID;
            insert tempObj;
            Apttus_Config2__ClassificationName__c  category = new Apttus_Config2__ClassificationName__c();
             category.Name = 'test- Category';
             category.Apttus_Config2__HierarchyLabel__c = 'test- Category';
             category.Apttus_Config2__Type__c = 'Offering';
             category.Apttus_Config2__Active__c = true;
             insert category;
             Apttus_Config2__ClassificationHierarchy__c classificationOBJ = new Apttus_Config2__ClassificationHierarchy__c();
             classificationOBJ.Apttus_Config2__HierarchyId__c = category.ID;
             classificationOBJ.Apttus_Config2__Level__c = 1;
             classificationOBJ.Apttus_Config2__Label__c = 'Test Category';
             classificationOBJ.APTS_LP_Code_Full_Hierarchy__c = 'Test Code';
             classificationOBJ.Name = 'Test';
             insert classificationOBJ;
             Apttus_Config2__PriceListCategory__c priceListCategory = new Apttus_Config2__PriceListCategory__c();
             priceListCategory.Apttus_Config2__HierarchyId__c = category.id;
             priceListCategory.Apttus_Config2__PriceListId__c = pricelist.Id;
             priceListCategory.Apttus_Config2__Sequence__c = 1;
             insert priceListCategory;
             Product2 testProduct = APTS_LP_TestUtility.getProduct();
             testProduct.Name = 'test- Category';
             testProduct.APTS_LP_Is_Hierarchy__c=True;
             testProduct.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Local Hierarchy').getRecordTypeId();
             testProduct.APTS_LP_Product_Hierarchy__c = 'Test Code';
             insert testProduct;
             Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c();
             lineItem.Apttus_Config2__BillToAccountId__c = acc.ID;
             lineItem.Apttus_Config2__ClassificationId__c = classificationOBJ.ID;
             lineItem.Apttus_Config2__ConfigurationId__c = productConfig.ID;
             lineItem.Apttus_Config2__PriceListId__c = pricelist.Id;
             lineItem.Apttus_Config2__ProductId__c = testProduct.ID;
             lineItem.Apttus_Config2__LineType__c='Product/Service';
             lineItem.Apttus_Config2__IsPrimaryLine__c=true;
             lineItem.Apttus_Config2__ItemSequence__c = 1;
             lineItem.Apttus_Config2__LineNumber__c = 1;
             lineItem.Apttus_Config2__PrimaryLineNumber__c = 1;
             insert lineItem;

            Test.startTest();
            ApexPages.currentPage().getParameters().put('Id', productConfig.Id);
            ApexPages.currentPage().getParameters().put('configRequestId', tempObj.Id);
            ApexPages.currentPage().getParameters().put('flow', 'LP_Spain');
            APTS_ConfigProductsCustomController instance=new APTS_ConfigProductsCustomController();
            list<APTS_ConfigProductsCustomController.ProductWrapperClass> productWrapperList = new list<APTS_ConfigProductsCustomController.ProductWrapperClass>();
             APTS_ConfigProductsCustomController.ProductWrapperClass productWrapper = new APTS_ConfigProductsCustomController.ProductWrapperClass(testProduct.Id, testProduct.Name);
             productWrapper.prdt = testProduct;
             productWrapper.IsSelected = true;
             productWrapperList.add(productWrapper);
             
             instance.wrapproductList = productWrapperList;
             instance.pricelistid=pricelist.Id;
             instance.setCategoryList();
             instance.getCategoryProductList();
             
             instance.wrapproductList = productWrapperList;
             instance.addMultiProducts();
             instance.CategoryId = classificationOBJ.ID;
             instance.standAloneBundleId = testProduct.ID;
             //instance.categoryprdt = testProduct.ID;
             instance.addStandaloneBundles();
             
             instance.getSearchText();
             instance.setSearchText('test- Category');
             instance.searchCategory = 'test- Category';
             
             instance.doSearchProductsWithText();
             instance.GotoCart();
             instance.DoAbandon();
             instance.SelectedNotification();
             
             
             APTS_ConfigProductsCustomController.nullOrEmpty('test- Category');
             
             
             instance.ConfigId=productConfig.id;
             instance.configRequestId=productConfig.id;
             instance.FlowName='ABC';
             instance.pricelistid=pricelist.id;
            
             instance.getRecordInfo();
             instance.next();
             instance.getRecordInfo();         
             instance.previous();         
             instance.first();
             instance.last();
             instance.getItems();
             instance.changeLimit();         
             instance.getRecordInfo();
             instance.getTotalPage();
             
             instance.pageNumber = 0;
             instance.pageNavigation();
             
             instance.pageNumber = 1;
             instance.pageNavigation();
             
             instance.pageNumber = 2;
             instance.pageNavigation();
             List<Product2> prodList = new List<Product2>();
             prodList.add(testProduct);
             instance.filterSearchedProducts(prodList);
            
            Test.stopTest();
        }
     }
   
   
 }