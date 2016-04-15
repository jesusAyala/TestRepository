public class APTS_DMMSPALineItemHelper extends APTS_DMHelper{

  /**
   * This method contains Bussniess Validation Rule for Validating Stage-MSPA-LineItem Object
   *  Written-By : Hardik Shah
   * 
   * */
     
     public static void validateStageMSPALineItems(List<APTS_Stage_MSPA_LineItems__c> listStageMSPALineItems){
        
         // Boolean Variable to indicate Validation Error
         Boolean bisValidattionError = false;
         APTS_DMHelperUtility dmHelperUtility;
         // Set of Product-Code in MSPA-LineItems
         Set<String> setMSPA_ProductCode = new Set<String>();
         // Set of Valid Product-Code
         Set<String> setValid_ProductCode = new Set<String>();
         // Set of Product-level3-Code in MSPA-LineItems
         Set<String> setMSPA_Product_Level3_Code = new Set<String>();
         // Set of Valid Product-level3-Code
         Set<String> setValid_Product_Level3_Code = new Set<String>();
         // List of updatedMSPALineItems
         List<APTS_Stage_MSPA_LineItems__c> listUpdatedMSPALineItems = new List<APTS_Stage_MSPA_LineItems__c>();
         
         for(APTS_Stage_MSPA_LineItems__c stageMSPALineItem : listStageMSPALineItems){
             
             if(stageMSPALineItem.APTS_Product_Code__c != null && String.isNotBlank(stageMSPALineItem.APTS_Product_Code__c)){
                 setMSPA_ProductCode.add(stageMSPALineItem.APTS_Product_Code__c);
             }
             if(stageMSPALineItem.APTS_Product_Level_3__c != null && String.isNotBlank(stageMSPALineItem.APTS_Product_Level_3__c)){
                 setMSPA_Product_Level3_Code.add(stageMSPALineItem.APTS_Product_Level_3__c);
             }
             
         }
         
         List<APTS_Stage_Product__c> listStageProductCode =  [Select APTS_Product_ID__c   
                                            from APTS_Stage_Product__c where APTS_Product_ID__c  IN :setMSPA_ProductCode
                                            AND APTS_RecordType__c =: APTS_DMConstants.LOCAL_PRODUCTS];
         
         List<Product2> listProductCode =  [Select APTS_Product_ID__c  
                                            from Product2 where APTS_Product_ID__c  IN :setMSPA_ProductCode
                                            AND RecordType.Name =: APTS_DMConstants.LOCAL_PRODUCTS];
         
        AggregateResult[] listStageProductLeve3Codes = [select APTS_Level3_Code__c  
                                                        from APTS_Stage_Local_Hierarchy__c 
                                                        group by   APTS_Level3_Code__c];
         if(listStageProductLeve3Codes!=null && listStageProductLeve3Codes.size() > 0)
          {
              for (AggregateResult ar : listStageProductLeve3Codes)  {
                setValid_ProductCode.add((String)ar.get('APTS_Level3_Code__c'));
              }
          }
        
                
         List<Product2> listProductLevel3Code =  [Select APTS_Hierarchy_Level_3_Code__c
                                            from Product2 where APTS_Hierarchy_Level_3_Code__c IN:setMSPA_Product_Level3_Code
                                            AND RecordType.Name =: APTS_DMConstants.LOCAL_HIERACHY AND 
                                            APTS_Hierarchy_Level_3_Code__c !=null and APTS_Hierarchy_Level_4_Code__c =null 
                                            and APTS_Hierarchy_Level__c =3];                                  
         
         
         if(listProductCode!=null && listProductCode.size() > 0)
         {
             for(Product2 product : listProductCode){
                 setValid_ProductCode.add(product.APTS_Product_ID__c );
             }
         }
                  
         if(listStageProductCode!=null && listStageProductCode.size() > 0)
         {
              for(APTS_Stage_Product__c stageProduct : listStageProductCode){
                  setValid_ProductCode.add(stageProduct.APTS_Product_ID__c  );
              }
             
         }

         if(listProductLevel3Code !=null && listProductLevel3Code .size() > 0)
         {
             for(Product2 product : listProductLevel3Code ){
                 setValid_ProductCode.add(product.APTS_Hierarchy_Level_3_Code__c);
             }
         }
         
         for(APTS_Stage_MSPA_LineItems__c mspaLineItem : listStageMSPALineItems){
              // Boolean Variable to indicate Validation Error
                  bisValidattionError = false;
                dmHelperUtility = New APTS_DMHelperUtility();
             // Validation logic for Product-Code
            if(
	(mspaLineItem.APTS_Product_Code__c!=null && String.isNotBlank(mspaLineItem.APTS_Product_Code__c) &&     mspaLineItem.APTS_Product_Level_3__c!=null && String.isNotBlank(mspaLineItem.APTS_Product_Level_3__c) &&  setValid_ProductCode.contains(mspaLineItem.APTS_Product_Code__c))
    || 
	(mspaLineItem.APTS_Product_Code__c!=null && String.isNotBlank(mspaLineItem.APTS_Product_Code__c) && (mspaLineItem.APTS_Product_Level_3__c==null || String.isBlank(mspaLineItem.APTS_Product_Level_3__c)) && setValid_ProductCode.contains(mspaLineItem.APTS_Product_Code__c)) 
	|| 
	( (mspaLineItem.APTS_Product_Code__c==null || String.isBlank(mspaLineItem.APTS_Product_Code__c))&& mspaLineItem.APTS_Product_Level_3__c!=null && mspaLineItem.APTS_Product_Level_3__c.length() > 0 && setValid_ProductCode.contains(mspaLineItem.APTS_Product_Level_3__c)) ){
             }else{
                bisValidattionError = true;
         dmHelperUtility.appendErrorMessage('Product-Code Doesnt Match with Product-Code in Product \n');
        system.debug('Product-Code Doesnt Match with Product-Code in Product');
                 
             }
             /*Sreekanth
             if(String.isBlank(mspaLineItem.APTS_Product_Code__c) && String.isNotBlank(mspaLineItem.APTS_Product_Level_3__c)) {
                 if(!setValid_Product_Level3_Code.contains(mspaLineItem.APTS_Product_Level_3__c)) {
                    dmHelperUtility.appendErrorMessage('Product-Code Doesnt Match with Product-Code in Product \n'); 
                    //sErrorMessage = sErrorMessage + 'Product-Code Doesnt Match with Product-Code in Product \n';
                    system.debug('Product-Code Doesnt Match with Product-Code in Product');
                 }
             }
             */
         dmHelperUtility.updatevalidationstatus(mspaLineItem,bIsValidattionError);    
          listUpdatedMSPALineItems.add(mspaLineItem);
             
         }
     
      // List of MSPALineItems
     if (listUpdatedMSPALineItems.size() > 0) {
      system.debug('HS--> Size of MSPALineItem to be updated' + listUpdatedMSPALineItems.size());
      try {
          Database.UpsertResult  [] results =   Database.upsert(listUpdatedMSPALineItems);
          system.debug('HS--Approval' + results);
      } 
      catch (Exception ex) {
        System.debug('Exception while upserting MSPA-LineItem.\nException : ' + ex.getMessage());
      }
    }
    
}
    
    public static APTS_CopyDataWrapper copyStageMSPALineItemToLineItem(List < APTS_Stage_MSPA_LineItems__c > listStageMSPALineItem) {
        
        Set<Decimal> spaIdSet = new Set<Decimal>();
        Map<Decimal,Apttus__APTS_Agreement__c> spaIdToAgmtMap = new Map<Decimal,Apttus__APTS_Agreement__c>();
        Map<Decimal,Id> spaIdToConfigIdMap = new Map<Decimal,Id>();
        for (APTS_Stage_MSPA_LineItems__c li: listStageMSPALineItem) {
            spaIdSet.add(li.APTS_SPA_Identifier__c);
        }
        
        if(spaIdSet.size()>0){
            Set<String> productCodeStrSet = New Set<String>();
            for (APTS_Stage_MSPA_LineItems__c sli: listStageMSPALineItem) {
               if(sli.APTS_Product_Code__c!=null && sli.APTS_Product_Code__c.length() > 0)
               {
                 productCodeStrSet.add(sli.APTS_Product_Code__c);
               }
           }
                
           List<Product2> productSoLst = [select id,APTS_Product_ID__c from product2 where APTS_Product_ID__c in :productCodeStrSet ];     
           
           Map<String,String> productCodeIdMap = New Map<String,String>();
           for(Product2 productSo : productSoLst) 
           {
              productCodeIdMap.put(productSo.APTS_Product_ID__c,productSo.id);
           }
    
           Set<id> standAloneProductIdSet = New Set<id>();
        
           for(Apttus__APTS_Agreement__c agmt: [Select Id, APTS_SPA_Identifier__c FROM Apttus__APTS_Agreement__c WHERE APTS_SPA_Identifier__c IN: spaIdSet]){
            
                /* Start of Creating Cart for the Agreement  */
                
                List<Apttus_Config2.Property> configProps = new List<Apttus_Config2.Property>();
                Apttus_Config2.Property prop = new Apttus_Config2.Property();
                Id configId;
                Id objectId;
                
                objectId = agmt.Id;
                prop.Name = APTS_DMConstants.PROPERTY_ADVANCE_APPROVAL;
                //Get the value from Custom Settings
                if(APTS_Custom_Cart_Settings__c.getValues('useAdvancedApproval') != null) {
                    prop.Value = String.ValueOf(APTS_Custom_Cart_Settings__c.getValues('useAdvancedApproval').APTS_Value__c);
                }
                configProps.add(prop);
                               
                prop = new Apttus_Config2.Property();
                prop.Name = APTS_DMConstants.PROPERTY_DEAL_OPTIMIZER;
                //Get the value from Custom Settings
                if(APTS_Custom_Cart_Settings__c.getValues('useDealOptimizer') != null) {
                    prop.Value = String.ValueOf(APTS_Custom_Cart_Settings__c.getValues('useDealOptimizer').APTS_Value__c);
                } 
                configProps.add(prop);
                
                try {
                    configId = Apttus_CMConfig.CMConfigWebService.createConfigurationRequest(objectId,configProps);
                    PageReference pageRef = Apttus_CMConfig.CMConfigWebService.startConfiguration(configId, configProps); 
                    ID cartId = ID.valueOf(pageRef.getParameters().get('id'));

                    system.debug('##configId='+configId);
                    system.debug('##productCodeIdMap='+productCodeIdMap);
                    system.debug('##APTS_SPA_Identifier__c='+agmt.APTS_SPA_Identifier__c);
                    
                    LIST<Decimal> lineNumbers = new LIST<Decimal>();
                                Apttus_CPQApi.CPQ.AddMultiProductRequestDO requests = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO ();
                                requests.CartId = cartId;
                                requests.SelectedProducts = new List<Apttus_CPQApi.CPQ.SelectedProductDO>();
                                
                                system.debug('product ids****'+standAloneProductIdSet);
                                Apttus_CPQApi.CPQ.SelectedProductDO prodDO;
                    for (APTS_Stage_MSPA_LineItems__c sli: listStageMSPALineItem) {
                            
                            
                           if(sli.APTS_Product_Code__c!=null && sli.APTS_Product_Code__c.length() > 0 
                              && productCodeIdMap.containsKey(sli.APTS_Product_Code__c) && sli.APTS_SPA_Identifier__c==agmt.APTS_SPA_Identifier__c)
                                {
                                    prodDO = new Apttus_CPQApi.CPQ.SelectedProductDO();
                                    prodDO.ProductId = productCodeIdMap.get(sli.APTS_Product_Code__c);
                                    prodDo.quantity =  sli.APTS_Quantity__c;
                                    Apttus_Config2__LineItem__c lineItemSo = new Apttus_Config2__LineItem__c();
                                    lineItemSo.APTS_Original_Created_By__c = sli.APTS_CreatedBy__c;
                                    lineItemSo.APTS_Original_Created_On__c = sli.APTS_CreatedOn__c;
                                    lineItemSo.APTS_Discount_Percentage__c = sli.APTS_Discount__c;
                                    lineItemSo.APTS_Discount_Type__c = sli.APTS_Discount_Type__c;
                                    lineItemSo.APTS_External_Id__c = sli.APTS_External_ID__c;
                                    lineItemSo.Apttus_Config2__NetPrice__c = sli.APTS_Net_Price__c;
                                    lineItemSo.APTS_Owner__c = sli.APTS_Owner__c;  
                                    lineItemSo.APTS_LP_Standard_Net__c = sli.APTS_Price__c;
                                    lineItemSo.Apttus_Config2__BasePrice__c = sli.APTS_Price_1_Gross_Price__c;
                                    lineItemSo.APTS_LP_Unit_Of_Price__c = String.valueOf(sli.APTS_Price_Unit__c);
                                    lineItemSo.GTV_Level__c = sli.APTS_Product_Level_3__c;
                                   
                                    lineItemSo.APTS_SPA_Line_Item_Number__c = String.valueOf(sli.APTS_SPA_Line_Item__c); 
                                     prodDO.CustomFields = new List<String>();
                                    prodDO.CustomFields.add('APTS_Original_Created_By__c');
                                    prodDO.CustomFields.add('APTS_Original_Created_On__c');
                                    prodDO.CustomFields.add('APTS_Discount_Percentage__c');
                                    prodDO.CustomFields.add('APTS_Discount_Type__c');
                                    prodDO.CustomFields.add('APTS_External_Id__c');
                                    prodDO.CustomFields.add('Apttus_Config2__NetPrice__c');
                                    prodDO.CustomFields.add('APTS_Owner__c');
                                    prodDO.CustomFields.add('APTS_LP_Standard_Net__c');
                                    prodDO.CustomFields.add('Apttus_Config2__BasePrice__c');
                                    prodDO.CustomFields.add('APTS_LP_Unit_Of_Price__c');
                                    prodDO.CustomFields.add('GTV_Level__c');
                                    prodDO.CustomFields.add('APTS_SPA_Line_Item_Number__c');
                                    prodDO.CustomData = lineItemSo;
                                    requests.SelectedProducts.add(prodDO);    
                                    
                                }
                
                       }
                        
                    system.debug('##standAloneProductIdSet='+standAloneProductIdSet);
                        
                       if(requests.SelectedProducts.size()>0)
                       {
                                
                                
                                system.debug('request****'+requests);
                                Apttus_CPQApi.CPQ.AddMultiProductResponseDO response = Apttus_CPQApi.CPQWebService.addMultiProducts(requests);
                                    
                                lineNumbers = response.LineNumbers; 
                                spaIdToConfigIdMap.put(agmt.APTS_SPA_Identifier__c, cartId);//test
                                system.debug('### lineNumbers: ' + lineNumbers.size());
                             
                       }
            
                    
                }catch(exception e) {
                    
                }
                
                /* End of Creating Cart for the Agreement  */
                
                spaIdToAgmtMap.put(agmt.APTS_SPA_Identifier__c, agmt);
            }
        }
        
        APTS_CopyDataWrapper oCopyWrapper = new APTS_CopyDataWrapper();
        
        system.debug('Copying Data from Staging Object to Normal Object for Local Product');

        List < Apttus_Config2__LineItem__c > listLineItem = new List < Apttus_Config2__LineItem__c > ();

        Schema.SObjectField f = Apttus_Config2__LineItem__c.Fields.APTS_External_Id__c;

        /* Start Reprice and finalize the cart. */
        
            system.debug('##spaIdToConfigIdMap='+spaIdToConfigIdMap);
            if(spaIdToConfigIdMap.size() > 0)
            {
            Set<Id> configIds = new Set<Id>();
            configIds.addAll(spaIdToConfigIdMap.values());
            repriceAndFinalize(configIds);
            }
        /* End Reprice and finalize the cart. */
        
        return oCopyWrapper;
    }
    
    public static void repriceAndFinalize(Set<Id> configIds){
        
        for(Id configId: configIds){
            
            // Reprice the Cart.
            Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
            objUpdatePriceRequestDO.CartId = configId;
            Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
            
            
            // Finalize the Cart.
            Apttus_CMConfig.CMConfigWebService.finalizeConfiguration(configId);
            Apttus_CMConfig.CMConfigWebService.afterFinalizeConfiguration(configId);
        }
        
        
    }

}