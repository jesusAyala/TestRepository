@isTest
private class APTS_DMLocalHierarchyHelperTest {
    
    private static User user;
    private static Apttus__APTS_Agreement__c agreement;
    private static APTS_Capture_LSO_Input_Config_Settings__c lodConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();
    

     public static testMethod void validateLocalHierachyNegative(){
            user  = APTS_LP_TestUtility.getUser();
            System.runAs(user) { 
            List<APTS_Stage_Local_Hierarchy__c> listStageLocalHierachy = APTS_LP_TestUtility.getLocalHierachyList(2);
            test.startTest();
            APTS_DMLocalHierarchyHelper.validateLocalHierachy(listStageLocalHierachy);
            test.stopTest();
            }
        }  
    
    public static testMethod void validateLocalHierachyPositive(){
            user  = APTS_LP_TestUtility.getUser();
            System.runAs(user) { 
            List<APTS_Stage_Local_Hierarchy__c> listStageLocalHierachy = new List<APTS_Stage_Local_Hierarchy__c>();
            APTS_Stage_Local_Hierarchy__c stgLclHrchy = new APTS_Stage_Local_Hierarchy__c();
            listStageLocalHierachy.add(stgLclHrchy);

            test.startTest();
           APTS_DMLocalHierarchyHelper.validateLocalHierachy(listStageLocalHierachy);
            test.stopTest();
            }
        }


        public static testMethod void copyLocalHierarchyLevelFourInProduct(){
            APTS_Stage_Data_Validation_Rules_Setting__c validateUser = new APTS_Stage_Data_Validation_Rules_Setting__c();
            validateUser.name = 'DataMigration';
            validateUser.APTS_Validate_SFDC_User__c = FALSE ;        
            insert validateUser; 
            
            user  = APTS_LP_TestUtility.getUser();
            System.runAs(user) { 
            List<APTS_Stage_Local_Hierarchy__c> listStageLocalHierachy=APTS_LP_TestUtility.getLocalHierachyList(2);
            for(APTS_Stage_Local_Hierarchy__c aslh : listStageLocalHierachy){
                            aslh.APTS_Active__c = 'TRUE';
                        }

            test.startTest();
             APTS_CopyDataWrapper cpyDtaWrpr =APTS_DMLocalHierarchyHelper.copyLocalHierarchyLevelFourInProduct(listStageLocalHierachy);
            test.stopTest();
            }
        }
        
        
         public static testMethod void copyLocalHierarchyLevelThreeInProduct(){
             APTS_Stage_Data_Validation_Rules_Setting__c validateUser = new APTS_Stage_Data_Validation_Rules_Setting__c();
            validateUser.name = 'DataMigration';
            validateUser.APTS_Validate_SFDC_User__c = FALSE ;        
            insert validateUser; 
            
            user  = APTS_LP_TestUtility.getUser();
            System.runAs(user) { 
            List<APTS_Stage_Local_Hierarchy__c> listStageLocalHierachy=APTS_LP_TestUtility.getLocalHierachyList(2);
            for(APTS_Stage_Local_Hierarchy__c aslh : listStageLocalHierachy){
                aslh.APTS_Active__c = 'TRUE';
            }

            test.startTest();
             APTS_CopyDataWrapper cpyDtaWrpr =APTS_DMLocalHierarchyHelper.copyLocalHierarchyLevelThreeInProduct(listStageLocalHierachy);
            test.stopTest();
            }
        }


        public static testMethod void copyLocalHierarchyLevelTwoInProduct(){
            APTS_Stage_Data_Validation_Rules_Setting__c validateUser = new APTS_Stage_Data_Validation_Rules_Setting__c();
            validateUser.name = 'DataMigration';
            validateUser.APTS_Validate_SFDC_User__c = FALSE ;        
            insert validateUser; 
            
            user  = APTS_LP_TestUtility.getUser();
            System.runAs(user) { 
            List<APTS_Stage_Local_Hierarchy__c> listStageLocalHierachy=APTS_LP_TestUtility.getLocalHierachyList(2);
            for(APTS_Stage_Local_Hierarchy__c aslh : listStageLocalHierachy){
                aslh.APTS_Active__c = 'TRUE';
            }

            test.startTest();
             APTS_CopyDataWrapper cpyDtaWrpr =APTS_DMLocalHierarchyHelper.copyLocalHierarchyLevelTwoInProduct(listStageLocalHierachy);
            test.stopTest();
            }
        }


