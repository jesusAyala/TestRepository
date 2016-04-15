/**
 * TriggerClass -  Mass Update the Flag on Opportunity Commit 
 * Updated for R5 req 2462 
*/
global with sharing class PISOpportunityProductsExtension {

/**
 * Method PISNode
 * Helper class to decode input format from VF page 
*/
    global class PISNode
    {
         private String cid;
         private String englishDescription;
         private String languageSpecificDescription;
    }

/**
 * Method ProductResult 
*/
    global class ProductResult {
        private List<PISNode> failedProducts;
        private Integer processed;
        private Integer failed;
        private Integer total;
        private boolean success;
        private Id lineItemId;
/**
 * Method ProductResult 
*/
        public ProductResult() {
            this.processed = 0;
            this.failed = 0;
            this.total = 0;
            this.failedProducts = new List<PISNode>();
        }
    }

    private final Opportunity oppty;
    private final OpportunityLineItem opptyLineItem;

/**
 * Controller PISOpportunityProductsExtension
*/  
public PISOpportunityProductsExtension(ApexPages.StandardController controller) {
        String controllerName = String.valueOf(controller.getRecord().getSObjectType());
        //System.debug('Controller: ' + controllerName);
        
        if (controllerName == 'OpportunityLineitem') {
            this.opptyLineItem = (OpportunityLineItem)controller.getRecord();
            this.oppty = this.opptyLineItem.Opportunity;
        } else {
            this.oppty = (Opportunity)controller.getRecord();
        }
    }

/**
 * Method replaceProduct
*/ 
    @RemoteAction
    global static ProductResult replaceProduct(ID lineItemId, PISNode newProduct) {
        //System.debug('replaceProduct(): Line Item ID: ' + lineItemId);
        //System.debug('Replace with [' + newProduct.cid + '] - ' + newProduct.englishDescription);
        
        ProductResult result = new ProductResult();
        Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
        
        //Get the Opportunity Line Item
        OpportunityLineitem oldOli = [SELECT Id, PricebookEntryId, CurrencyIsoCode, OpportunityId, Quantity, TotalPrice
                                      FROM OpportunityLineitem
                                      WHERE Id = :lineItemId LIMIT :remLimit];
        
        //Get the pricebook entry of the replacement product
        List<PricebookEntry> pbEntryList = [SELECT Id, Product2Id, CurrencyIsoCode, IsActive
                                            FROM PricebookEntry
                                            WHERE CurrencyIsoCode = :oldOli.CurrencyIsoCode
                                            AND IsActive = true
                                            AND Product2.cid__c = :newProduct.cid LIMIT :remLimit];


        if (pbEntryList.size() != 1) {
           // System.debug('Unexpected: ' + pbEntryList.size() + ' PB Entry for ' + newProduct.cid + '[' + oldOli.CurrencyIsoCode + '] found!');
            result.failedProducts.add(newProduct);
            result.failed++;
            result.success=false;
            return result;
        }
        
        PricebookEntry newPBEntry = pbEntryList.get(0);
        
        OpportunityLineitem newOli = new OpportunityLineitem(OpportunityId=oldOli.OpportunityId,
                                                             PricebookEntryId=newPBEntry.Id,
                                                             Quantity=oldOli.Quantity,
                                                             TotalPrice=oldOli.TotalPrice);
        
        ////Get the new product
        //Product2 tmpNewProduct = [SELECT Id, name, cid__c, parent_cid__c
        //                          FROM Product2
        //                          WHERE Id = :newPBEntry.Product2Id];
        
        ////Get the Old PB Entry
        //PricebookEntry oldPBEntry = [SELECT Id, Product2Id, CurrencyIsoCode
        //                             FROM PricebookEntry
        //                             WHERE Id = :oli.PriceBookEntryId];

        //                         //Get the Opportunity Line Item
        ////Get the old product
        //Product2 oldProduct = [SELECT Id, name, cid__c, parent_cid__c
        //                       FROM Product2
        //                       WHERE Id = :oldPBEntry.Product2Id];

        
        //System.debug('Old PB Entry [' + oldPBEntry.Id + '] - ' + oldProduct.cid__c);
        //oli.PricebookEntryId = newPBEntry.Id;
        //System.debug('New PB Entry [' + oli.PriceBookEntryId + '] - ' + tmpNewProduct.cid__c);

        
        try {
            Database.Delete(oldOli); 
            Database.Insert(newOli);
            
            result.processed++;
            result.total++;
            result.lineItemId = newOli.Id;
            result.success=true;
        }
        catch (Exception e) {
           // System.debug('Failed to update: ' + e.getMessage());
            result.total++;
            result.success=false;
        }
        return result;
    }

/**
 * Method addProducts
*/
    @RemoteAction
    global static ProductResult addProducts(ID opptyID, List<PISNode> products) {
        //System.debug('addProdcuts() Oppty ID: ' + opptyID);
        Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
        ProductResult result = new ProductResult();
        
        //Get the opportunity
        Opportunity oppty = [SELECT Id, CurrencyIsoCode, Pricebook2Id
                            FROM Opportunity 
                            WHERE Id = :opptyID LIMIT :remLimit];
        
        Id priceBookId = oppty.Pricebook2Id;

        //Check if the pricebook is set
        if (NULL == priceBookId) {
            List<Pricebook2> priceBooks = [SELECT Id, Name, IsActive, isStandard 
                                           FROM Pricebook2 
                                           WHERE IsActive = true AND IsStandard = true LIMIT :remLimit];
            priceBookId = priceBooks[0].Id;
           // System.Debug('PriceBook is not set, using standard pricebook [' + priceBookId + ']');
        }
        
        List<OpportunityLineItem> oliInsertList = new List<OpportunityLineItem>();
        //loop over products & create opportunity line items
        
        for (PISNode product : products) {
            result.total++;
            
            //Get pricebook entry
           // System.debug('Product: ' + product);
          
            List<PriceBookEntry> priceBookEntry = [SELECT Id, Product2Id, Product2.Id, Product2.Name
                                                   FROM PriceBookEntry
                                                   WHERE Product2.cid__c = :product.cid
                                                   AND CurrencyIsoCode = :oppty.CurrencyIsoCode
                                                   AND IsActive = true LIMIT :remLimit];

            if (priceBookEntry.size() == 0) {
              //  System.debug('No Pricebook Entry for ' + product.cid + '[' + oppty.CurrencyIsoCode + ']!');
                result.failedProducts.add(product);
                result.failed++;
            } else {
               // System.debug(PriceBookEntry.size() + ' PB entries for ' + product.cid + '. Using [' + priceBookEntry.get(0).Id + ']');
                //Create new LineItem
                OpportunityLineItem oli = new OpportunityLineItem();
                oli.OpportunityID = oppty.Id;
                oli.PriceBookEntryID = priceBookEntry.get(0).Id;
                oli.Quantity = 1;
                oli.TotalPrice = 0;
                if (product.languageSpecificDescription != null) {
                    oli.Description = product.languageSpecificDescription;
                }
                oliInsertList.add(oli);
            }
        }

        try {
            Database.Insert(oliInsertList);
        }
        catch (System.DmlException e) {
            //System.debug('Failed to add: ' + e.getMessage());
            for (Integer i = 0; i < e.getNumDml(); i++) {
                result.failed++;
                //System.debug(e.getDmlMessage(i));
            }
        }
        
        result.processed = result.total - result.failed;
        // System.debug('Result (Total/Added/Failed): ' + result.total + '/' + result.processed + '/' + result.failed);
        
        if (result.failed > 0) {
            result.success = false;
            for (PISNode failedNode:result.failedProducts) {
               // System.debug('Failed: [' + failedNode.cid + '] - ' + failedNode.englishDescription + '\n');
            }

        } else {
            result.success = true;
        }
        return result;
    }
}