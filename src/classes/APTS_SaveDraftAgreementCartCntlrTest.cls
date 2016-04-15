/**************************************************************
 * @Name : APTS_SaveDraftAgreementCartCntlrTest
 * @Owner : Mohit Patel <mopatel@apttus.com>
 * @CreatedOn : 13 jan 15
 * @Description : Test class for APTS_SaveDraftCartController
 **************************************************************/

@isTest
public class APTS_SaveDraftAgreementCartCntlrTest {
    
    public testMethod static void testOne() {
        
        User usr = APTS_LP_TestUtility.getUser();
        System.runAs(usr) {
            
            Test.startTest();
            
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
                       
            
            Apttus__APTS_Agreement__c agreement = APTS_LP_TestUtility.getAgreement('Test Agreement');
            insert agreement;
            
            PageReference ref = Page.APTS_SaveDraftPage;
            Test.setCurrentPage(ref);
            
            // For Agreement
            Apttus_Config2__ProductConfiguration__c config = APTS_LP_TestUtility.getProductConfiguration('Test Configuration');
            config.Apttus_CMConfig__AgreementId__c = agreement.Id;
            insert config;
                        
            ref.getParameters().put('Id', config.Id);
            APTS_SaveDraftCartController controller = new APTS_SaveDraftCartController();
            controller.saveDraftMethod();
            
            // For Proposal
            //config = APTS_LP_TestUtility.getProductConfiguration('Test Configuration');
            //config.Apttus_QPConfig__Proposald__c = proposal.Id;
            //insert config;
            
            ref.getParameters().put('Id', config.Id);
            controller = new APTS_SaveDraftCartController();
            controller.saveDraftMethod();
            
            // For un-inserted configuration.
            config = APTS_LP_TestUtility.getProductConfiguration('Test Configuration');            
            config.Apttus_CMConfig__AgreementId__c = agreement.Id;
            
            ref.getParameters().put('Id', config.Id);
            controller = new APTS_SaveDraftCartController();
            controller.saveDraftMethod();
            
            Test.stopTest();
        }
    }
}