        public static testMethod void createCategory(){
            APTS_Stage_Data_Validation_Rules_Setting__c validateUser = new APTS_Stage_Data_Validation_Rules_Setting__c();
            validateUser.name = 'DataMigration';
            validateUser.APTS_Validate_SFDC_User__c = FALSE ;        
            insert validateUser; 
            
            user  = APTS_LP_TestUtility.getUser();
            System.runAs(user) { 
            
            test.startTest();
            APTS_CopyDataWrapper cpyDtaWrpr = APTS_DMLocalHierarchyHelper.createCategory();

            System.assertNotEquals(cpyDtaWrpr,null);
            test.stopTest();
            }
        }


        public static testMethod void createPriceList(){
            APTS_Stage_Data_Validation_Rules_Setting__c validateUser = new APTS_Stage_Data_Validation_Rules_Setting__c();
            validateUser.name = 'DataMigration';
            validateUser.APTS_Validate_SFDC_User__c = FALSE ;        
            insert validateUser; 
            
            user  = APTS_LP_TestUtility.getUser();
            System.runAs(user) { 
            
            test.startTest();
            APTS_CopyDataWrapper cpyDtaWrpr = APTS_DMLocalHierarchyHelper.createPriceList();

            System.assertNotEquals(cpyDtaWrpr,null);
            test.stopTest();
            }
        }

    public static testMethod void associatePriceListWithCategory(){
            APTS_Stage_Data_Validation_Rules_Setting__c validateUser = new APTS_Stage_Data_Validation_Rules_Setting__c();
            validateUser.name = 'DataMigration';
            validateUser.APTS_Validate_SFDC_User__c = FALSE ;        
            insert validateUser; 
            
            user  = APTS_LP_TestUtility.getUser();
            System.runAs(user) { 
            Account acc  = APTS_LP_TestUtility.getNewAccount('Test','Spain');
            insert acc;

            Apttus_Config2__PriceList__c pricelist = APTS_LP_TestUtility.getPriceList(acc, 'Spain');
            pricelist.Name = APTS_DMConstants.CATEGORY_NAME;
            insert pricelist;

            Apttus_Config2__ClassificationName__c clsfcName = new Apttus_Config2__ClassificationName__c();
            clsfcName.Name = 'LP Spain';
            clsfcName.Apttus_Config2__Active__c = true;
            clsfcName.Apttus_Config2__HierarchyLabel__c = 'Test';
            clsfcName.Apttus_Config2__Type__c = 'Offering';
            insert clsfcName;

            Apttus_Config2__PriceListCategory__c prclistCat = new Apttus_Config2__PriceListCategory__c();
            prclistCat.Apttus_Config2__HierarchyId__c = clsfcName.id;
            prclistCat.Apttus_Config2__PriceListId__c = pricelist.id;
            insert prclistCat;

            test.startTest();
            APTS_CopyDataWrapper cpyDtaWrpr = APTS_DMLocalHierarchyHelper.associatePriceListWithCategory();


            

            System.assertNotEquals(cpyDtaWrpr,null);
            test.stopTest();
            }
        }



