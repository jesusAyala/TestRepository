/**************************************************************
 * @Name : APTS_CancelAgreementApprovalCtrlTest
 * @Owner : Shalin Shah <sshah@apttus.com>
 * @CreatedOn : 2nd Dec'15
 * @Description : Test class for APTS_CancelAgreementApprovalController
 **************************************************************/

@isTest
public class APTS_CancelAgreementApprovalCtrlTest {

    public testMethod static void testOne() {
        
        User usr = APTS_LP_TestUtility.getUser();
        System.runAs(usr) {
            
            Test.startTest();
            
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCommonConfigSetting();
            Apttus__APTS_Agreement__c agreement = APTS_LP_TestUtility.getAgreement('Test Agreement');
            insert agreement;
            
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
            
            PageReference ref = Page.APTS_CancelAgreementApproval;
            Test.setCurrentPage(ref);
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(agreement);
            APTS_CancelAgreementApprovalController controller = new APTS_CancelAgreementApprovalController(stdController);
            controller.onload();
            
            Test.stopTest();
        }
    }
}