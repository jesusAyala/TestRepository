/*************************************************************
@Name: APTS_ConfigProductsCustomControllerTest
@Author: Kushal Bhalodiya
@CreateDate: 16th Nov 2015.
@Description: This is test clas for APTS_ProposalTriggerHandler
@UsedBy: 
******************************************************************/
@isTest
private class APTS_ProposalTriggerHandler_Test {

     private static final String QUOTE_RECORD_TYPE = 'LP Spain'; 
    
    private static testMethod void testMethod1() {
    
        System.runAs(APTS_LP_TestUtility.getUser()){
            APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
            Account acc=APTS_LP_TestUtility.getNewAccount('Apttus Inc','Spain');
            insert acc;
            
            APTS_Capture_LSO_Input_Config_Settings__c LSOInputSetting = APTS_LP_TestUtility.getLODConfigSetting();
            APTS_Master_PickList_Table__c mpt = APTS_LP_TestUtility.getMasterPickListTableLocalChannelWithInsert();
            /*
            APTS_Discounts_Config__c oDBobj = new APTS_Discounts_Config__c();
            oDBobj.name = 'sDBName';
            oDBobj.APTS_Country__c = 'Spain';
            oDBobj.APTS_Record_Type__c = 'MSPA';
            oDBobj.APTS_Hierarchy_Level_MS__c = '2';
            oDBobj.APTS_Local_Channel__c = mpt.id;
            oDBobj.APTS_IsActive__c = TRUE;
            insert oDBobj;
            
            Apttus__APTS_Agreement__c agreement =  APTS_LP_TestUtility.getAgreement('Test Agreement');
            agreement.APTS_Local_Channel__c = mpt.ID;
            insert agreement;
            /*Apttus_Proposal__Proposal__c quote=APTS_LP_TestUtility.getProposal('Apttus quote');
            quote.APTS_Local_Channel__c = mpt.id;
            quote.APTS_Locale__c = 'es_ES';*/
            
            APTS_LP_TestUtility.getDiscountConfig();
            
            List<Apttus_Proposal__Proposal__c> listProposal = new List<Apttus_Proposal__Proposal__c>();
            
            Apttus_Proposal__Proposal__c propSO = APTS_LP_TestUtility.getProposal('Test Proposal');
           // propSO.APTS_Local_Channel__c = mpt.id;
            //propSO.RecordTypeID = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(QUOTE_RECORD_TYPE).getRecordTypeId();
            listProposal.add(propSO);
            
            
            Apttus_Proposal__Proposal__c propSO1 = APTS_LP_TestUtility.getProposal('Test Proposal1');
          //  propSO1.APTS_Local_Channel__c = mpt.id;
            //propSO1.RecordTypeID = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(QUOTE_RECORD_TYPE).getRecordTypeId();
            listProposal.add(propSO1);
            
            insert listProposal;
            
            List<Apttus_Proposal__Proposal__c> listP1= [select id,APTS_QuotationType__c from Apttus_Proposal__Proposal__c where id =: propSO.id];
            
            
            Map<Id,Apttus_Proposal__Proposal__c> mapOldProposal = new Map<Id,Apttus_Proposal__Proposal__c>();
            mapOldProposal.put(propSO.ID,propSO);
            mapOldProposal.put(propSO1.ID,propSO1);
            
            Map<Id,Apttus_Proposal__Proposal__c> mapNewProposal = new Map<Id,Apttus_Proposal__Proposal__c>();
            mapNewProposal.put(propSO.ID,propSO);
            mapNewProposal.put(propSO1.ID,propSO1);
            
            Test.startTest();
            APTS_ProposalTriggerHandler objHandler = new APTS_ProposalTriggerHandler();
            objHandler.onBeforeInsert(listProposal);
            
           // objHandler.OnAfterUpdate(mapOldProposal,mapNewProposal);
            
           // objHandler.OnAfterDelete(mapNewProposal);
            
            Test.stopTest();
        }
    }

}