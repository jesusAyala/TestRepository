/*************************************************************
@Name: APTS_AgreementTriggerHandler
@Author: Vamsi Guduri
@CreateDate: 11/02/2016
@Description: This class acts as a handler for various events on Attachment Object
@UsedBy: Trigger APTS_AgreementTrigger
******************************************************************/

public class APTS_AttachmentTriggerHandler {
 public APTS_AttachmentTriggerHandler() {
    }
    
      public void onBeforeInsert(List<Attachment> listAttachment){

        if(listAttachment.size() > 0){
            // update attachment title with specific format
            APTS_AttachmentTriggerHelper.updateAttachmentName(listAttachment);
            
        }
       
    }
}