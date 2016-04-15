@isTest
global class ServeISMockHttpResponseGen1 implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {      
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"Code":2,"Description":"OK","Status":0,"Items":[{"Adress":"Bangalore,Karnataka","BU":"PACT - CONTROL TECHNOLOGIES","Category":"Controller-CT","Cid":"9AAC166096","City":"Bangalore","CommissioningDate":"-","Country":"INDIA","CountryCode":"IN","Division":"PA - PROCESS AUTOMATION","InstallationId":"9AAK040013S8669","InstallationStatus":"Running","Latitude":"12.973368","Longitude":"77.594792","Manufacturer":null,"ManufacturingDate":"-","ManufacturingOrder":null,"Operator":"1 Involute Automation Pvt Ltd","OperatorGuid":"G07265860","PG":"4414 - CT SERVICE","PgCode":"4414","ProductClassName":"PM864","PurchaseOrderNumber":null,"RN":"1","SerialNumber":"1234","SiteId":"9AAS657351U8990","SiteName":"Test abc","WarrantyEnd":null,"WarrantyStart":null},{"Adress":"Dzielskiego 20","BU":"EPMV - MEDIUM VOLTAGE PRODUCTS","Category":"Secondary Switchgears","Cid":"9AAC30400115","City":"Mumbai","CommissioningDate":"-","Country":"INDIA","CountryCode":"IN","Division":"EP - ELECTRIFICATION PRODUCTS","InstallationId":"9AAK047001V7548","InstallationStatus":"Unknown","Latitude":"19.031751","Longitude":"72.848711","Manufacturer":null,"ManufacturingDate":"-","ManufacturingOrder":null,"Operator":"Aarti Steels Ltd","OperatorGuid":"G01142754","PG":"3442 - MV SERVICE","PgCode":"3442","ProductClassName":"UniSwitch","PurchaseOrderNumber":null,"RN":"2","SerialNumber":"123-4","SiteId":"9AAS330204H9966","SiteName":"XYZ TEST","WarrantyEnd":null,"WarrantyStart":null}],"Total":26}');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}