        public static testMethod void copyLocalHierarchyLevelTwoInCategoryHierarchy(){
            APTS_Stage_Data_Validation_Rules_Setting__c validateUser = new APTS_Stage_Data_Validation_Rules_Setting__c();
            validateUser.name = 'DataMigration';
            validateUser.APTS_Validate_SFDC_User__c = FALSE ;        
            insert validateUser; 
            
            user  = APTS_LP_TestUtility.getUser();
            System.runAs(user) { 

            Apttus_Config2__ClassificationName__c clsfcName = new Apttus_Config2__ClassificationName__c();
            clsfcName.Name = 'LP Spain';
            clsfcName.Apttus_Config2__Active__c = true;
            clsfcName.Apttus_Config2__HierarchyLabel__c = 'Test';
            clsfcName.Apttus_Config2__Type__c = 'Offering';
            insert clsfcName;


            Apttus_Config2__ClassificationHierarchy__c clsfHrchy = new Apttus_Config2__ClassificationHierarchy__c();
            clsfHrchy.Name = 'LP Spain';
            clsfHrchy.Apttus_Config2__HierarchyId__c =clsfcName.id;
            clsfHrchy.Apttus_Config2__Label__c = 'Test';
            insert clsfHrchy;

            List<APTS_Stage_Local_Hierarchy__c> listStageLocalHierachy=APTS_LP_TestUtility.getLocalHierachyList(2);
   
            APTS_Stage_Data_Validation_Rules_Setting__c oTemp1 = new APTS_Stage_Data_Validation_Rules_Setting__c();
            oTemp1.name = 'DataMigration';
            oTemp1.APTS_Category_Sequence__c = 'L20;L21';    
            insert oTemp1;   
        
            test.startTest();
            APTS_CopyDataWrapper cpyDtaWrpr = APTS_DMLocalHierarchyHelper.copyLocalHierarchyLevelTwoInCategoryHierarchy(listStageLocalHierachy);
            
           
            test.stopTest();
            }
        }


         public static testMethod void copyLocalHierarchyLevelThreeInCategoryHierarchy(){
             APTS_Stage_Data_Validation_Rules_Setting__c validateUser = new APTS_Stage_Data_Validation_Rules_Setting__c();
            validateUser.name = 'DataMigration';
            validateUser.APTS_Validate_SFDC_User__c = FALSE ;        
            insert validateUser; 
            
            user  = APTS_LP_TestUtility.getUser();
            System.runAs(user) { 
            Apttus_Config2__ClassificationName__c clsfcName = new Apttus_Config2__ClassificationName__c();
            clsfcName.Name = 'LP Spain';
            clsfcName.Apttus_Config2__Active__c = true;
            clsfcName.Apttus_Config2__HierarchyLabel__c = 'Test';
            clsfcName.Apttus_Config2__Type__c = 'Offering';
            insert clsfcName;


            Apttus_Config2__ClassificationHierarchy__c clsfHrchy = new Apttus_Config2__ClassificationHierarchy__c();
            clsfHrchy.Name = 'LP Spain';
            clsfHrchy.Apttus_Config2__Level__c = 1;
            clsfHrchy.Apttus_Config2__HierarchyId__c =clsfcName.id;
            clsfHrchy.Apttus_Config2__Label__c = 'Test';
            clsfHrchy.APTS_LP_Code__c = '2';
            insert clsfHrchy;

            Apttus_Config2__ClassificationHierarchy__c clsfHrchy1 = new Apttus_Config2__ClassificationHierarchy__c();
            clsfHrchy1.Name = '2';
            clsfHrchy1.Apttus_Config2__Level__c = 1;
            clsfHrchy1.Apttus_Config2__HierarchyId__c =clsfcName.id;
            clsfHrchy1.Apttus_Config2__Label__c = 'Test';
            clsfHrchy1.APTS_LP_Code__c = '2';
            insert clsfHrchy1;



            List<APTS_Stage_Local_Hierarchy__c> listStageLocalHierachy=APTS_LP_TestUtility.getLocalHierachyList(2);
            for(APTS_Stage_Local_Hierarchy__c aslh : listStageLocalHierachy){
                aslh.APTS_Level2_Code__c = '2';
                aslh.APTS_Level2_Name__c = '2';
                aslh.APTS_Level3_Name__c = '3';
            }

            test.startTest();
            APTS_CopyDataWrapper cpyDtaWrpr =APTS_DMLocalHierarchyHelper.copyLocalHierarchyLevelThreeInCategoryHierarchy(listStageLocalHierachy);
            test.stopTest();
            }
        }


