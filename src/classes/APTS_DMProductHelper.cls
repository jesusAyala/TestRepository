public class APTS_DMProductHelper extends APTS_DMHelper {

	/**
	 * This method contains Bussniess Validation Rule for Validating Product with RecordType as Global
	 *  Written-By : Hardik Shah
	 * 
	 * */

	public static void validateGlobalProducts(List < APTS_Stage_Product__c > listGlobalProducts) {
		boolean bisValidattionError = false;
		APTS_DMHelperUtility dmHelperUtility;
		Set < String > setBU = new Set < String > ();
		setBU.add('LPBS');
		setBU.add('LPCP');
		setBU.add('LPCW');
		setBU.add('LPED');
		setBU.add('LPLS');
		setBU.add('LPSU');
		setBU.add('LPWA');
		Set < String > setLCP = new Set < String > ();
		setLCP.add('Active');
		setLCP.add('Classic');
		setLCP.add('Development');
		setLCP.add('Limited');
		setLCP.add('Obsolete');
		Set < String > setPSS = new Set < String > ();
		setPSS.add('A');
		setPSS.add('I');
		setPSS.add('O');
		setPSS.add('P');

		system.debug('HS -> Size of List' + listGlobalProducts.size());
		// Set of ProductLineId for Product2 Object - APTS_Product_Line_ID__c
		Set < Decimal > setProductLineIDForStageProduct = new Set < Decimal > ();
		// Set of Product-id for ProductLineTree : APTS_Product_Line_1_ID__c
		Set < Decimal > setProductLineTreeID = new Set < Decimal > ();
		// List of Records that needs to be updated
		List < APTS_Stage_Product__c > updatedProducts = new List < APTS_Stage_Product__c > ();

		// Iterate over Product Object 
		for (APTS_Stage_Product__c oProduct: listGlobalProducts) {

			if (isValidProductId(oProduct.APTS_Product_Line_ID__c)) {
				setProductLineIDForStageProduct.add(Decimal.valueOf(oProduct.APTS_Product_Line_ID__c));
			} else {}
		} // End of for Loop.

		system.debug('HS -> Size of First Set' + setProductLineIDForStageProduct.size());
		system.debug('HS -> Size of First Set1' + setProductLineIDForStageProduct);
		// fetch the corresponding ID1,ID2,ID3, from Stage ProductLineTree Object
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
		//*Sreekanth - start*Also get prod-line-id from APTS_Product_Line_Tree__c into setProductLineTreeID set. 
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
		//*End
		// Validate the Id in Product with corresponding Id in ProductLineTree Object 
		for (APTS_Stage_Product__c oProduct: listGlobalProducts) {
			bisValidattionError = false;
			dmHelperUtility = New APTS_DMHelperUtility();

			// Validation of Product Line ID
			if (string.isBlank(oProduct.APTS_Product_Line_ID__c)) {

			} else {
				if (isValidProductId(oProduct.APTS_Product_Line_ID__c)) {

					if (setProductLineTreeID.contains(Decimal.valueOf(oProduct.APTS_Product_Line_ID__c)) && setProductLineIDForStageProduct.contains(Decimal.valueOf(oProduct.APTS_Product_Line_ID__c))) {
						oProduct.APTS_RowStatus__c = APTS_DMConstants.VALIDATION_STATUS;
						oProduct.APTS_Error_Description__c = '';
					} else {
						bisValidattionError = true;
						dmHelperUtility.appendErrorMessage('ProductLineId on ProductObject is not valid \n');
					}

				} else {
					bisValidattionError = true;
					dmHelperUtility.appendErrorMessage('ProductLineId on Staging Product Object is not valid \n');
				}
			}

			// Validation of PickList BU
			if (!setBU.contains(oProduct.APTS_BU__c)) {
				bisValidattionError = true;
				dmHelperUtility.appendErrorMessage('Incorrect Values in PickList BU. \n');
				system.debug('HS--> Incorrect Values in PickList BU');
			}
			// Validation of Product ID
			if (string.isBlank(oProduct.APTS_Product_ID__c)) {
				bisValidattionError = true;
				dmHelperUtility.appendErrorMessage('Invalid Product ID. \n');
				system.debug('HS--> Invalid Product ID');
			}
			// Validation of Description
			if (string.isBlank(oProduct.APTS_Description__c)) {
				bisValidattionError = true;
				dmHelperUtility.appendErrorMessage('Invalid Product Description. \n');
				system.debug('HS--> Invalid Product Description');
			}
			// Validation of PG
			if (string.isBlank(oProduct.APTS_PG__c)) {
				bisValidattionError = true;
				dmHelperUtility.appendErrorMessage('Invalid PG. \n');
				system.debug('HS--> Invalid PG');
			}
			// Validation of ABB Global ID
			if (string.isBlank(oProduct.APTS_ABB_Global_ID__c)) {
				bisValidattionError = true;
				dmHelperUtility.appendErrorMessage('Invalid ABB Global ID. \n');
				system.debug('HS--> Invalid ABB Global ID');
			}
			// Validation of PickList Life Cycle Phase
			//Commented as it doesnot impact on Apttus Functionality
			//Data object owner requires this check, but most of the data has it blank, as Apttus does not require this field for now we are removing the validation
			/* if (!setLCP.contains(oProduct.APTS_Life_Cycle_Phase__c)) {
            bisValidattionError = true;
            sErromMessage = sErromMessage + 'Incorrect Values in PickList Life Cycle Phase. \n';
            system.debug('HS--> Incorrect Values in PickList Life Cycle Phase');
         }*/
			// Validation of Product Sales Status
			if (!setPSS.contains(oProduct.APTS_Produt_Sales_Status__c)) {
				bisValidattionError = true;
				dmHelperUtility.appendErrorMessage('Incorrect Values in PickList Product Sales Status. \n');
				system.debug('HS--> Incorrect Values in PickList Product Sales Status');
			}
			// Validation of Offering Tree Classification node ID-1
			if (string.isBlank(oProduct.APTS_Offering_Tree_Classification_ID_1__c)) {
				bisValidattionError = true;
				dmHelperUtility.appendErrorMessage('Invalid Offering Tree Classification node ID-1. \n');
				system.debug('HS--> Invalid Offering Tree Classification node ID-1.');
			}
			// Validation of Record Type
			if (string.isBlank(oProduct.APTS_RecordType__c)) {
				bisValidattionError = true;
				dmHelperUtility.appendErrorMessage('Invalid Record Type. \n');
				system.debug('HS--> Invalid Record Type.');
			}

			// Validation active
			if (oProduct.APTS_Active__c != null && oProduct.APTS_Active__c.length() > 0 && (oProduct.APTS_Active__c == 'TRUE' || oProduct.APTS_Active__c == 'FALSE')) {

			} else {
				bisValidattionError = true;
				dmHelperUtility.appendErrorMessage('The valid value for APTS_Active__c is TRUE or FALSE. Current value=' + oProduct.APTS_Active__c + ' \n');
				system.debug('HS--> The valid value for APTS_Active__c is TRUE or FALSE. Current value=' + oProduct.APTS_Active__c);
			}

			// Validation active
			if (oProduct.APTS_Active__c == null || string.isBlank(oProduct.APTS_Active__c)) {
				bisValidattionError = true;
				dmHelperUtility.appendErrorMessage('The valid value for APTS_Active__c is TRUE or FALSE. It cannot be Blank \n');
				system.debug('HS--> The valid value for APTS_Active__c is TRUE or FALSE. It cannot be Blank');
			}

			dmHelperUtility.updateValidationStatus(oProduct, bisValidattionError);
			updatedProducts.add(oProduct);

		} // End of for Loop

		// update the records 
		if (updatedProducts.size() > 0) {
			system.debug('HS--> Size of Product to be updated' + updatedProducts.size());
			try {
				Database.upsert(updatedProducts);
			} catch (Exception ex) {
				System.debug('Exception while upserting Global-Product Data.\nException : ' + ex.getMessage());
			}
		}


	}

	/**
	 * This Method performs validation for a given Id
	 * Written-By : Hardik Shah
	 * 
	 * */
	public static Boolean isValidProductId(String recordIdOrPrefix) {
		Boolean bRecordIdForGlobalProduct = false;
		if (recordIdOrPrefix != null && recordIdOrPrefix.isNumeric()) {
			bRecordIdForGlobalProduct = true;
		}
		system.debug('HS--> Failed-Id' + recordIdOrPrefix);

		return bRecordIdForGlobalProduct;
	}

	public static APTS_CopyDataWrapper copyProduct(List < APTS_Stage_Product__c > listGlobalProducts) {

		APTS_CopyDataWrapper oCopyWrapper = new APTS_CopyDataWrapper();

		system.debug('Copying Data from Staging Object to Normal Object for Product');

		Id devRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(APTS_DMConstants.GLOBAL_PRODUCTS).getRecordTypeId();

		system.debug('HS--> Global-Record-Id : ' + devRecordTypeId);

		List < Product2 > listProduct2 = new List < Product2 > ();

		Schema.SObjectField f = Product2.Fields.APTS_External_Id__c;

		//*Sreekanth - start
		Set < Decimal > prodLineID = new Set < Decimal > ();
		for (APTS_Stage_Product__c stProduct: listGlobalProducts) {
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
		for (APTS_Stage_Product__c stageProduct: listGlobalProducts) {

			Product2 oProduct2 = new Product2();
			//oProduct2.CID__c         =             stageProduct.APTS_CID__c;
			oProduct2.APTS_Offering_Tree_Classification_ID_2__c = stageProduct.APTS_Offering_Tree_Classification_ID_2__c;
			oProduct2.APTS_Offering_Tree_Classification_ID_1__c = stageProduct.APTS_Offering_Tree_Classification_ID_1__c;
			oProduct2.APTS_ABB_Global_ID__c = stageProduct.APTS_ABB_Global_ID__c;
			oProduct2.APTS_BU__c = stageProduct.APTS_BU__c;
			oProduct2.APTS_Country_Market_Type__c = stageProduct.APTS_Country_Market_Type__c;
			oProduct2.APTS_EAN_Code__c = stageProduct.APTS_EAN_Code__c;
			oProduct2.APTS_Life_Cycle_Phase__c = stageProduct.APTS_Life_Cycle_Phase__c;
			oProduct2.APTS_MDF_Code__c = stageProduct.APTS_MDF_Code__c;
			oProduct2.APTS_PG__c = stageProduct.APTS_PG__c;
			oProduct2.APTS_LP_Product_Hierarchy__c = stageProduct.APTS_LP_Product_Hierarchy__c;
			oProduct2.APTS_Product_ID__c = stageProduct.APTS_Product_ID__c;
			oProduct2.APTS_Product_Line_ID__c = stageProduct.APTS_Product_Line_ID__c;
			oProduct2.APTS_Produt_Sales_Status__c = stageProduct.APTS_Produt_Sales_Status__c;
			oProduct2.APTS_Product_Type_ID__c = stageProduct.APTS_Product_Type_ID__c;
			oProduct2.APTS_External_ID__c = stageProduct.APTS_External_ID__c;
			oProduct2.APTS_LP_Sales_Organization__c = APTS_DMConstants.APPROVAL_ORGANIZATION;
			oProduct2.RecordTypeId = devRecordTypeId;
			oProduct2.description = stageProduct.APTS_Description__c;
			oProduct2.name = stageProduct.APTS_Description__c;
			oProduct2.ProductCode = stageProduct.APTS_Product_ID__c;
			if (stageProduct.APTS_Active__c != null) oProduct2.IsActive = Boolean.valueOf(stageProduct.APTS_Active__c);

			System.debug('stageProduct.APTS_Product_Line_ID__c***' + stageProduct.APTS_Product_Line_ID__c);
			//*Sreekanth - start
			if (stageProduct.APTS_Product_Line_ID__c != NULL) {

				if (prdLine3Map.containsKey(Decimal.ValueOf(stageProduct.APTS_Product_Line_ID__c))) {
					oProduct2.APTS_Product_Line_Tree__c = prdLine3Map.get(Decimal.ValueOf(stageProduct.APTS_Product_Line_ID__c));
				} else if (prdLine2Map.containsKey(Decimal.ValueOf(stageProduct.APTS_Product_Line_ID__c))) {
					oProduct2.APTS_Product_Line_Tree__c = prdLine2Map.get(Decimal.ValueOf(stageProduct.APTS_Product_Line_ID__c));
				} else {
					oProduct2.APTS_Product_Line_Tree__c = prdLine1Map.get(Decimal.ValueOf(stageProduct.APTS_Product_Line_ID__c));
				}
			}


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
						}
					}
				}

				APTS_DMHelper.updateLoadingStatus(successIdSet, 'Product2', 'APTS_External_ID__c', 'APTS_External_ID__c', listGlobalProducts);

				system.debug('HS1--> ' + oCopyWrapper);
			}

		} catch (Exception e) {
			System.debug('Exception while upserting Product Line Tree records.\nException : ' + e.getMessage());
			oCopyWrapper.sErrorMessage = e.getMessage();
			oCopyWrapper.bIsUpsertFail = true;
		}

		return oCopyWrapper;
	}

}