@isTest
public class APTS_WrapperLODTest {

    private static User user = null;
    public static testMethod void testWrapperLOD1(){
    	user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) { 
            APTS_LP_Local_Customer_Reference_Data__c oLODData = new APTS_LP_Local_Customer_Reference_Data__c();
            APTS_WrapperLOD oWrapperLOD = new APTS_WrapperLOD(oLODData, '','','','','');
        	system.debug('@@ : bIsSelected :' + oWrapperLOD.bIsSelected);
        }
    
    }
    
    public static testMethod void testWrapperLOD2(){
        user  = APTS_LP_TestUtility.getUser();
        System.runAs(user) { 
    
            APTS_LP_TestUtility.getMasterPicklistTableData();
            APTS_LP_TestUtility.getCommonConfigSetting();
            APTS_LP_Local_Customer_Reference_Data__c oLODData = new APTS_LP_Local_Customer_Reference_Data__c();
            oLODData.APTS_LP_Incoterms__c = 'CPT';
            oLODData.APTS_Payment_Terms__c = 'Z004';
            oLODData.APTS_LP_Local_Channel__c = 'P5';
            oLODData.APTS_LP_Distribution_Channel__c = 'BT';
            Set<String> setMPLCodes = new Set<String>();
            setMPLCodes.add('Z004');
            setMPLCodes.add('CPT');
            setMPLCodes.add('P5');
            setMPLCodes.add('BT');
                
            Map<Id, APTS_Master_Picklist_Table__c> mapMPLData = APTS_LP_CommonUtil.getMapOfMPLData(setMPLCodes);
            system.debug('@@ : mapMPLData :' + mapMPLData);
            APTS_WrapperLOD oWrapperLOD = new APTS_WrapperLOD(oLODData,mapMPLData, '','');
            system.debug('@@ : sDistributionChannelId :' + oWrapperLOD.sDistributionChannelId);
        }
    }
}