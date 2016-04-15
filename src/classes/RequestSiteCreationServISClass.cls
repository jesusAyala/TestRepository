/**
@Author Rajesh K
@name RequestSiteCreationServISClass
@CreateDate 17-Feb-2015
@Version 1.0
**/
global without sharing class RequestSiteCreationServISClass
{
    /*  Description of the method. 
    *  @name requestSiteCreate
    *  @Description - Request site creation in ServIS from SFDC.
    *  @return String
    */
    webservice static String requestSiteCreate(Id caseid) 
    { 
        Case objcase = [Select id, City__c, Site_Address__c, Site_Country__c, Site_Geo_Location__Latitude__s, Site_Geo_Location__Longitude__s, Serial_Number__c, Product_category_ServIS__c, Product.CID__c, Site_Id__c, Site_Name__c, Customer_Reference__c from Case where id =: caseid LIMIT 1];
        if(objcase.Product_category_ServIS__c !=NULL){
            HttpRequest req = new HttpRequest();
            req.setEndpoint(System.label.INTEG_SYS_ReqSiteCreation_Endpoint);   //'https://www1008.abb.com/stage/servisws/mcp/ProductRegistration.svc/RegisterAsUnathorized'
            req.setMethod(System.label.INTEG_SYS_ReqSiteCreation_Method);    //'POST'
            String autorithationServIS = System.label.SYS_ServIS_Autorithation;
            //req.setHeader('Authorization', 'Basic ZmFjZTpXZWIkZXJ2I2ZhY2U0');
            req.setHeader('Authorization', autorithationServIS );
            //String strbody = 'email='+ UserInfo.getUserEmail() +'&serialNumber='+objcase.Serial_Number__c+'&category='+objcase.Product_category_ServIS__c;
            User u = [select firstname, FederationIdentifier  from user where id=:userinfo.getuserid() LIMIT 1];
            String strbody = System.label.INTEG_SYS_ReqSiteCreation_Body1 + u.FederationIdentifier  + System.label.INTEG_SYS_ReqSiteCreation_Body2 + objcase.Serial_Number__c + System.label.INTEG_SYS_ReqSiteCreation_Body3 + objcase.Product_category_ServIS__c;    //INTEG_SYS_ReqSiteCreation_Body1 => 'email=' => '&serialNumber=' => '&category='
            strbody = strbody + System.label.INTEG_SYS_ReqSiteCreation_Body4 + objcase.Product.CID__c;      // =>'&cid='
            strbody = strbody + System.label.INTEG_SYS_ReqSiteCreation_Body5 + objcase.City__c + System.label.INTEG_SYS_ReqSiteCreation_Body6;  //>'&siteComment=&siteCity=' >'&siteZipCode='
            strbody = strbody + System.label.INTEG_SYS_ReqSiteCreation_Body9 + objcase.Site_Address__c + System.label.INTEG_SYS_ReqSiteCreation_Body10 + objcase.Site_Country__c;    //>>>'&siteRegion=&siteAddress='  >>'&siteCountry='
            strbody = strbody + System.label.INTEG_SYS_ReqSiteCreation_Body11+ objcase.Site_Name__c + System.label.INTEG_SYS_ReqSiteCreation_Body12;    //>>'&siteName='    >>'&siteType=&format=JSON&lang=EN'
            req.setBody(strbody);  
            Http http = new Http();
            HTTPResponse res = http.send(req);
            Map<String, object> m = (Map<String, object>)JSON.deserializeUntyped(res.getBody());
            String status = res.getStatus();
            String result = String.valueof(m.get(System.label.INTEG_SYS_ReqSiteCreation_Description));    //'Description'
            if(result != System.label.INTEG_SYS_ReqSiteCreation_OK){                //'OK'
                return result;    //'ServIS response: '
            }else{      
                Case updcase = new Case(id = caseid,Is_Request_site__c = true);
                Database.update(updcase, false);
                return System.label.INTEG_SYS_ReqSiteCreation_Return2;    //'Request Site Creation to ServIS has been completed.';   
            }
        return res.getStatus();
        }else{
            return System.label.INTEG_SYS_ReqSiteCreation_Return3;  //'Product Category ServIS is required, please provide it';
        }
        
    }    
}