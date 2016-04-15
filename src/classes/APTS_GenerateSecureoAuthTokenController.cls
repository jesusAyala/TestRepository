/*************************************************************
@Name: APTS_GenerateSecureoAuthTokenController
@Author: Ganga Vemula
@CreateDate: 10th sep 2015.
@Description: This class is to send an autherization request to SAP to get response.
@UsedBy: SAP Pricing and MSPA creation
******************************************************************/

public class APTS_GenerateSecureoAuthTokenController{
    
    private static string ERROR_EXIST='SERVER_ERROR_EXIST';
    
    public static String GetSecureOauthTokenAzure(string baseaddress){
        
        //read static values from custom settings
        APTS_SAP_Integration_Tokens__c SAPoAuthDataset= APTS_SAP_Integration_Tokens__c.getValues('SAP oAuth Tokens');
        
        //get erp gateway key from custom setting
        String authToken= SAPoAuthDataset.APTS_oAuth_Token__c;
        //get key name
        string keyname=SAPoAuthDataset.APTS_Key_Name__c;
        //get password
        string password=SAPoAuthDataset.APTS_Key__c;
        //get base address
        string authenticationaddress=SAPoAuthDataset.APTS_Base_Address__c;
        //get end point
        string endpoint=SAPoAuthDataset.APTS_End_Point__c;
        //get http header key value
        string headerkey=SAPoAuthDataset.APTS_Http_Header_Key__c;
        
        //generate oAuth token here
        String Token = EncodingUtil.base64Encode(Blob.valueof(authToken));
        string oAuthToken='Basic '+Token;
        
        
        HttpRequest req1 = new HttpRequest();
        HttpResponse res1 = new HttpResponse();
        Http http1 = new Http();
        
        req1.setEndpoint(endpoint);
        req1.setMethod('POST');
        //pass authentication token to SAP
        req1.setHeader(headerkey,oAuthToken);
        req1.setHeader('Content-Type', 'application/json');
        //set the body with required parameters
        req1.setBody('{"scope":"'+authenticationaddress+'","grant_type":"password","username":"'+keyname+'","password":"'+password+'"}');
        
        req1.setTimeout(120000);
        string errormsg;
        
        try{
            
            res1 = http1.send(req1);
            system.debug('****responsebody azure'+res1.getbody()+':::'+req1.getbody());
            
            //check if authentication is success and deserialize the jason body to get access token
            if(res1.getStatusCode() >= 200 && res1.getStatusCode() < 300){
                
                //deserialize json body to get access token
                JsonobjRes  jsonvalues = (JsonobjRes)JSON.deserialize(res1.getbody(), JsonobjRes.class);
                string access_token='OAuthJwt '+jsonvalues.access_token;
                
                return access_token;
                
            }else {//if authentication failed, return error message to APTS_SAPPricingIntegrationController
                
                /*errormsg='HTTP callout failed:test'
                    + '\nstatusCode=' + res1.getStatusCode()
                    + '\nstatus=' + res1.getStatus() + ERROR_EXIST;*/
                
                if(res1.getStatusCode() == 401 || res1.getStatusCode() == 500 || res1.getStatusCode() == 404){
                    
                    errormsg=Label.APTS_Gateway_Error+ERROR_EXIST;
                    return errormsg;
                    //'An error has been encountered while authenticating with the Gateway. Please contact your Salesforce administrator.'+ERROR_EXIST;
                }
                
                //return errormsg;                          
                
            }   
            
        }catch(System.CalloutException ex) {
            System.debug('#### Callout error: '+ ex.getMessage());
            errormsg = ex.getMessage();
            return errormsg;
        }catch (Exception ex) {
            System.debug('#### General Callout error: '+ ex.getMessage());
            errormsg = ex.getMessage();
            return errormsg;
        }   
        
        return null;
        
    }
    
    //Inner class to deserialize the response from SAP
    public class JsonobjRes
    {
        public string access_token { get; set; }
        public string token_type { get; set; }
        public integer expires_in { get; set; }
        public string refresh_token { get; set; }
    }  
    
    
}