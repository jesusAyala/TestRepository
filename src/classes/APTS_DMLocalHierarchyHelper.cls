public class APTS_DMLocalHierarchyHelper extends APTS_DMHelper {
    /**
     * This method contains Bussniess Validation Rule for Validating Stage Local Hierachy Object
     *  Written-By : Hardik Shah
     * 
     * */

    public static void validateLocalHierachy(List < APTS_Stage_Local_Hierarchy__c > listLocalHierachy) {

        system.debug('HS-> Inside validateApprovalMatrix ::' + listLocalHierachy.size());
        Boolean bIsValidattionError = false;
        APTS_DMHelperUtility dmHelperUtility;
        List < APTS_Stage_Local_Hierarchy__c > listUpdatedLocalHierachy = new List < APTS_Stage_Local_Hierarchy__c > ();
        List < String > ownerList = New List < String > ();

        List < Apttus_Config2__ClassificationHierarchy__c > oCategoryHierarchyQuery = [Select Id, Name, APTS_LP_Code_Full_Hierarchy__c from Apttus_Config2__ClassificationHierarchy__c where Apttus_Config2__Level__c = 3];
        Map < String, Apttus_Config2__ClassificationHierarchy__c > mapCategoryHierarchy = new Map < String, Apttus_Config2__ClassificationHierarchy__c > ();

        for (Apttus_Config2__ClassificationHierarchy__c oCategoryHierarchy: oCategoryHierarchyQuery) {

            mapCategoryHierarchy.put(oCategoryHierarchy.APTS_LP_Code_Full_Hierarchy__c, oCategoryHierarchy);
        }
        /*Sreekanth - need to uncoment for prod
          for(APTS_Stage_Local_Hierarchy__c localHierachy : listLocalHierachy ){
          
              if (localHierachy.APTS_Owner__c != null)
            {
                ownerList.add(localHierachy.APTS_Owner__c);
            }
          }
          
          //Get active user names
         Set <String> userNameSet = APTS_DMHelper.getActiveUserList(ownerList);
         //Get active user emails
         Set <String> userEmailSet = APTS_DMHelper.getActiveEmailList(ownerList);
         */

        for (APTS_Stage_Local_Hierarchy__c localHierachy: listLocalHierachy) {

            bIsValidattionError = false;

            dmHelperUtility = New APTS_DMHelperUtility();
            // active flag must always be set as true
            if (localHierachy.APTS_Active__c != 'TRUE') {
                bIsValidattionError = true;
                dmHelperUtility.appendErrorMessage('Local Hierarchy records must always be set as True \n');
            }

            //    Check Local Product Hierarchy Code is not null and that this code is present in the Category Hierarchy object
            if (localHierachy.APTS_Local_Product_Hierarchy_Code__c == null || localHierachy.APTS_Local_Product_Hierarchy_Code__c.length() == 0) {

                bIsValidattionError = true;
                dmHelperUtility.appendErrorMessage('Local Hierarchy code is null or not present in category hierarchy \n');
            }
            //    Ensure that Level 1 Code, Level 2 Code, Level 3 Code, and Level 4 Code are populated (not null).
            if (localHierachy.APTS_Level1_Name__c == null) {
                bIsValidattionError = true;
                dmHelperUtility.appendErrorMessage('Local Hierarchy APTS_Level1_Name__c cannot be null \n');
            }

            if (localHierachy.APTS_Level2_Name__c == null) {
                bIsValidattionError = true;
                dmHelperUtility.appendErrorMessage('Local Hierarchy APTS_Level2_Name__c cannot be null \n');
            }


            if (localHierachy.APTS_Level3_Name__c == null) {
                bIsValidattionError = true;
                dmHelperUtility.appendErrorMessage('Local Hierarchy APTS_Level3_Name__c cannot be null \n');
            }


            if (localHierachy.APTS_Level4_Name__c == null) {
                bIsValidattionError = true;
                dmHelperUtility.appendErrorMessage('Local Hierarchy APTS_Level4_Name__c cannot be null \n');
            }


            //    Level 1 Code should be LP Spain
            if (localHierachy.APTS_Level1_Code__c == null || (localHierachy.APTS_Level1_Code__c.length() > 0 && localHierachy.APTS_Level1_Code__c != APTS_DMConstants.CATEGORY_NAME)) {
                bIsValidattionError = true;
                dmHelperUtility.appendErrorMessage('Level-1 Code must always be set as LP Spain');
            }

            if (localHierachy.APTS_Level1_Name__c != null) {

                if (String.isBlank(localHierachy.APTS_Level1_Code__c)) {
                    bIsValidattionError = true;
                    dmHelperUtility.appendErrorMessage('Level-1 Code cannot be null, Level-1 Name is not null \n');
                }
            }
            if (localHierachy.APTS_Level2_Name__c != null) {

                if (String.isBlank(localHierachy.APTS_Level2_Code__c)) {
                    bIsValidattionError = true;
                    dmHelperUtility.appendErrorMessage('Level-2 Code cannot be null, Level-2 Name is not null \n');
                }
            }
            if (localHierachy.APTS_Level3_Name__c != null) {

                if (String.isBlank(localHierachy.APTS_Level3_Code__c)) {
                    bIsValidattionError = true;
                    dmHelperUtility.appendErrorMessage('Level-3 Code cannot be null, Level-3 Name is not null \n');
                }
            }

            String levelCodeConcatenation = localHierachy.APTS_Level2_Code__c + localHierachy.APTS_Level3_Code__c + localHierachy.APTS_Level4_Code__c;
            if (localHierachy.APTS_Local_Product_Hierarchy_Code__c != levelCodeConcatenation) {
                bIsValidattionError = true;
                dmHelperUtility.appendErrorMessage('Local Product Hierarchy code is invalid.');
            }

            /**Need to uncomment for prod
              if (localHierachy.APTS_Owner__c != null) {
                  if(!userNameSet.contains(localHierachy.APTS_Owner__c) && !userEmailSet.contains(localHierachy.APTS_Owner__c)) {
                       bisValidattionError = true;
                       system.debug('HS-->Valid values in owner field are Full Name or Email-ID');
                       dmHelperUtility.appendErrorMessage('Invalid owner \n');
                  }
              }else{
                 bisValidattionError = true;
                 system.debug('HS-->Valid values in owner field are Full Name or Email-ID');
                 dmHelperUtility.appendErrorMessage('Invalid owner \n');
              }
              */
            dmHelperUtility.updateValidationStatus(localHierachy, bIsValidattionError);
            listUpdatedLocalHierachy.add(localHierachy);

        } // End of For Loop

        // List of localHierachy
        if (listUpdatedLocalHierachy.size() > 0) {
            system.debug('HS--> Size of Product to be updated' + listUpdatedLocalHierachy.size());
            try {
                Database.UpsertResult[] results = Database.upsert(listUpdatedLocalHierachy);
                system.debug('HS--Approval' + results);
            } catch (Exception ex) {
                System.debug('Exception while upserting Staging Product Line Tree Data.\nException : ' + ex.getMessage());
            }
        }


    }

    public static APTS_CopyDataWrapper copyLocalHierarchyLevelFourInProduct(List < APTS_Stage_Local_Hierarchy__c > listLocalHierarchy) {

        APTS_CopyDataWrapper oCopyWrapper = new APTS_CopyDataWrapper();

        system.debug('Copying Data from Staging Object to Normal Object for Local Product');

        Id devRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(APTS_DMConstants.LOCAL_HIERACHY).getRecordTypeId();
        system.debug('HS--> Local-Record-Id : ' + devRecordTypeId);

        List < Product2 > listProduct2 = new List < Product2 > ();

        Schema.SObjectField f = Product2.Fields.APTS_External_Id__c;

        List < String > ownerNameList = new List < String > ();
        for (APTS_Stage_Local_Hierarchy__c oStageLocalHierarchy: listLocalHierarchy) {
            if (oStageLocalHierarchy.APTS_Owner__c != null) {
                ownerNameList.add(oStageLocalHierarchy.APTS_Owner__c);
            }
        }
        if (ownerNameList != null && ownerNameList.size() > 0) APTS_DMHelper.setActiveUserList(ownerNameList);

        // Creating Product with Record Type 'Local Hierarchy', assigning values and adding into List.
        for (APTS_Stage_Local_Hierarchy__c oStageLocalHierarchy: listLocalHierarchy) {

            Product2 oProduct2 = new Product2();
            oProduct2.RecordTypeId = devRecordTypeId;
            oProduct2.description = oStageLocalHierarchy.APTS_Level4_Name__c;
            oProduct2.name = oStageLocalHierarchy.APTS_Level4_Name__c;
            oProduct2.Apttus_Config2__ConfigurationType__c = 'Standalone';
            oProduct2.APTS_LP_Is_Hierarchy__c = true;
            oProduct2.IsActive = Boolean.valueOf(oStageLocalHierarchy.APTS_Active__c);
            oProduct2.APTS_Hierarchy_Level__c = 4;
            oProduct2.APTS_Hierarchy_Level_3_Code__c = oStageLocalHierarchy.APTS_Level3_Code__c;
            oProduct2.APTS_Hierarchy_Level_4_Code__c = oStageLocalHierarchy.APTS_Level4_Code__c;
            oProduct2.APTS_LP_Product_Hierarchy__c = oStageLocalHierarchy.APTS_Local_Product_Hierarchy_Code__c;
            oProduct2.APTS_GTV_Level__c = oStageLocalHierarchy.APTS_Level3_Name__c;
            oProduct2.APTS_Product_ID__c = oProduct2.APTS_LP_Product_Hierarchy__c;
            oProduct2.ProductCode = oProduct2.APTS_LP_Product_Hierarchy__c;
            oProduct2.APTS_External_ID__c = oProduct2.APTS_LP_Product_Hierarchy__c;
            listProduct2.add(oProduct2);
        }

        // Upserting the list
        try {
            if (listProduct2.size() > 0) {
                Database.UpsertResult[] results = Database.upsert(listProduct2, f, false);
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
                            System.debug('ProductLine fields that affected this error: ' + err.getFields());
                            System.debug('Id of Record that is failed: ' + sr.getId());
                        }
                    }
                }

                APTS_DMHelper.updateLoadingStatus(successIdSet, 'Product2', 'APTS_External_ID__c', 'APTS_Local_Product_Hierarchy_Code__c', listLocalHierarchy);

                system.debug('HS1--> ' + oCopyWrapper);

            }


        } catch (Exception e) {
            System.debug('Exception while upserting Local Hierarchy as Product records.\nException : ' + e.getMessage());
            oCopyWrapper.sErrorMessage = e.getMessage();
            oCopyWrapper.bIsUpsertFail = true;
        }

        return oCopyWrapper;
    }

    public static APTS_CopyDataWrapper copyLocalHierarchyLevelThreeInProduct(List < APTS_Stage_Local_Hierarchy__c > listLocalHierarchy) {

        APTS_CopyDataWrapper oCopyWrapper = new APTS_CopyDataWrapper();

        system.debug('Copying Data from Staging Object to Normal Object for Local Product');

        Id devRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(APTS_DMConstants.LOCAL_HIERACHY).getRecordTypeId();

        system.debug('HS--> Local-Record-Id : ' + devRecordTypeId);

        List < Product2 > listProduct2 = new List < Product2 > ();
        Set < String > setLevelThreeCodeAndName = new Set < String > ();
        //Set<String> setLevelThreeName = new Set<String>();
        List < APTS_Stage_Local_Hierarchy__c > listStageLocalHierarchy = new List < APTS_Stage_Local_Hierarchy__c > ();

        Schema.SObjectField f = Product2.Fields.APTS_External_Id__c;

        for (APTS_Stage_Local_Hierarchy__c oStageLocalHierarchy: listLocalHierarchy) {

            if (!setLevelThreeCodeAndName.contains(oStageLocalHierarchy.APTS_Level3_Code__c + oStageLocalHierarchy.APTS_Level3_Name__c)) {
                setLevelThreeCodeAndName.add(oStageLocalHierarchy.APTS_Level3_Code__c + oStageLocalHierarchy.APTS_Level3_Name__c);
                listStageLocalHierarchy.add(oStageLocalHierarchy);
            }
        }

        // Creating Product with Record Type 'Local Hierarchy', assigning values and adding into List.
        for (APTS_Stage_Local_Hierarchy__c oStageLocalHierarchy: listStageLocalHierarchy) {

            Product2 oProduct2 = new Product2();
            oProduct2.RecordTypeId = devRecordTypeId;
            oProduct2.description = oStageLocalHierarchy.APTS_Level3_Name__c;
            oProduct2.name = oStageLocalHierarchy.APTS_Level3_Name__c;
            oProduct2.Apttus_Config2__ConfigurationType__c = 'Standalone';
            oProduct2.APTS_LP_Is_Hierarchy__c = true;
            oProduct2.IsActive = Boolean.valueOf(oStageLocalHierarchy.APTS_Active__c);
            oProduct2.APTS_Hierarchy_Level__c = 3;
            oProduct2.APTS_Hierarchy_Level_3_Code__c = oStageLocalHierarchy.APTS_Level3_Code__c;
            oProduct2.APTS_LP_Product_Hierarchy__c = oStageLocalHierarchy.APTS_Level2_Code__c + oStageLocalHierarchy.APTS_Level3_Code__c;
            oProduct2.APTS_GTV_Level__c = oStageLocalHierarchy.APTS_Level3_Name__c;
            oProduct2.APTS_Product_ID__c = oProduct2.APTS_LP_Product_Hierarchy__c;
            oProduct2.ProductCode = oProduct2.APTS_LP_Product_Hierarchy__c;
            oProduct2.APTS_External_ID__c = oProduct2.APTS_LP_Product_Hierarchy__c;
            listProduct2.add(oProduct2);
        }

        // Upserting the list
        try {
            if (listProduct2.size() > 0) {
                Database.UpsertResult[] results = Database.upsert(listProduct2, f, false);
                system.debug('HS--> Error ' + results);

                // Iterate through each returned result
                for (Database.UpsertResult sr: results) {

                    if (sr.isSuccess()) {
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

                system.debug('HS1--> ' + oCopyWrapper);

            }


        } catch (Exception e) {
            System.debug('Exception while upserting Local Hierarchy as Product records.\nException : ' + e.getMessage());
            oCopyWrapper.sErrorMessage = e.getMessage();
            oCopyWrapper.bIsUpsertFail = true;
        }

        return oCopyWrapper;
    }

    public static APTS_CopyDataWrapper copyLocalHierarchyLevelTwoInProduct(List < APTS_Stage_Local_Hierarchy__c > listLocalHierarchy) {

        system.debug('Copying Data from Staging Object to Normal Object for Local Product');

        APTS_CopyDataWrapper oCopyWrapper = new APTS_CopyDataWrapper();

        Id devRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(APTS_DMConstants.LOCAL_HIERACHY).getRecordTypeId();

        system.debug('HS--> Local-Record-Id : ' + devRecordTypeId);

        List < Product2 > listProduct2 = new List < Product2 > ();
        Set < String > setLevelTwoCodeAndName = new Set < String > ();
        //Set<String> setLevelThreeName = new Set<String>();
        List < APTS_Stage_Local_Hierarchy__c > listStageLocalHierarchy = new List < APTS_Stage_Local_Hierarchy__c > ();
        Schema.SObjectField f = Product2.Fields.APTS_External_Id__c;

        for (APTS_Stage_Local_Hierarchy__c oStageLocalHierarchy: listLocalHierarchy) {

            if (!setLevelTwoCodeAndName.contains(oStageLocalHierarchy.APTS_Level2_Code__c + oStageLocalHierarchy.APTS_Level2_Name__c)) {
                setLevelTwoCodeAndName.add(oStageLocalHierarchy.APTS_Level2_Code__c + oStageLocalHierarchy.APTS_Level2_Name__c);
                listStageLocalHierarchy.add(oStageLocalHierarchy);
            }
        }

        // Creating Product with Record Type 'Local Hierarchy', assigning values and adding into List.
        for (APTS_Stage_Local_Hierarchy__c oStageLocalHierarchy: listStageLocalHierarchy) {

            Product2 oProduct2 = new Product2();
            oProduct2.RecordTypeId = devRecordTypeId;
            oProduct2.description = oStageLocalHierarchy.APTS_Level2_Name__c;
            oProduct2.name = oStageLocalHierarchy.APTS_Level2_Name__c;
            oProduct2.Apttus_Config2__ConfigurationType__c = 'Standalone';
            oProduct2.APTS_LP_Is_Hierarchy__c = true;
            oProduct2.IsActive = Boolean.valueOf(oStageLocalHierarchy.APTS_Active__c);
            oProduct2.APTS_Hierarchy_Level__c = 2;
            oProduct2.APTS_LP_Product_Hierarchy__c = oStageLocalHierarchy.APTS_Level2_Code__c;
            oProduct2.APTS_Product_ID__c = oProduct2.APTS_LP_Product_Hierarchy__c;
            oProduct2.ProductCode = oProduct2.APTS_LP_Product_Hierarchy__c;
            oProduct2.APTS_External_ID__c = oProduct2.APTS_LP_Product_Hierarchy__c;
            listProduct2.add(oProduct2);
        }

        // Upserting the list
        try {
            if (listProduct2.size() > 0) {
                Database.UpsertResult[] results = Database.upsert(listProduct2, f, false);
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
                            System.debug('ProductLine fields that affected this error: ' + err.getFields());
                            System.debug('Id of Record that is failed: ' + sr.getId());
                        }
                    }
                }
                APTS_DMHelper.updateLoadingStatus(successIdSet, 'Product2', 'APTS_External_ID__c', 'APTS_Level2_Code__c', listStageLocalHierarchy);
                system.debug('HS1--> ' + oCopyWrapper);

            }


        } catch (Exception e) {
            System.debug('Exception while upserting Local Hierarchy as Product records.\nException : ' + e.getMessage());
            oCopyWrapper.sErrorMessage = e.getMessage();
            oCopyWrapper.bIsUpsertFail = true;
        }
        return oCopyWrapper;
    }

    public static APTS_CopyDataWrapper createCategory() {

        APTS_CopyDataWrapper oCopyWrapper = new APTS_CopyDataWrapper();

        system.debug('Create Category LP Spain');

        List < Apttus_Config2__ClassificationName__c > listCategory = new List < Apttus_Config2__ClassificationName__c > ();
        Apttus_Config2__ClassificationName__c oCategory = new Apttus_Config2__ClassificationName__c();

        //Schema.SObjectField f = Apttus_Config2__ClassificationName__c.Fields.APTS_External_Id__c;
        
        List<Apttus_Config2__ClassificationName__c> listCategoryQuery = [Select Id, Name from Apttus_Config2__ClassificationName__c where Name =: APTS_DMConstants.CATEGORY_NAME ];

        System.debug('Size and null'+ listCategoryQuery.size() + 'Null'+listCategoryQuery);
        
        if((listCategoryQuery.size() == 0) || (listCategoryQuery == NULL)) {
            
        oCategory.Name = APTS_DMConstants.CATEGORY_NAME;
        oCategory.Apttus_Config2__HierarchyLabel__c = APTS_DMConstants.CATEGORY_LABEL;
        oCategory.Apttus_Config2__Active__c = true;
        oCategory.Apttus_Config2__Type__c = 'Offering';
        oCategory.CurrencyIsoCode = APTS_DMConstants.SPAIN_CURRENCY;
        oCategory.APTS_External_Id__c = APTS_DMConstants.CATEGORY_NAME;

        listCategory.add(oCategory);
        }

        // Upserting the list
        try {
            if (listCategory.size() > 0) {
                Database.SaveResult[] results = Database.insert(listCategory,true);
            system.debug('HS--> Error ' + results);

            // Iterate through each returned result
                for (Database.SaveResult sr: results) {

                if (sr.isSuccess()) {
                        System.debug('Successfully inserted Catrgory: ' + sr.getId());
                } else {
                    // Operation failed, so get all errors 
                    oCopyWrapper.bIsUpsertFail = true;
                    for (Database.Error err: sr.getErrors()) {
                        System.debug('The following error has occurred.');
                        oCopyWrapper.sErrorMessage = oCopyWrapper.sErrorMessage + '<br/><br/>' + err.getStatusCode() + ': ' + err.getMessage();
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Category fields that affected this error: ' + err.getFields());
                        System.debug('Id of Record that is failed: ' + sr.getId());
                    }
                }
            }

            system.debug('HS1--> ' + oCopyWrapper);

            }

        } catch (Exception e) {
            System.debug('Exception while upserting Root Category \nException : ' + e.getMessage());
            oCopyWrapper.sErrorMessage = e.getMessage();
            oCopyWrapper.bIsUpsertFail = true;
        }
        return oCopyWrapper;
    }
    
    public static APTS_CopyDataWrapper createPriceList() {

        APTS_CopyDataWrapper oCopyWrapper = new APTS_CopyDataWrapper();

        system.debug('Create Price List LP Spain');

        List < Apttus_Config2__PriceList__c > listPriceList = new List < Apttus_Config2__PriceList__c > ();
        Apttus_Config2__PriceList__c oPriceList = new Apttus_Config2__PriceList__c();

       // Schema.SObjectField f = Apttus_Config2__PriceList__c.Fields.APTS_External_Id__c;
        
        List<Apttus_Config2__PriceList__c> listPriceListQuery = [Select Id, Name from Apttus_Config2__PriceList__c where Name =: APTS_DMConstants.CATEGORY_NAME ];

        if((listPriceListQuery.size() == 0) || (listPriceListQuery == NULL)) {
            
        oPriceList.Name = APTS_DMConstants.CATEGORY_NAME;
        oPriceList.Apttus_Config2__Active__c = true;
        oPriceList.APTS_Country__c = 'Spain';
        oPriceList.CurrencyIsoCode = APTS_DMConstants.SPAIN_CURRENCY;

        listPriceList.add(oPriceList);
        }
        // Upserting the list
        try {
            if (listPriceList.size() > 0) {
                Database.SaveResult[] results = Database.insert(listPriceList,true);
            system.debug('HS--> Error ' + results);

            // Iterate through each returned result
                for (Database.SaveResult sr: results) {

                if (sr.isSuccess()) {
                    System.debug('Successfully inserted Price List: ' + sr.getId());
                } else {
                    // Operation failed, so get all errors 
                    oCopyWrapper.bIsUpsertFail = true;
                    for (Database.Error err: sr.getErrors()) {
                        System.debug('The following error has occurred.');
                        oCopyWrapper.sErrorMessage = oCopyWrapper.sErrorMessage + '<br/><br/>' + err.getStatusCode() + ': ' + err.getMessage();
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Following fields that affected this error: ' + err.getFields());
                        System.debug('Id of Record that is failed: ' + sr.getId());
                    }
                }
            }

            system.debug('HS1--> ' + oCopyWrapper);

            }

        } catch (Exception e) {
            System.debug('Exception while upserting Root Price List \nException : ' + e.getMessage());
            oCopyWrapper.sErrorMessage = e.getMessage();
            oCopyWrapper.bIsUpsertFail = true;
        }
        return oCopyWrapper;
    }

    public static APTS_CopyDataWrapper associatePriceListWithCategory() {

        APTS_CopyDataWrapper oCopyWrapper = new APTS_CopyDataWrapper();

        system.debug('Associate Price List LP Spain to root Category LP Spian');

        List < Apttus_Config2__PriceListCategory__c > listPriceListCategory = new List < Apttus_Config2__PriceListCategory__c > ();
        Apttus_Config2__PriceListCategory__c oPriceListCategory = new Apttus_Config2__PriceListCategory__c();

        //Schema.SObjectField f = Apttus_Config2__PriceListCategory__c.Fields.APTS_External_Id__c;

        List < Apttus_Config2__ClassificationName__c > listCategoryQuery = [Select Id, Name from Apttus_Config2__ClassificationName__c where Name = : APTS_DMConstants.CATEGORY_NAME];
        List < Apttus_Config2__PriceList__c > listPriceListQuery = [Select Id, Name from Apttus_Config2__PriceList__c where Name = : APTS_DMConstants.CATEGORY_NAME];
        if (listCategoryQuery.size() > 1 || listPriceListQuery.size() > 1) {

            oCopyWrapper.sErrorMessage = oCopyWrapper.sErrorMessage + '<br/><br/> You have more than One Category OR Price List with name LP Spain';
        } else {

            List < Apttus_Config2__PriceListCategory__c > listPriceListCategoryQuery = [Select Id, Name from Apttus_Config2__PriceListCategory__c where
            Apttus_Config2__HierarchyId__c = : listCategoryQuery[0].Id AND Apttus_Config2__PriceListId__c = : listPriceListQuery[0].Id];
            System.debug('List Price List Query' + listPriceListQuery);
            System.debug('listCategoryQuery[0].Id' + listCategoryQuery[0].Id);
            System.debug('listPriceListQuery[0].Id' + listPriceListQuery[0].Id);

            if ((listPriceListCategoryQuery.size() == 0) || (listPriceListCategoryQuery == NULL)) {

                oPriceListCategory.Apttus_Config2__HierarchyId__c = listCategoryQuery[0].Id;
                oPriceListCategory.Apttus_Config2__PriceListId__c = listPriceListQuery[0].Id;
                oPriceListCategory.Apttus_Config2__Sequence__c = 1;

                listPriceListCategory.add(oPriceListCategory);
            }

            // Upserting the list
            try {
                if (listPriceListCategory.size() > 0) {
                    Database.SaveResult[] results = Database.insert(listPriceListCategory, true);
                    system.debug('HS--> Error ' + results);

                    // Iterate through each returned result
                    for (Database.SaveResult sr: results) {

                        if (sr.isSuccess()) {
                            System.debug('Successfully inserted Price List Category: ' + sr.getId());
                        } else {
                            // Operation failed, so get all errors 
                            oCopyWrapper.bIsUpsertFail = true;
                            for (Database.Error err: sr.getErrors()) {
                                System.debug('The following error has occurred.');
                                oCopyWrapper.sErrorMessage = oCopyWrapper.sErrorMessage + '<br/><br/>' + err.getStatusCode() + ': ' + err.getMessage();
                                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                System.debug('Following fields that affected this error: ' + err.getFields());
                                System.debug('Id of Record that is failed: ' + sr.getId());
                            }
                        }
                    }

                    system.debug('HS1--> ' + oCopyWrapper);

                }

            } catch (Exception e) {
                System.debug('Exception while inserting Price List Category \nException : ' + e.getMessage());
                oCopyWrapper.sErrorMessage = e.getMessage();
                oCopyWrapper.bIsUpsertFail = true;
            }

        }

        return oCopyWrapper;
    }

    public static APTS_CopyDataWrapper copyLocalHierarchyLevelTwoInCategoryHierarchy(List < APTS_Stage_Local_Hierarchy__c > listLocalHierarchy) {

        system.debug('Copying Data from Staging Object to Normal Object for Category Hierarchy');

        APTS_CopyDataWrapper oCopyWrapper = new APTS_CopyDataWrapper();

        //Id devRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(APTS_DMConstants.LOCAL_HIERACHY).getRecordTypeId();
        //system.debug('HS--> Local-Record-Id : ' + devRecordTypeId );

        List < Apttus_Config2__ClassificationHierarchy__c > listCategoryHierarchy = new List < Apttus_Config2__ClassificationHierarchy__c > ();
        Set < String > setLevelTwoCodeAndName = new Set < String > ();
        //Set<String> setLevelThreeName = new Set<String>();
        Map < String, APTS_Stage_Local_Hierarchy__c > mapStageLocalHierarchy = new Map < String, APTS_Stage_Local_Hierarchy__c > ();
        List < APTS_Stage_Local_Hierarchy__c > listStageLocalHierarchy = new List < APTS_Stage_Local_Hierarchy__c > ();
        Schema.SObjectField f = Apttus_Config2__ClassificationHierarchy__c.Fields.APTS_External_Id__c;

        for (APTS_Stage_Local_Hierarchy__c oStageLocalHierarchy: listLocalHierarchy) {

            if (!setLevelTwoCodeAndName.contains(oStageLocalHierarchy.APTS_Level2_Code__c + oStageLocalHierarchy.APTS_Level2_Name__c)) {
                setLevelTwoCodeAndName.add(oStageLocalHierarchy.APTS_Level2_Code__c + oStageLocalHierarchy.APTS_Level2_Name__c);
                listStageLocalHierarchy.add(oStageLocalHierarchy);
                mapStageLocalHierarchy.put(oStageLocalHierarchy.APTS_Level2_Name__c, oStageLocalHierarchy);
            }
        }

        // STH Changes: changed to List based queries instead of single record queries.
        Apttus_Config2__ClassificationName__c oCategoryQuery = null;
        List < Apttus_Config2__ClassificationName__c > categories = [Select Id, Name from Apttus_Config2__ClassificationName__c where Name = : APTS_DMConstants.CATEGORY_NAME LIMIT 1];
        if (categories != null && categories.size() == 1) {
            oCategoryQuery = categories[0];
        }

        Apttus_Config2__ClassificationHierarchy__c oCategoryHierarchyQuery = null;
        List < Apttus_Config2__ClassificationHierarchy__c > catHierarchies = [Select Id, Name from Apttus_Config2__ClassificationHierarchy__c where Name = : APTS_DMConstants.CATEGORY_NAME LIMIT 1];
        if (catHierarchies != null && catHierarchies.size() == 1) {
            oCategoryHierarchyQuery = catHierarchies[0];
        }
        // End STH changes

        APTS_Stage_Data_Validation_Rules_Setting__c oDataValidationSetting;
        if(APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration') != null) {
            oDataValidationSetting = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration');
        }
        List < String > listCategorySequence;
        if(oDataValidationSetting.APTS_Category_Sequence__c !=null) {
            listCategorySequence = oDataValidationSetting.APTS_Category_Sequence__c.split(';');
        }
        for (integer i = 0; i < listCategorySequence.size(); i++)
        listCategorySequence[i] = listCategorySequence[i].trim();

        System.debug('listCategorySequence' + listCategorySequence);

        for (String str: listCategorySequence) {

            if (mapStageLocalHierarchy.containsKey(str)) {

                System.debug('mapStageLocalHierarchy.get(str)' + mapStageLocalHierarchy.get(str));
                Apttus_Config2__ClassificationHierarchy__c oCategoryHierarchy = new Apttus_Config2__ClassificationHierarchy__c();
                
                if(mapStageLocalHierarchy.get(str) != null) {
                    
                    oCategoryHierarchy.Name = mapStageLocalHierarchy.get(str).APTS_Level2_Name__c;
                    oCategoryHierarchy.Apttus_Config2__Label__c = mapStageLocalHierarchy.get(str).APTS_Level2_Name__c;
                    oCategoryHierarchy.APTS_LP_Code__c = mapStageLocalHierarchy.get(str).APTS_Level2_Code__c;
                    oCategoryHierarchy.APTS_LP_Code_Full_Hierarchy__c = mapStageLocalHierarchy.get(str).APTS_Level2_Code__c;
                    oCategoryHierarchy.Apttus_Config2__Level__c = 1;
                    oCategoryHierarchy.Apttus_Config2__HierarchyId__c = oCategoryQuery.Id;
                    oCategoryHierarchy.Apttus_Config2__AncestorId__c = oCategoryHierarchyQuery.Id;
                    oCategoryHierarchy.Apttus_Config2__PrimordialId__c = oCategoryHierarchyQuery.Id;
                    oCategoryHierarchy.APTS_External_Id__c = mapStageLocalHierarchy.get(str).APTS_Level2_Code__c;
                    oCategoryHierarchy.Apttus_Config2__MaxOptions__c = 1;
                    oCategoryHierarchy.Apttus_Config2__MinOptions__c = 1;
                    oCategoryHierarchy.CurrencyIsoCode = APTS_DMConstants.SPAIN_CURRENCY;
                    oCategoryHierarchy.Apttus_Config2__Modifiable__c = true;
                    
                }

                try {

                    Database.UpsertResult results = Database.upsert(oCategoryHierarchy, f, false);
                    //rebuildCategoryHierachies();
                    system.debug('HS--> Error ' + results);
                    List < Apttus_Config2__ClassificationHierarchy__c > listCategoryHierarchyQuery = [Select Id, Name, Apttus_Config2__Label__c, APTS_LP_Code__c, Apttus_Config2__Level__c, Apttus_Config2__Left__c, Apttus_Config2__Right__c from Apttus_Config2__ClassificationHierarchy__c where Apttus_Config2__Level__c = 1];
                    System.debug('listCategoryHierarchyQuery Root Level***' + listCategoryHierarchyQuery);

                    if (results.isSuccess()) {
                        System.debug('Successfully inserted accountID: ' + results.getId());
                    } else {
                        // Operation failed, so get all errors 
                        oCopyWrapper.bIsUpsertFail = true;
                        for (Database.Error err: results.getErrors()) {

                            System.debug('The following error has occurred.');
                            oCopyWrapper.sErrorMessage = oCopyWrapper.sErrorMessage + '<br/><br/>' + err.getStatusCode() + ': ' + err.getMessage();
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Category Hierarchy Level 2 fields that affected this error: ' + err.getFields());
                            System.debug('Id of Record that is failed: ' + results.getId());
                        }

                    }

                    system.debug('HS1--> ' + oCopyWrapper);

                } catch (Exception e) {
                    System.debug('Exception while upserting Local Hierarchy as Category Hierarchy records.\nException : ' + e.getMessage());
                    oCopyWrapper.sErrorMessage = e.getMessage();
                    oCopyWrapper.bIsUpsertFail = true;
                }

            }
        }

        rebuildCategoryHierachies();
        List < Apttus_Config2__ClassificationHierarchy__c > listCategoryHierarchyQuery = [Select Id, Name, Apttus_Config2__Label__c, APTS_LP_Code__c, Apttus_Config2__Level__c, Apttus_Config2__Left__c, Apttus_Config2__Right__c from Apttus_Config2__ClassificationHierarchy__c where Apttus_Config2__Level__c = 1];
        System.debug('listCategoryHierarchyQuery Root Level***' + listCategoryHierarchyQuery);
        return oCopyWrapper;
    }

    public static APTS_CopyDataWrapper copyESCategoryHierarchy() {

        system.debug('Copying Data from Staging Object to Normal Object for ES Category Hierarchy');

        APTS_CopyDataWrapper oCopyWrapper = new APTS_CopyDataWrapper();

        List < Apttus_Config2__ClassificationHierarchy__c > listESCategoryHierarchy = new List < Apttus_Config2__ClassificationHierarchy__c > ();

        Schema.SObjectField f = Apttus_Config2__ClassificationHierarchy__c.Fields.APTS_External_Id__c;

        // STH Changes: changed to List based queries instead of single record queries.
        Apttus_Config2__ClassificationName__c oCategoryQuery = null;
        List < Apttus_Config2__ClassificationName__c > categories = [Select Id, Name from Apttus_Config2__ClassificationName__c where Name = : APTS_DMConstants.CATEGORY_NAME LIMIT 1];
        if (categories != null && categories.size() == 1) {
            oCategoryQuery = categories[0];
        }

        Apttus_Config2__ClassificationHierarchy__c oCategoryHierarchyQuery = null;
        List < Apttus_Config2__ClassificationHierarchy__c > catHierarchies = [Select Id, Name from Apttus_Config2__ClassificationHierarchy__c where Name = : APTS_DMConstants.CATEGORY_NAME LIMIT 1];
        if (catHierarchies != null && catHierarchies.size() == 1) {
            oCategoryHierarchyQuery = catHierarchies[0];
        }
        // End STH changes

        // Manually Create ES Hierarchy for Binding Hierarchy as a Product
        Apttus_Config2__ClassificationHierarchy__c oCategoryHierarchy = new Apttus_Config2__ClassificationHierarchy__c();
        oCategoryHierarchy.Name = 'ES - Hierarchy';
        oCategoryHierarchy.Apttus_Config2__Label__c = 'ES - Hierarchy';
        oCategoryHierarchy.Apttus_Config2__Level__c = 1;
        oCategoryHierarchy.Apttus_Config2__HierarchyId__c = oCategoryQuery.Id;
        oCategoryHierarchy.Apttus_Config2__AncestorId__c = oCategoryHierarchyQuery.Id;
        oCategoryHierarchy.Apttus_Config2__PrimordialId__c = oCategoryHierarchyQuery.Id;
        oCategoryHierarchy.APTS_External_Id__c = 'ES - Hierarchy';
        oCategoryHierarchy.Apttus_Config2__MaxOptions__c = 1;
        oCategoryHierarchy.Apttus_Config2__MinOptions__c = 1;
        oCategoryHierarchy.CurrencyIsoCode = APTS_DMConstants.SPAIN_CURRENCY;
        oCategoryHierarchy.Apttus_Config2__Modifiable__c = true;

        listESCategoryHierarchy.add(oCategoryHierarchy);

        // Upserting the list
        try {
            if (listESCategoryHierarchy.size() > 0) {
                Database.UpsertResult[] results = Database.upsert(listESCategoryHierarchy, f, false);
                system.debug('HS--> Error ' + results);

                // Iterate through each returned result
                for (Database.UpsertResult sr: results) {

                    if (sr.isSuccess()) {
                        System.debug('Successfully inserted accountID: ' + sr.getId());
                    } else {
                        // Operation failed, so get all errors 
                        oCopyWrapper.bIsUpsertFail = true;
                        for (Database.Error err: sr.getErrors()) {
                            System.debug('The following error has occurred.');
                            oCopyWrapper.sErrorMessage = oCopyWrapper.sErrorMessage + '<br/><br/>' + err.getStatusCode() + ': ' + err.getMessage();
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Category Hierarchy Level 2 fields that affected this error: ' + err.getFields());
                            System.debug('Id of Record that is failed: ' + sr.getId());
                        }
                    }
                }

                system.debug('HS1--> ' + oCopyWrapper);

            }


        } catch (Exception e) {
            System.debug('Exception while upserting Local Hierarchy as Category Hierarchy records.\nException : ' + e.getMessage());
            oCopyWrapper.sErrorMessage = e.getMessage();
            oCopyWrapper.bIsUpsertFail = true;
        }
        rebuildCategoryHierachies();
        List < Apttus_Config2__ClassificationHierarchy__c > listCategoryHierarchyQuery = [Select Id, Name, Apttus_Config2__Label__c, APTS_LP_Code__c, Apttus_Config2__Level__c, Apttus_Config2__Left__c, Apttus_Config2__Right__c from Apttus_Config2__ClassificationHierarchy__c where Apttus_Config2__Level__c = 1];
        System.debug('listCategoryHierarchyQuery ES-Hierarchy***' + listCategoryHierarchyQuery);
        return oCopyWrapper;
    }

    public static APTS_CopyDataWrapper copyLocalHierarchyLevelThreeInCategoryHierarchy(List < APTS_Stage_Local_Hierarchy__c > listLocalHierarchy) {

        APTS_CopyDataWrapper oCopyWrapper = new APTS_CopyDataWrapper();

        system.debug('Copying Data from Staging Object to Normal Object for Local Product');

        List < Apttus_Config2__ClassificationHierarchy__c > listCategoryHierarchy = new List < Apttus_Config2__ClassificationHierarchy__c > ();
        Set < String > setLevelThreeCodeAndName = new Set < String > ();
        //Set<String> setLevelThreeName = new Set<String>();
        List < APTS_Stage_Local_Hierarchy__c > listStageLocalHierarchy = new List < APTS_Stage_Local_Hierarchy__c > ();

        Schema.SObjectField f = Apttus_Config2__ClassificationHierarchy__c.Fields.APTS_External_Id__c;

        for (APTS_Stage_Local_Hierarchy__c oStageLocalHierarchy: listLocalHierarchy) {

            if (!setLevelThreeCodeAndName.contains(oStageLocalHierarchy.APTS_Level3_Code__c + oStageLocalHierarchy.APTS_Level3_Name__c)) {
                setLevelThreeCodeAndName.add(oStageLocalHierarchy.APTS_Level3_Code__c + oStageLocalHierarchy.APTS_Level3_Name__c);
                listStageLocalHierarchy.add(oStageLocalHierarchy);
            }
        }

        Apttus_Config2__ClassificationName__c oCategoryQuery = [Select Id, Name from Apttus_Config2__ClassificationName__c where Name = : APTS_DMConstants.CATEGORY_NAME LIMIT 1];
        Apttus_Config2__ClassificationHierarchy__c oCategoryHierarchyQuery = [Select Id, Name from Apttus_Config2__ClassificationHierarchy__c where Name = : APTS_DMConstants.CATEGORY_NAME LIMIT 1];
        List < Apttus_Config2__ClassificationHierarchy__c > listCategoryHierarchyLevelOne = [Select Id, Name, APTS_LP_Code__c from Apttus_Config2__ClassificationHierarchy__c where Apttus_Config2__Level__c = 1];
        Map < String, Apttus_Config2__ClassificationHierarchy__c > mapCategoryHierarchyLevelOne = new Map < String, Apttus_Config2__ClassificationHierarchy__c > ();

        for (Apttus_Config2__ClassificationHierarchy__c oCategoryHierarchy: listCategoryHierarchyLevelOne) {

            mapCategoryHierarchyLevelOne.put(oCategoryHierarchy.APTS_LP_Code__c + oCategoryHierarchy.Name, oCategoryHierarchy);
        }

        // Creating Product with Record Type 'Local Hierarchy', assigning values and adding into List.
        for (APTS_Stage_Local_Hierarchy__c oStageLocalHierarchy: listStageLocalHierarchy) {

            Apttus_Config2__ClassificationHierarchy__c oCategoryHierarchy = new Apttus_Config2__ClassificationHierarchy__c();
            oCategoryHierarchy.Name = oStageLocalHierarchy.APTS_Level3_Name__c;
            oCategoryHierarchy.Apttus_Config2__Label__c = oStageLocalHierarchy.APTS_Level3_Name__c;
            oCategoryHierarchy.APTS_LP_Code__c = oStageLocalHierarchy.APTS_Level3_Code__c;
            oCategoryHierarchy.APTS_LP_Code_Full_Hierarchy__c = oStageLocalHierarchy.APTS_Level2_Code__c + oStageLocalHierarchy.APTS_Level3_Code__c;
            oCategoryHierarchy.Apttus_Config2__Level__c = 2;
            oCategoryHierarchy.Apttus_Config2__HierarchyId__c = oCategoryQuery.Id;
            oCategoryHierarchy.Apttus_Config2__AncestorId__c = mapCategoryHierarchyLevelOne.get(oStageLocalHierarchy.APTS_Level2_Code__c + oStageLocalHierarchy.APTS_Level2_Name__c).Id;
            oCategoryHierarchy.Apttus_Config2__PrimordialId__c = oCategoryHierarchyQuery.Id;
            oCategoryHierarchy.APTS_External_Id__c = oStageLocalHierarchy.APTS_Level2_Code__c + oStageLocalHierarchy.APTS_Level3_Code__c;
            oCategoryHierarchy.Apttus_Config2__MaxOptions__c = 1;
            oCategoryHierarchy.Apttus_Config2__MinOptions__c = 1;
            oCategoryHierarchy.CurrencyIsoCode = APTS_DMConstants.SPAIN_CURRENCY;
            oCategoryHierarchy.Apttus_Config2__Modifiable__c = true;

            listCategoryHierarchy.add(oCategoryHierarchy);
        }

        // Upserting the list
        try {
            if (listCategoryHierarchy.size() > 0) {
                Database.UpsertResult[] results = Database.upsert(listCategoryHierarchy, f, false);
                system.debug('HS--> Error ' + results);

                // Iterate through each returned result
                for (Database.UpsertResult sr: results) {

                    if (sr.isSuccess()) {
                        System.debug('Successfully inserted accountID: ' + sr.getId());
                    } else {
                        // Operation failed, so get all errors 
                        oCopyWrapper.bIsUpsertFail = true;
                        for (Database.Error err: sr.getErrors()) {
                            System.debug('The following error has occurred.');
                            oCopyWrapper.sErrorMessage = oCopyWrapper.sErrorMessage + '<br/><br/>' + err.getStatusCode() + ': ' + err.getMessage();
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Category Hierarchy Level 2 fields that affected this error: ' + err.getFields());
                            System.debug('Id of Record that is failed: ' + sr.getId());
                        }
                    }
                }

                system.debug('HS1--> ' + oCopyWrapper);

            }


        } catch (Exception e) {
            System.debug('Exception while upserting Local Hierarchy as Category Hierarchy records.\nException : ' + e.getMessage());
            oCopyWrapper.sErrorMessage = e.getMessage();
            oCopyWrapper.bIsUpsertFail = true;
        }
        rebuildCategoryHierachies();
        List < Apttus_Config2__ClassificationHierarchy__c > listCategoryHierarchyQuery = [Select Id, Name, Apttus_Config2__Label__c, APTS_LP_Code__c, Apttus_Config2__Level__c, Apttus_Config2__Left__c, Apttus_Config2__Right__c from Apttus_Config2__ClassificationHierarchy__c];
        System.debug('listCategoryHierarchyQuery Level 3***' + listCategoryHierarchyQuery);
        return oCopyWrapper;
    }

    public static APTS_CopyDataWrapper copyLocalHierarchyLevelFourInCategoryHierarchy(List < APTS_Stage_Local_Hierarchy__c > listLocalHierarchy) {

        APTS_CopyDataWrapper oCopyWrapper = new APTS_CopyDataWrapper();

        system.debug('Copying Data from Staging Object to Normal Object for Local Product');

        List < Apttus_Config2__ClassificationHierarchy__c > listCategoryHierarchy = new List < Apttus_Config2__ClassificationHierarchy__c > ();

        Schema.SObjectField f = Apttus_Config2__ClassificationHierarchy__c.Fields.APTS_External_Id__c;

        Apttus_Config2__ClassificationName__c oCategoryQuery = [Select Id, Name from Apttus_Config2__ClassificationName__c where Name = : APTS_DMConstants.CATEGORY_NAME LIMIT 1];
        Apttus_Config2__ClassificationHierarchy__c oCategoryHierarchyQuery = [Select Id, Name from Apttus_Config2__ClassificationHierarchy__c where Name = : APTS_DMConstants.CATEGORY_NAME LIMIT 1];
        List < Apttus_Config2__ClassificationHierarchy__c > listCategoryHierarchyLevelTwo = [Select Id, Name, APTS_LP_Code__c from Apttus_Config2__ClassificationHierarchy__c where Apttus_Config2__Level__c = 2];
        Map < String, Apttus_Config2__ClassificationHierarchy__c > mapCategoryHierarchyLevelTwo = new Map < String, Apttus_Config2__ClassificationHierarchy__c > ();

        for (Apttus_Config2__ClassificationHierarchy__c oCategoryHierarchy: listCategoryHierarchyLevelTwo) {

            mapCategoryHierarchyLevelTwo.put(oCategoryHierarchy.APTS_LP_Code__c + oCategoryHierarchy.Name, oCategoryHierarchy);
        }

        // Creating Product with Record Type 'Local Hierarchy', assigning values and adding into List.
        for (APTS_Stage_Local_Hierarchy__c oStageLocalHierarchy: listLocalHierarchy) {

            Apttus_Config2__ClassificationHierarchy__c oCategoryHierarchy = new Apttus_Config2__ClassificationHierarchy__c();
            oCategoryHierarchy.Name = oStageLocalHierarchy.APTS_Level4_Name__c;
            oCategoryHierarchy.Apttus_Config2__Label__c = oStageLocalHierarchy.APTS_Level4_Name__c;
            oCategoryHierarchy.APTS_LP_Code__c = oStageLocalHierarchy.APTS_Level4_Code__c;
            oCategoryHierarchy.APTS_LP_Code_Full_Hierarchy__c = oStageLocalHierarchy.APTS_Local_Product_Hierarchy_Code__c;
            oCategoryHierarchy.Apttus_Config2__Level__c = 3;
            oCategoryHierarchy.Apttus_Config2__HierarchyId__c = oCategoryQuery.Id;
            oCategoryHierarchy.Apttus_Config2__AncestorId__c = mapCategoryHierarchyLevelTwo.get(oStageLocalHierarchy.APTS_Level3_Code__c + oStageLocalHierarchy.APTS_Level3_Name__c).Id;
            oCategoryHierarchy.Apttus_Config2__PrimordialId__c = oCategoryHierarchyQuery.Id;
            oCategoryHierarchy.APTS_External_Id__c = oStageLocalHierarchy.APTS_Local_Product_Hierarchy_Code__c;
            oCategoryHierarchy.Apttus_Config2__MaxOptions__c = 1;
            oCategoryHierarchy.Apttus_Config2__MinOptions__c = 1;
            oCategoryHierarchy.CurrencyIsoCode = APTS_DMConstants.SPAIN_CURRENCY;
            oCategoryHierarchy.Apttus_Config2__Modifiable__c = true;

            listCategoryHierarchy.add(oCategoryHierarchy);
        }

        // Upserting the list
        try {
            if (listCategoryHierarchy.size() > 0) {
                Database.UpsertResult[] results = Database.upsert(listCategoryHierarchy, f, false);
                system.debug('HS--> Error ' + results);

                // Iterate through each returned result
                for (Database.UpsertResult sr: results) {
                    if (sr.isSuccess()) {
                        System.debug('Successfully inserted accountID: ' + sr.getId());
                    } else {
                        // Operation failed, so get all errors 
                        oCopyWrapper.bIsUpsertFail = true;
                        for (Database.Error err: sr.getErrors()) {
                            System.debug('The following error has occurred.');
                            oCopyWrapper.sErrorMessage = oCopyWrapper.sErrorMessage + '<br/><br/>' + err.getStatusCode() + ': ' + err.getMessage();
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Category Hierarchy Level 3 fields that affected this error: ' + err.getFields());
                            System.debug('Id of Record that is failed: ' + sr.getId());
                        }
                    }
                }
                system.debug('HS1--> ' + oCopyWrapper);
            }

        } catch (Exception e) {
            System.debug('Exception while upserting Local Hierarchy as Category Hierarchy records.\nException : ' + e.getMessage());
            oCopyWrapper.sErrorMessage = e.getMessage();
            oCopyWrapper.bIsUpsertFail = true;
        }

        rebuildCategoryHierachies();
        List < Apttus_Config2__ClassificationHierarchy__c > listCategoryHierarchyQuery = [Select Id, Name, Apttus_Config2__Label__c, APTS_LP_Code__c, Apttus_Config2__Level__c, Apttus_Config2__Left__c, Apttus_Config2__Right__c from Apttus_Config2__ClassificationHierarchy__c where Apttus_Config2__Level__c =1];
        System.debug('listCategoryHierarchyQuery***' + listCategoryHierarchyQuery);
        return oCopyWrapper;
    }

    public static APTS_CopyDataWrapper copyLocalHierarchyInProductClassification() {

        APTS_CopyDataWrapper oCopyWrapper = new APTS_CopyDataWrapper();

        system.debug('Copying Data from Staging Object to Normal Object for Local Product');

        List < Apttus_Config2__ProductClassification__c > listProductClassification = new List < Apttus_Config2__ProductClassification__c > ();

        Schema.SObjectField f = Apttus_Config2__ProductClassification__c.Fields.APTS_External_Id__c;

        List < Product2 > oProductQuery = [Select Id, Name, APTS_LP_Product_Hierarchy__c from Product2 where RecordType.Name = : APTS_DMConstants.LOCAL_HIERACHY AND APTS_External_ID__c != NULL];
        System.debug('oProductQuery Size' + oProductQuery.size());
        Apttus_Config2__ClassificationHierarchy__c oCategoryHierarchy = [Select Id, Name from Apttus_Config2__ClassificationHierarchy__c where Name = 'ES - Hierarchy'
        LIMIT 1];
        // Creating Product with Record Type 'Local Hierarchy', assigning values and adding into List.
        for (Product2 oProduct: oProductQuery) {

            Apttus_Config2__ProductClassification__c oProductClassification = new Apttus_Config2__ProductClassification__c();
            oProductClassification.Apttus_Config2__ProductId__c = oProduct.Id;
            oProductClassification.APTS_External_Id__c = oProduct.APTS_LP_Product_Hierarchy__c;
            oProductClassification.Apttus_Config2__ClassificationId__c = oCategoryHierarchy.Id;
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

                // Iterate through each returned result
                for (Database.UpsertResult sr: results) {
                    if (sr.isSuccess()) {
                        System.debug('Successfully inserted accountID: ' + sr.getId());
                    } else {
                        // Operation failed, so get all errors 
                        oCopyWrapper.bIsUpsertFail = true;
                        for (Database.Error err: sr.getErrors()) {
                            System.debug('The following error has occurred.');
                            oCopyWrapper.sErrorMessage = oCopyWrapper.sErrorMessage + '<br/><br/>' + err.getStatusCode() + ': ' + err.getMessage();
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Local Hierarchy to Product Classification fields that affected this error: ' + err.getFields());
                            System.debug('Id of Record that is failed: ' + sr.getId());
                        }
                    }
                }
                system.debug('HS1--> ' + oCopyWrapper);
            }

        } catch (Exception e) {
            System.debug('Exception while upserting Local Hierarchy as Product Classification records.\nException : ' + e.getMessage());
            oCopyWrapper.sErrorMessage = e.getMessage();
            oCopyWrapper.bIsUpsertFail = true;
        }

        return oCopyWrapper;

    }

    //API to incorporate Logic of Left and Right
    public static APTS_CopyDataWrapper rebuildCategoryHierachies() {

        APTS_CopyDataWrapper oCopyWrapper = new APTS_CopyDataWrapper();

        List < Apttus_Config2__ClassificationName__c > categories = [select id from Apttus_Config2__ClassificationName__c where name = : APTS_DMConstants.CATEGORY_NAME];

        try {
            if (categories != null && categories.size() > 0) {
                List < Id > hierarchies = new List < Id > ();
                hierarchies.add(categories[0].id);
                //Temp:  Need to fix
                Apttus_CPQApi.CPQWebService.rebuildCategoryHierachies(hierarchies);
            } else {

                oCopyWrapper.bIsUpsertFail = true;
                system.debug('missing categories of name LP Spain');
            }


        } catch (Exception e) {
            System.debug('Exception while setting Left Right.\nException : ' + e.getMessage());
            oCopyWrapper.sErrorMessage = e.getMessage();
            oCopyWrapper.bIsUpsertFail = true;
        }

        return oCopyWrapper;

    }
}