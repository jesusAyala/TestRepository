@isTest
private class APTS_GenerateSecureoAuthTokenCntrlrTest {

	@isTest static void test_method_one() {

		APTS_SAP_Integration_Tokens__c PricingToken = new APTS_SAP_Integration_Tokens__c();
        PricingToken.Name = 'SAP Pricing Tokens';
        PricingToken.APTS_Base_Address__c = 'https://abberpgatewaydev.servicebus.windows.net/';
        PricingToken.APTS_Bau_Code__c = 'ES1';
        PricingToken.APTS_Key__c = 'Sd6tRl5wj9ieNgE6q7Q9Y/wkYoD24aqERudvHvB9Ow8=';
        PricingToken.APTS_Key_Name__c = 'FaceServiceBusServices';
        PricingToken.APTS_End_Point__c = 'https://abberpgatewaydev.servicebus.windows.net/api/products/quotationpricelistsearch';
        PricingToken.APTS_ERP_Response_Culture__c = 'es-ES';
        PricingToken.APTS_Http_Header_Key__c = 'Authorization';
        Insert PricingToken;

		


		APTS_SAP_Integration_Tokens__c OAuthToken1 = new APTS_SAP_Integration_Tokens__c();
        OAuthToken1.Name = 'SAP oAuth Tokens';
        OauthToken1.APTS_Base_Address__c = 'https://abberpgatewaydev.servicebus.windows.net/';
        OauthToken1.APTS_Key__c = 'hj7nmmYxSZbtVsyeyqAJ';
        OauthToken1.APTS_Http_Header_Key__c = 'Authorization';
        OauthToken1.APTS_oAuth_Token__c = 'ErpGateway1:nU2+tOVFCK81+/wuuSx61QgOyySMcS9z//go4Lpej6k=';
        OauthToken1.APTS_Key_Name__c = 'FaceErpGateway_ServiceBus';
        OauthToken1.APTS_End_Point__c = 'https://applications.it.abb.com/abbaccountstest/issue/oauth2/token';
        insert OauthToken1;

		String access_token;
		string errors='';

		
        string ERROR_EXIST='SERVER_ERROR_EXIST';

        Test.setMock(HttpCalloutMock.class, new APTS_MockHttpResponseGeneratorTest());

         APTS_SAP_Integration_Tokens__c SAPPricingDataset= APTS_SAP_Integration_Tokens__c.getValues('SAP Pricing Tokens');
            
            //get base address from custom setting
            String baseaddress = SAPPricingDataset.APTS_Base_Address__c;

			Test.startTest();

			String result = APTS_GenerateSecureoAuthTokenController.GetSecureOauthTokenAzure(baseaddress);

         if(!result.contains(ERROR_EXIST)){
            
                //get access token here
                access_token = result;
            
            } else {//in case of authentication failure, return an error message to show on UI
                
                //get errors(if any exist) here
                errors=result;
               
                
            }

            Test.stopTest();

            system.debug('--> '+access_token);
            system.debug('--> '+errors);


	}

