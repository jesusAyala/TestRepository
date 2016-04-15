@istest (SeeAllData = False)
public class ClsLocalReferenceDataHandlerTest{

    public static Account createTestAccount() 
    {
        Account acc = new Account();    
        acc.Name = 'Test1';
        acc.BillingStreet = 'dajie';
        acc.BillingCity = 'berlin';
        acc.BillingState = 'Berlin';
        acc.BillingPostalCode = '20012';
        acc.BillingCountry = 'Germany';
        return acc;
     }

    Private Static testmethod void ClsLocalReferenceDataHandlerTest(){   
    
        Account Acc = createTestAccount();
        insert Acc;
        
        ERP_Mapping__c erpmp = new ERP_Mapping__c();
        erpmp.Country__c = 'Spain';
        erpmp.Description__c = 'Description';
        erpmp.ERP_ID__c = '001';
        erpmp.LBU__c = 'LBU1';
        erpmp.LSO__c = 'LSO1';
        erpmp.SAP_Distribution_Channel__c = '01';
        erpmp.SAP_Division__c = 'zz';
        erpmp.SAP_Sales_Organization__c = '0001';        
        insert erpmp;
        
        ERP_Reference_Data__c ERP = new ERP_Reference_Data__c();        
        ERP.Account__c = null;
        ERP.Country__c = 'Spain';                       
        ERP.LSO_ERP_Mapping_Value__c = 'LSO-LSO Description';
        ERP.LSO__c = 'LSO'; 
        insert ERP;
        
        RecordType ERPrecType = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'LSO_Field_Entries__c' and DeveloperName = 'LSO_ERP_Picklist_Entries'];
        RecordType recManualrecType = [SELECT Id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'LSO_Field_Entries__c' and DeveloperName = 'LSO_Manual_Picklist_Entries'];
        
        String ManualrecType = recManualrecType.Id;
        
        List<LSO_Field_Entries__c> lstLFE = new List<LSO_Field_Entries__c>();
        
        LSO_Field_Entries__c lfe_dist = new LSO_Field_Entries__c();        
        lfe_dist.Active__c = True;
        lfe_dist.Controlling_Field__c = 'LSO Reference Data.Country';
        lfe_dist.Country__c = 'Spain';
        lfe_dist.LSO_Pick_List_Value_Name__c = 'LSO Reference Data. Sales District';
        lfe_dist.PickList_Code__c = '002';
        lfe_dist.PickList_Description__c = 'SalesDistrict';
        lfe_dist.Value__c = 'Spain';
        lfe_dist.RecordTypeId = ManualrecType;
        lstLFE.Add(lfe_dist);
        
        LSO_Field_Entries__c lfe_sf = new LSO_Field_Entries__c();        
        lfe_sf.Active__c = True;
        lfe_sf.Controlling_Field__c = 'LSO Reference Data.Country';
        lfe_sf.Country__c = 'Spain';
        lfe_sf.LSO_Pick_List_Value_Name__c = 'LSO Reference Data. Sales Office';
        lfe_sf.PickList_Code__c = '001';
        lfe_sf.PickList_Description__c = 'Salesoffice';
        lfe_sf.Value__c = 'Spain';
        lfe_sf.RecordTypeId = ManualrecType;
        lstLFE.Add(lfe_sf);
        
        LSO_Field_Entries__c lfe_lmb = new LSO_Field_Entries__c();        
        lfe_lmb.Active__c = True;
        lfe_lmb.Controlling_Field__c = 'LSO Reference Data.Country';
        lfe_lmb.Country__c = 'Spain';
        lfe_lmb.LSO_Pick_List_Value_Name__c = 'LSO Reference Data. Local Main Business';
        lfe_lmb.PickList_Code__c = '003';
        lfe_lmb.PickList_Description__c = 'Local Main Business';
        lfe_lmb.Value__c = 'Spain';
        lfe_lmb.RecordTypeId = ManualrecType;
        lstLFE.Add(lfe_lmb);
        
