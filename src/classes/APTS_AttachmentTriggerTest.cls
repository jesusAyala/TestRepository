@isTest
public class APTS_AttachmentTriggerTest {
    
    
    private static testMethod void APTS_AttachmentTriggerTest() {
        
        System.runAs(APTS_LP_TestUtility.getUser()){
            Test.startTest();                        
            
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
            Apttus_Proposal__Proposal__c oProposal = APTS_LP_TestUtility.getProposal('Testing Proposal');
            
            insert oProposal;            
            
            Attachment oAttach = new Attachment();
            oAttach.ParentId = oProposal.Id;
            oAttach.Body = Blob.valueOf('Testing');  
            oAttach.Name = 'Quotation - Name15333_Cliente_2016-02-09.pdf';
            insert oAttach;
            
            
            Test.stopTest();
            
        }
        
    }
    
}