public class APTS_DMLODHelper extends APTS_DMHelper{
    
      /**
   * This method contains Bussniess Validation Rule for Validating Local Operational Data
   *  Written-By : Sreekanth Pinnamaneni
   * 
   * */

  public static void validateLocalOperationalData(List < APTS_Stage_Local_Operational_Data__c > listStageLocalOperationalData) {
        boolean bisValidattionError = false;
    	String sErromMessage = '';
    	List < APTS_Stage_Local_Operational_Data__c > UpdatedLodList = new List < APTS_Stage_Local_Operational_Data__c >();
        Set < String > countrySet = new Set < String > ();
    	countrySet.add('ES'); countrySet.add('IT'); countrySet.add('FR');
        
        system.debug('HS -> Size of List' + listStageLocalOperationalData.size());
      // Set of fields to be validated against Master Picklist
        Set <String> setDistributionChannel = new Set <String> ();
        Set <String> setPaymentTerms = new Set <String> ();
        Set <String> setIncoterms = new Set <String> ();
        Set <String> setLocalChannel = new Set <String> ();
        Set <String> setSAPDivision = new Set <String> ();
        Set <String> guiIDSet = new Set <String> ();
        
        for(APTS_Stage_Local_Operational_Data__c localOpData: listStageLocalOperationalData){
        
            setLocalChannel.add(localOpData.APTS_LP_Local_Channel__c);
            setDistributionChannel.add(localOpData.APTS_LP_Distribution_Channel__c);
            setIncoterms.add(localOpData.APTS_LP_Incoterms__c);
            setPaymentTerms.add(localOpData.APTS_Payment_Terms__c);
            setSAPDivision.add(localOpData.APTS_SAP_Division__c);
            guiIDSet.add(localOpData.APTS_LP_Account_GUID__c);
        }
        
        List <Account> actList = [select GUID__c from Account where GUID__c in :guiIDSet];
        Set <String> accountGuiIDSet = new Set <String> ();
        for(Account act: actList) {
            accountGuiIDSet.add(act.GUID__c);
        }
        
        LIst<APTS_Master_Picklist_Table__c> masterPicklistSoLst =  [select id,APTS_Code__c,APTS_Code_Used_For__c 
                                                                      from APTS_Master_Picklist_Table__c 
                                                                     where (APTS_Locale__c = : APTS_DMConstants.SPAIN_LOCALE and(
                                                                            (APTS_Code__c in :setLocalChannel and APTS_Code_Used_For__c  = :APTS_DMConstants.MASTER_PICKLIST_LOCAL_CHANNEL)
                                                                               OR
                                                                               (APTS_Code__c in :setDistributionChannel and APTS_Code_Used_For__c  = :APTS_DMConstants.MASTER_PICKLIST_DISTRIBUTION_CHANNEL)
                                                                               OR
                                                                               (APTS_Code__c in :setIncoterms and APTS_Code_Used_For__c  = :APTS_DMConstants.MASTER_PICKLIST_INCOTERM)
                                                                               OR
                                                                               (APTS_Code__c in :setSAPDivision and APTS_Code_Used_For__c  = :APTS_DMConstants.MASTER_PICKLIST_SAP_DIVISION)
                                                                               OR
                                                                               (APTS_Code__c in :setPaymentTerms and APTS_Code_Used_For__c  = :APTS_DMConstants.MASTER_PICKLIST_PAYMENT_TERM)
                                                                              )) ];
        Set <String> masterDistributionChannel = new Set <String> ();
        Set <String> masterPaymentTerms = new Set <String> ();
        Set <String> masterIncoterms = new Set <String> ();
        Set <String> masterLocalChannel = new Set <String> ();
        Set <String> masterSAPDivision = new Set <String> ();
        
      //Prepare sets for Local Channel, Distribution Channel, Incoterm, Payment Term from Master Picklist                                                                       
        for(APTS_Master_Picklist_Table__c mpTable: masterPicklistSoLst) {
            if(mpTable.APTS_Code_Used_For__c == APTS_DMConstants.MASTER_PICKLIST_LOCAL_CHANNEL)        masterLocalChannel.add(mpTable.APTS_Code__c);
            if(mpTable.APTS_Code_Used_For__c == APTS_DMConstants.MASTER_PICKLIST_DISTRIBUTION_CHANNEL) masterDistributionChannel.add(mpTable.APTS_Code__c);
            if(mpTable.APTS_Code_Used_For__c == APTS_DMConstants.MASTER_PICKLIST_INCOTERM)             masterIncoterms.add(mpTable.APTS_Code__c);
            if(mpTable.APTS_Code_Used_For__c == APTS_DMConstants.MASTER_PICKLIST_PAYMENT_TERM)         masterPaymentTerms.add(mpTable.APTS_Code__c);
            if(mpTable.APTS_Code_Used_For__c == APTS_DMConstants.MASTER_PICKLIST_SAP_DIVISION)         masterSAPDivision.add(mpTable.APTS_Code__c);
        }                                                                   
        system.debug('HS -> Size of Local Channel set' + masterLocalChannel.size());
        system.debug('HS -> Size of Distribution Channel set' + masterDistributionChannel.size());
        system.debug('HS -> Size of Incoterm set' + masterIncoterms.size());
        system.debug('HS -> Size of Payment Term set' + masterPaymentTerms.size());
        system.debug('HS -> Size of SAP Division set' + masterSAPDivision.size());
        
        
      
    //Iterate thru the Local Operational Data List and Validate each record  
     for(APTS_Stage_Local_Operational_Data__c localOpData: listStageLocalOperationalData) {
     	
     	APTS_DMHelperUtility dmHelperUtility = New APTS_DMHelperUtility();
     	        
         bisValidattionError = false;
    	 //sErromMessage = '';
         // Validation of Local Channel
          if (string.isBlank(localOpData.APTS_LP_Local_Channel__c) ) {
            bisValidattionError = true;
            dmHelperUtility.appendErrorMessage('Local Channel cannot be Blank');
         }
     	 if (!string.isBlank(localOpData.APTS_LP_Local_Channel__c) && !masterLocalChannel.contains(localOpData.APTS_LP_Local_Channel__c)) {
            bisValidattionError = true;
            dmHelperUtility.appendErrorMessage('Local Channel not found in Master Picklist.');
         }
         
         // Validation of Distribution Channel
     	 if (!string.isBlank(localOpData.APTS_LP_Distribution_Channel__c) && !masterDistributionChannel.contains(localOpData.APTS_LP_Distribution_Channel__c)) {
            bisValidattionError = true;
            dmHelperUtility.appendErrorMessage('Distribution Channel not found in Master Picklist.');
         }
         
         // Validation of Incoterm
     	 if (!string.isBlank(localOpData.APTS_LP_Incoterms__c) && !masterIncoterms.contains(localOpData.APTS_LP_Incoterms__c)) {
            bisValidattionError = true;
            dmHelperUtility.appendErrorMessage('Incoterm not found in Master Picklist.');
         }
         
         // Validation of Payment Term
     	 if (!string.isBlank(localOpData.APTS_Payment_Terms__c) && !masterPaymentTerms.contains(localOpData.APTS_Payment_Terms__c)) {
            bisValidattionError = true;
            dmHelperUtility.appendErrorMessage('Payment Term not found in Master Picklist.');
         }
         
         // Validation of SAP Division code
     	 if (!string.isBlank(localOpData.APTS_SAP_Division__c) && !masterSAPDivision.contains(localOpData.APTS_SAP_Division__c)) {
            bisValidattionError = true;
            dmHelperUtility.appendErrorMessage('SAP Division not found in Master Picklist.');
         }
         
         // Validation of Country code
     	 if (!string.isBlank(localOpData.APTS_Country__c) && !countrySet.contains(localOpData.APTS_Country__c)) {
            bisValidattionError = true;
            dmHelperUtility.appendErrorMessage('Invalid Country code.');
         }
         
         // Validation of GUI ID
     	 if (!string.isBlank(localOpData.APTS_LP_Account_GUID__c) && !accountGuiIDSet.contains(localOpData.APTS_LP_Account_GUID__c)) {
            bisValidattionError = true;
            dmHelperUtility.appendErrorMessage('Account GUI ID not found in Account Object.');
         }
         
         dmHelperUtility.updateValidationStatus(localOpData,bIsValidattionError);
         UpdatedLodList.add(localOpData);
         //**end
      }// End of for Loop
     
     // update the records 
     if (UpdatedLodList.size() > 0) {
      system.debug('HS--> Size of LODs to be updated' + UpdatedLodList.size());
      try {
        Database.upsert(UpdatedLodList);
      } catch (Exception ex) {
        System.debug('Exception while upserting LOD stage Data.\nException : ' + ex.getMessage());
      }
    }
      

  }

