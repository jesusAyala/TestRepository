/*
@Name: APTS_SummaryGroupTriggerHelper
@Author: Chetan Patel
@CreateDate: 07 Dec, 2015
@Description: Helper class to perform operations for trigger for records of Apttus_Config2__SummaryGroup__c.
@UsedBy: Class - APTS_SummaryGroupTriggerHandler
*/

public class APTS_SummaryGroupTriggerHelper {
    
    /**
     * Method to set the Summary Group totals in cart
     */
    public void setSummaryGrouTotals(List<Apttus_Config2__SummaryGroup__c> newSummaryGroupList) {
        
        for(Apttus_Config2__SummaryGroup__c summaryGrp: newSummaryGroupList){
            system.debug('<<<< Summary Group >>>> '+ APTS_PricingCallback.bUpdateSummaryGr+'===='+APTS_PricingCallback.dTotalStdPrice);
            if(APTS_PricingCallback.bUpdateSummaryGr){
                summaryGrp.APTS_Total_Standard_Price__c = APTS_PricingCallback.dTotalStdPrice;
                summaryGrp.APTS_Total_Quote_Price__c = APTS_PricingCallback.dTotalQuotePrice;
            }
        
        }
    }
    
    /**
     * Method to set the Summary Group totals in cart after Insert.
     */
    public void setSummaryGrouTotalsAfterInsert(List<Apttus_Config2__SummaryGroup__c> newSummaryGroupList) {
        Map<Id, Apttus_Config2__SummaryGroup__c> mapSummaryGrpConfigId = new Map<Id, Apttus_Config2__SummaryGroup__c>();
        for(Apttus_Config2__SummaryGroup__c summaryGrp: newSummaryGroupList){            
            if(!APTS_PricingCallback.bUpdateSummaryGr){
                mapSummaryGrpConfigId.put(summaryGrp.Apttus_Config2__ConfigurationId__c, summaryGrp);
            }
        
        }
        system.debug('<<<< after Insert Summary Group >>>> '+ mapSummaryGrpConfigId);
        if(mapSummaryGrpConfigId.size() > 0){
            Map<Id, Decimal> mapConfigIdTotalStdPrice = new Map<Id, Decimal>();
            Map<Id, Decimal> mapConfigIdTotalQuotePrice = new Map<Id, Decimal>();
            List<Apttus_Config2__ProductConfiguration__c> listConfigurations = new List<Apttus_Config2__ProductConfiguration__c>();
            for(Apttus_Config2__ProductConfiguration__c oConfig : [SELECT Id FROM Apttus_Config2__ProductConfiguration__c WHERE Id IN: mapSummaryGrpConfigId.keySet()]){
                oConfig.Apttus_Config2__IsPricePending__c = true;
                listConfigurations.add(oConfig);
            }
            
            if(listConfigurations.size() > 0){
                update listConfigurations;
            }
        }
    }
}