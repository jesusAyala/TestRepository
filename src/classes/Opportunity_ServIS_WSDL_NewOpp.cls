/*  Description of the method. 
    *  @name Opportunity_ServIS_WSDL_NewOpp
    *  @Author  Jesus
    *  @Description - Create new Opportunity from ServIS.
    *  @return String
    */
global without sharing class Opportunity_ServIS_WSDL_NewOpp {
    /*  Description of the method. 
    *  @name Result
    *  @Description - Webservice variables declaration.
    *  @return String
    */
    global without sharing class Result{
        WebService String oppID;
        WebService String error;
    }
    /*  Description of the method. 
    *  @name createOpp
    *  @Description - Create new Opportunity from ServIS.
    *  @return String
    */
    webservice static Result createOpp(String opportunityName, Date oppDueDate, String customerGUID, String endUserGUID, String ownerEmail,
                                        String industryUsage1,String industryUsage2, String industryUsage3, String currencycode, Boolean quotationNeeded) {
        Result res = new Result(); 
        Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
        //String erroMessage='';
        res.error = System.label.INTEG_SYS_ServIS_CreateOpp_Error1; //Label: 'Something went wrong, please try'

        res.error ='Name field too long, max length = 120';
        if(opportunityName.length()>119){
            return res;
        }

        try{
            List<Account> lstCustomerAcc = [SELECT id, GUID__c,Primary_Account_Manager__c 
                                            from Account where GUID__c =: customerGUID LIMIT 1];
            List<Account> lstEnduserAcc = new List<Account>();
             
            String testString = endUserGUID;
            if(!String.isBlank(testString )){
                lstEnduserAcc = [SELECT id, GUID__c from Account where GUID__c =: endUserGUID LIMIT 1];
            }
            
            List<User> lstUser = [SELECT id, email from User where email =:ownerEmail LIMIT :remLimit];
            List<PriceBook2> priceBookList = [SELECT Id FROM PriceBook2 WHERE IsStandard= true AND isActive=true LIMIT 1];
           // System.debug('message'+ lstCustomerAcc +lstUser );
            if(lstCustomerAcc.size()>0 && lstUser.size()>0){
                //System.debug('message2'+ lstCustomerAcc +lstUser );
                Opportunity opp = new Opportunity();
                opp.Name = opportunityName;
                opp.AccountID = lstCustomerAcc[0].id;
                if(lstEnduserAcc.size()>0){
                    opp.Account_End_User__c = lstEnduserAcc[0].id;
                }
                if(lstCustomerAcc[0].Primary_Account_Manager__c != null)                {
                    opp.Account_Customer_Key_Account_Manager__c = lstCustomerAcc[0].Primary_Account_Manager__c;
                }
                //opp.Creator_Email__c = creatorEmail;
                opp.CloseDate = oppDueDate;
                opp.Ownerid = lstUser[0].id;
                opp.StageName = System.label.INTEG_SYS_ServIS_CreateOpp_StageName; //'Prospecting';
                opp.ABB_Industry_Usage_Level1__c = industryUsage1;
                opp.ABB_Industry_Usage_Level2__c = industryUsage2;
                opp.ABB_Industry_Usage_Level3__c = industryUsage3;
                opp.Owner_s_Email__c = ownerEmail;
                opp.Pricebook2Id=priceBookList[0].id;
                opp.CurrencyIsocode = currencycode; 
                opp.Quotation_Needed__c = quotationNeeded;
                opp.ServIS_Initiated__c = true;
                database.insert(opp, false);
                res.oppID = String.valueof(opp.id);
                res.error = System.label.INTEG_SYS_ServIS_CreateOpp_Error2; //Label: 'No error';
                return res;
            }else{
                res.error = System.label.INTEG_SYS_ServIS_CreateOpp_Error3; //'No valid customer or no valid SFDC user found. Please check the GUID or owner email sent';
                return res;
            }
        }catch(ClsTriggerException cte){
           // System.debug('Message: ' + cte.getMessage());
            res.error = System.label.INTEG_SYS_ServIS_CreateOpp_Error4 + cte.getMessage();
            return res;
        }
        return res;
    }   
}