        LSO_Field_Entries__c lfe_ls = new LSO_Field_Entries__c();        
        lfe_ls.Active__c = True;
        lfe_ls.Controlling_Field__c = 'LSO Reference Data.Country';
        lfe_ls.Country__c = 'Spain';
        lfe_ls.LSO_Pick_List_Value_Name__c = 'LSO Reference Data. Local Segment';
        lfe_ls.PickList_Code__c = '004';
        lfe_ls.PickList_Description__c = 'Local Segment';
        lfe_ls.Value__c = 'Spain';
        lfe_ls.RecordTypeId = ManualrecType;
        lstLFE.Add(lfe_ls);
        
        LSO_Field_Entries__c lfe_lc = new LSO_Field_Entries__c();        
        lfe_lc.Active__c = True;
        lfe_lc.Controlling_Field__c = 'LSO Reference Data.Country';
        lfe_lc.Country__c = 'Spain';
        lfe_lc.LSO_Pick_List_Value_Name__c = 'LSO Reference Data. Local Channel';
        lfe_lc.PickList_Code__c = '005';
        lfe_lc.PickList_Description__c = 'Lcoal Channel';
        lfe_lc.Value__c = 'Spain';
        lfe_lc.RecordTypeId = ManualrecType;
        lstLFE.Add(lfe_lc);
        
        LSO_Field_Entries__c lfe_ca = new LSO_Field_Entries__c();        
        lfe_ca.Active__c = True;
        lfe_ca.Controlling_Field__c = 'LSO Reference Data.Country';
        lfe_ca.Country__c = 'Spain';
        lfe_ca.LSO_Pick_List_Value_Name__c = 'LSO Reference Data. Customer Allocation';
        lfe_ca.PickList_Code__c = '006';
        lfe_ca.PickList_Description__c = 'Customer Allocation';
        lfe_ca.Value__c = 'Spain';
        lfe_ca.RecordTypeId = ManualrecType;
        lstLFE.Add(lfe_ca);
        
        LSO_Field_Entries__c lfe_sr = new LSO_Field_Entries__c();        
        lfe_sr.Active__c = True;
        lfe_sr.Controlling_Field__c = 'LSO Reference Data.Country';
        lfe_sr.Country__c = 'Spain';
        lfe_sr.LSO_Pick_List_Value_Name__c = 'LSO Reference Data. Types of Sales Resources';
        lfe_sr.PickList_Code__c = '007';
        lfe_sr.PickList_Description__c = 'Sales Resources';
        lfe_sr.Value__c = 'Spain';
        lfe_sr.RecordTypeId = ManualrecType;
        lstLFE.Add(lfe_sr);
        
        
        LSO_Field_Entries__c lfe_dist1 = new LSO_Field_Entries__c();        
        lfe_dist1.Active__c = True;
        lfe_dist1.Controlling_Field__c = 'LSO Reference Data.LBU';
        lfe_dist1.Country__c = 'Spain';
        lfe_dist1.LSO_Pick_List_Value_Name__c = 'LSO Reference Data. Sales District';
        lfe_dist1.PickList_Code__c = '1002';
        lfe_dist1.PickList_Description__c = 'SalesDistrict';
        lfe_dist1.Value__c = 'LBU1';
        lfe_dist1.RecordTypeId = ManualrecType;
        lstLFE.Add(lfe_dist1);
        
        LSO_Field_Entries__c lfe_sf1 = new LSO_Field_Entries__c();        
        lfe_sf1.Active__c = True;
        lfe_sf1.Controlling_Field__c = 'LSO Reference Data.LBU';
        lfe_sf1.Country__c = 'Spain';
        lfe_sf1.LSO_Pick_List_Value_Name__c = 'LSO Reference Data. Sales Office';
        lfe_sf1.PickList_Code__c = '1001';
        lfe_sf1.PickList_Description__c = 'Salesoffice';
        lfe_sf1.Value__c = 'LBU1';
        lfe_sf1.RecordTypeId = ManualrecType;
        lstLFE.Add(lfe_sf1);
        
        LSO_Field_Entries__c lfe_lmb1 = new LSO_Field_Entries__c();        
        lfe_lmb1.Active__c = True;
        lfe_lmb1.Controlling_Field__c = 'LSO Reference Data.LBU';
        lfe_lmb1.Country__c = 'Spain';
        lfe_lmb1.LSO_Pick_List_Value_Name__c = 'LSO Reference Data. Local Main Business';
        lfe_lmb1.PickList_Code__c = '1003';
        lfe_lmb1.PickList_Description__c = 'Local Main Business';
        lfe_lmb1.Value__c = 'LBU1';
        lfe_lmb1.RecordTypeId = ManualrecType;
        lstLFE.Add(lfe_lmb1);
        
