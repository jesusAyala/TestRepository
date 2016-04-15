/**
 * Controller extension class for Account object
 *
 * @author Lili zhao
 * @created 2014-10-21
 * @version 1.0
 * @since 29.0 (Force.com ApiVersion)
 * 
 * @changelog
 * 2014-10-21 Lili Zhao <lili.zhao@itbconsult.com>
 * - Created
 * 
 * 2015-11-17 Ishita Bhardwaj <ishita_bhardwaj@infosys.com>
 * - changed
 *
 */
public class  ClsAccountUtil {
    
    public static boolean isAccTriggerFlag = False; 
    public static boolean isAccMergeFlag = False; 
    public static boolean isUpdate = true; 
    public static boolean isExtUpdate = true;
       
    //********************************* -=BEGIN public methods=- *********************************/
    /**
    * This method used to set Successor Company account
    @param    
    @return    void
    @changelog
    * 2014-10-21 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    * 
    * 2015-11-17 Ishita Bhardwaj <ishita_bhardwaj@infosys.com>
    * - changed
    * 
    */   
    public static String setSuccessorCompany_InactiveCheck(map<String, String> map_accId_successorCompany,map<String, String> map_accId_successorCompany_Out) {
            
        String DupeRecords ='';    
        DateTime CurrentDateTime=system.now();
        list<Sobject> list_cloneList = new list<Sobject>();
        list<Sobject> list_deletecloneList = new list<Sobject>();
        map<String, FeedItem> map_accId_feedItem = new map<String, FeedItem>();
        set<String> set_deleteAccId = new set<String>();
        set<String> set_accIds = new set<String>();
        set_accIds.addAll(map_accId_successorCompany.keySet());
        set<String> set_accIdsOut = new set<String>();
        set_accIdsOut.addAll(map_accId_successorCompany_Out.keySet());
        boolean isDelete = false;
        boolean added=false;
        // get the custom setting values to set the sql String
        list<ReAssigning_Related_Records__c> list_ReAssigningCustoms = ReAssigning_Related_Records__c.getAll().values();
        
        Map<Id,User> InactiveUserMap = new Map<Id,User>([select id from user where isactive = false]);
        
        if(list_ReAssigningCustoms.size() > 0) {                        
            ReAssigningSettingInfos settingInfos = new ReAssigningSettingInfos();   //for duplicate records
            
            Set <String> accSet=new Set<String>();
            if(map_accId_successorCompany.size()>0)
            {for(String acid:map_accId_successorCompany.keySet())
            {
            accSet.add(acid);    
            }}

            if(map_accId_successorCompany_Out.size()>0)
            {for(String acid:map_accId_successorCompany_Out.keySet())
            {
            accSet.add(acid);   
            }}
            
            // get related record query String    
            if(accSet.size()>0)  
            {             
            getQueryString_InactiveCheck(list_ReAssigningCustoms, settingInfos, accSet);    
            }
            
            if(settingInfos.map_objectAPI_Sql.size() > 0) {
                for(String objectAPI : settingInfos.map_objectAPI_Sql.keySet()) {
                    // get the parent API
                    String parentAPI = (settingInfos.map_objectAPI_parentAPI.containsKey(objectAPI) ? settingInfos.map_objectAPI_parentAPI.get(objectAPI) : '');                               
                    if(parentAPI != '' && settingInfos.map_objectAPI_isClone.containsKey(objectAPI) && objectAPI != 'Note' && objectAPI != 'Attachment' && objectAPI != 'Partner') {
                        isDelete = true;                        
                        for(Sobject objects : Database.query(settingInfos.map_objectAPI_Sql.get(objectAPI))) {                                                       
                            String ownerid = String.valueof(objects.get('OwnerId'));                            
                            if(InactiveUserMap.containsKey(ownerid))
                            {                           
                                DupeRecords += objectAPI+'::'+ objects.Id + '\r\n';     
                            }                                  
                        }
                        
                    }                                                           
                }                           
                
            } 
            
          
        }
        
       return DupeRecords; 
    }
    
    
    
