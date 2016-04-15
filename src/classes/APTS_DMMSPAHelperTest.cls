@isTest(seeAllData=False)
private class APTS_DMMSPAHelperTest {

	//private static APTS_Capture_LSO_Input_Config_Settings__c lodConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();
	private static User user;
	public static testMethod void validateStageMSPA(){   
        Boolean isValidateOwner = False;
        APTS_LP_TestUtility.getCommonConfigSetting();
        List<APTS_Stage_Data_Validation_Rules_Setting__c> dataValCustomSetting = APTS_Stage_Data_Validation_Rules_Setting__c.getall().values();
        for(APTS_Stage_Data_Validation_Rules_Setting__c dvr: dataValCustomSetting) {
            if(dvr.name == 'DataMigration') isValidateOwner = true;
        }
        if (isValidateOwner != true) {
            APTS_Stage_Data_Validation_Rules_Setting__c validateUser = new APTS_Stage_Data_Validation_Rules_Setting__c(); 
            validateUser.name = 'DataMigration'; 
            validateUser.APTS_Validate_SFDC_User__c = FALSE ;        
            insert validateUser;
        }
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
	       Account acct1 =  APTS_LP_TestUtility.getNewAccount('Acct-1','US');
	        insert acct1;
	       Account acct = [select ID, Primary_Address_Country__c,Main_Local_City__c,Main_Local_Street__c,BillingCity,BillingStreet,BillingCountry,GUID__c 
                         from Account where GUID__c = 'G01413815' limit 1];
            
	        List<APTS_Stage_MSPA__c> listStageMSPA =  APTS_LP_TestUtility.getStageMSPA(5);
	        for(APTS_Stage_MSPA__c stageMspa : listStageMSPA){
	        	stageMspa.APTS_Owner__c = 'Testing';
	        	stageMspa.APTS_SAP_Customer_ID__c = 'Testing';
	        }
	        APTS_LP_TestUtility.getSalesOffice();
	        APTS_LP_TestUtility.getDistributionChannel();
	        APTS_LP_Local_Customer_Reference_Data__c lcrd = new APTS_LP_Local_Customer_Reference_Data__c();
	        lcrd.APTS_LP_SAP_Customer_ID__c = 'Testing';
	        lcrd.APTS_LP_Account__c = acct.id;
	         lcrd.APTS_External_ID__c = 'Testing';
	        insert lcrd;

	        test.startTest();
	        
	        APTS_DMMSPAHelper.validateStageMSPA(listStageMSPA);
	        test.stopTest();  
       }
   }
	
	public static testMethod void copyMSPA(){
		Boolean isValidateOwner = False;
        APTS_LP_TestUtility.getCommonConfigSetting();
        List<APTS_Stage_Data_Validation_Rules_Setting__c> dataValCustomSetting = APTS_Stage_Data_Validation_Rules_Setting__c.getall().values();
        for(APTS_Stage_Data_Validation_Rules_Setting__c dvr: dataValCustomSetting) {
            if(dvr.name == 'DataMigration') isValidateOwner = true;
        }
        if (isValidateOwner != true) {
            APTS_Stage_Data_Validation_Rules_Setting__c validateUser = new APTS_Stage_Data_Validation_Rules_Setting__c(); 
            validateUser.name = 'DataMigration'; 
            validateUser.APTS_Validate_SFDC_User__c = FALSE ;        
            insert validateUser;
        }        
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
	       Account acct1 =  APTS_LP_TestUtility.getNewAccount('Acct-1','US');
	       insert acct1;
	     Account acct = [select ID, Primary_Address_Country__c,Main_Local_City__c,Main_Local_Street__c,BillingCity,BillingStreet,BillingCountry,GUID__c 
                         from Account where GUID__c = 'G01413815' limit 1];

	        List<APTS_Stage_MSPA__c> listStageMSPA =  APTS_LP_TestUtility.getStageMSPA(5);
	        for(APTS_Stage_MSPA__c stageMspa : listStageMSPA){
	        	stageMspa.APTS_Owner__c = 'Testing';
	        	stageMspa.APTS_SAP_Customer_ID__c = 'Testing';
	        	stageMspa.APTS_Incoterms_methods_Code__c = 'Testing';
	        	stageMspa.APTS_Payment_Terms_SPA__c = 'Testing';
	        }
            
            insert listStageMSPA;
            
	        APTS_LP_TestUtility.getSalesOffice();
	        APTS_LP_TestUtility.getDistributionChannel();

	        APTS_LP_Local_Customer_Reference_Data__c lcrd = new APTS_LP_Local_Customer_Reference_Data__c();
	        lcrd.APTS_LP_SAP_Customer_ID__c = 'Testing';
	       // lcrd.Name = 'Testing';
	       lcrd.APTS_External_ID__c = 'Testing';
	        lcrd.APTS_LP_Account__c = acct.id;

	        insert lcrd;

	        Apttus_Config2__PriceList__c prcielst = APTS_LP_TestUtility.getPriceList(acct, 'Spain');
	        prcielst.Apttus_Config2__Active__c = true;
	        insert prcielst;

	        test.startTest();
	        
	       APTS_CopyDataWrapper oCopyWrapper= APTS_DMMSPAHelper.copyMSPA(listStageMSPA);
	        test.stopTest();  
       }
   }
	

	public static testMethod void copyStageMSPALineItemToLineItem(){
        user  = APTS_LP_TestUtility.getUser();
        
        System.runAs(user) {
        
            APTS_LP_TestUtility.getCommonConfigSetting();
            Account acct1 =  APTS_LP_TestUtility.getNewAccount('Acct-1','US');
	        insert acct1;

            Account acct = [select ID, Primary_Address_Country__c,Main_Local_City__c,Main_Local_Street__c,BillingCity,BillingStreet,BillingCountry,GUID__c 
                         from Account where GUID__c = 'G01413815' limit 1];
            
	         Apttus_Config2__PriceList__c prcielst = APTS_LP_TestUtility.getPriceList(acct, 'Spain');
	        prcielst.Apttus_Config2__Active__c = true;
	        insert prcielst;

			Apttus__APTS_Agreement__c agreement = APTS_LP_TestUtility.getAgreement('Testing');
			agreement.APTS_SPA_Identifier__c = 0;
			agreement.Apttus_CMConfig__PriceListId__c = prcielst.id;
			APTS_LP_TestUtility.getDiscountConfig();
			APTS_LP_TestUtility.getApproalRuleMatrix();
            agreement.APTS_Locale__c = 'es_ES';
			insert agreement;

	         APTS_LP_TestUtility.getSalesOffice();
	        APTS_LP_TestUtility.getDistributionChannel();
	        APTS_LP_TestUtility.getCustomSetting();

        	List<APTS_Stage_Product__c> listLocalProduct  = APTS_LP_TestUtility.getProductList(5,APTS_DMConstants.LOCAL_PRODUCTS); 
        	insert listLocalProduct;

        	List<APTS_Stage_MSPA_LineItems__c> listStageMSPALineItems =  APTS_LP_TestUtility.getStageMSPALineItems(5);
            for(APTS_Stage_MSPA_LineItems__c mspaLineItem: listStageMSPALineItems) {
                mspaLineItem.APTS_RowStatus__c = APTS_DMConstants.VALIDATION_STATUS;
            }
        	insert listStageMSPALineItems;
            
            
            List<Product2> productList =  APTS_LP_TestUtility.getProductList(6);
        	//insert productList1;
            
        	//List<Product2> productList = APTS_LP_TestUtility.getProductList(3);
          //List<Product2> productList = [Select ID, APTS_Product_ID__c from Product2 limit 6]; 
        	Integer i = 0;
        	for(Product2 prd: productList){
       		prd.APTS_Product_ID__c = 'Product-Code' + i;
        		i++;
        	//	APTS_LP_TestUtility.addPricebookAndEntries(prd);
        	}

        	insert productList;
        	

        	

 			Apttus_Config2__ProductConfiguration__c productConfig = APTS_LP_TestUtility.getProductConfiguration('TestProductConfiguration');
            productConfig.Apttus_CMConfig__AgreementId__c = agreement.id;
            insert productConfig;
            
            Apttus_Config2__ProductConfiguration__c hierarchyProductConfig = APTS_LP_TestUtility.getProductConfiguration('TestHierarchyProductConfiguration');
            hierarchyProductConfig.Apttus_CMConfig__AgreementId__c = agreement.id;
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


	        List<APTS_Stage_MSPA__c> listStageMSPA =  APTS_LP_TestUtility.getStageMSPA(5);
	        for(APTS_Stage_MSPA__c stageMspa : listStageMSPA){
	        	stageMspa.APTS_Owner__c = 'Testing';
	        	stageMspa.APTS_SAP_Customer_ID__c = 'Testing';
	        	stageMspa.APTS_Incoterms_methods_Code__c = 'Testing';
	        	stageMspa.APTS_Payment_Terms_SPA__c = 'Testing';
	        }
	       
			insert listStageMSPA;
	        APTS_LP_Local_Customer_Reference_Data__c lcrd = new APTS_LP_Local_Customer_Reference_Data__c();
	        lcrd.APTS_LP_SAP_Customer_ID__c = 'Testing';
	         lcrd.APTS_External_ID__c = 'Testing';
	       // lcrd.Name = 'Testing';
	        lcrd.APTS_LP_Account__c = acct.id;

	        insert lcrd;

	       

	        test.startTest();
	       APTS_CopyDataWrapper oCopyWrapper= APTS_DMMSPAHelper.copyStageMSPALineItemToLineItem(listStageMSPALineItems);            
	        test.stopTest();  
            
            
       }
	}
       
       
       	public static testMethod void validateStageMSPANegative(){  
            Boolean isValidateOwner = False;
            List<APTS_Stage_Data_Validation_Rules_Setting__c> dataValCustomSetting = APTS_Stage_Data_Validation_Rules_Setting__c.getall().values();
            for(APTS_Stage_Data_Validation_Rules_Setting__c dvr: dataValCustomSetting) {
                if(dvr.name == 'DataMigration') isValidateOwner = true;
            }
            if (isValidateOwner != true) {
                APTS_Stage_Data_Validation_Rules_Setting__c validateUser = new APTS_Stage_Data_Validation_Rules_Setting__c(); 
                validateUser.name = 'DataMigration'; 
                validateUser.APTS_Validate_SFDC_User__c = FALSE ;        
                insert validateUser;
            }
       	 user  = APTS_LP_TestUtility.getUser();
   	     System.runAs(user) {
   	        //APTS_LP_TestUtility.getLODConfigSetting();
   	        
   	        List<APTS_Stage_MSPA__c> listStageMSPA =  APTS_LP_TestUtility.getStageMSPA(5);
   	        Account acct1 =  APTS_LP_TestUtility.getNewAccount('Acct-1','US');
	        insert acct1;
   	         Account acct = [select ID, Primary_Address_Country__c,Main_Local_City__c,Main_Local_Street__c,
	                            BillingCity,BillingStreet,BillingCountry,GUID__c 
                                from Account 
                                where GUID__c = 'G01413815' limit 1];

            
            for(APTS_Stage_MSPA__c stageMspa : listStageMSPA){
        	    stageMspa.APTS_Owner__c = '';
        	    stageMspa.APTS_SAP_Customer_ID__c = 'Testing';
        	    stageMspa.APTS_Incoterms_methods_Code__c = 'Testing';
        	    stageMspa.APTS_Payment_Terms_SPA__c = 'Testing';
        	    stageMspa.APTS_Max_Order_Amount_SPA__c = 0;
            }
            
            APTS_Stage_Local_Operational_Data__c stageLOD = new APTS_Stage_Local_Operational_Data__c();
	        stageLOD.APTS_LP_SAP_Customer_ID__c = 'Testing';
	        stageLOD.APTS_External_ID__c = 'Testing';
	        //stageLOD.APTS_LP_Account__c = acct.id;
	        Apttus_Config2__PriceList__c prcielst = APTS_LP_TestUtility.getPriceList(acct, 'Spain');
	        prcielst.Apttus_Config2__Active__c = true;
	        
	        APTS_LP_Local_Customer_Reference_Data__c lcrd = new APTS_LP_Local_Customer_Reference_Data__c();
	        lcrd.APTS_LP_SAP_Customer_ID__c = 'Testing';
	        lcrd.APTS_External_ID__c = 'Testing';
	        lcrd.APTS_LP_Account__c = acct.id;
	        
            test.startTest();
            insert stageLOD;
            insert listStageMSPA;
            insert lcrd;
            
            APTS_DMMSPAHelper.validateStageMSPA(listStageMSPA);
            test.stopTest();
   	    }
    }
    
    	public static testMethod void copyMSPANegative(){
	
		Boolean isValidateOwner = False;
       
        List<APTS_Stage_Data_Validation_Rules_Setting__c> dataValCustomSetting = APTS_Stage_Data_Validation_Rules_Setting__c.getall().values();
        
        for(APTS_Stage_Data_Validation_Rules_Setting__c dvr: dataValCustomSetting) {
            if(dvr.name == 'DataMigration') 
                isValidateOwner = true;
        }
        
        if (isValidateOwner != true) {
            APTS_Stage_Data_Validation_Rules_Setting__c validateUser = new APTS_Stage_Data_Validation_Rules_Setting__c(); 
            validateUser.name = 'DataMigration'; 
            validateUser.APTS_Validate_SFDC_User__c = FALSE ;        
            insert validateUser;
        }        
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {
	       Account acct1 =  APTS_LP_TestUtility.getNewAccount('Acct-1','US');
	       insert acct1;
	     Account acct = [select ID, Primary_Address_Country__c,Main_Local_City__c,Main_Local_Street__c,
	                            BillingCity,BillingStreet,BillingCountry,GUID__c 
                                from Account 
                                where GUID__c = 'G01413815' limit 1];

	    List<APTS_Stage_MSPA__c> listStageMSPA =  APTS_LP_TestUtility.getStageMSPA(5);
	        
	    for(APTS_Stage_MSPA__c stageMspa : listStageMSPA){
	        	stageMspa.APTS_Owner__c = 'Testing';
	        	stageMspa.APTS_SAP_Customer_ID__c = 'Testing';
	        	stageMspa.APTS_Incoterms_methods_Code__c = 'Testing';
	        	stageMspa.APTS_Payment_Terms_SPA__c = 'Testing';
	        	stageMSpa.APTS_Currency__c = null;
	        	stageMSpa.APTS_ChannelSetValue_Code__c = APTS_LP_TestUtility.getLocalChannel().APTS_Code__c;
	        	stageMSpa.APTS_Incoterms_methods_Code__c = APTS_LP_TestUtility.getIncoterm().APTS_Code__c;
	        	stageMSpa.APTS_Payment_Terms_SPA__c = APTS_LP_TestUtility.getPaymentTerm().APTS_Code__c;
	        	stageMSpa.APTS_Sales_Person_SPA__c = 'Testing';
	     }
	     
	        APTS_LP_Local_Customer_Reference_Data__c lcrd = new APTS_LP_Local_Customer_Reference_Data__c();
	        lcrd.APTS_LP_SAP_Customer_ID__c = 'Testing';
	        lcrd.APTS_External_ID__c = 'Testing';
	        lcrd.APTS_LP_Account__c = acct.id;
	        Apttus_Config2__PriceList__c prcielst = APTS_LP_TestUtility.getPriceList(acct, 'Spain');
	        prcielst.Apttus_Config2__Active__c = true;
            
            test.startTest();
            insert lcrd;
            insert listStageMSPA;
            insert prcielst;
	        APTS_CopyDataWrapper oCopyWrapper= APTS_DMMSPAHelper.copyMSPA(listStageMSPA);
	        test.stopTest();  
       }
   }
	



      /* public static testMethod void repriceAndFinalize(){
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) {

        	List<APTS_Stage_Product__c> listLocalProduct  = APTS_LP_TestUtility.getProductList(5,APTS_DMConstants.LOCAL_PRODUCTS); 
        	insert listLocalProduct;

        	List<APTS_Stage_MSPA_LineItems__c> listStageMSPALineItems =  APTS_LP_TestUtility.getStageMSPALineItems(5);
        	insert listStageMSPALineItems;

        	List<Product2> prds = APTS_LP_TestUtility.getProductList(4);
        	Integer i = 0;
        	for(Product2 prd: prds){
        		prd.APTS_Product_ID__c = 'Product-Code' + i;
        		i++;
        	}

        	insert prds;

			Apttus__APTS_Agreement__c agreement = APTS_LP_TestUtility.getAgreement('Testing');
			agreement.APTS_SPA_Identifier__c = 0;
			APTS_LP_TestUtility.getDiscountConfig();
			insert agreement;

			APTS_LP_TestUtility.getCustomSetting();


	        Account acct =  APTS_LP_TestUtility.getNewAccount('Acct-1','US');
	        insert acct;

	        List<APTS_Stage_MSPA__c> listStageMSPA =  APTS_LP_TestUtility.getStageMSPA(5);
	        for(APTS_Stage_MSPA__c stageMspa : listStageMSPA){
	        	stageMspa.APTS_Owner__c = 'Testing';
	        	stageMspa.APTS_SAP_Customer_ID__c = 'Testing';
	        	stageMspa.APTS_Incoterms_methods_Code__c = 'Testing';
	        	stageMspa.APTS_Payment_Terms_SPA__c = 'Testing';
	        }
	        APTS_LP_TestUtility.getSalesOffice();
	        APTS_LP_TestUtility.getMasterPicklistTableData();
 
	        APTS_LP_Local_Customer_Reference_Data__c lcrd = new APTS_LP_Local_Customer_Reference_Data__c();
	        lcrd.APTS_LP_SAP_Customer_ID__c = 'Testing';
	        lcrd.Name = 'Testing';
	        lcrd.APTS_LP_Account__c = acct.id;

	        insert lcrd;

	        Apttus_Config2__PriceList__c prcielst = APTS_LP_TestUtility.getPriceList(acct, 'Spain');
	        prcielst.Apttus_Config2__Active__c = true;
	        insert prcielst;

	        test.startTest();
	        insert acct;
	       APTS_CopyDataWrapper oCopyWrapper= APTS_DMMSPAHelper.repriceAndFinalize(listStageMSPALineItems);
	        test.stopTest();  
       }*/
}