          public static testMethod void copyLocalHierarchyLevelFourInCategoryHierarchy(){
            user  = APTS_LP_TestUtility.getUser();
            System.runAs(user) { 
            Apttus_Config2__ClassificationName__c clsfcName = new Apttus_Config2__ClassificationName__c();
            clsfcName.Name = 'LP Spain';
            clsfcName.Apttus_Config2__Active__c = true;
            clsfcName.Apttus_Config2__HierarchyLabel__c = 'Test';
            clsfcName.Apttus_Config2__Type__c = 'Offering';
            insert clsfcName;


            Apttus_Config2__ClassificationHierarchy__c clsfHrchy = new Apttus_Config2__ClassificationHierarchy__c();
            clsfHrchy.Name = 'LP Spain';
            clsfHrchy.Apttus_Config2__Level__c = 2;
            clsfHrchy.Apttus_Config2__HierarchyId__c =clsfcName.id;
            clsfHrchy.Apttus_Config2__Label__c = 'Test';
            insert clsfHrchy;

            Apttus_Config2__ClassificationHierarchy__c clsfHrchy1 = new Apttus_Config2__ClassificationHierarchy__c();
            clsfHrchy1.Name = '2';
            clsfHrchy1.Apttus_Config2__Level__c = 2;
            clsfHrchy1.Apttus_Config2__HierarchyId__c =clsfcName.id;
            clsfHrchy1.Apttus_Config2__Label__c = 'Test1';
            clsfHrchy1.APTS_LP_Code__c = '2';
            insert clsfHrchy1;

            List<APTS_Stage_Local_Hierarchy__c> listStageLocalHierachy=APTS_LP_TestUtility.getLocalHierachyList(2);

            for(APTS_Stage_Local_Hierarchy__c aslh : listStageLocalHierachy){
                aslh.APTS_Level4_Name__c = '4';
                aslh.APTS_Level3_Code__c = '2';
                aslh.APTS_Level3_Name__c = '2';

            }

            

            test.startTest();
            APTS_CopyDataWrapper cpyDtaWrpr =APTS_DMLocalHierarchyHelper.copyLocalHierarchyLevelFourInCategoryHierarchy(listStageLocalHierachy);
            test.stopTest();
            }
        }


        public static testMethod void copyLocalHierarchyInProductClassification(){
            user  = APTS_LP_TestUtility.getUser();
            System.runAs(user) { 

          
     
            Product2  prd2 = APTS_LP_TestUtility.getHierarchyProduct();
            prd2.APTS_External_ID__c = 'Test';

            insert prd2;
         
                
            Apttus_Config2__ClassificationName__c clsfcName = new Apttus_Config2__ClassificationName__c();
            clsfcName.Name = 'LP Spain';
            clsfcName.Apttus_Config2__Active__c = true;
            clsfcName.Apttus_Config2__HierarchyLabel__c = 'Test';
            clsfcName.Apttus_Config2__Type__c = 'Offering';
            insert clsfcName;

            Apttus_Config2__ClassificationHierarchy__c clsfHrchy = new Apttus_Config2__ClassificationHierarchy__c();
            clsfHrchy.Name = 'ES - Hierarchy';
            clsfHrchy.Apttus_Config2__HierarchyId__c =clsfcName.id;
            clsfHrchy.Apttus_Config2__Label__c = 'Test';
            insert clsfHrchy;


            List<APTS_Stage_Local_Hierarchy__c> listStageLocalHierachy=APTS_LP_TestUtility.getLocalHierachyList(2);
            test.startTest();
            APTS_CopyDataWrapper cpyDtaWrpr =APTS_DMLocalHierarchyHelper.copyLocalHierarchyInProductClassification();
            test.stopTest();
            }
        }


