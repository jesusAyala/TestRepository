@isTest
public class APTS_DelegateApproverTriggerTest {
    
    private static User usr;
    
    public static testMethod void testDelegateApprover() {
        
        usr  = APTS_LP_TestUtility.getUser();
        System.runAs(usr) {
            Test.startTest();
            
            // Create a group and insert it
            Group grp = new Group();
            grp.Name = 'Test';
            grp.developerName = 'Spain_Country_Admin_' + usr.Id;
            insert grp;
            
            GroupMember groupMember = new GroupMember();
            groupMember.GroupId  = grp.id;
            groupMember.UserOrGroupId = usr.id;
            insert groupMember;
            
            APTS_Delegated_Approver_Settings__c customSettings = APTS_LP_TestUtility.getDelegateApprovalCustomSettings();
            customSettings.APTS_Public_Group_Name__c = grp.developerName;
            insert customSettings;
            
            User anotherUser = APTS_LP_TestUtility.getUser();
            anotherUser.Country = 'India';
            update anotherUser;
            
            Apttus_Approval__Backup_Approver__c backApprover = new Apttus_Approval__Backup_Approver__c();
            backApprover.Apttus_Approval__Current_User__c = usr.id;
            backApprover.Apttus_Approval__Backup_User__c = anotherUser.id;
            insert backApprover;
            
            Apttus_Approval__Backup_Approver__c backApprover1 = new Apttus_Approval__Backup_Approver__c();
            backApprover1.Apttus_Approval__Current_User__c = anotherUser.id;
            backApprover1.Apttus_Approval__Backup_User__c = usr.id;
            try {
            	insert backApprover1;
            } catch (Exception ex) {}
            
            Test.stopTest();
        }
    }

}