/*************************************************************
@Name: APTS_LP_QueryUtility
@Author: Hardik Shah
@CreateDate: 23/08/2015
@Description: Utility class for fetching SQl queries
@UsedBy: APTS_ProposalTriggerHelper,APTS_ProductConfigurationTriggerHelper,APTS_AgreementTriggerHelper,APTS_LP_AgreementLineItemController
******************************************************************
@ModifiedBy: NA
@ModifiedDate: NA
@ChangeDescription: A brief description of what was modified.
**** PS: @ModifiedBy and @ChangeDescription can be repeated multiple time, based on number of changes made to the original process.
******************************************************************/


public class APTS_LP_QueryUtility {
    
    // This method return list of Agreement (only one) if exists, Otherwise return null
    public static List<Apttus__APTS_Agreement__c> getAgreement(Id agreementId){
        
       List<Apttus__APTS_Agreement__c> listAgreement = null;
           
        if(agreementId != null && String.isNotBlank(agreementId)){
            /*axay:uncomment it!
            listAgreement = [select Id, Name,APTS_LP_MSPA_title__c,APTS_LP_AccountCustomer__r.Name,APTS_LP_Sales_organization__c,
                                    APTS_Distribution_Channel__r.APTS_Code__c,APTS_Sales_Office__c,APTS_LP_Max_Order_Amount__c,
                                    APTS_LP_Residual_Amount__c,APTS_LP_Sales_Person__r.Name,APTS_LP_Price_Date__c,
                                    APTS_LP_Account_End_User__c,Apttus_CMConfig__PriceListId__c,APTS_LP_MSPA_Type__c,
                                    Apttus_Approval__Approval_Status__c,Apttus__Related_Opportunity__c,Apttus__Contract_Start_Date__c,
                                    Apttus__Status_Category__c,Apttus__Contract_End_Date__c,OwnerId,Apttus__Description__c,Apttus__Status__c
                                    from Apttus__APTS_Agreement__c where ID=:agreementId Limit 1];   
            */
            return listAgreement;
        }else{
            
            return null;
        }
    }
    
   
    
    // This method return list of AgreementLineItem if exists, Otherwise return null
    public static List<Apttus__AgreementLineItem__c> getAgreementLineItemList(Id agreementId){
        
       List<Apttus__AgreementLineItem__c> listAgreementLineItem = null;
           
        if(agreementId != null && String.isNotBlank(agreementId)){
            
            listAgreementLineItem = [select Id, Name,Apttus__Description__c,Apttus_CMConfig__ChargeType__c,Apttus__ProductId__r.Name,
                                            Apttus_CMConfig__Frequency__c,Apttus_CMConfig__PriceUom__c,Apttus_CMConfig__SellingFrequency__c,
                                            Apttus__Quantity__c,Apttus_CMConfig__BaseExtendedPrice__c,Apttus__NetPrice__c
                                            from Apttus__AgreementLineItem__c where Apttus__AgreementId__c =:agreementId];
            return listAgreementLineItem;
        }else{
            
            return null;
        }
    }
    
