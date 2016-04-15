/*************************************************************
@Name: APTS_LP_QueryUtilityTest
@Author: Prabhat Rai
@CreateDate: 26/09/2015
@Description: This class tests following Classes : APTS_LP_QueryUtility
@UsedBy: NA
******************************************************************/

@isTest
public class APTS_LP_QueryUtilityTest {

     private static APTS_Capture_LSO_Input_Config_Settings__c lodConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();
    //Test all the methods in APTS_LP_QueryUtility Class
    private static testMethod void QueryUtilityMethodsTest() {

		System.runAs(APTS_LP_TestUtility.getUser()){
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCommonConfigSetting();
            Apttus__APTS_Agreement__c agreement = APTS_LP_TestUtility.getAgreement('TestAgreement');   
            insert agreement;
            Test.startTest();
            APTS_LP_QueryUtility.getAgreement(agreement.id);     
            APTS_LP_QueryUtility.getAgreement(null); 
            APTS_LP_QueryUtility.getAgreementLineItemList(agreement.id);     
            APTS_LP_QueryUtility.getAgreementLineItemList(null);     
            APTS_LP_QueryUtility.getProductConfiguration(new Set<String> {'01tc0000003MaKq'});     
            APTS_LP_QueryUtility.getProductConfiguration(null);   
            APTS_LP_QueryUtility.getPriceList();   
            APTS_LP_QueryUtility.getAccount(new Set<String> {'01tc0000003MaKq'});   
            APTS_LP_QueryUtility.getAccount(null);   
            APTS_LP_QueryUtility.getUser(new Set<String> {'01tc0000003MaKq'});   
            APTS_LP_QueryUtility.getUser(null);
            APTS_LP_QueryUtility.isUserDivisionLP();   
            APTS_LP_QueryUtility.getUserSalesOfficeCode();
            APTS_LP_QueryUtility.getDefaultLocalChannel();
            APTS_LP_QueryUtility.getDefaultDistributionChannel();
            APTS_LP_QueryUtility.getAgreementSAPSetting();
            Test.stopTest();
        }
    }
    
   

}