/*************************************************************
@Name: APTS_UserTriggerHandler
@Author: Chetan Patel
@CreateDate: 30th October, 2015
@Description: Handler class for trigger for records of User.
@UsedBy: Trigger - APTS_UserTrigger
******************************************************************/

public class APTS_UserTriggerHandler {

    
    //Method to execute logic/operations when trigger is invoked before insert.
    public void onBeforeInsert(List<User> newUserList) {
        APTS_UserTriggerHelper helper = new APTS_UserTriggerHelper();
        helper.setDefaultValues(newUserList);
    }
    
    //Method to execute logic/operations when trigger is invoked before update.
    public void onBeforeUpdate(List<User> newUserList,List<User> oldUserList) {
        APTS_UserTriggerHelper helper = new APTS_UserTriggerHelper();
        helper.setDefaultValues(newUserList);
    }
}