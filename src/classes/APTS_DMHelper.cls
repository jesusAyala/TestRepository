/*************************************************************
@Name: APTS_DMHelper
@Author: Shabbir Lahori
@CreateDate: 12th November 2015
@Description: Helper Class for the Batch-Class to validate and Load data of Object selected by User from VF Page.  This is the parent abstract class and will be inherited.
@UsedBy: APTS_DMValidateData.cls
******************************************************************/

public abstract class APTS_DMHelper { 
    
     
    public static List <User> usrList = new List <User>();
    public static Map <String, User> emailMap = new Map <String, User>();
    public static Map <String, User> usrNameMap = new Map <String, User>();
    public static Boolean isValidateOwner = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_Validate_SFDC_User__c;
         
    //**Sreekanth - Start
   //Common method to validate Owner field
    public static String validateOwner(String ownername, String errorMessage) {
          /*String[] splitName = ownername.split('\n');
          String errMsg = ' ';
          User usr = [select FirstName, LastName from User where FirstName =:splitName[0] and LastName =:splitName[1] and IsActive=true limit 1];        
          if(usr == Null) {             
            User usr1 = [select FirstName, LastName from User where Email=:ownername and IsActive=true limit 1];
              if(usr1 == Null) { 
              system.debug('HS-->Valid values in owner field are Full Name or Email-ID');
              errMsg = errorMessage + 'Invalid owner: '+ ownername +'. \n';
              }
          }
          return(errMsg);*/
        return errorMessage;
    }
    //**End
   
    /**
     * This method returns the list of Active Users from the list passed to it
     * 
     *  Written by : Sreekanth
     * 
     **/
    public static void setActiveUserList(List <String> ownerList){
        
        usrList = getQueryResult(ownerList);
        for(User usr: usrList){
            usrNameMap.put(usr.FirstName+' '+usr.LastName, usr);
            emailMap.put(usr.Email, usr);
          }
    }
    
    public static Boolean validateUser(String usrName) { 
      if (!string.IsBlank(usrName)) {
          if(isValidateOwner && !APTS_DMHelper.usrNameMap.containsKey(usrName) && 
             !APTS_DMHelper.emailMap.containsKey(usrName)) {
            return false;     
          }
      } 
      return true; 
    }
    
    public static Id getUserforLoad(String usrName) {
        //User usr = new User();
        if(!string.isBlank(usrName)){
                if(APTS_DMHelper.usrNameMap.containsKey(usrName)) {
                   return APTS_DMHelper.usrNameMap.get(usrName).ID;
                 } else if(APTS_DMHelper.emailMap.containsKey(usrName)) {
                    return APTS_DMHelper.emailMap.get(usrName).ID;       
                 }
         }
        
        return UserInfo.getUserId();
    }
    
    public static List <User> getQueryResult(List <String> ownerList){
        List <User> usrList1 = new List <User>();
        String[] splitName;
        String query = 'select FirstName, LastName, Email from User where IsActive=true and ';
        Boolean firstIter = True;
        
        for (String OwnerName: ownerList) {
           if(OwnerName != null) {
              splitName = OwnerName.split(' ', 2);
              String firstNameStr='';
              String lastNameStr='';
              
              if(splitName!=null && splitName.size() > 0)
              {
                firstNameStr= splitName[0];
                if(splitname.size()> 1)
                {
                    lastNameStr = splitName[1];
                }
                  
              }
              if(firstIter) {
                  query = query + '(((FirstName =\''+firstNameStr+'\' and LastName =\''+lastNameStr+'\') or (Email = \''+OwnerName+'\'))';
                  firstIter = false;
              } else {
                  query = query + ' OR ' + '((FirstName =\''+firstNameStr+'\' and LastName =\''+lastNameStr+'\') or (Email = \''+OwnerName+'\'))';
                      }
            } 
        }
        query = query + ')';
        system.debug('User soql------'+query);  
        usrList1 = Database.query(query);
        
        return usrList1;
    }