    // This method return list of ProductConfiguration
    public static List<Apttus_Config2__ProductConfiguration__c> getProductConfiguration (Set<String> setProductConfig) {
        
         List <Apttus_Config2__ProductConfiguration__c> oConfigList = new List<Apttus_Config2__ProductConfiguration__c>();
       
            if(setProductConfig != null && setProductConfig.size() > 0){
                
                oConfigList =  [Select Id,Apttus_CMConfig__AgreementId__c,Apttus_QPConfig__Proposald__c,
                                Apttus_QPConfig__Proposald__r.APTS_QuotationType__c,
                                Apttus_QPConfig__Proposald__r.APTS_LP_Local_Channel__c,
                                Apttus_QPConfig__Proposald__r.APTS_Sales_Office__c,
                                Apttus_QPConfig__Proposald__r.APTS_Incoterms__c,
                                
                                Apttus_QPConfig__Proposald__r.APTS_Distribution_Channel__r.APTS_Code__c,
                                Apttus_QPConfig__Proposald__r.APTS_Local_Channel__c,
                                Apttus_QPConfig__Proposald__r.APTS_Local_Channel__r.APTS_Code__c,
                                Apttus_QPConfig__Proposald__r.APTS_Payment_Terms__r.APTS_Code__c,
                                Apttus_QPConfig__Proposald__r.APTS_Sales_Office__r.PickList_Code__c,
                                Apttus_QPConfig__Proposald__r.APTS_Incoterms__r.APTS_Code__c,
                                Apttus_QPConfig__Proposald__r.APTS_LP_MaximumSubstituteDiscount__c,
                                Apttus_QPConfig__Proposald__r.APTS_Country__c,
                                Apttus_QPConfig__Proposald__r.APTS_LP_Sales_Organization__c,
                                
                                
                                Apttus_CMConfig__AgreementId__r.APTS_LP_MSPA_Type__c,
                                Apttus_CMConfig__AgreementId__r.APTS_Local_Channel__c,
                                Apttus_CMConfig__AgreementId__r.APTS_Local_Channel__r.APTS_Code__c,
                                Apttus_CMConfig__AgreementId__r.APTS_Sales_Office__r.PickList_Code__c,
                                Apttus_CMConfig__AgreementId__r.APTS_Country__c,
                                Apttus_CMConfig__AgreementId__r.APTS_LP_Sales_Organization__c,
                                
                                       (Select Id,name,Apttus_Config2__NetAdjustmentPercent__c,
                                       Apttus_Config2__AdjustmentAmount__c,Apttus_Config2__AdjustmentType__c,
                                       Apttus_Config2__ListPrice__c,Apttus_Config2__ProductId__r.APTS_LP_Product_Hierarchy__c,
                                       Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__c,
                                       Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c,
                                       Apttus_Config2__ProductId__r.APTS_GTV_Level__c,Apttus_Config2__ProductId__r.APTS_Hierarchy_Level_3_Code__c,APTS_Line_Item_Discount__c
                                       from Apttus_Config2__LineItems__r) 
                                       from Apttus_Config2__ProductConfiguration__c where Id IN :setProductConfig];
                
                return oConfigList;        
            }else{
                
                return oConfigList;
            }
        
    }
    
    // This method returns priceList
    public static List<Apttus_Config2__PriceList__c> getPriceList() {
        List<Apttus_Config2__PriceList__c> listPrice = [select Id,APTS_Country__c,CurrencyISOCode from Apttus_Config2__PriceList__c];
        return listPrice;
    }
    
    // Return a Maps of Account Object with given set of Acc-id
    public static Map<id, Account> getAccount(Set<String> setCustomId){
        Map<id, Account> mapAcc = null;
        if(setCustomId != null && setCustomId.size() > 0){
                mapAcc = new Map<id, Account> ([select Primary_Address_Country__c from Account where Id IN :setCustomId]);
        
        }return mapAcc;
       
    }
    // Return a Maps of User Object with given set of salesPerson-id in Agreement record
     public static Map<id, User> getUser(Set<String> setSalesID){
        Map<id, User> mapUser = null;
        if(setSalesID != null && setSalesID.size() > 0){
            mapUser = new Map<id, User>([select Country from User where Id IN :setSalesID]);
        }return mapUser;
       
    }   
    
    // checks whether logged-in user has division field set to lp
    public static Boolean isUserDivisionLP(){
        List<User> listCurrentUser=[Select Division from User where Id=:userinfo.getuserId() AND Division =:APTS_Constants.LP_USER_DIVISION limit 1];
        if(listCurrentUser != null && listCurrentUser.size() > 0 &&  listCurrentUser[0] != null && listCurrentUser[0].Division != null 
                                   && listCurrentUser[0].Division.equalsIgnoreCase(APTS_Constants.LP_USER_DIVISION)) {
            
            return true;
        }
        else{
            
            return false;
        }
    }
    
