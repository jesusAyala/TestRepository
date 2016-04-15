/*************************************************************
@Name: APTS_LP_AgreementLineItemController
@Author: Hardik Shah
@CreateDate: 23/08/2015
@Description: This class fetches agreement and agreement-line Item
@UsedBy: Visual Force component APTS_LP_AgreementLine
******************************************************************
@ModifiedBy: NA
@ModifiedDate: NA
@ChangeDescription: A brief description of what was modified.
**** PS: @ModifiedBy and @ChangeDescription can be repeated multiple time, based on number of changes made to the original process.
******************************************************************/

public class APTS_LP_AgreementLineItemController {

     // Id of an Agreement
     public Id agreementId{get; set;} 
     // List of AgreementLineItem
      List <Apttus__AgreementLineItem__c> listAgreementLineItem {get; set;} 
     // List of Apttus Agreement
      List<Apttus__APTS_Agreement__c> listAgreement { get;set;}
     // boolean variable to check whether agreement has lineItem
      boolean bhasLineItem { get;set;}
    
    public boolean gethasLine(){
     
        try{
            this.listAgreementLineItem = APTS_LP_QueryUtility.getAgreementLineItemList(agreementId);
           
             if(listAgreementLineItem != null && listAgreementLineItem.size() > = 1){
                 this.bhasLineItem = true;
              
            }
            return this.bhasLineItem;
        }
        catch(Exception e){
            System.debug('Error:\t'+e.getMessage());
        }
        return null;
    }
     
     // Constructor to initialize controller and variables
     public APTS_LP_AgreementLineItemController() {
              bhasLineItem = false;
       
     }
   
    // fetches an agreement for a given agreement-id
    public List<Apttus__APTS_Agreement__c> getAgreements() {
       
        try{
            this.listAgreement = APTS_LP_QueryUtility.getAgreement(agreementId);
            if(listAgreement != null && listAgreement.size() > = 1){
                return this.listAgreement;
            }else{
                return null;
            }
        }
        catch(Exception e){
            System.debug('Error:\t'+e.getMessage());
        }
        return null;
     }
    
   
     // Method to Fetch All AgreementLineItem for Given Agreement-Id 
     public List<Apttus__AgreementLineItem__c> getAgreementLineItems(){
        return this.listAgreementLineItem;
     }
       
}