  public static APTS_CopyDataWrapper copyLocalOperationalData(List < APTS_Stage_Local_Operational_Data__c > listStageLocalOperationalData) {

        APTS_CopyDataWrapper oCopyWrapper = new APTS_CopyDataWrapper();

        system.debug('Copying Data from Staging Object to Normal Object for LOD');

		Schema.SObjectField f = APTS_LP_Local_Customer_Reference_Data__c.Fields.APTS_External_Id__c;

        List < APTS_LP_Local_Customer_Reference_Data__c > listloadLocalOperationalData = new List < APTS_LP_Local_Customer_Reference_Data__c > ();
        List < APTS_Stage_Local_Operational_Data__c > listupdatestageLocalOperationalData = new List < APTS_Stage_Local_Operational_Data__c > ();
        
		Set<String> setAccountGUID = new Set<String>();
		Map<String,Account> mapAccountGUID = new Map<String,Account>();
		
		for(APTS_Stage_Local_Operational_Data__c oStageLOD : listStageLocalOperationalData) {
			setAccountGUID.add(oStageLOD.APTS_LP_Account_GUID__c);
		}
		
		List<Account> listAccount = [Select Id,Name,GUID__c from Account where GUID__c =:setAccountGUID];
		
		for(Account oAccount : listAccount) {
			mapAccountGUID.put(oAccount.GUID__c,oAccount);
		}

        // Creating Product Line Tree, assigning values and adding into List.
        for (APTS_Stage_Local_Operational_Data__c oStageLOD: listStageLocalOperationalData) {

            APTS_LP_Local_Customer_Reference_Data__c oLOD = new APTS_LP_Local_Customer_Reference_Data__c();
            
			oLOD.APTS_External_ID__c = oStageLOD.APTS_External_ID__c;
			oLOD.APTS_Country__c = oStageLOD.APTS_Country__c;
			oLOD.APTS_LP_Distribution_Channel__c = oStageLOD.APTS_LP_Distribution_Channel__c;
			oLOD.APTS_LP_Incoterms__c = oStageLOD.APTS_LP_Incoterms__c;
			oLOD.APTS_LP_Local_Channel__c = oStageLOD.APTS_LP_Local_Channel__c;
			oLOD.APTS_Payment_Terms__c = oStageLOD.APTS_Payment_Terms__c;
			oLOD.APTS_LP_Sales_Organisation__c = oStageLOD.APTS_LP_Sales_Organisation__c;
			oLOD.APTS_LP_SAP_Customer_ID__c = oStageLOD.APTS_LP_SAP_Customer_ID__c;
			oLOD.APTS_SAP_Division__c = oStageLOD.APTS_SAP_Division__c;
            
			if(mapAccountGUID.get(oStageLOD.APTS_LP_Account_GUID__c)!= NULL) {
				oLOD.APTS_LP_Account__c = mapAccountGUID.get(oStageLOD.APTS_LP_Account_GUID__c).Id;
			}
			
            listloadLocalOperationalData.add(oLOD);
            
            oStageLOD.APTS_RowStatus__c = APTS_DMConstants.LOAD_STATUS;
            listupdatestageLocalOperationalData.add(oStageLOD);
        }

        // Upserting the list
        try {
            if (listloadLocalOperationalData.size() > 0) {
                Database.UpsertResult[] results = Database.upsert(listloadLocalOperationalData, f, false);
                system.debug('HS--> Result while copying Local Operational Data ' + results);
                Set < Id > successIdSet = New Set < id > ();
				Set < Id > failedIdSet = New Set < id > ();

                for (Database.UpsertResult sr: results) {
                    if (sr.isSuccess()) {
                        System.debug('Successfully inserted LOD: ' + sr.getId());
                        successIdSet.add(sr.getId());
						system.debug('##SUCCESSresults.get(i)=' + sr);
                    } else {
                        // Operation failed, so get all errors 
                        oCopyWrapper.bIsUpsertFail = true;
                        for (Database.Error err: sr.getErrors()) {
                            System.debug('The following error has occurred.');
                            oCopyWrapper.sErrorMessage = oCopyWrapper.sErrorMessage + '<br/><br/>' + err.getStatusCode() + ': ' + err.getMessage();
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Following fields that affected this error: ' + err.getFields());
                        }
                    }
                }
                
                APTS_DMHelper.updateLoadingStatus(successIdSet, 'APTS_LP_Local_Customer_Reference_Data__c', 'APTS_External_Id__c', 'APTS_External_ID__c', listStageLocalOperationalData);
            }

                system.debug('HS1--> ' + oCopyWrapper);

        } catch (Exception e) {
            System.debug('Exception while upserting LOD records.\nException : ' + e.getMessage());
            oCopyWrapper.sErrorMessage = e.getMessage();
            oCopyWrapper.bIsUpsertFail = true;
        }

        return oCopyWrapper;
    }  
    
}