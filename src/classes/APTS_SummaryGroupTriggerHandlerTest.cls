@isTest
public class APTS_SummaryGroupTriggerHandlerTest {

    @isTest static void updateSummaryGroup() {
    
        APTS_PricingCallback.bUpdateSummaryGr = true;
        
        system.runAs(APTS_LP_TestUtility.getUser()){
            
            Apttus_Config2__ProductConfiguration__c productConfig = APTS_LP_TestUtility.getProductConfiguration('Test-Config');
            
            Test.startTest();
            
            insert productConfig;
            Apttus_Config2__SummaryGroup__c oSummaryGroup = new Apttus_Config2__SummaryGroup__c();
            oSummaryGroup.Name = 'Test';
            oSummaryGroup.Apttus_Config2__ItemSequence__c = 5.0;
            oSummaryGroup.Apttus_Config2__LineNumber__c = 2;
            oSummaryGroup.Apttus_Config2__ConfigurationId__c = productConfig.id;
            insert oSummaryGroup;
            oSummaryGroup.Apttus_Config2__ChargeType__c = 'License Fee';
            update oSummaryGroup;
            
            Test.stopTest();
            
        }
    }
    
    
    @isTest static void updateSummaryGroup2() {
    
        APTS_PricingCallback.bUpdateSummaryGr = false;
        
        system.runAs(APTS_LP_TestUtility.getUser()){
            APTS_LP_TestUtility.getCommonConfigSetting();
            Apttus_Config2__ProductConfiguration__c productConfig = APTS_LP_TestUtility.getProductConfiguration('Test-Config');
            
            Test.startTest();
            
            insert productConfig;
            Apttus_Config2__SummaryGroup__c oSummaryGroup = new Apttus_Config2__SummaryGroup__c();
            oSummaryGroup.Name = 'Test';
            oSummaryGroup.Apttus_Config2__ItemSequence__c = 5.0;
            oSummaryGroup.Apttus_Config2__LineNumber__c = 2;
            oSummaryGroup.Apttus_Config2__ConfigurationId__c = productConfig.id;
            insert oSummaryGroup;
            oSummaryGroup.Apttus_Config2__ChargeType__c = 'License Fee';
            update oSummaryGroup;
            
            Test.stopTest();
            
        }
    }
    
}