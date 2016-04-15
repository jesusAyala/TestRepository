public class APTS_DMHelperUtility {

 public String errorDescriptionStr {get;set;}
 
 public APTS_DMHelperUtility () {
 errorDescriptionStr = '';
 }
 
 public void appendErrorMessage(String errorMessageStr)
 {
    errorDescriptionStr = errorDescriptionStr + errorMessageStr + '\n';
 }
 
 public void updateValidationStatus(SObject sObjParam, Boolean hasValidationErrors)
 {
   
   if(hasValidationErrors)
   {
     sObjParam.put('APTS_Error_Description__c',this.errorDescriptionStr );
     sObjParam.put('APTS_RowStatus__c',APTS_DMConstants.ERROR_STATUS );
   }
   else
   {
   
    sObjParam.put('APTS_Error_Description__c','' );
     sObjParam.put('APTS_RowStatus__c',APTS_DMConstants.VALIDATION_STATUS );
     
   
   }
   
 }
  
}