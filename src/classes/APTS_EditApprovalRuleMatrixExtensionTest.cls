/*************************************************************
@Name: APTS_EditApprovalRuleMatrixExtensionTest
@Author: Chetan Patel
@CreateDate: 15th Oct 2015
@Description: test class for APTS_EditApprovalRuleMatrixExtension class
@UsedBy: Visualforce Page - APTS_EditApprovalRuleMatrix, Apex Class  - APTS_EditApprovalRuleMatrixExtension
******************************************************************/

@isTest
public class APTS_EditApprovalRuleMatrixExtensionTest {
    
    public static testMethod void methodWithOneRuleMatrix() {
        User usr = APTS_LP_TestUtility.getUser();
        System.runAs(usr) {
            
            Test.startTest();
            APTS_LP_TestUtility.getCommonConfigSetting();
            APTS_Approval_Rule_Matrix__c rule = APTS_LP_TestUtility.getApproalRuleMatrix()[0];
            
            APTS_Approval_Rule_Matrix__c dummyApproval = new APTS_Approval_Rule_Matrix__c();
            dummyApproval.APTS_Country__c = 'Spain';
            dummyApproval.APTS_Sales_Organisation__c = 'ABB';
            dummyApproval.APTS_GTV_Level_Code__c = '00996';
            dummyApproval.APTS_Threshold_Discount__c = APTS_EditApprovalRuleMatrixExtension.THRESHOLD_DISCOUNT_DUMMY_CUTOFF + 1;
            dummyApproval.APTS_Approval_Level__c = 3;
            dummyApproval.APTS_Max_Discount__c = APTS_EditApprovalRuleMatrixExtension.THRESHOLD_DISCOUNT_DUMMY_CUTOFF + 2;
            dummyApproval.APTS_LP_Local_Channel__c = APTS_LP_TestUtility.getLocalChannel().id;
            dummyApproval.APTS_Sales_Office__c = APTS_LP_TestUtility.getSalesOffice().id;
            dummyApproval.APTS_LP_Sales_Office__c = APTS_LP_TestUtility.getMasterPicklistSalesOffice().Id;
            dummyApproval.APTS_Assigned_to__c = UserInfo.getUserId();
            insert dummyApproval;
            
            /* Apttus__APTS_Admin__c admin = new Apttus__APTS_Admin__c();
            admin.Name = 'APTS_MaxApprovalRuleMatrixLevels';
            admin.Apttus__Value__c = '1';
            insert admin; */
            
            ApexPages.StandardController sc = new ApexPages.StandardController(rule);
            APTS_EditApprovalRuleMatrixExtension controller = new APTS_EditApprovalRuleMatrixExtension(sc);
            
            PageReference pageRef = Page.APTS_EditApprovalRuleMatrix;
            pageRef.getParameters().put('id', String.valueOf(rule.Id));
            Test.setCurrentPage(pageRef);
            
            APTS_EditApprovalRuleMatrixExtension.ApprovalRuleMatrixWrapperByDiscount discount = new APTS_EditApprovalRuleMatrixExtension.ApprovalRuleMatrixWrapperByDiscount(70, 100, rule);
                    
            controller.addRow();
            controller.addRow();
            controller.addRow();
            
            pageRef.getParameters().put('iRowNumber','1');
            controller.addRowInner();
            
            controller.Save();
            controller.Add();
            
            pageRef.getParameters().put('iRowNumber','1');
            controller.addRowInner();
            
            controller.Save();
            
            pageRef.getParameters().put('iRowNumber','1');
            pageRef.getParameters().put('innerRowNumber','2');
            controller.deleteRowInner();
            
            pageRef.getParameters().put('iRowNumber','1');
            controller.deleteRow();
            
            controller.Save();
            controller.Add();
            controller.getHistoryOnComplete();
            
            Test.stopTest();
        }
    }
    
