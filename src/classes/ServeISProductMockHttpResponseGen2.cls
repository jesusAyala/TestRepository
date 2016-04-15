@isTest
global class ServeISProductMockHttpResponseGen2 implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {      
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"Code":2,"Description":"OK","Status":0,"Items":[{"Adress":"Noordzeedijk 105","BU":"PACT - CONTROL TECHNOLOGIES","Category":"Communication-CT","Cid":"9AAC207323","City":"Dinteloord","CommissioningDate":"-","Country":"NETHERLANDS","CountryCode":"NL","Division":"PA - PROCESS AUTOMATION","InstallationId":"9AAK266280H2699","InstallationStatus":"Running","Latitude":"51.61679130","Longitude":"4.4316076000000070","Manufacturer":"9AAE202848 - ABB AB, Malmo, SE","ManufacturingDate":"-","ManufacturingOrder":null,"Operator":"SUIKER UNIE BEHEER B.V.","OperatorGuid":"G01334628","PG":"4414 - CT SERVICE","PgCode":"4414","ProductClassName":"200-CIPBDP","PurchaseOrderNumber":null,"RN":"1","SerialNumber":"2221","SiteId":"9AAS193546U6076","SiteName":"Suikerunie","WarrantyEnd":null,"WarrantyStart":null}],"Total":1}');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}