    public static void setSuccessorCompany(map<String, String> map_accId_successorCompany,map<String, String> map_accId_successorCompany_Out, Set<Id> SafeIsland) {
        isUpdate =false;
        list<Sobject> list_resultList = new list<Sobject>();
        list<Sobject> list_resultList_second = new list<Sobject>();
        DateTime CurrentDateTime=system.now();
        list<Sobject> list_cloneList = new list<Sobject>();
        list<Sobject> list_deletecloneList = new list<Sobject>();
        map<String, FeedItem> map_accId_feedItem = new map<String, FeedItem>();
        set<String> set_deleteAccId = new set<String>();
        set<String> set_accIds = new set<String>();
        set_accIds.addAll(map_accId_successorCompany.keySet());
        set<String> set_accIdsOut = new set<String>();
        set_accIdsOut.addAll(map_accId_successorCompany_Out.keySet());
        boolean isDelete = false;
        boolean added=false;
        // get the custom setting values to set the sql String
        list<ReAssigning_Related_Records__c> list_ReAssigningCustoms = ReAssigning_Related_Records__c.getAll().values();
        
        if(list_ReAssigningCustoms.size() > 0) {                        
            ReAssigningSettingInfos settingInfos = new ReAssigningSettingInfos();   //for duplicate records
            ReAssigningSettingInfos settingInfosOut = new ReAssigningSettingInfos();  //for out of business records
            //ReAssigning_Related_Records__c ReassingSettings = ReAssigning_Related_Records__c.getValues('Partner');
            // get related record query String    
            
            // Account Team Member Logic - CR 
            
            Set <String> accSet=new Set<String>();
            if(map_accId_successorCompany.size()>0)
            {for(String acid:map_accId_successorCompany.keySet())
            {  //accSet.add(acid);    
            accSet.add(map_accId_successorCompany.get(acid));               
            }}

            if(map_accId_successorCompany_Out.size()>0)
            {for(String acid:map_accId_successorCompany_Out.keySet())
            {
            //accSet.add(acid);   
            accSet.add(map_accId_successorCompany_Out.get(acid));     
            }}
            
            
            Map<Id,AccountTeamMember> accTeamMap = new Map<Id,AccountTeamMember>([Select AccountId,Account.Successor_Company__c,UserId,TeamMemberRole from AccountTeamMember where AccountId IN : accSet]);

            Map<String, Set<String>> lstSImap = new   Map<String, Set<String>>();

            for(AccountTeamMember aTeam : accTeamMap.values()) 
            {
                if(!lstSImap.ContainsKey(aTeam.AccountId))
                {
                lstSImap.put(aTeam.AccountId, new Set<String>());
                }
                lstSImap.get(aTeam.AccountId).add(aTeam.UserId);      
            }
            
            
            Map<Id,AccountContactRole> accContMap = new Map<Id,AccountContactRole>([Select AccountId,ContactId from AccountContactRole where AccountId IN : accSet]);

            Map<String, Set<String>> lstACmap = new   Map<String, Set<String>>();

            for(AccountContactRole aCont : accContMap.values()) 
            {
                if(!lstACmap.ContainsKey(aCont.AccountId))
                {
                lstACmap.put(aCont.AccountId, new Set<String>());
                }
                lstACmap.get(aCont.AccountId).add(aCont.ContactId);      
            }
            
            
            
            if(map_accId_successorCompany.size()>0)  
            { 
            System.debug('*******************getting duplicate query*******************');
            getQueryString(list_ReAssigningCustoms, settingInfos, map_accId_successorCompany);
            }
            if(map_accId_successorCompany_Out.size()>0)  
            {
             System.debug('*******************getting Out query*******************');
             getQueryStringOut(list_ReAssigningCustoms, settingInfosOut, map_accId_successorCompany_Out);            
            } 
            if(settingInfos.map_objectAPI_Sql.size() > 0) {
                for(String objectAPI : settingInfos.map_objectAPI_Sql.keySet()) {
                    // get the parent API
                    String parentAPI = (settingInfos.map_objectAPI_parentAPI.containsKey(objectAPI) ? settingInfos.map_objectAPI_parentAPI.get(objectAPI) : '');
                    // some object the parent id is read_only,use the clone method                        
                    if(parentAPI != '' && settingInfos.map_objectAPI_isClone.containsKey(objectAPI) && objectAPI != 'Note' && objectAPI != 'Attachment' && objectAPI != 'Partner' ) {
                        isDelete = true;
                        for(Sobject objects : Database.query(settingInfos.map_objectAPI_Sql.get(objectAPI))) {  
                            // some object the parent id is edit,change parent id only
                            // query the related record list
                            
                            if(map_accId_successorCompany.containsKey(String.valueof(objects.get(parentAPI)))) {                                
                                
                                if(settingInfos.map_objectAPI_isClone.get(objectAPI)) {
                                    // clone the object for read only object
                                    system.debug('************************Calling clone method for'+objectAPI);
                                    cloneSobject(parentAPI, map_accId_successorCompany.get(String.valueof(objects.get(parentAPI))), objects, list_cloneList, objectAPI, lstSImap, lstACmap);
                                    if(!settingInfos.map_objectAPI_isCopy.get(objectAPI))
                                    {list_deletecloneList.add(objects);}    
                                    system.debug('MR**MR**Delete::'+list_deletecloneList.size());                                   
                                    
                                }else{
                                    
                                    Boolean blnrec = True;
                                                                          
                                    if(objectAPI == 'Safe_Island_Assessments__c')                                    
                                    {
                                        if(SafeIsland != null  && SafeIsland.size()>0 && SafeIsland.Contains(objects.Id)) 
                                        { blnrec = False; }              
                                    }
                                    if(blnrec)
                                    {
                                    // change the parent Id
                                    system.debug('************************Reparenting '+parentAPI+' for '+objectAPI+' : '+objects.id+' ***to*** MR ::'+ objects+ map_accId_successorCompany.get(String.valueof(objects.get(parentAPI))));
                                    objects.put(parentAPI, map_accId_successorCompany.get(String.valueof(objects.get(parentAPI))));
                                    for(SOBject obj:list_resultList)
                                    {
                                        if(obj.id==objects.id)
                                        {
                                        system.debug('************************Adding to second List: '+objects.id);
                                        list_resultList_second.add(objects);
                                         added=true;
                                         break;
                                        }
                                    }
                                    if(!added)
                                    {
                                    system.debug('************************Adding to first List: '+objects.id);
                                    list_resultList.add(objects);}
                                    added=false;
                                    }
                                }
                            }                                           
                        }
                        
                    }                                                           
                }                           
                //call batch to clone Attachments & Notes due to heap size limit
                system.debug('************************Calling NA batch for Duplicates');
                ClsBatch_cloneAccountNotes cls = new ClsBatch_cloneAccountNotes();
                cls.map_accId_successorCompany = map_accId_successorCompany;
                cls.reParentAttach = settingInfos.map_objectAPI_Sql.containsKey('Attachment');
                cls.reParentNote = settingInfos.map_objectAPI_Sql.containsKey('Note'); 
                database.executeBatch(cls, 1);
            } 
            if(settingInfosOut.map_objectAPI_Sql.size() > 0) {
                system.debug('************************Ooouuuttt Setting');
                
                for(String objectAPI : settingInfosOut.map_objectAPI_Sql.keySet()) {
                    // get the parent Id API
                    system.debug('************************OOO:'+objectAPI);
                    String parentAPI = (settingInfosOut.map_objectAPI_parentAPI.containsKey(objectAPI) ? settingInfosOut.map_objectAPI_parentAPI.get(objectAPI) : '');
                    // some object the parent id is read_only,use the clone method   
                             
                    if(parentAPI != '' && settingInfosOut.map_objectAPI_isClone.containsKey(objectAPI) && objectAPI != 'Note' && objectAPI != 'Attachment' && objectAPI != 'Partner') {
                        isDelete = true;
                        for(Sobject objects : Database.query(settingInfosOut.map_objectAPI_Sql.get(objectAPI))) {  
                            // some object the parent id is edit,change parent id only
                            // query the related record list
                            if(map_accId_successorCompany_Out.containsKey(String.valueof(objects.get(parentAPI)))) {                                
                                // add the Chatter Message                                 
                                if(settingInfosOut.map_objectAPI_isClone.get(objectAPI)) {
                                    // clone the object for read only object
                                    //cloneSobject(parentAPI, map_accId_successorCompany_Out.get(String.valueof(objects.get(parentAPI))), objects, list_cloneList);
                                    cloneSobject(parentAPI, map_accId_successorCompany_Out.get(String.valueof(objects.get(parentAPI))), objects, list_cloneList, objectAPI, lstSImap, lstACmap);
                                    if(!settingInfosOut.map_objectAPI_isCopy.get(objectAPI))
                                    {list_deletecloneList.add(objects);}                                    
                                }else{
                                    // change the parent Id
                                    objects.put(parentAPI, map_accId_successorCompany_Out.get(String.valueof(objects.get(parentAPI))));
                                    for(SOBject obj:list_resultList)
                                    {
                                        if(obj.id==objects.id)
                                        {list_resultList_second.add(objects);
                                         added=true;
                                         break;
                                        }
                                    }
                                    if(!added)
                                    {list_resultList.add(objects);}
                                    added=false;
                                }
                            }                                           
                        }
                        
                    }                                                           
                }                           
                //reset the merge related fields
              
                list<Account> list_updateAccFields = new list<Account>();
                system.debug('***********************for out reassign code');
                for(Account account : [Select ReAssign__c, Reassignment_Pending__c From Account where Id IN : map_accId_successorCompany_Out.keySet()]) 
                {
                account.ReAssign__c = false;
                account.Reassignment_Pending__c = false;
                system.debug('***********************for out reassign code updating'+account.Reassignment_Pending__c);
                list_updateAccFields.add(account);
                }
      
      if(list_updateAccFields.size() > 0) {
          ClsAccountUtil.isUpdate = false;
          ClsAccountUtil.isExtUpdate = false; 
          update list_updateAccFields;
          system.debug('***********************for out reassign code UPDATED');
          
      }
            } 
        }
        // insert the relate record list
        system.debug('list_cloneList::: '+list_cloneList);
        if(list_cloneList.size() > 0) {
            insert list_cloneList;
            /*if(list_cloneList.size()==list_deletecloneList.size())
            {                
                delete list_deletecloneList;
            }*/
            delete list_deletecloneList;
        }
       
        // update the relate record list
        if(list_resultList_second.size() > 0) {
        System.debug('****************** Updating Second *********************');
            update list_resultList_second;
        }
        if(list_resultList.size() > 0) {
        System.debug('****************** Updating First *********************');
            update list_resultList;
        }
        
        
    }
    /**
    * This method used to get query String for related record
    *
    @param    
    @return    void
    *
    @changelog
    * 2014-10-21 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    * 
    * 2015-11-17 Ishita Bhardwaj <ishita_bhardwaj@infosys.com>
    *- changed
    */
    public static void cloneSobject(String parentAPI, String targetId, Sobject sobj, list<Sobject> list_cloneList, String objectAPI, Map<String, Set<String>>  lstSImap,  Map<String, Set<String>> lstACmap) {
        
        Sobject cloneObj = sobj.clone(false, true);
        cloneObj.put(parentAPI, targetId);
        
        Boolean blnrec = True;
        if(objectAPI == 'AccountTeamMember')                                    
        {   
            if(lstSImap != null  && lstSImap.size()>0 ) 
            { 
                Set<String> accTeamSet = new Set<String>();
                accTeamSet = lstSImap.get(targetId);       
                system.debug('MR**MR'+String.valueof(sobj.get('AccountId')));    
                system.debug('MR**MR'+String.valueof(sobj.get('UserId')));   
                system.debug('MR**MR'+accTeamSet);              
                if(accTeamSet != null  && accTeamSet.size()>0 && accTeamSet.Contains(String.valueof(sobj.get('UserId'))))
                {
                    blnrec = False;
                }                                    
            
            } 
        }
        
        if(objectAPI == 'AccountContactRole')                                    
        {   
            if(lstACmap != null  && lstACmap.size()>0 ) 
            { 
                Set<String> accContactSet = new Set<String>();
                accContactSet = lstACmap.get(targetId);     
                            
                if(accContactSet != null  && accContactSet.size()>0 && accContactSet.Contains(String.valueof(sobj.get('ContactId'))))
                {
                    blnrec = False;
                }                                    
            
            } 
        }
        
        system.debug('*****************In function for cloneObj'+sobj.id+',,,,,,,,,,'+parentAPI+',,,'+targetId);
        if(blnrec)
        {list_cloneList.add(cloneObj);}
    }
    
  
    
