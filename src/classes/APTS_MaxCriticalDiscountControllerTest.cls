/**************************************************************
 * @Name : APTS_MaxCriticalDiscountControllerTest
 * @Owner : Shalin Shah <sshah@apttus.com>
 * @CreatedOn : 2nd Dec'15
 * @Description : Test class for APTS_MaxCriticalDiscountController
 **************************************************************/

@isTest
public class APTS_MaxCriticalDiscountControllerTest {

    public testMethod static void testOne() {
        User usr = APTS_LP_TestUtility.getUser();
        System.runAs(usr) {
            
            Test.startTest();
            
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCommonConfigSetting();
            String baseURL = String.valueOf(System.Url.getSalesforceBaseUrl());
            String instanceURL = baseURL.subString(baseURL.indexOf('=') + 1, baseURL.length() - 1);
            
            Apttus_Proposal__ProposalSystemProperties__c prop = new Apttus_Proposal__ProposalSystemProperties__c();
            prop.Name = 'System Properties';
            prop.Apttus_Proposal__InstanceUrl__c = instanceURL;
            insert prop;
            
            Apttus__APTS_Agreement__c agreement = APTS_LP_TestUtility.getAgreement('Test Agreement');
            insert agreement;
            
            Apttus__AgreementLineItem__c agreementLineItem = APTS_LP_TestUtility.getAgreementLineItem(agreement.Id);
            agreementLineItem.APTS_Is_Critical_Discount__c = TRUE;
            insert agreementLineItem;
            
            APTS_MaxCriticalDiscountController controller = new APTS_MaxCriticalDiscountController();
            controller.agrmntSO = agreement;
            
            controller.getAgreementUrl();
            controller.getAgreementLI();
            controller.agrmntSO = APTS_LP_TestUtility.getAgreement('Test Agreement1');
            controller.getAgreementLI();
            
            Test.stopTest();
        }
    }
}