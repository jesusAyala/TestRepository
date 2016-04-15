/**
    @Author Rajesh K
    @name NewCaptureTeamController
    @CreateDate 9/14/2015
    @Description check the access for allowing to create Capture Team Member.
    @Version 1.0
    **/
public with sharing class NewCaptureTeamController {
    /*  Description of the purpose of the method. 
    *  @name NewCaptureTeamController
    *  @Description - Constructor
    *  @return Nothing - 
    */
    public NewCaptureTeamController() {        
    }
    /*  Description of the purpose of the method. 
    *  @name redirect
    *  @Description - Redirecting to capture team member creation page .
    *  @return - Page Reference
    */
    public PageReference redirect(){
        List<End_User_Project__c> lstendUser = [SELECT id,Name,CreatedByid, Account_Manager__c FROM End_User_Project__c WHERE id =: Apexpages.Currentpage().getParameters().get(System.label.System_CL00018) LIMIT 1];
        if(lstendUser.size()>0){
            List<User> lstUser = [SELECT email FROM User where email =:lstendUser[0].Account_Manager__c];
            if(UserInfo.getUserId() == lstendUser[0].CreatedByid || UserInfo.getProfileId().equals(System.label.AdminProfileID) || 
            (lstUser.size() > 0 && UserInfo.getUserId() == lstUser[0].id)){              
                PageReference pageref = new PageReference(System.label.System_CL00044 +'e'); //System_CL00044=> '/a0j/' , System_CL00045=> 'retURL'
                pageref.getParameters().put('CF'+System.label.System_CL00099,lstendUser[0].Name);
                pageref.getParameters().put('CF'+System.label.System_CL00099+'_lkid',lstendUser[0].id);
                pageref.getParameters().put(System.label.System_CL00045, System.label.System_CL00020 +Apexpages.Currentpage().getParameters().get(System.label.System_CL00018)); //System_CL00020 => '/'
                pageref.setRedirect(true);
                return pageref;
            }
            else{
                PageReference pageref = new PageReference(System.label.System_CL00020+ Apexpages.Currentpage().getParameters().get(System.label.System_CL00018)); //System_CL00018 => 'id'
                pageref.setRedirect(true);
                return pageref;
            }
        }              
        return null;
    }
}