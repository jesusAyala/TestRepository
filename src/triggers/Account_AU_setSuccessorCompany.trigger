/**
 *  set Successor Company
 * 
 * @author Lili Zhao
 * @version 1.0
 * @since 29.0
 * 
 * @changelog
 * 2014-11-18 Lili Zhao <lili.zhao@itbconsult.com>
 * - Created   
 * 2015-11-17 Ishita Bhardwaj <ishita_bhardwaj@infosys.com>
 * - changed
 */
trigger Account_AU_setSuccessorCompany on Account (after update) {
If( (ClsAccountUtil.isUpdate) && !System.label.SYS_RunAccountTrigger.equalsIgnoreCase('NO')){
    system.debug('::MR:: Account Merge Trigger !' );
    map<String, String> map_accId_successorCompany = new map<String, String>(); //map to store duplicate accounts and successors
    map<string,string> map_accId_successorCompany_Out=new map<String, String>(); //map to store out of business accounts and successors
    list<Account> list_updateAcc = new list<Account>();
    boolean check=true;
    
     /*-- 
       Modified  : Abiramasundari Radha(Accenture)
       Date : 25/03/2016
       Replaced the Hardcoded value(Account Record type name) with the custom Label    
   */
    
    //fetching record type Ids
    Id GISApprovedID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get(System.label.Sys_Account_RecordType_GIS_Approved).getRecordTypeId();
    Id DefaultID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get(System.label.Sys_Account_RecordType_Default).getRecordTypeId();
    Id EXtNonBuyingID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get(System.label.Sys_Account_Record_Type_Ext_Non_Buying).getRecordTypeId();
    Id IcvID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get(System.label.Sys_Account_Record_Type_ABB_ICV).getRecordTypeId();
    Id ReadOnID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get(System.label.Sys_Account_Record_Type_Read_Only).getRecordTypeId();

    set<Id> cmpId = new set<Id>();
    set<Id> succmpId = new set<Id>();
    set<Id> ExtAccId = new set<Id>();
    //fetching custom setting for current user
    Validation_Override__c vc=Validation_Override__c.getInstance(UserInfo.getUserId());
    Boolean exclude=vc.Exclude__c;    
    
    set<Id> successorIds = new set<Id>();
    for (Account acc : Trigger.new) {
        if(acc.Successor_Company__c != null && (trigger.oldMap.get(acc.Id).get('RecordTypeId') != ReadOnID) )
        {
            successorIds.add(acc.Successor_Company__c);                 
        }
    }    
    Map<Id, Account> AccountSuccMap = new Map<Id, Account>([Select Id, RecordTypeId from Account where id in : successorIds]);   
   
    for (Account account : Trigger.new) {         
        //check if record type is not being changed by a normal user[other than systemadmin and integration user]              
        //check if GIS has assigned a successor       
          /** Account Merge Conditions **/
          
          Boolean PrimaryIsImmediate = False;
          Boolean IsImmediate = False;
          Boolean GoesApproval = False;
          
          /** Primary Is Immediate Condition **/
          
          if((ClsAccountUtil.isUpdate) && (check) && (trigger.oldMap.get(account.Id).get('RecordTypeId') != ReadOnID)           
            && (account.Successor_Company__c != null) 
            && (account.Successor_Company__c != account.Id)          
            && (account.Reason_for_Deactivation__c == 'Out of Business' || account.Reason_for_Deactivation__c == 'Duplicate') 
            && (account.Reassignment_Pending__c == false) 
            && (!UserInfo.getName().contains('GIS Integration')))
            {
                PrimaryIsImmediate = True;              
            }
            
            
            system.debug('::MR::Account Merge::Parameters::'+ClsAccountUtil.isUpdate);
            system.debug('::MR::Account Merge::Parameters::'+check );
            system.debug('::MR::Account Merge::Parameters::'+trigger.oldMap.get(account.Id).get('RecordTypeId') + account.RecordTypeId );
            system.debug('::MR::Account Merge::Parameters::'+account.Successor_Company__c);
            system.debug('::MR::Account Merge::Parameters::'+account.Reason_for_Deactivation__c );
            system.debug('::MR::Account Merge::Parameters::'+account.Reassignment_Pending__c);            
            system.debug('::MR::Account Merge::Parameters::'+UserInfo.getName().contains('GIS Integration'));
            system.debug('::MR::Account Merge::Parameters::'+UserInfo.getName().contains('Data Cleansing'));
            system.debug('::MR::Account Merge::PrimaryIsImmediate ::'+PrimaryIsImmediate );
          /** Non-Buying - Successor Account GIS Approved **/
          if(PrimaryIsImmediate == True
            && trigger.oldMap.get(account.Id).get('RecordTypeId') == EXtNonBuyingID
            && AccountSuccMap.get(account.Successor_Company__c).RecordTypeId == DefaultID           
            )
            {
                IsImmediate = True;                            
            }
            else if(PrimaryIsImmediate == True
            && trigger.oldMap.get(account.Id).get('RecordTypeId') == EXtNonBuyingID
            && AccountSuccMap.get(account.Successor_Company__c).RecordTypeId == GISApprovedID          
            )
            {
                IsImmediate = True;                           
            }
            else if(PrimaryIsImmediate == True
            && trigger.oldMap.get(account.Id).get('RecordTypeId') == EXtNonBuyingID
            && AccountSuccMap.get(account.Successor_Company__c).RecordTypeId == EXtNonBuyingID
            )
            {
                IsImmediate = True;                             
            }
                                 
            
           if(ClsAccountUtil.isUpdate && check && (trigger.oldMap.get(account.Id).get('RecordTypeId') != ReadOnID)           
            && account.Successor_Company__c != null 
            && account.Successor_Company__c != account.Id
            && trigger.oldMap.get(account.Id).get('RecordTypeId') == GISApprovedID
            && AccountSuccMap.get(account.Successor_Company__c).RecordTypeId == GISApprovedID
            && account.Reassignment_Pending__c == false 
            && (UserInfo.getName().contains('GIS Integration'))
          )
          {
              GoesApproval = True;                          
          }
          else if(ClsAccountUtil.isUpdate && check && (trigger.oldMap.get(account.Id).get('RecordTypeId') != ReadOnID)            
            && account.Successor_Company__c != null 
            && account.Successor_Company__c != account.Id
            && trigger.oldMap.get(account.Id).get('RecordTypeId') == DefaultID
            && AccountSuccMap.get(account.Successor_Company__c).RecordTypeId == GISApprovedID
            && account.Reassignment_Pending__c == false 
            && (UserInfo.getName().contains('GIS Integration'))
          )
          {
              GoesApproval = True;                          
          }
          
          if(IsImmediate){system.debug('::MR::'+IsImmediate);}
          if(GoesApproval){system.debug('::MR::'+GoesApproval);}          
         
          if(IsImmediate)
          {
              if(account.Reason_for_Deactivation__c == 'Duplicate') 
              {              
                map_accId_successorCompany.put(account.Id, account.Successor_Company__c);
                cmpId.add(account.Id);
                succmpId.add(account.Successor_Company__c);
                if(account.recordTypeID == EXtNonBuyingID)
                {ExtAccId.add(account.Id);}
              }
             else if(account.Reason_for_Deactivation__c == 'Out of Business')
             {                
                map_accId_successorCompany_Out.put(account.Id, account.Successor_Company__c);               
                cmpId.add(account.Id);
                succmpId.add(account.Successor_Company__c);
                if(account.recordTypeID == EXtNonBuyingID)
                {ExtAccId.add(account.Id);}
              }
          }
          
          if(GoesApproval)
          {  
             
              if(account.Company_Status__c == 'Duplicate') 
              {                
                map_accId_successorCompany.put(account.Id, account.Successor_Company__c);
                cmpId.add(account.Id);
                succmpId.add(account.Successor_Company__c); 
                if(account.recordTypeID == EXtNonBuyingID)
                {ExtAccId.add(account.Id);}
              }
              else if(account.Company_Status__c == 'Out of Business')
             {
                map_accId_successorCompany_Out.put(account.Id, account.Successor_Company__c);                
                cmpId.add(account.Id);
                succmpId.add(account.Successor_Company__c);
                if(account.recordTypeID == EXtNonBuyingID)
                {ExtAccId.add(account.Id);}
              }
          }
        
    }   
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
   
    
    //call batch or util class to reassign accounts
    
    system.debug('**SF**cmpId'+cmpId.size());
    system.debug('**SF**succmpId'+succmpId.size());
    
    Map<Id,Safe_Island_Assessments__c> IslandMap = new Map<Id,Safe_Island_Assessments__c>([Select Id,PG__c,Country__c,CreditAssesmentPriority__c,AccountCustomer__c from Safe_Island_Assessments__c where AccountCustomer__c IN : cmpId]);
    
    Map<String, List<Safe_Island_Assessments__c>> lstSImap = new   Map<String, List<Safe_Island_Assessments__c>>();
     
    for(Safe_Island_Assessments__c sInd : IslandMap.values()) 
    {
        if(!lstSImap.ContainsKey(sInd.AccountCustomer__c))
        {
            lstSImap.put(sInd.AccountCustomer__c, new List<Safe_Island_Assessments__c>());
        }
        lstSImap.get(sInd.AccountCustomer__c).add(sInd);      
    
    }  
    
    Map<String,Safe_Island_Assessments__c> IslandSucMap = new Map<String,Safe_Island_Assessments__c>();    
    Map<Id,Safe_Island_Assessments__c> IslandOutMap = new Map<Id,Safe_Island_Assessments__c>([Select Id,PG__c,Country__c,CreditAssesmentPriority__c,AccountCustomer__c from Safe_Island_Assessments__c where AccountCustomer__c IN : succmpId]);
    for(Safe_Island_Assessments__c sInd : IslandOutMap.values()) 
    {
        IslandSucMap.put(sInd.PG__c+sInd.Country__c+sInd.AccountCustomer__c , sInd);
    }
    
    Map<Id, Account> AccountMap = new Map<Id, Account>([Select Id,Successor_Company__c, RecordTypeId from Account where id in : cmpId]);   
    
    set<Id> safeIsland  = new set<Id>();
    set<Id> safeIslanddel  = new set<Id>();
    for(Account strid : AccountMap.values())
    {     
        List<Safe_Island_Assessments__c>  lstsafe =  new    List<Safe_Island_Assessments__c>();
        if(lstSImap != null && lstSImap.get(strid.Id) != null)     
        {
            lstsafe.addall(lstSImap.get(strid.Id)); 
        }            
        
        for(Safe_Island_Assessments__c s : lstsafe)        
        {   
           if(IslandSucMap.ContainsKey(s.PG__c+s.Country__c+strid.Successor_Company__c))
           {  
              String strchildid = IslandSucMap.get(s.PG__c+s.Country__c+strid.Successor_Company__c).Id;
              Integer intchildrating = Integer.valueOf(IslandSucMap.get(s.PG__c+s.Country__c+strid.Successor_Company__c).CreditAssesmentPriority__c);
              Integer intparentrating = Integer.valueOf(s.CreditAssesmentPriority__c);
              if( intparentrating != 0)
              {
                  if(intparentrating == intchildrating )
                  { safeIsland.add(s.Id);}              
                  else if(intparentrating > intchildrating)
                  { safeIsland.add(s.Id);}
                  else
                  {
                      safeIslanddel.add(strchildid);
                  }
             }
              
           }
            
        }        
        
    }
           
    String ErrContactRoleMsg ='';
    String ErrDupeMsg ='';
    if(accSet.size()>0)
    {System.debug('**MR**Dupchk**');
      ErrDupeMsg =  ClsAccountUtil.setSuccessorCompany_InactiveCheck(map_accId_successorCompany,map_accId_successorCompany_Out);
    }
    
    if (ErrDupeMsg != '')
    {
        for (Account account : Trigger.new) 
        {
            account.AddError('The transaction contains records with inactive owner. Please request Local Admin to update the owner to an active user, and then re-initiate the merge. Following record(s) have inactive owner:     '+ErrDupeMsg);
        }
        
    }
    else
    {
        
        if((accSet.size()>0))
        {
            try
            {        
         
            system.debug('**MR**Merge**0');
            if((map_accId_successorCompany.size() < 2 && map_accId_successorCompany_Out.size() < 2)  )
            {
                system.debug('**MR**Merge**1'+map_accId_successorCompany.size()+map_accId_successorCompany_Out.size()); 
                ClsAccountUtil.setSuccessorCompany(map_accId_successorCompany,map_accId_successorCompany_Out, safeIsland);
            }
            else if(map_accId_successorCompany_Out.size()>=2 && map_accId_successorCompany.size()<2)
            { 
                system.debug('**MR**Merge**2'+map_accId_successorCompany.size()+map_accId_successorCompany_Out.size());
                if(map_accId_successorCompany.size()>0)
                {
                map_accId_successorCompany_Out=new map<string,string>();
                ClsAccountUtil.setSuccessorCompany(map_accId_successorCompany,map_accId_successorCompany_Out, safeIsland);
                }
                //system.debug('***************Calling cls batch****************');
                
                ClsAccountUtil.batchToReAssignAccount('Out Of Business', safeIsland);
                //system.debug('***************AFter calling cls batch****************');
            
            }
            else if(map_accId_successorCompany.size()>=2 && map_accId_successorCompany_Out.size()<2)
            {system.debug('**MR**Merge**3'+map_accId_successorCompany.size()+map_accId_successorCompany_Out.size());
                if(map_accId_successorCompany_Out.size()>0)
                {
                map_accId_successorCompany=new map<string,string>();
                ClsAccountUtil.setSuccessorCompany(map_accId_successorCompany,map_accId_successorCompany_Out, safeIsland);
                }
                ClsAccountUtil.batchToReAssignAccount('Duplicate',safeIsland );
            }
            
           List<Safe_Island_Assessments__c> lstisland = [Select Id from Safe_Island_Assessments__c where id IN : safeIslanddel];    
           delete lstisland; 
           
            List<Account> lstacc = [Select Id,RecordTypeId, Successor_Company__c,Reason_for_Deactivation__c  from Account where id IN : ExtAccId];             
            for(Account acc : lstacc)
            {               
                acc.Active__c= False;                
                acc.RecordTypeId = ReadOnID;                            
            }   
            if(lstacc.size() > 0) {
            ClsAccountUtil.isUpdate = false;
            ClsAccountUtil.isExtUpdate = false;           
            update lstacc;                      
            } 
            

            }
            Catch(DmlException e) {                
            ErrContactRoleMsg = e.getMessage();
            }            
            
            if (ErrContactRoleMsg  != '')
            {            
                String errmsg = '';                
                errmsg = ErrContactRoleMsg;                 
                           
                for (Account account : Trigger.new) 
                {
                    account.AddError(errmsg );
                }           
                
            }           
            
            
        
        }
        
    
    }
    
    User[] usrfnl = [Select Id, AccountMerge_Override__c from User where id =: UserInfo.getUserId() ];
    usrfnl[0].AccountMerge_Override__c = False;
    Update usrfnl;
    
    ClsAccountUtil.isAccMergeFlag = False;
    //ClsAccountUtil.isAccTriggerFlag = False;
    
    
    }    
   
}