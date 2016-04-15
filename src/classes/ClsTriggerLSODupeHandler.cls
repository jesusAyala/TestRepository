/**
*  @Name: ClsTriggerLSODupeHandler
*  @Release - R3 CR
*  @Description - This class helps to allow the duplicate on ERP Picklist data
*  @Author : Mohan Raj (Accenture)
*/
public without sharing class ClsTriggerLSODupeHandler extends ClsTriggerVirtual  {
    
     /**
         * @see IntHelper.beforeTrigger
    */
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
        CheckLSODupeEntries(trgCtx);    
    }
    
    /**
    *  Method - CheckLSODupeEntries
    *  Description - Check the Description of ERP Mapping  
    */            
    @TestVisible 
    private void CheckLSODupeEntries(ClsWrappers.TriggerContext trgCtx) { 
        
        if ( (trgCtx.isBefore && trgCtx.isInsert) )
        {          
            Set<String> lsos = new Set<String>(); 
                         
            for (sobject so : trgCtx.newList) {
                ERP_Reference_Data__c erp = (ERP_Reference_Data__c)so;    
                
                //if( (erp.Account__c != null) && (erp.Country__c != null) && (erp.LBU__c != null) && (erp.LSO__c != null) && (erp.recordtypeid == '01220000000jYpuAAE'))
                if( (erp.Account__c != null) && (erp.Country__c != null) && (erp.LSO__c != null) && (erp.recordtypeid == '01220000000jYpuAAE'))
                {
                    string accid = erp.Account__c;
                    string strLBU = '';
                    if(erp.LBU__c != null){strLBU = erp.LBU__c;}
                    lsos.add(accid.substring(0,15)+erp.Country__c+strLBU+erp.LSO__c );                                  
                }
            } 
        
            set<String> Manualkeys = new set<String>();
            
            for(ERP_Reference_Data__c e : [select Id, ManualUniqueKey__c from ERP_Reference_Data__c where ManualUniqueKey__c in :lsos LIMIT 50000])
            {
                Manualkeys.add(e.ManualUniqueKey__c);
            }
            
            system.debug('MJ::'+Manualkeys.size());
                         
            for (sobject so : trgCtx.newList) {
                ERP_Reference_Data__c erp = (ERP_Reference_Data__c)so; 
                string accid1 = erp.Account__c; 
                //system.debug('MJ::'+accid1.substring(0,15)+erp.Country__c+erp.LBU__c+erp.LSO__c);      
                //system.debug('MJ::'+erp.recordtypeid);
                //system.debug('MJ::'+Manualkeys.Contains(accid1.substring(0,15)+erp.Country__c+erp.LBU__c+erp.LSO__c));
                if( (erp.Account__c != null) && (erp.Country__c != null) && (erp.LSO__c != null)  && (erp.recordtypeid == '01220000000jYpuAAE'))
                {   
                    string accid = erp.Account__c;
                    string strLBU = '';
                    if(erp.LBU__c != null){strLBU = erp.LBU__c;}                    
                    if(Manualkeys.Contains(accid.substring(0,15)+erp.Country__c+strLBU+erp.LSO__c) == True  )
                    {   system.debug('MJ::IS Error');                  
                        so.addError('An Account with this Country, LSO and LBU combination already exists. Cannot create duplicate records!');
                    }
                        
                }
            }            
        }  
        
        
        
        if ( trgCtx.isBefore && trgCtx.isUpdate )
        {               
        
            Set<String> lsos = new Set<String>(); 
            Set<Id> lsoids = new Set<Id>();
            
            for (sobject so : trgCtx.newList) {
                ERP_Reference_Data__c erp = (ERP_Reference_Data__c)so;    
                
                if( (erp.Account__c != null) && (erp.Country__c != null) && (erp.LSO__c != null) && (erp.recordtypeid == '01220000000jYpuAAE'))
                {
                    string accid = erp.Account__c;
                    string strLBU = '';
                    if(erp.LBU__c != null){strLBU = erp.LBU__c;}
                    lsos.add(accid.substring(0,15)+erp.Country__c+strLBU+erp.LSO__c );  
                    lsoids.add(erp.Id);                                
                }
            } 
        
            set<String> Manualkeys = new set<String>();
            
            for(ERP_Reference_Data__c e : [select Id, ManualUniqueKey__c from ERP_Reference_Data__c where ManualUniqueKey__c in :lsos and  Id not in : lsoids  LIMIT 50000])
            {
                Manualkeys.add(e.ManualUniqueKey__c);
            }
            
            system.debug('MJ::'+Manualkeys.size());
                         
            for (sobject so : trgCtx.newList) {
                ERP_Reference_Data__c erp = (ERP_Reference_Data__c)so; 
                string accid1 = erp.Account__c; 
                //system.debug('MJ::'+accid1.substring(0,15)+erp.Country__c+erp.LBU__c+erp.LSO__c);      
                //system.debug('MJ::'+erp.recordtypeid);
                //system.debug('MJ::'+Manualkeys.Contains(accid1.substring(0,15)+erp.Country__c+erp.LBU__c+erp.LSO__c));
                if( (erp.Account__c != null) && (erp.Country__c != null) && (erp.LSO__c != null)  && (erp.recordtypeid == '01220000000jYpuAAE'))
                {   
                    string accid = erp.Account__c;
                    string strLBU = '';
                    if(erp.LBU__c != null){strLBU = erp.LBU__c;}
                    if(Manualkeys.Contains(accid.substring(0,15)+erp.Country__c+strLBU+erp.LSO__c) )
                    {   system.debug('MJ::IS Error');                  
                        so.addError('An Account with this Country, LSO and LBU combination already exists. Cannot create duplicate records!');
                    }
                        
                }
            }            
        }  
        
                           
    }           
}