/*************************************************************
@Name: APTS_LRDLODUtility 
@Author: Jignesh Shekhaliya
@CreateDate: 4th Nov 2015
@Description: Class to process LRD and LOD data
@UsedBy: Class - APTS_LRDLODUtility
******************************************************************/

public class APTS_LRDLODUtility {
    /*
     * @Description: To Get the LOD records fro Quotation when it is created from Account (Buying and Non-Buying)
     * @Owner: Jignesh Shekhaliya
    */
    /* Commented on 12-Dec-2015 by JS as new common method has been developed.
    public static List<APTS_LP_Local_Customer_Reference_Data__c> GetLODForQuotationorAgreementFromAccount(APTS_CaptureInputForLSODataController controller, String accountId, String userCountryCode){
        String sAccLSOKey;
        String sUserLSO;
        String sUserLSO1;
        String sUserDefaultBU;        
        List<ERP_Reference_Data__c> listFilteredLRD = new List<ERP_Reference_Data__c>();
        List<APTS_LP_Local_Customer_Reference_Data__c> listLSOData = new List<APTS_LP_Local_Customer_Reference_Data__c>();
        try{
            system.debug('ERP Ref Data - Account ID ####>>>>> :' + accountId);
            if(!String.isEmpty(accountId)){
                
                // Get User Details
                User loggedInUser = [SELECT Id, Default_Country_ISO_Code__c, Default_BU__c, Default_LSO__c FROM User WHERE Id =: UserInfo.getUserId() Limit 1];
                if(String.isEmpty(loggedInUser.Default_LSO__c)){
                    controller.addErrorMessage(System.Label.APTS_DEFAULT_LSO_FOR_USER_IS_NOT_FOUND);
                }else{
                    // Create User LSO Key
                    if(!String.isEmpty(loggedInUser.Default_BU__c)){
                        sUserDefaultBU = loggedInUser.Default_BU__c;
                        sUserLSO = loggedInUser.Default_LSO__c + loggedInUser.Default_BU__c;
                    }else{
                        sUserLSO = loggedInUser.Default_LSO__c;
                    }
                }
                System.debug('User Profile Data ##### >>>>: '+sUserDefaultBU +'-'+sUserLSO);
                // Get Account Specific ERP Local Reference Data Records
                List<ERP_Reference_Data__c> listERPRefData = [  SELECT Id, Local_Customer_ID__c, Sales_Office_Text__c, SAP_Sales_Organization__c, SAP_Distribution_Channel__c, LSO__c, LBU__c 
                                                                FROM ERP_Reference_Data__c 
                                                                WHERE Account__c =: accountId 
                                                                LIMIT 1000
                                                             ];
                
                // Process ERP Local Reference Data and Filter the records.
                List <String> customerIDSet = new List <String>();
                if(!listERPRefData.isEmpty()){
                    for(ERP_Reference_Data__c lrd:listERPRefData){
                        sAccLSOKey = String.valueof(lrd.LSO__c);
                        if(sUserLSO!=null && sUserLSO.equalsIgnoreCase(sAccLSOKey)){
                            system.debug('Acc LSO Key>>>> : '+ sAccLSOKey+' matches with '+sUserLSO);
                            listFilteredLRD.add(lrd);
                            customerIDSet.add(lrd.Local_Customer_ID__c);
                        }

                    }
                }
                
                
                if(listFilteredLRD.isEmpty()){
                    controller.addWarningMessage(Label.APTS_AccQuoteLODWar);
                }else{
                    
                    String query = 'SELECT  APTS_LP_SAP_Customer_ID__c, APTS_LP_Sales_Organisation__c, APTS_LP_Distribution_Channel__c, APTS_Payment_Terms__c, APTS_LP_Incoterms__c, APTS_LP_Local_Channel__c, APTS_SAP_Division__c  FROM  APTS_LP_Local_Customer_Reference_Data__c  WHERE  APTS_LP_Account__c = :accountId AND APTS_Country__c = :userCountryCode AND APTS_LP_SAP_Customer_ID__c in :customerIDSet';
                    listLSOData = Database.query(query);
                    
                    List<ERP_Reference_Data__c> lrdfinalList = new List<ERP_Reference_Data__c>();
                    Set <String> lodCustomerSet = new Set <String>();
                    for(APTS_LP_Local_Customer_Reference_Data__c lod: listLSOData) {
                        lodCustomerSet.add(lod.APTS_LP_SAP_Customer_ID__c);
                    }
                    for(ERP_Reference_Data__c lrd: listFilteredLRD){    
                        if(lodCustomerSet.contains(lrd.Local_Customer_ID__c)) {
                            lrdfinalList.add(lrd);
                        }
                    }

                    controller.lrdList = lrdfinalList;
                }
                
                // Setting default SAP Customer ID for Non Buying Account
                if(listLSOData.isEmpty()){
                    // Show Warning Message if no LOD Records found
                    controller.addWarningMessage(Label.APTS_LODWarnning);
                }
            }
        } catch (Exception ex){
            controller.addErrorMessage(System.Label.APTS_ERROR_WHILE_FETCHING_ERP_LSO_DATA);
            System.debug('Exception occured while fetching ERP LSO Data.\nException : ' + ex);
        }
        
        return listLSOData;
    }
    */
    