   /**
    * This method used to get query String for related record
    *
    @param    
    *
    @return    void
    *
    @changelog
    * 2015-11-17 Ishita Bhardwaj <ishita_bhardwaj@infosys.com>
    * -Created
    * 
    */
    public static void getQueryStringOut(list<ReAssigning_Related_Records__c> list_ReAssigningCustoms, ReAssigningSettingInfos settingInfosOut, map<String, String> map_accId_successorCompany_Out) {     
        
        String sql = '';
        String RequireField = '';
        set<String> set_accIdsOut = new set<String>();
        
        set_accIdsOut.addAll(map_accId_successorCompany_Out.keySet());
        for(ReAssigning_Related_Records__c ReAssigningCustoms : list_ReAssigningCustoms) {
            List<String> parentList=new List<String>();
            //check to exclude contacts,leads,visit reports and feeditem for out of business account merge            
            if(ReAssigningCustoms.IsOutBusiness__c && ReAssigningCustoms.Name != 'Partner' )
            {
                if(ReAssigningCustoms.Parent_API__c!=null && ReAssigningCustoms.Parent_API__c!='')
                {
                    //check if parentAPI contains more than one relations with account
                    if(ReAssigningCustoms.Parent_API__c.contains(','))
                    {                        
                        parentList=ReAssigningCustoms.Parent_API__c.split(',');
                    } 
                     else   
                     {parentList.add(ReAssigningCustoms.Parent_API__c);  }
                }
                boolean flag=true;
                    for(String parent: parentList){               
            sql = ((parent != null && parent != '' ) ? ( (ReAssigningCustoms.Require_Field__c != null && ReAssigningCustoms.Require_Field__c != '')? 
                    ('select ' + parent + ',' + ReAssigningCustoms.Require_Field__c) : 
                    ('select ' + parent)) : '');
            if(sql != '' && ReAssigningCustoms.Name != 'Account ReAssign Scheduled Job Id' 
                && ReAssigningCustoms.Name != 'Account ReAssign Batch Class Id' && ReAssigningCustoms.Name != 'BatchNum') {
                // the query String
               
                sql += ' from ' + ReAssigningCustoms.Name + ' where ' + parent + ' IN :  set_accIdsOut ' ;
               
                if( ReAssigningCustoms.Filter_Clause__c !='' && + ReAssigningCustoms.Filter_Clause__c != null ){
                    sql += ReAssigningCustoms.Filter_Clause__c +' ';
                }

                if(ReAssigningCustoms.Name == 'FeedItem') {
                    sql += ' And Type != \'TrackedChange\' ';
                }
                if(ReAssigningCustoms.Name == 'Event') {
                sql+='AND EndDateTime>:CurrentDateTime';
                }
                                                
                
                if(flag)
                {
                    settingInfosOut.map_objectAPI_Sql.put(ReAssigningCustoms.Name, sql);
                    settingInfosOut.map_objectAPI_parentAPI.put(ReAssigningCustoms.Name, parent);
                    settingInfosOut.map_objectAPI_isClone.put(ReAssigningCustoms.Name, ReAssigningCustoms.isClone__c);
                    settingInfosOut.map_objectAPI_isCopy.put(ReAssigningCustoms.Name, ReAssigningCustoms.IsOutBusiness_Copy__c);
                 }
                else
                {
                    settingInfosOut.map_objectAPI_Sql.put(ReAssigningCustoms.Name+' parent', sql);
                    settingInfosOut.map_objectAPI_parentAPI.put(ReAssigningCustoms.Name+' parent', parent);
                    settingInfosOut.map_objectAPI_isClone.put(ReAssigningCustoms.Name+' parent', ReAssigningCustoms.isClone__c);
                    settingInfosOut.map_objectAPI_isCopy.put(ReAssigningCustoms.Name+' parent', ReAssigningCustoms.IsOutBusiness_Copy__c);
                }
                  flag=false;   
            }
                       
                }  
        }
        }
    }
    
