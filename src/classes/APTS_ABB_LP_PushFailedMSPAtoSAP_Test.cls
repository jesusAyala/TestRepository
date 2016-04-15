@isTest(seeAllData=false)
public class APTS_ABB_LP_PushFailedMSPAtoSAP_Test {
	    public static String CRON_EXP = '0 0 0 15 3 ? 2022';

    	//Test when agreement status is Approved
	    public static testMethod void testScheduledThwartedAgreement(){
			System.runAs(APTS_LP_TestUtility.getUser()) {
                List < APTS_Discounts_Config__c > listDisConfig = APTS_LP_TestUtility.getDiscountConfig();
                APTS_LP_TestUtility.getCommonConfigSetting();
                
                Account acc =  APTS_LP_TestUtility.getNewAccount('Test-Account', 'Spain');
                insert acc;
                
                Opportunity opp = APTS_LP_TestUtility.getOpportunity('Test Oppty');
                insert opp;
                
                Apttus__APTS_Agreement__c agr = APTS_LP_TestUtility.getAgreement('TestAgreement');
                agr.Apttus__Related_Opportunity__c = opp.Id;
                agr.Apttus__Status__c = 'Approved';
                agr.APTS_LP_Sales_Person__c = UserInfo.getUserId();
                agr.APTS_LP_AccountCustomer__c = acc.id;
                insert agr;
                
                agr.Apttus__Status__c = 'Approved';
                update agr;
                System.debug('*** Agreement Details: ' + [SELECT Id, Apttus__Status__c FROM Apttus__APTS_Agreement__c WHERE Id = :agr.id]);
               
                Test.startTest();
                    System.debug('Going to run test with Agreement status Approved.');
                    String jobId = System.schedule('ScheduleApexClassTes',
                                                   CRON_EXP,
                                                   new APTS_ABB_LP_PushFailedMSPAtoSAP(agr.Id));
                    
                    APTS_ABB_LP_Thwarted_Agreement__c thwartedAgr = new APTS_ABB_LP_Thwarted_Agreement__c();
                    thwartedAgr.APTS_Object_Id__c = agr.id;
                    thwartedAgr.APTS_Cron_Job_Id__c = jobId;
                    thwartedAgr.CurrencyIsoCode = 'EUR';
                    insert thwartedAgr;
                    
                    System.debug('1st Test Finished.');
                Test.stopTest();
            }
       }
    
/*    //Test when agreement Status is Draft.
    public static testMethod void testScheduledThwartedAgreement2(){
			System.runAs(APTS_LP_TestUtility.getUser()) {
                List < APTS_Discounts_Config__c > listDisConfig = APTS_LP_TestUtility.getDiscountConfig();
                APTS_LP_TestUtility.getCommonConfigSetting();
                
                Account acc =  APTS_LP_TestUtility.getNewAccount('Test-Account1', 'Spain');
                insert acc;
                
                Opportunity opp = APTS_LP_TestUtility.getOpportunity('Test Oppty1');
                insert opp;
                
                Apttus__APTS_Agreement__c agr = APTS_LP_TestUtility.getAgreement('TestAgreement1');
                agr.Apttus__Related_Opportunity__c = opp.Id;
                agr.Apttus__Status__c = 'Approved';
                agr.APTS_LP_Sales_Person__c = UserInfo.getUserId();
                agr.APTS_LP_AccountCustomer__c = acc.id;
                insert agr;
                System.debug('*** Agreement Details: ' + [SELECT Id, Apttus__Status__c FROM Apttus__APTS_Agreement__c WHERE Id = :agr.id]);
               
                Test.startTest();
                    System.debug('Going to run test with Agreement status Draft.');
                    String jobId = System.schedule('ScheduleApexClassTest1',
                                                   CRON_EXP,
                                                   new APTS_ABB_LP_PushFailedMSPAtoSAP(agr.Id));
                    
                    APTS_ABB_LP_Thwarted_Agreement__c thwartedAgr = new APTS_ABB_LP_Thwarted_Agreement__c();
                    thwartedAgr.APTS_Object_Id__c = agr.id;
                    thwartedAgr.APTS_Cron_Job_Id__c = jobId;
                    thwartedAgr.CurrencyIsoCode = 'EUR';
                    insert thwartedAgr;
                    
                    System.debug('2nd Test Finished.');
                Test.stopTest();
            }
       } */
}