    /**
     * Method to get the sales office code for the user based on his locale using his sales territory name.
     */
    public static String getUserSalesOfficeCode() {
        String sUserSalesTerritory = null;
        String sUserLocale = null;
        String sUserId = UserInfo.getUserId();
        String sSalesOffice = APTS_Constants.SALES_OFFICE;
        
        // Fetching user details.
        String sUserDetailsQuery = 'SELECT LocaleSidKey, Sales_Territory_Name__c FROM User WHERE id = :sUserId';
        User oLoggedInUser = Database.query(sUserDetailsQuery);
        
        if(oLoggedInUser == null) {
            return null;
        }
        
        sUserSalesTerritory = oLoggedInUser.Sales_Territory_Name__c;
        sUserLocale = oLoggedInUser.LocaleSidKey;
        
        // Fetching sales office code.
        String sQuery = 'SELECT APTS_Code__c  FROM APTS_Master_Picklist_Table__c  WHERE APTS_Code_Description__c = :sUserSalesTerritory  AND APTS_Locale__c = :sUserLocale  AND APTS_Code_Used_For__c = :sSalesOffice';
        List<APTS_Master_Picklist_Table__c> listMasterData = Database.query(sQuery);
        
        if(listMasterData != null && listMasterData.size() > 0) {
            return listMasterData[0].APTS_Code__c;
        } else {
            return null;
        }
    }
    
    /*
     * @Description: Get Defaul Local Channel
     * @Owner: Jignesh Shekhaliya
     * @Created Date: 11-Nov-2015
    */
    public static String getDefaultLocalChannel(){
        string sLocalChannel='';
        List<APTS_Master_Picklist_Table__c> listMPT = [ SELECT Id 
                                                                    FROM APTS_Master_Picklist_Table__c 
                                                                    WHERE 
                                                                        APTS_Code_Used_For__c = 'Local Channel' 
                                                                        AND APTS_Locale__c =: UserInfo.getLocale() 
                                                                        AND APTS_Code__c = 'P5'
                                                                  ];
        if(listMPT != null && listMPT.size() > 0){
            sLocalChannel = listMPT[0].Id;
        }
        return sLocalChannel;
    }
    
    /*
     * @Description: Get Defaul Distribution Channel
     * @Owner: Jignesh Shekhaliya
     * @Created Date: 11-Nov-2015
    */
    public static String getDefaultDistributionChannel(){
        string sLocalChannel='';
        List<APTS_Master_Picklist_Table__c> listMPT = [ SELECT Id 
                                                        FROM APTS_Master_Picklist_Table__c 
                                                        WHERE 
                                                            APTS_Code_Used_For__c = 'Distribution Channel' 
                                                            AND APTS_Locale__c =: UserInfo.getLocale() 
                                                            AND APTS_Code__c = 'BT'
                                                      ];
        if(listMPT != null && listMPT.size() > 0){
            sLocalChannel = listMPT[0].Id;
        }
        return sLocalChannel;
    }
    
    /*
     *  @Description: Validate that atleast one Discount config should be found.
     *  @Owner: Jignesh Shekhaliya
    */
    public static map<Id, APTS_Discounts_Config__c> getValidateDiscountConfig(String sRecordType){
        system.debug('<<<< Record Type >>>>'+ sRecordType);
        map<Id, APTS_Discounts_Config__c> mapDiscountConfig = new map<id, APTS_Discounts_Config__c>( [  SELECT Id, Name, APTS_Local_Channel__c,
                                                                                                            APTS_Additional_Discount__c, 
                                                                                                            APTS_Net_Discount__c, 
                                                                                                            APTS_Hierarchy_Level__c, 
                                                                                                            APTS_Substitute_Discount__c, 
                                                                                                            APTS_Additional_Discounts_Hierarchy__c, 
                                                                                                            APTS_Net_Discount_Hierarchy__c, 
                                                                                                            APTS_Substitutional_Discounts_Hierarchy__c
                                                                                                        FROM APTS_Discounts_Config__c 
                                                                                                        WHERE APTS_IsActive__c = TRUE 
                                                                                                            AND APTS_Quote_Record_Type__c =: sRecordType
                                                                                                     ]
                                                                                                    );
        return mapDiscountConfig;
    }
    
    
    /*
     *  @Description: Validate that atleast one Discount config should be found.
     *  @Owner: Jignesh Shekhaliya
    */
    public static map<Id, APTS_Discounts_Config__c> getAgreementDiscountConfig(String sRecordType){
        map<Id, APTS_Discounts_Config__c> mapDiscountConfig = new map<id, APTS_Discounts_Config__c>( [  SELECT Id, Name, APTS_Local_Channel__c,
                                                                                                            APTS_Additional_Discount__c, 
                                                                                                            APTS_Net_Discount__c, 
                                                                                                            APTS_Hierarchy_Level__c,
                                                                                                            APTS_Hierarchy_Level_MS__c, 
                                                                                                            APTS_Substitute_Discount__c, 
                                                                                                            APTS_Additional_Discounts_Hierarchy__c, 
                                                                                                            APTS_Net_Discount_Hierarchy__c, 
                                                                                                            APTS_Substitutional_Discounts_Hierarchy__c
                                                                                                        FROM APTS_Discounts_Config__c 
                                                                                                        WHERE APTS_IsActive__c = TRUE 
                                                                                                            AND APTS_Record_Type__c =: sRecordType
                                                                                                     ]
                                                                                                    );
        return mapDiscountConfig;
    }
    
