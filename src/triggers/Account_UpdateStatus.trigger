trigger Account_UpdateStatus on Account ( before update) {
If((ClsAccountUtil.isUpdate) && !System.label.SYS_RunAccountTrigger.equalsIgnoreCase('NO')){
/*-- 
       Modified  : Abiramasundari Radha(Accenture)
       Date : 25/03/2016
       Replaced the Hardcoded value(Account Record type name) with the custom Label    
   */

Set<ID> setAccountId = new Set<ID>();
Set<string> setEmailId = new Set<string>();
Map<String,Id> mapUserEmail = new Map<String,Id>();
List<Account> acc1 = new List<Account>();

// system.debug('::::trgCtx.newList'+trgCtx.newList);
for (Account acc : Trigger.new) {   
 //   system.debug('::::inside for'+so);
    //Account acc = (Account)so;
    Account oldAcc = (Trigger.isUpdate) ? (Account) Trigger.oldmap.get(acc.Id) : null;

    if(acc.Primary_Account_Manager__c != oldAcc.Primary_Account_Manager__c) {
        setAccountId.add(acc.Id);
        setEmailId.add(acc.Primary_Account_Manager__c);
        acc1.add(acc);
      //  system.debug(':::setEmailId:::'+setEmailId);
    }
}
Integer remLimit1 =  limits.getLimitQueryRows() - limits.getQueryRows();
if(setEmailId.size() > 0) {
   
    for(User usr : [SELECT Id, Name, Email, isActive FROM User WHERE Email IN :setEmailId LIMIT :remLimit1]) {
        if(usr.isActive){
            mapUserEmail.put(usr.Email,usr.Id);
        }                    
     // system.debug(':::mapUserEmail:::'+mapUserEmail);
    }   
    
    for(Account accList : acc1) {
        if(accList.Primary_Account_Manager__c == NULL || (!mapUserEmail.containsKey(accList.Primary_Account_Manager__c))) {
            accList.Key_Account_Manager__c = NULL;          
       // system.debug(':::accList.Key_Account_Manager__c:::'+accList.Key_Account_Manager__c);
        }
        else
        {
            if(mapUserEmail.containsKey(accList.Primary_Account_Manager__c)) {
                accList.Key_Account_Manager__c = mapUserEmail.get(accList.Primary_Account_Manager__c);              
           // system.debug(':::accList.Key_Account_Manager__c:::'+accList.Key_Account_Manager__c);
            }                    
        }
    }  
                
}   

Set<Id> processedIdSet = new Set<Id>();     
Set<ID> accountIds = new Set<ID>();       
List<Account> processList = new List<Account>();
ID sysAdminProfileId = Label.CL00075;        
Id GISProfId = Label.Sys_ABB_GIS_Integration_Profile_Id;
for (Account acc : Trigger.new) {
    
    if (!processedIdSet.contains(acc.ID) && sysAdminProfileId  != Userinfo.getProfileid() && GISProfId != Userinfo.getProfileid()) { 
    
        processedIdSet.add(acc.Id);  
        accountIds.add(acc.Id);
        processList.add(acc);                
    }

}

if (processList.size() > 0) {
    
    Map<id,List<AccountTeamMember>> ATMMap = new Map<id,List<AccountTeamMember>>();
    Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();   
    
    for(AccountTeamMember atmLoop  : [Select AccountAccessLevel, AccountId,IsDeleted,TeamMemberRole,UserId From AccountTeamMember 
        where AccountID in :accountIds LIMIT :remLimit]){
        
        if(ATMMap.containskey(atmloop.AccountId))
        {                
            list<AccountTeamMember> lst = ATMMap.get(atmloop.AccountId);
            lst.add(atmloop);
            ATMMap.put(atmloop.AccountId,lst);
        }
        else
        {
            list<AccountTeamMember> lst = new list<AccountTeamMember>();
            lst.add(atmLoop);
            ATMMap.put(atmloop.AccountId,lst);
        }
     
    }
    
    for (Account acc: processList) {
       
        Account oldAccount = (Account) Trigger.oldmap.get(acc.Id);
       
        boolean isexist = False;
        if(ATMMap != null && ATMMap.size() >0) {
            list<AccountTeamMember> lst = ATMMap.get(acc.Id);
            if(lst != null && lst.size() >0 ) {
                for(AccountTeamMember am : lst)
                {
                 if(UserInfo.getUserId() == am.UserId)
                 { isexist = True; }
                
                }
            }
        }
            
           
        if(((oldAccount.Leading_Business_Partner_Segment__c != acc.Leading_Business_Partner_Segment__c) ||
            (oldAccount.Channel_Class__c != acc.Channel_Class__c) ||

            oldAccount.Channel_Class_Level2__c != acc.Channel_Class_Level2__c ||            
            oldAccount.Channel_Class_Level1__c != acc.Channel_Class_Level1__c ||

            oldAccount.ABB_Business_Partner_Segment_Level1__c != acc.ABB_Business_Partner_Segment_Level1__c ||
            oldAccount.ABB_Business_Partner_Segment_Level2__c != acc.ABB_Business_Partner_Segment_Level2__c ||

            oldAccount.ABB_Industry_Usage_Level1__c != acc.ABB_Industry_Usage_Level1__c ||
            oldAccount.ABB_Industry_Usage_Level2__c != acc.ABB_Industry_Usage_Level2__c ||
            oldAccount.ABB_Industry_Usage_Level3__c != acc.ABB_Industry_Usage_Level3__c ||

            oldAccount.Reason_for_Deactivation__c != acc.Reason_for_Deactivation__c ||

            oldAccount.Successor_Company__c != acc.Successor_Company__c ||
            oldAccount.Primary_Account_Manager__c!= acc.Primary_Account_Manager__c||

            (oldAccount.Active__c != acc.Active__c) ||
            (oldAccount.Industry__c != acc.Industry__c) ||
            (oldAccount.Account_Type__c != acc.Account_Type__c ) ||
            (oldAccount.Code_of_Conduct__c != acc.Code_of_Conduct__c ) ||           
            (oldAccount.NDA__c != acc.NDA__c ) ||
            (oldAccount.ABB_Authorized_Provide__c != acc.ABB_Authorized_Provide__c) ||
            (oldAccount.Technical_Agreements__c != acc.Technical_Agreements__c) ||
            (oldAccount.Market_Development_Funds__c != acc.Market_Development_Funds__c) ||
            (oldAccount.GD43__c != acc.GD43__c) ||
            (oldAccount.Company_core_business_area__c != acc.Company_core_business_area__c) ||
            (oldAccount.Total_turnover__c != acc.Total_turnover__c) ||
            (oldAccount.Owner_structure__c != acc.Owner_structure__c) ||
            (oldAccount.Company_History__c != acc.Company_History__c) ||
            (oldAccount.Company_Description__c != acc.Company_Description__c) ||
            (oldAccount.Strengths__c != acc.Strengths__c) ||
            (oldAccount.Weaknesses__c != acc.Weaknesses__c) ||
            (oldAccount.Opportunities__c != acc.Opportunities__c) || 
            (oldAccount.Threats__c!= acc.Threats__c) ||        
            (oldAccount.Relationship_Status__c != acc.Relationship_Status__c) ||
            (oldAccount.Division_1__c != acc.Division_1__c) ||
     //    (oldAccount.Division_2__c != acc.Division_2__c) ||
           (oldAccount.Type_of_Agreements__c != acc.Type_of_Agreements__c))
     //    (oldAccount.Strategic_Key_Partner__c != acc.Strategic_Key_Partner__c))
              && acc.ownerid != UserInfo.getUserId() 
              && isexist == FALSE)  {
                
                
                acc.addError(System.label.System_CL00102);
        }    
    }
}
   
   
Id GISApprovedID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get(System.label.Sys_Account_RecordType_GIS_Approved).getRecordTypeId();
Id DefaultID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get(System.label.Sys_Account_RecordType_Default).getRecordTypeId();
Id EXtNonBuyingID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get(System.label.Sys_Account_Record_Type_Ext_Non_Buying).getRecordTypeId();
Id IcvID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get(System.label.Sys_Account_Record_Type_ABB_ICV).getRecordTypeId();
Id ReadOnID = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get(System.label.Sys_Account_Record_Type_Read_Only).getRecordTypeId();

User current_user=[SELECT alias FROM User WHERE Id= :UserInfo.getUserId()] ;
String userAlias= current_user.alias;

map<String, String> map_accId_successorCompany = new map<String, String>(); 
map<string,string> map_accId_successorCompany_Out=new map<String, String>();
set<Id> successorIds = new set<Id>();

for (Account a : Trigger.new) {
    if(a.Successor_Company__c != null && (a.recordTypeID != ReadOnID))
    {successorIds.add(a.Successor_Company__c);}
    if(a.Active__c==false)
    { 
        map_accId_successorCompany.put(a.Id, '');
        map_accId_successorCompany_Out.put(a.Id, '');
        
    }
}

Map<Id, Account> AccountSuccMap = new Map<Id, Account>();

if(ClsAccountUtil.isExtUpdate)
{
    List<Account> lstAcc = [Select Id, RecordTypeId from Account where id in : successorIds];
    for(Account accrec : lstAcc)
    {
        AccountSuccMap.put(accrec.Id, accrec);  
    }
}

for(Account acc:Trigger.new)
{
    Boolean PrimaryIsImmediate = False;
    Boolean IsImmediate = False;
    Boolean GoesApproval = False;
    
    System.debug('**MRUPDSTS***'+acc.Reassignment_Pending__c+ClsAccountUtil.isUpdate );
    
     if((ClsAccountUtil.isExtUpdate) && (acc.recordTypeID != ReadOnID) && acc.Successor_Company__c != null 
    && acc.Successor_Company__c != acc.Id           
    && (acc.Reason_for_Deactivation__c == 'Out of Business' || acc.Reason_for_Deactivation__c == 'Duplicate') 
    && acc.Reassignment_Pending__c == false 
    && (!UserInfo.getName().contains('GIS Integration'))    
    )
    {
        PrimaryIsImmediate = True;              
    }
    
    if(PrimaryIsImmediate == True
    && acc.recordTypeID == EXtNonBuyingID
    && AccountSuccMap.get(acc.Successor_Company__c).RecordTypeId == DefaultID           
    )
    {
        acc.Company_Status__c =  acc.Reason_for_Deactivation__c;    
        IsImmediate = True;
    }
    else if(PrimaryIsImmediate == True
    && acc.recordTypeID == EXtNonBuyingID
    && AccountSuccMap.get(acc.Successor_Company__c).RecordTypeId == GISApprovedID          
    )
    {
        acc.Company_Status__c =  acc.Reason_for_Deactivation__c;    
        IsImmediate = True;     
    }
    else if(PrimaryIsImmediate == True
    && acc.recordTypeID == EXtNonBuyingID
    && AccountSuccMap.get(acc.Successor_Company__c).RecordTypeId == EXtNonBuyingID
    )
    {
        acc.Company_Status__c =  acc.Reason_for_Deactivation__c;         
        IsImmediate = True;
    }
    
    
    if((ClsAccountUtil.isExtUpdate) && (acc.recordTypeID != ReadOnID) && acc.Successor_Company__c != null 
    && acc.Successor_Company__c != acc.Id
    && acc.recordTypeID == GISApprovedID
    && AccountSuccMap.get(acc.Successor_Company__c).RecordTypeId == GISApprovedID
    && acc.Reassignment_Pending__c == false 
    && (!UserInfo.getName().contains('GIS Integration'))    
    )
    {
      acc.Company_Status__c =  'Changed';                          
    }
    else if((ClsAccountUtil.isExtUpdate) && (acc.recordTypeID != ReadOnID) && acc.Successor_Company__c != null 
    && acc.Successor_Company__c != acc.Id
    && acc.recordTypeID == DefaultID
    && AccountSuccMap.get(acc.Successor_Company__c).RecordTypeId == GISApprovedID
    && acc.Reassignment_Pending__c == false 
    && (!UserInfo.getName().contains('GIS Integration'))    
    )
    {
      acc.Company_Status__c =  'Changed';                          
    }


   if((ClsAccountUtil.isExtUpdate) && (acc.recordTypeID != ReadOnID) && acc.Successor_Company__c != null 
    && acc.Successor_Company__c != acc.Id
    && acc.recordTypeID == GISApprovedID
    && AccountSuccMap.get(acc.Successor_Company__c).RecordTypeId == GISApprovedID
    && acc.Reassignment_Pending__c == false 
    && (UserInfo.getName().contains('GIS Integration'))
    && (acc.Company_Status__c == 'Out of Business' || acc.Company_Status__c == 'Duplicate')
    )
    {
      acc.Reason_for_Deactivation__c = acc.Company_Status__c;     
      GoesApproval = True;    
    }
    else if((ClsAccountUtil.isExtUpdate) &&(acc.recordTypeID != ReadOnID) && acc.Successor_Company__c != null 
    && acc.Successor_Company__c != acc.Id
    && acc.recordTypeID == DefaultID
    && AccountSuccMap.get(acc.Successor_Company__c).RecordTypeId == GISApprovedID
    && acc.Reassignment_Pending__c == false 
    && (UserInfo.getName().contains('GIS Integration'))
    && (acc.Company_Status__c == 'Out of Business' || acc.Company_Status__c == 'Duplicate')
    )
    {
      acc.Reason_for_Deactivation__c = acc.Company_Status__c;     
      GoesApproval = True;
    }
    
     //Boolean IsImmediate = False;
   // Boolean GoesApproval = False;
   
   if(IsImmediate || GoesApproval)
   {
        ClsAccountUtil.isAccMergeFlag = True;
        ClsAccountUtil.isAccTriggerFlag = True;
    
        User[] usr = [Select Id, AccountMerge_Override__c from User where id =: UserInfo.getUserId() ];
        usr[0].AccountMerge_Override__c = True;
        Update usr;
   }
    
    
    system.debug('**MR**STATUS**'+acc.Active__c+trigger.oldMap.get(acc.Id).get('Active__c')+acc.RecordTypeId);

    if(acc.Active__c==False && trigger.oldMap.get(acc.Id).get('Active__c') != acc.Active__c)
    {
    
        String ErrDupeMsg ='';
        if(map_accId_successorCompany.size()>0 || map_accId_successorCompany_Out.size()>0)
        {
          ErrDupeMsg =  ClsAccountUtil.setSuccessorCompany_InactiveCheck(map_accId_successorCompany,map_accId_successorCompany_Out);
        }
        
        if (ErrDupeMsg != '')
        {
            for (Account account : Trigger.new) 
            {
                account.AddError('The transaction contains records with inactive owner. Please request Local Admin to update the owner to an active user, and then re-initiate the Deactivation Request. Following record(s) have inactive owner:     '+ErrDupeMsg);
            }
            
        }
        
         if (acc.RecordTypeID == GISApprovedID && (UserInfo.getName().contains('GIS Integration'))) 
         {
             acc.RecordTypeId = ReadOnID;
         }
    
         if (acc.RecordTypeId != DefaultID && acc.RecordTypeID != GISApprovedID) 
         {
             acc.RecordTypeId = ReadOnID;
         }
         acc.Old_Record_Type__c = string.valueOf(trigger.oldMap.get(acc.Id).get('RecordTypeId'));
         
    }
    
    if((ClsAccountUtil.isExtUpdate) && acc.Active__c==true && trigger.oldMap.get(acc.Id).get('Active__c') != acc.Active__c)
    {     
               
        if(acc.Old_Record_Type__c == EXtNonBuyingID)
        {
            acc.RecordTypeId = EXtNonBuyingID;
            acc.Company_Status__c='Open';
            acc.Reason_for_Deactivation__c= null;
            acc.Successor_Company__c = null;
        }
        if(acc.Old_Record_Type__c == DefaultID)
        {
            acc.RecordTypeId = DefaultID;
            acc.Company_Status__c='Open';
            acc.Reason_for_Deactivation__c= null;
            acc.Successor_Company__c = null;
        }
        if(acc.Old_Record_Type__c == GISApprovedID)
        {
            acc.RecordTypeId = GISApprovedID;
            acc.Company_Status__c='Changed';
            acc.Reason_for_Deactivation__c= null;
            acc.Successor_Company__c = null;
        }
        if(acc.Old_Record_Type__c == IcvID)
        {
            //acc.RecordTypeId = ReadOnID;
            acc.Active__c = False;
        }
    }   
    
    
}


}


for (Account acct : Trigger.new) 
{   
    if(acct.Active__c==False && trigger.oldMap.get(acct.Id).get('Active__c') != acct.Active__c)
    {  
         acct.Old_Record_Type__c = string.valueOf(trigger.oldMap.get(acct.Id).get('RecordTypeId'));         
    }
}


}