/**
@Author Rajesh Kaliyaperumal
@name priceBookEntriesBatch 
@CreateDate 20th October 2015
@Description : To update/insert price book entries for existing/newly entered currencies 
@Version 1.0
*/
global class priceBookEntriesBatch implements Database.Batchable<SObject>
{
    //public Datetime dt = System.now()-1;
    public string mysoql = 'SELECT id, IsActive FROM Product2';
    
    public Database.querylocator start(Database.BatchableContext BchSharing){
        return Database.getquerylocator(mysoql);
    }
    
    global void execute(Database.BatchableContext BchSharing, List<SObject> scope){
        try{
            List<Product2> lstProducts = (List<Product2>)scope;
            Set<String> currencyIsoCodes = new Set<String>();
            Set<Id> setProductIDs = new Set<Id>();
            Set<String> pbCurrencyEntries = new Set<String>();
            List<PricebookEntry> pbEntriesInsert = new List<PricebookEntry>();
            
            //Get standard Pricebnook
            List<Pricebook2> pbList = [SELECT ID FROM Pricebook2 WHERE IsStandard = true];
            Pricebook2 stdPriceBook = pbList.get(0);

            //Get all active currencies
            List<CurrencyType> currencyList = [SELECT Id, IsoCode FROM CurrencyType WHERE IsActive = true LIMIT 50000];     
            for (CurrencyType loopCurrency : currencyList) {
                currencyIsoCodes.add(loopCurrency.IsoCode);
            }
            for (Product2 objProd : lstProducts) {
                setProductIDs.add(objProd.Id);
            }
            //Get existing pricebook entries for products in update 
            List<PricebookEntry> listPricebookEntries = new List<PricebookEntry>([SELECT Id, CurrencyIsoCode, Product2Id
                                                                                  FROM PricebookEntry
                                                                                  WHERE Product2Id IN :setProductIDs
                                                                                  AND CurrencyIsoCode IN :currencyIsoCodes LIMIT 50000]);
            for (PricebookEntry currentEntry : listPricebookEntries) {
                String hash = currentEntry.Product2Id + '_' + currentEntry.CurrencyIsoCode;
                pbCurrencyEntries.add(hash);
            }
            for (Product2 objProd : lstProducts) {  
                //check, if pricebook entries for all currencies are existing
                for (CurrencyType objCurrency : currencyList) {
                    String hash = objProd.Id + '_' + objCurrency.IsoCode;
                    System.debug('Looking for hash ' + hash);               
                    if (!pbCurrencyEntries.contains(hash) ) {                   
                        //Need to add a pricebook entry
                        pbEntriesInsert.add(new PricebookEntry(Pricebook2Id=stdPriceBook.Id, Product2Id = objProd.Id, 
                        IsActive = objProd.IsActive, UnitPrice = 0.00, CurrencyIsoCode = objCurrency.isoCode, UseStandardPrice = FALSE)); 
                    } 
                }   
            }
            if(pbEntriesInsert.size()>0){
                Database.insert(pbEntriesInsert);
            }
            System.debug('Inserting ' + pbEntriesInsert.size() + ' entries into PriceBook2');
        }catch(Exception ex){
            System.debug('Sales Batch Line Number :'+ ex.getLineNumber() + ', Message: '+ ex.getMessage() + ', FullError :'+ ex);
            Log__c objlog = new Log__c(Class_Name__c = 'priceBookEntriesBatch', Error_Line__c = String.valueof(ex.getLineNumber()), Full_Error__c = String.valueof(ex));    
            insert objlog;
        }
    }
    global void finish(Database.BatchableContext ctx){
        
    }
}