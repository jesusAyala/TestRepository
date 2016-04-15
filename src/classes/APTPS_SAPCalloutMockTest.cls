@isTest
global class APTPS_SAPCalloutMockTest implements HttpCalloutMock {
    
    String param;
    global APTPS_SAPCalloutMockTest(){
        this.param = '';
    }
    
    global APTPS_SAPCalloutMockTest(String param){
        this.param = param;
    }
    
    global HTTPResponse respond(HTTPRequest req) {
            
        HttpResponse res = new HttpResponse();
        res.setStatus('OK');
        res.setStatusCode(200);
        
        if(req.getEndpoint().equals('https://applications.it.abb.com/abbaccountstest/issue/oauth2/token')){
            
            APTS_ABB_LP_SAP_Tokens.oAuthIntegrationToken reqBody = new APTS_ABB_LP_SAP_Tokens.oAuthIntegrationToken();
            reqBody.access_token = 'OAuthJwt eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0NTYyNTQ5NjMsImlzcyI6Imh0dHBzOi8vYXBwbGljYXRpb25zLml0LmFiYi5jb20vQUJCQWNjb3VudHNUZXN0IiwiYXVkIjoiaHR0cHM6Ly9hYmJlcnBnYXRld2F5LnNlcnZpY2VidXMud2luZG93cy5uZXQvIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZSI6IkZhY2VFcnBHYXRld2F5X1NlcnZpY2VCdXMiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL2F1dGhlbnRpY2F0aW9ubWV0aG9kIjoiT0F1dGgyIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9hdXRoZW50aWNhdGlvbmluc3RhbnQiOiIyMDE2LTAyLTIzVDA5OjE2OjAzLjI4NFoiLCJodHRwOi8vaXQuYWJiLmNvbS9jbGFpbXMvY2xpZW50IjoiRXJwR2F0ZXdheSIsImh0dHA6Ly9pdC5hYmIuY29tL2NsYWltcy9zY29wZSI6Imh0dHBzOi8vYWJiZXJwZ2F0ZXdheS5zZXJ2aWNlYnVzLndpbmRvd3MubmV0LyJ9.2YVfuDAZp5kC2m-0ULhqaxMWAyfYSassQd99uBhpo6M';
            string Jsonbody = JSON.serialize(reqBody);
            res.setBody(Jsonbody);
        }
        
        else if(req.getEndpoint().equals('https://abberpgatewaydev.servicebus.windows.net/api/orders/createsalesdeal')){
            APTS_ABB_LP_SAP_Tokens.MSPASAPResponseWrapper reqBody = new APTS_ABB_LP_SAP_Tokens.MSPASAPResponseWrapper();
            string Jsonbody = JSON.serialize(reqBody);
            res.setBody(Jsonbody);
        }
        
        else if(req.getEndpoint().equals('https://abberpgatewaydev.servicebus.windows.net/api/orders/createsalesdeal') && param.equals('502')){
            APTS_ABB_LP_SAP_Tokens.IntegrationError err = new APTS_ABB_LP_SAP_Tokens.IntegrationError();
            err.Code = '502';
            
            APTS_ABB_LP_SAP_Tokens.MSPASAPResponseWrapper reqBody = new APTS_ABB_LP_SAP_Tokens.MSPASAPResponseWrapper();
            reqBody.Errors = new List<APTS_ABB_LP_SAP_Tokens.IntegrationError>{err};
            string Jsonbody = JSON.serialize(reqBody);
            res.setBody(Jsonbody);
        }
        
        else{
            APTS_ABB_LP_SAP_Tokens.MSPASAPResponseWrapper reqBody = new APTS_ABB_LP_SAP_Tokens.MSPASAPResponseWrapper();
            string Jsonbody = JSON.serialize(reqBody);
            res.setBody(Jsonbody);
        }
        
        return res;
        
    }

}