    /*
     * @Description: To Get the LOD records for AGREEMENT when it is created from ACCOUNT (Buying and Non-Buying)
     * @Owner: Jignesh Shekhaliya
    */
    /* Commented on 12-Dec-2015 by JS as new common method has been developed.
    public static List<APTS_LP_Local_Customer_Reference_Data__c> GetLODForAgreementFromAccount(APTS_CaptureInputForLSODataController controller, String accountId, String userCountryCode){
        List<APTS_LP_Local_Customer_Reference_Data__c> listLSOData = new List<APTS_LP_Local_Customer_Reference_Data__c>();
        String sAccLSOKey;
        String sUserLSO;
        String sUserLSO1;
        String sUserDefaultBU;
        List<ERP_Reference_Data__c> listFilteredLRD = new List<ERP_Reference_Data__c>();
        try{
            system.debug('ERP Ref Data - Account ID >>>>> :' + accountId);
            if(!String.isEmpty(accountId)){
                
                // Get User Details
                User loggedInUser = [SELECT Id, Default_Country_ISO_Code__c, Default_BU__c, Default_LSO__c FROM User WHERE Id =: UserInfo.getUserId() Limit 1];
                if(String.isEmpty(loggedInUser.Default_LSO__c)){
                    controller.addErrorMessage(System.label.APTS_DEFAULT_LSO_FOR_USER_IS_NOT_FOUND);
                }else{
                    // Create User LSO Key
                    if(!String.isEmpty(loggedInUser.Default_BU__c)){
                        sUserDefaultBU = loggedInUser.Default_BU__c;
                        sUserLSO = loggedInUser.Default_LSO__c + loggedInUser.Default_BU__c;
                    }else{
                        sUserLSO = loggedInUser.Default_LSO__c;
                    }
                }
                System.debug('User Data for Account >>>>: '+sUserDefaultBU +'-'+sUserLSO);
                // Get Account Specific ERP Local Reference Data Records
                List<ERP_Reference_Data__c> listERPRefData = [  SELECT Id, Local_Customer_ID__c,Sales_Office_Text__c, SAP_Sales_Organization__c, SAP_Distribution_Channel__c, LSO__c, LBU__c 
                                                                FROM ERP_Reference_Data__c 
                                                                WHERE Account__c =: accountId 
                                                                LIMIT 1000
                                                             ];
                
                // Process ERP Local Reference Data and Filter the records.
                if(!listERPRefData.isEmpty()){
                    for(ERP_Reference_Data__c lrd:listERPRefData){
                        sAccLSOKey = String.valueof(lrd.LSO__c)+String.valueof(lrd.LBU__c);
                        system.debug('Acc LSO Key>>>> : '+ sAccLSOKey);
                        if(sUserDefaultBU!=null && lrd.LBU__c!= null && sUserLSO!=null && sUserLSO.equalsIgnoreCase(sAccLSOKey)){
                            listFilteredLRD.add(lrd);
                        }
                        else if(sUserDefaultBU==null &&  lrd.LBU__c == null && sUserLSO!=null && sUserLSO.equalsIgnoreCase(String.valueof(lrd.LSO__c))){
                            listFilteredLRD.add(lrd);
                        }
                    }
                    
                    
                    // Get LOD Records
                    system.debug('<<<< Found Data for Agreemtn from Account: >>>>'+ listFilteredLRD.size());
                    if(listFilteredLRD.isEmpty()){
                        controller.addErrorMessage(Label.APTS_AgrAccLODValMsg);
                        
                    }else{
                        
                        // Prepare External Key from ERP LSO (SAP ID + Sales organisation + Distribution Channel.)
                        String sExternalID =  listFilteredLRD[0].Local_Customer_ID__c + listFilteredLRD[0].SAP_Sales_Organization__c + listFilteredLRD[0].SAP_Distribution_Channel__c;
                        
                        system.debug('External ID>>>> : '+ sExternalID);
                        controller.sSalesOffice = listFilteredLRD[0].Sales_Office_Text__c;
                        
                        String query = 'SELECT  APTS_LP_SAP_Customer_ID__c, APTS_LP_Sales_Organisation__c, APTS_LP_Distribution_Channel__c, APTS_Payment_Terms__c, APTS_LP_Incoterms__c, APTS_LP_Local_Channel__c, APTS_SAP_Division__c  FROM  APTS_LP_Local_Customer_Reference_Data__c  WHERE  APTS_LP_Account__c = :accountId AND APTS_Country__c = :userCountryCode AND APTS_External_ID__c = :sExternalID';
                        listLSOData = Database.query(query);
                        
                    }
                    
                    system.debug('<<<< LSO Data from Account for Agreement: >>>>'+ listLSOData.size());
                    // Setting default SAP Customer ID for Non Buying Account
                    if(listLSOData.isEmpty()){
                        // Show Warning Message if no LOD Records found
                        controller.addErrorMessage(Label.APTS_NoLODAgrToAcc);
                    }
                }else{
                    controller.addErrorMessage(Label.APTS_AgrAccLODValMsg);
                }
            }
            System.debug('finish Agree from Account >>>>');
        } catch (Exception ex){
            controller.addErrorMessage(System.label.APTS_ERROR_WHILE_FETCHING_ERP_LSO_DATA_FOR_AGREEMENT_FROM_ACCOUNT);
            System.debug('Exception occured while fetching ERP LSO Data.\nException : ' + ex);
        }
        
        return listLSOData;
        
    }
    */
    
