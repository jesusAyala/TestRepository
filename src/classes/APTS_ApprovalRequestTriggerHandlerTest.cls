/**
 * @Name : APTS_ApprovalRequestTriggerHandlerTest
 * @Author : Shalin Shah (sshah@apttus.com)
 * @CreateDate: 16th Sept 2015
 * @Description: Test class for handler class
 * @BaseClass : APTS_ApprovalRequestTriggerHandler
 */

@isTest (seealldata=false)
public with sharing class APTS_ApprovalRequestTriggerHandlerTest {
    
    static testMethod void testMethod1() {
 System.runAs(APTS_LP_TestUtility.getUser()) {
        Account acc=APTS_LP_TestUtility.getNewAccount('Apttus Inc','Spain');
        insert acc;
        
        APTS_LP_TestUtility.getDiscountConfig();
		APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
        Apttus_Proposal__Proposal__c quote=APTS_LP_TestUtility.getProposal('Apttus quote');
        quote.APTS_LP_Account_End_User__c=acc.Id;
        insert quote;

        Apttus_Approval__ApprovalsSystemProperties__c approvalSystemProperties = new Apttus_Approval__ApprovalsSystemProperties__c( name = 'System Properties');
        approvalSystemProperties.APTS_Comments_Mandatory_On_Rejection__c = 'Comments Mandatory on Rejection';
        insert approvalSystemProperties;

        Apttus_Approval__Approval_Request__c objApproval1 = new Apttus_Approval__Approval_Request__c(
                                                  Apttus_Approval__Assigned_To_Name__c = 'Test Test1',
                                                  Apttus_Approval__Assigned_To_Type__c = 'User');
        objApproval1.Apttus_Approval__Object_Type__c = 'Apttus_Proposal__Proposal__c';
        objApproval1.Apttus_Approval__Object_Id__c = quote.Id;
        insert objApproval1;
        
        objApproval1.Apttus_Approval__Approval_Status__c = 'Rejected';
        update objApproval1;

        objApproval1.Apttus_Approval__Approval_Status__c = 'Rejected';
        objApproval1.Apttus_Approval__Approver_Comments__c = 'Rejected due to high discount';
        try{
          update objApproval1;
             
      }Catch(exception ex){}
 }
    }

    static testMethod void testMethod2() {
         System.runAs(APTS_LP_TestUtility.getUser()) {
      APTS_LP_TestUtility.getDiscountConfig();
	APTS_LP_TestUtility.getCommonConfigSetting();
      Apttus__APTS_Agreement__c agreement = APTS_LP_TestUtility.getAgreement('TestAgreement');
      insert agreement;        
      
      Apttus_Approval__ApprovalsSystemProperties__c approvalSystemProperties = new Apttus_Approval__ApprovalsSystemProperties__c( name = 'System Properties');
        approvalSystemProperties.APTS_Comments_Mandatory_On_Rejection__c = 'Comments Mandatory on Rejection';
        insert approvalSystemProperties;

        Apttus_Approval__Approval_Request__c objApproval1 = new Apttus_Approval__Approval_Request__c(
                                                  Apttus_Approval__Assigned_To_Name__c = 'Test Test1',
                                                  Apttus_Approval__Assigned_To_Type__c = 'User');
        objApproval1.Apttus_Approval__Object_Type__c = 'Apttus__APTS_Agreement__c';
        objApproval1.Apttus_Approval__Object_Id__c = agreement.Id;
        insert objApproval1;
        
        objApproval1.Apttus_Approval__Approval_Status__c = 'Approved';
        update objApproval1;
         }

    }
}