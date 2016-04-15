@isTest
global class APTS_MockHttpWrongResponseGenTest implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        
        req.setEndpoint('https://abberpgatewaydev.servicebus.windows.net/api/products/quotationpricelistsearch');        
        string ReqStr = '{"productListRequest":{"Products":[{"Quantity":1.00,"Code":"FPTN472625R0001"}]},"globalParams":{"ErpResponseCulture":"es-ES","CustomerCode":"0080003494","BauCode":"ES1","AuthToken":"OAuthJwt eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ33leHAiOjE0NDMwNDg0ODUsImlzcyI6Imh0dHBzOi8vYXBwbGljYXRpb25zLml0LmFiYi5jb20vQUJCQWNjb3VudHNUZXN0IiwiYXVkIjoiaHR0cHM6Ly9hYmJlcnBnYXRld2F5ZGV2LnNlcnZpY2VidXMud2luZG93cy5uZXQvIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZSI6IkZhY2VFcnBHYXRld2F5X1NlcnZpY2VCdXMiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL2F1dGhlbnRpY2F0aW9ubWV0aG9kIjoiT0F1dGgyIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9hdXRoZW50aWNhdGlvbmluc3RhbnQiOiIyMDE1LTA5LTIzVDEyOjQ4OjA0Ljc5NVoiLCJodHRwOi8vaXQuYWJiLmNvbS9jbGFpbXMvY2xpZW50IjoiRXJwR2F0ZXdheSIsImh0dHA6Ly9pdC5hYmIuY29tL2NsYWltcy9zY29wZSI6Imh0dHBzOi8vYWJiZXJwZ2F0ZXdheWRldi5zZXJ2aWNlYnVzLndpbmRvd3MubmV0LyJ9.U1YA_d7O0bovOnVzgSkdRYtK90jFwVRejFycu2TPRfc"}}';
        system.debug('KS--> Request String' + ReqStr);
        System.assertEquals('https://abberpgatewaydev.servicebus.windows.net/api/products/quotationpricelistsearch', req.getEndpoint());
        req.setBody(ReqStr);
        req.setHeader('X-HTTP-Method','POST');
        req.setHeader('Content-Type', 'application/json');
        System.assertEquals('POST', req.getMethod());
        system.assertEquals(ReqStr, req.getBody());        
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        APTS_SAPPricingIntegrationController.APIRequestWrapper globalPar = new APTS_SAPPricingIntegrationController.APIRequestWrapper();
        string Jsonbody=JSON.serialize(globalPar);
        res.setBody('{"Errors":1,"Incomplete":[{"FieldName":"ABRVW","FieldText":"Energy Efficiency","ItemNumber":null,"TableName":"VBAK"}],"Messages":"Web page not available","Products":[{"ABBCode":null,"Code":"1SAJ230000R1005","Currency":"EUR","CurrencyPurchaseOrder":null,"CustomerCode":null,"DeliveryTime":0,"Description":"DNP21-FBP.050","DummyFunction":null,"EANCode":null,"Hierarchy":null,"HierarchyString":null,"ItemNumber":null,"MinQuantity":0,"OldCode":null,"PKWiUCode":null,"Parent":null,"Percentage1":0,"Percentage10":0,"Percentage2":0,"Percentage3":0,"Percentage4":0,"Percentage5":0,"Percentage6":0,"Percentage7":0,"Percentage8":0,"Percentage9":0,"Price":195.09,"Price1":0,"Price10":0,"Price2":0,"Price3":0,"Price4":0,"Price5":0,"Price6":0,"Price7":0,"Price8":0,"Price9":0,"PriceListCode":null,"PricePurchaseOrder":0,"PriceUnit":null,"PricingUnit":1,"PricingUom":"UN","Quantity":1.000,"QuotationCondition":null,"QuotationConditionFilteredList":[],"QuotationConditionList":[{"CalculationType":"C","ConBaseVal":1.000000000,"Counter":1,"Currency":"EUR","PUnit":1,"StepNumber":10,"Type":"ZPTA","Unit":"ST","Value":349.000000000},{"CalculationType":"A","ConBaseVal":349.000000000,"Counter":1,"Currency":null,"PUnit":0,"StepNumber":20,"Type":"ZDT1","Unit":null,"Value":-44.100000000},{"CalculationType":"B","ConBaseVal":19.509000000,"Counter":1,"Currency":"EUR","PUnit":0,"StepNumber":868,"Type":"ZAWR","Unit":null,"Value":0},{"CalculationType":"A","ConBaseVal":195.090000000,"Counter":1,"Currency":null,"PUnit":0,"StepNumber":870,"Type":"ZIVA","Unit":null,"Value":21.000000000},{"CalculationType":"C","ConBaseVal":1.000000000,"Counter":1,"Currency":"EUR","PUnit":1,"StepNumber":905,"Type":"ZCOM","Unit":"ST","Value":98.020000000},{"CalculationType":"C","ConBaseVal":1.000000000,"Counter":1,"Currency":"EUR","PUnit":1,"StepNumber":970,"Type":"EK01","Unit":"ST","Value":0},{"CalculationType":"C","ConBaseVal":1.000000000,"Counter":1,"Currency":"EUR","PUnit":1,"StepNumber":975,"Type":"EK02","Unit":"ST","Value":0}],"Reserve1":null,"Reserve10":null,"Reserve2":null,"Reserve3":null,"Reserve4":null,"Reserve5":null,"Reserve6":null,"Reserve7":null,"Reserve8":null,"Reserve9":null,"SalesUnit":null,"SpaNumber":null,"Stock":null,"UnitOfMeasure":null,"UnitTransferPrice":0,"Variants":null}],"SpaNumber":null}');
        res.setStatusCode(404);
        return res;
    }
}