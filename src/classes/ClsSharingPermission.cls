/*
* Apex Page - SharingPermission
* Controller Class - ClsSharingPermission
* Description - The Records can be created only either by Account Owner, Account Team Member and ABB Basic Admin Profile User.
                Else, through a warning message.
                
* Created By - Indhu Selvi Ramalingam(Accenture)
* Created Date - 2016-02-08
* Req.no  -  KAD-00959
*/
public with sharing class ClsSharingPermission {

     public Id abbBasicAdminProfileId = NULL;
     
/*
* Constructor ClsSharingPermission             
* Created By - Indhu Selvi Ramalingam(Accenture)
* Created Date - 2016-02-08
* Req.no  -  KAD-00959
*/     
     public ClsSharingPermission(){
         Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
         Profile[] basicProf = [ SELECT ID, Name FROM Profile WHERE Name = :system.label.ABB_Basic_Admin_Profile_Name LIMIT :remLimit];
         abbBasicAdminProfileId = (basicProf != NULL && basicProf.size() > 0) ? basicProf[0].Id : NULL; 
     }

 /*
 *  Method name:    accessPermission
 *  @description    Gives access only to the specifi users and Redirects the user to the given object + parameters
 *  @return         PageReference The page the user needs to be redirect to.
 */     
     public PageReference accessPermission() {
            
        //Get object name
        String strObject = System.currentPageReference().getParameters().get(Label.System_Object);
        Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
        //Get Account id
        String strAccountId = System.currentPageReference().getParameters().get(Label.System_ID_Account);       
        
        //Allow record type selection? if set to yes, then allow RTS
        String strEnableRTS = System.currentPageReference().getParameters().get(Label.System_RTS);
        
        String objectId = System.currentPageReference().getParameters().get(Label.System_ObjectId);
        
        //capture the Account team users ids
        Set<ID> setAccTeamUserIds = new Set<ID>(); 
        //capture the Account Ids
        Set<ID> setAccIds = new Set<ID>(); 
        Map<ID, Set<Id>> mapUsersId = new Map<ID, Set<Id>>();
      
        Id labelId = Label.CL00075;
        Id userProfileId = Userinfo.getProfileid();
        Id currUser = UserInfo.getUserId();
        
        //If there is an object name
        if(strObject != null){
        
            strObject =  strObject.trim();     
            
            //Create a generic object based on the name
            Schema.Sobjecttype oGenericObj = Schema.getGlobalDescribe().get(strObject);     
            //system.debug('::::::oGenericObj:::::'+oGenericObj);
            
            String ret = ApexPages.currentPage().getParameters().get('retURL');
            if (ret != NULL) {                   
                ret = ret.substring(ret.lastIndexOf('/'), ret.length());                  
            }
            //If a real object has been given
            if(oGenericObj != null){  
            
                PageReference pReference = null;
     
              //Check if we have to use record type selection or not
                if(strEnableRTS != '' && strEnableRTS == Label.System_CL00120){
                    
                    String entVal = (objectId != null && objectId != '') ? objectId  : +oGenericObj.getDescribe().getKeyPrefix(); 
                    //If we need RTS, the URL will have to point to the recordtypeselect.jsp
                    if(oGenericObj.getDescribe().custom){
                        pReference = new PageReference(Label.System_rectype+objectId+Label.System_Url+oGenericObj.getDescribe().getKeyPrefix()+Label.System_CL00113+Label.System_CL00045 + Label.System_CL0014_R4 + ret);    // System_CL0014_R4 = , System_Url =>  &save_new_url=/ , Label.System_CL00113 =>  /e?          
                    }
                    else{
                        pReference = new PageReference(Label.System_rectype+strObject+Label.System_Url+oGenericObj.getDescribe().getKeyPrefix()+Label.System_CL00113);      // System_rectype =>/setup/ui/recordtypeselect.jsp?ent=            
                    } 
                  }else{
                
                    //Else create the page reference to the edit page of this object
                    pReference = new PageReference(Label.System_CL00020 +  oGenericObj.getDescribe().getKeyPrefix() + Label.System_CL00112);
                }             
            
            if (strAccountId != NULL) { 
            
                Id accID = ID.valueOf(strAccountId.trim());              
                for(AccountTeamMember atm : [SELECT id, UserId, AccountId FROM AccountTeamMember where AccountId =: accID LIMIT :remLimit]){
                    if(!mapUsersId.containsKey(atm.AccountId)){
                           mapUsersId.put(atm.AccountId, new Set<ID>());
                    }
                 mapUsersId.get(atm.AccountId).add(atm.UserId);
                } 
        
                setAccTeamUserIds = mapUsersId.get(accID); 
        
                Map<ID, Account> accMap = new Map <Id, Account> ([SELECT ID, OwnerID FROM Account WHERE ID  =: accID LIMIT :remLimit]); 
            
               //system.debug('::::accID::::'+accID+'::::setAccTeamUserIds:::'+setAccTeamUserIds+'::currUser::'+currUser+'::userProfileId::'+userProfileId);
            
                 if(accID != NULL && (setAccTeamUserIds == NULL || (setAccTeamUserIds != NULL && !setAccTeamUserIds.contains(currUser))) && currUser != accMap.get(accID).OwnerId && abbBasicAdminProfileId != userProfileId ){
                   apexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,System.label.System_CL00102));
                 }  
                 else {
                    PageReference pEditReference = new PageReference(Label.System_CL00020+oGenericObj.getDescribe().getKeyPrefix() + Label.System_CL00112); // =>/e
                    //System.debug('************************'+pEditReference);
                    //Get all current parameters - this could be either edit page or the record type selection.
                    Map<String, String> m = pReference.getParameters();
                    //Create the parameters for the URL (translates field to ID)             
                    m.putAll(StaticFunctions.createLabelParameters(pEditReference, oGenericObj.newSObject()));
                    m.put('nooverride', Label.System_CL00114);                    
                    m.put(Label.System_CL00045, ApexPages.currentPage().getParameters().get(Label.System_CL00045)); //Label.System_CL00045 => retURL
                    
                    pReference.setRedirect(false); 
                    
                    //system.debug(':::param:::::'+StaticFunctions.createLabelParameters(pEditReference, oGenericObj.newSObject()));
                    //system.debug(':::::m:::::'+m);
                    //system.debug(':::::pReference:::::'+pReference);
                                      
                    //Return the page
                    return pReference;
                    }                              
            }
        }
             
       }
      return null; 
    }    
}