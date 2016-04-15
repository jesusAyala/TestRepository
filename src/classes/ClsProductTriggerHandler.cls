/**
* @author  Nikhil Pimpale
 * @created 2015-10-01
 * @version 1.0
 * @since   34.0 (Force.com ApiVersion)
 * @description Reporting Workstream : Code to auto-populate the related record Id of Product Group when a new product is inserted or 
 * when a product is updated to change the existing product group.
 * @changelog
 * 23-10-2015 : Nikhil Pimpale: Added the logic to clear the lookup field value if Product Group value is cleared.
 */
public class ClsProductTriggerHandler {
private Map<String,Set<Product2>> prdPGMap = new Map<String,Set<Product2>>();
    public void insertProductGroup (List<Product2> inputProductList)
    {
    try
    {
            for(Product2 prd:inputProductList)
            {
                if(prd.Product_Group__c != null)
                {
                    if(prdPGMap.containskey(String.valueOf(prd.Product_Group__c)))
                    {
                        prdPGMap.get(String.valueOf(prd.Product_Group__c)).add(prd);
                    }
                    else
                    {
                        prdPGMap.put(String.valueOf(prd.Product_Group__c),new Set<Product2> { prd });
                    }
                }
            }
            if(!prdPGMap.isEmpty())
            {
                List<Product_Group__c> productGroupDetailList = new List<Product_Group__c>([Select Id,Business_Unit__c,Division__c,Name From Product_Group__c where Name IN :prdPGMap.keyset() limit 10000]);
                if(productGroupDetailList.size() > 0)
                {
                System.debug('++++productGroupDetailList'+productGroupDetailList);
                    for(Product_Group__c pg:productGroupDetailList)
                    {
                        Set<Product2> tempPrd = new Set<Product2>();
                        tempPrd.addAll(prdPGMap.get(pg.Name));
                        if(!tempPrd.isEmpty())
                        {
                        System.debug('++++tempPrd'+tempPrd);
                            for(Product2 prd:tempPrd)
                            {
                                prd.Related_Product_Group__c =  pg.Id;
                            }
                        }
                    }
                }
            }
        }
        catch(ClsTriggerException cte)
        {
            System.debug('Message: ' + cte.getMessage()); 
        }
    }
    public void updateProductGroup (Map<Id,Product2> inputProductMap,Map<Id,Product2> oldMap)
    {
        try
        {

            for(Product2 prd:inputProductMap.values())
            {
                    if(String.valueOf(prd.Product_Group__c) != String.valueOf(oldMap.get(prd.Id).Product_Group__c))
                    {
                        if(prd.Product_Group__c != null)
                        {
                            if(prdPGMap.containskey(String.valueOf(prd.Product_Group__c)))
                            {
                                prdPGMap.get(String.valueOf(prd.Product_Group__c)).add(prd);
                            }
                            else
                            {
                                prdPGMap.put(String.valueOf(prd.Product_Group__c),new Set<Product2> { prd });
                            }
                        }
                        else
                        {
                            prd.Related_Product_Group__c = null;
                        }
                    }
            }
            if(!prdPGMap.isEmpty())
            {
                List<Product_Group__c> productGroupDetailList = new List<Product_Group__c>([Select Id,Business_Unit__c,Division__c,Name From Product_Group__c where Name IN :prdPGMap.keyset() limit 10000]);
                if(productGroupDetailList.size() > 0)
                {
                System.debug('++++productGroupDetailList'+productGroupDetailList);
                    for(Product_Group__c pg:productGroupDetailList)
                    {
                        Set<Product2> tempPrd = new Set<Product2>();
                        tempPrd.addAll(prdPGMap.get(pg.Name));
                        if(!tempPrd.isEmpty())
                        {
                        System.debug('++++tempPrd'+tempPrd);
                            for(Product2 prd:tempPrd)
                            {
                                prd.Related_Product_Group__c =  pg.Id;
                            }
                        }
                    }
                }
            }
      }
      catch(ClsTriggerException cte)
      {
        System.debug('Message: ' + cte.getMessage()); 
      }
    }
}