    /*
     * @Description: Validate input while updating code.
     * @Owner: Jignesh Shekhaliya
    */
    public static Boolean validateQuotationData(String sLocalChannelId, map<Id, APTS_Discounts_Config__c> mapDiscountConfig){
        Boolean iFoundCount = false;
        system.debug('Validation Local Channel : >>>>' + sLocalChannelId);
        for(APTS_Discounts_Config__c discountConfig: mapDiscountConfig.values()){
            if(discountConfig.APTS_Local_Channel__c == sLocalChannelId){
                return true;
            }
        }
        return false;
    }
    
    /*
     * @Description: Return Discount config records.
     * @Owner: Jignesh Shekhaliya
    */
    public static APTS_Discounts_Config__c getDiscountConfigRecord(String sLocalChannelId, map<Id, APTS_Discounts_Config__c> mapDiscountConfig){
        Boolean iFoundCount = false;
        system.debug('Validation Called : >>>> '+ sLocalChannelId);
        for(APTS_Discounts_Config__c discountConfig: mapDiscountConfig.values()){
            System.Debug('discountConfig.APTS_Local_Channel__c : '+discountConfig.APTS_Local_Channel__c+' -->sLocalChannelId: '+sLocalChannelId);
            if(discountConfig.APTS_Local_Channel__c == sLocalChannelId){
                return discountConfig;
            }
        }
        return null;
    }
    
    /*
     * @Description: Find Agreement SAP Settings for a Country
     * @Owner: Jignesh Shekhaliya
    */
    public static APTS_Agreement_SAP_Setting__c findAgreementSAPSetting(map<Id, APTS_Agreement_SAP_Setting__c> mapOfAgrSAPSetting, String sUserCountry){
        APTS_Agreement_SAP_Setting__c oAgrSAPSettings;
        for(APTS_Agreement_SAP_Setting__c oAgrSAP: mapOfAgrSAPSetting.values()){
            if(oAgrSAP.APTS_Country__c == sUserCountry){
                oAgrSAPSettings =  oAgrSAP;
            }
        }
        
        return oAgrSAPSettings;
    }
    
    /*
     * @Description: Get all Agreement SAP Settings
     * @Owner: Jignesh Shekhaliya
    */
    public static map<Id, APTS_Agreement_SAP_Setting__c> getAgreementSAPSetting(){
        map<Id, APTS_Agreement_SAP_Setting__c> mapAgrSAPSetting = new map<Id, APTS_Agreement_SAP_Setting__c>([ SELECT Id, APTS_Country__c, APTS_Auto_Create_MSPA_In_SAP_On_Approval__c, APTS_Block_MSPA_Creation_In_SAP__c 
                                                                                                               FROM APTS_Agreement_SAP_Setting__c
                                                                                                             ]);
        return mapAgrSAPSetting;
    }
    
}