    /*
     * @Description: To Get the LOD records for Quote when it is created from Opportunity
     * @Owner: Jignesh Shekhaliya
    */
    /* Commented on 12-Dec-2015 by JS as new common method has been developed.
    public static ERP_Reference_Data__c GetLODForQuoteFromOpportunity(String referenceId){
        ERP_Reference_Data__c referenceObject;
        
        try {
            referenceObject = [SELECT Account__c, SAP_Sales_Organization__c, SAP_Distribution_Channel__c, SAP_Division__c,Local_Customer_ID__c  
                                FROM  ERP_Reference_Data__c  
                                WHERE id = :referenceId
                                Limit 1
                              ];
            
        } catch (Exception ex) {
            System.debug('Exception occured while fetching ERP Reference Data from Opportunity.\nException : ' + ex);
        }
        
        return referenceObject;
    }
    */
    
    /*
     * @Description: To Get the LOD records for Agreement when it is created from Opportunity
     * @Owner: Jignesh Shekhaliya
    */
    /* Commented on 12-Dec-2015 by JS as new common method has been developed.
    public static List<APTS_LP_Local_Customer_Reference_Data__c> GetLODForAgrrementFromOpportunity(APTS_CaptureInputForLSODataController controller, String accountId, String userCountryCode, ERP_Reference_Data__c oLRDRefData){
        List<APTS_LP_Local_Customer_Reference_Data__c> listLSOData = new List<APTS_LP_Local_Customer_Reference_Data__c>();
        String sAccLSOKey;
        String sUserLSO;
        String sUserLSO1;
        String sUserDefaultBU;
        List<ERP_Reference_Data__c> listFilteredLRD = new List<ERP_Reference_Data__c>();
        try{
            system.debug('Agreement From Oppty - Account ID >>>>> :' + controller.oAccountSO.Id);
            if(!String.isEmpty(controller.oAccountSO.Id)){
                
                // Get User Details
                User loggedInUser = [SELECT Id, Default_Country_ISO_Code__c, Default_BU__c, Default_LSO__c FROM User WHERE Id =: UserInfo.getUserId() Limit 1];
                if(String.isEmpty(loggedInUser.Default_LSO__c)){
                    controller.addErrorMessage(System.label.APTS_DEFAULT_LSO_FOR_USER_IS_NOT_FOUND);
                }else{
                    // Create User LSO Key
                    if(!String.isEmpty(loggedInUser.Default_BU__c)){
                        sUserDefaultBU = loggedInUser.Default_BU__c;
                        sUserLSO = loggedInUser.Default_LSO__c + loggedInUser.Default_BU__c;
                    }else{
                        sUserLSO = loggedInUser.Default_LSO__c;
                    }
                }
                System.debug('<<<< ERP Data >>>>: '+oLRDRefData);
                
                if(oLRDRefData == null){
                    controller.addErrorMessage(Label.APTS_AgrOppLODValMsg);
                }else{
                    // Get Account Specific ERP Local Reference Data Records
                    List<ERP_Reference_Data__c> listERPRefData = [  SELECT Id, Local_Customer_ID__c, Sales_Office_Text__c, SAP_Sales_Organization__c, SAP_Distribution_Channel__c, LSO__c, LBU__c 
                                                                    FROM ERP_Reference_Data__c 
                                                                    WHERE Account__c =: controller.oAccountSO.Id
                                                                        AND Id =: oLRDRefData.Id
                                                                    LIMIT 1
                                                                 ];
                    system.debug('<<<< Count >>>>'+ listERPRefData.size());
                    // Process ERP Local Reference Data and Filter the records.
                    if(!listERPRefData.isEmpty()){
                        for(ERP_Reference_Data__c lrd:listERPRefData){
                                listFilteredLRD.add(lrd);
                        }
                        
                        // Get LOD Records
                        
                        if(listFilteredLRD.isEmpty()){
                            controller.addErrorMessage(Label.APTS_AgrOppLODValMsg);
                            
                        }else{
                            system.debug('<<<< FIND LOD >>>> '+ listFilteredLRD[0].Local_Customer_ID__c);
                            if(listFilteredLRD[0].Local_Customer_ID__c == null){
                                controller.addErrorMessage(Label.APTS_NoLODAgrToAcc);
                            }else if(listFilteredLRD[0].SAP_Sales_Organization__c == null){
                                controller.addErrorMessage(Label.APTS_NoLODAgrToAcc);
                            }else if(listFilteredLRD[0].SAP_Distribution_Channel__c == null){
                                controller.addErrorMessage(Label.APTS_NoLODAgrToAcc);
                            }else{
                                // Prepare External Key from ERP LSO (SAP ID + Sales organisation + Distribution Channel.)
                                String sExternalID =  listFilteredLRD[0].Local_Customer_ID__c + listFilteredLRD[0].SAP_Sales_Organization__c + listFilteredLRD[0].SAP_Distribution_Channel__c;
                                system.debug('External ID>>>> : '+ sExternalID);
                                controller.sSalesOffice = listFilteredLRD[0].Sales_Office_Text__c;
                                
                                String query = 'SELECT  APTS_LP_SAP_Customer_ID__c, APTS_LP_Sales_Organisation__c, APTS_LP_Distribution_Channel__c, APTS_Payment_Terms__c, APTS_LP_Incoterms__c, APTS_LP_Local_Channel__c, APTS_SAP_Division__c  FROM  APTS_LP_Local_Customer_Reference_Data__c  WHERE  APTS_LP_Account__c = :accountId AND APTS_Country__c = :userCountryCode AND APTS_External_ID__c = :sExternalID';
                                listLSOData = Database.query(query);
                                
                                system.debug('<<<< FIND LOD - **** >>>>' + listLSOData.size());
                            }
                        }
                        // Setting default SAP Customer ID for Non Buying Account
                        if(listLSOData.isEmpty()){
                            system.debug('<<<< Agree - Oppty No LSO Data Found >>>>');
                            // Show Warning Message if no LOD Records found
                            controller.addErrorMessage(Label.APTS_NoLODAgrToAcc);
                        }
                    }else{
                        system.debug('<<<< Agreement From Oppty - NO LRD DATA >>>');
                        controller.addErrorMessage(Label.APTS_AgrOppLODValMsg);   
                    }
                }
            }
        } catch (Exception ex){
            controller.addErrorMessage(System.Label.APTS_ERROR_WHILE_FETCHING_ERP_LSO_DATA);
            System.debug('Exception occured while fetching ERP LSO Data.\nException : ' + ex);
        }
        System.debug('<<<< Oppty - Agreement LOD data >>>> : ' + listLSOData.size());
        return listLSOData;
    }
    */    
    
