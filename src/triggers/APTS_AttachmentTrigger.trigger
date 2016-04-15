/*************************************************************
@Name: APTS_AttachmentTrigger
@Author: Vamsi Guduri
@CreateDate: 11/02/2016
@Description: Trigger on Attachment Object.
@UsedBy: NA
******************************************************************/

trigger APTS_AttachmentTrigger on Attachment (before insert) {
    
   APTS_AttachmentTriggerHandler attachmentTriggerHandler = new APTS_AttachmentTriggerHandler();
   
    /* Before Insert */
    if(Trigger.isInsert && Trigger.isBefore){
        attachmentTriggerHandler.onBeforeInsert(Trigger.new);
    }
    
}