        LSO_Field_Entries__c lfe_ls1 = new LSO_Field_Entries__c();        
        lfe_ls1.Active__c = True;
        lfe_ls1.Controlling_Field__c = 'LSO Reference Data.LBU';
        lfe_ls1.Country__c = 'Spain';
        lfe_ls1.LSO_Pick_List_Value_Name__c = 'LSO Reference Data. Local Segment';
        lfe_ls1.PickList_Code__c = '1004';
        lfe_ls1.PickList_Description__c = 'Local Segment';
        lfe_ls1.Value__c = 'LBU1';
        lfe_ls1.RecordTypeId = ManualrecType;
        lstLFE.Add(lfe_ls1);
        
        LSO_Field_Entries__c lfe_lc1 = new LSO_Field_Entries__c();        
        lfe_lc1.Active__c = True;
        lfe_lc1.Controlling_Field__c = 'LSO Reference Data.LBU';
        lfe_lc1.Country__c = 'Spain';
        lfe_lc1.LSO_Pick_List_Value_Name__c = 'LSO Reference Data. Local Channel';
        lfe_lc1.PickList_Code__c = '1005';
        lfe_lc1.PickList_Description__c = 'Lcoal Channel';
        lfe_lc1.Value__c = 'LBU1';
        lfe_lc1.RecordTypeId = ManualrecType;
        lstLFE.Add(lfe_lc1);
        
        LSO_Field_Entries__c lfe_ca1 = new LSO_Field_Entries__c();        
        lfe_ca1.Active__c = True;
        lfe_ca1.Controlling_Field__c = 'LSO Reference Data.LBU';
        lfe_ca1.Country__c = 'Spain';
        lfe_ca1.LSO_Pick_List_Value_Name__c = 'LSO Reference Data. Customer Allocation';
        lfe_ca1.PickList_Code__c = '1006';
        lfe_ca1.PickList_Description__c = 'Customer Allocation';
        lfe_ca1.Value__c = 'Spain';
        lfe_ca1.RecordTypeId = ManualrecType;
        lstLFE.Add(lfe_ca1);
        
        LSO_Field_Entries__c lfe_sr1 = new LSO_Field_Entries__c();        
        lfe_sr1.Active__c = True;
        lfe_sr1.Controlling_Field__c = 'LSO Reference Data.LBU';
        lfe_sr1.Country__c = 'Spain';
        lfe_sr1.LSO_Pick_List_Value_Name__c = 'LSO Reference Data. Types of Sales Resources';
        lfe_sr1.PickList_Code__c = '1007';
        lfe_sr1.PickList_Description__c = 'Sales Resources';
        lfe_sr1.Value__c = 'LBU1';
        lfe_sr1.RecordTypeId = ManualrecType;
        lstLFE.Add(lfe_sr1);
           
        
        LSO_Field_Entries__c lfe_sf2 = new LSO_Field_Entries__c();        
        lfe_sf2.Active__c = True;
        lfe_sf2.Controlling_Field__c = 'LSO Reference Data.District';
        lfe_sf2.Country__c = 'Spain';
        lfe_sf2.LSO_Pick_List_Value_Name__c = 'LSO Reference Data. Sales Office';
        lfe_sf2.PickList_Code__c = '2001';
        lfe_sf2.PickList_Description__c = 'Salesoffice';
        lfe_sf2.Value__c = 'SalesDistrict';
        lfe_sf2.RecordTypeId = ManualrecType;
        lstLFE.Add(lfe_sf2);
        
        List<APTS_Common_Config_Settings__c> aptsCustomSettingList = new List<APTS_Common_Config_Settings__c>();
        APTS_Common_Config_Settings__c aptsCustomSetting1 = new APTS_Common_Config_Settings__c();
        aptsCustomSetting1.Name = 'Global_Record_Type';
        aptsCustomSetting1.APTS_Value__c = 'Global Products';
        aptsCustomSettingList.add(aptsCustomSetting1);
        
