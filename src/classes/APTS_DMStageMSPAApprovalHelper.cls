public class APTS_DMStageMSPAApprovalHelper extends APTS_DMHelper {

	public static void validateStageMSPAApprovals(List < APTS_Stage_MSPA_Approvals__c > listStageMSPAApprovals) {

		// Boolean Variable to indicate Validation Error
		Boolean bisValidattionError = false;
		APTS_DMHelperUtility dmHelperUtility;
        Boolean isValidateOwner = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_Validate_SFDC_User__c;

		List < APTS_Stage_MSPA_Approvals__c > listUpdatedstageMSPAApproval = New List < APTS_Stage_MSPA_Approvals__c > ();
		Set < String > ownerNameSet = New Set < String > ();
		Set < String > spaReferenceSet = New Set < String > ();
		List < String > approversandCreatedUserList = New List < String > ();
		Organization oOrgDetail = [Select Id,Name, IsSandbox from Organization];
        String urlStr = String.valueOf(System.Url.getSalesforceBaseURL()) ; 
        String instanceNameStr= urlStr.subString(urlStr.indexOf('--')+2,urlStr.indexOf('.'));
		for (APTS_Stage_MSPA_Approvals__c stageMSPAApproval: listStageMSPAApprovals) {

			if (stageMSPAApproval.APTS_SPA_Reference__c != null && stageMSPAApproval.APTS_SPA_Reference__c.length() > 0) {
				spaReferenceSet.add(stageMSPAApproval.APTS_SPA_Reference__c);
			}

			if (stageMSPAApproval.APTS_Created_By__c != null && stageMSPAApproval.APTS_Created_By__c.length() > 0) {

				if(oOrgDetail.IsSandbox) {
                    String sCreatedBy = stageMSPAApproval.APTS_Created_By__c + '.' + instanceNameStr;
                    System.debug('Created By***'+ sCreatedBy);
                    ownerNameSet.add(sCreatedBy);
                }else {
                    ownerNameSet.add(stageMSPAApproval.APTS_Created_By__c);
                }
			}


		} //end for
		
        
        Map < String, User > userNameMap = New Map < String, User > ();
		Map < String, User > approverActualApproverMap = New Map < String, user > ();
        
		if (ownerNameSet.size() > 0) {
			List < User > userSoLst = [select id, name, username from User where isActive = true AND username in:ownerNameSet ];
			String userEmailStr;
			for (User userSo: userSoLst) {
				approverActualApproverMap.put(userSo.name, userSo);
				userEmailStr = userSo.username;
				if (userEmailStr.contains(instanceNameStr.tolowerCase())) {
					system.debug('##userEmail=' + userEmailStr);
					try {
						userEmailStr = userEmailStr.substring(0, userEmailStr.lastIndexOf('.' + instanceNameStr.tolowercase()));
					} catch (Exception e) {

					}

				}
				userNameMap.put(userEmailStr, userSo);
			}
		}
        
		Map < String, APTS_Stage_MSPA__c > externalIdStageMSPAMap = New Map < String, APTS_Stage_MSPA__c > ();
		if (spaReferenceSet.size() > 0) {

			List < APTS_Stage_MSPA__c > stageMSPALst = [select id, APTS_External_ID__c from APTS_Stage_MSPA__c where APTS_External_ID__c in : spaReferenceSet];

			if (stageMSPALst != null && stageMSPALst.size() > 0) {
				for (APTS_Stage_MSPA__c stageMSPA: stageMSPALst) {
					externalIdStageMSPAMap.put(stageMSPA.APTS_External_ID__c, stageMSPA);
				}
			}

		}

		for (APTS_Stage_MSPA_Approvals__c stageMSPAApproval: listStageMSPAApprovals) {

			dmHelperUtility = New APTS_DMHelperUtility();
			bisValidattionError = false;
			/*********
            Verify that the following fields are mandatory and should NOT be blank/null:
                    a.  SPAReference
                    b.  Assigned Approver
                    c.  Actual Approver
                    d.  Created By
                    e.  Created On
                    f.  SPA Approval History Step No
                    g.  ApprovalActionDate
                    h.  External Id
                    i.  Active
                    
          ******/

			if (stageMSPAApproval.APTS_SPA_Reference__c == null || stageMSPAApproval.APTS_SPA_Reference__c.length() == 0) {

				bisValidattionError = true;
				dmHelperUtility.appendErrorMessage('SPA Reference cannot be NULL or BLANK \n');
			//	system.debug('SPA Reference cannot be NULL or BLANK ');

			}

			if (stageMSPAApproval.APTS_Approver__c == null || stageMSPAApproval.APTS_Approver__c.length() == 0) {

				bisValidattionError = true;
				dmHelperUtility.appendErrorMessage('Assigned Approver cannot be NULL or BLANK \n');
			//	system.debug('Assigned Approver cannot be NULL or BLANK ');

			}


			if (stageMSPAApproval.APTS_Actual_Approver__c == null || stageMSPAApproval.APTS_Actual_Approver__c.length() == 0) {

				bisValidattionError = true;
				dmHelperUtility.appendErrorMessage('Actual Approver cannot be NULL or BLANK \n');
			//	system.debug('Actual Approver cannot be NULL or BLANK ');

			}

			if (stageMSPAApproval.APTS_Created_By__c == null || stageMSPAApproval.APTS_Created_By__c.length() == 0) {

				bisValidattionError = true;
				dmHelperUtility.appendErrorMessage('Created By cannot be NULL or BLANK \n');
			//	system.debug('Created By cannot be NULL or BLANK ');

			}


			if (stageMSPAApproval.APTS_Created_On__c == null) {

				bisValidattionError = true;
				dmHelperUtility.appendErrorMessage('Created On cannot be NULL\n');
			//	system.debug('Created On cannot be NULL');

			}

			if (stageMSPAApproval.APTS_Approval_History_Step__c == null || stageMSPAApproval.APTS_Approval_History_Step__c.length() == 0) {

				bisValidattionError = true;
				dmHelperUtility.appendErrorMessage('SPA Approval History Step cannot be NULL or BLANK \n');
			//	system.debug('SPA Approval History Step cannot be NULL or BLANK ');

			}

			if (stageMSPAApproval.APTS_Approval_Action_Date__c == null) {

				bisValidattionError = true;
				dmHelperUtility.appendErrorMessage('Approval Action Date cannot be NULL \n');
			//	system.debug('Approval Action Date cannot be NULL ');

			}

			if (stageMSPAApproval.APTS_External_ID__c == null) {

				bisValidattionError = true;
				dmHelperUtility.appendErrorMessage('External ID cannot be NULL\n');
			//	system.debug('External ID cannot be NULL ');

			}


			if (stageMSPAApproval.APTS_Active__c == null || stageMSPAApproval.APTS_Active__c.length() == 0) {

				bisValidattionError = true;
				dmHelperUtility.appendErrorMessage('Active cannot be NULL or BLANK \n');
			//	system.debug('Active cannot be NULL or BLANK ');

			}

			//  Verify that the Active field is “true” (case insensitive)

			if (stageMSPAApproval.APTS_Active__c != 'True') {

				bisValidattionError = true;
				dmHelperUtility.appendErrorMessage('Invalid value for field Active. Expected=True,Current=' + stageMSPAApproval.APTS_Active__c + '\n');
			//	system.debug('Invalid value for field Active. Expected=True,Current=' + stageMSPAApproval.APTS_Active__c);

			}

			// Validate that the MSPA Approval is related to an Approved MSPA.
			if (!externalIdStageMSPAMap.containsKey(stageMSPAApproval.APTS_SPA_Reference__c)) {
				bisValidattionError = true;
				dmHelperUtility.appendErrorMessage('SPA Reference is Null/Blank or (matching with external id of stage mspa) Stage MSPA not found\n');
			//	system.debug('SPA Reference is Null/Blank or valid corresponding (matching with external id of stage mspa) Stage MSPA not found');

			}

			/****
             Verify the following fields are associated to an Active User.  Note: These are all First and Last Name of the User.
                a.  Assigned Approver
                b.  Delegate Approver (only if not blank)
                c.  Actual Approver
                d.  Created By
                
             ****/
            if(isValidateOwner) {
                /* if(!APTS_DMHelper.validateUser(stageMSPAApproval.APTS_Approver__c)) {
                     bisValidattionError = true;
                     dmHelperUtility.appendErrorMessage('Assigned user not active \n');
                  } 
                
                 if(!APTS_DMHelper.validateUser(stageMSPAApproval.APTS_Actual_Approver__c)) {
                     bisValidattionError = true;
                     dmHelperUtility.appendErrorMessage('Actual Approver not active \n');
                  } */
    			
    			 if (!userNameMap.containsKey(stageMSPAApproval.APTS_Created_By__c)) {
    				bisValidattionError = true;
    				dmHelperUtility.appendErrorMessage('Created by user' + stageMSPAApproval.APTS_Created_By__c + ' not active\n');
    				system.debug('Created by user ' + stageMSPAApproval.APTS_Created_By__c + ' not found or is inactive');
    
    			}
    			/*if(stageMSPAApproval.APTS_Delegate_Approver__c!=null && stageMSPAApproval.APTS_Delegate_Approver__c.length() > 0) {
                    if(!APTS_DMHelper.validateUser(stageMSPAApproval.APTS_Delegate_Approver__c)) {
                        bisValidattionError = true;
                        dmHelperUtility.appendErrorMessage('Delegate Approver user'+stageMSPAApproval.APTS_Delegate_Approver__c+' not active\n');
                        system.debug('Delegate Approver user '+stageMSPAApproval.APTS_Delegate_Approver__c+' not found or is inactive');
                    }    
                 } */
		    }

			dmHelperUtility.updatevalidationstatus(stageMSPAApproval, bIsValidattionError);
			listUpdatedstageMSPAApproval.add(stageMSPAApproval);

		}

		// List of Stage-MSPAApproval Record
		if (listUpdatedstageMSPAApproval.size() > 0) {
			system.debug('HS--> Size of MSPA Approval to be updated' + listUpdatedstageMSPAApproval.size());
			try {
				Database.UpsertResult[] results = Database.upsert(listUpdatedstageMSPAApproval);
				system.debug('HS--MSPAApproval' + results);
			} catch (Exception ex) {
				System.debug('Exception while upserting Staging MSPA Approval Data.\nException : ' + ex.getMessage());
			}
		}


	}

	public static APTS_CopyDataWrapper copyStageMSPAApprovals(List < APTS_Stage_MSPA_Approvals__c > listStageMSPAApproval) {

		Set < decimal > listSPAs = new Set < decimal > ();
		Set < Id > setAgmtId = new Set < Id > ();
        List < String > assignedApproverandCreatedByUserList = New List < String > ();

		APTS_CopyDataWrapper oCopyWrapper = new APTS_CopyDataWrapper();

		system.debug('HS--> Copying Data to MSPA-Approvals');

		List < Apttus_Approval__Approval_Request_History__c > listMSPAApprvoal = new List < Apttus_Approval__Approval_Request_History__c > ();

		Set < String > spaReferenceSet = new Set < String > ();

		for (APTS_Stage_MSPA_Approvals__c stageMSPAApproval: listStageMSPAApproval) {
			if (stageMSPAApproval.APTS_SPA_Reference__c != null && stageMSPAApproval.APTS_SPA_Reference__c.length() > 0) {
				spaReferenceSet.add(stageMSPAApproval.APTS_SPA_Reference__c);
			}
            if (stageMSPAApproval.APTS_Created_By__c != null && stageMSPAApproval.APTS_Created_By__c.length() > 0) {
				assignedApproverandCreatedByUserList.add(stageMSPAApproval.APTS_Created_By__c);
			}
			if (stageMSPAApproval.APTS_Approver__c != null && stageMSPAApproval.APTS_Approver__c.length() > 0) {
			    assignedApproverandCreatedByUserList.add(stageMSPAApproval.APTS_Approver__c);
			}
		}

		
        Map < String, User > userNameMap = New Map < String, User > ();
        
		if (assignedApproverandCreatedByUserList.size() > 0) 
        APTS_DMHelper.setActiveUserList(assignedApproverandCreatedByUserList);
            
		/*	List < User > userSoLst = [select id, name, username from User where isActive = true];
			String userEmailStr;
			for (User userSo: userSoLst) {
				userEmailStr = userSo.username;
				userNameMap.put(userEmailStr, userSo);
			}
		} */
        
		Map < String, ID > spaToAgreement = New Map < String, ID > ();
		if (spaReferenceSet.size() > 0) {
			system.debug('***SPA Reference Set*****' + spaReferenceSet);
			List < Apttus__APTS_Agreement__c > agreementSoLst = [select id, APTS_SAP_Reference_No__c from Apttus__APTS_Agreement__c where APTS_SAP_Reference_No__c in : spaReferenceSet];
			system.debug('***Agreement list*****' + agreementSoLst);

			if (agreementSoLst != null && agreementSoLst.size() > 0) {
				for (Apttus__APTS_Agreement__c agreementSo: agreementSoLst) {
					spaToAgreement.put(agreementSo.APTS_SAP_Reference_No__c, agreementSo.ID);
				}
			}

		}

		list < Task > listTask = new list < Task > ();
		list < Apttus_Approval__Approval_Request_History__c > listApprovalHistory = new list < Apttus_Approval__Approval_Request_History__c > ();
        
		for (APTS_Stage_MSPA_Approvals__c stageMSPAApproval: listStageMSPAApproval) {

			if (spatoagreement.containsKey(stageMSPAApproval.APTS_SPA_Reference__c)) {

				Task oTask = new Task();

				ID agmt_ID = spatoagreement.get(stageMSPAApproval.APTS_SPA_Reference__c);
				system.debug('before if--------');
				if (agmt_ID != null) {
					system.debug('After if......');
					String sNotes;	
					sNotes = '';
					system.debug('Agreement ID----:' + agmt_ID);
					oTask.WhatId = agmt_ID;
					//oTask.Whoid = dummyCon.ID;
					if(APTS_DMHelper.getUserforLoad(stageMSPAApproval.APTS_Approver__c) != null) {
					    oTask.ownerId = APTS_DMHelper.getUserforLoad(stageMSPAApproval.APTS_Approver__c);
					} else {
					    oTask.ownerId = userinfo.getUserId();
					}
					oTask.Type = 'MSPA Approval';
					oTask.Subject = 'MSPA ' + string.valueOf(stageMSPAApproval.APTS_SPA_Reference__c) + 'Approved by ' + stageMSPAApproval.APTS_Actual_Approver__c;
					oTask.ActivityDate = Date.valueof(stageMSPAApproval.APTS_Approval_Action_Date__c);
					oTask.Status = 'Completed';
					oTask.Description = 'Assigned approver is ' + stageMSPAApproval.APTS_Approver__c + 'for step no. ' + stageMSPAApproval.APTS_Approval_History_Step__c + ' Approved by ' + stageMSPAApproval.APTS_Actual_Approver__c;
					oTask.APTS_External_Id__c = String.valueOf(stageMSPAApproval.APTS_External_Id__c);
					if (stageMSPAApproval.APTS_Delegate_Approver__c != null) {
						oTask.Description += ' Deligate Approver is :' + stageMSPAApproval.APTS_Delegate_Approver__c;
					}
                    if(APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_Create_Audit_Fields__c) {
                       oTask.put('CreatedDate', stageMSPAApproval.APTS_Created_On__c);
					   oTask.put('CreatedById', APTS_DMHelper.getUserforLoad(stageMSPAApproval.APTS_Created_By__c)); 
                    }
					
					listTask.add(oTask);
                    
                    
                     String sDesc = '';
                    sDesc = 'Assigned approver is ' + stageMSPAApproval.APTS_Approver__c + ' for step no. ' + stageMSPAApproval.APTS_Approval_History_Step__c + ' Approved by ' + stageMSPAApproval.APTS_Actual_Approver__c;
                    if (!string.isBlank(stageMSPAApproval.APTS_Notes__c)){
                        sDesc += '\n'+ ' Notes:'+stageMSPAApproval.APTS_Notes__c;
                       }					
                    if (!string.isBlank(stageMSPAApproval.APTS_Comments__c)){
                        	sDesc += '\n'+ ' Comments:'+stageMSPAApproval.APTS_Comments__c;
                    }
                    oTask.Description = sDesc;

					/*   Apttus_Approval__Approval_Request_History__c approvalHistory = createMSPAApprovalHistory(stageMSPAApproval, agmt_ID);
                            listApprovalHistory.add(approvalHistory); */

				}
			}

		}


		try {
			if (listTask.size() > 0) {

				Schema.SObjectField externalId = Task.Fields.APTS_External_Id__c;

				Database.UpsertResult[] results = Database.upsert(listTask, externalId);
				system.debug('HS--> Results While copying MSPA-Approval ' + results);
				Set < Id > successIdSet = New Set < id > ();
				Set < Id > failedIdSet = New Set < id > ();

				for (Database.UpsertResult sr: results) {

					if (sr.isSuccess()) {
						System.debug('Successfully inserted Task: ' + sr.getId());
						successIdSet.add(sr.getId());
						system.debug('##SUCCESSresults.get(i)=' + sr);
					} else {
						// Operation failed, so get all errors 
						oCopyWrapper.bIsUpsertFail = true;
						for (Database.Error err: sr.getErrors()) {
							System.debug('The following error has occurred.');
							oCopyWrapper.sErrorMessage = oCopyWrapper.sErrorMessage + '<br/><br/>' + err.getStatusCode() + ': ' + err.getMessage();
							System.debug(err.getStatusCode() + ': ' + err.getMessage());
							System.debug('MSPA-Approval fields that affected this error: ' + err.getFields());

						}
					}
				}
				APTS_DMHelper.updateLoadingStatus(successIdSet, 'Task', 'APTS_External_Id__c', 'APTS_External_Id__c', listStageMSPAApproval);
				system.debug('HS1--> ' + oCopyWrapper);
			}


		} catch (Exception e) {
			System.debug('Exception while upserting MSPA-Approval  records.\nException : ' + e.getMessage());
			oCopyWrapper.sErrorMessage = e.getMessage();
			oCopyWrapper.bIsUpsertFail = true;
		}
		return oCopyWrapper;

	}

	/*private static Contact getContact(){
		Contact result = null;
		
		String firstName = 'ABB';
		String lastName = 'DM';
		String contactName = firstName + ' ' + lastName;
		
		List<Contact> contacts = [select id from Contact where Name = :contactName limit 1];
		if( contacts != null && contacts.size() == 1 ){
			result = contacts[0];
		} else {
			result = new Contact();
			result.FirstName = firstName;
			result.LastName = lastName;
			
			insert result;
		}
		
		return result;
	} */

	//**Sreekanth
	/*
    public static Apttus_Approval__Approval_Request_History__c createMSPAApprovalHistory(APTS_Stage_MSPA_Approvals__c stageMSPAApproval, ID agmtID) { 
        
                Apttus_Approval__Approval_Request_History__c oApprovalRequestHistory = new Apttus_Approval__Approval_Request_History__c();

                oApprovalRequestHistory.Apttus_Approval__Parent_Agreement__c=agmtID;
                oApprovalRequestHistory.ownerId=stageMSPAApproval.APTS_Approver__c;
                
                if(stageMSPAApproval.APTS_Active__c=='True')
                {
                 oApprovalRequestHistory.Apttus_Approval__Approval_Status__c='Approved';
                 }
                oApprovalRequestHistory.Apttus_Approval__DelegateApprover__c=stageMSPAApproval.APTS_Delegate_Approver__c;
                oApprovalRequestHistory.Apttus_Approval__Actual_Approver__c=stageMSPAApproval.APTS_Actual_Approver__c;
                oApprovalRequestHistory.Apttus_Approval__Request_Comments__c='Step:'+stageMSPAApproval.APTS_Approval_History_Step__c + '\n'+
                                                                             'Notes:'+stageMSPAApproval.APTS_Notes__c+ '\n'+
                                                                             'Comments:'+stageMSPAApproval.APTS_Comments__c;
                return oApprovalRequestHistory;        
        
    } */
	//*End

}