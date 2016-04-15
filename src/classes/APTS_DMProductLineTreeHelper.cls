public class APTS_DMProductLineTreeHelper extends APTS_DMHelper{
/***
     * This Method validates ProdcutLineTree Object
     * Written-By : Hardik Shah
     */ 
    
  public static void validateProductLineTree(List < APTS_Stage_Product_Line_Tree__c > listStageProductLineTree) {

    boolean bisValidattionError = false;
    Boolean isValidateOwner = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_Validate_SFDC_User__c;
    APTS_DMHelperUtility dmHelperUtility ;
    List < APTS_Stage_Product_Line_Tree__c > listUpdatedProductLineTree = new List < APTS_Stage_Product_Line_Tree__c > ();
    Set<String> setBU = getApprovedBUCodes();
    
    List <String> ownerNameList = new List <String>();
    for (APTS_Stage_Product_Line_Tree__c prdLnTree: listStageProductLineTree) {    
        if(prdLnTree.APTS_Owner__c != null) {
          ownerNameList.add(prdLnTree.APTS_Owner__c);
            }
        }
    if(ownerNameList != null && ownerNameList.size()>0)
    APTS_DMHelper.setActiveUserList(ownerNameList);
              
    // iterate over ProductLineTree Object and validate each record
    for (APTS_Stage_Product_Line_Tree__c oProductLineTree: listStageProductLineTree) {

      bisValidattionError = false;
      dmHelperUtility = New APTS_DMHelperUtility ();
            
            // Validate PrdouctLineTree Id for Null Values
    /*  if ((oProductLineTree.APTS_Product_Line_1_ID__c == null) || (oProductLineTree.APTS_Product_Line_2_ID__c == null)
                                                                     || (oProductLineTree.APTS_Product_Line_3_ID__c == null) || oProductLineTree.APTS_PG__c == null) {
                bisValidattionError = true;
        sErromMessage = 'Please check values of either ProductLineId1 or ProductLineId2 or ProductLineId3 or PG field. \n';
        system.debug('Please check values of either ProductLineId1 or ProductLineId2 or ProductLineId3 field');
            }*/
            // Validation ProductLineId1 and ProductLineId2
      if (oProductLineTree.APTS_Product_Line_3_ID__c != null) {

        if (oProductLineTree.APTS_Product_Line_1_ID__c == null || oProductLineTree.APTS_Product_Line_2_ID__c == null) {
          bisValidattionError = true;
          dmHelperUtility.appendErrorMessage('ProdctLine1 Id or ProductLine2 Id cannot be null, as ProductLine3 Id is not null. \n');
          system.debug('HS--> ProdctLine1 Id or ProductLine2 Id cannot be null, as ProductLine3 Id is not null');
        }
            }
            
            // Validation ProductLineId1 and ProductLineId2
      if (oProductLineTree.APTS_Product_Line_2_ID__c != null) {

        if (oProductLineTree.APTS_Product_Line_1_ID__c == null) {
          bisValidattionError = true;
         dmHelperUtility.appendErrorMessage('ProdctLine1 Id cannot be null, as ProductLine2 Id is not null. \n');
         // sErromMessage = sErromMessage + 'ProdctLine1 Id cannot be null, as ProductLine2 Id is not null. \n';
          system.debug('HS-->ProdctLine1 Id cannot be null, as ProductLine2 Id is not null');
        }

      }
     
     // Code comment By Nishi,Waiting for ABB to confirm
      // Validation on Product Line Id 1
      if (oProductLineTree.APTS_Product_Line_1_ID__c == null ) {
          bisValidattionError = true;
         dmHelperUtility.appendErrorMessage('ProdctLine1 Id cannot be null. \n');
         // sErromMessage = sErromMessage + 'ProdctLine1 Id cannot be null, as ProductLine2 Id is not null. \n';
          system.debug('HS-->ProdctLine1 Id cannot be null.');
        }
        
        // Validation on PG
      if (oProductLineTree.APTS_PG__c== null ) {
          bisValidattionError = true;
         dmHelperUtility.appendErrorMessage('PG cannot be null. \n');
         // sErromMessage = sErromMessage + 'ProdctLine1 Id cannot be null, as ProductLine2 Id is not null. \n';
          system.debug('HS-->PG cannot be null.');
        }
        
        // Validation on PG Name
      if (oProductLineTree.APTS_PG_Name__c== null || (string.IsBlank(oProductLineTree.APTS_Owner__c)) ) {
          bisValidattionError = true;
         dmHelperUtility.appendErrorMessage('PG Name cannot be null. \n');
         // sErromMessage = sErromMessage + 'ProdctLine1 Id cannot be null, as ProductLine2 Id is not null. \n';
          system.debug('HS-->PG Name cannot be null.');
        } 

            // Validation of PickList BU
      if (!setBU.contains(oProductLineTree.APTS_BU__c)) {
        bisValidattionError = true;
        dmHelperUtility.appendErrorMessage('Incorrect Values in PickList BU.');
        //sErromMessage = sErromMessage + 'Incorrect Values in PickList BU. \n';
        system.debug('HS--> Incorrect Values in PickList BU');


      }
      
      // Validation on Division Field
      if (oProductLineTree.APTS_Division__c != null) {
		if(!oProductLineTree.APTS_Division__c.equals(APTS_DMConstants.SPAIN_DIVISION) && !oProductLineTree.APTS_Division__c.equals(APTS_DMConstants.SPAIN_DIVISION_NEW) ){
          	bisValidattionError = true;
			dmHelperUtility.appendErrorMessage('Value of Division field Should be LP or EP.\n');
        }
      } else {
        bisValidattionError = true;
       	dmHelperUtility.appendErrorMessage('Value of Division field Should be LP or EP.\n');
        system.debug('HS--> Value of Division field Should be LP or EP.');
      }
      
            //Validation on Active Field
     if(oProductLineTree.APTS_Active__c==null || !(oProductLineTree.APTS_Active__c=='TRUE' || oProductLineTree.APTS_Active__c == 'FALSE')) {
         bisValidattionError = true;
       dmHelperUtility.appendErrorMessage('Incorrect Values in Active Field. \n');
       // sErromMessage = sErromMessage + 'Incorrect Values in Active Field. \n';
        system.debug('HS--> Incorrect Values in Active Field');
     }
     
     //validation on BU Name field
     APTS_Stage_Data_Validation_Rules_Setting__c allowedBUNames = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration');
     if(allowedBUNames==null || allowedBUNames.APTS_SProductLineTree_BUName__c==null) {
         
        system.debug('***JPG' + oProductLineTree.APTS_BU_Name__c);
        system.debug('***JPG' + allowedBUNames);
         
         bisValidattionError = true;
        dmHelperUtility.appendErrorMessage('No values found in custom setting with name DataMigration to validate for BU Name.');
        //sErromMessage = sErromMessage + 'No values found in custom setting with name DataMigration to validate for BU Name. \n';
        system.debug('HS--> No values found in custom setting found with name DataMigration');
     }
     else {
         List<String> csBUNames = allowedBUNames.APTS_SProductLineTree_BUName__c.split(';');
         for(integer i=0;i<csBUNames.size();i++)
            csBUNames[i] = csBUNames[i].trim();
         Set<String> buNamesSet = new Set<String>();
         buNamesSet.addAll(csBUNames);
         

         
         if(oProductLineTree.APTS_BU_Name__c==null || !buNamesSet.contains(oProductLineTree.APTS_BU_Name__c)) {
             bisValidattionError = true;
            dmHelperUtility.appendErrorMessage('Incorrect Values in BU Name Field. \n');
            //sErromMessage = sErromMessage + 'Incorrect Values in BU Name Field. \n';
            system.debug('HS--> Incorrect Values in BU Name Field');
         }
     }

      // Validation APTS_Owner__c populated with the First & Last name from the User Object
      if (!string.IsBlank(oProductLineTree.APTS_Owner__c)) {
          if(!APTS_DMHelper.validateUser(oProductLineTree.APTS_Owner__c)) {
             bisValidattionError = true;
             dmHelperUtility.appendErrorMessage('No Active owner found in users \n');
          }
      } else {
            bisValidattionError = true;
            dmHelperUtility.appendErrorMessage('Invalid Owner Name \n');
            system.debug('HS--> Invalid Owner Name ');
      }
      
     dmHelperUtility.updateValidationStatus(oProductLineTree, bisValidattionError);
     listUpdatedProductLineTree.add(oProductLineTree); 

    } // End of for loop
    
        // Update the list of Record using Data.base upsert method
    if (listUpdatedProductLineTree.size() > 0) {
      system.debug('HS--> Size of ProductLineTree to be updated' + listUpdatedProductLineTree.size());
      try {
        Database.UpsertResult [] results =   Database.upsert(listUpdatedProductLineTree);
        system.debug('HS--ProductLineTree' + results);
      } catch (Exception ex) {
        System.debug('Exception while upserting Staging Product Line Tree Data.\nException : ' + ex.getMessage());
      }
    }
  }
    
    /**
     * This method copies Staging Object (Product-Line-Tree) to Normal Object (Product-Line-Tree)
     * 
     *  Written by : Hardik Shah
     * 
     * 
     **/
    public static APTS_CopyDataWrapper copyProductLineTree(List < APTS_Stage_Product_Line_Tree__c > listStageProductLineTree) {

        APTS_CopyDataWrapper oCopyWrapper = new APTS_CopyDataWrapper();
        system.debug('HS--> Copying Data from Staging Object to Normal Object');
        // List of ProductLineTree Objects that needs to be updated
        List < APTS_Product_Line_Tree__c > listProductLineTree = new List < APTS_Product_Line_Tree__c > ();
        
        Schema.SObjectField f = APTS_Product_Line_Tree__c.Fields.APTS_External_Id__c;
        APTS_Product_Line_Tree__c oProductLineTree = null;
        
        List <String> ownerNameList = new List <String>();
        for (APTS_Stage_Product_Line_Tree__c prdLnTree: listStageProductLineTree) {    
            if(prdLnTree.APTS_Owner__c != null) {
              ownerNameList.add(prdLnTree.APTS_Owner__c);
                }
        }
        if(ownerNameList != null && ownerNameList.size()>0)
        APTS_DMHelper.setActiveUserList(ownerNameList);
        
        // Creating Product Line Tree, assigning values and adding into List.
        for (APTS_Stage_Product_Line_Tree__c stageProductLineTree: listStageProductLineTree) {
            oProductLineTree = new APTS_Product_Line_Tree__c();
            oProductLineTree.APTS_Alternative_ID__c = stageProductLineTree.APTS_Alternative_ID__c;
            oProductLineTree.APTS_BU__c = stageProductLineTree.APTS_BU__c;
            oProductLineTree.APTS_BU_Name__c = stageProductLineTree.APTS_BU_Name__c;
            oProductLineTree.APTS_Division__c = stageProductLineTree.APTS_Division__c;
            oProductLineTree.APTS_Final_ID__c = stageProductLineTree.APTS_Final_ID__c;
            oProductLineTree.APTS_PG__c = stageProductLineTree.APTS_PG__c;
            oProductLineTree.APTS_PG_Name__c = stageProductLineTree.APTS_PG_Name__c;
            oProductLineTree.APTS_Product_Line_1_ID__c = stageProductLineTree.APTS_Product_Line_1_ID__c;
            oProductLineTree.APTS_Product_Line_1_Name__c = stageProductLineTree.APTS_Product_Line_1_Name__c;
            oProductLineTree.APTS_Product_Line_2_ID__c = stageProductLineTree.APTS_Product_Line_2_ID__c;
            oProductLineTree.APTS_Product_Line_2_Name__c = stageProductLineTree.APTS_Product_Line_2_Name__c;
            oProductLineTree.APTS_Product_Line_3_ID__c = stageProductLineTree.APTS_Product_Line_3_ID__c;
            oProductLineTree.APTS_Product_Line_3_Name__c = stageProductLineTree.APTS_Product_Line_3_Name__c;
            oProductLineTree.APTS_External_Id__c = stageProductLineTree.APTS_External_ID__c;
            oProductLineTree.OwnerID = APTS_DMHelper.getUserforLoad(stageProductLineTree.APTS_Owner__c);
                    
            listProductLineTree.add(oProductLineTree);
        }

        // Upserting the list
        try {
            if (listProductLineTree.size() > 0) {
                Database.UpsertResult[] results = Database.upsert(listProductLineTree, f, false);
                system.debug('HS--> Error ' + results);
                Set<Id> SuccessIdSet = New Set<id>();
  
  
                for (Database.UpsertResult sr: results) {

                    if (sr.isSuccess()) {
                    successIdSet.add(sr.getId());
                        System.debug('Successfully inserted ProductLineTree: ' + sr.getId());
                    } else {
                        // Operation failed, so get all errors 
                        oCopyWrapper.bIsUpsertFail = true;
                        for (Database.Error err: sr.getErrors()) {
                            System.debug('The following error has occurred.');
                            oCopyWrapper.sErrorMessage = oCopyWrapper.sErrorMessage + '<br/><br/>' + err.getStatusCode() + ': ' + err.getMessage();
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('ProductLine fields that affected this error: ' + err.getFields());
                        }
                    }
                }
                
                  APTS_DMHelper.updateLoadingStatus( successIdSet, 'APTS_Product_Line_Tree__c', 'APTS_External_ID__c', 'APTS_External_ID__c', listStageProductLineTree);

                system.debug('HS1--> copyDataWrapper ' + oCopyWrapper);
            }


        } catch (Exception e) {
            System.debug('Exception while upserting Product Line Tree records.\nException : ' + e.getMessage());
            oCopyWrapper.sErrorMessage = e.getMessage();
            oCopyWrapper.bIsUpsertFail = true;
        }

        return oCopyWrapper;
    }

    private static Set<String> getApprovedBUCodes(){
        Set<String> result = new Set<String>();

        APTS_Stage_Data_Validation_Rules_Setting__c customSetting = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration');
        if( customSetting != null && customSetting.APTS_Product_Line_Tree_BUs__c != null ){
            result.addAll(customSetting.APTS_Product_Line_Tree_BUs__c.split(';'));
        }
			        
        return result;
    }
}