        APTS_Common_Config_Settings__c aptsCustomSetting2 = new APTS_Common_Config_Settings__c();
        aptsCustomSetting2.Name = 'LP_USER_DIVISION';
        aptsCustomSetting2.APTS_Value__c = 'LP';
        aptsCustomSettingList.add(aptsCustomSetting2);
        
        APTS_Common_Config_Settings__c aptsCustomSetting3 = new APTS_Common_Config_Settings__c();
        aptsCustomSetting3.Name = 'DEFAULT_SAP_DIVISION';
        aptsCustomSetting3.APTS_Value__c = 'ZZ';
        aptsCustomSettingList.add(aptsCustomSetting3);

        APTS_Common_Config_Settings__c aptsCustomSetting4 = new APTS_Common_Config_Settings__c();
        aptsCustomSetting4.Name = 'SPAIN_LOCALE';
        aptsCustomSetting4.APTS_Value__c = 'es_ES';
        aptsCustomSettingList.add(aptsCustomSetting4);
        
        APTS_Common_Config_Settings__c aptsCustomSetting5 = new APTS_Common_Config_Settings__c();
        aptsCustomSetting5.Name = 'DIVISION';
        aptsCustomSetting5.APTS_Value__c = 'EP';
        aptsCustomSettingList.add(aptsCustomSetting5);
        
        APTS_Common_Config_Settings__c aptsCustomSetting6 = new APTS_Common_Config_Settings__c();
        aptsCustomSetting6.Name = 'APPROVAL_COUNTRY';
        aptsCustomSetting6.APTS_Value__c = 'Spain';
        aptsCustomSettingList.add(aptsCustomSetting6);
        
        insert aptsCustomSettingList;
        insert lstLFE;
        
        ApexPages.currentPage().getParameters().put('id',ERP.Id);               
        ApexPages.StandardController stdLead1 = new ApexPages.StandardController(ERP);
        ClsLocalReferenceDataHandler objController1  = new ClsLocalReferenceDataHandler(stdLead1);
        objController1.cancel();        
         ApexPages.currentPage().getParameters().put('accid', Acc.Id);
        objController1.getlistLSO();
        ApexPages.currentPage().getParameters().put('countryValue','Spain');
        ApexPages.currentPage().getParameters().put('LSOValue','LSO1 :: Description');
        objController1.getlistLBU();
        
        objController1.getlistTypeSalesResource();
        objController1.getlistCustAllocation();
        objController1.getlistLocalSegment();
        objController1.getlistLocalChannel();
        objController1.getlistLocalMainBus();        
        ApexPages.currentPage().getParameters().put('DisValue', 'SalesDistrict');
        objController1.getlistSalDistrict();
        objController1.getlistSalesOffice();
        objController1.loadPickLists_Country ('Spain');
        objController1.loadPickLists (True, False, False, 'Spain' , '', '');
        objController1.loadPickLists (False, True, False, 'Spain' , 'LBU1', '');
        objController1.loadPickLists (False, False, True, 'Spain' , 'LBU1', 'SalesDistrict');

                      
        ApexPages.StandardController stdLead = new ApexPages.StandardController(ERP);
        ClsLocalReferenceDataHandler objController  = new ClsLocalReferenceDataHandler(stdLead);
        objController.cancel();        
        ApexPages.currentPage().getParameters().put('accid',Acc.Id); 
        objController.cancel(); 
        objController.getlistLSO();
        ApexPages.currentPage().getParameters().put('countryValue','Spain');
        ApexPages.currentPage().getParameters().put('LSOValue','LSO1 :: Description');
        objController.getlistLBU();
        
        objController.getlistTypeSalesResource();
        objController.getlistCustAllocation();
        objController.getlistLocalSegment();
        objController.getlistLocalChannel();
        objController.getlistLocalMainBus();        
        ApexPages.currentPage().getParameters().put('DisValue', 'SalesDistrict');
        objController.getlistSalDistrict();
        objController.getlistSalesOffice();
        objController.loadPickLists_Country ('Spain');
        objController.loadPickLists (True, False, False, 'Spain' , '', '');
        objController.loadPickLists (False, True, False, 'Spain' , 'LBU1', '');
        objController.loadPickLists (False, False, True, 'Spain' , 'LBU1', 'SalesDistrict');        
        objController.SaveERP();
        
        
    }
}