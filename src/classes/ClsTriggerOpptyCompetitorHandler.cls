/**   
* ClsTriggerOpptyCompetitorHandler
* Release R5
*  
* @author  Shankar Anand (Accenture)
* @created 2015-12-11 @version 1.0
*
*/ 
public with sharing class ClsTriggerOpptyCompetitorHandler extends ClsTriggerVirtual {
    
    /**
    * @see IntHelper.beforeTrigger
    */
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
    try{
          enforceSingleWinnerOnInsert(trgCtx);
          }catch(Exception e){String err=e.getMessage();}
    }
    
    /**
    * @see IntHelper.afterTrigger
    */
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
        try
        {
            
            enforceSingleWinnerOnUpdate(trgCtx);
            clearOpptyWinnerOnDelete(trgCtx);
        }
        catch(DMLException e){  string err = e.getmessage(); 
       // system.debug('^^^^^^'+err);
       } 
    }
    
    
     /**
     *This trigger is used to ensure that there is a single Winning Competitor 
     *from among all the competitors for any opportunity.
     *
     @author  Shankar Anand
     @created 2015-12-11
     @version 1.0
     @since   35.0 (Force.com ApiVersion)
     **/  
    @TestVisible 
    private void enforceSingleWinnerOnInsert(ClsWrappers.TriggerContext trgCtx) 
    {
        Map<Id,Competitor__c> comptrMap = new Map<Id,Competitor__c>(); 
        Map<Id,Opportunity> opptyMap = new Map<Id,Opportunity>();
        Set<Id> opptyIds = new Set<Id>();  
        Set<Competitor__c> oldWinnersSet = new Set<Competitor__c>();
        List<Competitor__c> oldWinnersList = new List<Competitor__c>();
        Map<Id,Opportunity> opptySet = new Map<Id,Opportunity>();
        List<Opportunity> opptyList = new List<Opportunity>(); 
    
        if (trgCtx.isBefore && trgCtx.isInsert) 
        {        
            for(sobject so : trgCtx.newList)
            {
                Competitor__c cmptr = (Competitor__c)so;
                opptyIds.add(cmptr.Opportunity__c);
            }
            
            comptrMap = new Map<Id,Competitor__c>([Select Id, Name, Competitor__c, Opportunity__c, Winning_Company__c From Competitor__c where Opportunity__c in : opptyIds LIMIT 50000]);
            opptyMap = new Map<Id,Opportunity>([Select Id, Name, Opportunity_Winner__c,Winners_Price__c From Opportunity where Id in : opptyIds LIMIT 50000]);
            
            for(sobject so : trgCtx.newList)
            {
                Competitor__c cmptr = (Competitor__c)so;
                String result = userinfo.getDefaultCurrency();
                cmptr.CurrencyIsoCode = userinfo.getDefaultCurrency();
                if(cmptr.Winning_Company__c == true)
                {
                Opportunity opp = opptyMap.get(cmptr.Opportunity__c);
                    for(Competitor__c cmp :comptrMap.values())
                    {
                        if(cmptr.Opportunity__c == cmp.Opportunity__c && cmptr.Id != cmp.Id && cmp.Winning_Company__c == true)
                        {
                            cmp.Winning_Company__c = false;                            
                            oldWinnersSet.add(cmp);
                        }
                    }
                    
                    opp.Opportunity_Winner__c = cmptr.Competitor__c;
                    opp.Winners_Price__c = cmptr.Estimated_Sale_Price__c;
                    opptySet.put(opp.id,opp); 
                   // system.debug('&&&&&&'+opptySet);          
                }   
            }
            
            if(oldWinnersSet.size()>0)
            {
                oldWinnersList.addAll(oldWinnersSet);
                update oldWinnersList;
            }
            
            if(opptySet!= null && opptySet.values().size()>0)
            {
                for(Opportunity opp: opptySet.values()){
                opptyList.add(opp); 
                }
                try{  
                clsTriggerFactory.competitorUpdate = true;           
                update opptyList;
                }
                catch(DmlException exc){
                           String error ='';
                           String errMsgs  = '';
                           Integer numErrors = exc.getNumDml();
                           String genErr = System.label.System_Oppty_Label1+ System.label.Line_Break;
                           for(Integer i=0;i<numErrors;i++) { 
                              errMsgs +=  opptyMap.get(exc.getDmlId(i)).Name +System.label.CL00200+ exc.getDmlMessage(i) +System.label.Line_Break;              
                           }
                           error = genErr + errMsgs ;  
                           for (sobject sob : trgCtx.newList){
                              Competitor__c cmptr = (Competitor__c)sob;
                              cmptr.addError(error, false); 
                          }  
                    }
            }
                 
        }
    }
    
    
     /**
     *This trigger is used to ensure that there is a single Winning Competitor 
     *from among all the competitors for any opportunity.
     *
     @author  Shankar Anand
     @created 2015-12-11
     @version 1.0
     @since   35.0 (Force.com ApiVersion)
     **/    
    @TestVisible 
    private void enforceSingleWinnerOnUpdate(ClsWrappers.TriggerContext trgCtx) 
    {
        Map<Id,Competitor__c> comptrMap = new Map<Id,Competitor__c>(); 
        Map<Id,Opportunity> opptyMap = new Map<Id,Opportunity>();
        Set<Id> opptyIds = new Set<Id>();  
        Set<Competitor__c> oldWinnersSet = new Set<Competitor__c>();
        List<Competitor__c> oldWinnersList = new List<Competitor__c>();
        //Set<Competitor__c> newWinnersSet = new Set<Competitor__c>();
        //List<Competitor__c> newWinnersList = new List<Competitor__c>();
        Map<Id,Opportunity> opptySet = new Map<Id,Opportunity>();
        List<Opportunity> opptyList = new List<Opportunity>(); 
    
        if (trgCtx.isAfter && trgCtx.isUpdate) 
        {        
            for(sobject so : trgCtx.newList)
            {
                Competitor__c cmptr = (Competitor__c)so;
                opptyIds.add(cmptr.Opportunity__c);
            }
            
            comptrMap = new Map<Id,Competitor__c>([Select Id, Name, Competitor__c, Opportunity__c, Winning_Company__c From Competitor__c where Opportunity__c in : opptyIds LIMIT 50000]);
            opptyMap = new Map<Id,Opportunity>([Select Id, Name, Opportunity_Winner__c,Winners_Price__c From Opportunity where Id in : opptyIds LIMIT 50000]);
            
            for(sobject so : trgCtx.newList)
            {
                Competitor__c cmptr = (Competitor__c)so;
                Opportunity opp = opptyMap.get(cmptr.Opportunity__c);
                if(cmptr.Winning_Company__c == true){
                    opp.Winners_Price__c = cmptr.Estimated_Sale_Price__c;
                    opptySet.put(opp.id,opp);
                }
                
                //if(((Competitor__c)trgCtx.oldMap.get(cmptr.id)).Winning_Company__c == true && ((Competitor__c)trgCtx.newMap.get(cmptr.id)).Winning_Company__c == false){ 
                //   opp.Opportunity_Winner__c = null;
                //   opptySet.put(opp.id,opp);
                //}
                
                if(((Competitor__c)trgCtx.oldMap.get(cmptr.id)).Winning_Company__c == false && cmptr.Winning_Company__c == true)
                {
                    for(Competitor__c cmp :comptrMap.values())
                    {
                        if(cmptr.Opportunity__c == cmp.Opportunity__c && cmptr.Id != cmp.Id && cmp.Winning_Company__c == true)
                        {
                            cmp.Winning_Company__c = false;                            
                            oldWinnersSet.add(cmp);
                        }
                    }
                    
                    opp.Opportunity_Winner__c = cmptr.Competitor__c;
                    opptySet.put(opp.Id,opp);           
                }   
            }
            
            
            if(oldWinnersSet.size()>0)
            {
                oldWinnersList.addAll(oldWinnersSet);
                update oldWinnersList;  
            }
            
            if(opptySet!= null && opptySet.values().size()>0)
            {
                for(Opportunity opp: opptySet.values()){
                opptyList.add(opp); 
                }
                try{            
                update opptyList;
                }
                catch(DmlException exc){
                           String error ='';
                           String errMsgs  = '';
                           Integer numErrors = exc.getNumDml();
                           String genErr = System.label.System_Oppty_Label1+ System.label.Line_Break;
                           for(Integer i=0;i<numErrors;i++) { 
                              errMsgs +=  opptyMap.get(exc.getDmlId(i)).Name +System.label.CL00200+ exc.getDmlMessage(i) +System.label.Line_Break;              
                           }
                           error = genErr + errMsgs ;  
                           for (sobject sob : trgCtx.newList){
                             Competitor__c cmptr = (Competitor__c)sob;
                             cmptr.addError(error, false); 
                          }  
                    }
            }               
        }
    }
    
        
     /**
     *This trigger is used to ensure that the Opportunity Winner field 
     *is cleared for the opportunity when the current Winning Competitor is deleted.
     *
     @author  Shankar Anand
     @created 2015-12-11
     @version 1.0
     @since   35.0 (Force.com ApiVersion)
     **/   
    @TestVisible 
    private void clearOpptyWinnerOnDelete(ClsWrappers.TriggerContext trgCtx) {
    Map<Id,Opportunity> opptyMap = new Map<Id,Opportunity>();
    Set<Id> opptyIds = new Set<Id>();  
    Map<Id,Opportunity> opptySet = new Map<Id,Opportunity>();
    List<Opportunity> opptyList = new List<Opportunity>(); 
    //system.debug('ZZZZ');
        if (trgCtx.isAfter && trgCtx.isDelete)
        {        
            for(sobject so : trgCtx.oldList)
            {
                Competitor__c cmptr = (Competitor__c)so;
                opptyIds.add(cmptr.Opportunity__c);
            }
            
            opptyMap = new Map<Id,Opportunity>([Select Id, Name, Opportunity_Winner__c,Winners_Price__c  From Opportunity where Id in : opptyIds LIMIT 50000]);
            
            for(sobject so : trgCtx.oldList)
            {
                Competitor__c cmptr = (Competitor__c)so;
                Opportunity opp = opptyMap.get(cmptr.Opportunity__c); 
                if(cmptr.Winning_Company__c == true && opp.Opportunity_Winner__c == cmptr.Competitor__c)
                {             
                    opp.Opportunity_Winner__c = null;
                    opp.Winners_Price__c = null;
                    opptySet.put(opp.id,opp);           
                }   
            }
            
            if(opptySet.values().size()>0)
            {
                opptyList.addAll(opptySet.values()); 
                try{       
                update opptyList;
                } 
                 catch(DmlException exc){
                           String error ='';
                           String errMsgs  = '';
                           Integer numErrors = exc.getNumDml();
                           String genErr = System.label.System_Oppty_Label1+ System.label.Line_Break;
                           for(Integer i=0;i<numErrors;i++) { 
                              errMsgs +=  opptyMap.get(exc.getDmlId(i)).Name +System.label.CL00200+ exc.getDmlMessage(i) +System.label.Line_Break;              
                           }
                           error = genErr + errMsgs ;  
                           for (sobject sob : trgCtx.newList){
                             Competitor__c cmptr = (Competitor__c)sob;
                             cmptr.addError(error, false); 
                          }  
                    }

            }                
        }
    }
     
}