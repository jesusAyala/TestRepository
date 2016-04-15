@isTest
global class APTPS_CalloutMockTest implements HttpCalloutMock{
  global HttpResponse respond(HTTPRequest req){
    HttpResponse res = new HttpResponse();
    res.setStatus('OK');
    res.setStatusCode(200);
    APTS_MSPACreatorInSAPController.MSPARequestWrapper reqBody = new APTS_MSPACreatorInSAPController.MSPARequestWrapper();
    string Jsonbody=JSON.serialize(reqBody);
    res.setBody(Jsonbody);
    return res;
  }
    
    global HttpResponse respond2(HTTPRequest req){
    HttpResponse res = new HttpResponse();
    res.setStatus('No Response');
    res.setStatusCode(204);
    APTS_MSPACreatorInSAPController.MSPARequestWrapper reqBody = new APTS_MSPACreatorInSAPController.MSPARequestWrapper();
    string Jsonbody=JSON.serialize(reqBody);
    res.setBody(Jsonbody);
    return res;
  }
}