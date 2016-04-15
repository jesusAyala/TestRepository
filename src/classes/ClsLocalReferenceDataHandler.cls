/**   
* ApexClass - Insert/Update the LocalReferenceData record 
* Controller for the VisualForce page LocalReferenceDataHandlerVF
*     
* Release R3
*  
* @author  MohanRaj Kasinathan (Accenture)
* @created 2015-07-31* @version 1.0
*
* - Created
*/
Public with sharing class ClsLocalReferenceDataHandler{    
    public List<Field_Dependencies__c> listCustomSettings = new List<Field_Dependencies__c>();
    public List<SelectOption> listLSO = new List<SelectOption>();
    public List<SelectOption> listLBU = new List<SelectOption>();
    Public String userCountry {get;set;}
    public String strLSOValues {get;set;}
    public String strLBUValues {get;set;}         
    public String erpId = null;
    public String accountId = null;
    public String eId{get;set;}   
    private final ERP_Reference_Data__c eRPrec;
    private final String dBcountry;
    private final String countryParam;
        
    Public String userLSO {get;set;}
    Public String userLBU {get;set;}
    
    private integer i = 1;
    
    
    public List<SelectOption> listSalDistrict = new List<SelectOption>();
    public String strSalDistrict {get;set;}
    public List<SelectOption> listSalesOffice = new List<SelectOption>();
    public String strSalesOffice {get;set;}
    public List<SelectOption> listLocalMainBus = new List<SelectOption>();
    public String strLocalMainBus {get;set;}
    public List<SelectOption> listLocalChannel = new List<SelectOption>();
    public String strLocalChannel {get;set;}
    public List<SelectOption> listLocalSegment = new List<SelectOption>();
    public String strLocalSegment {get;set;}
    public List<SelectOption> listCustAllocation = new List<SelectOption>();
    public String strCustAllocation {get;set;}
    public List<SelectOption> listTypeSalesResource = new List<SelectOption>();
    public String strTypeSalesResource {get;set;}

    /**   
    * ApexClass - Insert/Update the ClsLSOFieldEntries - Constructor      
    * Release R3
    *  
    * @author  MohanRaj Kasinathan (Accenture)
    * @created 2015-07-31* @version 1.0
    *
    */
    public ERP_Reference_Data__c localreferenceData {
        get {
            if (localreferenceData == null)
                localreferenceData = new ERP_Reference_Data__c();
            return localreferenceData;
        }
        set;
        
    } 
    
    /**   
    * ApexClass - Insert/Update the ClsLocalReferenceDataHandler - Overloaded Constructor
    * Release R3
    *  
    * @author  MohanRaj Kasinathan (Accenture)
    * @created 2015-07-31* @version 1.0    *
    */
    Public ClsLocalReferenceDataHandler(ApexPages.StandardController controller){
      try{
      this.eRPrec = (ERP_Reference_Data__c)controller.getRecord();             
      
      User userDetails = [SELECT Id, Country, Default_BU__c, Default_LSO__c FROM User WHERE Id=:userinfo.getuserId() limit 1];
      userCountry = userDetails.Country;    
      if((userDetails.Default_LSO__c != '') && (userDetails.Default_LSO__c != null) )   
      {
          userLSO = userDetails.Default_LSO__c; 
      }
      if((userDetails.Default_BU__c != '') && (userDetails.Default_BU__c != null) )   
      { 
          userLBU = userDetails.Default_BU__c;      
      }
      
      ERP_Mapping__c[] erp_lso = [SELECT Id, Country__c,LSO_Description__c, LSO__c, LBU__c FROM ERP_Mapping__c WHERE Country__c= : userCountry and LSO__c =: userLSO  LIMIT 1];
      if(erp_lso != null && erp_lso.size() >0)
      {
          userLSO = erp_lso[0].LSO_Description__c;
      }
      
      erpId = apexpages.currentpage().getParameters().get(Label.System_CL0005);      
      eId = erpId;
      
      localreferenceData = new ERP_Reference_Data__c();
      
      if(eId == null)
      {localreferenceData.Country__c = userCountry;}
      
       
       List<ERP_Reference_Data__c> listERP = [Select Id, Name ,Account__c, Non_Buying_Account_Type__c,  LSO_ERP_Mapping_Value__c, LBU__c, LSO__c , Country__c,
                                              Sales_District_Text__c, Sales_Office_Text__c, Local_Main_Business_Text__c, Local_Channel_Text__c, 
                                              Local_Segment_Text__c, Customer_Allocation_Text__c, Type_of_Sales_Resources_Text__c,Sales_Plan__c,
                                              Promotion_Plan__c, Crif_Number__c, Business_1__c,Business_2__c,Business_3__c,Sales_Person_1_Manual_Entry__c,
                                              Sales_Person_2_Manual_Entry__c,Sales_Person_3_Manual_Entry__c, Technical_Support__c,Technical_Promoter__c                      
                                              FROM ERP_Reference_Data__c where Id= : erpId limit 1];
                     

          if (listERP != NULL && listERP.size() > 0) {
          
              if(eId != null){localreferenceData.Country__c = listERP[0].Country__c; dBcountry = listERP[0].Country__c; }    
                localreferenceData.Id = listERP[0].Id;
                localreferenceData.Account__c = listERP[0].Account__c;
                localreferenceData.Non_Buying_Account_Type__c = listERP[0].Non_Buying_Account_Type__c;  
                localreferenceData.LSO_ERP_Mapping_Value__c = listERP[0].LSO_ERP_Mapping_Value__c;
                localreferenceData.LBU__c = listERP[0].LBU__c; 
                localreferenceData.Country__c = listERP[0].Country__c;           
                localreferenceData.Sales_District_Text__c = listERP[0].Sales_District_Text__c; 
                localreferenceData.Sales_Office_Text__c = listERP[0].Sales_Office_Text__c; 
                localreferenceData.Local_Main_Business_Text__c = listERP[0].Local_Main_Business_Text__c;
                localreferenceData.Local_Channel_Text__c = listERP[0].Local_Channel_Text__c; 
                localreferenceData.Local_Segment_Text__c = listERP[0].Local_Segment_Text__c; 
                localreferenceData.Customer_Allocation_Text__c = listERP[0].Customer_Allocation_Text__c; 
                localreferenceData.Type_of_Sales_Resources_Text__c = listERP[0].Type_of_Sales_Resources_Text__c;
                localreferenceData.Sales_Plan__c = listERP[0].Sales_Plan__c;
                localreferenceData.Promotion_Plan__c = listERP[0].Promotion_Plan__c; 
                localreferenceData.Crif_Number__c = listERP[0].Crif_Number__c; 
                localreferenceData.Business_1__c = listERP[0].Business_1__c;
                localreferenceData.Business_2__c = listERP[0].Business_2__c;
                localreferenceData.Business_3__c = listERP[0].Business_3__c;
                localreferenceData.Sales_Person_1_Manual_Entry__c = listERP[0].Sales_Person_1_Manual_Entry__c;
                localreferenceData.Sales_Person_2_Manual_Entry__c = listERP[0].Sales_Person_2_Manual_Entry__c;
                localreferenceData.Sales_Person_3_Manual_Entry__c = listERP[0].Sales_Person_3_Manual_Entry__c; 
                localreferenceData.Technical_Support__c = listERP[0].Technical_Support__c;
                localreferenceData.Technical_Promoter__c = listERP[0].Technical_Promoter__c; 
          }  
          
      // get the current record account Id            
      accountId = apexpages.currentpage().getParameters().get(Label.System_CL0006); 
      
      if(accountId != NULL){
          localreferenceData.Account__c = accountId;  
      }  
       
       
      }catch(DMLException e){                
        // exception            
      } 
                             
    }
    
    /**   
    * Retrieve the LSO values from ERP Mapping Table 
    *     
    * Release R3
    */    
    public List<SelectOption> getlistLSO(){  
        try{                  
        
        string countryVal = apexpages.currentpage().getparameters().get(System.Label.System_CL0007);        
        
        if((countryVal != System.Label.System_None_Value && countryVal != null && i != 1)|| (countryVal == null && i == 1) )
        {             
            listLSO.clear();        
            listLSO.add(new SelectOption(System.Label.System_None_Value, System.Label.System_None_Value)); 
            strLSOValues = null;        
            listLBU.clear();
            listLBU.add(new SelectOption(System.Label.System_None_Value, System.Label.System_None_Value));     
            
            Set<String> lsoDistinct = new Set<String>();        
            if (countryVal != NULL && !String.isBlank(countryVal)) {
                
                localreferenceData.Country__c = countryVal;
            }
            
            for(ERP_Mapping__c erp : [SELECT Id, Country__c,LSO_Description__c, LSO__c, LBU__c FROM ERP_Mapping__c WHERE Country__c= :localreferenceData.Country__c  order by LSO_Description__c LIMIT 50000]){           
    
                lsoDistinct.add(erp.LSO_Description__c);            
            }
            
            for(string str : lsoDistinct)
            {           
                listLSO.add(new SelectOption(str, str ));
            } 
            
            if(eId == null && strLSOValues  == null && i == 1)
            {                 
                strLSOValues = userLSO;
                //localreferenceData.LSO_ERP_Mapping_Value__c = strLSOValues;
                
                listLBU.clear();
                listLBU.add(new SelectOption(System.Label.System_None_Value, System.Label.System_None_Value));                
                Set<String> lbuDistinct  = new Set<String>();
                
                for(ERP_Mapping__c erp : [SELECT Id, LSO__c, LBU__c FROM ERP_Mapping__c WHERE LSO_Description__c =: strLSOValues order by LBU__c limit 50000]){
                if(erp.LBU__c!= null)
                {lbuDistinct .add(erp.LBU__c);}
                } 
                
                integer i = 0;        
                for(string str : lbuDistinct ){           
                listLBU.add(new SelectOption(str, str ));
                    if(userLBU != '' && userLBU != null && userLBU == str )
                    {         
                        strLBUValues = userLBU;
                        //localreferenceData.LBU__c = strLBUValues;
                    }
                                                 
                }   
            
                
                            
                // Load LBU Ends here ////               
                
                
                
            }
        
            if(eId != null && strLSOValues  == null && countryVal == null && i == 1)
            {        
                strLSOValues = localreferenceData.LSO_ERP_Mapping_Value__c;  
                
                
                // Load LBU ////
                
                    listLBU.clear();
                    listLBU.add(new SelectOption(System.Label.System_None_Value, System.Label.System_None_Value));                
                    Set<String> lbuDistinct  = new Set<String>();
                    
                    for(ERP_Mapping__c erp : [SELECT Id, LSO__c, LBU__c FROM ERP_Mapping__c WHERE LSO_Description__c =: strLSOValues order by LBU__c limit 50000]){
                    if(erp.LBU__c!= null)
                    {lbuDistinct .add(erp.LBU__c);}
                    } 
                    
                    integer i = 0;        
                    for(string str : lbuDistinct ){           
                    listLBU.add(new SelectOption(str, str ));                                 
                    }   
                
                // Load LBU Ends here ////               
                
                strLBUValues  = localreferenceData.LBU__c;
                
                if(localreferenceData.Country__c != null && strLBUValues == null )
                {
                    loadPickLists (True, False, False, localreferenceData.Country__c , '', '');
                }
                
                if(localreferenceData.Country__c != null && strLBUValues != null )
                {          
                    loadPickLists (False, True, False, localreferenceData.Country__c , strLBUValues, '');
                } 
                
                if(localreferenceData.Sales_District_Text__c != null )
                {           
                    loadPickLists (False, False, True, localreferenceData.Country__c , strLBUValues, localreferenceData.Sales_District_Text__c);
                } 
                                        
                strSalDistrict = localreferenceData.Sales_District_Text__c;
                strSalesOffice = localreferenceData.Sales_Office_Text__c;
                strLocalMainBus = localreferenceData.Local_Main_Business_Text__c;
                strLocalChannel = localreferenceData.Local_Channel_Text__c;
                strLocalSegment = localreferenceData.Local_Segment_Text__c;
                strCustAllocation = localreferenceData.Customer_Allocation_Text__c;
                strTypeSalesResource = localreferenceData.Type_of_Sales_Resources_Text__c;
            } 
            
            if(eId != null && countryVal != null && i != 1)
            {            
                loadPickLists (True, False, False, localreferenceData.Country__c , '', ''); 
            }     
            
            
            if(eId == null)
            {
                loadPickLists (True, False, False, localreferenceData.Country__c , '', '');
            }
            
            i = 2;
        
            }
                  
            return listLSO;
            }catch(DMLException e){                
                    return null;     
            } 
    }     
    
    /**   
    * Selects the LBU values from ERP mapping table, for the related Local Reference Data country
    *     
    * Release R3
    */    
    public List<SelectOption> getlistLBU(){ 
        try{
        
        string countryVal = apexpages.currentpage().getparameters().get(System.Label.System_CL0007);
        string LSOVal = apexpages.currentpage().getparameters().get(System.Label.System_LSOValue);   
        string LBUVal = apexpages.currentpage().getparameters().get(System.Label.System_LBUValue); 
         
         if(LSOVal != null){
            
            strLSOValues =  LSOVal;
        
            listLBU.clear();
            listLBU.add(new SelectOption(System.Label.System_None_Value, System.Label.System_None_Value));                
            Set<String> lbuDistinct  = new Set<String>();
        
            for(ERP_Mapping__c erp : [SELECT Id, LSO__c, LBU__c FROM ERP_Mapping__c WHERE LSO_Description__c =: strLSOValues limit 50000]){
            if(erp.LBU__c!= null)
            {lbuDistinct .add(erp.LBU__c);}
            } 
        
            integer i = 0;        
            for(string str : lbuDistinct ){           
                listLBU.add(new SelectOption(str, str ));                                 
            }   
            
            
        
        }
        
        return listLBU;   
        }catch(DMLException e){                
                return null;     
        }      
    } 
    
    
    
    public void loadPickLists_Country (String strCountry)
    {
        List<LSO_Field_Entries__c> lstPicvals = new List<LSO_Field_Entries__c>();
        
        lstPicvals = [Select LSO_Pick_List_Value_Name__c, PickList_Description__c, PickList_Description_Code__c from LSO_Field_Entries__c 
                          where Controlling_Field__c =:  System.Label.System_CountryCntrl and RecordType.name =: System.Label.System_LSOManual_RT and Value__c =: strCountry order by PickList_Description__c];
          
            listSalDistrict.clear(); 
            listSalDistrict.add(new SelectOption(System.Label.System_None_Value, System.Label.System_None_Value));
            listSalesOffice.clear(); 
            listSalesOffice.add(new SelectOption(System.Label.System_None_Value, System.Label.System_None_Value));
            listLocalMainBus.clear(); 
            listLocalMainBus.add(new SelectOption(System.Label.System_None_Value, System.Label.System_None_Value));
            listLocalChannel.clear(); 
            listLocalChannel.add(new SelectOption(System.Label.System_None_Value, System.Label.System_None_Value));
            listLocalSegment.clear(); 
            listLocalSegment.add(new SelectOption(System.Label.System_None_Value, System.Label.System_None_Value));
            listCustAllocation.clear(); 
            listCustAllocation.add(new SelectOption(System.Label.System_None_Value, System.Label.System_None_Value));
            listTypeSalesResource.clear(); 
            listTypeSalesResource.add(new SelectOption(System.Label.System_None_Value, System.Label.System_None_Value));   
            
            strSalDistrict = null;
            strSalesOffice = null;
            strLocalMainBus = null;
            strLocalChannel = null;
            strLocalSegment = null;
            strCustAllocation = null;
            strTypeSalesResource = null;  
          
            for(LSO_Field_Entries__c fe : lstPicvals)
            {
                
                if(fe.LSO_Pick_List_Value_Name__c == System.Label.System_SalesDistrict)
                {        
                    listSalDistrict.add(new SelectOption(fe.PickList_Description__c, fe.PickList_Description__c));  
                }        
                if(fe.LSO_Pick_List_Value_Name__c == System.Label.System_SalesOffice)
                {        
                    listSalesOffice.add(new SelectOption(fe.PickList_Description__c, fe.PickList_Description__c));  
                }        
                if(fe.LSO_Pick_List_Value_Name__c == System.Label.System_LocalMainBus)
                {        
                    listLocalMainBus.add(new SelectOption(fe.PickList_Description__c, fe.PickList_Description__c));  
                }
                if(fe.LSO_Pick_List_Value_Name__c == System.Label.System_LocalSegment)
                {        
                    listLocalSegment.add(new SelectOption(fe.PickList_Description__c, fe.PickList_Description__c));  
                }
                if(fe.LSO_Pick_List_Value_Name__c == System.Label.System_LocalChannel)
                {        
                    listLocalChannel.add(new SelectOption(fe.PickList_Description__c, fe.PickList_Description__c));  
                }
                if(fe.LSO_Pick_List_Value_Name__c == System.Label.System_CustAllocation)
                {        
                    listCustAllocation.add(new SelectOption(fe.PickList_Description__c, fe.PickList_Description__c));  
                }
                if(fe.LSO_Pick_List_Value_Name__c == System.Label.System_SalesResources)
                {        
                    listTypeSalesResource.add(new SelectOption(fe.PickList_Description__c, fe.PickList_Description__c));  
                }           
                
            }
            
    }
    
    /**   
    * Retrieve the Picklist values from LSO_Field_Entries__c 
    *     
    * Release R3
    */
    public void loadPickLists (Boolean isCountry, Boolean isLbu, Boolean isDisrict, String strCountry, String strLbu, String strDistrict)
    {
    
        List<LSO_Field_Entries__c> lstPicvals = new List<LSO_Field_Entries__c>();
        List<LSO_Field_Entries__c> lstDistPicvals = new List<LSO_Field_Entries__c>();
        
        if(isCountry)
        {
            loadPickLists_Country(strCountry);
        }
        
        if(isLbu)
        {
            lstPicvals = [Select LSO_Pick_List_Value_Name__c, PickList_Description__c, PickList_Description_Code__c from LSO_Field_Entries__c 
                            where Controlling_Field__c =: System.Label.System_LBUContrl and Value__c = : strLbu  
                            and RecordType.name =: System.Label.System_LSOManual_RT and Country__c =: strCountry order by PickList_Description__c];    
                            
            listSalDistrict.clear(); 
            listSalDistrict.add(new SelectOption(System.Label.System_None_Value, System.Label.System_None_Value));
            listSalesOffice.clear(); 
            listSalesOffice.add(new SelectOption(System.Label.System_None_Value, System.Label.System_None_Value));
            listLocalMainBus.clear(); 
            listLocalMainBus.add(new SelectOption(System.Label.System_None_Value, System.Label.System_None_Value));
            listLocalChannel.clear(); 
            listLocalChannel.add(new SelectOption(System.Label.System_None_Value, System.Label.System_None_Value));
            listLocalSegment.clear(); 
            listLocalSegment.add(new SelectOption(System.Label.System_None_Value, System.Label.System_None_Value));
            listCustAllocation.clear(); 
            listCustAllocation.add(new SelectOption(System.Label.System_None_Value, System.Label.System_None_Value));
            listTypeSalesResource.clear(); 
            listTypeSalesResource.add(new SelectOption(System.Label.System_None_Value, System.Label.System_None_Value));   
            
            strSalDistrict = null;
            strSalesOffice = null;
            strLocalMainBus = null;
            strLocalChannel = null;
            strLocalSegment = null;
            strCustAllocation = null;
            strTypeSalesResource = null;    
            
            Boolean blnSalDistrict = False;
            Boolean blnSalesOffice = False;
            Boolean blnLocalMainBus = False;
            Boolean blnLocalChannel = False;
            Boolean blnLocalSegment = False;
            Boolean blnCustAllocation = False;
            Boolean blnTypeSalesResource = False; 
            
            if(lstPicvals != null && lstPicvals.size() >0)
            {           
                
              
                for(LSO_Field_Entries__c fe : lstPicvals)
                {
                    
                    if(fe.LSO_Pick_List_Value_Name__c == System.Label.System_SalesDistrict)
                    {        
                        listSalDistrict.add(new SelectOption(fe.PickList_Description__c, fe.PickList_Description__c));  
                    }        
                    if(fe.LSO_Pick_List_Value_Name__c == System.Label.System_SalesOffice)
                    {        
                        listSalesOffice.add(new SelectOption(fe.PickList_Description__c, fe.PickList_Description__c));  
                    }        
                    if(fe.LSO_Pick_List_Value_Name__c == System.Label.System_LocalMainBus)
                    {        
                        listLocalMainBus.add(new SelectOption(fe.PickList_Description__c, fe.PickList_Description__c));  
                    }
                    if(fe.LSO_Pick_List_Value_Name__c == System.Label.System_LocalSegment)
                    {        
                        listLocalSegment.add(new SelectOption(fe.PickList_Description__c, fe.PickList_Description__c));  
                    }
                    if(fe.LSO_Pick_List_Value_Name__c == System.Label.System_LocalChannel)
                    {        
                        listLocalChannel.add(new SelectOption(fe.PickList_Description__c, fe.PickList_Description__c));  
                    }
                    if(fe.LSO_Pick_List_Value_Name__c == System.Label.System_CustAllocation)
                    {        
                        listCustAllocation.add(new SelectOption(fe.PickList_Description__c, fe.PickList_Description__c));  
                    }
                    if(fe.LSO_Pick_List_Value_Name__c == System.Label.System_SalesResources)
                    {        
                        listTypeSalesResource.add(new SelectOption(fe.PickList_Description__c, fe.PickList_Description__c));  
                    }           
                    
                }
            }
                         
            
            if(listSalDistrict.size()== 1)
            {blnSalDistrict = True;}
            
            if(listSalesOffice.size()== 1)
            {blnSalesOffice = True;}
            
            if(listLocalMainBus.size()== 1)
            {blnLocalMainBus = True;}
            
            if(listLocalChannel.size()== 1)
            {blnLocalChannel= True;}
            
            if(listLocalSegment.size()== 1)
            {blnLocalSegment = True;}
            
            if(listCustAllocation.size()== 1)
            {blnCustAllocation = True;}
            
            if(listTypeSalesResource.size()== 1)
            {blnTypeSalesResource = True;}
            
            
            List<LSO_Field_Entries__c> lstPicvals_Country = new List<LSO_Field_Entries__c>();
        
            lstPicvals_Country = [Select LSO_Pick_List_Value_Name__c, PickList_Description__c, PickList_Description_Code__c from LSO_Field_Entries__c 
                                   where Controlling_Field__c =:  System.Label.System_CountryCntrl  
                                   and RecordType.name =: System.Label.System_LSOManual_RT and Value__c =: strCountry order by PickList_Description__c];          
             
          
            for(LSO_Field_Entries__c fe : lstPicvals_Country)
            {
                
                if(fe.LSO_Pick_List_Value_Name__c == System.Label.System_SalesDistrict && blnSalDistrict == true )
                {        
                    listSalDistrict.add(new SelectOption(fe.PickList_Description__c, fe.PickList_Description__c));  
                }        
                if(fe.LSO_Pick_List_Value_Name__c == System.Label.System_SalesOffice  && blnSalesOffice  == true )
                {        
                    listSalesOffice.add(new SelectOption(fe.PickList_Description__c, fe.PickList_Description__c));  
                }        
                if(fe.LSO_Pick_List_Value_Name__c == System.Label.System_LocalMainBus  && blnLocalMainBus  == true )
                {        
                    listLocalMainBus.add(new SelectOption(fe.PickList_Description__c, fe.PickList_Description__c));  
                }
                if(fe.LSO_Pick_List_Value_Name__c == System.Label.System_LocalSegment  && blnLocalSegment == true )
                {        
                    listLocalSegment.add(new SelectOption(fe.PickList_Description__c, fe.PickList_Description__c));  
                }
                if(fe.LSO_Pick_List_Value_Name__c == System.Label.System_LocalChannel && blnLocalChannel == true )
                {        
                    listLocalChannel.add(new SelectOption(fe.PickList_Description__c, fe.PickList_Description__c));  
                }
                if(fe.LSO_Pick_List_Value_Name__c == System.Label.System_CustAllocation  && blnCustAllocation  == true )
                {        
                    listCustAllocation.add(new SelectOption(fe.PickList_Description__c, fe.PickList_Description__c));  
                }
                if(fe.LSO_Pick_List_Value_Name__c == System.Label.System_SalesResources  && blnTypeSalesResource  == true )
                {        
                    listTypeSalesResource.add(new SelectOption(fe.PickList_Description__c, fe.PickList_Description__c));  
                }           
                
            }
            
                  
                            
        }        
       
        
        if(isDisrict)
        {
            lstDistPicvals = [Select LSO_Pick_List_Value_Name__c, PickList_Description__c, PickList_Description_Code__c from LSO_Field_Entries__c 
                              where Controlling_Field__c =: System.Label.System_DistrictCntrl  
                              and RecordType.name =: System.Label.System_LSOManual_RT and Value__c =: strDistrict  and Country__c =: strCountry order by PickList_Description__c];
        
            if(lstDistPicvals != null && lstDistPicvals.size() >0)
            {
                listSalesOffice.clear();
                listSalesOffice.add(new SelectOption(System.Label.System_None_Value, System.Label.System_None_Value));
                strSalesOffice = null;
                
                for(LSO_Field_Entries__c val : lstDistPicvals)
                {       
                    if(val.LSO_Pick_List_Value_Name__c == System.Label.System_SalesOffice )
                    {        
                        listSalesOffice.add(new SelectOption(val.PickList_Description__c, val.PickList_Description__c));  
                    }       
                
                } 
            }
            else if (strLbu != null && strLbu != System.Label.System_None_Value )    
            {
               List<LSO_Field_Entries__c>  lstPicSOFvals_LBU = [Select LSO_Pick_List_Value_Name__c, PickList_Description__c, PickList_Description_Code__c from LSO_Field_Entries__c 
                                                                where Controlling_Field__c =: System.Label.System_LBUContrl and Value__c = : strLbu and Country__c =: strCountry 
                                                                 and RecordType.name =: System.Label.System_LSOManual_RT and LSO_Pick_List_Value_Name__c =: System.Label.System_SalesOffice order by PickList_Description__c];    
              
                if(lstPicSOFvals_LBU != null && lstPicSOFvals_LBU.size() >0)
                {                 
                    listSalesOffice.clear();
                    listSalesOffice.add(new SelectOption(System.Label.System_None_Value, System.Label.System_None_Value));
                    strSalesOffice = null;
                    
                    for(LSO_Field_Entries__c val : lstPicSOFvals_LBU)
                    {       
                        if(val.LSO_Pick_List_Value_Name__c == System.Label.System_SalesOffice )
                        {        
                            listSalesOffice.add(new SelectOption(val.PickList_Description__c, val.PickList_Description__c));  
                        }       
                    
                    } 
                
                }
            }
            else
            {
              List<LSO_Field_Entries__c>  lstPicSOFvals_CNTY = [Select LSO_Pick_List_Value_Name__c, PickList_Description__c, PickList_Description_Code__c from LSO_Field_Entries__c 
                                                               where Controlling_Field__c =:  System.Label.System_CountryCntrl and Value__c =: strCountry 
                                                                and RecordType.name =: System.Label.System_LSOManual_RT and LSO_Pick_List_Value_Name__c =: System.Label.System_SalesOffice order by PickList_Description__c];
              
                if(lstPicSOFvals_CNTY != null && lstPicSOFvals_CNTY.size() >0)
                { 
                    listSalesOffice.clear();
                    listSalesOffice.add(new SelectOption(System.Label.System_None_Value, System.Label.System_None_Value));
                    strSalesOffice = null;
                    
                    for(LSO_Field_Entries__c val : lstPicSOFvals_CNTY)
                    {       
                        if(val.LSO_Pick_List_Value_Name__c == System.Label.System_SalesOffice )
                        {        
                            listSalesOffice.add(new SelectOption(val.PickList_Description__c, val.PickList_Description__c));  
                        }       
                    
                    } 
                
                }
            
            }      
        
        }
        
    
    
    }    
    
    /**   
    * getlistSalDistrict() 
    *     
    * Release R3
    */
    public List<SelectOption> getlistSalDistrict(){ 
        try{        
        
        string countryVal = apexpages.currentpage().getparameters().get(System.Label.System_CL0007);
        string LSOVal = apexpages.currentpage().getparameters().get(System.Label.System_LSOValue);   
        string LBUVal = apexpages.currentpage().getparameters().get(System.Label.System_LBUValue);           
        
        if(LBUVal  != null )
        {        
            strLBUValues = LBUVal;        
            loadPickLists (False, True, False, localreferenceData.Country__c , strLBUValues, '');
        } 
        
        return listSalDistrict;   
        }catch(DMLException e){                
                return null;     
        }      
    } 

    /**   
    * getlistSalesOffice() 
    *     
    * Release R3
    */
    public List<SelectOption> getlistSalesOffice(){ 
        try
        {
            string DisValue = apexpages.currentpage().getparameters().get(System.Label.System_DisValue);            
        
            if(DisValue != null )
            {        
                strSalDistrict = DisValue;        
                loadPickLists (False, False, True, localreferenceData.Country__c , strLBUValues, DisValue);
                strSalesOffice = null; 
            } 
            
            return listSalesOffice;   
        }catch(DMLException e){                
                return null;     
        }      
     } 
      
    /**   
    * getlistLocalMainBus() 
    *     
    * Release R3
    */
    public List<SelectOption> getlistLocalMainBus(){ 
        try
        {        
            string SalValue = apexpages.currentpage().getparameters().get(System.Label.System_SalValue);            
        
            if(SalValue != null && SalValue  == System.Label.System_None_Value )
            {        
                //strSalesOffice = null;                        
            } 
        
            return listLocalMainBus;   
        }catch(DMLException e){                
                return null;     
        }      
     }
     
    /**   
    * getlistLocalChannel() 
    *     
    * Release R3
    */
     public List<SelectOption> getlistLocalChannel(){ 
        try
        {
            return listLocalChannel;   
        }catch(DMLException e){                
                return null;     
        }      
     }
    
    /**   
    * getlistLocalSegment() 
    *     
    * Release R3
    */
     public List<SelectOption> getlistLocalSegment(){ 
        try
        {
            return listLocalSegment;   
        }catch(DMLException e){                
                return null;     
        }      
     }
     
    /**   
    * getlistCustAllocation() 
    *     
    * Release R3
    */
     public List<SelectOption> getlistCustAllocation(){ 
        try
        {
            return listCustAllocation;   
        }catch(DMLException e){                
                return null;     
        }      
     }
     
    /**   
    * getlistTypeSalesResource() 
    *     
    * Release R3
    */
     public List<SelectOption> getlistTypeSalesResource(){ 
        try
        {
            return listTypeSalesResource;   
        }catch(DMLException e){                
                return null;     
        }      
     }
    
    
    /**   
    * SaveERP() 
    *     
    * Release R3
    */
    public PageReference SaveERP()
    {
    
        try
        {    
        string countryVal = apexpages.currentpage().getparameters().get(System.Label.System_CL0007);
        string LSOVal = apexpages.currentpage().getparameters().get(System.Label.System_LSOValue);   
        string LBUVal = apexpages.currentpage().getparameters().get(System.Label.System_LBUValue);   
        
        if(strLSOValues != null && strLSOValues != System.Label.System_None_Value )
        {        
            localreferenceData.LSO_ERP_Mapping_Value__c = strLSOValues;        
            localreferenceData.LSO__c = strLSOValues.split( System.Label.System_LSODelimiter)[0];
        }
        
        if(strLBUValues != null && strLBUValues != System.Label.System_None_Value )
        {localreferenceData.LBU__c = strLBUValues;}
        else
        {localreferenceData.LBU__c = null;}
                
        if(strSalDistrict != null && strSalDistrict!= System.Label.System_None_Value )
        {localreferenceData.Sales_District_Text__c = strSalDistrict;}
        else
        {localreferenceData.Sales_District_Text__c = null;}
        
        if(strSalesOffice != null && strSalesOffice != System.Label.System_None_Value )
        {localreferenceData.Sales_Office_Text__c = strSalesOffice;}
        else
        {localreferenceData.Sales_Office_Text__c = null;}
        
        if(strLocalMainBus != null && strLocalMainBus != System.Label.System_None_Value )
        {localreferenceData.Local_Main_Business_Text__c = strLocalMainBus;}
        else
        {localreferenceData.Local_Main_Business_Text__c = null;}
        
        if(strLocalChannel != null && strLocalChannel != System.Label.System_None_Value )
        {localreferenceData.Local_Channel_Text__c = strLocalChannel;}
        else
        {localreferenceData.Local_Channel_Text__c = null;}
        
        if(strLocalSegment != null && strLocalSegment != System.Label.System_None_Value )
        {localreferenceData.Local_Segment_Text__c = strLocalSegment;}
        else
        {localreferenceData.Local_Segment_Text__c = null;}
        
        if(strCustAllocation != null && strCustAllocation!= System.Label.System_None_Value )
        {localreferenceData.Customer_Allocation_Text__c = strCustAllocation;}
        else
        {localreferenceData.Customer_Allocation_Text__c = null;}
        
        if(strTypeSalesResource != null && strTypeSalesResource != System.Label.System_None_Value )
        {localreferenceData.Type_of_Sales_Resources_Text__c = strTypeSalesResource;}
        else
        {localreferenceData.Type_of_Sales_Resources_Text__c = null;}
        
        
        Upsert localreferenceData;
        
        PageReference pageReference = new PageReference(System.Label.System_CL0009+localreferenceData.Id);
        pageReference.setRedirect(true);
        return pageReference;
        }
        catch(System.DMLException e)
        {      
            String strStatusCode = string.valueof(e.getDmlType(0));
            if(strStatusCode == System.Label.System_CL0008 )
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.CL0006));              
            }
            else
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getDmlMessage(0)));
            }
            return null;
        }
        
    }
    
    /**   
    * Method for Cancel :  Cancel button is clicked in VF. It will redirect to List view of Local Reference Data, If user clicks Cancel button  
    *     
    * Release R3
    */    
     public PageReference cancel() {
     
       try
       {
        //getting the key prfix value of Local Reference data
        Schema.DescribeSObjectResult schemaERPObject = ERP_Reference_Data__c.SObjectType.getDescribe();
        String objectIdPrefix = schemaERPObject.getKeyPrefix();
        
        //redirect to the Local Reference data List view         
        String accountId = apexpages.currentpage().getParameters().get(Label.System_CL0006); 
        
        if(accountId != null)
        {
            PageReference pageReference = new PageReference(System.Label.CL0001+accountId );
            pageReference.setRedirect(true);
            return pageReference;  
        }
        
        String EpId = apexpages.currentpage().getParameters().get(Label.System_CL0005);
        if(EpId != null && accountId == null)
        {
           String Accid =  localreferenceData.Account__c;
           if(Accid  != null &&  !String.isBlank(Accid )) 
           {
               PageReference pageReference = new PageReference(System.Label.CL0001+Accid);
               pageReference.setRedirect(true);
               return pageReference;  
           }
           
        }
               
        return null;   
         
        }catch(DMLException e){            
                
                return null;     
        }       
    }      

}
