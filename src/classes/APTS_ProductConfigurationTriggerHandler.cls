/*************************************************************
@Name: APTS_ProductConfigurationTriggerHandler
@Author: Hardik Shah
@CreateDate: 02/09/2015
@Description: This class is called on BeforeUpdate event. This class finds the maximum discount of LineItems in a ProductConfiguration
@UsedBy: Trigger APTS_ProductConfigurationTrigger
******************************************************************
@ModifiedBy: Nishi Kushwaha
@ModifiedDate: 02/09/2015
@ChangeDescription: Creaed a method "OnBeforeUpdate()" which calls API to finalize cart when Finalize Cart Checkbox = True
******************************************************************/

public with sharing class APTS_ProductConfigurationTriggerHandler {
    
   
  
    public void OnBeforeUpdate(Map < Id, Apttus_Config2__ProductConfiguration__c > mapProductConfiguration, Map < Id, Apttus_Config2__ProductConfiguration__c > mapOldProductConfiguration) {
          
          //assign proper line number for each line item
          APTS_ProductConfigurationTriggerHelper.populateLineNumber(mapProductConfiguration.values());
       
        // update the agreement with GTV Value of LineItem that has maximum discount
        // Added by Hardik Shah 
        try {
            APTS_ProductConfigurationTriggerHelper.getMaxLineItemDiscount(mapProductConfiguration, mapOldProductConfiguration);
        } catch (Exception ex) {
            // TODO - Need to have a Exception framework
            system.debug('Exception in BeforeUpdate of ProductConfiguration trigger' + ex.getMessage());
        }
          
     }
}