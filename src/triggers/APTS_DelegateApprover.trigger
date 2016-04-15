/*************************************************************
@Name: APTS_DelegateApprover
@Author: Ganga Vemula
@CreateDate: 24th NOV 2015.
@Description: TThis trigger is to validate the delegate approver data on inserting the record
@UsedBy: 
******************************************************************/
trigger APTS_DelegateApprover on Apttus_Approval__Backup_Approver__c (before insert) {

    map<Id,Id> userGroupIdMap=new map<Id,Id>();
    map<string,string> countryGroupnameMap=new map<string,string>();
    Group grp;
    
    //get the custom setting entries where we are storing country name and corresponding public group's API name
    list<APTS_Delegated_Approver_Settings__c> delegatedSettings=APTS_Delegated_Approver_Settings__c.getall().values();
    
    
    //store the country and public group's api name in a map
    for(APTS_Delegated_Approver_Settings__c settingdata : delegatedSettings){
       countryGroupnameMap.put(settingdata.APTS_Country__c,settingdata.APTS_Public_Group_Name__c);
    }
    
     //get the public group based on owner's(record creator) country.
    //for example, for Spain user, get the public group called "Spain Country Admin"
    //using trigger.new[0] will not cause any issue during bulkification, because owner will be same for set of records.
    if(countryGroupnameMap.get(trigger.new[0].APTS_Owner_Country__c) != null){
        grp =[SELECT id, RelatedId, Type FROM Group where DeveloperName=:countryGroupnameMap.get(trigger.new[0].APTS_Owner_Country__c) limit 1];
    }
    
    //get all members of public group
    list<GroupMember> groupMembers=[Select Id, UserOrGroupId,groupid From GroupMember Where GroupId = :grp.Id];
    
    for(Apttus_Approval__Backup_Approver__c approverobj : trigger.new){
     
         for (GroupMember m : groupMembers){
           //check if the owner of delegated approver record belongs to public group or not
           if(m.UserOrGroupId==approverobj.ownerId){
           
                userGroupIdMap.put(approverobj.ownerId,m.groupid);
                
           }
           
                      
        }
        //Added by chetan 30-11-2015  populate APTS_Country__c field used in sharing rules
        approverobj.APTS_Country__c  = approverobj.APTS_Owner_Country__c;

    }   

    
    for(Apttus_Approval__Backup_Approver__c approver : trigger.new){
      //check if owner is same as current user OR owner should be member of corresponding public group and current user should belongs corresponding country.
      if((approver.Apttus_Approval__Current_User__c==approver.ownerid) || (userGroupIdMap.get(approver.ownerId) != null && approver.APTS_Current_User_Country__c==approver.APTS_Owner_Country__c) ){
       
        continue;
       
      }else{
        //if not met the criteria, through an error message
        approver.adderror(Label.APTS_Delegate_Approver_Error);
       
      }
      
   }
    

}