    /**
    * This method used to get query String for related record
    *
    @param    
    *
    @return    void
    *
    @changelog
    * 2015-11-17 Ishita Bhardwaj <ishita_bhardwaj@infosys.com>
    * -Created
    * 
    */
    public static void getQueryString(list<ReAssigning_Related_Records__c> list_ReAssigningCustoms, ReAssigningSettingInfos settingInfos, map<String, String> map_accId_successorCompany) {     
        
        String sql = '';
        String RequireField = '';
        set<String> set_accIds = new set<String>();
        
        set_accIds.addAll(map_accId_successorCompany.keySet());
        for(ReAssigning_Related_Records__c ReAssigningCustoms : list_ReAssigningCustoms) {       
            List<String> parentList=new List<String>();
            if(ReAssigningCustoms.Parent_API__c!=null && ReAssigningCustoms.Parent_API__c!='' && ReAssigningCustoms.IsDuplicate__c && ReAssigningCustoms.Name != 'Partner' )
                {
                    if(ReAssigningCustoms.Parent_API__c.contains(','))
                    {                        
                        parentList=ReAssigningCustoms.Parent_API__c.split(',');
                    } 
                     else   
                     {parentList.add(ReAssigningCustoms.Parent_API__c);  }
                }
                boolean flag=true;
            for(String parent: parentList){
                system.debug(',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,'+parent);
            sql = ((parent != null && parent != '' ) ? ( (ReAssigningCustoms.Require_Field__c != null && ReAssigningCustoms.Require_Field__c != '')? 
                    ('select ' + parent + ',' + ReAssigningCustoms.Require_Field__c) : 
                    ('select ' + parent)) : '');
            if(sql != '' && ReAssigningCustoms.Name != 'Account ReAssign Scheduled Job Id' 
                && ReAssigningCustoms.Name != 'Account ReAssign Batch Class Id' && ReAssigningCustoms.Name != 'BatchNum' && ReAssigningCustoms.Name != 'Partner' ) {
                // the query String
               
                sql += ' from ' + ReAssigningCustoms.Name + ' where ' + parent + ' IN :  set_accIds ' ;   
               
                if( ReAssigningCustoms.Filter_Clause__c !='' && + ReAssigningCustoms.Filter_Clause__c != null ){                   
                  //  sql += ReAssigningCustoms.Filter_Clause__c +' ';                     
                }
                 if(ReAssigningCustoms.Name=='Lead' )
                 { sql += 'And IsConverted=false ';}
                if(ReAssigningCustoms.Name == 'FeedItem') {
                    sql += ReAssigningCustoms.Filter_Clause__c +' ';
                }
         
                if(flag)
                { 
                    settingInfos.map_objectAPI_Sql.put(ReAssigningCustoms.Name, sql);
                    settingInfos.map_objectAPI_parentAPI.put(ReAssigningCustoms.Name, parent);
                    settingInfos.map_objectAPI_isClone.put(ReAssigningCustoms.Name, ReAssigningCustoms.isClone__c);
                    settingInfos.map_objectAPI_isCopy.put(ReAssigningCustoms.Name, ReAssigningCustoms.IsDuplicate_Copy__c);
                 }
                else
                {
                    settingInfos.map_objectAPI_Sql.put(ReAssigningCustoms.Name+' parent', sql);
                    settingInfos.map_objectAPI_parentAPI.put(ReAssigningCustoms.Name+' parent', parent);
                    settingInfos.map_objectAPI_isClone.put(ReAssigningCustoms.Name+' parent', ReAssigningCustoms.isClone__c);
                    settingInfos.map_objectAPI_isCopy.put(ReAssigningCustoms.Name+' parent', ReAssigningCustoms.IsDuplicate_Copy__c);
                }
                    flag=false;
                }}
        }
    }
    
    
    
    
    public static void getQueryString_InactiveCheck(list<ReAssigning_Related_Records__c> list_ReAssigningCustoms, ReAssigningSettingInfos settingInfos, set<String> set_accIds) {     
        
        String sql = '';
        String RequireField = '';
        //set<String> set_accIds = new set<String>();        
        //set_accIds.addAll(map_accId_successorCompany.keySet());
        for(ReAssigning_Related_Records__c ReAssigningCustoms : list_ReAssigningCustoms) {       
            List<String> parentList=new List<String>();
            if(ReAssigningCustoms.Parent_API__c!=null && ReAssigningCustoms.Parent_API__c!='' && ( ReAssigningCustoms.IsDuplicate__c || ReAssigningCustoms.IsOutBusiness__c) && ReAssigningCustoms.Name != 'Partner')
                {
                    if(ReAssigningCustoms.Parent_API__c.contains(','))
                    {                        
                        parentList=ReAssigningCustoms.Parent_API__c.split(',');
                    } 
                     else   
                     {parentList.add(ReAssigningCustoms.Parent_API__c);  }
                }
                boolean flag=true;
            for(String parent: parentList){
                system.debug(',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,'+parent);
            sql = ((parent != null && parent != '' ) ? ( (ReAssigningCustoms.Require_Field__c != null && ReAssigningCustoms.Require_Field__c != '')? 
                    ('select OwnerId,' + parent + ',' + ReAssigningCustoms.Require_Field__c) : 
                    ('select OwnerId,' + parent)) : '');
            if(sql != '' && ReAssigningCustoms.Name != 'Account ReAssign Scheduled Job Id' 
                && ReAssigningCustoms.Name != 'Account ReAssign Batch Class Id' && ReAssigningCustoms.Name != 'BatchNum' 
                && ReAssigningCustoms.Name != 'AccountContactRole' && ReAssigningCustoms.Name != 'AccountTeamMember'
                && ReAssigningCustoms.Name != 'Competitor__c' && ReAssigningCustoms.Name !=  'Additional_Attending_Account__c' && ReAssigningCustoms.Name != 'Partner') {
                // the query String               
               
                sql += ' from ' + ReAssigningCustoms.Name + ' where ' + parent + ' IN :  set_accIds ' ;
                
                if( ReAssigningCustoms.Filter_Clause__c !='' && + ReAssigningCustoms.Filter_Clause__c != null && !ReAssigningCustoms.IsDuplicate__c && ReAssigningCustoms.IsOutBusiness__c ){                   
                    sql += ReAssigningCustoms.Filter_Clause__c +' ';                     
                }
                 if(ReAssigningCustoms.Name=='Lead' )
                 { sql += 'And IsConverted=false ';}
                if(ReAssigningCustoms.Name == 'FeedItem') {
                    sql += ReAssigningCustoms.Filter_Clause__c +' ';
                }
                
                if(flag)
                { 
                    settingInfos.map_objectAPI_Sql.put(ReAssigningCustoms.Name, sql);
                    settingInfos.map_objectAPI_parentAPI.put(ReAssigningCustoms.Name, parent);
                    settingInfos.map_objectAPI_isClone.put(ReAssigningCustoms.Name, ReAssigningCustoms.isClone__c);
                    settingInfos.map_objectAPI_isCopy.put(ReAssigningCustoms.Name, ReAssigningCustoms.IsDuplicate_Copy__c);
                 }
                else
                {
                    settingInfos.map_objectAPI_Sql.put(ReAssigningCustoms.Name+' parent', sql);
                    settingInfos.map_objectAPI_parentAPI.put(ReAssigningCustoms.Name+' parent', parent);
                    settingInfos.map_objectAPI_isClone.put(ReAssigningCustoms.Name+' parent', ReAssigningCustoms.isClone__c);
                    settingInfos.map_objectAPI_isCopy.put(ReAssigningCustoms.Name+' parent', ReAssigningCustoms.IsDuplicate_Copy__c);
                }
                    flag=false;
                }}
        }
    }
    
    
    /**
    * This method used to run the schedule Job
    *
    @param    
    @return    void
    @changelog
    * 2014-10-21 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    * 
    * 2015-11-17 Ishita Bhardwaj <ishita_bhardwaj@infosys.com>
    * -Created
    */  
   
