/*************************************************************
@Name: APTS_RefreshAccountCustomerProcessor
@Author: Niket Chandane
@CreateDate: 11-03-2015
@Description: Class to read URL parameters and fetch and set relevant Apttus LSO data 
@UsedBy: controller - APTS_RefreshAccountCustomerInfoCntrl
******************************************************************/
public with sharing class APTS_RefreshAccountCustomerProcessor {
	
	// Parameters for value selection on page
    private String guid {get; set;}
    private String baseObject {get; set;}
    private String accountName {get; set;}
    private String accountType {get; set;}
    private String quoteId {get; set;}
    private String agreementId {get; set;}
    private String userDivision {get; set;}
    private String defaultLBU {get; set;}
    private String defaultLSO {get; set;}
    private String locale {get; set;}
    private string accountId {get; set;}
	
	private Map<String, Map<String, String>> lsoCodeDescriptionMap = new Map<String, Map<String, String>>();
    private Map<String, Map<String, String>> lsoCodeDescriptionIdMap = new Map<String, Map<String, String>>();
	private APTS_RefreshAccountCustomerInfoCntrl controller;
    private List<APTS_LP_Local_Customer_Reference_Data__c> listLODData;
    
    
    /**
     * Constructor to initialize the object.
     */
    public APTS_RefreshAccountCustomerProcessor(APTS_RefreshAccountCustomerInfoCntrl controller) {
        this.controller = controller;
    }
	
	 /**
     * Method processing data and getting LOD
     */
	public List<APTS_LP_Local_Customer_Reference_Data__c> processDatatoSearchLOD(Map<String, String> dataMap){
		listLODData = new List<APTS_LP_Local_Customer_Reference_Data__c>();
		
    	try{
    		// Populate data from MAP
        	setVariablesFromDataMap(dataMap);
        	
        	String sAccountId = dataMap.get('accountId');
        	String sUserCountryCode = [select Country,CountryCode from user where id=:UserInfo.getUserId()].CountryCode;
        	
        	system.debug('@@@ accountId --- Country Code : '+sAccountId +'==='+ sUserCountryCode);
        	
        	// Get Filtered LOD Records as per Distribution Channel
        	this.controller.listUniqWrapperLOD = getAccountLODDataForRefresh(sAccountId, sUserCountryCode);
        	
        	system.debug('@@@ listUniqWrapperLOD : '+JSON.serialize(this.controller.listUniqWrapperLOD));
        	if(this.controller.listUniqWrapperLOD!=null && this.controller.listUniqWrapperLOD.size()>0){
        	    for(APTS_WrapperLOD wrapper:this.controller.listUniqWrapperLOD){
        	        listLODData.add(wrapper.LSOData);
        	    }
        	}
        	
    	}catch(Exception ex){
    		controller.addErrorMessage('Error while fetching LOD Data. Please check if data is existing.'+ex.getMessage());
    	}
    	system.debug('@@@ listLODData : '+listLODData);
    	return listLODData;
    }
	
	public String getMasterPickListCodeDesc(String code, String codeUsedFor){
        
        
        if(lsoCodeDescriptionMap == null || lsoCodeDescriptionMap.get(codeUsedFor) == null) {
            return APTS_CaptureInputForLSODataConstants.NO_DESC_AVAILABLE;
        }
        
        String description = lsoCodeDescriptionMap.get(codeUsedFor).get(code);
        return ((description != null && description.length() > 0) ? description : APTS_CaptureInputForLSODataConstants.NO_DESC_AVAILABLE);
        
        
    }
	
	/**
     * Method to set the values of variables from the data map.
     */
    private void setVariablesFromDataMap(Map<String, String> dataMap) {
        
        guid = dataMap.get('guid');
        baseObject = dataMap.get('baseObject');
        accountName = dataMap.get('name');
        accountType = dataMap.get('accountType');
        quoteId = dataMap.get('quoteId');
        agreementId = dataMap.get('agreementId'); 
        defaultLBU = dataMap.get('defaultLBU');
        defaultLSO = dataMap.get('defaultLSO');
        locale = dataMap.get('locale');
        accountId = dataMap.get('accountId');
    }
    
    
    public String getCodeDescriptionIdForLSOCode(String code, String codeUsedFor) {
        
        if(String.isBlank(code)) {
            return null;
        }
        
        if(lsoCodeDescriptionIdMap == null || lsoCodeDescriptionIdMap.get(codeUsedFor) == null) {
            return null;
        }
        
        return lsoCodeDescriptionIdMap.get(codeUsedFor).get(code);
    }
    
    /*
     * Description: Method to get LOD Records and Filter it as per Distribution channel in Quotation / Agreement
     * Owner: Jignesh Shekhaliya
     * Created Date: 04-Feb-2016
    */
    private List<APTS_WrapperLOD> getAccountLODDataForRefresh(string sAccountId, String sUserCountryCode){
        List<APTS_WrapperLOD> listAccLODFiltered = new List<APTS_WrapperLOD>();
        List<APTS_WrapperLOD> listAccLOD = APTS_LRDLODUtility.findMatchingLODRecordsForRefresh(sAccountId,this.controller,sUserCountryCode);
        
        // Filter LOD records based on Distribution Channel in Quote
        if(this.controller.quote.APTS_Distribution_Channel__c != null){
            for(APTS_WrapperLOD oLodRecord:listAccLOD){
                if(this.controller.quote.APTS_Distribution_Channel__c == oLodRecord.sDistributionChannelId){
                    listAccLODFiltered.add(oLodRecord);
                }
            }
        }
        
        // Filter LOD records based on Distribution Channel in Agreement
        if(this.controller.agreement.APTS_Distribution_Channel__c != null){
            for(APTS_WrapperLOD oLodRecord:listAccLOD){
                if(this.controller.agreement.APTS_Distribution_Channel__c == oLodRecord.sDistributionChannelId){
                    listAccLODFiltered.add(oLodRecord);
                }
            }
        }
        return listAccLODFiltered;
    }
}