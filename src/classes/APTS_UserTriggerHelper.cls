/*************************************************************
@Name: APTS_UserTriggerHelper
@Author: Chetan Patel
@CreateDate: 30th October, 2015
@Description: Helper class to perform operations for trigger for records of User.
@UsedBy: Class - APTS_UserHandler
******************************************************************/

public class APTS_UserTriggerHelper {
    
    /**
     * Method to set the default values in the provided list of new Apttus LSO records.
     */
    public void setDefaultValues(List<User> newUserList) {
        
        for(User user : newUserList) {
                user.APTS_Locale__c = user.LocaleSidKey;
        }
    }
}