    /*
     * @Description: To Get matching LOD records
     * @Owner: Jignesh Shekhaliya
     * @Date: 13-Nov-2015
    */
    public static List<APTS_WrapperLOD> findMatchingLODRecords(String accountId, APTS_CaptureInputForLSODataController controller, String userCountryCode){
        String sUserLSO = '';
        List<APTS_WrapperLOD> listUniqWrapperLOD = new List<APTS_WrapperLOD>();
        
        try{
            
            // Get User Details
            User loggedInUser = [SELECT Id, Default_Country_ISO_Code__c, Default_BU__c, Default_LSO__c FROM User WHERE Id =: UserInfo.getUserId() Limit 1];
            if(String.isEmpty(loggedInUser.Default_LSO__c)){
                controller.addErrorMessage(System.Label.APTS_DEFAULT_LSO_FOR_USER_IS_NOT_FOUND);
            }else{
                // Create User LSO Key
                if(!String.isEmpty(loggedInUser.Default_LSO__c)){
                    sUserLSO = loggedInUser.Default_LSO__c;
                }
            }
            
            System.debug('User Profile Data ##### >>>>: '+sUserLSO);
            
            listUniqWrapperLOD = filterLODRecords(accountId, sUserLSO, userCountryCode);
            
        } catch(Exception ex){
            controller.addErrorMessage(System.Label.APTS_ERROR_WHILE_FETCHING_ERP_LSO_DATA);
            System.debug('Exception occured while fetching ERP LSO Data.\nException : ' + ex);
        }
        return listUniqWrapperLOD;
    }
    