	@isTest static void test_method_two() {

		APTS_SAP_Integration_Tokens__c PricingToken = new APTS_SAP_Integration_Tokens__c();
        PricingToken.Name = 'SAP Pricing Tokens';
        PricingToken.APTS_Base_Address__c = 'https://abberpgatewaydev.servicebus.windows.net/';
        PricingToken.APTS_Bau_Code__c = 'ES1';
        PricingToken.APTS_Key__c = 'Sd6tRl5wj9ieNgE6q7Q9Y/wkYoD24aqERudvHvB9Ow8=';
        PricingToken.APTS_Key_Name__c = 'FaceServiceBusServices';
        PricingToken.APTS_End_Point__c = 'https://abberpgatewaydev.servicebus.windows.net/api/products/quotationpricelistsearch';
        PricingToken.APTS_ERP_Response_Culture__c = 'es-ES';
        PricingToken.APTS_Http_Header_Key__c = 'Authorization';
        Insert PricingToken;

		APTS_SAP_Integration_Tokens__c OAuthToken1 = new APTS_SAP_Integration_Tokens__c();
        OAuthToken1.Name = 'SAP oAuth Tokens';
        OauthToken1.APTS_Base_Address__c = 'https://abberpgatewaydev.servicebus.windows.net/';
        OauthToken1.APTS_Key__c = 'hj7nmmYxSZbtVsyeyqAJ';
        OauthToken1.APTS_Http_Header_Key__c = 'Authorization';
        OauthToken1.APTS_oAuth_Token__c = 'ErpGateway1:nU2+tOVFCK81+/wuuSx61QgOyySMcS9z//go4Lpej6k=';
        OauthToken1.APTS_Key_Name__c = 'FaceErpGateway_ServiceBus';
        OauthToken1.APTS_End_Point__c = 'https://applications.it.abb.com/abbaccountstest/issue/oauth2/token';
        insert OauthToken1;
		String access_token;
		string errors='';

		Test.setMock(HttpCalloutMock.class, new APTS_MockHttpWrongResponseGenTest());

		
        string ERROR_EXIST='SERVER_ERROR_EXIST';

        Test.startTest();

         APTS_SAP_Integration_Tokens__c SAPPricingDataset= APTS_SAP_Integration_Tokens__c.getValues('SAP Pricing Tokens');
            
            //get base address from custom setting
         String baseaddress = SAPPricingDataset.APTS_Base_Address__c;

         String result = APTS_GenerateSecureoAuthTokenController.GetSecureOauthTokenAzure(baseaddress);
			
         if(!result.contains(ERROR_EXIST)){
            
                //get access token here
                access_token = result;
            
            } else {//in case of authentication failure, return an error message to show on UI
                
                //get errors(if any exist) here
                errors=result;
               
                
            }

		 Test.stopTest();
         system.debug('--> '+access_token);
         system.debug('--> '+errors);


	}
	

	@isTest static void test_method_three() {

		APTS_SAP_Integration_Tokens__c PricingToken = new APTS_SAP_Integration_Tokens__c();
        PricingToken.Name = 'SAP Pricing Tokens';
        PricingToken.APTS_Base_Address__c = 'https://abberpgatewaydev.servicebus.windows.net/';
        PricingToken.APTS_Bau_Code__c = 'ES1';
        PricingToken.APTS_Key__c = 'Sd6tRl5wj9ieNgE6q7Q9Y/wkYoD24aqERudvHvB9Ow8=';
        PricingToken.APTS_Key_Name__c = 'FaceServiceBusServices';
        PricingToken.APTS_End_Point__c = 'https://abberpgatewaydev.servicebus.windows.net/api/products/quotationpricelistsearch';
        PricingToken.APTS_ERP_Response_Culture__c = 'es-ES';
        PricingToken.APTS_Http_Header_Key__c = 'Authorization';
        Insert PricingToken;

		APTS_SAP_Integration_Tokens__c OAuthToken1 = new APTS_SAP_Integration_Tokens__c();
        OAuthToken1.Name = 'SAP oAuth Tokens';
        OauthToken1.APTS_Base_Address__c = 'https://abberpgatewaydev.servicebus.windows.net/';
        OauthToken1.APTS_Key__c = 'hj7nmmYxSZbtVsyeyqAJ';
        OauthToken1.APTS_Http_Header_Key__c = 'Authorization';
        OauthToken1.APTS_oAuth_Token__c = 'ErpGateway1:nU2+tOVFCK81+/wuuSx61QgOyySMcS9z//go4Lpej6k=';
        OauthToken1.APTS_Key_Name__c = 'FaceErpGateway_ServiceBus';
        OauthToken1.APTS_End_Point__c = 'https://applications.it.abb.com/abbaccountstest/issue/oauth2/token';
        insert OauthToken1;
		String access_token;
		string errors='';

		Test.setMock(HttpCalloutMock.class, new APTS_MockHttpWrongResponseGenTest2());

		
        string ERROR_EXIST='SERVER_ERROR_EXIST';

        Test.startTest();

         APTS_SAP_Integration_Tokens__c SAPPricingDataset= APTS_SAP_Integration_Tokens__c.getValues('SAP Pricing Tokens');
            
            //get base address from custom setting
         String baseaddress = SAPPricingDataset.APTS_Base_Address__c;

         String result = APTS_GenerateSecureoAuthTokenController.GetSecureOauthTokenAzure(baseaddress);
			
         if(!result.contains(ERROR_EXIST)){
            
                //get access token here
                access_token = result;
            
            } else {//in case of authentication failure, return an error message to show on UI
                
                //get errors(if any exist) here
                errors=result;
               
                
            }

		 Test.stopTest();
         system.debug('--> '+access_token);
         system.debug('--> '+errors);
	}
}