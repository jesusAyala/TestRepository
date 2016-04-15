/**
*  @Name: ClsTriggerOpportunityTeam
*  @return - void
*  
*  @author  MohanRaj Kasinathan (Accenture)
*  @created  @version 1.0

*/
public class ClsTriggerOpportunityTeam extends ClsTriggerVirtual {
/**
* @see IntHelper.beforeTrigger
*/
public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {       
/*try
{            
    revokeQuoteAccess(trgCtx);
}           
catch(DMLException e){  string err = e.getmessage(); } */
}    

/**    
 * @see IntHelper.afterTrigger
*/
public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {        
   /* try
    {*/
        setQuoteAccess(trgCtx);
        revokeQuoteAccess(trgCtx);
        updateQuoteAccess(trgCtx);
   /* }           
    catch(DMLException e){  string err = e.getmessage(); } */
}    
   
    /**
     *  This trigger is used to Set Contact to Primary with a Role.
     @author  Jinbo Shan
     @created 2015-03-26
     @version 1.0
     @since   30.0 (Force.com ApiVersion)
     *
     @changelog
     * 2015-03-26 Jinbo Shan <jinbo.shan@itbconsult.com>
     * - Created
    */
    @TestVisible 
    private void setQuoteAccess(ClsWrappers.TriggerContext trgCtx) {
    
        if (trgCtx.isBefore) return;
        
        if (trgCtx.isInsert & trgCtx.isAfter ) {
            
             set<Id> setOppids = new set<Id>();
             for (sobject so : trgCtx.newList) {
                OpportunityTeamMember  oppytm = (OpportunityTeamMember)so;
                if (oppytm.UserId != null && oppytm.OpportunityAccessLevel != null && oppytm.OpportunityId != null ) {
                    setOppids.add(oppytm.OpportunityId);
                }
                
             }
                        
           Map<Id, Apttus_Proposal__Proposal__c> quoteMap = new  Map<Id, Apttus_Proposal__Proposal__c>([Select Id, Apttus_Proposal__Opportunity__c, APTS_Is_Placeholder_Quote__c from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c in : setOppids and APTS_Is_Placeholder_Quote__c = true LIMIT 50000]);      

           Map<Id, String>  quoteOppMap  = new Map<Id, String>();
           
           for(Apttus_Proposal__Proposal__c qp : quoteMap.values())
           {
              quoteOppMap.put(qp.Apttus_Proposal__Opportunity__c, qp.Id);              
           }            
           list<Apttus_Proposal__Proposal__Share > lstQuoteShare = new list<Apttus_Proposal__Proposal__Share >();
            
            for (sobject so : trgCtx.newList) {
                OpportunityTeamMember  oppytm = (OpportunityTeamMember)so;               
             //      system.debug('::MR::1::'+quoteOppMap.containskey(oppytm.OpportunityId));
                if (oppytm.UserId != null && oppytm.OpportunityAccessLevel != null && oppytm.OpportunityId != null && quoteOppMap.containskey(oppytm.OpportunityId)) {
                    Apttus_Proposal__Proposal__Share oqs = new Apttus_Proposal__Proposal__Share();
                    oqs.AccessLevel = oppytm.OpportunityAccessLevel;                    
                    oqs.ParentId = quoteOppMap.get(oppytm.OpportunityId);
                    oqs.UserOrGroupId = oppytm.UserId;
                    oqs.RowCause = System.Label.System_APTSEnableAccessToOpportunityTeam;                    
                    lstQuoteShare.add(oqs);
                }
            }
            if(lstQuoteShare.size() > 0) {
                Database.Insert(lstQuoteShare);
            }
        } 
    }      
   
    
    
