public class APTS_OpptyQuoteCreateRedirectController {

    //Constructor
    public APTS_OpptyQuoteCreateRedirectController(ApexPages.StandardController controller){
        
    }
    
    public Pagereference redirectToQuoteCreatePage(){
        Pagereference pgRef = new Pagereference('/apex/Apttus_QPConfig__OpptyQuoteCreate?id=006g000000AJ6gX&recordTypeName=LP&priceListId=a2jg0000000Gz0vAAC&retUrl=/006g000000AJ6gX&is_placeholder_quote=true&flow=LP_Spain');
        return pgRef;
    } 
}