    public static void insertError(Database.UpsertResult[] listErr, String obj){
        List<APTS_Stage_DM_Error__c> listError = new List<APTS_Stage_DM_Error__c>();
        String sError;
        String sStatusCodes;
        for (Database.UpsertResult sr: listErr) {
                    if (sr.isSuccess()) {
                        
                    } else {
                        sError = '';
                        sStatusCodes = '';
                        for (Database.Error err: sr.getErrors()) {
                            sError = sError + ' -- ' +  err.getMessage();    
                            sStatusCodes = sStatusCodes + ' -- ' +  String.ValueOf(err.getStatusCode());
                        }
                          APTS_Stage_DM_Error__c oError = new APTS_Stage_DM_Error__c();
                          oError.APTS_Error_Description__c = sError;
                          oError.APTS_Error_Status__c = sStatusCodes;
                          oError.APTS_Object_Name__c = obj;
                          oError.APTS_User_Name__c = userInfo.getName();
             
                            listError.add(oError);
                           
                        }
                     }
                if (listerror.size() > 0){
                    insert listerror;
                }

          }

        
      



    /**
     * This Method performs validation for a given Id
     * Written-By : Hardik Shah
     * 
     * */
  public static Boolean isValidProductId(String recordIdOrPrefix) {
    Boolean bRecordIdForGlobalProduct = false;
    if(recordIdOrPrefix != null  && recordIdOrPrefix.isNumeric()){
        bRecordIdForGlobalProduct = true;
      }
      system.debug('HS--> Failed-Id' +recordIdOrPrefix );
      
        return bRecordIdForGlobalProduct;
  }
  
  
  
  /**
   * This method creates a list of Codes from Master-PickList Table
   * 
   * */ 
   Public static List<APTS_Master_Picklist_Table__c> getMasterListCodes(){
      
      List<APTS_Master_Picklist_Table__c> listMasterCodes = [Select APTS_Code__c from APTS_Master_Picklist_Table__c
                                                             where (APTS_Locale__c = : APTS_DMConstants.SPAIN_LOCALE )
                                                             AND (APTS_Code_Used_For__c =: APTS_DMConstants.MASTER_PICKLIST_COUNTRY 
                                                             OR  APTS_Code_Used_For__c =:  APTS_DMConstants.MASTER_PICKLIST_DISTRIBUTION_CHANNEL
                                                             OR APTS_Code_Used_For__c  =:  APTS_DMConstants.MASTER_PICKLIST_SALES_OFFICE 
                                                             OR APTS_Code_Used_For__c  =:  APTS_DMConstants.MASTER_PICKLIST_LOCAL_CHANNEL
                                                             OR APTS_Code_Used_For__c  =:  APTS_DMConstants.MASTER_PICKLIST_INCOTERM
                                                             OR APTS_Code_Used_For__c  =:  APTS_DMConstants.MASTER_PICKLIST_PAYMENT_TERM
                                                             OR APTS_Code_Used_For__c  =:  APTS_DMConstants.MASTER_PICKLIST_SAP_DIVISION
                                                             OR APTS_Code_Used_For__c  =:  APTS_DMConstants.MASTER_PICKLIST_SAP_SALES_ORGANIZATION)
                                                             ];
      
      return listMasterCodes;
      
      
  }
  
