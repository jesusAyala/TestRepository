@isTest
public class APTS_LRDLODUtilityTest {

    private static User user = null;
    public static testMethod void testGetLODForQuotationFromAccount(){
        
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) { 
       		APTS_LP_TestUtility.getCommonConfigSetting();
            APTS_CaptureInputForLSODataController lsoController = new APTS_CaptureInputForLSODataController();
            Account acct = APTS_LP_TestUtility.getNewAccount('Test', 'Spain');
            test.startTest();
            insert acct;
            
            getERPReferenceData(acct);
            getLODReferenceData(acct);
            APTS_LRDLODUtility.findMatchingLODRecords(acct.id,lsoController,'Spain');
            
            test.stopTest();
        }
    }
    /*
    public static testMethod void testGetLODForAgreementFromAccount(){
        
         user  = APTS_LP_TestUtility.getUser();
         System.runAs(user) {         
             APTS_CaptureInputForLSODataController lsoController = new APTS_CaptureInputForLSODataController();
             Account acct = APTS_LP_TestUtility.getNewAccount('Test', 'Spain');
             test.startTest();
             insert acct;
             getERPReferenceData(acct);
             APTS_LRDLODUtility.GetLODForAgreementFromAccount(lsoController,acct.id,'Spain');
             test.stopTest();
         }
    }
    */
    /*
     public static testMethod void testGetLODForAgrrementFromOpportunity(){
        
         user  = APTS_LP_TestUtility.getUser();
         System.runAs(user) {
             APTS_CaptureInputForLSODataController lsoController = new APTS_CaptureInputForLSODataController();
             Account acct = APTS_LP_TestUtility.getNewAccount('Test', 'Spain');
             test.startTest();
             insert acct;
             ERP_Reference_Data__c erprefData = getERPReferenceData(acct);
             APTS_LRDLODUtility.GetLODForAgrrementFromOpportunity(lsoController,acct.id,'Spain',erpRefData);
             test.stopTest();
         }
        
     }
    
   */
   /* public static testMethod void testfindMatchingLODRecords(){
        
     user  = APTS_LP_TestUtility.getUser();
     System.runAs(user) {
     APTS_CaptureInputForLSODataController lsoController = new APTS_CaptureInputForLSODataController();
     Account acct = APTS_LP_TestUtility.getNewAccount('Test', 'Spain');
     test.startTest();
     insert acct;
     
     ERP_Reference_Data__c erprefData = getERPReferenceData(acct);
     List<ERP_Reference_Data__c> ref = new List<ERP_Reference_Data__c>();
     ref.add(erprefData);
     APTS_LRDLODUtility.findMatchingLODRecords(lsoController,ref);
     String refID = String.valueOf(erprefData.id);
     APTS_LRDLODUtility.GetLODForQuoteFromOpportunity(refID);
     test.stopTest();    
     } 
        
        
    }*/
    
    public static ERP_Reference_Data__c getERPReferenceData (Account acc){
    
        ERP_Reference_Data__c  refData1 = new ERP_Reference_Data__c();
        refData1.Local_Customer_ID__c = '12345678';
        refData1.SAP_Sales_Organization__c = 'ABB';
        refData1.SAP_Distribution_Channel__c = APTS_LP_TestUtility.getDistributionChannel().APTS_Code__c;
        refData1.LSO__c = user.Default_LSO__c;
        refData1.LBU__c = user.Default_BU__c;
        refData1.Account_GUID__c = acc.GUID__c;
        refData1.Account__c = acc.id;
        insert refData1;
        
        //String refID = String.valueOf(refData1.id);
        //APTS_LRDLODUtility.GetLODForQuoteFromOpportunity(refID);
        
        return refData1;
    }
    
        public static APTS_LP_Local_Customer_Reference_Data__c getLODReferenceData (Account acc){
    
        APTS_LP_Local_Customer_Reference_Data__c  refData1 = new APTS_LP_Local_Customer_Reference_Data__c();
        refData1.APTS_LP_SAP_Customer_ID__c = '12345678';
        refData1.APTS_LP_Sales_Organisation__c = 'ABB';
        refData1.APTS_LP_Distribution_Channel__c = APTS_LP_TestUtility.getDistributionChannel().APTS_Code__c;
        refData1.APTS_LP_Account__c = acc.id;
        refData1.APTS_Country__c = 'Spain';
        refData1.APTS_External_ID__c = '12345678';
        refData1.APTS_Payment_Terms__c = 'Z300';
        refData1.APTS_LP_Incoterms__c = 'CPT';
        refData1.APTS_LP_Local_Channel__c = 'P5';
        insert refData1;
        
        //String refID = String.valueOf(refData1.id);
        //APTS_LRDLODUtility.GetLODForQuoteFromOpportunity(refID);
        
        return refData1;
    }

}