/*************************************************************
@Name: APTS_LP_CommonUtil
@Author: Hardik Shah
@CreateDate: 17 Sep 2015
@Description: This class continas utility functions that are common across LP-Specific Code.
@UsedBy: Many Classes and Triggers
******************************************************************
@ModifiedBy: Author who modified this process.
@ModifiedDate: Date the process was modified.
@ChangeDescription: A brief description of what was modified. */

public class APTS_LP_CommonUtil {
    
    
    /*
     * @Description: Prepare map of Sales Office From LSO Field Entry Object
     * @Owner: Jignesh Shekhaliya
     * @CreateDate: 12-Dec-2015
    */
    public static Map<Id, APTS_Master_Picklist_Table__c> getMapOfMPLData(set<String> setMPLCodes){
        
        Map<Id, APTS_Master_Picklist_Table__c> mapMPLRecords = new Map<Id, APTS_Master_Picklist_Table__c>([ SELECT ID, Name, APTS_Code__c, 
                                                                                                                APTS_Code_Description__c, 
                                                                                                                APTS_Code_Used_For__c,
                                                                                                                APTS_Country__c,
                                                                                                                APTS_Locale__c
                                                                                                             FROM APTS_Master_Picklist_Table__c
                                                                                                             WHERE APTS_Code__c IN : setMPLCodes
                                                                                                                AND APTS_Locale__c =: UserInfo.getLocale()
                                                                                                           ]);
        return mapMPLRecords;
    }
    
    /*
     * @Description: Get Sales Office record based on Sales Office Code
     * @Owner: Jignesh Shekhaliya
     * @CreateDate: 12-Dec-2015
    */
    public Static APTS_Master_Picklist_Table__c getMPLRecord(map<Id, APTS_Master_Picklist_Table__c> mapMPLData, String sMPLCode, String sUsedFor){
        for(APTS_Master_Picklist_Table__c oMPL : mapMPLData.values()){
            if(oMPL.APTS_Code__c == sMPLCode && oMPL.APTS_Code_Used_For__c == sUsedFor && oMPL.APTS_Locale__c == UserInfo.getLocale()){
                return oMPL;
            }
        }
        return null;
    }
    
    
    /*
     * @Description: Prepare map of Sales Office From LSO Field Entry Object
     * @Owner: Jignesh Shekhaliya
    */
    public static Map<String, LSO_Field_Entries__c> getMapOfSalesOfficeFromLSO(set<String> setSalesOffice){
        
        Map<String, LSO_Field_Entries__c> mapLSOSalesOffice = new Map<String, LSO_Field_Entries__c>();
        if(setSalesOffice != null && setSalesOffice.size() > 0){
            //Id lsoRecordTypeId = '';
            Id lsoRecordTypeId;
            List<RecordType> listRecordType = [Select Id, Name From RecordType  Where SobjectType = 'LSO_Field_Entries__c' AND Name = 'LSO ERP Picklist Entries'];
            if(listRecordType.size() > 0){
                lsoRecordTypeId = listRecordType[0].Id;
            }
            for(LSO_Field_Entries__c oLSOSalesOffice: [ SELECT Id, PickList_Code__c, PickList_Description__c, Country__c FROM LSO_Field_Entries__c
                                                        WHERE PickList_Code__c IN : setSalesOffice
                                                        AND RecordTypeId =: lsoRecordTypeId
                                                      ]
                ){
                mapLSOSalesOffice.put(oLSOSalesOffice.PickList_Code__c, oLSOSalesOffice);
            }
        }
        return mapLSOSalesOffice;
    }
    
    /*
     * @Description: Get Sales Office record based on Sales Office Code
     * @Owner: Jignesh Shekhaliya
    */
    public Static LSO_Field_Entries__c getLSOSalesOffice(map<String, LSO_Field_Entries__c> mapLSOSalesOffice, String sSalesOfficeCode, String sCountry){
        LSO_Field_Entries__c oSalesOfficeLSO = mapLSOSalesOffice.get(sSalesOfficeCode);
        for(LSO_Field_Entries__c oSalesOffice : mapLSOSalesOffice.values()){
            if(oSalesOffice.PickList_Code__c == sSalesOfficeCode && oSalesOffice.Country__c == sCountry){
                oSalesOfficeLSO = oSalesOffice;
            }
        }
        
        return oSalesOfficeLSO;
    }
    
    /*
     * @Description: Get All Sales Office record from Master Pick List Table object
     * @Owner: Jignesh Shekhaliya
     * @date: 27-Nov-2015
    */
    public Static Map<Id, APTS_Master_Picklist_Table__c> getMPLSalesOffice(){
        
        map<Id,APTS_Master_Picklist_Table__c> mapMPLSalesOffice = new Map<Id, APTS_Master_Picklist_Table__c>([  SELECT ID, Name, APTS_Code__c, APTS_Code_Description__c, 
                                                                                                                APTS_Code_Used_For__c,
                                                                                                                APTS_Country__c
                                                                                                                FROM APTS_Master_Picklist_Table__c 
                                                                                                                WHERE APTS_Code_Used_For__c = 'Sales Office'
                                                                                                             ]);
        return mapMPLSalesOffice;
    }
    
    
    /*
     * @Description: Get Sales Office record based on Sales Office Description from Master Pick List Table object
     * @Owner: Jignesh Shekhaliya
    */
    public Static APTS_Master_Picklist_Table__c getMPLSalesOffice(String sSalesOfficeDesc, String sCountry){
        
        List<APTS_Master_Picklist_Table__c> listMPLSalesOffice = [  SELECT ID, Name, APTS_Code__c, APTS_Code_Description__c, APTS_Code_Used_For__c
                                                                    FROM APTS_Master_Picklist_Table__c 
                                                                    WHERE APTS_Code_Description__c =: sSalesOfficeDesc And APTS_Country__c = : sCountry
                                                                 ];
        if(listMPLSalesOffice != null && listMPLSalesOffice.size() > 0){
            return listMPLSalesOffice[0];
        }
        return null;
    }
    