        public static testMethod void rebuildCategoryHierachies(){
            user  = APTS_LP_TestUtility.getUser();
            System.runAs(user) { 
            List<APTS_Stage_Local_Hierarchy__c> listStageLocalHierachy=APTS_LP_TestUtility.getLocalHierachyList(2);
            
            Apttus_Config2__ClassificationName__c clsfcName = new Apttus_Config2__ClassificationName__c();
            clsfcName.Name = 'LP Spain';
            clsfcName.Apttus_Config2__Active__c = true;
            clsfcName.Apttus_Config2__HierarchyLabel__c = 'Test';
            clsfcName.Apttus_Config2__Type__c = 'Offering';
            insert clsfcName;
            
             Apttus_Config2__ClassificationHierarchy__c clsfHrchy = new Apttus_Config2__ClassificationHierarchy__c();
            clsfHrchy.Name = 'LP Spain';
            clsfHrchy.Apttus_Config2__Level__c = 1;
            clsfHrchy.Apttus_Config2__HierarchyId__c =clsfcName.id;
            clsfHrchy.Apttus_Config2__Label__c = 'Test';
            clsfHrchy.APTS_LP_Code__c = '2';
            clsfHrchy.Apttus_Config2__Left__c=1;
            clsfHrchy.Apttus_Config2__Right__c=2;
            insert clsfHrchy;

            Apttus_Config2__ClassificationHierarchy__c clsfHrchy1 = new Apttus_Config2__ClassificationHierarchy__c();
            clsfHrchy1.Name = '2';
            clsfHrchy1.Apttus_Config2__Level__c = 1;
            clsfHrchy1.Apttus_Config2__HierarchyId__c =clsfcName.id;
            clsfHrchy1.Apttus_Config2__Label__c = 'Test';
            clsfHrchy1.APTS_LP_Code__c = '1';
            clsfHrchy1.Apttus_Config2__Left__c=1;
            clsfHrchy1.Apttus_Config2__Right__c=2;
            insert clsfHrchy1;
            
            test.startTest();
            APTS_CopyDataWrapper cpyDtaWrpr =APTS_DMLocalHierarchyHelper.rebuildCategoryHierachies();
            test.stopTest();
            }
        }
        
         public static testMethod void copyLocalHierarchyLevelFourInProductNegative(){
            try{
                user  = APTS_LP_TestUtility.getUser();
                System.runAs(user) { 
                test.startTest();
                List<APTS_Stage_Local_Hierarchy__c> listStageLocalHierachy=APTS_LP_TestUtility.getLocalHierachyList(2);
                for(APTS_Stage_Local_Hierarchy__c aslh : listStageLocalHierachy){
                            aslh.APTS_External_ID__c = '1234';
                 }
                APTS_CopyDataWrapper cpyDtaWrpr = APTS_DMLocalHierarchyHelper.copyLocalHierarchyLevelFourInProduct(null);
                 test.stopTest();
                }
            }catch(Exception ex){
                
            }
        }
        
