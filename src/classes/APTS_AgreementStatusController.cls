/*************************************************************
@Name: APTS_AgreementStatusController
@Author: Hardik Shah
@CreateDate: 07 Sep 2015
@Description: This class updates the status of Agreement based on Request Parameter Received
@UsedBy: VF-Page : APTS_AgreementStatus
******************************************************************
@ModifiedBy: NA
@ModifiedDate: NA
@ChangeDescription: A brief description of what was modified.
**** PS: @ModifiedBy and @ChangeDescription can be repeated multiple time, based on number of changes made to the original process.
******************************************************************/

public class APTS_AgreementStatusController {
	// Agreement Id
	public Id agreementId {
		get;
		set;
	}
	// Request Parameter from URL - This Parameter is used to determine whether agreement
	// needs to be blocked or DeActivated.
	private string requestParameter;
	// boolean variable to show error message on  VF page
	public Boolean hasErrors {
		get;
		set;
	}
	// Instance of PageReference
	private Pagereference pagereference;
	// Agreement Object
	public Apttus__APTS_Agreement__c agreement {
		get;
		set;
	}


	// Constructor to iniatialize Agreement-Id,Request-Parameter
	public APTS_AgreementStatusController(ApexPages.StandardController controller) {
		agreement = (Apttus__APTS_Agreement__c) controller.getrecord();
		requestParameter = ApexPages.currentPage().getParameters().get('requestParameter');
		hasErrors = false;
	}

	public pagereference onload() {
		try {
			// Check for Agreement-Id
			if (agreement != null && String.isNotBlank(agreement.Id)) {
				// Fetch the Agreement Status. 
				system.debug('status***' + agreement.Apttus__Status__c);
				if (APTS_Constants.AGREEMENT_STATUS.equalsIgnoreCase(agreement.Apttus__Status__c)) {
					Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, Label.APTS_CANCEL_APPROVAL));
					hasErrors = true;
					return null;
				}
			} else {
				Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, Label.APTS_AGREEMENT_NOT_FOUND));
				hasErrors = true;
				return null;
			}

			// Check for Request-Parameter
			if (requestParameter != null && String.isNotBlank(requestParameter)) {
				// If Request Parameter is De-Activated	
				if (APTS_Constants.MSPA_DEACTIVATED.equalsIgnoreCase(requestParameter)) {

					Apttus__APTS_Agreement__c agr = new Apttus__APTS_Agreement__c(Id = agreement.Id);
					agr.Apttus__Status__c = APTS_Constants.MSPA_DEACTIVATED;
					agr.APTS_LP_Deactivated__c = true;
					update agr;

				}
				// If Request Parameter is Blocked
				else if (APTS_Constants.MSPA_BLOCKED.equalsIgnoreCase(requestParameter)) {
					Apttus__APTS_Agreement__c agr = new Apttus__APTS_Agreement__c(Id = agreement.Id);
					agr.Apttus__Status__c = APTS_Constants.MSPA_BLOCKED;
					agr.APTS_LP_Blocked__c = true;
					update agr;
				}

				pagereference = New Pagereference('/' + agreement.Id);
				pagereference.setRedirect(true);

			} else {
				Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, Label.APTS_AGREEMENT_REQUEST_PARAMETER_NOTFOUND));
				hasErrors = true;
			}


		} catch (Exception ex) {
			Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
			hasErrors = true;
		}
		return pagereference;
	}

}