    public static void batchToReAssignAccount(String status,Set<Id> SafeIsland ) {
 // update the custom setting for the schedule Job record
     system.debug('***************Inside cls batch****************');
        String apexClassId = '';
        Boolean isBatch = false;
        String BatchNum = '';
        String jobRunTime = '';
        
        if(ReAssigning_Related_Records__c.getInstance('Account ReAssign Batch Class Id') != null 
            && ReAssigning_Related_Records__c.getInstance('Account ReAssign Batch Class Id').value__c != null) {
                
            apexClassId = ReAssigning_Related_Records__c.getInstance('Account ReAssign Batch Class Id').value__c;
        } 
        
        if(ReAssigning_Related_Records__c.getInstance('BatchNum') != null 
            && ReAssigning_Related_Records__c.getInstance('BatchNum').value__c != null) {
                
            BatchNum = ReAssigning_Related_Records__c.getInstance('BatchNum').value__c;
        } 
        
        BatchNum = (BatchNum == '' ? String.valueOf(10) : BatchNum);
         
        if(apexClassId != '') {
            list<AsyncApexJob> list_apexJobs = new list<AsyncApexJob>();
            for(AsyncApexJob apexJob : [SELECT ApexClassId, JobType, Status FROM AsyncApexJob 
                                        where JobType = 'BatchApex' And (Status = 'Processing' OR Status = 'Preparing')]) {
                if(apexJob.ApexClassId == apexClassId ) {
                    isBatch = true;
                    system.debug('***************Apex job queue****************');
                }
                list_apexJobs.add(apexJob);
            }
            if(!isBatch && ReAssigning_Related_Records__c.getInstance('Account ReAssign Scheduled Job Id') != null) {
                ReAssigning_Related_Records__c setting = ReAssigning_Related_Records__c.getInstance('Account ReAssign Scheduled Job Id');
                if(setting.value__c == null || setting.value__c == '') {                    
                    if(list_apexJobs.size() < 5 ){    
                    system.debug('***************Calling batch from cls****************');    
                    system.debug('***************Calling cls batch BAtch nummm****************'+ Integer.ValueOf(BatchNum));                  
                        ClsBatch_reAssignAccount batchJob = new ClsBatch_reAssignAccount(status, SafeIsland);
                      system.debug('***************returning to cls****************');   
                         
                        Database.executeBatch(batchJob, Integer.ValueOf(BatchNum));   
                         system.debug('***************after execute****************');                                 
                    }else if(list_apexJobs.size() >= 5) {  
                    system.debug('***************Calling cls scheduler****************');  
                        if(ReAssigning_Related_Records__c.getInstance('JobRunTime') != null 
                            && ReAssigning_Related_Records__c.getInstance('JobRunTime').value__c != null) {
                            jobRunTime = ReAssigning_Related_Records__c.getInstance('JobRunTime').value__c;
                        }                       
                        jobRunTime = (jobRunTime == '' ? String.valueOf(2) : jobRunTime);
                                    
                        DateTime currTime = DateTime.now();
                        currTime = currTime.addMinutes(Integer.ValueOf(jobRunTime));
                        Integer min = currTime.minute();
                        Integer hour = currTime.hour();
                        Integer day = currTime.day();
                        Integer month = currTime.month();
                        String dayOfWeek= currTime.format('EEEE').subString(0, 3);
                        Integer year = currTime.year();
                        String sch = '0 ' + min + ' ' + hour + ' ' + day + ' ' + month + ' ? ' + year;
                        ClsScheduled_reAssignAccount cls = new ClsScheduled_reAssignAccount(status, SafeIsland );
                       String jobId = system.schedule('ClsScheduled_fetchReAssignAccount for ' + sch, sch, cls);
                      setting.value__c = jobId;
                      update setting;        
                    }
                }
            }           
        }                
     }
    
