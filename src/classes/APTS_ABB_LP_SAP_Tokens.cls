public with sharing class APTS_ABB_LP_SAP_Tokens {
    
    //SAP Request Wrapper MSPARequestWrapper
    public class MSPASAPRequestWrapper {
       
       public SAPRequestAuthHeader globalParams{get; set;}
       
       public AgreementHeader createSalesDealRequest{get; set;}
    }
        
    //cls_globalParams 
    public class SAPRequestAuthHeader {
        
        public String BauCode{get; set;}
        
        public string Currency1{get; set;}//it should be currency but we cannot make a variable name as currency so we keep this as currency1 and later on we will replace it with keyword "currency"
        
        public String CustomerCode{get; set;} 
        
        public string AuthToken{get; set;}
    }
    
    //cls_createSalesDealRequest    
    public class AgreementHeader {

        public String Action{get; set;}//For blocking Action="B", for insert, "I", for read "R", for update "U"
        
        public String Block{get; set;}//block=true for blocking else it will be false  
        
        public String CustomerGroup{get; set;}//local channel
        
        public String DealCode{get; set;}
        
        public String DealType{get; set;}//MSPA type
        
        public String DealValue{get; set;}//total agreement value
         
        public String MaxOrdVal{get; set;}//maximum order value 
         
        public String MinOrdVal{get; set;}//minimum order value 
        
        public String ResidualAmount{get; set;}//residual amount is not needed for spain
        
        public String SalesMan{get; set;}
        
        public String SalesOffice{get; set;}
        
        public String SalesOrganization{get; set;}
        
        public String DistributionChannel{get; set;}
        
        public string ValidFrom{get; set;}//start date of MSPA  
        
        public string ValidTo{get; set;} //End date of MSPA
        
        public AgreementLineItems[] SalesDealItems{get; set;}
    }
    
    //cls_SalesDealItems
    public class AgreementLineItems {
        
        public String ConditionPricingUnit{get; set;}
        
        public String DealCalculationType{get; set;}
        
        public String DealCode{get; set;}
        
        public String DealCurrency{get; set;}
        
        public String DealType{get; set;}
        
        public String DealValue{get; set;}
        
        public String ItemNumber{get; set;}
        
        public String MaxOrdQty{get; set;}
        
        public String MaxOrdVal{get; set;}
        
        public String Maxconval{get; set;}
        
        public String MinOrdQty{get; set;}
        
        public String MinOrdVal{get; set;}
        
        public String OrderQty{get; set;}
        
        public String OrderVal{get; set;}
        
        public String PricingUnit{get; set;}
        
        public String ProductHierarchy{get; set;}
        
        public String SalesOrganization{get; set;}
        
        public String ScaleQuantity{get; set;}
        
        public String DistributionChannel{get; set;}
        
        public String ProductCode{get; set;}
    }
    
    //APIResponseBody 
    public class MSPASAPResponseWrapper {
        
        public IntegrationError[] Errors{get; set;}
        
        public AgreementLineItems[] SalesDealItems{get; set;}
    }

    //cls_Errors 
    public class IntegrationError {
        
        public String Code{get; set;}
    }
    
    public class oAuthIntegrationToken {
        
        public string access_token{get; set;}
        public string token_type{get; set;}
        public integer expires_in{get; set;}
        public string refresh_token{get; set;}
    } 
}