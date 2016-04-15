/*************************************************************
@Name: APTS_Product2TriggerHelper
@Author: Hardik Shah
@Modified; Jagannath Gorti
@CreateDate: 05/09/2015
@Description: Helper Class to Perform operations on Proposal
@UsedBy: APTS_ProposalTriggerHandler
******************************************************************/

public class APTS_Product2TriggerHelper {

	/**
	 * This method Adds PriceList and PricelistItem with ListPrice = 0 on Product
	 * */
	public void onAfterInsert(List < Product2 > listProduct) {

		System.debug('Inside Helper Class **');

		List < Apttus_Config2__PriceList__c > listPrice = [select Id from Apttus_Config2__PriceList__c where Apttus_Config2__Active__c = True];
		List < Apttus_Config2__PriceListItem__c > listPriceListItem = new List < Apttus_Config2__PriceListItem__c > ();
		Map < ID, Schema.RecordTypeInfo > mapRecordType = Product2.sObjectType.getDescribe().getRecordTypeInfosById();

		System.debug('List Price List **' + listPrice);

		set < string > setProductID = new set < String > ();

		for (Product2 p: listProduct) {
			setProductID.add(p.Id);
		}
		System.debug('Set Product Id ***' + setProductID);
		// If PriceList is available
		if (listPrice != null && listPrice.size() > 0) {
			Apttus_Config2__PriceList__c priceList = listPrice.get(0);
			Apttus_Config2__PriceListItem__c priceListItem = null;


			List < Apttus_Config2__PriceListItem__c > listPLI = [select id, name, Apttus_Config2__ProductId__r.APTS_Product_ID__c from Apttus_Config2__PriceListItem__c where Apttus_Config2__ProductId__c
			IN: setProductID];
			map < String, String > mapPLIName = new map < String, String > ();

			for (Apttus_Config2__PriceListItem__c p: listPLI) {
				mapPLIName.put(p.Id, p.name);
			}

			System.debug('List PLI**' + listPLI);
			System.debug('Map PLI Name **' + mapPLIName);
			System.debug('List Product **' + listProduct);
			for (Product2 product: listProduct) {

				if ((mapRecordType.get(product.recordTypeID).getName().equals(APTS_DMConstants.LOCAL_HIERACHY) || mapRecordType.get(product.recordTypeID).getName().equals(APTS_DMConstants.LOCAL_PRODUCTS)) && (product.IsActive == true)) {
					//Do your stuff
					system.debug('***JPG' + product.RecordTypeId);
					//if ((product.RecordType.Name == 'Local Products' || product.RecordType.Name == 'Local Hierarchy') && (product.IsActive == true)){
					if (!mapPLIName.containsKey(product.Id)) {
						priceListItem = new Apttus_Config2__PriceListItem__c();
						priceListItem.Apttus_Config2__PriceListId__c = priceList.id;
						priceListItem.Apttus_Config2__ProductId__c = product.id;
						priceListItem.Apttus_Config2__ListPrice__c = 0;

						if (mapRecordType.get(product.recordTypeID).getName().equals(APTS_DMConstants.LOCAL_HIERACHY)) {
							priceListItem.Apttus_Config2__IsQuantityReadOnly__c = true;
						}

						//priceListItem.Apttus_Config2__ChargeType__c = 'Standard Price';
						listPriceListItem.add(priceListItem);
					}
				}

			} // End of for loop
		} // End of If Statement

		System.debug('ListPriceListItem**' + listPriceListItem);
		// Insert the PriceListItems
		if (listPriceListItem.size() > 0) insert listPriceListItem;
	}

}