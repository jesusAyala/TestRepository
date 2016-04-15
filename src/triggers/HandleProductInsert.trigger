/**********************************************************************
 Trigger to handle newly inserted Products,
 creating a PriceBookEntry for every Currency of the Org

 History
 -------
 Date          AUTHOR                  DETAIL
 26.03.2014    Stefan Talkenberg        Initial Version
 30.03.2015    Stefan Talkenberg        Changed to hanlde only insert
 06.10.2015    Nikhil Pimpale         Added before update method call.
 23.10.2015    Nikhil Pimpale         Added the trigger Framework control.
***********************************************************************/
trigger HandleProductInsert on Product2 (before insert,after insert) {
if(System.Label.SYS_RUN_HandleProductInsert.equalsIgnoreCase('Y'))
{
    if(Trigger.isBefore)
    {
        ClsProductTriggerHandler prdHandler = new ClsProductTriggerHandler();
        prdHandler.insertProductGroup(Trigger.New);  
    }
    else
    {
        if(!Test.isRunningTest())
        {
        //Get ID of Standard pricebook
        List<Pricebook2> pbList = [SELECT ID FROM Pricebook2 WHERE IsStandard = true];
        Pricebook2 defaultPb = pbList.get(0);
    
        //Get all active currencies
        List<CurrencyType> currencyList = [SELECT Id, IsoCode FROM CurrencyType WHERE IsActive = true];
        
        List<PricebookEntry> pbEntriesInsert = new List<PricebookEntry>();
    
        for (Product2 loopProduct : Trigger.new) {
            for (CurrencyType c : currencyList) {
                pbEntriesInsert.add(new PricebookEntry(
                                    Pricebook2Id=defaultPb.Id,
                                    Product2Id = loopProduct.ID, 
                                    IsActive=loopProduct.IsActive,
                                    UnitPrice=0.00,
                                    CurrencyIsoCode=c.isoCode,
                                    UseStandardPrice=FALSE)
                                );  
                }
            }
        
        //Insert the PricebookEntries
        insert pbEntriesInsert;
        }
    }
}
}