     /**
    * This method used to abort the schedule Job
    *
    @param    
    @return    void
    @changelog
    * 2014-10-21 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static void abortScheduledJobToReAssignAccount() {
        // abort the schedule Job and clear the custom setting record
        if(ReAssigning_Related_Records__c.getInstance('Account ReAssign Scheduled Job Id') != null) {
            ReAssigning_Related_Records__c setting = ReAssigning_Related_Records__c.getInstance('Account ReAssign Scheduled Job Id');
            if(setting.value__c != null && String.valueOf(setting.value__c).trim() != '') {
                system.abortJob(setting.value__c);
                setting.value__c = '';
                update setting;
            }       
        }              
     }
    
    //********************************* -=BEGIN inner classes=- ***********************************/
    public class ReAssigningSettingInfos{ 
        
        public map<String, String> map_objectAPI_Sql{get;set;}
        public map<String, String> map_objectAPI_parentAPI{get;set;}
        public map<String, Boolean> map_objectAPI_isClone{get;set;}
        public map<String, Boolean> map_objectAPI_isCopy{get;set;}

        public ReAssigningSettingInfos(map<String, String> map_objectAPI_Sql, map<String, String> map_objectAPI_parentAPI, map<String, Boolean> map_objectAPI_isClone, map<String, Boolean> map_objectAPI_isCopy) {
            this.map_objectAPI_Sql = map_objectAPI_Sql;
            this.map_objectAPI_parentAPI = map_objectAPI_parentAPI;
            this.map_objectAPI_isClone = map_objectAPI_isClone;    
            this.map_objectAPI_isCopy = map_objectAPI_isCopy; 
        }
        public ReAssigningSettingInfos() {
            this.map_objectAPI_Sql = new map<String, String>();
            this.map_objectAPI_parentAPI = new map<String, String>();
            this.map_objectAPI_isClone = new map<String, Boolean>();    
            this.map_objectAPI_isCopy = new map<String, Boolean>(); 
        }
    }
    //********************************* -=END inner classes=- ***********************************/
}