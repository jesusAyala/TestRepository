/**
*  @Name: ClsTriggerExchangeRateLoaderHandler
*  @return - void
*  @Description - This class helps to load data in to Exchange rate currency object
*  @Author : Rajesh Kaliyaperumal (Accenture)
*/
public class ClsTriggerExchangeRateLoaderHandler extends ClsTriggerVirtual {
    /**
     * @see IntHelper.beforeTrigger
    */    
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
       
    }    
    /**
     * @see IntHelper.afterTrigger
    */
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {      
        loadDataExchangeRate(trgCtx);
    }
    
    /**
    *  @Name: loadDataExchangeRate
    *  @return - void
    */
    @TestVisible 
    private void loadDataExchangeRate(ClsWrappers.TriggerContext trgCtx) { 
        if(trgCtx.isAfter && trgCtx.isInsert)
        {
            List<DatedConversionRate> lstDatedConvRate = new List<DatedConversionRate>();
            for (sobject so : trgCtx.newList) {             
                Exchange_Rate_Loader__c erl = (Exchange_Rate_Loader__c)so;
                if(erl.Type__c == 'Budget'){
                    DatedConversionRate objDCR = new DatedConversionRate();
                    objDCR.StartDate = System.today();
                    //objDCR.NextStartDate = System.today()+1;
                    objDCR.ISOCODE = erl.CurrencyIsoCode;
                    objDCR.ConversionRate = Decimal.valueof(erl.Value__c);
                    lstDatedConvRate.add(objDCR);
                }
            }
            if(lstDatedConvRate.size()>0){
                //Database.insert(lstDatedConvRate, false);
            }
        }
    }
}