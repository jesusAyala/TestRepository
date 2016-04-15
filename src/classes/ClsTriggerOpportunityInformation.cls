/**   
* TriggerClass :  ClsTriggerOpportunityInformation
* 
* To create Opportunity_Info_Channel_Business_Review__c
* Release R5
*  
* @author  Vasanthi (Accenture)
* @created 2016-3-09
* @version 1.0
*
* - Created
*/
public without sharing class ClsTriggerOpportunityInformation extends ClsTriggerVirtual {
        
   
    Integer remLimit;     
    
    
    /**
    * @see IntHelper.AfterTrigger
    *To copy the opportunity information
    */  
    public override void bulkAfter(ClsWrappers.TriggerContext trgCtx) {
        if (trgCtx.isInsert) {
            copytheOpportuntiyInfos(trgCtx);
        }
    }            

    /**    
    *To copy the opportunity information
    */ 
    public void copytheOpportuntiyInfos(ClsWrappers.TriggerContext trgCtx){
        
        List<Opportunity_Info_Channel_Business_Review__c> toBeCreatedOppReviewList = new List<Opportunity_Info_Channel_Business_Review__c>();
        Map<Id, List<Opportunity_Information__c >> accIDOppInfoListMap  = new Map<Id, List<Opportunity_Information__c >>();
        
        for (Sobject sobj : trgCtx.newList) {
        
            Opportunity_Information__c info = (Opportunity_Information__c)sObj;            
            if (info.Account__c != NULL) {
                if (!accIDOppInfoListMap.containsKey(info.Account__c)) {
                    accIDOppInfoListMap.put(info.Account__c, new List<Opportunity_Information__c>());
                }
                accIDOppInfoListMap.get(info.Account__c).add(info);
            }
        }
        
        if (!accIDOppInfoListMap.isEmpty()) {
            
            remLimit =  limits.getLimitQueryRows() - limits.getQueryRows(); 
            
            for (Channel_Business_Review__c channel : [SELECT Id, Account__c FROM Channel_Business_Review__c WHERE Account__c IN : accIDOppInfoListMap.KeySet() LIMIT :remLimit ] ) {
                
                for (Opportunity_Information__c oppInfo: accIDOppInfoListMap.get(channel.Account__c)) {
                    
                    toBeCreatedOppReviewList.add( new Opportunity_Info_Channel_Business_Review__c(Channel_Partner_Business_Review__c = channel.Id, Opportunity_Information__c = oppInfo.Id));
                }
            }
        }
        
        try {
            if (toBeCreatedOppReviewList.size() > 0) {
                insert toBeCreatedOppReviewList;
            }
        } Catch(DMLException e) {
            String err = '';
            for (Integer i = 0; i < e.getNumDML(); i++) {
                err += e.getDMLMessage(i) +Label.Line_Break;
            }
            
            for (Sobject sobj : trgCtx.newList) {
                sobj.addError(err, false);
            }
        }
    }
}