    public static List<APTS_WrapperLOD> findMatchingLODRecordsForRefresh(String accountId, APTS_RefreshAccountCustomerInfoCntrl controller, String userCountryCode){
        
        String sUserLSO = '';
        List<APTS_WrapperLOD> listUniqWrapperLOD = new List<APTS_WrapperLOD>();
        
        try{
            
            // Get User Details
            User loggedInUser = [SELECT Id, Default_Country_ISO_Code__c, Default_BU__c, Default_LSO__c FROM User WHERE Id =: UserInfo.getUserId() Limit 1];
            if(String.isEmpty(loggedInUser.Default_LSO__c)){
                controller.addErrorMessage(System.Label.APTS_DEFAULT_LSO_FOR_USER_IS_NOT_FOUND);
            }else{
                // Create User LSO Key
                if(!String.isEmpty(loggedInUser.Default_LSO__c)){
                    sUserLSO = loggedInUser.Default_LSO__c;
                }
            }
            System.debug('User Profile Data ##### >>>>: '+sUserLSO);
            
            listUniqWrapperLOD = filterLODRecords(accountId, sUserLSO, userCountryCode);
            
        } catch(Exception ex){
            controller.addErrorMessage(System.Label.APTS_ERROR_WHILE_FETCHING_ERP_LSO_DATA);
            System.debug('Exception occured while fetching ERP LSO Data.\nException : ' + ex);
        }
        return listUniqWrapperLOD;
    }
    
