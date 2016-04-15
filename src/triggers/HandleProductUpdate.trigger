/**********************************************************************
 HandleProductUpdate

 Trigger to handle updated inserted Products,
 creating miisung PriceBookEntries

 History
 -------
 Date          AUTHOR                  DETAIL
  30.03.2015    Stefan Talkenberg      Initial revision
  06.10.2015    Nikhil Pimpale         Added before update method call.
  23.10.2015    Nikhil Pimpale         Added the trigger Framework control.
***********************************************************************/
trigger HandleProductUpdate on Product2 (before update,after update) {
if(System.Label.SYS_RUN_HandleProductUpdate.equalsIgnoreCase('Y'))
{
    if(Trigger.isBefore)
    {
        ClsProductTriggerHandler prdHandler = new ClsProductTriggerHandler();
        prdHandler.updateProductGroup(Trigger.NewMap,Trigger.OldMap);
    }
    else
    {
        if(!Test.isRunningTest())
        {    
        //Get standard Pricebnook
        List<Pricebook2> pbList = [SELECT ID FROM Pricebook2 WHERE IsStandard = true];
        Pricebook2 stdPriceBook = pbList.get(0);
    
        //Get all active currencies
        List<CurrencyType> currencyList = [SELECT Id, IsoCode FROM CurrencyType WHERE IsActive = true];
    
        Set<String> currencyIsoCodes = new Set<String>();
        for (CurrencyType loopCurrency : currencyList) {
            currencyIsoCodes.add(loopCurrency.IsoCode);
        }
    
        //Get product IDs
        Set<Id> productIDs = new Set<Id>();
        for (Product2 loopProduct : trigger.new) {
            productIDs.add(loopProduct.Id);
        }
    
        //Get existing pricebook entries for products in update 
        List<PricebookEntry> listPricebookEntries = new List<PricebookEntry>([SELECT Id, CurrencyIsoCode, Product2Id
                                                                              FROM PricebookEntry
                                                                              WHERE Product2Id in :productIDs
                                                                              AND CurrencyIsoCode in :currencyIsoCodes]);
    
        Set<String> pbCurrencyEntries = new Set<String>();
        for (PricebookEntry currentEntry : listPricebookEntries) {
            String hash = currentEntry.Product2Id + '_' + currentEntry.CurrencyIsoCode;
            System.Debug('Created hash: ' + hash);
            pbCurrencyEntries.add(hash);
        }
        
        List<PricebookEntry> pbEntriesInsert = new List<PricebookEntry>();
        
        //Check for changes
        for (Id productID : Trigger.newMap.keySet()) {  
            
            Product2 oldProduct = Trigger.oldMap.get(productID);
            Product2 newProduct = Trigger.newMap.get(productID);
            Integer newPbEntries = 0;
    
            //check, if pricebook entries for all currencies are existing
            for (CurrencyType loopCurrency : currencyList) {
                String hash = newProduct.Id + '_' + loopCurrency.IsoCode;
                System.debug('Looking for hash ' + hash);
                
                if (!pbCurrencyEntries.contains(hash) ) {
                    System.debug('not found, adding!');
                    //Need to add a pricebook entry
                    pbEntriesInsert.add(new PricebookEntry(
                                            Pricebook2Id=stdPriceBook.Id,
                                            Product2Id=newProduct.Id, 
                                            IsActive=newProduct.IsActive,
                                            UnitPrice=0.00,
                                            CurrencyIsoCode=loopCurrency.isoCode,
                                            UseStandardPrice=FALSE)
                                        ); 
                    newPbEntries++;
                } else {
                    System.debug('.. found!');
                }
            }
            //Check for unchanged products
            //if (oldProduct.name == newProduct.name &&
            //  oldProduct.Parent_CID__c == newProduct.Parent_CID__c &&
            //  oldProduct.Product_Group__c == newProduct.Product_Group__c) {
         //     //prevent the record from being updated
         //     System.Debug('No changes for ' + newProduct.cid__c + ' - '+ newProduct.name);
         //     newProduct.addError('Product unchanged, added ' + newPbEntries + ' PriceBookEntries.');
         //   } else {
         //     System.Debug('CHANGED: ' + newProduct.cid__c + ' - '+ newProduct.name);   
         //   }
        }
        
        System.debug('Inserting ' + pbEntriesInsert.size() + ' entries into PriceBook2');
        insert(pbEntriesInsert);
    }
  }  
}
}