        public static testMethod void copyLocalHierarchyLevelFourInProductNegative2(){
            try{
                user  = APTS_LP_TestUtility.getUser();
                System.runAs(user) { 
                test.startTest();
                List<APTS_Stage_Local_Hierarchy__c> listStageLocalHierachy= new List<APTS_Stage_Local_Hierarchy__c>();
                APTS_CopyDataWrapper cpyDtaWrpr = APTS_DMLocalHierarchyHelper.copyLocalHierarchyLevelFourInProduct(listStageLocalHierachy);
                test.stopTest();
                }
            }catch(Exception ex){
                
            }
        }
       
       
        public static testMethod void copyLocalHierarchyLevelThreeInCategoryHierarchyNegative(){
            user  = APTS_LP_TestUtility.getUser();
            System.runAs(user) { 
            Apttus_Config2__ClassificationName__c clsfcName = new Apttus_Config2__ClassificationName__c();
            clsfcName.Name = 'LP Spain';
            clsfcName.Apttus_Config2__Active__c = true;
            clsfcName.Apttus_Config2__HierarchyLabel__c = 'Test';
            clsfcName.Apttus_Config2__Type__c = 'Offering';
            insert clsfcName;


            Apttus_Config2__ClassificationHierarchy__c clsfHrchy = new Apttus_Config2__ClassificationHierarchy__c();
            clsfHrchy.Name = 'LP Spain';
            clsfHrchy.Apttus_Config2__Level__c = 1;
            clsfHrchy.Apttus_Config2__HierarchyId__c =clsfcName.id;
            clsfHrchy.Apttus_Config2__Label__c = 'Test';
            clsfHrchy.APTS_LP_Code__c = '2';
            insert clsfHrchy;

            Apttus_Config2__ClassificationHierarchy__c clsfHrchy1 = new Apttus_Config2__ClassificationHierarchy__c();
            clsfHrchy1.Name = '2';
            clsfHrchy1.Apttus_Config2__Level__c = 1;
            clsfHrchy1.Apttus_Config2__HierarchyId__c =clsfcName.id;
            clsfHrchy1.Apttus_Config2__Label__c = 'Test';
            clsfHrchy1.APTS_LP_Code__c = '2';
            insert clsfHrchy1;

            List<APTS_Stage_Local_Hierarchy__c> listStageLocalHierachy=APTS_LP_TestUtility.getLocalHierachyList(2);
            for(APTS_Stage_Local_Hierarchy__c aslh : listStageLocalHierachy){
                aslh.APTS_Level2_Code__c = '2';
                aslh.APTS_Level2_Name__c = '2';
                aslh.APTS_Level3_Name__c = '3';
                aslh.APTS_External_ID__c = '1234';
            }
            test.startTest();
            APTS_CopyDataWrapper cpyDtaWrpr =APTS_DMLocalHierarchyHelper.copyLocalHierarchyLevelThreeInCategoryHierarchy(listStageLocalHierachy);
            test.stopTest();
            }
        }
        
       public static testMethod void copyESCategoryHierarchy(){
            user  = APTS_LP_TestUtility.getUser();
            System.runAs(user) { 

            Apttus_Config2__ClassificationName__c clsfcName = new Apttus_Config2__ClassificationName__c();
            clsfcName.Name = 'LP Spain';
            clsfcName.Apttus_Config2__Active__c = true;
            clsfcName.Apttus_Config2__HierarchyLabel__c = 'Test';
            clsfcName.Apttus_Config2__Type__c = 'Offering';
            insert clsfcName;


            Apttus_Config2__ClassificationHierarchy__c clsfHrchy = new Apttus_Config2__ClassificationHierarchy__c();
            clsfHrchy.Name = 'LP Spain';
            clsfHrchy.Apttus_Config2__HierarchyId__c =clsfcName.id;
            clsfHrchy.Apttus_Config2__Label__c = 'Test';
            insert clsfHrchy;

            List<APTS_Stage_Local_Hierarchy__c> listStageLocalHierachy=APTS_LP_TestUtility.getLocalHierachyList(2);
             
            for(APTS_Stage_Local_Hierarchy__c aslh : listStageLocalHierachy){
                aslh.APTS_Level2_Name__c = '2';
            
            }
   
            APTS_Stage_Data_Validation_Rules_Setting__c oTemp1 = new APTS_Stage_Data_Validation_Rules_Setting__c();
            oTemp1.name = 'DataMigration';
            oTemp1.APTS_Category_Sequence__c = 'Series de empotrar;Envolventes;Service BT;Interruptores de Potencia B.T;Thomas and Betts;KNX-EIB;Aparamenta Modular;Entrelec;Control y Automatizacion';        
            insert oTemp1;   
         
            test.startTest();
            APTS_CopyDataWrapper cpyDtaWrpr = APTS_DMLocalHierarchyHelper.copyESCategoryHierarchy();
            test.stopTest();
            }
        }  
    
    
     

    
}