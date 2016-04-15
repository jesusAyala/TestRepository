/**
 * TriggerClass -   Opportunity Qualification Status and Tender Screening Status are automatically updated in Opportunity
 * based on most recent Opportunity Screening. 
 * Release R4
 * @author  Abiramasundari Radha (Accenture)
 * @created 2015-07-29
 * @version 1.0
 * Created
 */ 
public class ClsTriggerOpportunityScreeningHandler extends ClsTriggerVirtual {
/**
* @see IntHelper.beforeTrigger
*/
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
        setAWAassignees(trgCtx); 
        setOpportunityScreeningclassficaton(trgCtx); 
    }
/**
* @see IntHelper.afterTrigger
*/
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx){
        //setOpportunityScreeningStatus(trgCtx); 
        //setOpportunityScreeningGatesCreation(trgCtx);
        setOpportunityScreeningGatesUpdation(trgCtx);
    }   
    //Added Release:4 By Rajesh Kaliyaperumal(Accenture) 
    /**
    * @see Added Release:4 By Rajesh Kaliyaperumal(Accenture) 
    
    */     
    private void setOpportunityScreeningGatesUpdation(ClsWrappers.TriggerContext trgCtx) { 
        Map<String, Schema.RecordTypeInfo> oPP_SCREENING_RECORD_TYPES = Schema.SObjectType.Opportunity_Screening__c.getRecordTypeInfosByName();
        String oPP_SCREENING_GATE1_ID = oPP_SCREENING_RECORD_TYPES.get(Label.System_CL00085).getRecordTypeId();
        String oPP_SCREENING_GATE2_ID = oPP_SCREENING_RECORD_TYPES.get(Label.System_CL00086).getRecordTypeId();
        String oPP_SCREENING_GATE3_ID = oPP_SCREENING_RECORD_TYPES.get(Label.System_CL00087).getRecordTypeId();
        Map<ID,List<Opportunity_Screening__c>> mapOppScreening = new Map<ID,List<Opportunity_Screening__c>>();
        if(trgCtx.isUpdate && trgCtx.isAfter){
            Set<ID> oppids = new Set<ID>();
            List<Opportunity> lstupdOpportunity = new List<Opportunity>();
            for (sobject so : trgCtx.newList) {                
                Opportunity_Screening__c oppScr = (Opportunity_Screening__c)so;
                
                if(oppScr.Approval_Status__c == 'Approved'){
                    oppids.add(oppScr.Opportunity__c);
                }                
            } 
            for(Opportunity_Screening__c objOS :[Select id,Opportunity__c,Gate_Status__c,RecordtypeId from Opportunity_Screening__c where Opportunity__c IN:oppids and Approval_Status__c = 'Approved' order by LastModifiedDate DESC LIMIT 50000]){
                if(mapOppScreening.containskey(objOS.Opportunity__c)){
                    List<Opportunity_Screening__c> lstoppScreen = mapOppScreening.get(objOS.Opportunity__c);
                    lstoppScreen.add(objOS);
                    mapOppScreening.put(objOS.Opportunity__c,lstoppScreen);
                }else{
                    mapOppScreening.put(objOS.Opportunity__c,new List<Opportunity_Screening__c>{objOS});
                }
            }
            for(ID objopp: mapOppScreening.keyset()){
                String gate1 = null;
                String gate2 = null;
                
                List<Opportunity_Screening__c> lstOppScrGate1 = new List<Opportunity_Screening__c>();
                List<Opportunity_Screening__c> lstOppScrGate2 = new List<Opportunity_Screening__c>();
                
                for(Opportunity_Screening__c objoppScreen : mapOppScreening.get(objopp)){
                    if(objoppScreen.RecordtypeId.equals(oPP_SCREENING_GATE1_ID)){
                        lstOppScrGate1.add(objoppScreen);
                    }else if(objoppScreen.RecordtypeId.equals(oPP_SCREENING_GATE2_ID) || objoppScreen.RecordtypeId.equals(oPP_SCREENING_GATE3_ID)){
                        lstOppScrGate2.add(objoppScreen);
                    }                  
                }               
               
                if(lstOppScrGate1.size()>0){
                    gate1 = lstOppScrGate1[0].Gate_Status__c;
                }
                if(lstOppScrGate2.size()>0){
                    gate2 = lstOppScrGate2[0].Gate_Status__c;
                }
                if(Gate1 != null && Gate2 == null){
                    lstupdOpportunity.add(new Opportunity(id = objopp,Opportunity_Qualification_Status__c = Gate1));
                }else if(gate1 == null && gate2 != null){
                    lstupdOpportunity.add(new Opportunity(id = objopp, Opportunity_Screening_Gate_2_Status__c = Gate2));
                }else if(gate1 != null && gate2 != null){
                    lstupdOpportunity.add(new Opportunity(id = objopp,Opportunity_Qualification_Status__c = Gate1, Opportunity_Screening_Gate_2_Status__c = Gate2));
                }else{}
                System.debug('lstupdOpportunity:'+lstupdOpportunity);
            }
            if(lstupdOpportunity.size()>0){
                ClsTriggerFactory.isSkipOpptyTrigger = true;  
                Database.update(lstupdOpportunity);
            }
        }
    }
   
     
    
 //Added Release:4 By Mohan Raj(Accenture)  
     /**
    * @see Added Release:4 By Mohan Raj(Accenture) 
    */    
    private void setOpportunityScreeningclassficaton(ClsWrappers.TriggerContext trgCtx) { 
        Map<String, Schema.RecordTypeInfo> oPP_SCREENING_RECORD_TYPES = Schema.SObjectType.Opportunity_Screening__c.getRecordTypeInfosByName();
        String oPP_SCREENING_GATE1_ID = oPP_SCREENING_RECORD_TYPES.get(Label.System_CL00085).getRecordTypeId();
        String oPP_SCREENING_GATE2_ID = oPP_SCREENING_RECORD_TYPES.get(Label.System_CL00086).getRecordTypeId();
        String oPP_SCREENING_GATE3_ID = oPP_SCREENING_RECORD_TYPES.get(Label.System_CL00087).getRecordTypeId();
        Map<ID,List<Opportunity_Screening__c>> mapOppScreening = new Map<ID,List<Opportunity_Screening__c>>();
        if((trgCtx.isInsert && trgCtx.isBefore)||(trgCtx.isUpdate && trgCtx.isBefore)){
            Set<ID> oppScrids = new Set<ID>();
            Set<Id> oppids = new Set<Id>();
            Set<Id> locids = new Set<Id>();
            Set<Id> accids = new Set<Id>();            
            
            for (sobject so : trgCtx.newList) {                
                Opportunity_Screening__c oppScr = (Opportunity_Screening__c)so;
                oppScrids.add(oppScr.id);  
                oppids.add(oppScr.Opportunity__c);        
            } 
            
            Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([Select Id,ABB_Location__c,Account.Id,Local_Product_Group__c from Opportunity where id in : oppids limit 10000]);          
            for(Opportunity o : oppMap.values())
            {
                locids.add(o.ABB_Location__c);
                accids.add(o.Account.Id);                 
            }
                        
            Map<Id, ABB_Location__c> locMap = new Map<Id, ABB_Location__c>([Select Id, Country__c, Product_Group__c from ABB_Location__c where Id in : locids limit 10000]);
            
            Map<String, Safe_Island_Assessments__c>  finalSafeMap = new Map<String, Safe_Island_Assessments__c>();
            
            Map<Id, Safe_Island_Assessments__c> safeMap  = new Map<Id, Safe_Island_Assessments__c>([Select Id, AccountCustomer__c, Classification__c, Country__c, PG__c from Safe_Island_Assessments__c where AccountCustomer__c in : accids order by Createddate asc limit 10000]);          

            for(Safe_Island_Assessments__c sia : safeMap .values() ) 
            {
                 String aId = sia.AccountCustomer__c;
                 String cId = '';
                 if(sia.Country__c!= null) {cId = sia.Country__c;}
                 String pGId = '';
                 
                 if(sia.PG__c != null ){pGId = sia.PG__c;}            
                 String strCode =aId+cId+pGId;
                 
                 finalSafeMap .put(strCode,sia );
            }        
            
            for (sobject so : trgCtx.newList) {                
                Opportunity_Screening__c oppScr = (Opportunity_Screening__c)so;
                
                String oppScrnId = oppScr.id; 
                String opportunityId = oppScr.Opportunity__c;              
                String locationId = oppMap.get(opportunityId).ABB_Location__c;
                Boolean isAssigned = False;
                
                if(locationId != null){
                                   
                String accountId  = oppMap.get(oppScr.Opportunity__c).Account.Id;
                String pGId = oppMap.get(oppScr.Opportunity__c).Local_Product_Group__c;                
                String locationCountry =  locMap.get(locationId).Country__c; 
                 
              
                If(accountId  != null && pGId != null && locationCountry != null )
                {
                    String code = accountId +locationCountry+pGId; 
                    
                    if(finalSafeMap.get(code) != null)
                    {
                        if(oppScr.RecordTypeId == oPP_SCREENING_GATE1_ID )
                        {
                            oppScr.Safe_Island_Classification__c = finalSafeMap.get(Code).Classification__c;
                            oppScr.Gate1_Fit_Safe_Island_A__c = Label.System_SafeIslandYes; 
                            isAssigned = True;                          
                        }
                        if(oppScr.RecordTypeId == oPP_SCREENING_GATE2_ID || oppScr.RecordTypeId == oPP_SCREENING_GATE3_ID )
                        {
                            oppScr.Safe_Island_Classification__c = finalSafeMap.get(Code).Classification__c;
                            oppScr.Gate2_Fit_Safe_Island_Classification_A__c = finalSafeMap.get(Code).Classification__c;
                            oppScr.Gate1_Fit_Safe_Island_A__c = Label.System_SafeIslandYes; 
                            oppScr.Gate2_FIT_Safe_Island_A__c = Label.System_SafeIslandYes; 
                            isAssigned = True; 
                        }                        
                       
                    }                
                                     
                 }
                }
                
                if(!isAssigned)
                {                
                    if(oppScr.RecordTypeId == oPP_SCREENING_GATE1_ID )
                    {
                        oppScr.Safe_Island_Classification__c = Label.CL00071;
                        oppScr.Gate1_Fit_Safe_Island_A__c = Label.System_SafeIslandNo;
                    }
                    if(oppScr.RecordTypeId == oPP_SCREENING_GATE2_ID || oppScr.RecordTypeId == oPP_SCREENING_GATE3_ID )
                    {
                        oppScr.Safe_Island_Classification__c =  Label.CL00071;
                        oppScr.Gate2_Fit_Safe_Island_Classification_A__c = Label.CL00071;
                        oppScr.Gate1_Fit_Safe_Island_A__c = Label.System_SafeIslandNo; 
                        oppScr.Gate2_FIT_Safe_Island_A__c = Label.System_SafeIslandNo;
                    }
                }
            }
        }
    }




    /**
    * Added Release:5 By Shankar Anand(Accenture) 
    **/    
    private void setAWAassignees(ClsWrappers.TriggerContext trgCtx) { 
    if((trgCtx.isInsert && trgCtx.isBefore)||(trgCtx.isUpdate && trgCtx.isBefore)){
        for(sobject so:trgCtx.newList){
            Opportunity_Screening__c oppScr = (Opportunity_Screening__c)so;
            if(trgCtx.isInsert || (trgCtx.isUpdate && oppScr.Gate_Status__c!=null && oppScr.Gate_Status__c!='' && (Opportunity_Screening__c)trgCtx.oldMap.get(oppScr.Id)!= null && ((Opportunity_Screening__c)trgCtx.oldMap.get(oppScr.Id)).Gate_Status__c!=oppScr.Gate_Status__c)){
                oppScr.Primary_Acc_Manager__c = oppScr.Primary_Account_Manager__c;
                oppScr.Submitter__c = oppScr.CreatedById;
            }
        }
    }
 }   }