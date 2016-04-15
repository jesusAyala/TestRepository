/**
*  @Name: CanvasContrller
*  @return - void
*  @Description - This class helps to return the values to canvas application
*  @Author : Rajesh Kaliyaperumal (Accenture)
*/
public with sharing class CanvasController
{
    /**
    *  @Constructor: CanvasContrller
    *  @return - void
    *  @Description - Standard Controller Constructor
    */
    public canvasController(ApexPages.StandardController controller) {

    }
    /**
    *  @Method Name: getcParameters
    *  @return - String
    *  @Description - Build the string parameters which need to send canvas
    */
    public string getcParameters(){        
        string cparam = null;
        String accountID = ApexPages.currentPage().getParameters().get(System.label.ApexPagesAccountID);
        String quotationNumber = ApexPages.currentPage().getParameters().get(System.label.ApexPagesQuotationNumber);
        String opportunityNumber = ApexPages.currentPage().getParameters().get(System.label.ApexPagesOpportunityNumber);
        String sfdcUserId = ApexPages.currentPage().getParameters().get(System.label.ApexPagesSFDCUserId);
        String requestID = ApexPages.currentPage().getParameters().get(System.label.ApexPagesRequestID);
        try{
            if(quotationNumber != null){
                cparam = '{'+
                '\"quotationNumber\": \"'+quotationNumber+'\",'+
                '\"SFDCUserId\": \"'+sfdcUserId+'\",'+ 
                '\"RequestID\": \"'+requestID+'\"'+ 
                '}';
            }else{
                if(opportunityNumber != null){
                    cparam = '{'+
                    '\"accountID\": \"'+accountID+'\",'+
                    '\"opportunityNumber\": \"'+opportunityNumber +'\",'+ 
                    '\"SFDCUserId\": \"'+sfdcUserId+'\",'+ 
                     '\"RequestID\": \"'+requestID+'\"'+ 
                    '}';
                }else{
                    cparam = '{'+
                    '\"accountID\": \"'+accountID+'\",'+
                    '\"SFDCUserId\": \"'+sfdcUserId+'\",'+  
                    '\"RequestID\": \"'+requestID+'\"'+     
                    '}';
                }
            }
        }Catch(Exception ex){return null;}
        return cparam;
    }
}