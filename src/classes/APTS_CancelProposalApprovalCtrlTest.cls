/**************************************************************
 * @Name : APTS_CancelProposalApprovalCtrlTest
 * @Owner : Shalin Shah <sshah@apttus.com>
 * @CreatedOn : 2nd Dec'15
 * @Description : Test class for APTS_CancelProposalApprovalController
 **************************************************************/

@isTest
public class APTS_CancelProposalApprovalCtrlTest {

    public testMethod static void testOne() {
        
        User usr = APTS_LP_TestUtility.getUser();
        System.runAs(usr) {
            
            Test.startTest();
            
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
            Apttus_Proposal__Proposal__c proposal = APTS_LP_TestUtility.getProposal('Test Proposal');
            insert proposal;
            
            Group grpMain = new Group();
            grpMain.Name = 'Spain Country Admin';
            grpMain.Type = 'Regular';
            insert grpMain;
            
            Group grpChild = new Group();
            grpChild.Name = 'Test Name';
            grpChild.Type = 'Regular';
            insert grpChild;
            
            GroupMember userMember = new GroupMember();
            userMember.UserOrGroupId = usr.Id;
            userMember.GroupId = grpMain.Id;
            insert userMember;
            
            GroupMember grpMember = new GroupMember();
            grpMember.UserOrGroupId = grpChild.Id;
            grpMember.GroupId = grpMain.Id;
            insert grpMember;
            
            PageReference ref = Page.APTS_CancelProposalApproval;
            Test.setCurrentPage(ref);
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(proposal);
            APTS_CancelProposalApprovalController controller = new APTS_CancelProposalApprovalController(stdController);
            controller.onload();
            
            Test.stopTest();
        }
    }
}