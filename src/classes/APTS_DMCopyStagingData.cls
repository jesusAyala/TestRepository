/*************************************************************
@Name: APTS_DMCopyStagingData
@Author: Hardik Shah,Nishi Kushwaha
@CreateDate: 27th October 2015
@Description: Batch-Class to copy data of Object selected by User from VF Page
@UsedBy: APTS_CopyData.cls
******************************************************************/

global class APTS_DMCopyStagingData implements Database.Batchable < sObject > , Database.Stateful {

  // Query     
  global final String sQuery;
  // Name of the object for which copying needs to happen
  global final String sObjectName;
  // String messages that needs to be send to user in mail
  global String sMessage = '';
  // boolean flag to determine whether copy from normal to staging object was success/failure
  global boolean bIsUpsertFail = false;

  global APTS_DMCopyStagingData(String query, String ObjectName) {
    sQuery = query;
    sObjectName = ObjectName;
  }

  global Database.QueryLocator start(Database.BatchableContext BC) {
    return Database.getQueryLocator(sQuery);
  }

  /**
   * Execute Method of Batch Job
   * Based on the Object type it will copy the data from staging to normal object
   * 
   * */
  global void execute(Database.BatchableContext BC, List < sObject > scope) {

    system.debug('HS--> Inside Execute of CopyStagingData' + sObjectName);

    // Copy the ProductLineTree Object
    if (sObjectName.equals('APTS_Stage_Product_Line_Tree__c')) {

      List < APTS_Stage_Product_Line_Tree__c > listStageProductLineTree = (List < APTS_Stage_Product_Line_Tree__c > ) scope;

      system.debug('HS--> IF Inside Execute of CopyStaging Data' + listStageProductLineTree.size());

      APTS_CopyDataWrapper oCopyDataWrapper = APTS_DMProductLineTreeHelper.copyProductLineTree(listStageProductLineTree);
      bIsUpsertFail = oCopyDataWrapper.bIsUpsertFail;
      sMessage = oCopyDataWrapper.sErrorMessage;

    }
    // Copy the Product Object with RecordType as Global Product
    else if (sObjectName.equals('APTS_Stage_Product__c')) {

      List < APTS_Stage_Product__c > listGlobalProducts = (List < APTS_Stage_Product__c > ) scope;

      system.debug('HS--> IF Inside Execute of Product2');

      APTS_CopyDataWrapper oCopyDataWrapper = APTS_DMProductHelper.copyProduct(listGlobalProducts);
      bIsUpsertFail = oCopyDataWrapper.bIsUpsertFail;
      sMessage = oCopyDataWrapper.sErrorMessage;

    }
    // Copy the Product Object with RecordType as Local Product
    else if (sObjectName.equals('APTS_Stage_Product__c_local')) {

      List < APTS_Stage_Product__c > listLocalProducts = (List < APTS_Stage_Product__c > ) scope;

      system.debug('HS--> IF Inside Execute of Local Product');

      APTS_CopyDataWrapper oCopyDataWrapper = APTS_DMLocalProductHelper.copyLocalProduct(listLocalProducts);
      APTS_CopyDataWrapper oCopyDataWrapper1 = APTS_DMLocalProductHelper.copyLocalProductInProductClassification(listLocalProducts);
      //bIsUpsertFail = oCopyDataWrapper.bIsUpsertFail;
      //sMessage = oCopyDataWrapper.sErrorMessage;
      if (oCopyDataWrapper.bIsUpsertFail || oCopyDataWrapper1.bIsUpsertFail) {
        bIsUpsertFail = true;
        sMessage = oCopyDataWrapper.sErrorMessage + '\n' + oCopyDataWrapper1.sErrorMessage;
      } else {
        bIsUpsertFail = false;
      }

      // Copy the Approval Rule Matrix Object
    } else if (sObjectName.equals('APTS_Stage_Approval_Rule_Matrix__c')) {

      List < APTS_Stage_Approval_Rule_Matrix__c > listApprovalMatrix = (List < APTS_Stage_Approval_Rule_Matrix__c > ) scope;

      system.debug('HS--> IF Inside Execute of listApprovalMatrix ' + listApprovalMatrix.size());

      APTS_CopyDataWrapper oCopyDataWrapper = APTS_DMApprovalRuleMatrixHelper.copyApprovalMatrix(listApprovalMatrix);
      bIsUpsertFail = oCopyDataWrapper.bIsUpsertFail;
      sMessage = oCopyDataWrapper.sErrorMessage;

      // Copy Local Hierarchy Object   
    } else if (sObjectName.equals('APTS_Stage_Local_Hierarchy__c')) {

      List < APTS_Stage_Local_Hierarchy__c > listStageLocalHierarchy = (List < APTS_Stage_Local_Hierarchy__c > ) scope;

      system.debug('HS--> IF Inside Execute of listStageLocalHierarchy ' + listStageLocalHierarchy.size());

      APTS_CopyDataWrapper oCreatePriceList = APTS_DMLocalHierarchyHelper.createPriceList();
      APTS_CopyDataWrapper oCopyDataWrapper1 = APTS_DMLocalHierarchyHelper.copyLocalHierarchyLevelFourInProduct(listStageLocalHierarchy);
      APTS_CopyDataWrapper oCopyDataWrapper2 = APTS_DMLocalHierarchyHelper.copyLocalHierarchyLevelThreeInProduct(listStageLocalHierarchy);
      APTS_CopyDataWrapper oCopyDataWrapper3 = APTS_DMLocalHierarchyHelper.copyLocalHierarchyLevelTwoInProduct(listStageLocalHierarchy);
      APTS_CopyDataWrapper oCopyDataWrapper4 = APTS_DMLocalHierarchyHelper.createCategory();
      APTS_CopyDataWrapper oAssociateCategoryWithPriceList = APTS_DMLocalHierarchyHelper.associatePriceListWithCategory();
      APTS_CopyDataWrapper oCopyDataWrapper5 = APTS_DMLocalHierarchyHelper.copyLocalHierarchyLevelTwoInCategoryHierarchy(listStageLocalHierarchy);
      APTS_CopyDataWrapper oCopyDataWrapperESCategoryHierarchy = APTS_DMLocalHierarchyHelper.copyESCategoryHierarchy();
      APTS_CopyDataWrapper oCopyDataWrapper6 = APTS_DMLocalHierarchyHelper.copyLocalHierarchyLevelThreeInCategoryHierarchy(listStageLocalHierarchy);
      APTS_CopyDataWrapper oCopyDataWrapper7 = APTS_DMLocalHierarchyHelper.copyLocalHierarchyLevelFourInCategoryHierarchy(listStageLocalHierarchy);
      //APTS_CopyDataWrapper rebuildCategory = APTS_DMLocalHierarchyHelper.rebuildCategoryHierachies();
      APTS_CopyDataWrapper oCopyDataWrapper8 = APTS_DMLocalHierarchyHelper.copyLocalHierarchyInProductClassification();

      if (oCopyDataWrapper1.bIsUpsertFail || oCopyDataWrapper2.bIsUpsertFail || oCopyDataWrapper3.bIsUpsertFail || oCopyDataWrapper4.bIsUpsertFail 
         || oCreatePriceList.bIsUpsertFail || oAssociateCategoryWithPriceList.bIsUpsertFail || 
            oCopyDataWrapper5.bIsUpsertFail || oCopyDataWrapper6.bIsUpsertFail || oCopyDataWrapper7.bIsUpsertFail || oCopyDataWrapper8.bIsUpsertFail || 
            oCopyDataWrapperESCategoryHierarchy.bIsUpsertFail ) {
        bIsUpsertFail = true;
        sMessage = oCopyDataWrapper1.sErrorMessage + '\n' + oCopyDataWrapper2.sErrorMessage + '\n' + oCopyDataWrapper3.sErrorMessage +  '\n' + 
        oCopyDataWrapper4.sErrorMessage + '\n' + 
        oCreatePriceList.sErrorMessage + '\n' + oAssociateCategoryWithPriceList.sErrorMessage + '\n' + 
        oCopyDataWrapper5.sErrorMessage + '\n' + oCopyDataWrapper6.sErrorMessage +
               '\n' + oCopyDataWrapper7.sErrorMessage + '\n' + oCopyDataWrapper8.sErrorMessage  + '\n' + oCopyDataWrapperESCategoryHierarchy.sErrorMessage ;
      } else {
        bIsUpsertFail = false;
      }
    } else if (sObjectName.equals('APTS_Stage_MSPA__c')) {

      List < APTS_Stage_MSPA__c > listStageCopyMSPA = (List < APTS_Stage_MSPA__c > ) scope;
            system.debug('HS--> IF Inside Execute of listStageLocalHierarchy ' + listStageCopyMSPA.size());
            APTS_CopyDataWrapper oCopyDataWrapper1 = APTS_DMMSPAHelper.copyMSPA(listStageCopyMSPA);
      if (oCopyDataWrapper1.bIsUpsertFail ) {
            bIsUpsertFail = true;
            sMessage = oCopyDataWrapper1.sErrorMessage ;
      }else {
        bIsUpsertFail = false;
      }
      
    } else if (sObjectName.equals('APTS_Stage_MSPA_LineItems__c')) {

      List < APTS_Stage_MSPA_LineItems__c > listStageMSPALineItem = (List < APTS_Stage_MSPA_LineItems__c > ) scope;
            system.debug('HS--> IF Inside Execute of listStageLocalHierarchy ' + listStageMSPALineItem.size());
            APTS_CopyDataWrapper oCopyDataWrapper1 = APTS_DMMSPALineItemHelper.copyStageMSPALineItemToLineItem(listStageMSPALineItem);
      if (oCopyDataWrapper1.bIsUpsertFail ) {
            bIsUpsertFail = true;
            sMessage = oCopyDataWrapper1.sErrorMessage ;
      }else {
        bIsUpsertFail = false;
      }
      
    }else if((sObjectName.equals('APTS_Stage_Master_Picklist__c'))){
          List <APTS_Stage_Master_Picklist__c> listStageMasterPick = (List <APTS_Stage_Master_Picklist__c>) scope;
          system.debug('HS--> IF Inside Execute of stageMasterPickList ' + listStageMasterPick.size());
          APTS_CopyDataWrapper oCopyDataWrapper1 = APTS_DMMasterPicklistTableHelper.copyMasterPickList(listStageMasterPick);
           if (oCopyDataWrapper1.bIsUpsertFail ) {
            bIsUpsertFail = true;
           sMessage = oCopyDataWrapper1.sErrorMessage ;
          }else {
            bIsUpsertFail = false;
          }
     }
      else if((sObjectName.equals('APTS_Stage_Local_Operational_Data__c'))){
          List <APTS_Stage_Local_Operational_Data__c> listStageLODPick = (List <APTS_Stage_Local_Operational_Data__c>) scope;
          system.debug('HS--> IF Inside Execute of LODPickList ' + listStageLODPick.size());
          APTS_CopyDataWrapper oCopyDataWrapper1 = APTS_DMLODHelper.copyLocalOperationalData(listStageLODPick);
           if (oCopyDataWrapper1.bIsUpsertFail ) {
            bIsUpsertFail = true;
           sMessage = oCopyDataWrapper1.sErrorMessage ;
          }else {
            bIsUpsertFail = false;
          }
     }
     
     else if((sObjectName.equals('APTS_Stage_MSPA_Approvals__c'))){
          List <APTS_Stage_MSPA_Approvals__c> listStageMSPAApproval = (List <APTS_Stage_MSPA_Approvals__c>) scope;
          system.debug('HS--> IF Inside Execute of stageMasterPickList ' + listStageMSPAApproval.size());
         //TODO:  Yet to Update this into a seperate file 
         APTS_CopyDataWrapper oCopyDataWrapper1 = APTS_DMStageMSPAApprovalHelper.copyStageMSPAApprovals(listStageMSPAApproval);
           if (oCopyDataWrapper1.bIsUpsertFail ) {
            bIsUpsertFail = true;
            sMessage = oCopyDataWrapper1.sErrorMessage ;
          }else {
            bIsUpsertFail = false;
          }
      
        } 
  
  }

    /**
     * Finish Method of Batch-Job
     * 
     * Based on the response of code in execute method,this method sends appropriate mails to user.
     * 
     * */ 
  global void finish(Database.BatchableContext BC) {

    String sMessageBody = '';
    String sReportId = '';
    String sObjectName1 = '';
    
     try{
             if(APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration') != null){
                    
                     // Get the Report-Id for Stage-ProductLineTree Object
                    if(sObjectName.equals('APTS_Stage_Product_Line_Tree__c')){
                        sReportId = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_ProductLineTree_Reconciliation__c;
                        sObjectName1 = 'Product Line Tree';
                        
                    }
                    // Get the Report-Id for Stage-Product (RecordType Global Product) Object
                    else if(sObjectName.equals('APTS_Stage_Product__c')){
                         sReportId = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_GlobalProduct_Reconciliation__c;
                         sObjectName1 = 'Global Products';
                        
                    }
                    // Get the Report-Id for Stage-Product (RecordType LocalProduct) Object
                    else if(sObjectName.equals('APTS_Stage_Product__c_local')){
                        sReportId = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_LocalProduct_Reconciliation__c;
                        sObjectName1 = 'Local Products';
                         
                    }
                    // Get the Report-Id for Stage Approval Matrix  Object
                    else if(sObjectName.equals('APTS_Stage_Approval_Rule_Matrix__c')){
                         sReportId = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_ApprovalMatrix_Reconciliation__c;
                         sObjectName1 = 'Approval Rule Matrix';
                    }
                    // Get the Report-Id for Stage Local Hierachy
                    else if(sObjectName.equals('APTS_Stage_Local_Hierarchy__c')){
                         sReportId = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_LocalHierachy_Reconciliation__c;
                         sObjectName1 = 'Local Hierarchy';
                    }
                    // Get the Report-Id for Stage MSPA
                    else if(sObjectName.equals('APTS_Stage_MSPA__c')){
                         sReportId = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_MSPA_Reconciliation__c;
                         sObjectName1 = 'MSPA';
                    }
                    // Get the Report-Id for Stage MSPA LineItems 
                    else if(sObjectName.equals('APTS_Stage_MSPA_LineItems__c')){
                         sReportId = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_MSPA_LineItems_Reconciliation__c;
                         sObjectName1 = 'MSPA LineItems';
                    }
                    else if(sObjectName.equals('Stage_MSPA_Approvals__c')){
                         sReportId = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_MSPAApproval_Reconciliation__c;
                         sObjectName1 = 'MSPA Approvals';
                    }
                    else if(sObjectName.equals('Stage_Master_Picklist__c')){
                         sReportId = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_MasterPickList_Reconciliation__c;
                         sObjectName1 = 'Master PickList';
                    }else if(sObjectName.equals('APTS_Stage_Local_Operational_Data__c')){
                         sReportId = APTS_Stage_Data_Validation_Rules_Setting__c.getValues('DataMigration').APTS_LocalOperationalData_Reconciliation__c;
                         sObjectName1 = 'Local Operational Data';
                    }
                    
                    system.debug('HS--> Report Ids for:' + sObjectName1 + ':' +  sReportId);
               }
               
        }
        
        catch(Exception ex){
            system.debug('Error while Fetching CustomSettings' +ex.getMessage());
        }
    
    AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
	                    FROM AsyncApexJob WHERE Id = :BC.getJobId()];
    
    system.debug('HS--> ' + bIsUpsertFail);
    if (bIsUpsertFail) {
      sMessageBody = ' Hi <br/><br/> Batch Job for '+sObjectName1+ ' to Copy Data from Staging to Normal Object is Done, <br/><br/> ' +
        'Please refer to details Below. <br/><br/> Job-ID: '+ a.ID+ '<br/><br/> Job-Status: '+ a.Status+ '<br/><br/> Total Job Items: '+
        a.TotalJobItems+ '<br/><br/> Job Items Processed: '+ a.JobItemsProcessed+ ' <br/><br/> Number Of Errors: ' + a.NumberOfErrors + '<br/><br/><br/>' + sMessage;
    } else {
      sMessageBody = ' Hi <br/><br/> Batch Job for '+sObjectName1+ ' to Copy Data from Staging to Normal Object is Done, <br/><br/> ' +
        'Data has been successfully copied. <br/><br/> Job-ID: '+ a.ID+ '<br/><br/> Job-Status: '+ a.Status+ '<br/><br/> Total Job Items: '+
        a.TotalJobItems+ '<br/><br/> Job Items Processed: '+ a.JobItemsProcessed+ ' <br/><br/> Number Of Errors: ' + a.NumberOfErrors + '<br/><br/>' + sMessage+ 
            			'<br/> Reconciliation Report: '+sReportId;
    }

    APTS_EmailUtility.sendEmail(sMessageBody, 'Data Copy for '+sObjectName1+ ' from Staging to Normal Object');
    system.debug('HS--> Finish');
  }


}