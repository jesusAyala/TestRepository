@isTest (seeAllData = true)
public class PriceBookEntriesBatch_TEST{

private static testmethod void priceBookEntriesBatch_Test(){

    Product2 prod1 = new Product2(Name = 'Test Product 1', IsActive = true, CurrencyIsoCode =  'USD');
    insert prod1;
    
    Product2 prod2 = new Product2(Name = 'Test Product 2', IsActive = true, CurrencyIsoCode = 'DKK');
    insert prod2;
    
    Product2 prod3 = new Product2(Name = 'Test Product 3', IsActive = true, CurrencyIsoCode = 'USD');
    insert prod3;
    
    Product2 prod4 = new Product2(Name = 'Test Product 4', IsActive = true, CurrencyIsoCode = 'DKK');
    insert prod4;
    
    Id pricebookId = Test.getStandardPricebookId();
     
    PricebookEntry entry1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod1.Id, UnitPrice = 100, IsActive = true);
    insert entry1;
    
    PricebookEntry entry2 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod2.Id, UnitPrice = 100, IsActive = true);
    insert entry2;
    
    PricebookEntry entry3 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod3.Id, UnitPrice = 100, IsActive = true);
    insert entry3;
    
    PricebookEntry entry4 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod4.Id, UnitPrice = 100, IsActive = true);
    insert entry4;    
    
    //Test.startTest();
    priceBookEntriesBatch batch = new priceBookEntriesBatch();
    batch.mysoql = 'SELECT id, IsActive FROM Product2 WHERE id=\''+prod1.id + '\'';
    Database.executeBatch(batch);
   //  Test.stopTest();
}
}