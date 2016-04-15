/**************************************************************
 * @Name : APTS_SaveDraftCartControllerTest
 * @Owner : Shalin Shah <sshah@apttus.com>
 * @CreatedOn : 2nd Dec'15
 * @Description : Test class for APTS_SaveDraftCartController
 **************************************************************/

@isTest
public class APTS_SaveDraftCartControllerTest {
    
    public testMethod static void testOne() {
        
        User usr = APTS_LP_TestUtility.getUser();
        System.runAs(usr) {
            
            Test.startTest();
            
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
            Opportunity oppty = APTS_LP_TestUtility.getOpportunity('Test Oppty');
            insert oppty;
            
            Apttus_Proposal__Proposal__c proposal = APTS_LP_TestUtility.getProposal('Test Proposal');
            proposal.Apttus_Proposal__Opportunity__c = oppty.Id;
            insert proposal;
            
            PageReference ref = Page.APTS_SaveDraftPage;
            Test.setCurrentPage(ref);
            
            //ref.getParameters().put('Id', config.Id);
            //APTS_SaveDraftCartController controller = new APTS_SaveDraftCartController();
            //controller.saveDraftMethod();
            
            //For Proposal
            Apttus_Config2__ProductConfiguration__c config = APTS_LP_TestUtility.getProductConfiguration('Test Configuration');
            config.Apttus_QPConfig__Proposald__c = proposal.Id;
            insert config;
            
            ref.getParameters().put('Id', config.Id);
            APTS_SaveDraftCartController controller = new APTS_SaveDraftCartController();
            controller.saveDraftMethod();
            
            // For un-inserted configuration.
            config = APTS_LP_TestUtility.getProductConfiguration('Test Configuration');
            config.Apttus_QPConfig__Proposald__c = proposal.Id;            
            
            ref.getParameters().put('Id', config.Id);
            controller = new APTS_SaveDraftCartController();
            controller.saveDraftMethod();
            
            Test.stopTest();
        }
    }
}