@isTest(SeeAllData = false)
public class APTS_ABB_LP_SAP_Integration_Util_Test {
    
    static testmethod void testgetSASTokens(){
        
        APTS_LP_TestUtility.getIntegrationParameters();
        APTS_LP_TestUtility.getSAPIntegrationTokens();
        APTS_LP_TestUtility.getCommonConfigSetting();
        APTS_LP_TestUtility.getLODConfigSetting();
        
        APTS_Config_SAP_Integration__c sapConfig = new APTS_Config_SAP_Integration__c(name = 'MSPA SAP Config');
        sapConfig.APTS_of_Re_Tries__c = 2;
        sapConfig.APTS_Call_Interval__c = 2;
        insert sapConfig;
        
        Test.setMock(HttpCalloutMock.class, new APTPS_SAPCalloutMockTest());
        
        Test.startTest();
        APTS_ABB_LP_SAP_Integration_Util.getSasToken();
        
        APTS_ABB_LP_SAP_Integration_Util.GetSecureOauthTokenAzure();
        
        //APTS_ABB_LP_SAP_Integration_Util.getSAPRequestJSON();
        
        System.debug('AXAY: '+APTS_ABB_LP_SAP_Integration_Util.errorMsg);
        Test.stopTest();
        
        }
        
        static testmethod void testTokenWrapper(){
            
            APTS_ABB_LP_SAP_Tokens.AgreementLineItems aLines = new APTS_ABB_LP_SAP_Tokens.AgreementLineItems();
            aLines.ProductHierarchy = '00M0';
            aLines.ProductCode = '0200M';
            
            APTS_ABB_LP_SAP_Tokens.IntegrationError err = new APTS_ABB_LP_SAP_Tokens.IntegrationError();
            err.Code = '502';
            
            APTS_ABB_LP_SAP_Tokens.MSPASAPResponseWrapper res = new APTS_ABB_LP_SAP_Tokens.MSPASAPResponseWrapper();
            res.Errors = new List<APTS_ABB_LP_SAP_Tokens.IntegrationError>{err};
            res.SalesDealItems = new List<APTS_ABB_LP_SAP_Tokens.AgreementLineItems>{aLines};
            
            APTS_ABB_LP_SAP_Tokens.oAuthIntegrationToken token = new APTS_ABB_LP_SAP_Tokens.oAuthIntegrationToken();
            token.token_type = '1';
            token.expires_in = 2;
            token.refresh_token = '3';
            
        }
    
    
}