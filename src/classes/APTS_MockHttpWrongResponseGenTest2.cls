@isTest
global class APTS_MockHttpWrongResponseGenTest2 implements HttpCalloutMock {
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
        
        throw new applicationException(' request string not valid');
    }
    
    class applicationException extends Exception {}
}