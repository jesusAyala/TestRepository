/*************************************************************
@Name: APTS_AgreementTrigger
@Author: Nishi Kushwaha
@CreateDate: 05/09/2015
@Description: Trigger on Agreement Object.
@UsedBy: NA
******************************************************************
@ModifiedBy: Hardik Shah
@ModifiedDate: 02/09/2015
@ChangeDescription: OnAfterUpdate Method Call, OnAfterDelete Method Call
**** PS: @ModifiedBy and @ChangeDescription can be repeated multiple time, based on number of changes made to the original process.
******************************************************************/


trigger APTS_AgreementTrigger on Apttus__APTS_Agreement__c (before insert, before update) {
    
    //If DML happend from Approval Request - dont fire Proposal Trigger
    if(APTS_ProcessorControl.isByPassTriggerOnDML){
        APTS_ProcessorControl.isByPassTriggerOnDML = false;
        return;
    }
    
    APTS_AgreementTriggerHandler agreementTriggerHandler = new APTS_AgreementTriggerHandler();

    /* Before Insert */
    if(Trigger.isInsert && Trigger.isBefore){
        agreementTriggerHandler.onBeforeInsert(Trigger.new);
    }
    /* Before Update */
    if(Trigger.isUpdate && Trigger.isBefore){
        //System.debug('before update trigger of MSPA');
        agreementTriggerHandler.OnBeforeUpdate(Trigger.oldMap,Trigger.newMap);
        
        //Axay:
        Boolean callSAPCreation = false;
        for(Apttus__APTS_Agreement__c newAgr : Trigger.new){
            
            if(newAgr.APTS_isClone__c && Trigger.size == 1){
                callSAPCreation = true;
                newAgr.APTS_isClone__c = false;
            }
        }
        //commented by Ganga to make sure MSPA flow is working
        //if(callSAPCreation){
            agreementTriggerHandler.OnAfterUpdate(Trigger.oldMap, Trigger.newMap);
       // }
    }
}