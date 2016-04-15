public class APTS_DMMSPAHelper extends APTS_DMHelper {
    
    public class DMMSPAHelperException extends Exception {}
    
    /**
     * This method contains Bussniess Validation Rule for Validating Stage MSPA Object
     *  Written-By : Hardik Shah 
     * 
     * */

    public static void validateStageMSPA(List < APTS_Stage_MSPA__c > listStageMSPA) {

        // Boolean Variable to indicate Validation Error
        Boolean bisValidattionError = false;
        Boolean isValidateOwner = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_Validate_SFDC_User__c;
        APTS_DMHelperUtility dmHelperUtility;

        // Set of masterCode from MasterPickList Table
        Set < String > setMasterCode = new Set < String > ();
        // Set of Account-Name in MSPA
        Set < String > setMSPA_Account_Name = new Set < String > ();
        // Set of Valid Account-Name from Account Object
        Set < String > setValidAccount_Name = new Set < String > ();
        // list of Stage-MSPA Object that are updated.
        List < APTS_Stage_MSPA__c > listUpdatedStageMSPA = new List < APTS_Stage_MSPA__c > ();

        // sales office set to lookup in lso entries
        Set < String > salesOfficeSet = New Set < String > ();
        Set < String > sapCustomerIdSet = New Set < String > ();

        //*Sreekanth
        List < String > ownerNameandSalesPersonList = new List < String > ();

        // Iterate over for loop and store Indirect-Customer
        for (APTS_Stage_MSPA__c stageMSPA: listStageMSPA) {
            if (stageMSPA.APTS_Final_Indirect_Customer_SPA__c != null && string.isNotBlank(stageMSPA.APTS_Final_Indirect_Customer_SPA__c)) {
                setMSPA_Account_Name.add(stageMSPA.APTS_Final_Indirect_Customer_SPA__c);
            }
            if (stageMSPA.APTS_Sales_Office_SPA__c != null) {
                salesOfficeSet.add(stageMSPA.APTS_Sales_Office_SPA__c);

            }
            if (stageMSPA.APTS_SAP_Customer_ID__c != null && stageMSPA.APTS_SAP_Customer_ID__c.length() > 0) {
                sapCustomerIdSet.add(stageMSPA.APTS_SAP_Customer_ID__c);
            }
            if (stageMSPA.APTS_Owner__c != null && stageMSPA.APTS_Owner__c.length() > 0) {
                ownerNameandSalesPersonList.add(stageMSPA.APTS_Owner__c);
            }
            if (stageMSPA.APTS_Sales_Person_SPA__c != null && stageMSPA.APTS_Sales_Person_SPA__c.length() > 0) {
                ownerNameandSalesPersonList.add(stageMSPA.APTS_Sales_Person_SPA__c);
            }
        }
        if (ownerNameandSalesPersonList != null && ownerNameandSalesPersonList.size() > 0) 
            APTS_DMHelper.setActiveUserList(ownerNameandSalesPersonList);

        Map < String, LSO_Field_Entries__c > lsoFieldEntryCodeMap = validateSalesOffice(salesOfficeSet);

        // Fetch list of Name from Account Object those are in Indirect-Customer Set 
        List < Account > listAccountName = [Select Name from Account WHERE NAME IN: setMSPA_Account_Name];

        if (listAccountName != null && listAccountName.size() > 0) {
            // Populate the list to set
            for (Account acc: listAccountName) {
                setValidAccount_Name.add(acc.name);
            }
        }

        // for direct customer validation ,we need to create a map of sap customer id from local operational data (LOD)
        // and then validate that the stageMSPA record has the sap customer id which exists in LOD, here we are populating that map4

        List < APTS_Stage_Local_Operational_Data__c > listStgLOD = [Select APTS_LP_SAP_Customer_ID__c from APTS_Stage_Local_Operational_Data__c WHERE APTS_LP_SAP_Customer_ID__c IN: sapCustomerIdSet];
        List < APTS_LP_Local_Customer_Reference_Data__c > listLOD = [Select APTS_LP_SAP_Customer_ID__c from APTS_LP_Local_Customer_Reference_Data__c WHERE APTS_LP_SAP_Customer_ID__c IN: sapCustomerIdSet];

        Map < String, sObject > lodMap = New Map < String, sObject > ();

        if (listStgLod != null && listStgLOD.size() > 0) {
            for (APTS_Stage_Local_Operational_Data__c lodSo: listStgLOD) {
                if (lodSo.APTS_LP_SAP_Customer_ID__c != null && lodSo.APTS_LP_SAP_Customer_ID__c.length() > 0) {
                    lodMap.put(lodSo.APTS_LP_SAP_Customer_ID__c, lodSo);

                }
            }

        }


        if (listLod != null && listLOD.size() > 0) {
            for (APTS_LP_Local_Customer_Reference_Data__c lodSo: listLOD) {
                if (lodSo.APTS_LP_SAP_Customer_ID__c != null && lodSo.APTS_LP_SAP_Customer_ID__c.length() > 0) {
                    lodMap.put(lodSo.APTS_LP_SAP_Customer_ID__c, lodSo);

                }
            }

        }

        // fetch the list of Mastercodes from Master-PickList
        List < APTS_Master_Picklist_Table__c > listMasterCode = APTS_DMHelper.getMasterListCodes();
        List < APTS_Stage_Master_Picklist__c > listStageMasterCode = APTS_DMHelper.getMasterListCodesFromStage();

        // Create a set of MasterPickList codes
        for (APTS_Master_Picklist_Table__c masterCode: listMasterCode) {
            setMasterCode.add(masterCode.APTS_Code__c);
        }

        // Create a set of Stage MasterPickList codes
        for (APTS_Stage_Master_Picklist__c masterCode: listStageMasterCode) {
            setMasterCode.add(masterCode.APTS_Code__c);
        }

        system.debug('HS-->' + setMasterCode);

        for (APTS_Stage_MSPA__c stageMSPA: listStageMSPA) {

            bisValidattionError = false;
            dmHelperUtility = New APTS_DMHelperUtility();
            // Validation Check for Distribution-Channel
            if (stageMSPA.APTS_DistributionChannel_SPA__c != null && setMasterCode.contains(stageMSPA.APTS_DistributionChannel_SPA__c)) {
                // No Error
            } else {
                bisValidattionError = true;
                dmHelperUtility.appendErrorMessage('Invalid Distribution-Channel-Code: ' + stageMSPA.APTS_DistributionChannel_SPA__c + ' \n');
                system.debug('Invalid Distribution-Channel-Code: ' + stageMSPA.APTS_DistributionChannel_SPA__c);
            }
            
              // Validation APTS_Owner__c populated with the First & Last name from the User Object
              if (!string.IsBlank(stageMSPA.APTS_Owner__c)) {
                  if(!APTS_DMHelper.validateUser(stageMSPA.APTS_Owner__c)) {
                     bisValidattionError = true;
                     dmHelperUtility.appendErrorMessage('No Active owner found in users \n');
                  }
              } else {
                    bisValidattionError = true;
                    dmHelperUtility.appendErrorMessage('Invalid Owner Name \n');
              }
            
              // Validation APTS_Owner__c populated with the First & Last name from the User Object
              if (!string.IsBlank(stageMSPA.APTS_Sales_Person_SPA__c)) {
                  if(!APTS_DMHelper.validateUser(stageMSPA.APTS_Sales_Person_SPA__c)) {
                     bisValidattionError = true;
                     dmHelperUtility.appendErrorMessage('Sales Person not Active \n');
                  }
              } else {
                    bisValidattionError = true;
                    dmHelperUtility.appendErrorMessage('Invalid Sales Person \n');
              }
            
            // Validation Check for Sales-Office which needs to be looked up in LSO FIeld Entries instead of master picklist
            if (stageMSPA.APTS_Sales_Office_SPA__c != null && stageMSPA.APTS_Sales_Office_SPA__c.length() > 0 && lsoFieldEntryCodeMap.keySet().contains(stageMSPA.APTS_Sales_Office_SPA__c)) {
                // No Error
            } else {
                bisValidattionError = true;
                dmHelperUtility.appendErrorMessage('Invalid Sales-Office-Code \n');
                system.debug('Invalid Sales-Office-Code');
            }

            // Validation Check for Channel
            if (stageMSPA.APTS_ChannelSetValue_Code__c != null && setMasterCode.contains(stageMSPA.APTS_ChannelSetValue_Code__c)) {
                // No Error
            } else {
                bisValidattionError = true;
                dmHelperUtility.appendErrorMessage('Invalid Local Channel-Code \n');
                system.debug('Invalid Local-Channel -Code');
            }

            // Validation Check for incoterms
            if (stageMSPA.APTS_Incoterms_methods_Code__c != null && setMasterCode.contains(stageMSPA.APTS_Incoterms_methods_Code__c)) {
                // No Error
            } else {
                bisValidattionError = true;
                dmHelperUtility.appendErrorMessage('Invalid Incoterms Code \n');
                system.debug('Invalid Incoterms Code');
            }
            
            // Validation Check for Max Order Amount
            if (stageMSPA.APTS_Max_Order_Amount_SPA__c <= 0) {
            
                    bisValidattionError = true;
                    dmHelperUtility.appendErrorMessage('Invalid Max Order Amount: '+ stageMSPA.APTS_Max_Order_Amount_SPA__c+' \n');
                    system.debug('Invalid Max Order Amount:'+ stageMSPA.APTS_Max_Order_Amount_SPA__c);
                
            }

            // Validation Check for Payment-Term
            if (stageMSPA.APTS_Payment_Terms_SPA__c != null) {
                if (setMasterCode.contains(stageMSPA.APTS_Payment_Terms_SPA__c)) {
                    // No Error
                } else {
                    bisValidattionError = true;
                    dmHelperUtility.appendErrorMessage('Invalid Paytment Term \n');
                    //  sErrorMessage = sErrorMessage + 'Invalid Paytment Term \n';
                    system.debug('Invalid Payment Term');
                }
            }

            // Validation Check for SAP Division
            if (stageMSPA.APTS_SAP_Division_SPA__c != null && setMasterCode.contains(stageMSPA.APTS_SAP_Division_SPA__c)) {
                // No Error
            } else {
                bisValidattionError = true;
                dmHelperUtility.appendErrorMessage('Invalid SAP Division \n');
                system.debug('Invalid SAP Division');
            }

            /* // Validation Check for SAP Sales Orgniazation
         if(stageMSPA.APTS_Sales_Organization_SPA__c != null) {
             if(setMasterCode.contains(stageMSPA.APTS_Sales_Organization_SPA__c)){
                   // No Error
               }
               else{
                    bisValidattionError = true;
                sErrorMessage = sErrorMessage + 'Invalid SAP Sales Organization \n';
                system.debug('Invalid SAP Sales Organization');
               }
         }*/


            // Validtion error for direct-Customer Name
            if (String.isNotBlank(stageMSPA.APTS_Direct_Customer__c) && lodMap.containsKey(stageMSPA.APTS_SAP_Customer_ID__c)) {
                // No Error
            } else {
                bisValidattionError = true;
                dmHelperUtility.appendErrorMessage('Direct Customer SAP Customer ID ' + stageMSPA.APTS_SAP_Customer_ID__c + ' missing in LOD.  \n');
                system.debug('Direct Customer SAP Customer ID ' + stageMSPA.APTS_SAP_Customer_ID__c + ' missing in LOD.');
            }
            dmHelperUtility.updatevalidationstatus(stageMSPA, bIsValidattionError);
            listUpdatedStageMSPA.add(stageMSPA);

        } // End of for loop

        // List of localHierachy
        if (listUpdatedStageMSPA.size() > 0) {
            system.debug('HS--> Size of Product to be updated' + listUpdatedStageMSPA.size());
            try {
                Database.UpsertResult[] results = Database.upsert(listUpdatedStageMSPA);
                system.debug('HS--MSPA Data' + results);
            } catch (Exception ex) {
                System.debug('Exception while upserting MSPA Data.\nException : ' + ex.getMessage());
            }
        }

    }

    public static APTS_CopyDataWrapper copyMSPA(List < APTS_Stage_MSPA__c > listMSPA) {

        APTS_CopyDataWrapper oCopyWrapper = new APTS_CopyDataWrapper();

        system.debug('Copying Data from Staging Object to Normal Object for Local Product');

        List < Apttus_Config2__PriceList__c > priceListSoLst = [select id from Apttus_Config2__PriceList__c where Apttus_Config2__Active__c = true];

        Id priceListId; //save
        if (priceListSoLst != null && priceListSoLst.size() > 0) {

            priceListId = priceListSoLst.get(0).id;
        }

        Id devRecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('MSPA').getRecordTypeId();

        List < Apttus__APTS_Agreement__c > listAgreement = new List < Apttus__APTS_Agreement__c > ();
        Set < String > setSAPCustomerId = new Set < String > ();
        Map < String, APTS_LP_Local_Customer_Reference_Data__c > mapLocalReferenceData = new Map < String, APTS_LP_Local_Customer_Reference_Data__c > ();
        Set < String > salesOfficeSet = New Set < String > ();
        List < String > ownerNameandSalesPersonList = new List < String > ();
        
        for (APTS_Stage_MSPA__c oStageMSPA: listMSPA) {

            setSAPCustomerId.add(oStageMSPA.APTS_SAP_Customer_ID__c);

            if (oStageMSPA.APTS_Owner__c != null && oStageMSPA.APTS_Owner__c.length() > 0) {
                ownerNameandSalesPersonList.add(oStageMSPA.APTS_Owner__c);
            }
            if (oStageMSPA.APTS_Sales_Person_SPA__c != null && oStageMSPA.APTS_Sales_Person_SPA__c.length() > 0) {
                ownerNameandSalesPersonList.add(oStageMSPA.APTS_Sales_Person_SPA__c);
            }
            if (oStageMSPA.APTS_Sales_Office_SPA__c != null) {
                salesOfficeSet.add(oStageMSPA.APTS_Sales_Office_SPA__c);
            }
        }
        
        if (ownerNameandSalesPersonList != null && ownerNameandSalesPersonList.size() > 0) 
            APTS_DMHelper.setActiveUserList(ownerNameandSalesPersonList);

        Set < String > setIndirectCustomerAccount = new Set < String > ();
        Map < String, Account > mapValidIndirectCustomerAccount = new Map < String, Account > ();
        Set < String > sapCustomerIdSet = New Set < String > ();
        for (APTS_Stage_MSPA__c stageMSPA: listMSPA) {
            if (stageMSPA.APTS_Final_Indirect_Customer_SPA__c != null && string.isNotBlank(stageMSPA.APTS_Final_Indirect_Customer_SPA__c)) {
                if(stageMSPA.APTS_Final_Indirect_Customer_SPA__c.isNumeric()) {
                   sapCustomerIdSet.add(stageMSPA.APTS_Final_Indirect_Customer_SPA__c);
                } else {
                   setIndirectCustomerAccount.add(stageMSPA.APTS_Final_Indirect_Customer_SPA__c);
                }
            }

            if (stageMSPA.APTS_SAP_Customer_ID__c != null && stageMSPA.APTS_SAP_Customer_ID__c.length() > 0) {
                sapCustomerIdSet.add(stageMSPA.APTS_SAP_Customer_ID__c);
            }


        }

        // Fetch list of Name from Account Object those are in Indirect-Customer Set 
        if (setIndirectCustomerAccount.size() > 0) {
            List < Account > listAccountName = [Select id, Name from Account WHERE NAME IN: setIndirectCustomerAccount];

            if (listAccountName != null && listAccountName.size() > 0) {
                // Populate the list to set
                for (Account acc: listAccountName) {
                    mapValidIndirectCustomerAccount.put(acc.name, acc);
                }
            }
        }


        // for direct customer validation ,we need to create a map of sap customer id from local operational data (LOD)
        // and then validate that the stageMSPA record has the sap customer id which exists in LOD, here we are populating that map
        Map < String, APTS_LP_Local_Customer_Reference_Data__c > lodMap = New Map < String, APTS_LP_Local_Customer_Reference_Data__c > ();
        if (sapCustomerIdSet.size() > 0) {
            List < APTS_LP_Local_Customer_Reference_Data__c > listLOD = [Select APTS_LP_SAP_Customer_ID__c, APTS_LP_Account__c from APTS_LP_Local_Customer_Reference_Data__c WHERE APTS_LP_SAP_Customer_ID__c IN: sapCustomerIdSet];

            if (listLod != null && listLOD.size() > 0) {
                for (APTS_LP_Local_Customer_Reference_Data__c lodSo: listLOD) {
                    if (lodSo.APTS_LP_SAP_Customer_ID__c != null && lodSo.APTS_LP_SAP_Customer_ID__c.length() > 0) {
                        lodMap.put(lodSo.APTS_LP_SAP_Customer_ID__c, lodSo);
                    }
                }

            }
        }

        List < APTS_LP_Local_Customer_Reference_Data__c > listLocalReferenceDataQuery = [Select Id, Name, APTS_LP_Account__c, APTS_LP_SAP_Customer_ID__c from APTS_LP_Local_Customer_Reference_Data__c
        where APTS_LP_SAP_Customer_ID__c IN: setSAPCustomerId];

        for (APTS_LP_Local_Customer_Reference_Data__c oLocalReferenceData: listLocalReferenceDataQuery) {

            mapLocalReferenceData.put(oLocalReferenceData.APTS_LP_SAP_Customer_ID__c, oLocalReferenceData);
        }
        System.debug('mapLocalReferenceData' + mapLocalReferenceData);
        Schema.SObjectField f = Apttus__APTS_Agreement__c.Fields.APTS_SAP_Reference_No__c;

        Apttus__APTS_Agreement__c oAgreement = null;
        //try {

        Set < String > masterCodeSet = New Set < String > ();
        Set < String > localChannelSet = New Set < String > ();
        Set < String > distributionSet = New Set < String > ();
        Set < String > incotermsSet = New Set < String > ();
        Set < String > paymentTermsSet = New Set < String > ();

        for (APTS_Stage_MSPA__c oStageMSPA: listMSPA) {

            if (oStageMSPA.APTS_ChannelSetValue_Code__c != null && oStageMSPA.APTS_ChannelSetValue_Code__c.length() > 0) {
                masterCodeSet.add(oStageMSPA.APTS_ChannelSetValue_Code__c);
                localChannelSet.add(oStageMSPA.APTS_ChannelSetValue_Code__c);
            }

            if (oStageMSPA.APTS_DistributionChannel_SPA__c != null && oStageMSPA.APTS_DistributionChannel_SPA__c.length() > 0) {
                masterCodeSet.add(oStageMSPA.APTS_DistributionChannel_SPA__c);
                distributionSet.add(oStageMSPA.APTS_DistributionChannel_SPA__c);
            }

            if (oStageMSPA.APTS_Incoterms_methods_Code__c != null && oStageMSPA.APTS_Incoterms_methods_Code__c.length() > 0) {
                masterCodeSet.add(oStageMSPA.APTS_Incoterms_methods_Code__c);
                incotermsSet.add(oStageMSPA.APTS_Incoterms_methods_Code__c);
            }

            if (oStageMSPA.APTS_Payment_Terms_SPA__c != null && oStageMSPA.APTS_Payment_Terms_SPA__c.length() > 0) {
                masterCodeSet.add(oStageMSPA.APTS_Payment_Terms_SPA__c);
                paymentTermsSet.add(oStageMSPA.APTS_Payment_Terms_SPA__c);
            }

        }

        LIst < APTS_Master_Picklist_Table__c > masterPicklistSoLst = [select id, APTS_Code__c, name
        from APTS_Master_Picklist_Table__c
        where
        APTS_Locale__c = : APTS_DMConstants.SPAIN_LOCALE
        AND(
        (APTS_Code__c in : localChannelSet and APTS_Code_Used_For__c = 'Local Channel')
        OR(APTS_Code__c in : distributionSet and APTS_Code_Used_For__c = 'Distribution Channel')
        OR(APTS_Code__c in : incotermsSet and APTS_Code_Used_For__c = 'Incoterm')
        OR(APTS_Code__c in : paymentTermsSet and APTS_Code_Used_For__c = 'Payment Term')
        OR(APTS_Code__c in : salesOfficeSet and APTS_Code_Used_For__c = 'Sales Office'))];


        Map < String, String > masterPicklistCodeNameMap = New Map < String, String > ();
        Map < String, Id > masterPicklistCodeIdMap = New Map < String, Id > ();
        if (masterPicklistSoLst.size() > 0) {

            for (APTS_Master_Picklist_Table__c masterPicklistSo: masterPicklistSoLst) {
                masterPicklistCodeNameMap.put(masterPicklistSo.APTS_Code__c, masterPicklistSo.name);
                masterPicklistCodeIdMap.put(masterPicklistSo.APTS_Code__c, masterPicklistSo.id);
            }

        }

        Map < String, LSO_Field_Entries__c > lsoFieldEntryCodeMap = validateSalesOffice(salesOfficeSet);


        // Creating Approval Rule Matrix, assigning values and adding into List.
        for (APTS_Stage_MSPA__c oStageMSPA: listMSPA) {

            oAgreement = new Apttus__APTS_Agreement__c();
            oAgreement.APTS_SPA_Identifier__c = oStageMSPA.APTS_SPA_Identifier_SPA__c;
            oAgreement.Apttus__Status_Category__c = APTS_DMConstants.READY_FOR_SIGNATURES;
            oAgreement.Apttus__Status__c = oStageMSPA.APTS_SPA_Status_SPA__c;
            oAgreement.APTS_Locale__c = APTS_DMConstants.SPAIN_LOCALE;
            oAgreement.APTS_LP_Sales_Organization__c = oStageMSPA.APTS_Sales_Organization_SPA__c;
            oAgreement.Apttus_CMConfig__PricingDate__c = oStageMSPA.APTS_Price_Date_SPA__c;
            oAgreement.APTS_Country__c= APTS_DMConstants.APPROVAL_COUNTRY;
            oAgreement.APTS_LP_Sales_Person__c = APTS_DMHelper.getUserforLoad(oStageMSPA.APTS_Sales_Person_SPA__c);

            if (oStageMSPA.APTS_SAP_Customer_ID__c != null && oStageMSPA.APTS_SAP_Customer_ID__c.length() > 0) {
                if (lodMap.containsKey(oStageMSPA.APTS_SAP_Customer_ID__c)) {
                    oAgreement.Apttus__Account__c = lodMap.get(oStageMSPA.APTS_SAP_Customer_ID__c).APTS_LP_Account__c;
                    oAgreement.APTS_LP_AccountCustomer__c = lodMap.get(oStageMSPA.APTS_SAP_Customer_ID__c).APTS_LP_Account__c;
                }
            }

            // populate the primary partner customer for indirect cutsomer
            if (oStageMSPA.APTS_Final_Indirect_Customer_SPA__c != null && oStageMSPA.APTS_Final_Indirect_Customer_SPA__c.length() > 0) {
                if(oStageMSPA.APTS_Final_Indirect_Customer_SPA__c.isNumeric() && lodMap.containsKey(oStageMSPA.APTS_SAP_Customer_ID__c)) {
                    oAgreement.APTS_LP_Account_End_User__c = lodMap.get(oStageMSPA.APTS_SAP_Customer_ID__c).APTS_LP_Account__c;
                } else {
                    if (mapValidIndirectCustomerAccount.containsKey(oStageMSPA.APTS_Final_Indirect_Customer_SPA__c)) 
                    oAgreement.APTS_LP_Account_End_User__c = mapValidIndirectCustomerAccount.get(oStageMSPA.APTS_Final_Indirect_Customer_SPA__c).id;
                }
            }

            oAgreement.APTS_SAP_Customer_ID__c = oStageMSPA.APTS_SAP_Customer_ID__c;
            if (priceListId != null) {
                oAgreement.Apttus_CMConfig__PriceListId__c = priceListId;
            }
            //todo get the description from master piclist object of locale es_ES
            if (oStageMSPA.APTS_ChannelSetValue_Code__c != null && oStageMSPA.APTS_ChannelSetValue_Code__c.length() > 0 && masterPicklistCodeNameMap.containsKey(oStageMSPA.APTS_ChannelSetValue_Code__c)) {
                oAgreement.APTS_Local_Channel_Description__c = masterPicklistCodeNameMap.get(oStageMSPA.APTS_ChannelSetValue_Code__c);
                oAgreement.APTS_Local_Channel__c = masterPicklistCodeIdMap.get(oStageMSPA.APTS_ChannelSetValue_Code__c);
            }

            if (oStageMSPA.APTS_Incoterms_methods_Code__c != null && oStageMSPA.APTS_Incoterms_methods_Code__c.length() > 0 && masterPicklistCodeNameMap.containsKey(oStageMSPA.APTS_Incoterms_methods_Code__c)) {
                oAgreement.APTS_Incoterm_Description__c = masterPicklistCodeNameMap.get(oStageMSPA.APTS_Incoterms_methods_Code__c);
                oAgreement.APTS_Incoterms__c = masterPicklistCodeIdMap.get(oStageMSPA.APTS_Incoterms_methods_Code__c);
            }
            if (oStageMSPA.APTS_Payment_Terms_SPA__c != null && oStageMSPA.APTS_Payment_Terms_SPA__c.length() > 0 && masterPicklistCodeNameMap.containsKey(oStageMSPA.APTS_Payment_Terms_SPA__c)) {
                oAgreement.APTS_Payment_Term_Description__c = masterPicklistCodeNameMap.get(oStageMSPA.APTS_Payment_Terms_SPA__c);
                oAgreement.APTS_Payment_Terms__c = masterPicklistCodeIdMap.get(oStageMSPA.APTS_Payment_Terms_SPA__c);
            }
            if (oStageMSPA.APTS_DistributionChannel_SPA__c != null && oStageMSPA.APTS_DistributionChannel_SPA__c.length() > 0 && masterPicklistCodeIdMap.containsKey(oStageMSPA.APTS_DistributionChannel_SPA__c)) {
                oAgreement.APTS_Distribution_Channel__c = masterPicklistCodeIdMap.get(oStageMSPA.APTS_DistributionChannel_SPA__c);
            }
            //oAgreement.APTS_LP_Local_Channel__c =  oStageMSPA.APTS_ChannelSetValue_Code__c;
            //oAgreement.APTS_LP_Incoterms__c = oStageMSPA.APTS_Incoterms_methods_Code__c;
            oAgreement.APTS_LP_Distribution_Channel__c = oStageMSPA.APTS_DistributionChannel_SPA__c;
            oAgreement.APTS_Terms_of_Payment__c = oStageMSPA.APTS_Payment_Terms_SPA__c;


            oAgreement.APTS_SAP_Division__c = oStageMSPA.APTS_SAP_Division_SPA__c;
            oAgreement.Apttus__Contract_Start_Date__c = oStageMSPA.APTS_Valid_From_SPA__c;
            oAgreement.Apttus__Contract_End_Date__c = oStageMSPA.APTS_Valid_To_SPA__c;
            oAgreement.APTS_Sales_Office_Code__c = oStageMSPA.APTS_Sales_Office_SPA__c;

            if (oStageMSPA.APTS_Sales_Office_SPA__c != null && oStageMSPA.APTS_Sales_Office_SPA__c.length() > 0 && lsoFieldEntryCodeMap != null && lsoFieldEntryCodeMap.keySet().contains(oStageMSPA.APTS_Sales_Office_SPA__c)) {
                oAgreement.APTS_Sales_Office__c = lsoFieldEntryCodeMap.get(oStageMSPA.APTS_Sales_Office_SPA__c).Id;
            }
            if (oStageMSPA.APTS_Sales_Office_SPA__c != null && oStageMSPA.APTS_Sales_Office_SPA__c.length() > 0 && masterPicklistCodeIdMap!= null && masterPicklistCodeIdMap.containsKey(oStageMSPA.APTS_Sales_Office_SPA__c)) {
                oAgreement.APTS_Sales_Office_LP__c = masterPicklistCodeIdMap.get(oStageMSPA.APTS_Sales_Office_SPA__c);
            }
            oAgreement.RecordTypeId = devRecordTypeId;
            oAgreement.APTS_SAP_Reference_No__c = oStageMSPA.APTS_External_ID__c;
            oAgreement.Apttus__Description__c = oStageMSPA.APTS_Direct_Customer__c + oStageMSPA.APTS_SPA_Type_SPA__c + oStageMSPA.APTS_SPA_Identifier_SPA__c;
            oAgreement.APTS_LP_Max_Order_Amount__c = oStageMSPA.APTS_Max_Order_Amount_SPA__c;
            oAgreement.APTS_LP_MSPA_title__c = oStageMSPA.APTS_New_Apply_Reason__c;
            oAgreement.APTS_Notes__c = oStageMSPA.APTS_Notes_SPA__c;
            oAgreement.CurrencyIsoCode = oStageMSPA.APTS_Currency__c;
            oAgreement.APTS_Legacy_MSPA__c = TRUE;
            
            if(	APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration') != null && 
            	APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_Create_Audit_Fields__c) {
            	
            	oAgreement.put('CreatedDate', oStageMSPA.APTS_Created_On__c); 
            }
            
            APTS_LP_Local_Customer_Reference_Data__c lodRefData = mapLocalReferenceData.get(oStageMSPA.APTS_SAP_Customer_ID__c);
            if (lodRefData != null) oAgreement.APTS_LP_AccountCustomer__c = lodRefData.APTS_LP_Account__c;
            
            oAgreement.OwnerID = APTS_DMHelper.getUserforLoad(oStageMSPA.APTS_Owner__c);
            
            listAgreement.add(oAgreement);
        }
        
        List <APTS_Stage_MSPA_LineItems__c> mspaLineItems = null;
        Savepoint sp = Database.setSavepoint();
        
        // Upserting the list 
        try {
            if (listAgreement.size() > 0) {
                Database.UpsertResult[] results = Database.upsert(listAgreement, f, false);
                system.debug('HS--> Error ' + results);
                Set < Id > successfulMSPAIdSet = New Set < id > ();
                // Iterate through each returned result
                for (Database.UpsertResult sr: results) {

                    if (sr.isSuccess()) {

                        System.debug('Successfully inserted agreement: ' + sr.getId());

                        successfulMSPAIdSet.add(sr.getId());

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

                APTS_DMHelper.updateLoadingStatus(successfulMSPAIdSet, 'Apttus__APTS_Agreement__c', 'APTS_SAP_Reference_No__c', 'APTS_External_ID__c', listMSPA);

                if (successfulMSPAIdSet.size() > 0) {
                    // get the mspa identifier

                    List < Apttus__APTS_Agreement__c > agrSoLst = [select APTS_SPA_Identifier__c from Apttus__APTS_Agreement__c where id in : successfulMSPAIdSet];

                    if (agrSoLst != null && agrSoLst.size() > 0) {
                        Set < Decimal > spaIdentifierSet = New Set < Decimal > ();
                        for (Apttus__APTS_Agreement__c agrSo: agrSoLst) {
                            spaIdentifierSet.add(agrSo.APTS_SPA_Identifier__c);
                        }

                        if (spaIdentifierSet.size() > 0) {

                            mspaLineItems = [select Id, OwnerId, IsDeleted, Name, CurrencyIsoCode, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, APTS_CreatedBy__c, APTS_CreatedOn__c, APTS_Discount_Type__c, APTS_Discount__c, APTS_Error_Description__c, APTS_External_ID__c, APTS_Net_Price__c, APTS_Owner__c, APTS_Price_1_Gross_Price__c, APTS_Price_Unit__c, APTS_Price__c, APTS_Product_Code__c, APTS_Product_Level_3__c, APTS_Quantity__c, APTS_RowStatus__c, APTS_SPA_Identifier__c, APTS_SPA_Line_Item__c from APTS_Stage_MSPA_LineItems__c where APTS_SPA_Identifier__c in : spaIdentifierSet];
                         oCopyWrapper=  copyStageMSPALineItemToLineItem(mspaLineItems);
                            wrapupMSPALineItems(mspaLineItems);
                        }
                    }

                }


                system.debug('HS1--> ' + oCopyWrapper);
            }


        } catch (Exception e) {
            System.debug('Exception while upserting Agreement/Agreement Line Items records.\nException : ' + e.getMessage());
            oCopyWrapper.sErrorMessage = e.getMessage();
            oCopyWrapper.bIsUpsertFail = true;
            
            // Time to Roll Back!
            Database.rollback(sp);
            
            // Set the Status of the MSPA's and MSPA Line Items to Load Fail.
            setLoadFailureStatus(listMSPA, mspaLineItems);
        }
        return oCopyWrapper;
    }
    
    private static void setLoadFailureStatus(List<APTS_Stage_MSPA__c> listMSPA, List<APTS_Stage_MSPA_LineItems__c> mspaLineItems){
        // Now to set the MSPA's as "Load Fail" Status
        if( listMSPA != null && listMSPA.size() > 0 ){
            
            List<APTS_Stage_MSPA__c> toUpdate = new List<APTS_Stage_MSPA__c>();
            
            for (APTS_Stage_MSPA__c oStageMSPA: listMSPA) {
                // Create a new Record so that we don't risk updating the record with unclean data.
                APTS_Stage_MSPA__c rowStatusChangeOnly = new APTS_Stage_MSPA__c();
                rowStatusChangeOnly.Id = oStageMSPA.Id;
                rowStatusChangeOnly.APTS_RowStatus__c = APTS_DMConstants.LOAD_FAIL;
                
                toUpdate.add(rowStatusChangeOnly);
            }
            
            update toUpdate;
        }
        
        // Now to set the MSPA Line Item's as "Load Fail" Status
        if( mspaLineItems != null && mspaLineItems.size() > 0 ){
            
            List<APTS_Stage_MSPA_LineItems__c> toUpdate = new List<APTS_Stage_MSPA_LineItems__c>();
            
            for (APTS_Stage_MSPA_LineItems__c oStageMSPALineItem: mspaLineItems) {
                // Create a new Record so that we don't risk updating the record with unclean data.
                APTS_Stage_MSPA_LineItems__c rowStatusChangeOnly = new APTS_Stage_MSPA_LineItems__c();
                rowStatusChangeOnly.Id = oStageMSPALineItem.Id;
                rowStatusChangeOnly.APTS_RowStatus__c = APTS_DMConstants.LOAD_FAIL;
                
                toUpdate.add(rowStatusChangeOnly);
            }
            
            update toUpdate;
        }
    }

    /*
        Wrap up the Line Items by changing the Line Item Status AND updating the Operational record Lookup
    */
    private static void wrapupMSPALineItems(List <APTS_Stage_MSPA_LineItems__c> stageMSPALineItems) {
        Map<String, APTS_Stage_MSPA_LineItems__c> externalIds = new Map<String, APTS_Stage_MSPA_LineItems__c>();
        for( APTS_Stage_MSPA_LineItems__c lineItem : stageMSPALineItems ){
            externalIds.put(lineItem.APTS_External_Id__c, lineItem);
            lineItem.APTS_RowStatus__c = APTS_DMConstants.LOAD_FAIL; // Set it temporarily to Failure so that we don't have to iterate it again later.
        }
        
        Integer successCounter = 0;
        
        List<Apttus__AgreementLineItem__c> agreementLineItems = [SELECT Id, APTS_External_Id__c FROM Apttus__AgreementLineItem__c WHERE APTS_External_Id__c IN : externalIds.keySet()];
        if( agreementLineItems != null && agreementLineItems.size() > 0 ){
            for( Apttus__AgreementLineItem__c agreementLineItem : agreementLineItems ){
                String externalId = agreementLineItem.APTS_External_Id__c;
                
                APTS_Stage_MSPA_LineItems__c stageLineItem = externalIds.get(externalId);
                if( stageLineItem != null ){
                    stageLineItem.APTS_RowStatus__c = APTS_DMConstants.LOAD_STATUS; // Reset to success!!
                    stageLineItem.APTS_Operational_Object__c = agreementLineItem.Id;
                    successCounter++;
                }
            }
        }
        
        if( successCounter == stageMSPALineItems.size() ){
            update stageMSPALineItems;
        } else {
            // This batch should fail... 
            DMMSPAHelperException e = new DMMSPAHelperException('Not all Line Items were successfully created. Rollback Required.');
            throw e;
        }
    }

    public static APTS_CopyDataWrapper copyStageMSPALineItemToLineItem(List < APTS_Stage_MSPA_LineItems__c > listStageMSPALineItem) {

        Set < Decimal > spaIdSet = new Set < Decimal > ();
        Map < Decimal, Apttus__APTS_Agreement__c > spaIdToAgmtMap = new Map < Decimal, Apttus__APTS_Agreement__c > ();
        Map < Decimal, Id > spaIdToConfigIdMap = new Map < Decimal, Id > ();
        for (APTS_Stage_MSPA_LineItems__c li: listStageMSPALineItem) {
            spaIdSet.add(li.APTS_SPA_Identifier__c);
            
            if( li.APTS_RowStatus__c != APTS_DMConstants.VALIDATION_STATUS ){
            	System.debug('APTS_DMMSPHelper.copyStageMSPALineItemToLineItem: Invalid LineItem Status=' + li.APTS_RowStatus__c);
                // This batch should fail... 
                DMMSPAHelperException e = new DMMSPAHelperException('Not all Line Items were successfully validated. Rollback Required.');
                throw e;
            }
        }


        if (spaIdSet.size() > 0) {
            Set < String > productCodeStrSet = New Set < String > ();
            Set < String > setMSPA_Product_Level3_Code = new Set < String > ();
            for (APTS_Stage_MSPA_LineItems__c sli: listStageMSPALineItem) {
                if (sli.APTS_Product_Code__c != null && sli.APTS_Product_Code__c.length() > 0) {
                    productCodeStrSet.add(sli.APTS_Product_Code__c);
                }
                if (sli.APTS_Product_Level_3__c != null && String.isNotBlank(sli.APTS_Product_Level_3__c)) {
                    setMSPA_Product_Level3_Code.add(sli.APTS_Product_Level_3__c);
                }
            }

            List < Product2 > productSoLst = [select id, APTS_Product_ID__c from product2 where APTS_Product_ID__c in : productCodeStrSet];

            List < Product2 > listProductLevel3Code = [Select APTS_Hierarchy_Level_3_Code__c
            from Product2 where APTS_Hierarchy_Level_3_Code__c IN: setMSPA_Product_Level3_Code
            AND RecordType.Name = : APTS_DMConstants.LOCAL_HIERACHY AND
            APTS_Hierarchy_Level_3_Code__c != null and APTS_Hierarchy_Level_4_Code__c = null
            and APTS_Hierarchy_Level__c = 3];

            Map < String, String > productCodeIdMap = New Map < String, String > ();
            for (Product2 productSo: productSoLst) {
                productCodeIdMap.put(productSo.APTS_Product_ID__c, productSo.id);
            }

            if (listProductLevel3Code != null && listProductLevel3Code.size() > 0) {
                for (Product2 product: listProductLevel3Code) {
                    productCodeIdMap.put(product.APTS_Hierarchy_Level_3_Code__c, product.id);
                }
            }

            Set < id > standAloneProductIdSet = New Set < id > ();

            List < Apttus__APTS_Agreement__c > agmtSoLst = [Select Id, APTS_SPA_Identifier__c FROM Apttus__APTS_Agreement__c WHERE APTS_SPA_Identifier__c IN: spaIdSet];
            if (agmtSoLst != null && agmtSoLst.size() > 0) {
                for (Apttus__APTS_Agreement__c agmt: agmtSoLst) {

                    /* Start of Creating Cart for the Agreement  */

                    List < Apttus_Config2.Property > configProps = new List < Apttus_Config2.Property > ();
                    Apttus_Config2.Property prop = new Apttus_Config2.Property();
                    Id configId;
                    Id objectId;

                    objectId = agmt.Id;
                    prop.Name = APTS_DMConstants.PROPERTY_ADVANCE_APPROVAL;
                    //Get the value from Custom Settings
                    if (APTS_Custom_Cart_Settings__c.getValues('useAdvancedApproval') != null) {
                        prop.Value = String.ValueOf(APTS_Custom_Cart_Settings__c.getValues('useAdvancedApproval').APTS_Value__c);
                    }
                    configProps.add(prop);

                    prop = new Apttus_Config2.Property();
                    prop.Name = APTS_DMConstants.PROPERTY_DEAL_OPTIMIZER;
                    //Get the value from Custom Settings
                    if (APTS_Custom_Cart_Settings__c.getValues('useDealOptimizer') != null) {
                        prop.Value = String.ValueOf(APTS_Custom_Cart_Settings__c.getValues('useDealOptimizer').APTS_Value__c);
                    }
                    configProps.add(prop);

                    try {
                        configId = Apttus_CMConfig.CMConfigWebService.createConfigurationRequest(objectId, configProps);
                        PageReference pageRef = Apttus_CMConfig.CMConfigWebService.startConfiguration(configId, configProps);
                        ID cartId = ID.valueOf(pageRef.getParameters().get('id'));

                        system.debug('##configId=' + configId);
                        system.debug('##productCodeIdMap=' + productCodeIdMap);
                        system.debug('##APTS_SPA_Identifier__c=' + agmt.APTS_SPA_Identifier__c);

                        LIST < Decimal > lineNumbers = new LIST < Decimal > ();
                        Apttus_CPQApi.CPQ.AddMultiProductRequestDO requests = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
                        requests.CartId = cartId;
                        requests.SelectedProducts = new List < Apttus_CPQApi.CPQ.SelectedProductDO > ();

                        system.debug('product ids****' + standAloneProductIdSet);
                        Apttus_CPQApi.CPQ.SelectedProductDO prodDO;
                        for (APTS_Stage_MSPA_LineItems__c sli: listStageMSPALineItem) {


                            if (((sli.APTS_Product_Code__c != null && sli.APTS_Product_Code__c.length() > 0 && productCodeIdMap.containsKey(sli.APTS_Product_Code__c)) || (sli.APTS_Product_Level_3__c != null && sli.APTS_Product_Level_3__c.length() > 0 && productCodeIdMap.containsKey(sli.APTS_Product_Level_3__c))) && sli.APTS_SPA_Identifier__c == agmt.APTS_SPA_Identifier__c) {
                                prodDO = new Apttus_CPQApi.CPQ.SelectedProductDO();
                                if (sli.APTS_Product_Code__c != null && sli.APTS_Product_Code__c.length() > 0 && productCodeIdMap.containsKey(sli.APTS_Product_Code__c)) {
                                    prodDO.ProductId = productCodeIdMap.get(sli.APTS_Product_Code__c);
                                } else if (sli.APTS_Product_Level_3__c != null && sli.APTS_Product_Level_3__c.length() > 0 && productCodeIdMap.containsKey(sli.APTS_Product_Level_3__c)) {
                                    prodDO.ProductId = productCodeIdMap.get(sli.APTS_Product_Level_3__c);
                                }
                                prodDo.quantity = sli.APTS_Quantity__c;
                                Apttus_Config2__LineItem__c lineItemSo = new Apttus_Config2__LineItem__c();
                                lineItemSo.APTS_Original_Created_By__c = sli.APTS_CreatedBy__c;
                                lineItemSo.APTS_Original_Created_On__c = sli.APTS_CreatedOn__c;
                                lineItemSo.APTS_Discount_Type__c = sli.APTS_Discount_Type__c;
                                if(sli.APTS_Discount_Type__c=='Net Price Discount')
                                {
                                   // lineItemSo.APTS_Discount_Percentage__c = sli.APTS_Net_Price__c;
                                    lineItemSo.APTS_Net_Price_Override__c=sli.APTS_Net_Price__c;
                                    
                                }
                                else if(sli.APTS_Discount_Type__c=='Substitute Discount')
                                {
                                    lineItemSo.APTS_Discount_Percentage__c = sli.APTS_Discount__c;
                                   
                                }
                                
                                
                                
                                lineItemSo.APTS_External_Id__c = sli.APTS_External_ID__c;
                            //  lineItemSo.Apttus_Config2__NetPrice__c = sli.APTS_Net_Price__c;
                                lineItemSo.APTS_Owner__c = sli.APTS_Owner__c;
                                lineItemSo.APTS_LP_Standard_Net__c = sli.APTS_Price__c;
                            //  lineItemSo.Apttus_Config2__BasePrice__c = sli.APTS_Price_1_Gross_Price__c;
                                lineItemSo.APTS_LP_Unit_Of_Price__c = String.valueOf(sli.APTS_Price_Unit__c);
                                lineItemSo.GTV_Level__c = sli.APTS_Product_Level_3__c;

                                lineItemSo.APTS_SPA_Line_Item_Number__c = String.valueOf(sli.APTS_SPA_Line_Item__c);
                                prodDO.CustomFields = new List < String > ();
                                prodDO.CustomFields.add('APTS_Original_Created_By__c');
                                prodDO.CustomFields.add('APTS_Original_Created_On__c');
                                 prodDO.CustomFields.add('APTS_Discount_Percentage__c');
                                prodDO.CustomFields.add('APTS_Discount_Type__c');
                                prodDO.CustomFields.add('APTS_External_Id__c');
                                prodDO.CustomFields.add('APTS_Net_Price_Override__c');
                                prodDO.CustomFields.add('APTS_Owner__c');
                                prodDO.CustomFields.add('APTS_LP_Standard_Net__c');
                            //  prodDO.CustomFields.add('Apttus_Config2__BasePrice__c');
                                prodDO.CustomFields.add('APTS_LP_Unit_Of_Price__c');
                                prodDO.CustomFields.add('GTV_Level__c');
                                prodDO.CustomFields.add('APTS_SPA_Line_Item_Number__c');
                                prodDO.CustomData = lineItemSo;
                                requests.SelectedProducts.add(prodDO);

                            }

                        }

                        system.debug('##standAloneProductIdSet=' + standAloneProductIdSet);

                        if (requests.SelectedProducts.size() > 0) {


                            system.debug('request****' + requests);
                            Apttus_CPQApi.CPQ.AddMultiProductResponseDO response = Apttus_CPQApi.CPQWebService.addMultiProducts(requests);

                            lineNumbers = response.LineNumbers;
                            spaIdToConfigIdMap.put(agmt.APTS_SPA_Identifier__c, cartId); //test
                            system.debug('### lineNumbers: ' + lineNumbers.size());

                        }


                    } catch (exception e) {

                    }

                    /* End of Creating Cart for the Agreement  */

                    spaIdToAgmtMap.put(agmt.APTS_SPA_Identifier__c, agmt);
                }
            }
        }

        APTS_CopyDataWrapper oCopyWrapper = new APTS_CopyDataWrapper();

        system.debug('Copying Data from Staging Object to Normal Object for Local Product');

        List < Apttus_Config2__LineItem__c > listLineItem = new List < Apttus_Config2__LineItem__c > ();

        Schema.SObjectField f = Apttus_Config2__LineItem__c.Fields.APTS_External_Id__c;


        /* Start Reprice and finalize the cart. */

        system.debug('##spaIdToConfigIdMap=' + spaIdToConfigIdMap);
        if (spaIdToConfigIdMap.size() > 0) {
        
            Set < Id > configIds = new Set < Id > ();
            configIds.addAll(spaIdToConfigIdMap.values());
            repriceAndFinalize(configIds);
        }
        /* End Reprice and finalize the cart */

        return oCopyWrapper;
    }

    public static void repriceAndFinalize(Set < Id > configIds) {

        Boolean isPricingPending=false;
        
        for (Id configId: configIds) {
        
            isPricingPending = false;
        
            do{         
            // Reprice the Cart.
            Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
            objUpdatePriceRequestDO.CartId = configId;
            Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
            isPricingPending = result.isPricePending;
            }while(isPricingPending);


            // Finalize the Cart.

            // create the finalize cart request
            Apttus_CpqApi.CPQ.FinalizeCartRequestDO request = new
            Apttus_CpqApi.CPQ.FinalizeCartRequestDO();
            // add request parameters
            request.CartId = configId;

            // finalize the cart
            system.debug('##Invoking FinalizeCart API');
            try {

                Apttus_CpqApi.CPQ.FinalizeCartResponseDO response = Apttus_CpqApi.CPQWebService.finalizeCart(request);
            } Catch(Exception ex) {

            }
            system.debug('##Invoking FinalizeConfiguration API');
            Apttus_CMConfig.CMConfigWebService.finalizeConfiguration(configId);
            system.debug('##Invoking AfterFinalize API');
            Apttus_CMConfig.CMConfigWebService.afterFinalizeConfiguration(configId);

        }


    }

    private static Map < String, LSO_Field_Entries__c > validateSalesOffice(Set < String > salesOfficeSet) {
        Map < String, LSO_Field_Entries__c > lsoFieldEntryCodeMap = New Map < String, LSO_Field_Entries__c > ();
        // create a map of 
        if (salesOfficeSet.size() > 0) {
            List < LSO_Field_Entries__c > lsoFieldEntrySoLst = [select id, PickList_Code__c from LSO_Field_Entries__c where LSO_Pick_List_Value_Name__c = 'LSO Reference Data. Sales Office'
            and Controlling_Field__c != ''
            and Controlling_Field__c != null];
            if (lsoFieldEntrySoLst != null && lsoFieldEntrySoLst.size() > 0) {
                for (LSO_Field_Entries__c lfe: lsoFieldEntrySoLst) {
                    if (salesofficeSet.contains(lfe.PickList_Code__c)) {
                        lsoFieldEntryCodeMap.put(lfe.PickList_Code__c, lfe);
                    }
                }
            }
        }

        return lsoFieldEntryCodeMap;
    }
}