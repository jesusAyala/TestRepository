/**
 * Trigger on Product Object.
 * */ 

trigger APTS_ProductTrigger on Product2 (before insert,before update,after insert) {

        System.debug('Inside Trigger ** -->');

        APTS_Product2TriggerHelper helper = new APTS_Product2TriggerHelper();
         
        if (Trigger.isInsert && Trigger.isAfter) {
             try{
                // This method attaches PriceListItem to Product 
                helper.onAfterInsert(Trigger.New);
             }catch(Exception ex){
                 system.debug('Exception exists while inserting PriceListItem' + ex.getMessage());
             }
        }
    }