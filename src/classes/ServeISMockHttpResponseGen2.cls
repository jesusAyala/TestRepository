@isTest
global class ServeISMockHttpResponseGen2 implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {      
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"Code":2,"Description":"OK","Status":0,"Items":[{"Adress":"Bangalore,Karnataka","BU":"PACT - CONTROL TECHNOLOGIES","Category":"Controller-CT","Cid":"9AAC166096","City":"Bangalore","CommissioningDate":"-","Country":"INDIA","CountryCode":"IN","Division":"PA - PROCESS AUTOMATION","InstallationId":"9AAK040013S8669","InstallationStatus":"Running","Latitude":"12.973368","Longitude":"77.594792","Manufacturer":null,"ManufacturingDate":"-","ManufacturingOrder":null,"Operator":"1 Involute Automation Pvt Ltd","OperatorGuid":"G07265860","PG":"4414 - CT SERVICE","PgCode":"4414","ProductClassName":"PM864","PurchaseOrderNumber":null,"RN":"1","SerialNumber":"1234","SiteId":"9AAS657351U8990","SiteName":"Test abc","WarrantyEnd":null,"WarrantyStart":null}],"Total":26}');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}