  Public static List<APTS_Stage_Master_Picklist__c> getMasterListCodesFromStage(){
      
      List<APTS_Stage_Master_Picklist__c> listStageMasterCodes = [Select APTS_Code__c from APTS_Stage_Master_Picklist__c
                                                             where  (APTS_Locale__c = : APTS_DMConstants.SPAIN_LOCALE )
                                                             AND(APTS_Code_Used_For__c =: APTS_DMConstants.MASTER_PICKLIST_COUNTRY 
                                                             OR  APTS_Code_Used_For__c =:  APTS_DMConstants.MASTER_PICKLIST_DISTRIBUTION_CHANNEL
                                                             OR APTS_Code_Used_For__c  =:  APTS_DMConstants.MASTER_PICKLIST_SALES_OFFICE 
                                                             OR APTS_Code_Used_For__c  =:  APTS_DMConstants.MASTER_PICKLIST_LOCAL_CHANNEL
                                                             OR APTS_Code_Used_For__c  =:  APTS_DMConstants.MASTER_PICKLIST_INCOTERM
                                                             OR APTS_Code_Used_For__c  =:  APTS_DMConstants.MASTER_PICKLIST_PAYMENT_TERM
                                                             OR APTS_Code_Used_For__c  =:  APTS_DMConstants.MASTER_PICKLIST_SAP_DIVISION
                                                             OR APTS_Code_Used_For__c  =:  APTS_DMConstants.MASTER_PICKLIST_SAP_SALES_ORGANIZATION)
                                                             ];
      
      return listStageMasterCodes;
      
      
  }
  
     
     // WIP
     public static void validateStageMSPAApprovals(List<APTS_Stage_MSPA_Approvals__c>  listStageMSPAApproval){
     } 
   
     
     public static String getQuery(String SobjectApiName, String statusStr, Integer queryLimit){
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
 
        String commaSepratedFields = '';
        for(String fieldName : fieldMap.keyset()){
            if(commaSepratedFields == null || commaSepratedFields == ''){
                commaSepratedFields = fieldName;
            }else{
                commaSepratedFields = commaSepratedFields + ', ' + fieldName;
            }
        }
 
        String query = 'select ' + commaSepratedFields + ' from ' + SobjectApiName  + ' where APTS_RowStatus__c = \''+statusStr +'\' ';
        if(statusStr==APTS_DMConstants.INITIAL_LOAD_STATUS)
        {
         
         query = 'select ' + commaSepratedFields + ' from ' + SobjectApiName  + ' where APTS_RowStatus__c in( \''+statusStr +'\', \'Error\') ';
        }
        else
        {
        query = 'select ' + commaSepratedFields + ' from ' + SobjectApiName  + ' where APTS_RowStatus__c = \''+statusStr +'\' ';
        }
        
        if (queryLimit > 0) {
            query =  query + ' Limit '+queryLimit;
        }
 
        return query;
    }

     
public static void updateLoadingStatus(Set<Id> successIdSet, String targetsobjectNameStr, String targetExternalIdFieldNameStr, String sourceExternalIdFieldNameStr, List<sObject> stageLst){

  Set<String> externalIdSet = New Set<String>();
  Map<String,Id> mapOberationalObject = new Map<String,Id>();
          if(successIdSet.size() > 0)
                {
                    String queryStr  = 'select Id, ' + targetExternalIdFieldNameStr + ' from '  +targetsobjectNameStr +  ' where id in :successIdSet' ;
                    List<sObject > listOperationalObject = Database.query(queryStr);
                    for(sObject oOperationalObject: listOperationalObject)
                    {
                      externalIdSet.add((String)oOperationalObject.get(targetExternalIdFieldNameStr));
                      mapOberationalObject.put((String)oOperationalObject.get(targetExternalIdFieldNameStr),oOperationalObject.Id);
                    }
                    if(externalIdSet.size() > 0)
                    {
                       for(sObject stageSo : stageLst){
                        
                            if(externalIdSet.contains((String)stageSo.get(sourceExternalIdFieldNameStr)))
                            {
                                 stageSo.put('APTS_RowStatus__c',APTS_DMConstants.LOAD_STATUS);
                                 stageSo.put('APTS_Operational_Object__c',mapOberationalObject.get((String)stageSo.get(sourceExternalIdFieldNameStr)));
                            }
                            else
                            {
                                stageSo.put('APTS_RowStatus__c',APTS_DMConstants.LOAD_FAIL);
                            }
                       }// end for
                       
                       update stageLst;
                    }
                }
                else
                {
                    for(sObject stageSo : stageLst){
                     stageSo.put('APTS_RowStatus__c',APTS_DMConstants.LOAD_FAIL);
                        
                    }
                    
                    update stageLst ;
          }
}

 
      /*
  private static void prepareExternalIdForProductLineItem(APTS_Stage_Product_Line_Tree__c productLineTree) {
    String sExternalId = '';

    if ((productLineTree.APTS_PG__c != null)) {
      sExternalId = sExternalId + String.valueOf(productLineTree.APTS_PG__c);
    }

    if ((productLineTree.APTS_Product_Line_1_ID__c != null)) {
      sExternalId = sExternalId + String.valueOf(productLineTree.APTS_Product_Line_1_ID__c);
    }

    if ((productLineTree.APTS_Product_Line_2_ID__c != null)) {
      sExternalId = sExternalId + String.valueOf(productLineTree.APTS_Product_Line_2_ID__c);
    }

    if ((productLineTree.APTS_Product_Line_3_ID__c != null)) {
      sExternalId = sExternalId + String.valueOf(productLineTree.APTS_Product_Line_3_ID__c);
    }
    system.debug('HS--> External-Id' + sExternalId);
    productLineTree.APTS_External_ID__c = String.valueOf(sExternalId);

  } */

}