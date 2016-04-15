/**
*  @Name: ClsTriggerERPDupeHandler
*  @Release - R3 CR
*  @Description - This class helps to allow the duplicate on ERP Picklist data
*  @Author : Mohan Raj (Accenture)
*/
public without sharing class ClsTriggerERPDupeHandler extends ClsTriggerVirtual  {
    
     /**
         * @see IntHelper.beforeTrigger
    */
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
        CheckErpDescriptionDupeallow(trgCtx);    
    }
    
    /**
    *  Method - CheckLsoDescriptionDupeallow
    *  Description - Check the Description of ERP Mapping  
    */            
    @TestVisible 
    private void CheckErpDescriptionDupeallow(ClsWrappers.TriggerContext trgCtx) {        
        
        Set<String> erps = new Set<String>();    
        
        if ( (trgCtx.isBefore && trgCtx.isInsert) || (trgCtx.isBefore && trgCtx.isUpdate) )
        {               
            for (sobject so : trgCtx.newList) {
                LSO_Field_Entries__c erp = (LSO_Field_Entries__c)so;           
                if( (erp.LSO_Pick_List_Value_Name__c != null) && (erp.PickList_Code__c != null)&& (erp.Country__c != null) && (erp.PickList_Description__c != null))
                {
                    erps.add(erp.LSO_Pick_List_Value_Name__c+erp.PickList_Code__c+erp.Country__c);
                }
            }            
        }                
        
        Map<id,LSO_Field_Entries__c> mapErpMapping = new Map<Id,LSO_Field_Entries__c>([select Id, ERP_Description_Dupe__c, LSO_Pick_List_Value_Name__c,PickList_Code__c, Country__c,PickList_Description__c from LSO_Field_Entries__c where ERP_Description_Dupe__c in :erps LIMIT 50000]);
        
        if ( (trgCtx.isBefore && trgCtx.isInsert) || (trgCtx.isBefore && trgCtx.isUpdate) )
        {               
            for (sobject so : trgCtx.newList) {
                LSO_Field_Entries__c erp = (LSO_Field_Entries__c)so;           
                if( (erp.LSO_Pick_List_Value_Name__c != null) && (erp.PickList_Code__c != null)&& (erp.Country__c != null) && (erp.PickList_Description__c != null))
                {
                    for( LSO_Field_Entries__c erpmap : mapErpMapping.values()) 
                    {
                        if((erp.LSO_Pick_List_Value_Name__c+erp.PickList_Code__c+erp.Country__c == erpmap.ERP_Description_Dupe__c) && (erp.PickList_Description__c != erpmap.PickList_Description__c ) )
                        {                     
                            so.addError(System.Label.System_ERP_Picklist_Err);
                        }                    
                    }                    
                }                
            }            
        }                   
    }           
}