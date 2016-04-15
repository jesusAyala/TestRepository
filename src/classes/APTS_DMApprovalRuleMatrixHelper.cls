public class APTS_DMApprovalRuleMatrixHelper extends APTS_DMHelper{

  /**
   * This method contains Bussniess Validation Rule for Validating Stage Approval Rule Matrix Product
   *  Written-By : Hardik Shah
   * 
   * */
  
    public static void validateApprovalMatrix(List<APTS_Stage_Approval_Rule_Matrix__c>  listApprovalMatrix){
        
        system.debug('HS-> Inside validateApprovalMatrix ::' + listApprovalMatrix.size());
        // Boolean flag to indicate validation error in record
      boolean bisValidattionError = false;
     Boolean isValidateOwner = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_Validate_SFDC_User__c;
      
     APTS_DMHelperUtility dmHelperUtility ;
    // set of masterCode from MasterPickList Table
    Set<String> setMasterCode = new Set<String>();
    // list of Stage Approval Matrix Objects that needs to be updated 
    List<APTS_Stage_Approval_Rule_Matrix__c> listUpdateStageApprovalRuleMatrix = new List<APTS_Stage_Approval_Rule_Matrix__c>();
    // Fetch list of Master Codes
    List<APTS_Master_Picklist_Table__c> listMasterCode = APTS_DMHelper.getMasterListCodes();
    // set of GTV-Codes 
    Set<String> setGTVCode = new Set<String>();
    
    Set<String> assignedToSet = New Set<String>();
      
    Set<String> salesOfficeSet = New Set<String>();
    
    Set<String> gtvStageLevelCodeSet = New Set<String>();
    
    List <String> ownerNameandAssignedApproverList = new List <String>();
    Organization oOrgDetail = [Select Id,Name, IsSandbox from Organization];
    String urlStr = String.valueOf(System.Url.getSalesforceBaseURL()) ; 
    String instanceNameStr= urlStr.subString(urlStr.indexOf('--')+2,urlStr.indexOf('.'));
        
       for(APTS_Stage_Approval_Rule_Matrix__c oApprovalMatrix : listApprovalMatrix){
            
            if(oApprovalMatrix.APTS_Assigned_to__c!=null && oApprovalMatrix.APTS_Assigned_to__c.length() > 0)
            {
                if(oOrgDetail.IsSandbox) {
                    String sAssignedTo = oApprovalMatrix.APTS_Assigned_to__c + '.' + instanceNameStr;
                    System.debug('Assigned To***'+ sAssignedTo);
                    assignedToSet.add(sAssignedTo);
                }else {
                    assignedToSet.add(oApprovalMatrix.APTS_Assigned_to__c);
                }
            }
            
            if(oApprovalMatrix.APTS_Sales_Office__c!=null && oApprovalMatrix.APTS_Sales_Office__c.length() > 0)
            {
                salesOfficeSet.add(oApprovalMatrix.APTS_Sales_Office__c);
            }
            if(oApprovalMatrix.APTS_Owner__c != null) {
                ownerNameandAssignedApproverList.add(oApprovalMatrix.APTS_Owner__c);
            }
            if(oApprovalMatrix.APTS_GTV_Level_Code__c != null && oApprovalMatrix.APTS_GTV_Level_Code__c.length() >0) {
                gtvStageLevelCodeSet.add(oApprovalMatrix.APTS_GTV_Level_Code__c);
            }
       }
       
        if(ownerNameandAssignedApproverList != null && ownerNameandAssignedApproverList.size()>0)
        APTS_DMHelper.setActiveUserList(ownerNameandAssignedApproverList);
        
       Map<String,LSO_Field_Entries__c> lsoFieldEntryCodeMap = New Map<String,LSO_Field_Entries__c>();
        // create a map of LSO_Field_Entries__c where the key is the description and the value is the sObject
        if(salesOfficeSet.size() > 0)
        {
            List<LSO_Field_Entries__c> lsoFieldEntrySoLst = [select id,PickList_Description__c,PickList_Code__c from LSO_Field_Entries__c where LSO_Pick_List_Value_Name__c = 'LSO Reference Data. Sales Office' and PickList_Code__c in :salesofficeSet];                             
            if(lsoFieldEntrySoLst!=null && lsoFieldEntrySoLst.size() > 0)
            {
                for(LSO_Field_Entries__c lsoFESO : lsoFieldEntrySoLst)
                {
                   lsoFieldEntryCodeMap.put(lsoFESO.PickList_Code__c,lsoFESO);
                }
            }
        }
      
      Map<String, User> userNameMap = New Map<String,User>();
      if(assignedToSet.size() > 0)
      {
          List<User> userSoLst = [select id,name,username from User where isActive=true AND username in: assignedToSet ];
          String userEmailStr;
          
          for(User userSo: userSoLst )
         {
            userEmailStr=userSo.username; 
            if(userEmailStr.contains(instanceNameStr.tolowerCase()))
            {
                try{
                    userEmailStr=userEmailStr.substring(0,userEmailStr.lastIndexOf('.'+instanceNameStr.tolowercase()));
                } 
                catch(Exception e) {
                    
                }
              
            }
            userNameMap.put(userEmailStr ,userSo);
          }
      }
      
      // create a set of Master-codes
      for(APTS_Master_Picklist_Table__c masterCode : listMasterCode ){
         setMasterCode.add(masterCode.APTS_Code__c);
         
      }
      
      system.debug('HS--> Master-code' + setMasterCode );
      
      List<APTS_Stage_Local_Hierarchy__c> listStageHierarchy = [Select APTS_Level3_Code__c from APTS_Stage_Local_Hierarchy__c
                                                      where APTS_Level3_Code__c in :gtvStageLevelCodeSet];
      if(listStageHierarchy != null && listStageHierarchy.size()>0) {
          for(APTS_Stage_Local_Hierarchy__c oStageHierarchy : listStageHierarchy){
            setGTVCode.add(oStageHierarchy.APTS_Level3_Code__c);                          
         }
      }
      // Fetch APTS_Hierarchy_Level_3_Code__c (GTV-code) from Product with RecordType as LOCAL_HIERACHY
      List<Product2>  listProduct =  [Select APTS_Hierarchy_Level_3_Code__c  from Product2 
                                      where RecordType.Name =: APTS_DMConstants.LOCAL_HIERACHY and APTS_Hierarchy_Level__c = 3];
     
      for(Product2 oProduct : listProduct){
          setGTVCode.add(oProduct.APTS_Hierarchy_Level_3_Code__c);                          
      }
      
       system.debug('HS--> GTV-code' + setGTVCode );
      
     for(APTS_Stage_Approval_Rule_Matrix__c oApprovalMatrix : listApprovalMatrix){
         
          bisValidattionError = false;

          dmHelperUtility = New APTS_DMHelperUtility();
         // Verify the local-Channel from MasterPickList
         if(oApprovalMatrix.APTS_Local_Channel__c != null && setMasterCode.contains(oApprovalMatrix.APTS_Local_Channel__c)){
             
         }else{
            bisValidattionError = true;
        dmHelperUtility.appendErrorMessage('Invalid Local-Channel-Code \n');
        //sErromMessage = sErromMessage + 'Invalid Local-Channel-Code \n';
        system.debug('Invalid Local-Channel-Code');
         }
         
         // Verify active assigned to       
         if (!string.IsBlank(oApprovalMatrix.APTS_Assigned_to__c)) {
              if(!userNameMap.containsKey(oApprovalMatrix.APTS_Assigned_to__c)) {
                 bisValidattionError = true;
                 dmHelperUtility.appendErrorMessage('Assigned user is not Active \n');
              }
         } else {
            bisValidattionError = true;
            dmHelperUtility.appendErrorMessage('Invalid Assigned to. The user '+ oApprovalMatrix.APTS_Assigned_to__c+ '\n');
         }
         
         // Verify the SalesOffice from LSO_Field_Entries__c
         if(oApprovalMatrix.APTS_Sales_Office__c != null && oApprovalMatrix.APTS_Sales_Office__c.length() > 0  && lsoFieldEntryCodeMap.containsKey(oApprovalMatrix.APTS_Sales_Office__c)){
             
         }
         else{
            bisValidattionError = true;
        dmHelperUtility.appendErrorMessage('Invalid SalesOffice \n');
       // sErromMessage = sErromMessage + 'Invalid SalesOffice \n';
        system.debug('Invalid SalesOffice');
         } 
         
         // ThreShold Discoount Validation
         if(oApprovalMatrix.APTS_Threshold_Discount__c < 0 || oApprovalMatrix.APTS_Threshold_Discount__c > 100 ){
            bisValidattionError = true;
         dmHelperUtility.appendErrorMessage('Threshold Discount should be greater than zero or less than 100 \n');
        system.debug('Threshold Discount should be greater than zero or less than 100');
         }
         
         // Validation Check for GTV-Code
         if(oApprovalMatrix.APTS_GTV_Level_Code__c != null && setGTVCode.contains(oApprovalMatrix.APTS_GTV_Level_Code__c) ){
             
         }else{
            bisValidattionError = true;
       dmHelperUtility.appendErrorMessage('GTV code is not matching. \n');
        system.debug('GTV code is not matching');
         }
         
         // Validation Check for Country-Field
         if(!(oApprovalMatrix.APTS_Country__c.equalsIgnoreCase(APTS_DMConstants.APPROVAL_COUNTRY))){
            bisValidattionError = true;
        dmHelperUtility.appendErrorMessage('Country Field should be Spain. \n');
        system.debug('Country Field should be Spain');
            
         }
          // Validation Check for SalesOrganization
         if(!(oApprovalMatrix.APTS_Sales_Organisation__c.equalsIgnoreCase(APTS_DMConstants.APPROVAL_ORGANIZATION))){
            bisValidattionError = true;
        dmHelperUtility.appendErrorMessage('Sales Organization Should be ABB. \n');
        system.debug('Sales Organization Should be ABB.');
             
         }
         
         // Validation APTS_Owner__c populated with the First & Last name from the User Object        
         if (!string.IsBlank(oApprovalMatrix.APTS_Owner__c)) {
              if(!APTS_DMHelper.validateUser(oApprovalMatrix.APTS_Owner__c)) {
                 bisValidattionError = true;
                 dmHelperUtility.appendErrorMessage('No Active owner found in users \n');
              }
         } else {
            bisValidattionError = true;
            dmHelperUtility.appendErrorMessage('Invalid Owner Name \n');
         }
           
         dmHelperUtility.updateValidationStatus(oApprovalMatrix,bisValidattionError);
           listUpdateStageApprovalRuleMatrix.add(oApprovalMatrix);
         
     }// End of for-Loop
     
     // List of Stage-Approval Rule Matrix Record
     if (listUpdateStageApprovalRuleMatrix.size() > 0) {
      system.debug('HS--> Size of Product to be updated' + listUpdateStageApprovalRuleMatrix.size());
      try {
          Database.UpsertResult  [] results =   Database.upsert(listUpdateStageApprovalRuleMatrix);
          system.debug('HS--Approval' + results);
      } 
      catch (Exception ex) {
        System.debug('Exception while upserting Staging Product Line Tree Data.\nException : ' + ex.getMessage());
      }
    }
        
        
    }

    /***
     *  This Method copies the Approval-Rule Matrix Object from Staging to Normal Object
     * 
     * Written By : Nishi Kushwaha
     * 
     * 
     * */
    public static APTS_CopyDataWrapper copyApprovalMatrix(List < APTS_Stage_Approval_Rule_Matrix__c > listStageApprovalMatrix) {

        APTS_CopyDataWrapper oCopyWrapper = new APTS_CopyDataWrapper();
        
        system.debug('Copying Data from Staging Object to Normal Object for Local Product');

        List < APTS_Approval_Rule_Matrix__c > listApprovalMatrix = new List < APTS_Approval_Rule_Matrix__c > ();
        Set < String > setLocalChannel = new Set < String > ();
        Set < String > setSalesOffice = new Set < String > ();
        Set<String> assignedToSet = New Set<String>();
        Map < String, APTS_Master_Picklist_Table__c > mapLocalChannel = new Map < String, APTS_Master_Picklist_Table__c > ();
        Map < String, APTS_Master_Picklist_Table__c > mapSalesOffice = new Map < String, APTS_Master_Picklist_Table__c > ();
        Organization oOrgDetail = [Select Id,Name, IsSandbox from Organization];
        String urlStr = String.valueOf(System.Url.getSalesforceBaseURL()) ; 
        String instanceNameStr= urlStr.subString(urlStr.indexOf('--')+2,urlStr.indexOf('.'));

        Schema.SObjectField f = APTS_Approval_Rule_Matrix__c.Fields.APTS_External_Id__c;
        
        List <String> ownerNameList = new List <String>();
        for (APTS_Stage_Approval_Rule_Matrix__c oStageApprovalMatrix: listStageApprovalMatrix) {
            setLocalChannel.add(oStageApprovalMatrix.APTS_Local_Channel__c);
            setSalesOffice.add(oStageApprovalMatrix.APTS_Sales_Office__c);
            if(oStageApprovalMatrix.APTS_Owner__c != null) {
              ownerNameList.add(oStageApprovalMatrix.APTS_Owner__c);
            }
            if(oStageApprovalMatrix.APTS_Assigned_to__c!=null && oStageApprovalMatrix.APTS_Assigned_to__c.length() > 0)
            {
                if(oOrgDetail.IsSandbox) {
                    String sAssignedTo = oStageApprovalMatrix.APTS_Assigned_to__c + '.' + instanceNameStr;
                    System.debug('Assigned To***'+ sAssignedTo);
                    assignedToSet.add(sAssignedTo);
                }else {
                    assignedToSet.add(oStageApprovalMatrix.APTS_Assigned_to__c);
                }
            }
        }
        if(ownerNameList != null && ownerNameList.size()>0)
        APTS_DMHelper.setActiveUserList(ownerNameList);

        Map<String, User> userNameMap = New Map<String,User>();     
            
          List<User> userSoLst = [select id,name,username from User where isActive=true AND username in: assignedToSet];       
          String userEmailStr;      
          for(User userSo: userSoLst)       
         {      
            userEmailStr=userSo.username;       
            if(userEmailStr.contains(instanceNameStr.tolowerCase()))        
            {    
                try { 
                 userEmailStr=userEmailStr.substring(0,userEmailStr.lastIndexOf('.'+instanceNameStr.tolowercase()));        
               } 
                catch(Exception e) {
                    
                }     
            }       
            userNameMap.put(userEmailStr ,userSo);      
          }     
      system.debug('##setSalesOffice ='+setSalesOffice );
      system.debug('##locale='+APTS_DMConstants.SPAIN_LOCALE);      
        
        List < APTS_Master_Picklist_Table__c > listMasterPickList = [Select Id, APTS_Code__c, APTS_Code_Used_For__c, APTS_Code_Description__c, APTS_Locale__c
        FROM APTS_Master_Picklist_Table__c
        WHERE(APTS_Code__c IN: setLocalChannel AND APTS_Locale__c = : APTS_DMConstants.SPAIN_LOCALE)
        OR(APTS_Code__c IN: setSalesOffice AND APTS_Locale__c = : APTS_DMConstants.SPAIN_LOCALE)];
        
        /** JPG */      
        List<LSO_Field_Entries__c> listLSO = [SELECT id, PickList_Code__c, Picklist_Code_Country__c, PickList_Description__c, PickList_Description_Code__c, LSO_Pick_List_Value_Name__c     
                                            FROM LSO_Field_Entries__c];     
                
        map<String, LSO_Field_Entries__c> mapSalesOfficeLSO = new map<String, LSO_Field_Entries__c>();      
                
        for (LSO_Field_Entries__c oLSO : listLSO){      
            if (oLSO.LSO_Pick_List_Value_Name__c == 'LSO Reference Data. Sales Office'){        
                mapSalesOfficeLSO.put(oLSO.PickList_Code__c, oLSO);     
            }       
        }       
        /* END JPG */
        
        for (APTS_Master_Picklist_Table__c oMasterPickList: listMasterPickList) {

            if (oMasterPickList.APTS_Code_Used_For__c == 'Local Channel') {
                mapLocalChannel.put(oMasterPickList.APTS_Code__c, oMasterPickList);
            } else if (oMasterPickList.APTS_Code_Used_For__c == 'Sales Office') {
                mapSalesOffice.put(oMasterPickList.APTS_Code__c, oMasterPickList);
            }

        }
        System.debug('mapLocalChannel*****' + mapLocalChannel);
        System.debug('mapSalesOffice*****' + mapSalesOffice);
        System.debug('User Locale***' + UserInfo.getLocale());
        // Creating Approval Rule Matrix, assigning values and adding into List.

        
        for (APTS_Stage_Approval_Rule_Matrix__c oStageApprovalMatrix: listStageApprovalMatrix) {

            APTS_Approval_Rule_Matrix__c oApprovalMatrix = new APTS_Approval_Rule_Matrix__c();
            oApprovalMatrix.CurrencyIsoCode = oStageApprovalMatrix.CurrencyIsoCode;
            //oApprovalMatrix.APTS_GTV_Level__c = oStageApprovalMatrix.APTS_GTV_Level__c;
            oApprovalMatrix.APTS_GTV_Level_Code__c = oStageApprovalMatrix.APTS_GTV_Level_Code__c;
            oApprovalMatrix.APTS_Sales_Organisation__c = oStageApprovalMatrix.APTS_Sales_Organisation__c;
            oApprovalMatrix.APTS_Country__c = oStageApprovalMatrix.APTS_Country__c;
            oApprovalMatrix.APTS_External_ID__c = oStageApprovalMatrix.APTS_External_ID__c;
            oApprovalMatrix.APTS_Threshold_Discount__c = oStageApprovalMatrix.APTS_Threshold_Discount__c;
            //oApprovalMatrix.APTS_Assigned_to__c = APTS_DMHelper.getUserforLoad(oStageApprovalMatrix.APTS_Assigned_to__c);
            if(userNameMap.containsKey(oStageApprovalMatrix.APTS_Assigned_to__c) && userNameMap.get(oStageApprovalMatrix.APTS_Assigned_to__c)!=null)                    
            {       
              oApprovalMatrix.APTS_Assigned_to__c = userNameMap.get(oStageApprovalMatrix.APTS_Assigned_to__c).id;       
            }
            
            if(mapLocalChannel.get(oStageApprovalMatrix.APTS_Local_Channel__c)!=null)
            {
            oApprovalMatrix.APTS_LP_Local_Channel__c = mapLocalChannel.get(oStageApprovalMatrix.APTS_Local_Channel__c).Id;
            }
            
            if( mapSalesOfficeLSO.get(oStageApprovalMatrix.APTS_Sales_Office__c)!=null)
            {
            oApprovalMatrix.APTS_Sales_Office__c = mapSalesOfficeLSO.get(oStageApprovalMatrix.APTS_Sales_Office__c).Id;
            }
            
            if(mapSalesOffice.get(oStageApprovalMatrix.APTS_Sales_Office__c)!=null)
            {
             oApprovalMatrix.APTS_LP_Sales_Office__c = mapSalesOffice.get(oStageApprovalMatrix.APTS_Sales_Office__c).id;
            }
            oApprovalMatrix.APTS_Max_Discount__c =   oStageApprovalMatrix.APTS_Max_Discount__c;
            oApprovalMatrix.APTS_Approval_Level__c = oStageApprovalMatrix.APTS_Approval_Level__c;
            oApprovalMatrix.currencyIsoCode= APTS_DMConstants.SPAIN_CURRENCY;
            oApprovalMatrix.OwnerID = APTS_DMHelper.getUserforLoad(oStageApprovalMatrix.APTS_Owner__c);
            
            listApprovalMatrix.add(oApprovalMatrix);
            
            if(oApprovalMatrix.APTS_Approval_Level__c==2)
            {
                 for(integer i=3;i<9;i++)
                {
                  APTS_Approval_Rule_Matrix__c tempApprovalMatrix = new APTS_Approval_Rule_Matrix__c();
                  tempApprovalMatrix = oApprovalMatrix.clone(false, false, false, false);
                  tempApprovalMatrix.APTS_Approval_Level__c = i;
                  tempApprovalMatrix.APTS_External_ID__c = oApprovalMatrix.APTS_External_ID__c.substring(0,oApprovalMatrix.APTS_External_ID__c.length()-1)+i;
                  tempApprovalMatrix.APTS_Threshold_Discount__c = 10000;
                  tempApprovalMatrix.APTS_Max_Discount__c =10000;
                  listApprovalMatrix.add(tempApprovalMatrix);
                  
                }
            }
        }
        
        // Upserting the list
        try {
            if (listApprovalMatrix.size() > 0) {
                Database.UpsertResult[] results = Database.upsert(listApprovalMatrix, f, false);
                system.debug('HS--> Result while copying Approval Rule MAtrix ' + results);
                Set < Id > successIdSet = New Set < id > ();
                Set < Id > failedIdSet = New Set < id > ();

                // Iterate through each returned result
                for (Database.UpsertResult sr: results) {

                    if (sr.isSuccess()) {
                        System.debug('Successfully inserted accountID: ' + sr.getId());
                        successIdSet.add(sr.getId());
                        system.debug('##SUCCESSresults.get(i)=' + sr);
                    } else {
                        // Operation failed, so get all errors 
                        oCopyWrapper.bIsUpsertFail = true;
                        for (Database.Error err: sr.getErrors()) {
                            System.debug('The following error has occurred.');
                            oCopyWrapper.sErrorMessage = oCopyWrapper.sErrorMessage + '<br/><br/>' + err.getStatusCode() + ': ' + err.getMessage();
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Approval Rule MAtrix fields that affected this error: ' + err.getFields());
                            System.debug('Id of Record that is failed: ' + sr.getId());
                        }
                    }
                }
                
                APTS_DMHelper.updateLoadingStatus(successIdSet, 'APTS_Approval_Rule_Matrix__c', 'APTS_External_Id__c', 'APTS_External_ID__c', listStageApprovalMatrix);

                system.debug('HS1--> ' + oCopyWrapper);
            }


        } catch (Exception e) {
            System.debug('Exception while upserting Product Line Tree records.\nException : ' + e.getMessage());
            oCopyWrapper.sErrorMessage = e.getMessage();
            oCopyWrapper.bIsUpsertFail = true;
        }
        return oCopyWrapper;
    }
    
}