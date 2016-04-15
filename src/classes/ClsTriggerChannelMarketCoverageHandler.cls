/**   
* TriggerClass on the Channel_Market_Coverage__c object
*       
* Release - R5 
 *  
 * @author  - Vasanthi (Accenture)
 * @created - 2016-2-16
 * @version - 1.0
 * @Description - Req #2182 (KAD-01000): To prevent the user, if they are trying to change already existing channel market scope if they are not account team member, Account Owner Local Administrator
 
* - Created

 * @author - Ayiravalli Arasu(Accenture)
 * @updated - 2016-2-19
 * @Description - Req #2742 : populate account common data section with high ranking channel market scope's relationship status and div values
*/
public without sharing class ClsTriggerChannelMarketCoverageHandler extends ClsTriggerVirtual {
 
/**   
* Constructor       
* Release - R5 
 *  
*/    
    public ClsTriggerChannelMarketCoverageHandler () {    
    }

/**   
* bulkBefore 
* Release - R5 
 *  
*/       
    public override void bulkBefore(ClsWrappers.TriggerContext trgCtx) {   
        if (trgCtx.isUpdate) {                       
            permissionChecking(trgCtx);
        }
    }
    
/**   
* @see after trigger 
* Release - R5 
 *  
*/      
   public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
        if(trgCtx.isInsert || trgCtx.isUpdate|| trgCtx.isDelete){
            relationshipStatusRanking(trgCtx);
        }
        
        if(trgCtx.isUpdate){
            updateChannelBusReview(trgCtx);
        }
    }
    
    public void updateChannelBusReview(ClsWrappers.TriggerContext trgCtx) {
        
        Set<Id> scopeIdSet = new Set<Id>();
        Map<Id, Channel_Market_Coverage__c> marketCoverageMap = new Map<Id, Channel_Market_Coverage__c>();
        List<Channel_Business_Review__c> cbrList = new List<Channel_Business_Review__c>();
        
        for (Sobject sobj: trgCtx.newList) {
            
            Channel_Market_Coverage__c channel = (Channel_Market_Coverage__c) sobj; 
            Channel_Market_Coverage__c oldchannel = (Channel_Market_Coverage__c) sobj;
            scopeIdSet.add(channel.Id);
            marketCoverageMap.put(channel.Id, channel);
        }
        
        if (scopeIdSet.size() > 0) {
            
            for ( Channel_Business_Review__c cbr: [SELECT ID, Joint_Business_Plan__r.Channel_Market_Coverage__c, Focused_Industry_hidden__c, Product_Line_Hidden_from_scope__c FROM Channel_Business_Review__c 
                WHERE Joint_Business_Plan__r.Channel_Market_Coverage__c IN: scopeIdSet ]) {
                
                cbr.Focused_Industry_hidden__c = marketCoverageMap.get(cbr.Joint_Business_Plan__r.Channel_Market_Coverage__c).Focussed_Industry1__c;
                cbr.Product_Line_Hidden_from_scope__c = marketCoverageMap.get(cbr.Joint_Business_Plan__r.Channel_Market_Coverage__c).Product_Line1__c ;
                cbrList.add( cbr );
            }
        }
        try {
            if (cbrList.size() > 0) {
               update cbrList; 
            }
        }Catch(DMLException e) {
            String error = '';
            for (Integer i = 0; i < e.getNumDML(); i++) {
                error += e.getDMLMessage(i) + System.label.Line_Break;
            }
            
            for (Sobject sob: trgCtx.newList ) {
                sob.addError(error, false);
            }
        }
    }