    public static List<APTS_WrapperLOD> filterLODRecords(String accountId, String sUserLSO, String userCountryCode){
        List<APTS_LP_Local_Customer_Reference_Data__c> listLODData = new List<APTS_LP_Local_Customer_Reference_Data__c>();
        set<String> setExternalKey = new set<String>();
        List<APTS_WrapperLOD> listUniqWrapperLOD = new List<APTS_WrapperLOD>();
        APTS_WrapperLOD oWapperLOD;
        Set<String> setMPLCodes = new Set<String>();
        Map<Id, APTS_Master_Picklist_Table__c> mapMPLData;
        String sUniqueLODKey = '';
        Map<String, Set<String>> mapLODKeySalesOffice = new Map<String, Set<String>>();
        
        try{
            // Get Account Specific ERP Local Reference Data Records
            List<ERP_Reference_Data__c> listERPRefData = [  SELECT Id, Local_Customer_ID__c, SAP_Division__c, Sales_Office_Text__c, SAP_Sales_Organization__c, SAP_Distribution_Channel__c, LSO__c, LBU__c 
                                                            FROM ERP_Reference_Data__c 
                                                            WHERE Account__c =: accountId AND LSO__c =: sUserLSO
                                                            LIMIT 1000
                                                         ];
            // Populate set of External Id to filter LOD records + JS on 13-Dec-2015
            for(ERP_Reference_Data__c oLRDData: listERPRefData){
                if(!String.isBlank(oLRDData.Local_Customer_ID__c) && !String.isBlank(oLRDData.SAP_Sales_Organization__c) && !String.isBlank(oLRDData.SAP_Distribution_Channel__c)){
                    setExternalKey.add(oLRDData.Local_Customer_ID__c + oLRDData.SAP_Sales_Organization__c + oLRDData.SAP_Distribution_Channel__c);
                }
            }
            
            String query = 'SELECT  APTS_LP_SAP_Customer_ID__c,APTS_LP_Account__c, APTS_LP_Sales_Organisation__c, APTS_LP_Distribution_Channel__c, APTS_Payment_Terms__c, APTS_LP_Incoterms__c, APTS_LP_Local_Channel__c, APTS_SAP_Division__c, APTS_External_ID__c FROM  APTS_LP_Local_Customer_Reference_Data__c  WHERE  APTS_LP_Account__c = :accountId AND APTS_Country__c = :userCountryCode AND APTS_External_ID__c = :setExternalKey';
            listLODData = Database.query(query);
            
            // Prepare set of MPL Code for get description
            for(APTS_LP_Local_Customer_Reference_Data__c oLODRecord: listLODData){
                if(!setMPLCodes.contains(oLODRecord.APTS_LP_Incoterms__c)){
                    setMPLCodes.add(oLODRecord.APTS_LP_Incoterms__c);
                }
                if(!setMPLCodes.contains(oLODRecord.APTS_Payment_Terms__c)){
                    setMPLCodes.add(oLODRecord.APTS_Payment_Terms__c);
                }
                if(!setMPLCodes.contains(oLODRecord.APTS_LP_Local_Channel__c)){
                    setMPLCodes.add(oLODRecord.APTS_LP_Local_Channel__c);
                }
                if(!setMPLCodes.contains(oLODRecord.APTS_LP_Distribution_Channel__c)){
                    setMPLCodes.add(oLODRecord.APTS_LP_Distribution_Channel__c);
                }
            }
            
            // Get Map of require Master Picklist Table records
            if(setMPLCodes.size() > 0){
                mapMPLData = APTS_LP_CommonUtil.getMapOfMPLData(setMPLCodes);
            }
            
            if(mapMPLData != null && mapMPLData.size() > 0){
                integer iLODRecordCount = 1;
                // Prepare Map of Unique Key wise available Sales Office Details
                for(ERP_Reference_Data__c oLRDData: listERPRefData){
                    if(!string.isBlank(oLRDData.Sales_Office_Text__c)){
                        sUniqueLODKey = oLRDData.Local_Customer_ID__c + oLRDData.SAP_Sales_Organization__c + oLRDData.SAP_Distribution_Channel__c + oLRDData.SAP_Division__c;
                        if(mapLODKeySalesOffice.containsKey(sUniqueLODKey)){
                            mapLODKeySalesOffice.get(sUniqueLODKey).add(oLRDData.Sales_Office_Text__c);
                        }else{
                            mapLODKeySalesOffice.put(sUniqueLODKey, new Set<String>{oLRDData.Sales_Office_Text__c});
                        }
                    }
                }
                system.debug('<<<< Key-Sales Office >>>>: '+mapLODKeySalesOffice);
                // Prepare LOD data having matching key with Sales Office
                for(APTS_LP_Local_Customer_Reference_Data__c oLODRecord: listLODData){
                    sUniqueLODKey = oLODRecord.APTS_LP_SAP_Customer_ID__c + oLODRecord.APTS_LP_Sales_Organisation__c+ oLODRecord.APTS_LP_Distribution_Channel__c+ oLODRecord.APTS_SAP_Division__c;
                    if(mapLODKeySalesOffice.containsKey(sUniqueLODKey)){
                        for(String sSalesOffice: mapLODKeySalesOffice.get(sUniqueLODKey)){
                            oWapperLOD = new APTS_WrapperLOD(oLODRecord, mapMPLData, sSalesOffice, '');
                            oWapperLOD.iRecordId = iLODRecordCount;
                            listUniqWrapperLOD.add(oWapperLOD);
                            iLODRecordCount++;
                        }
                    }
                }
            }
            
            Account selectedAccount = new Account();
            selectedAccount = [select id,RecordType.DeveloperName,Name from Account where id=:accountId limit 1];
            system.debug('@@ selectedAccount @@ :'+ selectedAccount);
            if((listUniqWrapperLOD==null || listUniqWrapperLOD.size()==0) && selectedAccount != null && selectedAccount.RecordType.DeveloperName =='GIS_Approved'){
                system.debug('@@ selectedAccount @@ :'+ selectedAccount.Name);
                createTaskAndSendMailAlert(selectedAccount.Name,selectedAccount.id);
            }
            
        } catch(Exception ex){
            System.debug('Exception occured while fetching ERP LSO Data.\nException : ' + ex);
        }
        return listUniqWrapperLOD;
    }
    
