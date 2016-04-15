/*  Description of the method. 
    *  @name CheckCaseBusinessUnitDetailClass
    *  @Author  Rajesh Kaliyaperumal
    *  @Description - validate when create new case Business Unit detail.
    *  @return nothing
    */
global without sharing class CheckCaseBusinessUnitDetailClass{

/*  Description of the method. 
*  @name checkCaseBU
*  @Description - validate when create new case Business Unit detail.
*  @return String
*/
webservice static String checkCaseBU(Id caseid){ 
         String caseBusinessUnit;   
        Case objcase = [Select id,Business_Unit__c from Case where id=:caseid LIMIT 1];
        if(objcase.Business_Unit__c.equals(System.label.INTEG_SYS_Case_BU_EPBP_Full)){
            caseBusinessUnit = System.label.INTEG_SYS_Case_BU_EPBP;
        }else if(objcase.Business_Unit__c.equals(System.label.INTEG_SYS_Case_BU_EPCP_Full)){
            caseBusinessUnit = System.label.INTEG_SYS_Case_BU_EPCP;
        }else if(objcase.Business_Unit__c.equals(System.label.INTEG_SYS_Case_BU_DMMG_Full)){
            caseBusinessUnit = System.label.INTEG_SYS_Case_BU_DMMG;
        }else if(objcase.Business_Unit__c.equals(System.label.INTEG_SYS_Case_BU_DMDR_Full)){
            caseBusinessUnit = System.label.INTEG_SYS_Case_BU_DMDR;
        }else if(objcase.Business_Unit__c.equals(System.label.INTEG_SYS_Case_BU_DMPC_Full)){
            caseBusinessUnit = System.label.INTEG_SYS_Case_BU_DMPC;
        }else if(objcase.Business_Unit__c.equals(System.label.INTEG_SYS_Case_BU_PACT_Full)){
            caseBusinessUnit = System.label.INTEG_SYS_Case_BU_PACT;
        }else if(objcase.Business_Unit__c.equals(System.label.INTEG_SYS_Case_BU_PAMP_Full)){
            caseBusinessUnit = System.label.INTEG_SYS_Case_BU_PAMP;
        }else if(objcase.Business_Unit__c.equals(System.label.INTEG_SYS_Case_BU_PAOG_Full)){
            caseBusinessUnit = System.label.INTEG_SYS_Case_BU_PAOG;
        }else if(objcase.Business_Unit__c.equals(System.label.INTEG_SYS_Case_BU_PAPI_Full)){
            caseBusinessUnit = System.label.INTEG_SYS_Case_BU_PAPI;
        }else if(objcase.Business_Unit__c.equals(System.label.INTEG_SYS_Case_BU_EPMV_Full)){
            caseBusinessUnit = System.label.INTEG_SYS_Case_BU_EPMV;
        }else if(objcase.Business_Unit__c.equals(System.label.INTEG_SYS_Case_BU_PGGS_Full)){
            caseBusinessUnit = System.label.INTEG_SYS_Case_BU_PGGS;
        }else if(objcase.Business_Unit__c.equals(System.label.INTEG_SYS_Case_BU_PGGI_Full)){
            caseBusinessUnit = System.label.INTEG_SYS_Case_BU_PGGI; 
        }else if(objcase.Business_Unit__c.equals(System.label.INTEG_SYS_Case_BU_PGGA_Full)){
            caseBusinessUnit = System.label.INTEG_SYS_Case_BU_PGGA;
        }
        else{
            return System.label.INTEG_SYS_Case_BU_Return_NoBusinessUnit;
        }
        Boolean ischeck = false;
        for(Case_BU__c objcaseBU : [Select Recordtype.name from Case_BU__c where case__c =: caseid LIMIT 10000]){
            if(caseBusinessUnit == objcaseBU.recordtype.Name){
                ischeck = true;
                break;
            }
            else
            {
                continue;
            }
        }
        if(ischeck==true){
            return System.label.INTEG_SYS_Case_BU_Return_BUisThere;
        }
        return System.label.INTEG_SYS_Case_BU_Return_Yes;
    }    
}