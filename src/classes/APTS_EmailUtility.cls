/*************************************************************
@Name: APTS_EmailUtility
@Author: Hardik Shah
@CreateDate: 27th October 2015
@Description: Utility-Class to send mail
@UsedBy: APTS_Validate.cls
******************************************************************/

public class APTS_EmailUtility {

  /**
   *  The methos sends a mail 
   * 
   * */
   
  public static void sendEmail(String messageBody,String sSubject){
           
       try{
        
        String sRecipantName = UserInfo.getUserEmail();
        String[] sendingTo = new String[]{sRecipantName};
        Messaging.SingleEmailMessage oMail = new Messaging.SingleEmailMessage();
        String sBody = messageBody ;
        oMail.setHtmlBody(sBody);
        oMail.setSubject(sSubject);
        oMail.setBccSender(false);
        oMail.setSenderDisplayName('noreply@salesforce.com');
        oMail.setSaveAsActivity(false);
        oMail.setToAddresses(sendingTo);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { oMail });
       
        }catch(Exception ex){
            system.debug('Exception while Sending Mail ' + ex.getMessage());
        }

    }

}