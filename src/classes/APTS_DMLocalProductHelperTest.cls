@isTest
public class APTS_DMLocalProductHelperTest {

    private static User user;
    private static APTS_Capture_LSO_Input_Config_Settings__c lodConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();
        
    // Test- method to Validate Local Products
    public static testMethod void validateStageLocalProducts(){
        APTS_Stage_Data_Validation_Rules_Setting__c validateUser = new APTS_Stage_Data_Validation_Rules_Setting__c(); 
        validateUser.name = 'DataMigration'; 
        validateUser.APTS_Validate_SFDC_User__c = FALSE ;        
        insert validateUser; 
        
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) { 
            Test.startTest();
            
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getMasterPicklistTableData();
            
            List<APTS_Stage_Product__c> listLocalProduct  = APTS_LP_TestUtility.getProductList(5,APTS_DMConstants.LOCAL_PRODUCTS);
            for(APTS_Stage_Product__c prod : listLocalProduct) {
                prod.APTS_Product_Line_ID__c = '1234567';
                prod.APTS_Distribution_Channel__c = 'BT';
                prod.APTS_Sales_Organization__c = 'ABB';
            }
            listLocalProduct.get(0).APTS_Product_Line_ID__c = '32003';
            listLocalProduct.get(1).APTS_Product_Line_ID__c = 'ABCDE';            
            listLocalProduct.get(listLocalProduct.size() - 1).APTS_Product_Line_ID__c = '78965';
            listLocalProduct.get(listLocalProduct.size() - 1).APTS_Global_Product_ID__c = '78934';
                        
            List<APTS_Product_Line_Tree__c> listProductLineTree = getProductLineTreeList();
            insert listProductLineTree;
            
            List<APTS_Stage_Product_Line_Tree__c > listStageProductLineTree =  APTS_LP_TestUtility.getStageProductLineTreeList(5);
            insert listStageProductLineTree;
            
            APTS_Stage_Local_Hierarchy__c localHierarchy = new APTS_Stage_Local_Hierarchy__c();
            localHierarchy.APTS_Local_Product_Hierarchy_Code__c = 'HierachyTestXYZ1';
            insert localHierarchy;
            
            APTS_DMLocalProductHelper.validateLocalProducts(listLocalProduct);
            
            test.stopTest(); 
        }
        
    }

    
    // Test- method to Validate Local Products
    public static testMethod void copyStageLocalProducts(){
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
            test.startTest();     
          
            List<APTS_Stage_Product__c> listLocalProduct  = APTS_LP_TestUtility.getProductList(5,APTS_DMConstants.LOCAL_PRODUCTS);
            for(Integer i = 1; i <= listLocalProduct.size(); i++) {
                listLocalProduct.get(i-1).APTS_LP_Product_Hierarchy__c = 'Test HR ' + i;
                listLocalProduct.get(i-1).APTS_Product_Line_ID__c = '1234567';
            }
            listLocalProduct.get(listLocalProduct.size() - 1).APTS_Global_Product_ID__c = '78934';
            listLocalProduct.get(0).APTS_Product_Line_ID__c = '32003';
            
            List<APTS_Product_Line_Tree__c> listProductLineTree = getProductLineTreeList();
            insert listProductLineTree;
            
            List<APTS_Stage_Product_Line_Tree__c > listStageProductLineTree =  APTS_LP_TestUtility.getStageProductLineTreeList(5);
            insert listStageProductLineTree;
            
            insertAndGetClassificationHierarchyList();
            
            List<Product2> productList = APTS_LP_TestUtility.getProductList(3);
            for(Integer i = 1; i <= 3; i++) {
                productList.get(i-1).APTS_LP_Product_Hierarchy__c = 'Test HR ' + i;
                productList.get(i-1).APTS_External_ID__c = 'Test External ID ' + i;
                productList.get(i-1).APTS_Product_ID__c = '123' + (i-1);
            }
            productList.get(1).APTS_ABB_Global_ID__c = '78934';
            productList.get(1).RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(APTS_DMConstants.GLOBAL_PRODUCTS).getRecordTypeId();
            insert productList;
            
            APTS_DMLocalProductHelper.copyLocalProduct(listLocalProduct);
            APTS_DMLocalProductHelper.copyLocalProductInProductClassification(listLocalProduct);
            
            Test.stopTest(); 
        }
    }
    
    private static List<APTS_Product_Line_Tree__c> getProductLineTreeList() {
        List<APTS_Product_Line_Tree__c> listProductLineTree = new List<APTS_Product_Line_Tree__c>();
        
        APTS_Product_Line_Tree__c lineTree1 = new APTS_Product_Line_Tree__c();
        lineTree1.APTS_Product_Line_1_ID__c = 1234567;
        lineTree1.APTS_Product_Line_2_ID__c = 1234567;
        lineTree1.APTS_Product_Line_3_ID__c = 1234567;
        listProductLineTree.add(lineTree1);
        
        return listProductLineTree;
    }
    
    private static List<Apttus_Config2__ClassificationHierarchy__c> insertAndGetClassificationHierarchyList() {
        
        Apttus_Config2__ClassificationName__c cat = new Apttus_Config2__ClassificationName__c();
        cat.name = 'Test Cat';
        cat.Apttus_Config2__Type__c = 'Both';
        cat.Apttus_Config2__HierarchyLabel__c = 'Test';
        insert cat;
        
        List<Apttus_Config2__ClassificationHierarchy__c> listHierarchy = new List<Apttus_Config2__ClassificationHierarchy__c>();
        
        Apttus_Config2__ClassificationHierarchy__c objLevel2 = new Apttus_Config2__ClassificationHierarchy__c();
        objLevel2.name = 'Test Level 2';
        objLevel2.Apttus_Config2__HierarchyId__c = cat.id;
        objLevel2.Apttus_Config2__Level__c = 2;
        objLevel2.APTS_LP_Code__c = 'Test Level 2';
        objLevel2.Apttus_Config2__Label__c = 'Test Level 2';
        objLevel2.APTS_LP_Code_Full_Hierarchy__c = 'Test HR 2';
        listHierarchy.add(objLevel2);
        
        Apttus_Config2__ClassificationHierarchy__c objLevel3 = new Apttus_Config2__ClassificationHierarchy__c();
        objLevel3.name = 'Test Level 3';
        objLevel3.Apttus_Config2__HierarchyId__c = cat.id;
        objLevel3.Apttus_Config2__Level__c = 3;
        objLevel3.APTS_LP_Code__c = 'Test Level 3';
        objLevel3.Apttus_Config2__Label__c = 'Test Level 3';
        objLevel3.APTS_LP_Code_Full_Hierarchy__c = 'Test HR 3';
        listHierarchy.add(objLevel3);
        
        insert listHierarchy;
        return listHierarchy;
    }
}