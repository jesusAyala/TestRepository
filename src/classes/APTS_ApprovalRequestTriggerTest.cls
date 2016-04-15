/**
* @Name : APTS_ApprovalRequestTriggerTest
* @Author : Shalin Shah (sshah@apttus.com)
* @CreateDate: 16th Sept 2015
* @Description: Test class for handler class
* @BaseClass : APTS_ApprovalRequestTrigger
*/

@isTest (seealldata=false)
public with sharing class APTS_ApprovalRequestTriggerTest {
    
    static APTS_Capture_LSO_Input_Config_Settings__c oLODConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();
    static Apttus_Approval__ApprovalsSystemProperties__c approvalSystemProperties = APTS_LP_TestUtility.getApprovalSystemProperty();

    static testMethod void testMethod1() {
        System.runAs(APTS_LP_TestUtility.getUser()) {
            List<APTS_Discounts_Config__c> listDiscountConfig = APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
            Account acc = APTS_LP_TestUtility.getNewAccount('Apttus Inc','Spain');
            insert acc;
            
            Apttus_Proposal__Proposal__c quote = APTS_LP_TestUtility.getProposal('Apttus quote');
            quote.APTS_LP_Account_End_User__c = acc.Id;
            insert quote;
            
            Apttus_Proposal__Proposal__Share quoteShare = new Apttus_Proposal__Proposal__Share();
            quoteShare.RowCause = 'APTS_EnableAccessToApprover__c';
            quoteShare.ParentId = quote.id;
            quoteShare.UserOrGroupId = UserInfo.getUserId();
            quoteShare.AccessLevel = 'Read';
            insert quoteShare;
            
            Apttus_Approval__Approval_Request__c objApproval1 = new Apttus_Approval__Approval_Request__c(
                Apttus_Approval__Assigned_To_Name__c = 'Test Test1',
                Apttus_Approval__Assigned_To_Type__c = 'User');
            objApproval1.Apttus_Approval__Object_Type__c = 'Apttus_Proposal__Proposal__c';
            objApproval1.Apttus_Approval__Object_Id__c = quote.Id;
            objApproval1.Apttus_Approval__HasDelegateApprover__c = TRUE;
            objApproval1.Apttus_Approval__DelegateApprover__c = UserInfo.getUserId();
            objApproval1.Apttus_Approval__Assigned_To_Id__c = String.valueOf(UserInfo.getUserId());
            insert objApproval1;
            
            objApproval1.Apttus_Approval__Approval_Status__c = 'Rejected';
            update objApproval1;
            
            objApproval1.Apttus_Approval__Approval_Status__c = 'Rejected';
            objApproval1.Apttus_Approval__Approver_Comments__c = 'Rejected due to high discount';
            objApproval1.Apttus_QPApprov__ProposalId__c = quote.Id;
            
            try{
                update objApproval1;
            }catch(exception ex){}
            
            try {
                delete objApproval1;
            } catch(Exception ex) {}
        }
    }
    
    static testMethod void testMethod2() {
        System.runAs(APTS_LP_TestUtility.getUser()) {
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
            Apttus__APTS_Agreement__c agreement = APTS_LP_TestUtility.getAgreement('TestAgreement');
            insert agreement;
            
            Apttus__APTS_Agreement__Share agreementShare = new Apttus__APTS_Agreement__Share();
            agreementShare.RowCause = 'APTS_EnableAccessToApprover__c';
            agreementShare.ParentId = agreement.id;
            agreementShare.UserOrGroupId = UserInfo.getUserId();
            agreementShare.AccessLevel = 'Read';
            insert agreementShare;
            
            Apttus_Approval__Approval_Request__c objApproval1 = new Apttus_Approval__Approval_Request__c(
                Apttus_Approval__Assigned_To_Name__c = 'Test Test1',
                Apttus_Approval__Assigned_To_Type__c = 'User');
            objApproval1.Apttus_Approval__Object_Type__c = 'Apttus__APTS_Agreement__c';
            objApproval1.Apttus_Approval__Object_Id__c = agreement.Id;
            objApproval1.Apttus_Approval__HasDelegateApprover__c = TRUE;
            objApproval1.Apttus_Approval__DelegateApprover__c = UserInfo.getUserId();
            objApproval1.Apttus_Approval__Assigned_To_Id__c = String.valueOf(UserInfo.getUserId());
            objApproval1.Apttus_Approval__Approver_Comments__c = 'Test Comments';
            insert objApproval1;
            
            objApproval1.Apttus_Approval__Approval_Status__c = 'Approved';
            objApproval1.Apttus_Approval__Approver_Comments__c = 'Approved by Test Manager.';
            objApproval1.Apttus_Approval__Related_Agreement__c = agreement.Id;
            try {
                update objApproval1;
            } catch (Exception ex) {}
            
            try {
                delete objApproval1;
            } catch(Exception ex) {}
        }
    }
}