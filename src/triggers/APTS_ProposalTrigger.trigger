trigger APTS_ProposalTrigger on Apttus_Proposal__Proposal__c(before insert, before update, after insert) {
    
    //If DML happend from Approval Request - dont fire Proposal Trigger
    if(APTS_ProcessorControl.isByPassTriggerOnDML){
        APTS_ProcessorControl.isByPassTriggerOnDML= false;
        return;
    }
    
    APTS_ProposalTriggerHandler proposalTriggerHandler = new APTS_ProposalTriggerHandler();

    /* Before Insert */
    if (Trigger.isInsert && Trigger.isBefore) {
        proposalTriggerHandler.onBeforeInsert(Trigger.new);
    }

    if (Trigger.isInsert && Trigger.isafter) {
     APTS_ProposalTriggerHelper.getRefrencedata(trigger.new);
     proposalTriggerHandler.onAfterInsert(trigger.new);
    }

    /* Before Update */
    if (Trigger.isUpdate && Trigger.isBefore) {
        proposalTriggerHandler.OnBeforeUpdate(Trigger.oldMap, Trigger.newMap);
    }
}