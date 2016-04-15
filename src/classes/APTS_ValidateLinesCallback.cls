/**
 *  Apttus Config & Pricing
 *  DefaultValidationCallback
 *   
 *  @2012-2013 Apttus Inc. All rights reserved.

@Name: APTS_ValidateLinesCallback 
@Author: Ganga Vemula
@CreateDate: 27th sep 2015.
@Description: This class is to implement all cart validations
@UsedBy: 
******************************************************************/


global with sharing class APTS_ValidateLinesCallback implements Apttus_Config2.CustomClass.IValidationCallback2 {

 
  /**
   * Callback to validate the line items in the cart
   * @param cart the cart object to validate
   * @return the validation result
   */
  global Apttus_Config2.CustomClass.ValidationResult validateCart(Apttus_Config2.ProductConfiguration cart) {

    // build the validation result 
    Boolean bIsPriceOverride = false;
    Boolean bDiscountIsGreaterThan100 = false;
    Boolean bIsSubstituteDisFail = false;
    Boolean bIsBlankNetPriceOverride = false;
    Boolean bIsBlankDiscount = false;
    Boolean bIsQtyDecimal = false;
    Boolean bIsNetPriceHigherThanBasePrice = false;
    Boolean bIsDiscountTypeNone = false;
    Boolean isLinePriced=false;
    Boolean bNoneDiscTypeHasValue = false;
    
    // get Product Configuration 
    Apttus_Config2__ProductConfiguration__c oConfiguration = cart.getConfigSO();

    // fetch Quote / Agreement record type Product Configuration 
    oConfiguration = [Select Id, Apttus_QPConfig__Proposald__c, Apttus_QPConfig__Proposald__r.RecordType.Name,
                          Apttus_CMConfig__AgreementId__c, Apttus_CMConfig__AgreementId__r.RecordType.Name 
                          from Apttus_Config2__ProductConfiguration__c 
                          where Id = :oConfiguration.Id];

    List < Apttus_Config2.LineItem > listAllLines = cart.getLineItems();
    List < Apttus_Config2__LineItem__C > listAllLineItems = getLineItems(listAllLines);
    /*
    system.debug('****entered validation CB');
    APTS_LocaleInfo__c localeInfo = APTS_LocaleInfo__c.getValues(UserInfo.getLocale());
    String decimalSeparator = '.';
    System.debug('user locale: '+UserInfo.getLocale());
    System.debug('localeInfo: '+localeInfo);
    if(localeInfo != null){
        decimalSeparator = localeInfo.APTS_Decimal_Separator__c;
    }
    System.debug('decimalSeparator: '+decimalSeparator);
    */
    
    Apttus_Config2.CustomClass.ValidationResult result = new Apttus_Config2.CustomClass.ValidationResult(true);
    
    Map<String, String> mapValues = Apttus_Config2.RuntimeContext.getParameters();
    System.debug('Hemant-->'+mapValues);
    String itenNums = mapValues.get('contextLineNumbers');
    String PageAction = mapValues.get('pageAction');
        
    if( (oConfiguration.Apttus_QPConfig__Proposald__c != null && oConfiguration.Apttus_QPConfig__Proposald__r.RecordType.Name.equals(APTS_Constants.QUOTATION_RECORD_TYPE)) || 
        (oConfiguration.Apttus_CMConfig__AgreementId__c != null && oConfiguration.Apttus_CMConfig__AgreementId__r.RecordType.Name.Contains(APTS_Constants.MSPA_TYPE)) ){

      for (Apttus_Config2__LineItem__C item: listAllLineItems) {
        
        
           system.debug('discount type***'+item.APTS_Discount_Type__c );
          //Added by Ganga
          //check if product line item got priced from SAP
          if(!item.APTS_BundleOptionIsHierarchy__c && !item.APTS_Is_Line_Priced__c){
              isLinePriced=true;
           }
              
        
          system.debug('KS--> Discount Type' + item.APTS_Discount_Type__c);
          
        // Blank value is not allowed in Net Price Override for Net Price Discount
        if ( (mapValues.get('pageAction') != 'previousPage' && mapValues.get('pageAction') != 'nextPage')   &&
        item.APTS_Discount_Type__c == APTS_Constants.NET_DISCOUNT && string.isEmpty(String.valueOf(item.APTS_Net_Price_Override__c))) {
          bIsBlankNetPriceOverride = true;
        } 
        
        //Check Net Price Override values less then Gross Price.
        if (item.APTS_Discount_Type__c == APTS_Constants.NET_DISCOUNT && string.isNotEmpty(String.valueOf(item.APTS_Net_Price_Override__c)) &&  item.APTS_Net_Price_Override__c > item.Apttus_Config2__BasePrice__c) {
          bIsNetPriceHigherThanBasePrice = true;
        }

        // Blank value is not allowed in Discount% for Substitute Discount
        
        /*
        if ((item.APTS_Discount_Type__c == APTS_Constants.SUB_DISCOUNT && string.isEmpty(String.valueOf(item.APTS_Discount_Percentage__c))) || 
            (item.APTS_Discount_Type__c == APTS_Constants.SUB_DISCOUNT && !string.isEmpty(String.valueOf(item.APTS_Discount_Percentage__c)) && item.APTS_Discount_Percentage__c < 0)) {
          bIsBlankDiscount = true;
        }
        */
        String itenNum = String.valueOf(item.Apttus_Config2__LineNumber__c);
        System.debug('###' + itenNum );
        
        //Duplicate Line Number Issue - so commented out following code
      /*  if (((mapValues.get('pageAction') == 'previousPage' || mapValues.get('pageAction') == 'nextPage') && (itenNums.contains(itenNum))) 
        && ((item.APTS_Discount_Type__c == APTS_Constants.SUB_DISCOUNT && string.isEmpty(String.valueOf(item.APTS_Discount_Percentage__c))) || 
            (item.APTS_Discount_Type__c == APTS_Constants.SUB_DISCOUNT && !string.isEmpty(String.valueOf(item.APTS_Discount_Percentage__c)) && item.APTS_Discount_Percentage__c < 0))) {
            System.debug('### come here');
            bIsBlankDiscount = true;
        }
        else if ((mapValues.get('pageAction') != 'previousPage' && mapValues.get('pageAction') != 'nextPage')  
        && ((item.APTS_Discount_Type__c == APTS_Constants.SUB_DISCOUNT && string.isEmpty(String.valueOf(item.APTS_Discount_Percentage__c))) || 
            (item.APTS_Discount_Type__c == APTS_Constants.SUB_DISCOUNT && !string.isEmpty(String.valueOf(item.APTS_Discount_Percentage__c)) && item.APTS_Discount_Percentage__c < 0))) {
            bIsBlankDiscount = true;
            System.debug('### come here second condi');
            
         }*/
         
        if ((mapValues.get('pageAction') != 'previousPage' && mapValues.get('pageAction') != 'nextPage')  
        && ((item.APTS_Discount_Type__c == APTS_Constants.SUB_DISCOUNT && string.isEmpty(String.valueOf(item.APTS_Discount_Percentage__c))) || 
            (item.APTS_Discount_Type__c == APTS_Constants.SUB_DISCOUNT && !string.isEmpty(String.valueOf(item.APTS_Discount_Percentage__c)) && item.APTS_Discount_Percentage__c < 0))) {
            bIsBlankDiscount = true;
            
         }
        

        //validate if user entered some value for discount % for Net Price discount type and through an error 
        if (item.APTS_Discount_Type__c == APTS_Constants.NET_DISCOUNT && item.APTS_Discount_Percentage__c != null) {
          bIsPriceOverride = true;
        }

        //Defect 303 Fixed: CAhjolia - Apttus PS: 28Sep2015: to avoid the discount more than 100%.
        //For 'Additional Discount' OR 'Substitute Discount'.
        if ((item.APTS_Discount_Type__c == APTS_Constants.SUB_DISCOUNT || item.APTS_Discount_Type__c == APTS_Constants.ADD_DISCOUNT) && item.APTS_Discount_Percentage__c != null && item.APTS_Discount_Percentage__c > 100) {
          bDiscountIsGreaterThan100 = true;
        } else if (item.APTS_Discount_Type__c == APTS_Constants.NET_DISCOUNT && item.APTS_Net_Price_Override__c != null && item.APTS_Net_Price_Override__c < 0) {
          bDiscountIsGreaterThan100 = true;
        }

        //Defect 423 Fixed: JS - Apttus PS: 29Sep2015: to avoid the Net Price Override for Substitute Discount    
        if (item.APTS_Discount_Type__c == APTS_Constants.SUB_DISCOUNT && item.APTS_Net_Price_Override__c != null) {
          bIsSubstituteDisFail = true;
        }
        
        if(item.Apttus_Config2__Quantity__c != null){
            System.debug('QTY: '+item.Apttus_Config2__Quantity__c);
            Integer intVal = Integer.valueOf(item.Apttus_Config2__Quantity__c);
            if(Decimal.valueOf(intVal) != item.Apttus_Config2__Quantity__c){
                bIsQtyDecimal = true;
            }
        }
        /*
        //Defect 609, Quantity can not contain decimal value
        if ( item.Apttus_Config2__Quantity__c != null && String.valueOf(item.Apttus_Config2__Quantity__c.stripTrailingZeros()).Contains(decimalSeparator) ) {
          System.debug('QTY: '+String.valueOf(item.Apttus_Config2__Quantity__c.stripTrailingZeros()));
          bIsQtyDecimal = true;
        }*/
        
        if(item.APTS_Discount_Type__c == null && (string.isNotEmpty(String.valueOf(item.APTS_Discount_Percentage__c))||string.isNotEmpty(String.valueOf(item.APTS_Net_Price_Override__c)))){
            bNoneDiscTypeHasValue = true;
        }        
        /*
                //Defect 555, Net Price cannot be higher than Base Price
                if( item.Apttus_Config2__BasePrice__c != null && item.Apttus_Config2__NetPrice__c != null && 
                    item.Apttus_Config2__BasePrice__c < item.Apttus_Config2__NetPrice__c ) {
                
                  IsNetPriceHigherThanBasePrice = true;
                }
        */
        /*
        //Check if discount type is none, then the discount % and net price override column values should be null/blank
        if((item.APTS_Discount_Type__c == null || item.APTS_Discount_Type__c == APTS_Constants.NO_DISCOUNT) && string.isNotEmpty(String.valueOf(item.APTS_Discount_Percentage__c))) {
            bIsDiscountTypeNone = true;
        } else if((item.APTS_Discount_Type__c == null || item.APTS_Discount_Type__c == APTS_Constants.NO_DISCOUNT) && string.isNotEmpty(String.valueOf(item.APTS_Net_Price_Override__c))) {
            bIsDiscountTypeNone = true;
        }
        */
      }

      
      if (isLinePriced) {
        result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, LABEL.APTS_SAPPricingError));
        result.isSuccess = false;
      }
      
      if (bIsBlankNetPriceOverride) {
        result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, LABEL.APTS_NoNetPriceOverride));
        result.isSuccess = false;
      }

      if (bIsBlankDiscount) {
        result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, LABEL.APTS_NoBlankDiscount));
        result.isSuccess = false;
      }

      if (bIsPriceOverride) {
        result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, LABEL.APTS_Net_Discount_Validation));
        result.isSuccess = false;
      }

      if (bDiscountIsGreaterThan100) {
        result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, LABEL.APTS_Discount_Validation));
        result.isSuccess = false;
      }
      if (bIsSubstituteDisFail) {
        result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, LABEL.APTS_Substitute_Discount_Validation));
        result.isSuccess = false;
      }

      if (bIsQtyDecimal) {
        result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, LABEL.APTS_QuantityDecimalCheck));
        result.isSuccess = false;
      }

      if (bIsNetPriceHigherThanBasePrice) {
        result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, LABEL.APTS_Net_Price_Overide_Validation));
        result.isSuccess = false;
      }
      
      if(bIsDiscountTypeNone){
          result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, LABEL.APTS_Discount_Type_None));
          result.isSuccess = false;
      }
      
      if(bNoneDiscTypeHasValue){
          result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, LABEL.APTS_Discount_Type_None));
          result.isSuccess = false;    
      }
    }

    return result;

  }


  /**
   * Callback to validate the given list ramp line items
   * @param cart the cart object associated with the ramp line items
   * @param rampLineItems the list of ramp line items
   * @return the validation result
   */
  global Apttus_Config2.CustomClass.ValidationResult validateRampLineItems(Apttus_Config2.ProductConfiguration cart, List < Apttus_Config2.LineItem > rampLineItems) {
    return null;
  }

  /* Gets the list of product line items associated with the Battery line
   * @param cart the cart object
   * @return the list of line item objects
   */
  private static List < Apttus_Config2__LineItem__C > getLineItems(List < Apttus_Config2.LineItem > listAllLines) {

    List < Apttus_Config2__LineItem__C > listLineItems = new List < Apttus_Config2__LineItem__C > ();
    // iterate thru the cart and get the line items matching the battery code1 
    for (Apttus_Config2.LineItem lineItemMO: listAllLines) {
      listLineItems.add(lineItemMO.getLineItemSO());
    }

    return listLineItems;

  }

  /**
   * Callback to validate the given list of asset items
   * @param cart the cart object associated with the asset items
   * @param assetItems the list of asset items
   * @return the validation result
   */
  global Apttus_Config2.CustomClass.ValidationResult validateAssetItems(Apttus_Config2.ProductConfiguration cart, List < Apttus_Config2__TempRenew__c > assetItems) {

    return null;
  }

}