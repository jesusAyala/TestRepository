/**
*  @Name: ClsTriggerlocalErploaderHandler
*  @Description - This class helps to Insert the LSO record ALSO Update the existing LSO record, If the new record in Local ERP has the same value of Country, LSO & LBU.
*  @Release - R3 
*  @Author : MohanRaj Kasinathan (Accenture )
*/
public without sharing class ClsTriggerlocalErploaderHandler extends ClsTriggerVirtual {

    
/**
* @see IntHelper.afterTrigger
*/
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {        
        listNewLSORecordFromLocalERP(trgCtx);           
    }
    
/**   
*     
* Method - listNewLSORecordFromLocalERP Method 
*
* Description - Upsert the LSO record 
*/ 
    @TestVisible 
    private void listNewLSORecordFromLocalERP(ClsWrappers.TriggerContext trgCtx) {
        
        Set<String> ManualOverriden = new Set<String>();
        
        List<Local_ERP_Loader__c> erpLoaderList = new List<Local_ERP_Loader__c>();  
        List<Local_ERP_Loader__c> filterERPLoaderList = new List<Local_ERP_Loader__c>();  
        List<ERP_Reference_Data__c> tobeInsertErpRefDataList = new List<ERP_Reference_Data__c>();             
        Set<String> setAccountGUID = new Set<String>();           
        Set<String> setERPIDAndSOAndDCAndDivision = new Set<String>();        
        Map<String, Local_ERP_Loader__c> mapERPIDAndSAId = new Map<String, Local_ERP_Loader__c>();
        Map<Id, String> recTypeIdANdDeveloperNameMap = new Map<Id, String>();
        Map<String, Id> mapERPIDSAIdLBULSOAndERPRefRecId = new Map<String, Id>();
        Map<String, List<ERP_Mapping__c>> erpMappingMap = new Map<String, List<ERP_Mapping__c>>();
        Map<String, String> mapGUIdAndAccountId = new Map<String, String>();
        
        ////////// ERP PickList Vaules //////////////
        
        Map<String, LSO_Field_Entries__c > mapDistrict = new Map<String, LSO_Field_Entries__c>();
        Map<String, LSO_Field_Entries__c > mapSalesOffice = new Map<String, LSO_Field_Entries__c>();
        Map<String, LSO_Field_Entries__c > mapLocalMain = new Map<String, LSO_Field_Entries__c>();
        Map<String, LSO_Field_Entries__c > mapLocalChannel = new Map<String, LSO_Field_Entries__c>();
        Map<String, LSO_Field_Entries__c > mapLocalSegment = new Map<String, LSO_Field_Entries__c>();
        Map<String, LSO_Field_Entries__c > mapCustomAllocation = new Map<String, LSO_Field_Entries__c>();
        Map<String, LSO_Field_Entries__c > mapTypeSales = new Map<String, LSO_Field_Entries__c>();
        
        
        for (LSO_Field_Entries__c lso_fe : [Select PickList_Code__c,Picklist_Code_Country__c, PickList_Description__c, PickList_Description_Code__c, LSO_Pick_List_Value_Name__c from LSO_Field_Entries__c 
                                            where RecordType.name =: System.Label.System_LSOERP_RT and Active__c = True LIMIT 5000]){
         
            if(lso_fe.LSO_Pick_List_Value_Name__c == System.Label.System_SalesDistrict)
            {        
                mapDistrict.put (lso_fe.Picklist_Code_Country__c ,lso_fe);  
            }        
            if(lso_fe.LSO_Pick_List_Value_Name__c == System.Label.System_SalesOffice)
            {        
                 mapSalesOffice.put (lso_fe.Picklist_Code_Country__c ,lso_fe);  
            }        
            if(lso_fe.LSO_Pick_List_Value_Name__c == System.Label.System_LocalMainBus)
            {        
                 mapLocalMain.put (lso_fe.Picklist_Code_Country__c ,lso_fe);  
            }
            if(lso_fe.LSO_Pick_List_Value_Name__c == System.Label.System_LocalSegment)
            {        
                 mapLocalSegment.put (lso_fe.Picklist_Code_Country__c,lso_fe);  
            }
            if(lso_fe.LSO_Pick_List_Value_Name__c == System.Label.System_LocalChannel)
            {        
                 mapLocalChannel.put (lso_fe.Picklist_Code_Country__c,lso_fe); 
            }
            if(lso_fe.LSO_Pick_List_Value_Name__c == System.Label.System_CustAllocation)
            {        
                 mapCustomAllocation.put (lso_fe.Picklist_Code_Country__c,lso_fe);  
            }
            if(lso_fe.LSO_Pick_List_Value_Name__c == System.Label.System_SalesResources)
            {        
                 mapTypeSales.put (lso_fe.Picklist_Code_Country__c ,lso_fe);  
            }  
                                                                          
        } 
        
       
        ////////// ERP PickList Vaules Ends Here ////
        
        // FIRE ONLY AFTER INSERT 
        if (trgCtx.isAfter && trgCtx.isInsert) {            
            // GET Local_ERP_Loader__c RECORD INTO THE LIST
            for (sobject sObj : trgCtx.newList) {                
                // ERP ID & SO & DC & Division & Account GUID & Country (Mandatory)    
                Local_ERP_Loader__c erpLoader = (Local_ERP_Loader__c)sObj;                                
                if (erpLoader.ERP_ID__c != NULL && erpLoader.SAP_Sales_Organization__c != NULL && erpLoader.SAP_Distribution_Channel__c != NULL && erpLoader.SAP_Division__c != NULL && erpLoader.Account_GUID__c != NULL && erpLoader.Country__c != NULL && erpLoader.Local_Customer_ID__c != NULL){                   
                    setAccountGUID.add(erpLoader.Account_GUID__c);
                    erpLoaderList.add(erpLoader);
                }               
            }
        }
        
        // QUERTY ACCOUNT CORRESPONDING GUID
        if (setAccountGUID != NULL && setAccountGUID.size() > 0) {            
            for (Account acc : [SELECT ID, GUID__c FROM Account                                 
                                WHERE GUID__c IN: setAccountGUID AND GUID__c != NULL LIMIT 5000]){                                    
                                    mapGUIdAndAccountId.put (acc.GUID__c, acc.Id);                                                                       
                                } 
        } 
        
        // FOR BULK RECORD
        for (Local_ERP_Loader__c loc : erpLoaderList) {
            
            // CHECK WHETHER ACCOUNT GUID IS VALID OR NOT 
            if (mapGUIdAndAccountId.containsKey(loc.Account_GUID__c)) {                
                String erpIdAndSOAndDCAndDiAndGUId = loc.ERP_ID__c + loc.SAP_Sales_Organization__c + loc.SAP_Distribution_Channel__c + loc.SAP_Division__c + loc.Country__c + loc.Account_GUID__c+loc.Local_Customer_ID__c; 
                mapERPIDAndSAId.put (erpIdAndSOAndDCAndDiAndGUId, loc);
            }                
        }
        
        // ADD FROM MAP INTO THE LIST
        if (mapERPIDAndSAId != NULL && mapERPIDAndSAId.size() > 0){filterERPLoaderList.addall(mapERPIDAndSAId.values());}        
        // GET ERP ID AND SA ID AND ACCOUNTGUID
        for (Local_ERP_Loader__c erpl : filterERPLoaderList) {                       
            // COMBINE ALL FIELD INTO THE SET, SO WE CAN QUERY EASILY FROM ERP MAPPING  
            setERPIDAndSOAndDCAndDivision.add(erpl.ERP_ID__c+erpl.SAP_Sales_Organization__c+erpl.SAP_Distribution_Channel__c+erpl.SAP_Division__c);                             
        }
        
        // QUERY RECORD TYPE 
        for (RecordType rec : [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType =: System.Label.System_Local_Reference_Data_SObject LIMIT 5000]) {
            recTypeIdANdDeveloperNameMap.put (rec.Id, rec.DeveloperName);
        }
        
        // QUERY LSO REFERENCE DATA FOR OVERRIDE EXISITNG DATA
        for (ERP_Reference_Data__c erp : [SELECT Id, ERP_ID__c, LBU__c, LSO__c,currencyIsocode , Account__c, Account__r.GUID__c, RecordTypeId, SAP_Sales_Organization__c, SAP_Distribution_Channel__c,  SAP_Division__c, Country__c, Local_Customer_ID__c
                                          FROM ERP_Reference_Data__c 
                                          WHERE Account__c != NULL AND Account__r.GUID__c != NULL
                                          AND Account__r.GUID__c IN :setAccountGUID LIMIT 50000]){                                                
                                           
                                              // FOR GET ID  
                                              // BUYING RECORDTYPE ID 
                                              if (recTypeIdANdDeveloperNameMap.containsKey(erp.RecordTypeId) && recTypeIdANdDeveloperNameMap.get(erp.RecordTypeId) == Label.System_LocalReferenceData_Record_Type_Buying) { 
                                                  mapERPIDSAIdLBULSOAndERPRefRecId.put (erp.ERP_ID__c+erp.SAP_Sales_Organization__c+erp.SAP_Distribution_Channel__c+erp.SAP_Division__c + erp.LBU__c+erp.LSO__c+erp.Account__r.GUID__c+erp.Country__c+erp.Local_Customer_ID__c, erp.Id);
                                              }
                                              // NON BUYING RECORD TYPE ID 
                                              else if (recTypeIdANdDeveloperNameMap.containsKey(erp.RecordTypeId) && recTypeIdANdDeveloperNameMap.get(erp.RecordTypeId) == Label.System_LocalReferenceData_Record_Type_Non_Buying){                                                  
                                                  // NON BUYING ACCOUNT
                                                  mapERPIDSAIdLBULSOAndERPRefRecId.put (erp.LBU__c+erp.LSO__c+erp.Account__r.GUID__c+erp.Country__c, erp.Id);
                                              }  else{}                               
                                          }
              
        // QUERY ERP MAPPING AND SET KEY AS AERP ID AND SO AND DC AND DIVISION 
        if (setERPIDAndSOAndDCAndDivision != NULL && setERPIDAndSOAndDCAndDivision.size() > 0) {           
            for (ERP_Mapping__c erpMapping : [SELECT ID, SAP_Division__c, ERP_ID__c, LBU__c, LSO__c, ERP_Mapping_Combination__c, SAP_Sales_Organization__c, SAP_Distribution_Channel__c
                                              FROM ERP_Mapping__c 
                                              WHERE ERP_Mapping_Combination__c IN : setERPIDAndSOAndDCAndDivision LIMIT 50000]){
                                                  
                                                  if (!erpMappingMap.containsKey(erpMapping.ERP_ID__c+erpMapping.SAP_Sales_Organization__c+ erpMapping.SAP_Distribution_Channel__c + erpMapping.SAP_Division__c) ){
                                                      erpMappingMap.put (erpMapping.ERP_ID__c+erpMapping.SAP_Sales_Organization__c+ erpMapping.SAP_Distribution_Channel__c + erpMapping.SAP_Division__c, new List<ERP_Mapping__c>());}                                                 
                                                  erpMappingMap.get(erpMapping.ERP_ID__c+erpMapping.SAP_Sales_Organization__c+ erpMapping.SAP_Distribution_Channel__c + erpMapping.SAP_Division__c).add(erpMapping);                                                                                               
                                              }
        }  
        
        // QUERY RECORD TYPE FOR ERP_Reference_Data__c 
        String approveGISRecordTypeId = NULL;
        
        for (RecordType rec: [SELECT Id, DeveloperName, sobjecttype FROM RecordType 
                              WHERE sobjecttype =: System.Label.System_Local_Reference_Data_SObject AND DeveloperName =: Label.System_LocalReferenceData_Record_Type_Buying LIMIT 50000]) {                                  
                              approveGISRecordTypeId = rec.Id;
                              } 
        
        // ITERATE CORRESPONDING ERP MAPPING REGARDING ERPID              
        for (Local_ERP_Loader__c loc : filterERPLoaderList) {
            
            IF (loc.ERP_ID__c == NULL){loc.ERP_ID__c = NULL;}
            if (erpMappingMap.containsKey(loc.ERP_ID__c+loc.SAP_Sales_Organization__c+ loc.SAP_Distribution_Channel__c + loc.SAP_Division__c) && erpMappingMap.get(loc.ERP_ID__c+loc.SAP_Sales_Organization__c+ loc.SAP_Distribution_Channel__c + loc.SAP_Division__c) != NULL) {                
                // ITERATE CORRESPONDING ERP MAPPING LIST BELONGS TO THE ERP ID AND SALES ORGANIZAION AND DISTRIBUTION CHANNEL AND DIVISION
                for (ERP_Mapping__c  erp : erpMappingMap.get(loc.ERP_ID__c+loc.SAP_Sales_Organization__c+ loc.SAP_Distribution_Channel__c + loc.SAP_Division__c)) {                   
                    ERP_Reference_Data__c referenceLSOData = new ERP_Reference_Data__c();
                    referenceLSOData.RecordTypeId = approveGISRecordTypeId; // RECORD TYPE DEFAULT SET GIS_Approved_LSO_Reference_Data
                    referenceLSOData.Account_GUID__c = loc.Account_GUID__c;
                    referenceLSOData.SAP_Division__c = loc.SAP_Division__c;
                    referenceLSOData.LSO__c = erp.LSO__c;
                    referenceLSOData.LBU__c = erp.LBU__c;
                    referenceLSOData.ERP_ID__c = loc.ERP_ID__c;
                    referenceLSOData.Country__c = loc.Country__c;                    
                    referenceLSOData.Local_Customer_ID__c = loc.Local_Customer_ID__c; 
                    if(loc.Block__c == NULL){referenceLSOData.Block__c =False;}else{referenceLSOData.Block__c = loc.Block__c;}                    
                    referenceLSOData.Block_description__c = loc.Block_description__c;                                      
                    referenceLSOData.Risk_class__c = loc.Credit_Information_Risk_class__c;
                    referenceLSOData.Business_1__c = loc.Business_1__c;
                    referenceLSOData.Business_2__c = loc.Business_2__c;
                    referenceLSOData.Business_3__c = loc.Business_3__c;                    
                    referenceLSOData.Sales_Person_1__c = loc.Sales_Person_1__c;
                    referenceLSOData.Sales_Person_2__c = loc.Sales_Person_2__c;
                    referenceLSOData.Sales_Person_3__c = loc.Sales_Person_3__c;                     
                    referenceLSOData.Customer_Currency__c = loc.currencyIsocode ; 
                    
                    //// Newly Added ERP Picklist lookuping /////////////////
                    
                    String strDelimiter = ' '+System.Label.System_LSODelimiter+' ';                    
                    
                    if(loc.Sales_District__c != null && loc.Country__c != null)
                    {   
                        string strdismap =  loc.Sales_District__c.trim()+strDelimiter+loc.Country__c;                        
                        if(mapDistrict.get(strdismap) != null && mapDistrict.get(strdismap).PickList_Description__c != null )
                        {referenceLSOData.Sales_District_Text__c = mapDistrict.get(strdismap).PickList_Description__c; }
                        else
                        {referenceLSOData.Sales_District_Text__c = loc.Sales_District__c;}
                    }
                    if(loc.Sales_Office__c!= null && loc.Country__c != null)
                    {
                        string strsalmap = loc.Sales_Office__c.trim()+strDelimiter+loc.Country__c;
                        if(mapSalesOffice.get(strsalmap) != null && mapSalesOffice.get(strsalmap).PickList_Description__c != null)                        
                        {referenceLSOData.Sales_Office_Text__c = mapSalesOffice.get(strsalmap).PickList_Description__c;}
                        else
                        {referenceLSOData.Sales_Office_Text__c = loc.Sales_Office__c;}
                    }
                    if(loc.Local_Main_Business__c!= null && loc.Country__c != null)
                    {
                        string strlocmap = loc.Local_Main_Business__c.trim()+strDelimiter+loc.Country__c;
                        if(mapLocalMain.get(strlocmap)!= null && mapLocalMain.get(strlocmap).PickList_Description__c != null)
                        {referenceLSOData.Local_Main_Business_Text__c = mapLocalMain.get(strlocmap).PickList_Description__c;}
                        else
                        {referenceLSOData.Local_Main_Business_Text__c = loc.Local_Main_Business__c;}
                    }
                    if(loc.Local_Channel__c!= null && loc.Country__c != null)
                    {
                        string strchnmap = loc.Local_Channel__c.trim()+strDelimiter+loc.Country__c;
                        if(mapLocalChannel.get(strchnmap) != null && mapLocalChannel.get(strchnmap).PickList_Description__c!= null)
                        {referenceLSOData.Local_Channel_Text__c = mapLocalChannel.get(strchnmap).PickList_Description__c;}
                        else
                        {referenceLSOData.Local_Channel_Text__c = loc.Local_Channel__c;}
                    }
                    if(loc.Local_Segment__c!= null && loc.Country__c != null)
                    {
                        string strsegmap = loc.Local_Segment__c.trim()+strDelimiter+loc.Country__c;
                        if(mapLocalSegment.get(strsegmap)!= null && mapLocalSegment.get(strsegmap).PickList_Description__c != null)
                        {referenceLSOData.Local_Segment_Text__c = mapLocalSegment.get(strsegmap).PickList_Description__c;}
                        else
                        {referenceLSOData.Local_Segment_Text__c = loc.Local_Segment__c;}
                    }
                    if(loc.Customer_Allocation__c!= null && loc.Country__c != null)
                    {
                        string strcusmap = loc.Customer_Allocation__c.trim()+strDelimiter+loc.Country__c;
                        if(mapCustomAllocation.get(strcusmap) != null && mapCustomAllocation.get(strcusmap).PickList_Description__c != null)
                        {referenceLSOData.Customer_Allocation_Text__c = mapCustomAllocation.get(strcusmap).PickList_Description__c;}
                        else
                        {referenceLSOData.Customer_Allocation_Text__c = loc.Customer_Allocation__c;}
                    }
                    if(loc.Type_of_Sales_Force__c!= null && loc.Country__c != null)
                    {
                        string strtypmap = loc.Type_of_Sales_Force__c.trim()+strDelimiter+loc.Country__c;
                        if(mapTypeSales.get(strtypmap) != null && mapTypeSales.get(strtypmap).PickList_Description__c != null)
                        {referenceLSOData.Type_of_Sales_Resources_Text__c = mapTypeSales.get(strtypmap).PickList_Description__c;}
                        else
                        {referenceLSOData.Type_of_Sales_Resources_Text__c = loc.Type_of_Sales_Force__c;}
                    }
        
                    //// Newly Added ERP Picklist lookuping ends here ////////
                                                                            
                    if (loc.SAP_Sales_Organization__c != NULL ){referenceLSOData.SAP_Sales_Organization__c = loc.SAP_Sales_Organization__c;}
                    if (loc.SAP_Distribution_Channel__c != NULL ){referenceLSOData.SAP_Distribution_Channel__c = loc.SAP_Distribution_Channel__c;}
                    
                    if (mapGUIdAndAccountId.containsKey(loc.Account_GUID__c) && mapGUIdAndAccountId.get(loc.Account_GUID__c) != NULL){
                        referenceLSOData.Account__c = mapGUIdAndAccountId.get(loc.Account_GUID__c);
                    }
                    
                    // PUT ID ALREADY ERP REFERENCE DATA MEAN
                    if (mapERPIDSAIdLBULSOAndERPRefRecId.containsKey(erp.ERP_ID__c+erp.SAP_Sales_Organization__c+erp.SAP_Distribution_Channel__c+erp.SAP_Division__c + erp.LBU__c+erp.LSO__c+loc.Account_GUID__c+loc.Country__c+loc.Local_Customer_ID__c)) {
                        referenceLSOData.Id = mapERPIDSAIdLBULSOAndERPRefRecId.get(erp.ERP_ID__c+erp.SAP_Sales_Organization__c+erp.SAP_Distribution_Channel__c+erp.SAP_Division__c + erp.LBU__c+erp.LSO__c+loc.Account_GUID__c+loc.Country__c+loc.Local_Customer_ID__c);                                               
                    }else if (mapERPIDSAIdLBULSOAndERPRefRecId.containsKey(erp.LBU__c+erp.LSO__c+loc.Account_GUID__c+loc.Country__c )&& !ManualOverriden.contains(erp.LBU__c+erp.LSO__c+loc.Account_GUID__c+loc.Country__c)) {
                        referenceLSOData.Id = mapERPIDSAIdLBULSOAndERPRefRecId.get(erp.LBU__c+erp.LSO__c+loc.Account_GUID__c+loc.Country__c);
                        ManualOverriden.add(erp.LBU__c+erp.LSO__c+loc.Account_GUID__c+loc.Country__c);                       
                        referenceLSOData.Sales_Person_1_Manual_Entry__c = null;
                        referenceLSOData.Sales_Person_2_Manual_Entry__c = null;
                        referenceLSOData.Sales_Person_3_Manual_Entry__c = null;                        
                    }else{}
                    
                    // 26/08/2015
                    referenceLSOData.Credit_Limit__c = loc.Credit_Limit_Information__c;                    
                    tobeInsertErpRefDataList.add(referenceLSOData);                       
                }
            }           
        } // end for loop            
            Database.UPSERT(tobeInsertErpRefDataList);                                   
    }                       

}