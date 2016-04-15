public class APTS_DMMasterPicklistTableHelper extends APTS_DMHelper {
	public static void validateStageMasterPickList(List < APTS_Stage_Master_Picklist__c > listStageMasterPick) {

		// Boolean Variable to indicate Validation Error
		Boolean bisValidattionError = false;
		// Variable for Error Message.
		//String sErrorMessage = ''; 

		// intialize the helper utility
		APTS_DMHelperUtility dmHelperUtility = New APTS_DMHelperUtility();

		List < APTS_Stage_Master_Picklist__c > listUpdatedMasterPick = new List < APTS_Stage_Master_Picklist__c > ();

		for (APTS_Stage_Master_Picklist__c stageMasterPickItem: listStageMasterPick) {
			bisValidattionError = false;
			// Variable for Error Message.
			// sErrorMessage = '';

			if (String.isBlank(stageMasterPickItem.APTS_Code_Used_For__c)) {
				bisValidattionError = true;
				// sErrorMessage = sErrorMessage + 'CodeUserFor field cannot be Blank \n';
				dmHelperUtility.appendErrorMessage('CodeUserFor field cannot be Blank.');
			}

			if (String.isBlank(stageMasterPickItem.APTS_Code__c)) {
				bisValidattionError = true;
				//sErrorMessage = sErrorMessage +'Code field cannot be Blank \n';
				dmHelperUtility.appendErrorMessage('Code field cannot be Blank.');
			}

			dmHelperUtility.updateValidationStatus(stageMasterPickItem, bIsValidattionError);
			listUpdatedMasterPick.add(stageMasterPickItem);

		} // End of for loop

		// List of MSPALineItems
		if (listUpdatedMasterPick.size() > 0) {
			system.debug('HS--> Size of MasterPickList to be updated' + listUpdatedMasterPick.size());
			try {
				Database.UpsertResult[] results = Database.upsert(listUpdatedMasterPick);
				system.debug('HS--Master PickList' + results);
			} catch (Exception ex) {
				System.debug('Exception while upserting MSPA-LineItem.\nException : ' + ex.getMessage());
			}
		}

	}

	public static APTS_CopyDataWrapper copyMasterPickList(List < APTS_Stage_Master_Picklist__c > listStageMasterPick) {

		APTS_CopyDataWrapper oCopyWrapper = new APTS_CopyDataWrapper();
		system.debug('HS--> Copying Data from Staging Object to Normal Object : MasterPickList');

		// List of MasterPick List Objects that needs to be updated
		List < APTS_Master_Picklist_Table__c > listMasterPick = new List < APTS_Master_Picklist_Table__c > ();

		Schema.SObjectField f = APTS_Master_Picklist_Table__c.Fields.APTS_External_Id__c;

		APTS_Master_Picklist_Table__c oMasterPickItem = null;

		// Creating Master PickList, assigning values and adding into List.
		for (APTS_Stage_Master_Picklist__c stageMasterPickItem: listStageMasterPick) {
			oMasterPickItem = new APTS_Master_Picklist_Table__c();
			oMasterPickItem.Name = stageMasterPickItem.Name;
			oMasterPickItem.APTS_Code__c = stageMasterPickItem.APTS_Code__c;
			oMasterPickItem.APTS_Code_Description__c = stageMasterPickItem.APTS_Code_Description__c;
			oMasterPickItem.APTS_Code_Used_For__c = stageMasterPickItem.APTS_Code_Used_For__c;
			oMasterPickItem.APTS_Locale__c = stageMasterPickItem.APTS_Locale__c;
			oMasterPickItem.APTS_External_Id__c = stageMasterPickItem.APTS_External_ID__c;
            oMasterPickItem.APTS_Country__c = stageMasterPickItem.APTS_Country__c;
			listMasterPick.add(oMasterPickItem);
		}

		try {
			if (listMasterPick.size() > 0) {
				Database.UpsertResult[] results = Database.upsert(listMasterPick, f, false);
				system.debug('HS--> Results While copying master-picklist ' + results);
				Set < Id > successIdSet = New Set < id > ();
				Set < Id > failedIdSet = New Set < id > ();

				// Iterate through each returned result
				for (Database.UpsertResult sr: results) {

					if (sr.isSuccess()) {
						System.debug('Successfully inserted master picklist: ' + sr.getId());
						successIdSet.add(sr.getId());
						system.debug('##SUCCESSresults.get(i)=' + sr);
					} else {
						// Operation failed, so get all errors 
						oCopyWrapper.bIsUpsertFail = true;
						for (Database.Error err: sr.getErrors()) {
							System.debug('The following error has occurred.');
							oCopyWrapper.sErrorMessage = oCopyWrapper.sErrorMessage + '<br/><br/>' + err.getStatusCode() + ': ' + err.getMessage();
							System.debug(err.getStatusCode() + ': ' + err.getMessage());
							System.debug('Master-PickList fields that affected this error: ' + err.getFields());

						}
					}
				}

				APTS_DMHelper.updateLoadingStatus(successIdSet, 'APTS_Master_Picklist_Table__c', 'APTS_External_Id__c', 'APTS_External_ID__c', listStageMasterPick);

			}
			system.debug('HS1--> ' + oCopyWrapper);

		} catch (Exception e) {
			System.debug('Exception while upserting Master-PickList  records.\nException : ' + e.getMessage());
			oCopyWrapper.sErrorMessage = e.getMessage();
			oCopyWrapper.bIsUpsertFail = true;
		}

		return oCopyWrapper;
	}

}