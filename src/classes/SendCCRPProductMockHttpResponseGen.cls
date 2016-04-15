@isTest
global class SendCCRPProductMockHttpResponseGen implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {      
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"complaintId":416125,"complaintNumber":"PL-S-806417","complaintStatus":"Draft","complaintUrl":"http://xc-s-aiw0124.xc.abb.com:81/en/Complaint/416125","resultType":"SUCCESS","error":null}');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}