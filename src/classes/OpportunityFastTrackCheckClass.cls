/**
    @Author Rajesh K
    @name OpportunityFastTrackCheckClass
    @CreateDate 9/05/2015
    @Version 1.0
    **/
global class OpportunityFastTrackCheckClass
{
    /*  Description of the purpose of the method. 
    *  @name isFastTrackCheck
    *  @Description - OpportunityFastTrackCheck.
    *  @return String
    */
    webservice static String isFastTrackCheck(Id oppId) 
    { 
        List<Opportunity> lstopportunity = [Select Name, isPGManualUpdate__c,CurrencyIsoCode, Product_Group__r.CurrencyIsoCode, Opportunity_Value__c, Product_Group__r.Opportunity_Default_Type__c, Product_Group__r.Opportunity_Threshold__c from Opportunity where id =: oppId LIMIT 1];
        Map<String,CurrencyType> conversion_rates = new Map<String,CurrencyType>();
        for(CurrencyType curr : [SELECT ISOCode, ConversionRate FROM CurrencyType WHERE IsActive=TRUE LIMIT 50000]){
                conversion_rates.put(curr.ISOCode,curr);
        }
        if(lstopportunity.size()>0){
            if(lstopportunity[0].isPGManualUpdate__c <> false && (lstopportunity[0].Product_Group__r.Opportunity_Default_Type__c.equals(System.label.Opportunity_RecordType_Regular) || (lstopportunity[0].Opportunity_Value__c != null && lstopportunity[0].Product_Group__r.Opportunity_Threshold__c != null && 
            (lstopportunity[0].Opportunity_Value__c/conversion_rates.get(lstopportunity[0].CurrencyIsoCode).ConversionRate) > (lstopportunity[0].Product_Group__r.Opportunity_Threshold__c/conversion_rates.get(lstopportunity[0].Product_Group__r.CurrencyIsoCode).ConversionRate)))){
                return 'No';         
            }
            else if(lstopportunity[0].isPGManualUpdate__c <> true){
                ClsTriggerOpportunityProductHandler objOppProdHandler = new ClsTriggerOpportunityProductHandler();
                Set<Id> oppIds = new Set<Id>();
                Map<Id, List<OpportunityLineItem>> mapOppLineItems = new Map<Id, List<OpportunityLineItem>>();
                Map<String, Product_Group__c> mapProductGroups = new Map<String, Product_Group__c>();
                Set<String> productGroups = new Set<String>();
                oppIds.add(oppId);
                mapOppLineItems = objOppProdHandler.buildOpportunitylineitem(oppIds);
                for(ID opp : mapOppLineItems.Keyset()){
                    for(OpportunityLineItem oppline : mapOppLineItems.get(opp)){
                        productGroups.add(String.valueof(oppline.Product_Group__c));
                    }
                }           
                mapProductGroups = objOppProdHandler.buildProductGroups(productGroups);
                Boolean oppCheck1 = false;
                Boolean oppCheck2 = false;
                for(ID opp : mapOppLineItems.Keyset()){
                    for(OpportunityLineItem opplineRec : mapOppLineItems.get(opp))
                    {
                        if(mapProductGroups.containskey(String.valueof(opplineRec.Product_Group__c)) && (mapProductGroups.get(String.valueof(opplineRec.Product_Group__c)).Opportunity_Default_Type__c.equals(System.label.Opportunity_RecordType_Regular) || 
                        (opplineRec.Opportunity.Opportunity_Value__c != null && mapProductGroups.get(String.valueof(opplineRec.Product_Group__c)).Opportunity_Threshold__c != null && 
                        opplineRec.Opportunity.Opportunity_Value__c/conversion_rates.get(opplineRec.Opportunity.CurrencyIsoCode).ConversionRate > mapProductGroups.get(String.valueof(opplineRec.Product_Group__c)).Opportunity_Threshold__c/conversion_rates.get(mapProductGroups.get(String.valueof(opplineRec.Product_Group__c)).CurrencyIsoCode).ConversionRate))){
                            oppCheck1 = true;                      
                        }
                        else if(mapProductGroups.containskey(String.valueof(opplineRec.Product_Group__c))){
                            oppCheck2 = true; 
                        }else{}                         
                    }                   
                }
                if(oppCheck2 <> false && oppCheck1 <> true){
                    return 'Yes'; 
                }else if(oppCheck1 <> false){ 
                    return 'No';  
                }       
            }else{return 'Yes';}            
        }   
        return null;
    }    
}