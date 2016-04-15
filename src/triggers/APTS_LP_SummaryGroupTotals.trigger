trigger APTS_LP_SummaryGroupTotals on Apttus_Config2__SummaryGroup__c (before insert, before update) {
    
    Map<Id, Apttus_Config2__SummaryGroup__c> mapSummaryGrpConfigId = new Map<Id, Apttus_Config2__SummaryGroup__c>();
    
    for(Apttus_Config2__SummaryGroup__c sGrp : Trigger.New){
        
        if(sGrp.Name == 'Total (One Time)'){
            mapSummaryGrpConfigId.put(sGrp.Apttus_Config2__ConfigurationId__c, sGrp);
        }
    }
    
    if(mapSummaryGrpConfigId.size() > 0){
        
        Map<Id, Decimal> mapConfigIdTotalStdPrice = new Map<Id, Decimal>();
        Map<Id, Decimal> mapConfigIdTotalQuotePrice = new Map<Id, Decimal>();
        
        for(Id configId : mapSummaryGrpConfigId.keySet()){
            
            mapConfigIdTotalStdPrice.put(configId, 0);
            mapConfigIdTotalQuotePrice.put(configId, 0);
        }
        
        for(Apttus_Config2__LineItem__c lineItem : [SELECT Id, Apttus_Config2__ConfigurationId__c, APTS_LP_Total_Standard_Price__c,
                                                   Apttus_Config2__NetPrice__c 
                                                   FROM Apttus_Config2__LineItem__c
                                                   WHERE Apttus_Config2__ConfigurationId__c IN :mapSummaryGrpConfigId.keySet()]){
            
            Decimal totalStdPrice = mapConfigIdTotalStdPrice.get(lineItem.Apttus_Config2__ConfigurationId__c) + (lineItem.APTS_LP_Total_Standard_Price__c != null ? lineItem.APTS_LP_Total_Standard_Price__c : 0);
            Decimal totalQuotePrice = mapConfigIdTotalQuotePrice.get(lineItem.Apttus_Config2__ConfigurationId__c) + (lineItem.Apttus_Config2__NetPrice__c != null ? lineItem.Apttus_Config2__NetPrice__c : 0);
            
            mapConfigIdTotalStdPrice.put(lineItem.Apttus_Config2__ConfigurationId__c, totalStdPrice);
            mapConfigIdTotalQuotePrice.put(lineItem.Apttus_Config2__ConfigurationId__c, totalQuotePrice);
            
        }
        
        for(Apttus_Config2__SummaryGroup__c summaryGrp : mapSummaryGrpConfigId.values()){
            
            summaryGrp.APTS_Total_Standard_Price__c = mapConfigIdTotalStdPrice.get(summaryGrp.Apttus_Config2__ConfigurationId__c);
            summaryGrp.APTS_Total_Quote_Price__c = mapConfigIdTotalQuotePrice.get(summaryGrp.Apttus_Config2__ConfigurationId__c);
        }
    }
}