    public static testMethod void methodWithNoRuleMatrix() {
        User usr = APTS_LP_TestUtility.getUser();
        System.runAs(usr) {
            
            Test.startTest();
            APTS_LP_TestUtility.getCommonConfigSetting();
            APTS_Approval_Rule_Matrix__c rule = new APTS_Approval_Rule_Matrix__c();
            rule.APTS_Country__c = 'Spain';
            rule.APTS_Sales_Organisation__c = 'ABB';
            rule.APTS_GTV_Level_Code__c = '00996';
            rule.APTS_Threshold_Discount__c = 71.13;
            rule.APTS_Approval_Level__c = 2;
            rule.APTS_Max_Discount__c = 100.00;
            rule.APTS_LP_Local_Channel__c = APTS_LP_TestUtility.getLocalChannel().id;
            rule.APTS_Sales_Office__c = APTS_LP_TestUtility.getSalesOffice().id;
            rule.APTS_LP_Sales_Office__c = APTS_LP_TestUtility.getMasterPicklistSalesOffice().Id;
            rule.APTS_Assigned_to__c = UserInfo.getUserId();
            
            Apttus__APTS_Admin__c admin = new Apttus__APTS_Admin__c();
            admin.Name = 'APTS_MaxApprovalRuleMatrixLevels';
            admin.Apttus__Value__c = '2';
            insert admin;
            
            ApexPages.StandardController sc = new ApexPages.StandardController(rule);
            APTS_EditApprovalRuleMatrixExtension controller = new APTS_EditApprovalRuleMatrixExtension(sc);
            
            PageReference pageRef = Page.APTS_EditApprovalRuleMatrix;
            Test.setCurrentPage(pageRef);
            
            controller.saveOrAdd();
            
            controller.addRow();
            controller.addRow();
            controller.addRow();
            
            pageRef.getParameters().put('iRowNumber','1');
            controller.addRowInner();
            
            pageRef.getParameters().put('iRowNumber','1');
            controller.addRowInner();
            
            controller.saveOrAdd();
            
            pageRef.getParameters().put('iRowNumber','1');
            pageRef.getParameters().put('innerRowNumber','2');
            controller.deleteRowInner();
            
            pageRef.getParameters().put('iRowNumber','1');
            controller.deleteRow();
            
            controller.getHistoryOnComplete();
            
            Test.stopTest();
        }
    }
    
    public static testMethod void testInValidThreshold() {
        User usr = APTS_LP_TestUtility.getUser();
        System.runAs(usr) {
            
            Test.startTest();
            APTS_LP_TestUtility.getCommonConfigSetting();
            APTS_Approval_Rule_Matrix__c rule = APTS_LP_TestUtility.getApproalRuleMatrix()[0];
            
            APTS_Approval_Rule_Matrix__c dummyApproval = new APTS_Approval_Rule_Matrix__c();
            dummyApproval.APTS_Country__c = 'Spain';
            dummyApproval.APTS_Sales_Organisation__c = 'ABB';
            dummyApproval.APTS_GTV_Level_Code__c = '00996';
            dummyApproval.APTS_Threshold_Discount__c = 101;
            dummyApproval.APTS_Approval_Level__c = 3;
            dummyApproval.APTS_Max_Discount__c = 102;
            dummyApproval.APTS_LP_Local_Channel__c = APTS_LP_TestUtility.getLocalChannel().id;
            dummyApproval.APTS_Sales_Office__c = APTS_LP_TestUtility.getSalesOffice().id;
            dummyApproval.APTS_LP_Sales_Office__c = APTS_LP_TestUtility.getMasterPicklistSalesOffice().Id;
            dummyApproval.APTS_Assigned_to__c = UserInfo.getUserId();
            insert dummyApproval;
            
            Apttus__APTS_Admin__c admin = new Apttus__APTS_Admin__c();
            admin.Name = 'APTS_MaxApprovalRuleMatrixLevels';
            admin.Apttus__Value__c = '1';
            insert admin;
            
            ApexPages.StandardController sc = new ApexPages.StandardController(rule);
            APTS_EditApprovalRuleMatrixExtension controller = new APTS_EditApprovalRuleMatrixExtension(sc);
            
            PageReference pageRef = Page.APTS_EditApprovalRuleMatrix;
            pageRef.getParameters().put('id', String.valueOf(rule.Id));
            Test.setCurrentPage(pageRef);
            
            APTS_EditApprovalRuleMatrixExtension.ApprovalRuleMatrixWrapperByDiscount discount = new APTS_EditApprovalRuleMatrixExtension.ApprovalRuleMatrixWrapperByDiscount(70, 100, rule);
                    
            controller.addRow();
            controller.addRow();
            controller.addRow();
            
            pageRef.getParameters().put('iRowNumber','1');
            controller.addRowInner();
            
            controller.Save();
            controller.Add();
            
            pageRef.getParameters().put('iRowNumber','1');
            controller.addRowInner();
            
            pageRef.getParameters().put('iRowNumber','1');
            pageRef.getParameters().put('innerRowNumber','2');
            controller.deleteRowInner();
            
            pageRef.getParameters().put('iRowNumber','1');
            controller.deleteRow();
            
            controller.Save();
            controller.Add();
            controller.getHistoryOnComplete();
            
            Test.stopTest();
        }
    }
}