    /*
    * Added by Axay: to check whether the sales Office found in LSO_Field_Entries__c object or not.
    */
    
    public Static String getSalesOfficeExistInLSOFields(String salesOffice, String country){

        //Id lsoRecordTypeId = '';
        Id lsoRecordTypeId;
        List<RecordType> listRecordType = [Select Id, Name From RecordType  Where SobjectType = 'LSO_Field_Entries__c' AND Name = 'LSO ERP Picklist Entries'];
        if(listRecordType.size() > 0){
            lsoRecordTypeId = listRecordType[0].Id;
        }
        
        List<LSO_Field_Entries__c> lstLSOFieldsEntry = [SELECT Id 
                                                        FROM LSO_Field_Entries__c 
                                                        WHERE PickList_Description__c = :salesOffice
                                                        AND Country__c = :country
                                                        AND RecordTypeId =: lsoRecordTypeId
                                                       ];
                                                        
        if(lstLSOFieldsEntry.size() > 0){
            return lstLSOFieldsEntry[0].Id;
        }
        
        return null;
    }
    
    /**
     *  This method creates a Map of agreement that has MSPA-Type Specific to LP-Spain 
     *  @Added-By : Hardik Shah
     *  @Date : 23 Sep 2015
     */

    public static Map < Id, Apttus__APTS_Agreement__c > isApplicableFOrLP(Map < Id, Apttus__APTS_Agreement__c > mapNewAgreement) {

        Map < Id, Apttus__APTS_Agreement__c > mapAgrForLPSpain = new Map < Id, Apttus__APTS_Agreement__c > ();
        // Loop over the new Agreement
        for (Apttus__APTS_Agreement__c oAgreement: mapNewAgreement.values()) {
            // Fetch only those Agreement which has MSPA-Type as LP Spain - Project MSPA or LP Spain - Project MSPA RO
            if (String.isNotBlank(oAgreement.APTS_LP_MSPA_Type__c) && (APTS_Constants.MSPA_TYPE.equals(oAgreement.APTS_LP_MSPA_Type__c))) {
                mapAgrForLPSpain.put(oAgreement.id, oAgreement);
            }
        }
        return mapAgrForLPSpain;
    }

    /**
     *  This method creates a List of agreement that has MSPA-Type Specific to LP-Spain 
     *  @Added-By : Hardik Shah
     *  @Date : 23 Sep 2015
     */

    public static List < Apttus__APTS_Agreement__c > isApplicableFOrLP(List < Apttus__APTS_Agreement__c > listNewAgreement) {

        List < Apttus__APTS_Agreement__c > listAgrForLPSpain = new List < Apttus__APTS_Agreement__c > ();
        // Loop over the new Agreement
        for (Apttus__APTS_Agreement__c oAgreement: listNewAgreement) {
            // Fetch only those Agreement which has MSPA-Type as LP Spain - Project MSPA or LP Spain - Project MSPA RO
            if (String.isNotBlank(oAgreement.APTS_LP_MSPA_Type__c) && (APTS_Constants.MSPA_TYPE.equals(oAgreement.APTS_LP_MSPA_Type__c))) {
                listAgrForLPSpain.add(oAgreement);
            }
        }
        return listAgrForLPSpain;
    }

    public static Map < Id, Apttus_Proposal__Proposal__c > isProposalApplicableFOrLP(Map < Id, Apttus_Proposal__Proposal__c > mapNewProposal) {

        Map < Id, Apttus_Proposal__Proposal__c > mapProposalForLPSpain = new Map < Id, Apttus_Proposal__Proposal__c > ();
        // Loop over the new Agreement
        for (Apttus_Proposal__Proposal__c oProposal: mapNewProposal.values()) {

            // Fetch only those Agreement which has MSPA-Type as LP Spain - Project MSPA or LP Spain - Project MSPA RO
            if (String.isNotBlank(oProposal.APTS_QuotationType__c) && (APTS_Constants.PROPOSAL_TYPE.equals(oProposal.APTS_QuotationType__c))) {
                mapProposalForLPSpain.put(oProposal.id, oProposal);
            }
        }
        return mapProposalForLPSpain;
    }

    /**
     *  This method creates a List of Proposals that has Proposal-Type Specific to LP-Spain 
     *  @Added-By : Hardik Shah
     *  @Date : 23 Sep 2015
     */

    public static List < Apttus_Proposal__Proposal__c > isProposalApplicableFOrLP(List < Apttus_Proposal__Proposal__c > listProposal) {

        List < Apttus_Proposal__Proposal__c > listProposalForLPSpain = new List < Apttus_Proposal__Proposal__c > ();
        // Loop over the new Agreement
        for (Apttus_Proposal__Proposal__c oProposal: listProposal) {
            // Fetch only those Agreement which has MSPA-Type as LP Spain - Project MSPA or LP Spain - Project MSPA RO

            if (String.isNotBlank(oProposal.APTS_QuotationType__c) && string.isnotblank(APTS_Constants.PROPOSAL_TYPE) && (APTS_Constants.PROPOSAL_TYPE.equals(oProposal.APTS_QuotationType__c))) {
                listProposalForLPSpain.add(oProposal);
            }
        }
        return listProposalForLPSpain;
    }
}