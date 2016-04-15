/**
    @Author Rajesh K
    @name SendSubstitutesToCCRPclass
    @CreateDate 14-Dec-2015
    @Version 1.0
    **/
global class SendSubstitutesToCCRPclass
{
    /*  Description of the method. 
    *  @name sendSubstitutes
    *  @Description - Send case team members(only users not contact) to CCRP.
    *  @return String
    */
    webservice static String sendSubstitutes(Id caseid) 
    { 
     Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
        try{
            Set<Id> setMembers = new Set<Id>();
            List<CaseTeamMember> lstCaseTeamMembers = [Select Memberid, Parentid, TeamRoleid from CaseTeamMember where Parentid =: caseid LIMIT :remLimit];
            for(CaseTeamMember CTM : lstCaseTeamMembers){
                setMembers.add(CTM.Memberid);
            }
            List<User> lstUsers = [Select Username, Name, Email from User where ID IN: setMembers LIMIT :remLimit];
            if(lstUsers.size()>0){
                String cparam = '{';
                for(User objuser : lstUsers){               
                    cparam = cparam + '\"Username\": \"'+objuser.Username+'\",'+'\"Email\": \"'+objuser.Email+'\",';            
                }
                cparam = cparam + '}';
                /*
                 return here cparam (to CCRP)
                */
                return 'Yes';
            }else{
                return 'NoMember';
            }
            return null;
        }catch(Exception ex){
          //  System.debug('Exception:'+ ex);
            return 'No';
        }
    }    
}