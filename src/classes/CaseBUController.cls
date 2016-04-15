/*  Description of the method. 
    *  @name CaseBUController
    *  @Author  Rajesh K
    *  @Description - Used to find the Case BU.
    */
public with sharing class CaseBUController
{
    /*  Description of the method. 
    *  @name CaseBUController
    *  @Description - constructor.
    *  @return nothing
    */
    public CaseBUController() {
    }
    /*  Description of the method. 
    *  @name redirect
    *  @Description - Logic to find the case BU.
    *  @return PageReference
    */
    public PageReference redirect(){
        case c = [select id,Business_Unit__c from case where id = :ApexPages.currentPage().getParameters().get(System.label.INTEG_SYS_Case_BU_ID) LIMIT 1]; //id
        Map<String, Schema.RecordTypeInfo> caseBU_RECORD_TYPES = Schema.SObjectType.Case_BU__c.getRecordTypeInfosByName();
        String caseBU_DMDR_RECORD_TYPE_ID = caseBU_RECORD_TYPES.get(system.label.INTEG_SYS_Case_BU_DMDR).getRecordTypeId(); //DMDR
        String caseBU_DMMG_RECORD_TYPE_ID = caseBU_RECORD_TYPES.get(system.label.INTEG_SYS_Case_BU_DMMG).getRecordTypeId(); //DMMG
        String caseBU_DMPC_RECORD_TYPE_ID = caseBU_RECORD_TYPES.get(system.label.INTEG_SYS_Case_BU_DMPC).getRecordTypeId(); //DMPC
        String caseBU_EPBP_RECORD_TYPE_ID = caseBU_RECORD_TYPES.get(system.label.INTEG_SYS_Case_BU_EPBP).getRecordTypeId(); //EPBP
        String caseBU_EPCP_RECORD_TYPE_ID = caseBU_RECORD_TYPES.get(system.label.INTEG_SYS_Case_BU_EPCP).getRecordTypeId(); //EPCP
        String caseBU_PACT_RECORD_TYPE_ID = caseBU_RECORD_TYPES.get(system.label.INTEG_SYS_Case_BU_PACT).getRecordTypeId(); //PACT
        String caseBU_PAMP_RECORD_TYPE_ID = caseBU_RECORD_TYPES.get(system.label.INTEG_SYS_Case_BU_PAMP).getRecordTypeId(); //PAMP
        String caseBU_PAOG_RECORD_TYPE_ID = caseBU_RECORD_TYPES.get(system.label.INTEG_SYS_Case_BU_PAOG).getRecordTypeId(); //PAOG
        String caseBU_PAPI_RECORD_TYPE_ID = caseBU_RECORD_TYPES.get(system.label.INTEG_SYS_Case_BU_PAPI).getRecordTypeId(); //PAPI
        String caseBU_EPMV_RECORD_TYPE_ID = caseBU_RECORD_TYPES.get(system.label.INTEG_SYS_Case_BU_EPMV).getRecordTypeId(); //EPMV
        String caseBU_PGGS_RECORD_TYPE_ID = caseBU_RECORD_TYPES.get(system.label.INTEG_SYS_Case_BU_PGGS).getRecordTypeId(); //PGGS
        String caseBU_PGGI_RECORD_TYPE_ID = caseBU_RECORD_TYPES.get(system.label.INTEG_SYS_Case_BU_PGGI).getRecordTypeId(); //PGGI
        String caseBU_PGGA_RECORD_TYPE_ID = caseBU_RECORD_TYPES.get(system.label.INTEG_SYS_Case_BU_PGGA).getRecordTypeId(); // PGGA
            
        PageReference pReference = null;
        String strObject = System.currentPageReference().getParameters().get(system.label.INTEG_SYS_Case_BU_object); // Object
        Schema.Sobjecttype oGenericObj = Schema.getGlobalDescribe().get(strObject); 
        pReference = new PageReference(system.label.INTEG_SYS_MassUncheck_Url1 + oGenericObj.getDescribe().getKeyPrefix() + system.label.INTEG_SYS_Case_BU_url1); 
        
        Map<String, String> m = pReference.getParameters();      
        if(oGenericObj != null){                
            PageReference pEditReference = new PageReference(system.label.INTEG_SYS_MassUncheck_Url1 +  oGenericObj.getDescribe().getKeyPrefix() +system.label.INTEG_SYS_Case_BU_url1);            
            m.putAll(StaticFunctions.createLabelParameters(pEditReference, oGenericObj.newSObject()));
            m.put(system.label.INTEG_SYS_Case_BU_nooverride,system.label.INTEG_SYS_Case_BU_1); //(nooverride,1)      
            m.put(system.label.INTEG_SYS_Case_BU_retURL, ApexPages.currentPage().getParameters().get(system.label.INTEG_SYS_Case_BU_retURL));         
        }
        if(c.Business_Unit__c.equals(system.label.INTEG_SYS_Case_BU_PAPI_Full)) {
            m.put(system.label.INTEG_SYS_Case_BU_RecordType, caseBU_PAPI_RECORD_TYPE_ID);
            pReference.setRedirect(false);
            return pReference;
        }
        else if(c.Business_Unit__c .equals(system.label.INTEG_SYS_Case_BU_PAOG_Full)) {
            m.put(system.label.INTEG_SYS_Case_BU_RecordType, caseBU_PAOG_RECORD_TYPE_ID);//RecordType
            pReference.setRedirect(false);
            return pReference;
        }
        else if(c.Business_Unit__c.equals(system.label.INTEG_SYS_Case_BU_PAMP_Full)){
            m.put(system.label.INTEG_SYS_Case_BU_RecordType, caseBU_PAMP_RECORD_TYPE_ID);//RecordType
            pReference.setRedirect(false);
            return pReference;
        }
        else if(c.Business_Unit__c.equals(system.label.INTEG_SYS_Case_BU_PACT_Full)){
            m.put(system.label.INTEG_SYS_Case_BU_RecordType, caseBU_PACT_RECORD_TYPE_ID);//RecordType
            pReference.setRedirect(false);
            return pReference;
        }
        else if(c.Business_Unit__c.equals(system.label.INTEG_SYS_Case_BU_EPCP_Full)){
            m.put(system.label.INTEG_SYS_Case_BU_RecordType, caseBU_EPCP_RECORD_TYPE_ID);//RecordType
            pReference.setRedirect(false);
            return pReference;
        }
        else if(c.Business_Unit__c.equals(system.label.INTEG_SYS_Case_BU_EPBP_Full)){
            m.put(system.label.INTEG_SYS_Case_BU_RecordType, caseBU_EPBP_RECORD_TYPE_ID);//RecordType
            pReference.setRedirect(false);
            return pReference;
        }
        else if(c.Business_Unit__c.equals(System.label.INTEG_SYS_Case_BU_DMPC_Full)) {
            m.put(system.label.INTEG_SYS_Case_BU_RecordType, caseBU_DMPC_RECORD_TYPE_ID);//RecordType
            pReference.setRedirect(false);
            return pReference;
        }
        else if(c.Business_Unit__c.equals(system.label.INTEG_SYS_Case_BU_DMMG_Full)){
            m.put(system.label.INTEG_SYS_Case_BU_RecordType, caseBU_DMMG_RECORD_TYPE_ID);//RecordType
            pReference.setRedirect(false);
            return pReference;
        }
        else if(c.Business_Unit__c.equals(system.label.INTEG_SYS_Case_BU_DMDR_Full)){
            m.put(system.label.INTEG_SYS_Case_BU_RecordType, caseBU_DMDR_RECORD_TYPE_ID);//RecordType
            pReference.setRedirect(false);
            return pReference;
            }
        else if(c.Business_Unit__c.equals(system.label.INTEG_SYS_Case_BU_EPMV_Full)){
            m.put(system.label.INTEG_SYS_Case_BU_RecordType, caseBU_EPMV_RECORD_TYPE_ID);//RecordType
            pReference.setRedirect(false);
            return pReference;
            }
      else if(c.Business_Unit__c.equals(system.label.INTEG_SYS_Case_BU_PGGS_Full)){
            m.put(system.label.INTEG_SYS_Case_BU_RecordType, caseBU_PGGS_RECORD_TYPE_ID);//RecordType
            pReference.setRedirect(false);
            return pReference;
            }
        else if(c.Business_Unit__c.equals(system.label.INTEG_SYS_Case_BU_PGGI_Full)){
            m.put(system.label.INTEG_SYS_Case_BU_RecordType, caseBU_PGGI_RECORD_TYPE_ID);//RecordType
            pReference.setRedirect(false);
            return pReference;
            }
        else if(c.Business_Unit__c.equals(system.label.INTEG_SYS_Case_BU_PGGA_Full)){
            m.put(system.label.INTEG_SYS_Case_BU_RecordType, caseBU_PGGA_RECORD_TYPE_ID);//RecordType
            pReference.setRedirect(false);
            return pReference;
            }
        else
        {return null;}
    }
}