    // mothods to create task and send email alert when an account is missing LOD data 
    // Added by Chetan date : 22-12-2015 as part of ABB LP 3.1 
    
    public static void createTaskAndSendMailAlert(String sBaseObjectName,String sBaseAccountObjectId){
        
        if(!isLRDLODAlertSent(sBaseObjectName,sBaseAccountObjectId)){
            String subject = Label.APTS_ADD_LOD_DATA_MSG + sBaseObjectName;
            String description = '';
            set<id> setLCAUserIds = new set<id>();
            setLCAUserIds.addAll(GetUserIdsFromGroup(getLCAPublicGroups()));
            sendMail(setLCAUserIds,sBaseObjectName,sBaseAccountObjectId);
            createTask(subject,description,sBaseAccountObjectId,setLCAUserIds);
        }
    }
    
    public static boolean isLRDLODAlertSent(String sBaseObjectName,String sBaseAccountObjectId){
        
        boolean bIsInvalid = false;
        String subject = Label.APTS_ADD_LOD_DATA_MSG + sBaseObjectName;
        List<Task> lstTask = new List<Task>();
        lstTask = [SELECT Id, Subject FROM TASK WHERE What.Type = 'Account' AND whatId=:sBaseAccountObjectId AND Subject=:subject];
        if(lstTask != null && lstTask.size()>0){
            
            bIsInvalid = true;
        }
        return bIsInvalid;
        
    }

