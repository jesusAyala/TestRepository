@isTest
public class APTS_LP_CommonUtilTest {
   static APTS_Capture_LSO_Input_Config_Settings__c oLODConfigSetting = APTS_LP_TestUtility.getLODConfigSetting();
   private static User user;
   private static Apttus__APTS_Agreement__c agreement;
   private static Apttus_Proposal__Proposal__c proposal;
   public static testMethod void getSalesOfficeExistInLSOFields(){
        
       System.runAs(APTS_LP_TestUtility.getUser()){
            List<LSO_Field_Entries__c> lstLSOFieldsEntry = new  List<LSO_Field_Entries__c>();
            LSO_Field_Entries__c lsoEntry = new LSO_Field_Entries__c();
            lsoEntry.PickList_Description__c = 'Desc';
            lsoEntry.Country__c = 'Spain';
            lstLSOFieldsEntry.add(lsoEntry);
            insert lstLSOFieldsEntry;  
            APTS_LP_CommonUtil.getSalesOfficeExistInLSOFields('Desc', 'Spain'); 
            
            APTS_LP_CommonUtil.getSalesOfficeExistInLSOFields('Description', 'Italy');    
       }
   }
   public static testMethod void isApplicableFOrLP(){
       user  = APTS_LP_TestUtility.getUser();
       System.runAs(user) {
		   APTS_LP_TestUtility.getCommonConfigSetting();
           agreement = APTS_LP_TestUtility.getAgreement('TestAgreement');
           APTS_LP_TestUtility.getDiscountConfig();
           List < Apttus__APTS_Agreement__c > listAgrForLPSpain = new List < Apttus__APTS_Agreement__c > ();
           Map < Id, Apttus__APTS_Agreement__c > mapAgrForLPSpain = new Map < Id, Apttus__APTS_Agreement__c > ();
           test.starttest();
           listAgrForLPSpain.add(agreement);
           insert listAgrForLPSpain;
           mapAgrForLPSpain.put(agreement.id,agreement);
           Test.stopTest();
           APTS_LP_CommonUtil.isApplicableFOrLP(listAgrForLPSpain);
           APTS_LP_CommonUtil.isApplicableFOrLP(mapAgrForLPSpain);
       }
   }
   public static testMethod void isProposalApplicableFOrLP(){
       user  = APTS_LP_TestUtility.getUser();
       System.runAs(user) {
           APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
           proposal = APTS_LP_TestUtility.getProposal('TestProposal');
           APTS_LP_TestUtility.getDiscountConfig();
           List < Apttus_Proposal__Proposal__c > listProposalForLPSpain = new List < Apttus_Proposal__Proposal__c > ();
           Map < Id, Apttus_Proposal__Proposal__c > mapProposalForLPSpain = new Map < Id, Apttus_Proposal__Proposal__c > ();
           Test.startTest();
           listProposalForLPSpain.add(proposal);
           insert listProposalForLPSpain;
           Test.stopTest();
           APTS_LP_CommonUtil.isProposalApplicableFOrLP(listProposalForLPSpain);
           APTS_LP_CommonUtil.isProposalApplicableFOrLP(mapProposalForLPSpain);
       }
   }
}