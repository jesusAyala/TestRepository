public class APTS_DMLocalProductHelper extends APTS_DMHelper {

	/**
	 * This method contains Bussniess Validation Rule for Validating Product with RecordType as Local
	 *  Written-By : Hardik Shah,Nishi Khushwaha
	 * 
	 * */
	public static void validateLocalProducts(List < APTS_Stage_Product__c > listLocalProducts) {

		system.debug('HS-> Inside validateLocalProducts');
		// Boolean flag to indicate validation error in record
		boolean bisValidattionError = false;
		APTS_DMHelperUtility dmHelperUtility;
		// setOf Bussiness Unit Fields
		Set < String > setBU = new Set < String > ();
		Set < String > setHierachyCode = new Set < String > ();
		// set of Master codes from MasterPickList Table
		Set < String > setMasterCode = new Set < String > ();
		// List of Products that needs to be updated
		List < APTS_Stage_Product__c > listUpdateProducts = new List < APTS_Stage_Product__c > ();
		setBU.add('LPBS');
		setBU.add('LPCP');
		setBU.add('LPCW');
		setBU.add('LPED');
		setBU.add('LPLS');
		setBU.add('LPSU');
		setBU.add('LPWA');
		// set of Global-Product Id
		Set < String > setGlobalProductId = new Set < String > ();
		Set < String > setLocalHierarchyCode = new Set < String > ();
		Set < String > stageLocalHierarchyCodeSet = new Set < String > ();

		Map < String, Product2 > mapGlobalProductId = new Map < String, Product2 > ();

		//create aset of level-4 codes from Apttus_Config2__ClassificationHierarchy__c      
		List < Apttus_Config2__ClassificationHierarchy__c > oCategoryHierarchyQuery = [Select Id, Name, APTS_LP_Code_Full_Hierarchy__c from Apttus_Config2__ClassificationHierarchy__c where Apttus_Config2__Level__c = 3];
		Map < String, Apttus_Config2__ClassificationHierarchy__c > mapCategoryHierarchy = new Map < String, Apttus_Config2__ClassificationHierarchy__c > ();

		for (Apttus_Config2__ClassificationHierarchy__c oCategoryHierarchy: oCategoryHierarchyQuery) {

			mapCategoryHierarchy.put(oCategoryHierarchy.APTS_LP_Code_Full_Hierarchy__c, oCategoryHierarchy);
		}

		//List of global-ProductId in Product2
		List < Product2 > listProduct = [Select Id, Name, APTS_ABB_Global_ID__c from Product2
		WHERE APTS_ABB_Global_ID__c IN: setGlobalProductId
		AND RecordType.Name = : APTS_DMConstants.GLOBAL_PRODUCTS];

		for (Product2 oProduct: listProduct) {
			mapGlobalProductId.put(oProduct.APTS_ABB_Global_ID__c, oProduct);
		}

		System.Debug('mapGlobalProductId *****' + mapGlobalProductId);
		//**Sreekanth
		// Create Set of Global-Product Id and level 4 hierarchy code
		for (APTS_Stage_Product__c oStageProduct: listLocalProducts) {
			setGlobalProductId.add(oStageProduct.APTS_Global_Product_ID__c);
			if (oStageProduct.APTS_LP_Product_Hierarchy__c != null) setLocalHierarchyCode.add(oStageProduct.APTS_LP_Product_Hierarchy__c);
		}
		system.Debug('setGlobalProductId *****' + setGlobalProductId);

		List < APTS_Stage_Local_Hierarchy__c > oStageHierarchyQuery = [Select APTS_Local_Product_Hierarchy_Code__c from APTS_Stage_Local_Hierarchy__c where APTS_Local_Product_Hierarchy_Code__c in : setLocalHierarchyCode];

		for (APTS_Stage_Local_Hierarchy__c slocalHierarchy: oStageHierarchyQuery) {
			stageLocalHierarchyCodeSet.add(slocalHierarchy.APTS_Local_Product_Hierarchy_Code__c);
		}
		//*end

		// fetch the list of Mastercodes from Master-PickList
		List < APTS_Master_Picklist_Table__c > listMasterCode = APTS_DMHelper.getMasterListCodes();

		// Create a set of MasterPickList codes
		for (APTS_Master_Picklist_Table__c masterCode: listMasterCode) {
			setMasterCode.add(masterCode.APTS_Code__c);
		}
		system.debug('HS-->' + setMasterCode);
		//*Sreekanth - start- Product line ID Validation and Global ID validations   
		// Set of ProductLineId for Product2 Object - APTS_Product_Line_ID__c
		Set < Decimal > setProductLineIDForStageProduct = new Set < Decimal > ();
		// Set of Product-id for ProductLineTree : APTS_Product_Line_1_ID__c
		Set < Decimal > setProductLineTreeID = new Set < Decimal > ();
		// Iterate over Product Object 
		for (APTS_Stage_Product__c oPrd: listLocalProducts) {
			if (APTS_DMHelper.isValidProductId(oPrd.APTS_Product_Line_ID__c)) {
				setProductLineIDForStageProduct.add(Decimal.valueOf(oPrd.APTS_Product_Line_ID__c));
			} else {}
		} // End of for Loop.

		system.debug('HS -> Size of First Set' + setProductLineIDForStageProduct.size());
		system.debug('HS -> Size of First Set1' + setProductLineIDForStageProduct);
		// fetch the corresponding ID1,ID2,ID3, from Stage ProductLineTree Object
		if (setProductLineIDForStageProduct.size() > 0) {
			List < APTS_Stage_Product_Line_Tree__c > listProductLineTree = [Select APTS_Product_Line_1_ID__c, APTS_Product_Line_2_ID__c, APTS_Product_Line_3_ID__c
			from APTS_Stage_Product_Line_Tree__c
			where APTS_Product_Line_1_ID__c in : setProductLineIDForStageProduct
			OR APTS_Product_Line_2_ID__c in : setProductLineIDForStageProduct
			OR APTS_Product_Line_3_ID__c in : setProductLineIDForStageProduct];

			// Prepare a set of ProductLineTree Id
			for (APTS_Stage_Product_Line_Tree__c oProductLineTree: listProductLineTree) {

				setProductLineTreeID.add(oProductLineTree.APTS_Product_Line_1_ID__c);
				setProductLineTreeID.add(oProductLineTree.APTS_Product_Line_2_ID__c);
				setProductLineTreeID.add(oProductLineTree.APTS_Product_Line_3_ID__c);

			}

			List < APTS_Product_Line_Tree__c > listProductLineTree_Oper = [Select APTS_Product_Line_1_ID__c, APTS_Product_Line_2_ID__c, APTS_Product_Line_3_ID__c
			from APTS_Product_Line_Tree__c
			where APTS_Product_Line_1_ID__c in : setProductLineIDForStageProduct
			OR APTS_Product_Line_2_ID__c in : setProductLineIDForStageProduct
			OR APTS_Product_Line_3_ID__c in : setProductLineIDForStageProduct];
			// Prepare a set of ProductLineTree Id
			for (APTS_Product_Line_Tree__c oProductLineTree_Oper: listProductLineTree_Oper) {

				setProductLineTreeID.add(oProductLineTree_Oper.APTS_Product_Line_1_ID__c);
				setProductLineTreeID.add(oProductLineTree_Oper.APTS_Product_Line_2_ID__c);
				setProductLineTreeID.add(oProductLineTree_Oper.APTS_Product_Line_3_ID__c);

			}
		}

		// Set of GlobalProductId for Stage Product Object - APTS_Global_Product_ID__c
		Set < String > setGlobalProductIDForStageProduct = new Set < String > ();
		// Set of GlobalProductId for Product2 : APTS_Global_Product_ID__c
		Set < String > setGlobalProdID = new Set < String > ();
		// Iterate over Product Object 
		for (APTS_Stage_Product__c oPrd: listLocalProducts) {
			setGlobalProductIDForStageProduct.add(oPrd.APTS_Global_Product_ID__c);
		} // End of for Loop.

		// Check the existance of Global ID in Global Products
		if (setGlobalProductIDForStageProduct.size() > 0) {
			List < APTS_Stage_Product__c > listGlobalProducts = [Select APTS_ABB_Global_ID__c from APTS_Stage_Product__c
			where APTS_ABB_Global_ID__c in : setGlobalProductIDForStageProduct
			and APTS_RecordType__c = : APTS_DMConstants.GLOBAL_PRODUCTS];
			/// Prepare a set of Product ID's from Global products
			for (APTS_Stage_Product__c oProductGlobal: listGlobalProducts) {
				setGlobalProdID.add(oProductGlobal.APTS_ABB_Global_ID__c);
			}

			List < Product2 > listGlobalProducts_Oper = [Select APTS_ABB_Global_ID__c from Product2
			where APTS_ABB_Global_ID__c in : setGlobalProductIDForStageProduct
			and RecordType.Name = : APTS_DMConstants.GLOBAL_PRODUCTS];
			// Prepare a set of Product ID's from Global products
			for (Product2 oProductGlobal: listGlobalProducts_Oper) {
				setGlobalProdID.add(oProductGlobal.APTS_ABB_Global_ID__c);
			}
		}
		//*Sreekanth - end of changes
		for (APTS_Stage_Product__c oProduct: listLocalProducts) {

			/*if(!setHierachyCode.contains(oProduct.APTS_LP_Product_Hierarchy__c)){
              bisValidattionError = true;
        sErromMessage = sErromMessage + 'Hierachy-Code Doesnt much with Id with Category Hierachy \n';
        system.debug('HS--> Incorrect Values in PickList BU');
              
          }*/

			bisValidattionError = false;
			dmHelperUtility = New APTS_DMHelperUtility();
			// Validation of Product Line ID
			if (string.isBlank(oProduct.APTS_Product_Line_ID__c)) {

			} else {
				if (APTS_DMHelper.isValidProductId(oProduct.APTS_Product_Line_ID__c)) {

					if (setProductLineTreeID.contains(Decimal.valueOf(oProduct.APTS_Product_Line_ID__c)) && setProductLineIDForStageProduct.contains(Decimal.valueOf(oProduct.APTS_Product_Line_ID__c))) {
						// oProduct.APTS_Error_Description__c = '';
					} else {
						bisValidattionError = true;
						dmHelperUtility.appendErrorMessage('ProductLineId on ProductObject is not valid \n');
					}

				} else {
					bisValidattionError = true;
					dmHelperUtility.appendErrorMessage('ProductLineId on Staging Product Object is not valid \n');
				}
			}

			// Validation of Global ID
			if (!string.isBlank(oProduct.APTS_Global_Product_ID__c)) {
				if (setGlobalProdID.contains(oProduct.APTS_Global_Product_ID__c)) {

				} else {
					bisValidattionError = true;
					dmHelperUtility.appendErrorMessage('Invalid Global Product ID \n');
				}
			}

			// Validatio check for Counrty code
			if (oProduct.APTS_Country_Code__c != null && setMasterCode.contains(oProduct.APTS_Country_Code__c)) {

			} else {
				bisValidattionError = true;
				dmHelperUtility.appendErrorMessage('Incorrect Country Code \n');
				system.debug('HS--> Incorrect Country Code');
			}

			// Validation check for Distribution Channel
			if (oProduct.APTS_Distribution_Channel__c != null && setMasterCode.contains(oProduct.APTS_Distribution_Channel__c)) {

			} else {
				bisValidattionError = true;
				dmHelperUtility.appendErrorMessage('Incorrect Distribution Channel Code \n');
				// sErromMessage = sErromMessage + 'Incorrect Distribution Channel Code \n';
				system.debug('HS--> Incorrect Distribution Channel Code');
			}


			// Validation active
			if (oProduct.APTS_Active__c != null && oProduct.APTS_Active__c.length() > 0 && (oProduct.APTS_Active__c == 'TRUE' || oProduct.APTS_Active__c == 'FALSE')) {

			} else {
				bisValidattionError = true;
				dmHelperUtility.appendErrorMessage('The valid value for APTS_Active__c is TRUE or FALSE. Current value=' + oProduct.APTS_Active__c + ' \n');
				system.debug('HS--> The valid value for APTS_Active__c is TRUE or FALSE. Current value=' + oProduct.APTS_Active__c);
			}

			// Validation check for Sales Organization
			if (oProduct.APTS_Sales_Organization__c != null && oProduct.APTS_Sales_Organization__c.length() > 0 && oProduct.APTS_Sales_Organization__c == APTS_DMConstants.APPROVAL_ORGANIZATION) {

			} else {
				bisValidattionError = true;
				dmHelperUtility.appendErrorMessage('Incorrect value for Sales Organization. Current value = ' + oProduct.APTS_Sales_Organization__c + ' Expected value= ' + APTS_DMConstants.APPROVAL_ORGANIZATION + '\n');
				system.debug('HS--> Incorrect Sales Organization');
			}


			// Validation check for globalProductId 
			/*if(!mapGlobalProductId.containsKey(oProduct.APTS_Global_Product_ID__c)) {
                bisValidattionError = true;
        sErromMessage = sErromMessage + 'Incorrect Id in Global Product Id. \n';
        system.debug('HS--> Incorrect Id in Global Product Id');
            }*/

			// Validation check for Bussiness unit PickList;
			if (!setBU.contains(oProduct.APTS_BU__c)) {
				bisValidattionError = true;
				dmHelperUtility.appendErrorMessage('Incorrect Values in PickList BU. \n');
				system.debug('HS--> Incorrect Values in PickList BU');
			}

			// validation check for Local Hierarchy
			system.debug('***JPG' + mapCategoryHierarchy.size());

			if (oProduct.APTS_LP_Product_Hierarchy__c == null || oProduct.APTS_LP_Product_Hierarchy__c.length() == 0 || !mapCategoryHierarchy.containsKey(oProduct.APTS_LP_Product_Hierarchy__c)) {
				//**Sreekanth
				if (!stageLocalHierarchyCodeSet.contains(oProduct.APTS_LP_Product_Hierarchy__c)) {
					system.debug('***JPG' + oProduct.APTS_LP_Product_Hierarchy__c + ' does not exist');


					bisValidattionError = true;
					dmHelperUtility.appendErrorMessage('Hierachy-Code Doesnt match with Id with Category Hierachy  \n');
					system.debug('HS--> Incorrect Values in Product Hierarchy');

					//**sreekanth
				}
			}

			// Create a list of Record that needs to be updated
			// Ensure you do the updation after all validation check
			dmHelperUtility.updateValidationStatus(oProduct, bisValidattionError);
			listUpdateProducts.add(oProduct);

		}

		// Update the records      
		if (listUpdateProducts.size() > 0) {
			system.debug('HS--> Size of Product to be updated' + listUpdateProducts.size());
			try {
				Database.upsert(listUpdateProducts);
			} catch (Exception ex) {
				System.debug('Exception while upserting Staging Product Line Tree Data.\nException : ' + ex.getMessage());
			}
		}


	}

	/***
	 *  This Method copies the Product Object with RecordType = Local-Product from Staging to Normal Object
	 * 
	 * Written By : Nishi Kushwaha
	 * 
	 * 
	 * */

	public static APTS_CopyDataWrapper copyLocalProduct(List < APTS_Stage_Product__c > listLocalProducts) {

		APTS_CopyDataWrapper oCopyWrapper = new APTS_CopyDataWrapper();

		system.debug('Copying Data from Staging Object to Normal Object for Local Product');

		Id devRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(APTS_DMConstants.LOCAL_PRODUCTS).getRecordTypeId();

		system.debug('HS--> Local-Record-Id : ' + devRecordTypeId);

		List < Product2 > listProduct2 = new List < Product2 > ();
		Set < String > setGlobalProductId = new Set < String > ();
		Map < String, Product2 > mapGlobalProductId = new Map < String, Product2 > ();

		Schema.SObjectField f = Product2.Fields.APTS_External_Id__c;

		for (APTS_Stage_Product__c oStageProduct: listLocalProducts) {
			setGlobalProductId.add(oStageProduct.APTS_Global_Product_ID__c);
		}

		List < Product2 > listGlobalProduct = [Select Id, Name, APTS_Product_ID__c, APTS_ABB_Global_ID__c from Product2 WHERE APTS_ABB_Global_ID__c IN: setGlobalProductId AND RecordType.Name = : APTS_DMConstants.GLOBAL_PRODUCTS];

		for (Product2 oProduct: listGlobalProduct) {
			mapGlobalProductId.put(oProduct.APTS_ABB_Global_ID__c, oProduct);
		}
		// Added by JPG

		List < Apttus_Config2__ClassificationHierarchy__c > listHierarchy3 = [select id, name, Apttus_Config2__Level__c, APTS_LP_Code__c, Apttus_Config2__Label__c, APTS_LP_Code_Full_Hierarchy__c from Apttus_Config2__ClassificationHierarchy__c
		                                                                      where Apttus_Config2__Level__c = : APTS_DMConstants.LEVEL_2_CAT];

		List < Apttus_Config2__ClassificationHierarchy__c > listHierarchy4 = [select id, name, Apttus_Config2__Level__c, APTS_LP_Code__c, Apttus_Config2__Label__c, APTS_LP_Code_Full_Hierarchy__c from Apttus_Config2__ClassificationHierarchy__c
		                                                                      where Apttus_Config2__Level__c = : APTS_DMConstants.LEVEL_3_CAT];

		//List<Apttus_Config2__ClassificationHierarchy__c> listHierarchy4 = [select id, name, Apttus_Config2__Level__c, APTS_LP_Code__c, Apttus_Config2__Label__c, APTS_LP_Code_Full_Hierarchy__c from Apttus_Config2__ClassificationHierarchy__c
		//                                                              where Apttus_Config2__Level__c = 3];

		map < String, Apttus_Config2__ClassificationHierarchy__c > mapHierarchy3 = new map < String, Apttus_Config2__ClassificationHierarchy__c > ();
		map < String, Apttus_Config2__ClassificationHierarchy__c > mapHierarchy4 = new map < String, Apttus_Config2__ClassificationHierarchy__c > ();

		for (Apttus_Config2__ClassificationHierarchy__c ch3: listHierarchy3) {
			if ((ch3.APTS_LP_Code_Full_Hierarchy__c != null) && (ch3.Apttus_Config2__Label__c != null)) {

				system.debug('***JPG -- ' + ch3.APTS_LP_Code_Full_Hierarchy__c);
				mapHierarchy3.put(ch3.APTS_LP_Code_Full_Hierarchy__c, ch3);
			}
		}

		for (Apttus_Config2__ClassificationHierarchy__c ch4: listHierarchy4) {
			mapHierarchy4.put(ch4.APTS_LP_Code_Full_Hierarchy__c, ch4);
		}

		System.debug('***JPG --- mh4' + mapHierarchy3.keySet());

		//System.debug('***JPG --- mh3'+ mapHierarchy3);
		// -- End by JPG

		//*Sreekanth - start
		Set < Decimal > prodLineID = new Set < Decimal > ();
		for (APTS_Stage_Product__c stProduct: listLocalProducts) {
			if (stProduct.APTS_Product_Line_ID__c != null) prodLineID.add(Decimal.ValueOf(stProduct.APTS_Product_Line_ID__c));
		}
		List < APTS_Product_Line_Tree__c > lstProdLine = [select ID, APTS_Product_Line_1_ID__c, APTS_Product_Line_2_ID__c, APTS_Product_Line_3_ID__c from APTS_Product_Line_Tree__c where APTS_Product_Line_1_ID__c IN: prodLineID OR APTS_Product_Line_2_ID__c IN: prodLineID OR APTS_Product_Line_3_ID__c IN: prodLineID];
		Map < Decimal, ID > prdLine1Map = new Map < Decimal, ID > ();
		Map < Decimal, ID > prdLine2Map = new Map < Decimal, ID > ();
		Map < Decimal, ID > prdLine3Map = new Map < Decimal, ID > ();
		for (APTS_Product_Line_Tree__c prodLine: lstProdLine) {
			if (prodLine.APTS_Product_Line_1_ID__c != null) prdLine1Map.put(prodLine.APTS_Product_Line_1_ID__c, prodLine.ID);
			if (prodLine.APTS_Product_Line_2_ID__c != null) prdLine2Map.put(prodLine.APTS_Product_Line_2_ID__c, prodLine.ID);
			if (prodLine.APTS_Product_Line_3_ID__c != null) prdLine3Map.put(prodLine.APTS_Product_Line_3_ID__c, prodLine.ID);
		}
		//*end
		// Creating Product Line Tree, assigning values and adding into List.
		for (APTS_Stage_Product__c stageProduct: listLocalProducts) {

			Product2 oProduct2 = new Product2();
			oProduct2.APTS_Product_ID__c = stageProduct.APTS_Product_ID__c;
			oProduct2.APTS_BU__c = stageProduct.APTS_BU__c;
			oProduct2.APTS_PG__c = stageProduct.APTS_PG__c;
			oProduct2.APTS_MDF_Code__c = stageProduct.APTS_MDF_Code__c;
			oProduct2.APTS_EAN_Code__c = stageProduct.APTS_EAN_Code__c;
			oProduct2.APTS_LP_Product_Hierarchy__c = stageProduct.APTS_LP_Product_Hierarchy__c;
			oProduct2.APTS_Product_Type_ID__c = stageProduct.APTS_Product_Type_ID__c;
			oProduct2.APTS_Product_Line_ID__c = stageProduct.APTS_Product_Line_ID__c;
			oProduct2.IsActive = Boolean.valueOf(stageProduct.APTS_Active__c);
			oProduct2.Apttus_Config2__ConfigurationType__c = stageProduct.APTS_ConfigurationType__c;
			oProduct2.RecordTypeId = devRecordTypeId;
			oProduct2.description = stageProduct.APTS_Description__c;
			oProduct2.name = stageProduct.APTS_Description__c;
			oProduct2.ProductCode = stageProduct.APTS_Product_ID__c;
			oProduct2.CurrencyIsoCode = stageProduct.CurrencyIsoCode;
			oProduct2.APTS_GTV_Level__c = stageProduct.APTS_GTV_Level__c;
			oProduct2.APTS_Country_Code__c = stageProduct.APTS_Country_Code__c;
			
			oProduct2.APTS_ProductType__c = stageProduct.APTS_ProductType__c;
			
			oProduct2.APTS_External_Id__c = stageProduct.APTS_External_Id__c;

			if (mapGlobalProductId.get(stageProduct.APTS_Global_Product_ID__c) != null) {
				oProduct2.APTS_Global_Product_ID__c = mapGlobalProductId.get(stageProduct.APTS_Global_Product_ID__c).Id;
			}

			oProduct2.APTS_LP_Sales_Organization__c = stageProduct.APTS_Sales_Organization__c;
			oProduct2.APTS_LP_Distribution_Channel__c = stageProduct.APTS_Distribution_Channel__c;

			/* Added by JPG */
			//oProduct2.APTS_GTV_Level__c = mapHierarchyName3.get(stageProduct.APTS_LP_Product_Hierarchy__c);
			//oProduct2.APTS_Hierarchy_Level_3_Code__c = mapHierarchy3.get(stageProduct.APTS_LP_Product_Hierarchy__c);
			//oProduct2.APTS_Hierarchy_Level_4_Code__c = mapHierarchy4.get(stageProduct.APTS_LP_Product_Hierarchy__c);

			string sLevel3Code = '';

			sLevel3Code = stageProduct.APTS_LP_Product_Hierarchy__c.trim().left(10);

			// System.debug('*** JPG Leve 3 Code' + mapHierarchy3.get(stageProduct.APTS_LP_Product_Hierarchy__c.trim().left(10)).Apttus_Config2__Level__c );

			if (mapHierarchy3.containsKey(sLevel3Code)) {

				System.debug('*** JPG INSIDE LOOP');
				oProduct2.APTS_GTV_Level__c = mapHierarchy3.get(sLevel3Code).Apttus_Config2__Label__c;

			}


			if (mapHierarchy3.containsKey(stageProduct.APTS_LP_Product_Hierarchy__c.trim().left(10))) {

				system.debug('***JPG' + stageProduct.APTS_LP_Product_Hierarchy__c);
				system.debug('***JPG Level3' + mapHierarchy3.get(sLevel3Code));

				oProduct2.APTS_Hierarchy_Level_3_Code__c = mapHierarchy3.get(sLevel3Code).APTS_LP_Code__c;

			} else {
				oCopyWrapper.bIsUpsertFail = true;
				oCopyWrapper.sErrorMessage = oCopyWrapper.sErrorMessage + '<br/><br/>' + ': Hierarchy 3 corresponding to this code cannot be found for product ' + oProduct2.APTS_Hierarchy_Level_3_Code__c;
				System.debug(oProduct2.APTS_Hierarchy_Level_3_Code__c + ': Hierarchy 3 corresponding to this code cannot be found for product ' + oProduct2.APTS_Hierarchy_Level_3_Code__c);
				continue;
			}

			//System.debug('Map Hierarchy 4 Nishi****' + mapHierarchy4.size());   

			if (mapHierarchy4.get(stageProduct.APTS_LP_Product_Hierarchy__c) != null) {

				System.debug('stageProduct.APTS_LP_Product_Hierarchy__c *****--->' + stageProduct.APTS_LP_Product_Hierarchy__c);

				oProduct2.APTS_Hierarchy_Level_4_Code__c = mapHierarchy4.get(stageProduct.APTS_LP_Product_Hierarchy__c).APTS_LP_Code__c;
			} else {
				oCopyWrapper.bIsUpsertFail = true;
				oCopyWrapper.sErrorMessage = oCopyWrapper.sErrorMessage + '<br/><br/>' + ': Hierarchy 4 corresponding to this code cannot be found for product ' + stageProduct.APTS_LP_Product_Hierarchy__c;
				System.debug(stageProduct.APTS_LP_Product_Hierarchy__c + ': Hierarchy 4 corresponding to this code cannot be found for product ' + stageProduct.APTS_LP_Product_Hierarchy__c);
				continue;
			}

			//*Sreekanth - start
			if (stageProduct.APTS_Product_Line_ID__c != null) {
				if (prdLine3Map.containsKey(Decimal.ValueOf(stageProduct.APTS_Product_Line_ID__c))) {
					oProduct2.APTS_Product_Line_Tree__c = prdLine3Map.get(Decimal.ValueOf(stageProduct.APTS_Product_Line_ID__c));
				} else if (prdLine2Map.containsKey(Decimal.ValueOf(stageProduct.APTS_Product_Line_ID__c))) {
					oProduct2.APTS_Product_Line_Tree__c = prdLine2Map.get(Decimal.ValueOf(stageProduct.APTS_Product_Line_ID__c));
				} else {
					oProduct2.APTS_Product_Line_Tree__c = prdLine1Map.get(Decimal.ValueOf(stageProduct.APTS_Product_Line_ID__c));
				}
			}
			//*end
			listProduct2.add(oProduct2);
		}

		// Upserting the list
		try {
			if (listProduct2.size() > 0) {
				Database.UpsertResult[] results = Database.upsert(listProduct2, f, false);
				system.debug('HS--> Error ' + results);
				Set < Id > SuccessIdSet = New Set < id > ();


				for (Database.UpsertResult sr: results) {

					if (sr.isSuccess()) {
						successIdSet.add(sr.getId());
						System.debug('Successfully inserted accountID: ' + sr.getId());
					} else {
						// Operation failed, so get all errors 
						oCopyWrapper.bIsUpsertFail = true;
						for (Database.Error err: sr.getErrors()) {
							System.debug('The following error has occurred.');
							oCopyWrapper.sErrorMessage = oCopyWrapper.sErrorMessage + '<br/><br/>' + err.getStatusCode() + ': ' + err.getMessage();
							System.debug(err.getStatusCode() + ': ' + err.getMessage());
							System.debug('ProductLine fields that affected this error: ' + err.getFields());
							System.debug('Id of Record that is failed: ' + sr.getId());
						}
					}
				}

				APTS_DMHelper.updateLoadingStatus(successIdSet, 'Product2', 'APTS_External_ID__c', 'APTS_External_ID__c', listLocalProducts);

				system.debug('HS1--> ' + oCopyWrapper);

			}

		} catch (Exception e) {
			System.debug('Exception while upserting Product Line Tree records.\nException : ' + e.getMessage());
			oCopyWrapper.sErrorMessage = e.getMessage();
			oCopyWrapper.bIsUpsertFail = true;
		}

		return oCopyWrapper;
	}

	public static APTS_CopyDataWrapper copyLocalProductInProductClassification(List < APTS_Stage_Product__c > listLocalProducts) {

		APTS_CopyDataWrapper oCopyWrapper = new APTS_CopyDataWrapper();

		system.debug('Copying Data from Staging Object to Normal Object for Local Product');

		List < Apttus_Config2__ProductClassification__c > listProductClassification = new List < Apttus_Config2__ProductClassification__c > ();

		Schema.SObjectField f = Apttus_Config2__ProductClassification__c.Fields.APTS_External_Id__c;
		List < String > productCodes = new List < String > ();
		for (APTS_Stage_Product__c stageProduct: listLocalProducts) {
			productCodes.add(stageProduct.APTS_Product_ID__c);
		}

		List < Product2 > oProductQuery = [Select Id, Name, APTS_LP_Product_Hierarchy__c, APTS_External_ID__c from Product2 where RecordType.Name = : APTS_DMConstants.LOCAL_PRODUCTS and APTS_Product_ID__c in : productCodes];
		List < Apttus_Config2__ClassificationHierarchy__c > oCategoryHierarchyQuery = [Select Id, Name, APTS_LP_Code_Full_Hierarchy__c from Apttus_Config2__ClassificationHierarchy__c where Apttus_Config2__Level__c = 3];
		Map < String, Apttus_Config2__ClassificationHierarchy__c > mapCategoryHierarchy = new Map < String, Apttus_Config2__ClassificationHierarchy__c > ();

		for (Apttus_Config2__ClassificationHierarchy__c oCategoryHierarchy: oCategoryHierarchyQuery) {

			mapCategoryHierarchy.put(oCategoryHierarchy.APTS_LP_Code_Full_Hierarchy__c, oCategoryHierarchy);
		}

		// Creating Product with Record Type 'Local Hierarchy', assigning values and adding into List.
		for (Product2 oProduct: oProductQuery) {

			Apttus_Config2__ProductClassification__c oProductClassification = new Apttus_Config2__ProductClassification__c();
			oProductClassification.Apttus_Config2__ProductId__c = oProduct.Id;
			oProductClassification.APTS_External_Id__c = oProduct.APTS_External_ID__c;
			if (mapCategoryHierarchy.get(oProduct.APTS_LP_Product_Hierarchy__c) != null) {
				oProductClassification.Apttus_Config2__ClassificationId__c = mapCategoryHierarchy.get(oProduct.APTS_LP_Product_Hierarchy__c).Id;
			} else {
				oCopyWrapper.bIsUpsertFail = true;
				oCopyWrapper.sErrorMessage = oCopyWrapper.sErrorMessage + '<br/><br/>' + ': Hierarchy corresponding to this code cannot be found for product ' + oProduct.APTS_External_ID__c;
				System.debug(oProduct.APTS_LP_Product_Hierarchy__c + ': Hierarchy corresponding to this code cannot be found for product ' + oProduct.APTS_External_ID__c);
				continue;
			}
			oProductClassification.Apttus_Config2__Modifiable__c = true;
			oProductClassification.Apttus_Config2__MinQuantity__c = 0;
			oProductClassification.Apttus_Config2__MaxQuantity__c = 1;
			oProductClassification.Apttus_Config2__DefaultQuantity__c = 1;
			oProductClassification.Apttus_Config2__Default__c = false;
			oProductClassification.CurrencyIsoCode = APTS_DMConstants.SPAIN_CURRENCY;

			listProductClassification.add(oProductClassification);
		}

		// Upserting the list
		try {
			if (listProductClassification.size() > 0) {
				Database.UpsertResult[] results = Database.upsert(listProductClassification, f, false);
				system.debug('HS--> Error ' + results);
				Set < Id > SuccessIdSet = New Set < id > ();


				// Iterate through each returned result
				for (Database.UpsertResult sr: results) {
					if (sr.isSuccess()) {
						successIdSet.add(sr.getId());
						System.debug('Successfully inserted accountID: ' + sr.getId());
					} else {
						// Operation failed, so get all errors 
						oCopyWrapper.bIsUpsertFail = true;
						for (Database.Error err: sr.getErrors()) {
							System.debug('The following error has occurred.');
							oCopyWrapper.sErrorMessage = oCopyWrapper.sErrorMessage + '<br/><br/>' + err.getStatusCode() + ': ' + err.getMessage();
							System.debug(err.getStatusCode() + ': ' + err.getMessage());
							System.debug('Local Product to Product Classification fields that affected this error: ' + err.getFields());
							System.debug('Id of Record that is failed: ' + sr.getId());
						}
					}
				}

				APTS_DMHelper.updateLoadingStatus(successIdSet, 'Apttus_Config2__ProductClassification__c', 'APTS_External_ID__c', 'APTS_External_ID__c', listLocalProducts);

				system.debug('HS1--> ' + oCopyWrapper);
			}

		} catch (Exception e) {
			System.debug('Exception while upserting Local Product as Product Classification records.\nException : ' + e.getMessage());
			oCopyWrapper.sErrorMessage = e.getMessage();
			oCopyWrapper.bIsUpsertFail = true;
		}

		return oCopyWrapper;

	}

}