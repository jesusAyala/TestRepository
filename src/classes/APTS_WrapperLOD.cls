/*
    @Description: This is a Wrapper Class used for displaying LOD records on the LOD selection page.
    @Owner: Jignesh Shekhaliya(Apttus)
    @Created Date: 12-Dec-2015
*/
public class APTS_WrapperLOD{
    public integer iRecordId{get;set;}
    public APTS_LP_Local_Customer_Reference_Data__c LSOData  {get; set;}
    public String descDistributionChannel {get; set;}
    public String descIncoterm {get; set;}
    public String descPaymentTerm {get; set;}
    public String descLocalChannel {get; set;}
    public String salesOffice {get;set;}
    public String lbu {get;set;}
    public boolean bIsSelected {get; set;}
    public String sDistributionChannelId {get; set;}
    public String sPaymentTermId {get; set;}
    public String sLocalChannelId {get; set;}
    public String sIncotermId {get; set;}
    
    // Default constructor
    public APTS_WrapperLOD(){
        
    }
    
    public APTS_WrapperLOD(APTS_LP_Local_Customer_Reference_Data__c LSOData, string descIncoterm,string descPaymentTerm,string descLocalChannel, string sSalesOffice, string lbu){
        
        this.LSOData = LSOData;
        this.descIncoterm = descIncoterm;
        this.descPaymentTerm = descPaymentTerm;
        this.descLocalChannel = descLocalChannel;
        this.salesOffice = sSalesOffice;
        this.lbu = lbu;
        this.bIsSelected = false;
        
    }
    
    public APTS_WrapperLOD(APTS_LP_Local_Customer_Reference_Data__c oLODRecord, Map<Id, APTS_Master_Picklist_Table__c> mapMPLData, string sSalesOffice, string lbu){
        
        APTS_Master_Picklist_Table__c oMPLRecord;
        oMPLRecord = APTS_LP_CommonUtil.getMPLRecord(mapMPLData, oLODRecord.APTS_LP_Incoterms__c, APTS_CaptureInputForLSODataConstants.INCOTERM);
        if(oMPLRecord != null){        
            String descIncoterm  = oMPLRecord.APTS_Code_Description__c; 
            this.descIncoterm = descIncoterm;
            this.sIncotermId = oMPLRecord.id;
        }
        
        oMPLRecord = APTS_LP_CommonUtil.getMPLRecord(mapMPLData, oLODRecord.APTS_Payment_Terms__c, APTS_CaptureInputForLSODataConstants.PAYMENT_TERM);
        if(oMPLRecord != null){
            String descPaymentTerm  = oMPLRecord.APTS_Code_Description__c;
            this.descPaymentTerm = descPaymentTerm;
            this.sPaymentTermId = oMPLRecord.id;
        }
        
        oMPLRecord = APTS_LP_CommonUtil.getMPLRecord(mapMPLData, oLODRecord.APTS_LP_Local_Channel__c, APTS_CaptureInputForLSODataConstants.LOCAL_CHANNEL);
        if(oMPLRecord != null){
            String descLocalChannel  = oMPLRecord.APTS_Code_Description__c;
            this.descLocalChannel = descLocalChannel;
            this.sLocalChannelId = oMPLRecord.id;
        }
        
        oMPLRecord = APTS_LP_CommonUtil.getMPLRecord(mapMPLData, oLODRecord.APTS_LP_Distribution_Channel__c, APTS_CaptureInputForLSODataConstants.DISTRIBUTION_CHANNEL);
        if(oMPLRecord != null){
            system.debug('@@ : oLODRecord.APTS_LP_Distribution_Channel__c :' + oLODRecord.APTS_LP_Distribution_Channel__c);
            String descDistributionChannel  = oMPLRecord.APTS_Code_Description__c;
            this.descDistributionChannel = descDistributionChannel;
            this.sDistributionChannelId = oMPLRecord.id;
            system.debug('@@ : sDistributionChannelId :' + sDistributionChannelId);
        }
        
        
                        
        this.LSOData = oLODRecord;
        this.salesOffice = sSalesOffice;
        this.lbu = lbu;
        this.bIsSelected = false;
        
    }
}