    public static void createTask(String subject, String description, String whatId, set<id> setLCAUserIds){
    	
    	List<Task> lstTasksForLCA = new List<Task>();
    	for(Id TaskOwner : setLCAUserIds){
        	
        	Task t = new Task();
        	t.Subject = subject;
        	t.WhatId = whatId;
        	t.OwnerId= TaskOwner;
        	t.Description = description;
        	t.Status = 'Open';
        	t.Priority = 'Normal';
        	t.ActivityDate = system.today()+2;
        	lstTasksForLCA.add(t);
    	}
    	if(lstTasksForLCA !=null && lstTasksForLCA.size()>0)
    	    insert lstTasksForLCA;
    
    }
    
    public static set<id> getLCAPublicGroups(){
    	
    	// For R3, we are only fetching LCA users who are part of public group 'Spain Country Admin'
    	// Going forward if we create another public group for other coutry, 
    	// We must include that public group in below query to give access to "Recall Approvals" button to those LCA users
    	
    	List<group> lstLCAPublicGroups = new List<group>();
    	set<id> groupIds = new set<id>();
    	
    	lstLCAPublicGroups = [select id,name from group where type='Regular' and name='Spain Country Admin'];
    	
    	if(lstLCAPublicGroups != null && lstLCAPublicGroups.size()>0){
    		
    		for(group g:lstLCAPublicGroups){
    			groupIds.add(g.id);
    		}
    	}
    	
    	return groupIds;
    	
    }
    
    public static Set<id> GetUserIdsFromGroup(Set<Id> groupIds)
    {
    	// store the results in a set so we don't get duplicates
    	Set<Id> result=new Set<Id>();
    	String userType = Schema.SObjectType.User.getKeyPrefix();
    	String groupType = Schema.SObjectType.Group.getKeyPrefix();
    	Set<Id> groupIdProxys = new Set<Id>();
    	// Loop through all group members in a group
    	
    	if(groupIds != null && groupIds.size()>0)
    	{
    		
    		for(GroupMember m : [Select Id, UserOrGroupId From GroupMember Where GroupId in :groupIds])
    		{
    			// If the user or group id is a user
    			if(((String)m.UserOrGroupId).startsWith(userType))
    			{
    				result.add(m.UserOrGroupId);
    			}
    			// If the user or group id is a group
    			// Note: there may be a problem with governor limits if this is called too many times
    			else if (((String)m.UserOrGroupId).startsWith(groupType))
    			{
    				// Call this function again but pass in the group found within this group
    				groupIdProxys.add(m.UserOrGroupId);
    			}
    		}
    	}
    	if(groupIdProxys.size() > 0)
    	{
    		result.addAll(GetUSerIdsFromGroup(groupIdProxys));
    	}
    	return result;  
    }
    
    public static void sendMail(set<id> setLCAUserIds,String sBaseObjectName,String sBaseAccountObjectId){
            
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    
            
            List<String> sendTo = new List<String>();
            String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + sBaseAccountObjectId;  
            
            for(User u:[select id,email from user where id in :setLCAUserIds]){
                sendTo.add(u.Email);   
            }
            
            mail.setToAddresses(sendTo);
            
            mail.setSubject(Label.APTS_ADD_LOD_DATA_MSG + ' ' + sBaseObjectName);
            mail.setSaveAsActivity(false);
            
            String body = 'Dear Country Admin, <br/>';
            body += '<br/><b>Please note that Local Operation Data is missing for the following Buying Account. </b>';
            body += '<br/>';
            body += '<br/>';
            body += '<b>Account Name : </b>'+ sBaseObjectName + ' <br/><br/>';
            body += '<b>Account Link : </b>'+  sfdcURL + ' <br/>';
            body += '<br/>';
            body += '<br/>This email has been generated as '+ UserInfo.getName() +' was trying to create a quotation/MSPA for this Account.<br/><br/>';
            body += '<b>*** This is system generated mail. Please do not reply ***</b><br/>'; 
            mail.setHtmlBody(body);
            
            mails.add(mail);
            
            
            Messaging.sendEmail(mails);
        }
        
    // Methods for task and send email alert ends here
    
}