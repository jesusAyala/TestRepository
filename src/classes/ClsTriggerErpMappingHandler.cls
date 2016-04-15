/**
*  @Name: ClsTriggerErpMappingHandler
*  @Release - R3 
*  @Description - This class helps to Check the duplicate on ERP Mapping
*  @Author : Mohan (Accenture)
*/
public without sharing class ClsTriggerErpMappingHandler extends ClsTriggerVirtual  {
    
 /**
     * @see IntHelper.beforeTrigger
*/
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
        CheckLsoDescriptionDupeallow(trgCtx);    
    }
    
/**
*  Method - CheckLsoDescriptionDupeallow
*  Description - Check the Description of ERP Mapping  
*/            
    @TestVisible 
    private void CheckLsoDescriptionDupeallow(ClsWrappers.TriggerContext trgCtx) {        
        
        Set<String> LSOs = new Set<String>();    
        
        if ( (trgCtx.isBefore && trgCtx.isInsert) || (trgCtx.isBefore && trgCtx.isUpdate) )
        {               
            for (sobject so : trgCtx.newList) {
                ERP_Mapping__c erp = (ERP_Mapping__c)so;           
                if( (erp.LSO__c != null) && (erp.LSO_Description__c != null) )
                {
                    LSOs.add(erp.Country__c+erp.LSO__c);
                }
            }            
        }                
        
        Map<id,ERP_Mapping__c> mapErpMapping = new Map<Id,ERP_Mapping__c>([select Id, LSO__c,Country_LSO__c, LSO_Description__c from ERP_Mapping__c where Country_LSO__c IN: LSOs LIMIT 50000]);
        
        if ( (trgCtx.isBefore && trgCtx.isInsert) || (trgCtx.isBefore && trgCtx.isUpdate) )
        {               
            for (sobject so : trgCtx.newList) {
                ERP_Mapping__c erp = (ERP_Mapping__c)so;           
                if( (erp.LSO__c != null) && (erp.Country__c != null)&& (erp.LSO_Description__c != null) )
                {
                    for( ERP_Mapping__c erpmap : mapErpMapping.values()) 
                    {
                        if((erp.Country__c+erp.LSO__c == erpmap.Country_LSO__c) && (erp.LSO_Description__c != erpmap.LSO_Description__c ) )
                        {                     
                            so.addError(System.Label.System_ERP_Mapping_Error_Message);
                        }                    
                    }                    
                }                
            }            
        }                   
    }           
}