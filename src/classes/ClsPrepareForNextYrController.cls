/**
 * ApexClass -  ClsPrepareForNextYrController (Controller for the VF Page-PrepareForNextYrPage)
 * Release R5
 * @author  Vasanthi (Accenture)
 * @created 2016-2-17
 * @version 1.0
 * Created
 
  */
  public class ClsPrepareForNextYrController { 
  
    Id jbpProductId;
    public Boolean isAnyError {get;set;}
/**
 * Constructor
*/     
    public ClsPrepareForNextYrController(ApexPages.StandardController ctrl) {
        
        Joint_Business_Plan_Product_Lines__c jobProduct = (Joint_Business_Plan_Product_Lines__c) ctrl.getRecord();
        jbpProductId = jobProduct.Id;
        isAnyError = FALSE;        
    }
/**
 * cloneRecord
 * When the user clicks on the button this will create a new record and adjust the financials accordingly.
*/    
    public PageReference cloneRecord() {
        
        
        Map<string, Schema.SObjectField> jobProductFieldsMap = Schema.SObjectType.Joint_Business_Plan_Product_Lines__c.fields.getMap();
        String fields = '';
        for (Schema.SObjectField fld : jobProductFieldsMap .values()) {
            fields += String.valueOf(fld.getDescribe().getName())+',';
        }
        fields = fields.substring(0, fields .lastIndexOf(','));
        String query = 'SELECT '+fields +' FROM Joint_Business_Plan_Product_Lines__c WHERE Id= \''+jbpProductId+'\'';
            
        Joint_Business_Plan_Product_Lines__c[] recList = Database.Query(query);
        
        if (reclist.size() > 0) {
            Joint_Business_Plan_Product_Lines__c clonedJobProduct = recList[0].clone(false, true);
            clonedJobProduct.Starting_Year__c = (recList[0].Starting_Year__c != NULL) ? String.ValueOf(Integer.valueOf(recList[0].Starting_Year__c) + 1) : NULL;
            clonedJobProduct.Current_Year_Currency__c = recList[0].Second_Year_Currency__c;
            clonedJobProduct.Second_Year_Currency__c = recList[0].Third_Year_Currency__c;
            clonedJobProduct.Previous_Year_Currency__c = recList[0].Current_Ongoing_Year__c ; 
            clonedJobProduct.Third_Year_Currency__c = NULL;
            clonedJobProduct.Current_Ongoing_Year__c = NULL;
            clonedJobProduct.Forecast_Ongoing_Year__c = NULL;
            clonedJobProduct.Third_Year_Currency__c = NULL;
            clonedJobProduct.Starting_Year_Product__c = NULL;
            clonedJobProduct.Actual_Year_to_Date_Changed_on__c = NULL;
            try {
                Insert clonedJobProduct;
                return new PageReference('/'+clonedJobProduct.Id);
            } Catch(DMLEXception e) {
                
                String err = '';
                for (Integer i = 0; i < e.getNumDML(); i++) {
                    err += e.getDMLMessage(i) + '<br/>';
                }
                isAnyError = TRUE;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, err));
                return NULL;
            }
        }
        return null;
    }
/**
* returns to the previous page
*/    
    public PageReference back() {        
        PageReference pageref = (jbpProductId != NULL) ? new PageReference('/'+jbpProductId) : NULL;
        return pageref;
    }
  
}