/**   
* Method permissionChecking
* Release - R5 
 *  
*/    
     public void permissionChecking(ClsWrappers.TriggerContext trgCtx) {
        
        Map<Id, Set<Id>> accIdAndAccTeamMemberIdSetMap = new Map<Id, Set<Id>>();
        Map<Id, Id> accIdAndOwnerIdMap = new Map<Id, Id> ();
        Set<ID> accountIdSet = new Set<ID>();
        Id abbBasicAdminProfileId ;
        Integer limitrow =  limits.getLimitQueryRows() - limits.getQueryRows(); 
        for (Sobject sobj: trgCtx.newList) {
            
            Channel_Market_Coverage__c channel = (Channel_Market_Coverage__c) sobj;   
            accountIdSet.add(channel.Account__c);            
        }
        
        if (accountIdSet.size() > 0) {
            
            Profile[] basicProf = [ SELECT ID, Name FROM Profile WHERE Name = :system.label.ABB_Basic_Admin_Profile_Name LIMIT :limitrow];
            abbBasicAdminProfileId = (basicProf != NULL && basicProf.size() > 0) ? basicProf[0].Id : NULL; 
            Id userProfileId = Userinfo.getProfileid();
            
         //   List<Account> accList = [ SELECT ID, OwnerID, (SELECT id, UserId, AccountId FROM AccountTeamMembers) FROM Account WHERE ID IN: accountIdSet];
            
            for (Account acc : [ SELECT ID, OwnerID, (SELECT id, UserId, AccountId FROM AccountTeamMembers) FROM Account WHERE ID IN: accountIdSet LIMIT :limitrow]) {
                
                accIdAndOwnerIdMap.put(acc.Id, acc.OwnerId);
                
                if (acc.AccountTeamMembers != NULL && acc.AccountTeamMembers.size() > 0) {
                    
                    for (AccountTeamMember team: acc.AccountTeamMembers) {
                        
                        if (!accIdAndAccTeamMemberIdSetMap.containsKey(team.AccountId)) {
                            
                            accIdAndAccTeamMemberIdSetMap.put(team.AccountId, new Set<ID>());
                        }
                        accIdAndAccTeamMemberIdSetMap.get(team.AccountId).add(team.USerId);
                    }                    
                }
            }
            
            ID currUser = UserInfo.getUSerId();
            //system.debug('::currUser :'+currUser );
            for (Sobject sobj: trgCtx.newList) {
            
                Channel_Market_Coverage__c channel = (Channel_Market_Coverage__c) sobj;   
                Set<ID> setAccTeamUserIds = accIdAndAccTeamMemberIdSetMap.get(channel.Account__c); 
                
                if(channel.Account__c != NULL && (setAccTeamUserIds == NULL || (setAccTeamUserIds != NULL && !setAccTeamUserIds.contains(currUser))) && currUser != accIdAndOwnerIdMap.get(channel.Account__c) && abbBasicAdminProfileId != userProfileId ){
                    channel.addError(System.label.System_CL00102);
                }           
            }
        }
    }
    