    /**
     *  This trigger is used to Set Contact to Primary with a Role.
     @author  Jinbo Shan
     @created 2015-03-26
     @version 1.0
     @since   30.0 (Force.com ApiVersion)
     *
     @changelog
     * 2015-03-26 Jinbo Shan <jinbo.shan@itbconsult.com>
     * - Created
    */
    @TestVisible 
    private void revokeQuoteAccess(ClsWrappers.TriggerContext trgCtx) {    
        
        
        if (trgCtx.isDelete & trgCtx.isAfter) {
            
             set<Id> setOppids = new set<Id>();
             set<Id> setUserids = new set<Id>();
             for (sobject so : trgCtx.oldList) {
                OpportunityTeamMember  oppytm = (OpportunityTeamMember)so;
                if (oppytm.UserId != null && oppytm.OpportunityAccessLevel != null && oppytm.OpportunityId != null ) {
                    setOppids.add(oppytm.OpportunityId);
                    setUserids.add(oppytm.UserId);
                }
                
             }
                        
           Map<Id, Apttus_Proposal__Proposal__c> quoteMap = new  Map<Id, Apttus_Proposal__Proposal__c>([Select Id, Apttus_Proposal__Opportunity__c, APTS_Is_Placeholder_Quote__c from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c in : setOppids and APTS_Is_Placeholder_Quote__c = true LIMIT 50000]);      

           set<Id> setQuoteids = new set<Id>(); 
           
           setQuoteids = quoteMap.KeySet();
           
            List<Apttus_Proposal__Proposal__Share >  proposalsharesToDelete = [SELECT Id FROM Apttus_Proposal__Proposal__Share WHERE ParentId IN :setQuoteids AND UserOrGroupId IN :setUserids AND RowCause =: System.Label.System_APTSEnableAccessToOpportunityTeam LIMIT 50000];
         /*   
            system.debug('::MR::'+ quoteMap);
            system.debug('::MR::'+ proposalsharesToDelete);
         */   
            if(!proposalsharesToDelete.isEmpty()) {
            
            Database.Delete(proposalsharesToDelete , false);           
            
            }
        } 
    }      

     /**
     *  This trigger is used to Set Contact to Primary with a Role.
     @author  Jinbo Shan
     @created 2015-03-26
     @version 1.0
     @since   30.0 (Force.com ApiVersion)
     *
     @changelog
     * 2015-03-26 Jinbo Shan <jinbo.shan@itbconsult.com>
     * - Created
    */
    @TestVisible 
    private void updateQuoteAccess(ClsWrappers.TriggerContext trgCtx) {
    
        if (trgCtx.isBefore) return;
        
        if (trgCtx.isUpdate & trgCtx.isAfter ) {
            
             set<Id> setOppids = new set<Id>();
             set<Id> setUserids = new set<Id>();
             for (sobject so : trgCtx.newList) {
                OpportunityTeamMember  oppytm = (OpportunityTeamMember)so;
                if (oppytm.UserId != null && oppytm.OpportunityAccessLevel != null && oppytm.OpportunityId != null ) {
                    setOppids.add(oppytm.OpportunityId);
                    setUserids.add(oppytm.UserId);   
                }
                
             }
                        
           Map<Id, Apttus_Proposal__Proposal__c> quoteMap = new  Map<Id, Apttus_Proposal__Proposal__c>([Select Id, Apttus_Proposal__Opportunity__c, APTS_Is_Placeholder_Quote__c from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c in : setOppids and APTS_Is_Placeholder_Quote__c = true LIMIT 50000]);      

           Map<Id, String>  quoteOppMap  = new Map<Id, String>();
           set<Id> setQuoteids = new set<Id>();
           
           for(Apttus_Proposal__Proposal__c qp : quoteMap.values())
           {
              quoteOppMap.put(qp.Apttus_Proposal__Opportunity__c, qp.Id);  
              setQuoteids.add(qp.Id);  
           }            
           
           list<Apttus_Proposal__Proposal__Share > lstQuoteShare = [Select Id,AccessLevel,ParentId , UserOrGroupId   from Apttus_Proposal__Proposal__Share where ParentId  IN : setQuoteids and UserOrGroupId IN:setUserids and RowCause =: System.Label.System_APTSEnableAccessToOpportunityTeam LIMIT 50000];
           
           list<Apttus_Proposal__Proposal__Share > lstQuoteShareUpd = new list<Apttus_Proposal__Proposal__Share >();
            
            for (sobject so : trgCtx.newList) {
                OpportunityTeamMember  oppytm = (OpportunityTeamMember)so;               
                  
                if (oppytm.UserId != null && oppytm.OpportunityAccessLevel != null && oppytm.OpportunityId != null && quoteOppMap.containskey(oppytm.OpportunityId)) {
                
                    for(Apttus_Proposal__Proposal__Share  lst : lstQuoteShare)
                    {
                        if(oppytm.UserId == lst.UserOrGroupId  && quoteOppMap.get(oppytm.OpportunityId) == lst.ParentId )
                        {
                            Apttus_Proposal__Proposal__Share oqs = new Apttus_Proposal__Proposal__Share();
                            oqs.AccessLevel = oppytm.OpportunityAccessLevel; 
                            oqs.Id = lst.Id;
                            lstQuoteShareUpd .add(oqs);
                        }
                    }
                }
            }
            if(lstQuoteShareUpd.size() > 0) {
                Database.Update(lstQuoteShareUpd );
            }
        } 
    }      
   
   
        
}