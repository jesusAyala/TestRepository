@isTest
public class APTS_DoNotDeleteTaskTest {

    @isTest static void positive() {
    
        system.runAs(APTS_LP_TestUtility.getUser()){
            // For Agreement
            APTS_LP_TestUtility.getDiscountConfig();
            APTS_LP_TestUtility.getCommonConfigSetting();
            Task oTask = new Task();
            Apttus__APTS_Agreement__c oAgreement =  APTS_LP_TestUtility.getAgreement('Test');
            insert oAgreement;
            oTask.WhatId = oAgreement.id;
            oTask.Subject = 'Test';
            insert oTask;
            oTask.Subject = 'Re-Test';
            oTask.Status = 'Completed';
            update oTask;
            try{
                delete oTask;
            }catch(Exception ex){
                
            }
            delete oAgreement;
            
        }
        
    }
    
     @isTest static void positive1() {
    
         system.runAs(APTS_LP_TestUtility.getUser()){
            APTS_LP_TestUtility.getDiscountConfig();
             APTS_LP_TestUtility.getCustomSetting_QuoteNProposal();
            // For Proposal
            Task oTask1 = new Task();
            Apttus_Proposal__Proposal__c oProposal =  APTS_LP_TestUtility.getProposal('Test');
            insert oProposal;
            oTask1.WhatId = oProposal.id;
            oTask1.Subject = 'Test';
            insert oTask1;
            
            oTask1.Subject = 'Re-Test';
            oTask1.Status = 'Completed';
            update oTask1;
            
            try{
                delete oTask1;
            }catch(Exception ex){
                
            }
            
            delete oProposal;
         }
     } 
}