/**   
* Method relationshipStatusRanking
* Release - R5 
 *  
*/     
    Public void relationshipStatusRanking(ClsWrappers.TriggerContext trgCtx){
        
        Set<Id> setAccIds = new Set<Id>(); 
        Map<String,List<Channel_Market_Coverage__c>> mapAccAndRanking = new Map<String, List<Channel_Market_Coverage__c>>();
        List<Account> accListToUpdate = new List<Account>();
        
        List<Sobject> objList = (trgCtx.IsDelete) ? trgCtx.oldList : trgCtx.newList;
        
        for (Sobject sobj: objList ) {
                
                Channel_Market_Coverage__c cmc = (Channel_Market_Coverage__c) sobj; 
                Channel_Market_Coverage__c oldcmc = (trgCtx.isInsert) ? NULL : (Channel_Market_Coverage__c) trgCtx.oldMap.get(cmc.Id);
                 
                if ((trgCtx.IsInsert || trgCtx.IsDelete || ( trgCtx.IsUpdate && (oldcmc.Relationship_Status__c !=
                    cmc.Relationship_Status__c || oldcmc.Division__c != cmc.Division__c ||
                    oldcmc.Targeted_Key_Strategic__c != cmc.Targeted_Key_Strategic__c ||
                    oldcmc.Account__c != cmc.Account__c))) ) {
                    
                    if ( cmc.Account__c != NULL) {
                        setAccIds.add(cmc.Account__c);
                    }
                    
                    if ( trgCtx.IsUpdate && oldcmc.Account__c != NULL) {
                        setAccIds.add(oldcmc.Account__c);
                    }
                }
        }
        
        if(setAccIds != null && setAccIds.size() >0){
            
            Integer limitrow = Limits.getLIMITQueryRows() - Limits.getQueryRows();
            
            for (Channel_Market_Coverage__c chanMarkScope : [SELECT Id, Account__c, Relationship_Status__c, Division__c, Targeted_Key_Strategic__c FROM
                    Channel_Market_Coverage__c WHERE Account__c IN :setAccIds LIMIT :limitrow ]){
                   
                if(!mapAccAndRanking.containsKey(chanMarkScope.Account__c + chanMarkScope.Relationship_Status__c)) {
                    mapAccAndRanking.put(chanMarkScope.Account__c + chanMarkScope.Relationship_Status__c, new List<Channel_Market_Coverage__c>());
                }
                mapAccAndRanking.get(chanMarkScope.Account__c + chanMarkScope.Relationship_Status__c).add(chanMarkScope);
            }
        }
        
        if(setAccIds != null && setAccIds.size() >0){
            
            for (Id setIdIterate : setAccIds ){
            
                List<Channel_Market_Coverage__c> lstChanelScope = new List<Channel_Market_Coverage__c>(); 
                Set<String> setDivs = new Set<String>();
                String divValue =Null;
                
                
                if (mapAccAndRanking.containsKey(setIdIterate+Label.CMS_Relationship_Ranking1)){
                    
                    for(Channel_Market_Coverage__c chanMarkScopeIter : mapAccAndRanking.get(setIdIterate+Label.CMS_Relationship_Ranking1)) {
                        
                             lstChanelScope.add(chanMarkScopeIter);
                             divValue = chanMarkScopeIter.Division__c;
                             List<String> splitDivValues= DivValue.split(Label.System_CL00046); //semi colon
                             setDivs.addall(splitDivValues);
                    }  
                    
                }else if (mapAccAndRanking.containsKey(setIdIterate+Label.CMS_Relationship_Ranking2)){
                    
                    for(Channel_Market_Coverage__c chanMarkScopeIter : mapAccAndRanking.get(setIdIterate+Label.CMS_Relationship_Ranking2)) {
                        
                            lstChanelScope.add(chanMarkScopeIter);
                            divValue = chanMarkScopeIter.Division__c;
                            List<String> splitDivValues= DivValue.split(Label.System_CL00046); //semi colon
                            setDivs.addall(splitDivValues);
                    }
                       
                }else if(mapAccAndRanking.containsKey(setIdIterate+Label.CMS_Relationship_Ranking3)){
                
                    for(Channel_Market_Coverage__c chanMarkScopeIter : mapAccAndRanking.get(setIdIterate+Label.CMS_Relationship_Ranking3)) {
                        
                            lstChanelScope.add(chanMarkScopeIter);
                            divValue = chanMarkScopeIter.Division__c;
                            List<String> splitDivValues= DivValue.split(Label.System_CL00046); //semi colon
                            setDivs.addall(splitDivValues);
                    }
                                      
                }else if(mapAccAndRanking.containsKey(setIdIterate+Label.CMS_Relationship_Ranking4)){
                
                   for(Channel_Market_Coverage__c chanMarkScopeIter : mapAccAndRanking.get(setIdIterate+Label.CMS_Relationship_Ranking4)) {
                        
                            lstChanelScope.add(chanMarkScopeIter);
                            divValue = chanMarkScopeIter.Division__c;
                            List<String> splitDivValues= DivValue.split(Label.System_CL00046); //semi colon
                            setDivs.addall(splitDivValues);
                           
                    } 
                }else{}
               
               
                if(lstChanelScope.size() > 0){
                   
                    String div = '';
                    for(String setUniqueDivs : setDivs){
                        div += setUniqueDivs+Label.System_CL00046 ;
                    }
                    Account a = new Account();
                    a.Id=setIdIterate ;
                    a.Relationship_Status__c=lstChanelScope[0].Relationship_Status__c;
                    a.Division_1__c=div; 
                    accListToUpdate.add(a);               
                }
             
            }
            
           
        }
        
        try {
            if (accListToUpdate.size() > 0) Database.Update(accListToUpdate);
        } Catch(DMLException e) {
            
            String error = '';
            for (Integer i = 0; i < e.getNumDML(); i++) {
                error += e.getDMLMessage(i) + System.label.Line_Break;
            }
            
            for (Sobject sob: objList ) {
                sob.addError(error, false);
            }
        }
        
    }
}