/*
 * @Description: This class is develope to manage pricing related information on the Cart Page
 * @Owner: Jignesh Shekhaliya
 * @Date: 07-Dec-2015
*/
global with sharing class APTS_PricingCallback implements Apttus_Config2.CustomClass.IPricingCallback2 {

    private Apttus_Config2.CustomClass.PricingMode mode = null;
    private Apttus_Config2.ProductConfiguration prodConfigObj;
    private static Map<Id, Apttus_Config2__LineItem__c> mapOfLineItemSO;
    private static Map<Id, Apttus_Config2__ProductAttributeValue__c> mapOfLItemProdAtt;
    private list<Apttus_Config2__LineItem__c> lstPrimaryLineItems;
    private static map<id, Apttus_Config2.LineItem> mapLineItemIdtoLineItem;
    private static map<id, Apttus_Config2__LineItem__c> mapLineItemAmortiseGatewayDevice, mapLineItemAmortiseBoarding, mapLineItemAmortiseProfiles, mapOtherAllLItems;
    private Apttus_Config2.LineItem amortisationGatewayDeviceLineItem, amortisationOnBoardingLineItem, amortisationProfilesLineItem;
    private String logStr='';
    private Id accountId, configID;
    private integer contractTerm = 0;
    private List<Integer> tempList = new List<Integer>();
    public static Decimal dTotalStdPrice = 0;
    public static Decimal dTotalQuotePrice = 0;
    public static Boolean bUpdateSummaryGr = false;

    
    
    global void setMode(Apttus_Config2.CustomClass.PricingMode mode) {
        logStr += '<BR/>Set Mode: ' + mode;
        this.mode = mode;
    }
    
    global void start(Apttus_Config2.ProductConfiguration prodConfig) {        
        prodConfigObj = prodConfig;        
        Apttus_Config2__ProductConfiguration__c prodConfigSO = prodConfig.getConfigSO();
        if(prodConfigSO != null){
            configID = prodConfigSO.Id;
            accountId = prodConfigSO.Apttus_Config2__AccountId__c;       
        }                 
    }
  
    // Populate Attribute Details of an product on line item
    private void populateProAttriDetails() {
        
    }
    
    global void beforePricing(Apttus_Config2.ProductConfiguration.LineItemColl lineItemColl) {                
        List<Apttus_Config2.LineItem> listOfLineItems = lineItemColl.getAllLineItems();
    }    
    
  
    global void beforePricingLineItem(Apttus_Config2.ProductConfiguration.LineItemColl lineItemColl, Apttus_Config2.LineItem lineItem) {     
        Apttus_Config2__LineItem__c lineItemSO = lineItem.getLineItemSO();        
        List<Apttus_Config2.LineItem> listOfAllLineItems = lineItemColl.getAllLineItems();        
    }   
    
    
     
    global void afterPricing(Apttus_Config2.ProductConfiguration.LineItemColl lineItemColl) {
        
    }
    
    global void afterPricingLineItem(Apttus_Config2.ProductConfiguration.LineItemColl lineItemColl, Apttus_Config2.LineItem lineItem){
        if(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT == this.mode){
            Apttus_Config2__LineItem__c lineItemSO = lineItem.getLineItemSO();
            system.debug('<<<< Pricing Data >>>>'+lineItemSO.APTS_LP_Total_Standard_Price__c);
            if(lineItemSO.APTS_LP_Total_Standard_Price__c != null){
                dTotalStdPrice += lineItemSO.APTS_LP_Total_Standard_Price__c;
            }
            
            if(lineItemSO.Apttus_Config2__NetPrice__c != null){
                dTotalQuotePrice += lineItemSO.Apttus_Config2__NetPrice__c;
            }
        }
    }
    
    global void finish(){
        if(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT == this.mode){
            if(dTotalQuotePrice != null & dTotalStdPrice != null){
                bUpdateSummaryGr = true;
            }
            //updateSummaryGroupTotal();
        }
    } 
    
    private void updateSummaryGroupTotal(){
        system.debug('<<<< Summary Group - Prod Config. Id >>>> '+ configID);
        
        Map<Id, Apttus_Config2__SummaryGroup__c> mapSummaryGrpConfigId = new Map<Id, Apttus_Config2__SummaryGroup__c>();
    
        for(Apttus_Config2__SummaryGroup__c sGrp : [ SELECT Id, Name, Apttus_Config2__ConfigurationId__c, APTS_Net_Adjustment_Percent__c, Apttus_Config2__NetAdjustmentPercent__c
                                                     FROM Apttus_Config2__SummaryGroup__c WHERE Apttus_Config2__ConfigurationId__c =: configID LIMIT 10
                                                   ]
           ){
            
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
            
            Decimal totalStdPrice = 0;
            Decimal totalQuotePrice = 0;
            for(Apttus_Config2__LineItem__c lineItem : [SELECT Id, Apttus_Config2__ConfigurationId__c, APTS_LP_Total_Standard_Price__c,
                                                       Apttus_Config2__NetPrice__c 
                                                       FROM Apttus_Config2__LineItem__c
                                                       WHERE Apttus_Config2__ConfigurationId__c IN :mapSummaryGrpConfigId.keySet()]){
                
                if(lineItem.APTS_LP_Total_Standard_Price__c != null){
                    totalStdPrice += lineItem.APTS_LP_Total_Standard_Price__c;
                }
                if(lineItem.Apttus_Config2__NetPrice__c != null){
                    totalQuotePrice += lineItem.Apttus_Config2__NetPrice__c;     
                }
            }
            
            system.debug('<<<< Pricing Data >>>>: '+ totalStdPrice + '-----' + totalQuotePrice);
            List<Apttus_Config2__SummaryGroup__c> listSummaryGroup = new List<Apttus_Config2__SummaryGroup__c>();
            for(Apttus_Config2__SummaryGroup__c summaryGrp : mapSummaryGrpConfigId.values()){
                summaryGrp.APTS_Total_Standard_Price__c = totalStdPrice;
                summaryGrp.APTS_Total_Quote_Price__c = totalQuotePrice;
                listSummaryGroup.add(summaryGrp);
            }
            
            if(listSummaryGroup.size() > 0){
                system.debug('<<<< Final Price >>>>: '+ listSummaryGroup[0].APTS_Total_Standard_Price__c  + '-----' + listSummaryGroup[0].APTS_Total_Quote_Price__c);
                update listSummaryGroup;
            }
        }
    }
        
    
}