/************************************************************
 * @Name : APTS_ApprovalRequestTriggerHandler
 * @Author : Shalin Shah (sshah@apttus.com)
 * @CreateDate : 16th Sept, 2015
 * @Description : Handler class for trigger
 * @UsedBy : Trigger : APTS_ApprovalRequestTrigger
 ************************************************************/

public class APTS_ApprovalRequestTriggerHandler {
     
    private static String REJECTED = 'Rejected';
    private static String WITH_COMMENTS = 'with comments';
    
    /**
     * Method being called by trigger before updating the record.
     */
    public void handleBeforeUpdate(List<Apttus_Approval__Approval_Request__c> listApprovalRequestSo, Map<Id, Apttus_Approval__Approval_Request__c> mapOldRecords) {
        
        // fetch the error message from approval system properties
        Apttus_Approval__ApprovalsSystemProperties__c oApprovalSystemProperties = Apttus_Approval__ApprovalsSystemProperties__c.getInstance('System Properties');
        
        // iterate over all the approval request records
        for(Apttus_Approval__Approval_Request__c oApprovalRequest : listApprovalRequestSo) {
            
            // System by default enters a default comment with sysdate, time and user name in round brackets.
            // Below conditions are written considering in mind that if the request is rejected and no comments
            // are provided by the user then throw the error message on page.
            
            Apttus_Approval__Approval_Request__c oOldApprovalRequest = mapOldRecords.get(oApprovalRequest.ID);
            
            if(REJECTED.equals(oApprovalRequest.Apttus_Approval__Approval_Status__c)
                && oApprovalRequest.Apttus_Approval__Approver_Comments__c != oOldApprovalRequest.Apttus_Approval__Approver_Comments__c
                && oApprovalRequest.Apttus_Approval__Approver_Comments__c != null
                && !oApprovalRequest.Apttus_Approval__Approver_Comments__c.contains(WITH_COMMENTS)) {
                    
                    oApprovalRequest.addError(oApprovalSystemProperties.APTS_Comments_Mandatory_On_Rejection__c);
            }
        }
    } 
    
    public void handleBeforeDelete(List<Apttus_Approval__Approval_Request__c> deletedApprovalRequestSoLst) {
        
        Set<Id> proposalIdSet = New Set<Id>();
        Set<Id> agreementIdSet = New Set<Id>();
        
        for(Apttus_Approval__Approval_Request__c approvalRequestSo : deletedApprovalRequestSoLst) {
            
            if(approvalRequestSo.Apttus_Approval__Object_Type__c == 'Apttus_Proposal__Proposal__c') {
                proposalIdSet.add(approvalRequestSo.Apttus_Approval__Object_Id__c);
            } else if (approvalRequestSo.Apttus_Approval__Object_Type__c == 'Apttus__APTS_Agreement__c') {
                agreementIdSet.add(approvalRequestSo.Apttus_Approval__Object_Id__c);
            }
        }
        
        List<Apttus__APTS_Agreement__Share> sharesToDelete = [SELECT Id 
                                                                FROM Apttus__APTS_Agreement__Share
                                                               WHERE ParentId IN :agreementIdSet
                                                                 AND RowCause = 'APTS_EnableAccessToApprover__c'];
        if(!sharesToDelete.isEmpty()) {
            Database.Delete(sharesToDelete, false);
        }
        
        List<Apttus_Proposal__Proposal__Share >  proposalsharesToDelete = [SELECT Id 
                                                                             FROM Apttus_Proposal__Proposal__Share 
                                                                            WHERE ParentId IN :proposalIdSet 
                                                                              AND RowCause = 'APTS_EnableAccessToApprover__c'];
        if(!proposalsharesToDelete.isEmpty()) {
            Database.Delete(proposalsharesToDelete , false);
        }
    }
    
    public void handleAfterUpdate(List<Apttus_Approval__Approval_Request__c> updatedApprovalRequestSoLst, Map<Id, Apttus_Approval__Approval_Request__c> mapOldRecords) {
        
        Set<Id> proposalIdSet = New Set<Id>();
        Set<Id> agreementIdSet = New Set<Id>();
        List<Apttus_Approval__Approval_Request__c> cancelledARList = new List<Apttus_Approval__Approval_Request__c>();
        // Revoke Quote/mspa access from approver users when approval request is recalled
        // Date : 08/01/2016 added by Chetan Patel as part of R 3.1 SIT defect fix
        
        for(Apttus_Approval__Approval_Request__c approvalRequestSo : updatedApprovalRequestSoLst) {
            
            if(approvalRequestSo.Apttus_Approval__Approval_Status__c=='Cancelled'){
                cancelledARList.add(approvalRequestSo);
                if(approvalRequestSo.Apttus_Approval__Object_Type__c == 'Apttus_Proposal__Proposal__c' ) {
                    proposalIdSet.add(approvalRequestSo.Apttus_Approval__Object_Id__c);
                } else if (approvalRequestSo.Apttus_Approval__Object_Type__c == 'Apttus__APTS_Agreement__c') {
                    agreementIdSet.add(approvalRequestSo.Apttus_Approval__Object_Id__c);
                }
            }
        }
        
        List<Apttus__APTS_Agreement__Share> sharesToDelete = [SELECT Id 
                                                                FROM Apttus__APTS_Agreement__Share
                                                               WHERE ParentId IN :agreementIdSet
                                                                 AND RowCause = 'APTS_EnableAccessToApprover__c'];
        if(!sharesToDelete.isEmpty()) {
            Database.Delete(sharesToDelete, false);
        }
        
        List<Apttus_Proposal__Proposal__Share >  proposalsharesToDelete = [SELECT Id 
                                                                             FROM Apttus_Proposal__Proposal__Share 
                                                                            WHERE ParentId IN :proposalIdSet 
                                                                              AND RowCause = 'APTS_EnableAccessToApprover__c'];
        if(!proposalsharesToDelete.isEmpty()) {
            Database.Delete(proposalsharesToDelete , false);
        }
        //remove approver user ids from quotation/MSPA
        if(!cancelledARList.isEmpty()){
            removeApproverIdsOnParentRecord(cancelledARList);
        }
    }
    
    public void giveAccesstoApprovers(List<Apttus_Approval__Approval_Request__c> insertedApprovalRequestSoLst) {
        
        // Apttus__APTS_Agreement__Share  is the "Share" table that was created when the
        // Organization Wide Default sharing setting was set to "Private".
        // Allocate storage for a list of Apttus__APTS_Agreement__Share  records.
        List<Apttus_Approval__Approval_Request__c> proposalApprovalRequestSoLst = New List<Apttus_Approval__Approval_Request__c>();
        List<Apttus_Approval__Approval_Request__c> agreementApprovalRequestSoLst = New List<Apttus_Approval__Approval_Request__c>();
        
        Set<Id> proposalIdSet = New Set<Id>();
        Set<Id> agreementIdSet = New Set<Id>();
        
        for(Apttus_Approval__Approval_Request__c approvalRequestSo : insertedApprovalRequestSoLst) {
            
            if(approvalRequestSo.Apttus_Approval__Object_Type__c == 'Apttus_Proposal__Proposal__c') {
                proposalApprovalRequestSoLst.add(approvalRequestSo);
                proposalIdSet.add(approvalRequestSo.Apttus_Approval__Object_Id__c);
            } else if (approvalRequestSo.Apttus_Approval__Object_Type__c == 'Apttus__APTS_Agreement__c') {
                agreementApprovalRequestSoLst.add(approvalRequestSo);
                agreementIdSet.add(approvalRequestSo.Apttus_Approval__Object_Id__c);
            }
        }
        
        List<Apttus_Proposal__Proposal__Share > proposalSharesLst = new List<Apttus_Proposal__Proposal__Share >();
        
        // For each of the Agreement records being inserted, do the following:
        for(Apttus_Approval__Approval_Request__c approvalRequestSo : proposalApprovalRequestSoLst) {
            
            if( approvalRequestSo.Apttus_Approval__Object_Type__c =='Apttus_Proposal__Proposal__c' 
                  && ( (approvalRequestSo.Apttus_Approval__HasDelegateApprover__c 
                          && approvalREquestSo.Apttus_Approval__DelegateApprover__c!=null
                          && String.ValueOf(approvalRequestSo.Apttus_Approval__DelegateApprover__c).startsWith('005'))
                                ||
                       (approvalRequestSo.Apttus_Approval__Assigned_To_Id__c != null 
                          && approvalRequestSo.Apttus_Approval__Assigned_To_Id__c.startsWith('005'))
                     )
              ) {
                  // Create a new Apttus__APTS_Agreement__Share record to be inserted in to the
                  // Apttus__APTS_Agreement__Share table.
                  Apttus_Proposal__Proposal__Share proposalForShare = new Apttus_Proposal__Proposal__Share ();
                  
                  // Populate the Apttus__APTS_Agreement__Share record with the ID of the record to be shared.
                  proposalForShare.ParentId = approvalRequestSo.Apttus_Approval__Object_Id__c;
                  
                  // Then, set the ID of user or group being granted access. In this case,
                  // we’re setting the Id of the Requestor that was specified by
                  proposalForShare.UserOrGroupId = approvalRequestSo.Apttus_Approval__Assigned_To_Id__c;
                  
                  // Specify that the Requestor should have edit access for this particular Agreement record.
                  proposalForShare.AccessLevel = 'Read';
                  
                  // Specify that the reason the Requestor can edit the record is because he’s the Requestor.
                  // (APTS_EnableAccessToRequestor is the Apex Sharing Reason that we defined on Agreement object.)
                  proposalForShare.RowCause = Schema.Apttus_Proposal__Proposal__Share.RowCause.APTS_EnableAccessToApprover__c;
                  
                  // Add the new Share record to the list of new Share records.
                  proposalSharesLst.add(proposalForShare);
                  
                  if( approvalRequestSo.Apttus_Approval__HasDelegateApprover__c
                        && approvalREquestSo.Apttus_Approval__DelegateApprover__c!=null) {
                            
                       proposalForShare = new Apttus_Proposal__Proposal__Share ();
                       proposalForShare.ParentId = approvalRequestSo.Apttus_Approval__Object_Id__c;
                       proposalForShare.UserOrGroupId = approvalRequestSo.Apttus_Approval__DelegateApprover__c;
                       proposalForShare.AccessLevel = 'Read';
                       proposalForShare.RowCause = Schema.Apttus_Proposal__Proposal__Share.RowCause.APTS_EnableAccessToApprover__c;
                       proposalSharesLst.add(proposalForShare);
                  }
              }
        }
        
        if(proposalSharesLst.size() > 0) {
            // Insert all of the newly created Share records
            insert proposalSharesLst;
        }
        
        List<Apttus__APTS_Agreement__Share> agreementSharesLst  = new List<Apttus__APTS_Agreement__Share>();
        
        // For each of the Agreement records being inserted, do the following:
        for(Apttus_Approval__Approval_Request__c approvalRequestSo : agreementApprovalRequestSoLst) {
            
            if( approvalRequestSo.Apttus_Approval__Object_Type__c =='Apttus__APTS_Agreement__c'
                 && ( (approvalRequestSo.Apttus_Approval__HasDelegateApprover__c 
                        && approvalREquestSo.Apttus_Approval__DelegateApprover__c != null
                        && String.ValueOf(approvalRequestSo.Apttus_Approval__DelegateApprover__c).startsWith('005'))
                            ||
                      (approvalRequestSo.Apttus_Approval__Assigned_To_Id__c != null 
                        && approvalRequestSo.Apttus_Approval__Assigned_To_Id__c.startsWith('005'))
                    )
              ) {
                  // Create a new Apttus__APTS_Agreement__Share record to be inserted in to the
                  // Apttus__APTS_Agreement__Share table.
                  Apttus__APTS_Agreement__Share proposalForShare = new Apttus__APTS_Agreement__Share ();
                  
                  // Populate the Apttus__APTS_Agreement__Share record with the ID of the record to be shared.
                  proposalForShare.ParentId = approvalRequestSo.Apttus_Approval__Object_Id__c;
                  
                  // Then, set the ID of user or group being granted access. In this case,
                  // we’re setting the Id of the Requestor that was specified by
                  proposalForShare.UserOrGroupId = approvalRequestSo.Apttus_Approval__Assigned_To_Id__c;
                  
                  // Specify that the Requestor should have edit access for this particular Agreement record.
                  proposalForShare.AccessLevel = 'Edit'; //Changed the access to edit as a part of changes for enabling preview button for approvers 
                                                             //because APttus does not allows to preview if the user does not have edit access on agreement
                  
                  // Specify that the reason the Requestor can edit the record is because he’s the Requestor.
                  // APTS_EnableAccessToRequestor is the Apex Sharing Reason that we defined on Agreement object.
                  proposalForShare.RowCause = Schema.Apttus__APTS_Agreement__Share.RowCause.APTS_EnableAccessToApprover__c;
                  
                  // Add the new Share record to the list of new Share records.
                  agreementSharesLst.add(proposalForShare);
                  
                  if( approvalRequestSo.Apttus_Approval__HasDelegateApprover__c
                       && approvalREquestSo.Apttus_Approval__DelegateApprover__c!=null) {
                           
                       proposalForShare = new Apttus__APTS_Agreement__Share();
                       proposalForShare.ParentId = approvalRequestSo.Apttus_Approval__Object_Id__c;
                       proposalForShare.UserOrGroupId = approvalRequestSo.Apttus_Approval__DelegateApprover__c;
                       proposalForShare.AccessLevel = 'Edit'; //Changed the access to edit as a part of changes for enabling preview button for approvers 
                                                             //because APttus does not allows to preview if the user does not have edit access on agreement
                       proposalForShare.RowCause = Schema.Apttus__APTS_Agreement__Share.RowCause.APTS_EnableAccessToApprover__c;
                       
                       agreementSharesLst.add(proposalForShare);
                  }
              }
        }
        
        if(agreementSharesLst.size() > 0) {
            // Insert all of the newly created Share records
            insert agreementSharesLst;
        }
    }
    
    
    public void sendMailToRecordOwner(List<Apttus_Approval__Approval_Request__c> oldRecords, Map<Id, Apttus_Approval__Approval_Request__c> mapOldRecords,
        List<Apttus_Approval__Approval_Request__c> newRecords, Map<Id, Apttus_Approval__Approval_Request__c> mapNewRecords){
        
        Map<Id,Id> mapReqToProposal = new Map<Id,Id>();
        Map<Id,Id> mapReqToAgreement = new Map<Id,Id>();
        
        for(Apttus_Approval__Approval_Request__c requestObj : newRecords){
            
            Apttus_Approval__Approval_Request__c oldApprovalReq = mapOldRecords.get(requestObj.Id);
            Apttus_Approval__Approval_Request__c newApprovalReq = mapNewRecords.get(requestObj.Id);
            
            if(((oldApprovalReq.Apttus_Approval__Approver_Comments__c == null && newApprovalReq.Apttus_Approval__Approver_Comments__c != null)
                || (oldApprovalReq.Apttus_Approval__Approver_Comments__c != newApprovalReq.Apttus_Approval__Approver_Comments__c)) && (!newApprovalReq.Apttus_Approval__Auto_Complete__c)){
                
                System.debug('Old***'+oldApprovalReq.Apttus_Approval__Approver_Comments__c);
                System.debug('New***'+newApprovalReq.Apttus_Approval__Approver_Comments__c);
               
                if(requestObj.Apttus_Approval__Related_Agreement__c == null && requestObj.Apttus_QPApprov__ProposalId__c != null){
                    //mapReqToProposal.put(requestObj.Id,requestObj.Apttus_QPApprov__ProposalId__c);
                    mapReqToProposal.put(requestObj.Apttus_QPApprov__ProposalId__c,requestObj.Id);
                }
                
                else if(requestObj.Apttus_Approval__Related_Agreement__c != null && requestObj.Apttus_QPApprov__ProposalId__c == null){
                    //mapReqToAgreement.put(requestObj.Id,requestObj.Apttus_Approval__Related_Agreement__c);
                    mapReqToAgreement.put(requestObj.Apttus_Approval__Related_Agreement__c,requestObj.Id);
                }
            
            }
            
        }
        
        
        Map<Id,Apttus_Proposal__Proposal__c> mapIdToProposal = new Map<Id,Apttus_Proposal__Proposal__c>([SELECT Id, 
                                                                       Owner.Email,
                                                                       Name,
                                                                       APTS_SAP_Reference_No__c,
                                                                       Apttus_Proposal__Proposal_Name__c, 
                                                                       APTS_LP_AccountCustomer__r.Name,
                                                                       APTS_LP_Account_End_User__r.Name,
                                                                       Apttus_Proposal__Opportunity__c,
                                                                       APTS_Local_Channel__r.Name,
                                                                       Apttus_Proposal__Opportunity__r.Name,
                                                                       APTS_LP_Sales_Organization__c,
                                                                       APTS_LP_Distribution_Channel__c,
                                                                       APTS_LP_Local_Channel__c,
                                                                       APTS_Local_Channel__c,
                                                                       APTS_LP_Sales_Person__r.Name,
                                                                       APTS_LP_MaximumSubstituteDiscount__c
                                                                       FROM Apttus_Proposal__Proposal__c
                                                                       WHERE Id IN :mapReqToProposal.keySet()]);
       
        Map<Id,Apttus__APTS_Agreement__c> mapIdToAgreement = new Map<Id,Apttus__APTS_Agreement__c>([SELECT Id,
                                                                       Name,
                                                                       Owner.Email,
                                                                       Apttus__Agreement_Number__c,
                                                                       APTS_SAP_Reference_No__c, 
                                                                       APTS_LP_AccountCustomer__r.Name,
                                                                       APTS_LP_Account_End_User__c,
                                                                       APTS_LP_Sales_Organization__c,
                                                                       APTS_LP_Sales_Person__r.Name,
                                                                       APTS_LP_Sales_Office__c,
                                                                       APTS_Sales_Office_LP__r.Name,
                                                                       APTS_LP_Max_Order_Amount__c,
                                                                       APTS_LP_MaximumSubstituteDiscount__c
                                                                       FROM Apttus__APTS_Agreement__c
                                                                       WHERE Id IN :mapReqToAgreement.keySet()]);
        
       List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
       
       if(null != mapReqToProposal){
           for(Id propId : mapReqToProposal.keySet()){
               Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
               
               List<String> sendTo = new List<String>();
               Apttus_Proposal__Proposal__c propSO = mapIdToProposal.get(propId);
               Id requestId = mapReqToProposal.get(propId);
               Apttus_Approval__Approval_Request__c reqSO = mapNewRecords.get(requestId);
               
               sendTo.add(propSO.Owner.Email);
               mail.setToAddresses(sendTo);
               
               List<String> ccTo = new List<String>();
               ccTo.add(propSO.Owner.Email);
               //mail.setCcAddresses(ccTo);
               
               mail.setSubject('Comments added to Quote ID #'+propSO.APTS_SAP_Reference_No__c+' - '+propSO.Apttus_Proposal__Proposal_Name__c);
               mail.setSaveAsActivity(false);
               
               String body = 'Dear User, <br/>' ;
               body += '<br/><b>Comments have been added to </b>'+propSO.APTS_SAP_Reference_No__c+' - '+propSO.Apttus_Proposal__Proposal_Name__c;
               body += '<br/>';
               body += '<b>Quote Details:</b> <br/> ';
               body += '<b>Quote Number : </b> '+propSO.APTS_SAP_Reference_No__c+' <br/>';
               body += '<b>Account Customer : </b>'+ propSO.APTS_LP_AccountCustomer__r.Name + ' <br/>';
               if(propSO.Apttus_Proposal__Opportunity__c != null && propSO.Apttus_Proposal__Opportunity__r.Name != 'null') {
                body += '<b>Opportunity : </b>'+ propSO.Apttus_Proposal__Opportunity__r.Name  + ' <br/>';    
               }
               else {
                body += '<b>Opportunity : </b>  <br/>';  
               }
               body += '<b>Sales Organization : </b>'+ propSO.APTS_LP_Sales_Organization__c + ' <br/>';
               body += '<b>Distribution Channel : </b>'+ propSO.APTS_LP_Distribution_Channel__c + ' <br/>';
               body += '<b>Local Channel : </b>'+ propSO.APTS_Local_Channel__r.Name + ' <br/>';
               body += '<b>Sales Person : </b>'+ propSO.APTS_LP_Sales_Person__r.Name + ' <br/>';
               body += '<b>Maximum Discount : </b>'+ propSO.APTS_LP_MaximumSubstituteDiscount__c + ' <br/>';
               body += '<br/>';
               body += '<b>Added Comments : </b>'+ reqSO.Apttus_Approval__Approver_Comments__c + ' <br/>';
               body += '<br/>';
               body += '<b>Best Regards,</b> <br/>';
               body += '<b>Sales Team </b><br/>'; 
               mail.setHtmlBody(body);
               
               mails.add(mail);

           }
       }
       
       
       if(null != mapReqToAgreement){
           for(Id agrId : mapReqToAgreement.keySet()){
               Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
               
               List<String> sendTo = new List<String>();
               Apttus__APTS_Agreement__c agreementSO = mapIdToAgreement.get(agrId);
               Id requestId = mapReqToAgreement.get(agrId);
               Apttus_Approval__Approval_Request__c reqSO = mapNewRecords.get(requestId);
               String criticalDiscount = String.valueOf(agreementSO.APTS_LP_MaximumSubstituteDiscount__c);
               String formattedDiscount;

                   if(criticalDiscount !=null && criticalDiscount != ''){
                       formattedDiscount = criticalDiscount.replace('.',',') + ' %';
                   }else{
                       formattedDiscount = '';
                   }
               
               sendTo.add(agreementSO.Owner.Email);
               mail.setToAddresses(sendTo);
               
               List<String> ccTo = new List<String>();
               ccTo.add(agreementSO.Owner.Email);
               //mail.setCcAddresses(ccTo);
               
               mail.setSubject('Comments added to MSPA # '+agreementSO.APTS_SAP_Reference_No__c+' - Name : '+agreementSO.Name);
               mail.setSaveAsActivity(false);
               
               String body = 'Hi, <br/>' ;
               body += '<br/><b>Comments have been added to </b>'+agreementSO.APTS_SAP_Reference_No__c;
               body += '<br/><br/>';
               body += '<b>Agreement Details:</b> <br/> ';
               body += '<b>MSPA Number : </b> '+agreementSO.APTS_SAP_Reference_No__c+' <br/>';
               body += '<b>Account Customer : </b>'+ agreementSO.APTS_LP_AccountCustomer__r.Name + ' <br/>';
               body += '<b>Primary Partner Customer : </b>'+ agreementSO.APTS_LP_Account_End_User__c + ' <br/>';
               body += '<b>Sales Organization : </b>'+ agreementSO.APTS_LP_Sales_Organization__c + ' <br/>';
               body += '<b>Sales Person : </b>'+ agreementSO.APTS_LP_Sales_Person__r.Name + ' <br/>';
               body += '<b>Sales Office : </b>'+ agreementSO.APTS_Sales_Office_LP__r.Name + ' <br/>';
               body += '<b>Max Order Amount : </b>'+ agreementSO.APTS_LP_Max_Order_Amount__c + ' <br/>';
               body += '<b>Critical Discount : </b>'+ formattedDiscount + ' <br/>';
               body += '<br/>';
               body += '<b>Added Comments : </b>'+ reqSO.Apttus_Approval__Approver_Comments__c + ' <br/>';
               body += '<br/>';
               body += '<b>Best Regards,</b> <br/>';
               body += '<b>Sales Team </b><br/>'; 
               mail.setHtmlBody(body);
               
               mails.add(mail);

           }
       }
       
       Messaging.sendEmail(mails);

    }
    
    public void addApproverIdsOnParentRecord(List<Apttus_Approval__Approval_Request__c> insertedApprovalRequestSoLst) {
        
        // Apttus__APTS_Agreement__Share  is the "Share" table that was created when the
        // Organization Wide Default sharing setting was set to "Private".
        // Allocate storage for a list of Apttus__APTS_Agreement__Share  records.
        List<Apttus_Approval__Approval_Request__c> proposalApprovalRequestSoLst = New List<Apttus_Approval__Approval_Request__c>();
        List<Apttus_Approval__Approval_Request__c> agreementApprovalRequestSoLst = New List<Apttus_Approval__Approval_Request__c>();
        
        Set<Id> proposalIdSet = New Set<Id>();
        Set<Id> agreementIdSet = New Set<Id>();
        
        Map<Id,Set<String>> agreementApproverIDMap = new Map<Id,Set<String>>();
        Map<Id,Apttus__APTS_Agreement__c> agreementSOMap;
        
        Map<Id,Set<String>> proposalApproverIDMap= new Map<Id,Set<String>>();
        Map<Id,Apttus_Proposal__Proposal__c> proposalSOMap;
        
        for(Apttus_Approval__Approval_Request__c approvalRequestSo : insertedApprovalRequestSoLst) {
            
            if(approvalRequestSo.Apttus_Approval__Object_Type__c == 'Apttus_Proposal__Proposal__c') {
                proposalApprovalRequestSoLst.add(approvalRequestSo);
                proposalIdSet.add(approvalRequestSo.Apttus_Approval__Object_Id__c);
                proposalApproverIDMap.put(approvalRequestSo.Apttus_Approval__Object_Id__c,new Set<String>());
                
            } else if (approvalRequestSo.Apttus_Approval__Object_Type__c == 'Apttus__APTS_Agreement__c') {
                agreementApprovalRequestSoLst.add(approvalRequestSo);
                agreementIdSet.add(approvalRequestSo.Apttus_Approval__Object_Id__c);
                agreementApproverIDMap.put(approvalRequestSo.Apttus_Approval__Object_Id__c,new Set<String>());
            }
        }
        
        if(!proposalApproverIDMap.keySet().isEmpty()){
            
            proposalSOMap = new Map<id,Apttus_Proposal__Proposal__c>([SELECT Id,APTS_Approver_User_IDs__c
                                                                       FROM Apttus_Proposal__Proposal__c 
                                                                       WHERE Id IN: proposalApproverIDMap.keySet() ]);
           /*
           proposalSOMap = new Map<id,Apttus_Proposal__Proposal__c>();
           for(Id quoteId : proposalApproverIDMap.keySet()){
               proposalSOMap.put(quoteId, new Apttus_Proposal__Proposal__c(Id = quoteId, APTS_Approver_User_IDs__c = ''));
           }*/
        }
        
        if(!agreementApproverIDMap.keySet().isEmpty()){
            agreementSOMap = new Map<id,Apttus__APTS_Agreement__c>([SELECT Id,APTS_Approver_User_IDs__c 
                                                                       FROM Apttus__APTS_Agreement__c 
                                                                       WHERE Id IN: agreementApproverIDMap.keySet() ]);
        }
        
        System.Debug('## proposalSOMap1 : '+proposalSOMap);
        // For each of the Agreement records being inserted, do the following:
        for(Apttus_Approval__Approval_Request__c approvalRequestSo : proposalApprovalRequestSoLst) {
            
            if( approvalRequestSo.Apttus_Approval__Object_Type__c =='Apttus_Proposal__Proposal__c' 
                  && ( (approvalRequestSo.Apttus_Approval__HasDelegateApprover__c 
                          && approvalREquestSo.Apttus_Approval__DelegateApprover__c!=null
                          && String.ValueOf(approvalRequestSo.Apttus_Approval__DelegateApprover__c).startsWith('005'))
                                ||
                       (approvalRequestSo.Apttus_Approval__Assigned_To_Id__c != null 
                          && approvalRequestSo.Apttus_Approval__Assigned_To_Id__c.startsWith('005'))
                     )
              ) {
                //Add string
                If(proposalApproverIDMap.get(approvalRequestSo.Apttus_Approval__Object_Id__c) != null){
                    proposalApproverIDMap.get(approvalRequestSo.Apttus_Approval__Object_Id__c).add(approvalREquestSo.Apttus_Approval__Assigned_To_Id__c+';');
                    //Delegate approvers
                    if( approvalRequestSo.Apttus_Approval__HasDelegateApprover__c
                        && approvalREquestSo.Apttus_Approval__DelegateApprover__c!=null) {
                        proposalApproverIDMap.get(approvalRequestSo.Apttus_Approval__Object_Id__c).add(approvalREquestSo.Apttus_Approval__DelegateApprover__c+';');                        
                    }
                }
            }
        }
        System.Debug('## proposalApproverIDMap : '+proposalApproverIDMap);
        //Update field on Proposal Object
        if(proposalApproverIDMap.values().size() >0 ){
            for(Id propId : proposalApproverIDMap.keySet()){
                if(proposalSOMap != null && proposalSOMap.get(propId) != null){
                    String approverIdString = '';
                    //if the quotation/MSPA already has an approver value we need to consider it
                    if(String.isNotBlank(proposalSOMap.get(propId).APTS_Approver_User_IDs__c)){
                        approverIdString = proposalSOMap.get(propId).APTS_Approver_User_IDs__c;
                    }
                    for(String userId : proposalApproverIDMap.get(propId)){
                        if(!approverIdString.contains(userId)){
                            approverIdString += userId;
                        }
                    }
                    proposalSOMap.get(propId).APTS_Approver_User_IDs__c = approverIdString;
                }
            }
        }
        System.Debug('## proposalSOMap2 : '+proposalSOMap);
        //Update proposals
        if(proposalSOMap != null && proposalSOMap.values().size() >0){
            try{
                APTS_ProcessorControl.isByPassTriggerOnDML = true;
                update proposalSOMap.values();
            } catch(Exception ex){
                
            }
        }

        
        // For each of the Agreement records being inserted, do the following:
        for(Apttus_Approval__Approval_Request__c approvalRequestSo : agreementApprovalRequestSoLst) {
            
            if(approvalRequestSo.Apttus_Approval__Object_Type__c =='Apttus__APTS_Agreement__c'
                 && ( (approvalRequestSo.Apttus_Approval__HasDelegateApprover__c 
                        && approvalREquestSo.Apttus_Approval__DelegateApprover__c != null
                        && String.ValueOf(approvalRequestSo.Apttus_Approval__DelegateApprover__c).startsWith('005'))
                            ||
                      (approvalRequestSo.Apttus_Approval__Assigned_To_Id__c != null 
                        && approvalRequestSo.Apttus_Approval__Assigned_To_Id__c.startsWith('005'))
                    )
              ) {
                //Add string
                If(agreementApproverIDMap.get(approvalRequestSo.Apttus_Approval__Object_Id__c) != null){
                    agreementApproverIDMap.get(approvalRequestSo.Apttus_Approval__Object_Id__c).add(approvalREquestSo.Apttus_Approval__Assigned_To_Id__c+';');
                    //Delegate approvers
                    if( approvalRequestSo.Apttus_Approval__HasDelegateApprover__c
                        && approvalREquestSo.Apttus_Approval__DelegateApprover__c!=null) {
                        agreementApproverIDMap.get(approvalRequestSo.Apttus_Approval__Object_Id__c).add(approvalREquestSo.Apttus_Approval__DelegateApprover__c+';');                        
                    }
                }
            }
        }
        
        if(agreementApproverIDMap.values().size() >0 ){
            for(Id agreementId : agreementApproverIDMap.keySet()){
                if(agreementSOMap != null && agreementSOMap.get(agreementId) != null){
                    String approverIdString = '';
                    //if the quotation/MSPA already has an approver value we need to consider it
                    if(String.isNotBlank(agreementSOMap.get(agreementId).APTS_Approver_User_IDs__c)){
                        approverIdString = agreementSOMap.get(agreementId).APTS_Approver_User_IDs__c;
                    }
                    
                    for(String userId : agreementApproverIDMap.get(agreementId)){
                        if(!approverIdString.contains(userId)){
                            approverIdString += userId;
                        }
                    }
                    agreementSOMap.get(agreementId).APTS_Approver_User_IDs__c = approverIdString;
                }
            }
        }
        
        //Update agreements
        if(agreementSOMap != null && agreementSOMap.values().size() >0){
            try{
                APTS_ProcessorControl.isByPassTriggerOnDML = true;
                update agreementSOMap.values();
            } catch(Exception ex){
                
            }
        }
    }
    
    public void removeApproverIdsOnParentRecord(List<Apttus_Approval__Approval_Request__c> removedApprovalRequestSoLst) {
        
        // Apttus__APTS_Agreement__Share  is the "Share" table that was created when the
        // Organization Wide Default sharing setting was set to "Private".
        // Allocate storage for a list of Apttus__APTS_Agreement__Share  records.
        List<Apttus_Approval__Approval_Request__c> proposalApprovalRequestSoLst = New List<Apttus_Approval__Approval_Request__c>();
        List<Apttus_Approval__Approval_Request__c> agreementApprovalRequestSoLst = New List<Apttus_Approval__Approval_Request__c>();
        
        Set<Id> proposalIdSet = New Set<Id>();
        Set<Id> agreementIdSet = New Set<Id>();
        
        Map<Id,Set<String>> agreementApproverIDMap = new Map<Id,Set<String>>();
        Map<Id,Apttus__APTS_Agreement__c> agreementSOMap;
        
        Map<Id,Set<String>> proposalApproverIDMap= new Map<Id,Set<String>>();
        Map<Id,Apttus_Proposal__Proposal__c> proposalSOMap;
        
        for(Apttus_Approval__Approval_Request__c approvalRequestSo : removedApprovalRequestSoLst) {
            
            if(approvalRequestSo.Apttus_Approval__Object_Type__c == 'Apttus_Proposal__Proposal__c') {
                proposalApprovalRequestSoLst.add(approvalRequestSo);
                proposalIdSet.add(approvalRequestSo.Apttus_Approval__Object_Id__c);
                proposalApproverIDMap.put(approvalRequestSo.Apttus_Approval__Object_Id__c,new Set<String>());
                
            } else if (approvalRequestSo.Apttus_Approval__Object_Type__c == 'Apttus__APTS_Agreement__c') {
                agreementApprovalRequestSoLst.add(approvalRequestSo);
                agreementIdSet.add(approvalRequestSo.Apttus_Approval__Object_Id__c);
                agreementApproverIDMap.put(approvalRequestSo.Apttus_Approval__Object_Id__c,new Set<String>());
            }
        }
        
        if(!proposalApproverIDMap.keySet().isEmpty()){
            proposalSOMap = new Map<id,Apttus_Proposal__Proposal__c>([SELECT Id,APTS_Approver_User_IDs__c
                                                                       FROM Apttus_Proposal__Proposal__c 
                                                                       WHERE Id IN: proposalApproverIDMap.keySet() ]);
        }
        
        if(!agreementApproverIDMap.keySet().isEmpty()){
            agreementSOMap = new Map<id,Apttus__APTS_Agreement__c>([SELECT Id,APTS_Approver_User_IDs__c 
                                                                       FROM Apttus__APTS_Agreement__c 
                                                                       WHERE Id IN: agreementApproverIDMap.keySet() ]);
        }
        
        // For each of the Agreement records being inserted, do the following:
        for(Apttus_Approval__Approval_Request__c approvalRequestSo : proposalApprovalRequestSoLst) {
            
            if( approvalRequestSo.Apttus_Approval__Object_Type__c =='Apttus_Proposal__Proposal__c' 
                  && ( (approvalRequestSo.Apttus_Approval__HasDelegateApprover__c 
                          && approvalREquestSo.Apttus_Approval__DelegateApprover__c!=null
                          && String.ValueOf(approvalRequestSo.Apttus_Approval__DelegateApprover__c).startsWith('005'))
                                ||
                       (approvalRequestSo.Apttus_Approval__Assigned_To_Id__c != null 
                          && approvalRequestSo.Apttus_Approval__Assigned_To_Id__c.startsWith('005'))
                     )
              ) {
                //Add string
                If(proposalApproverIDMap.get(approvalRequestSo.Apttus_Approval__Object_Id__c) != null){
                    proposalApproverIDMap.get(approvalRequestSo.Apttus_Approval__Object_Id__c).add(approvalREquestSo.Apttus_Approval__Assigned_To_Id__c+';');
                    //Delegate approvers
                    if( approvalRequestSo.Apttus_Approval__HasDelegateApprover__c
                        && approvalREquestSo.Apttus_Approval__DelegateApprover__c!=null) {
                        proposalApproverIDMap.get(approvalRequestSo.Apttus_Approval__Object_Id__c).add(approvalREquestSo.Apttus_Approval__DelegateApprover__c+';');                        
                    }
                }
            }
        }

        //Update field on Proposal Object
        if(proposalApproverIDMap.values().size() >0 ){
            for(Id propId : proposalApproverIDMap.keySet()){
                if(proposalSOMap != null && proposalSOMap.get(propId) != null && String.isNotBlank(proposalSOMap.get(propId).APTS_Approver_User_IDs__c)){
					String userIDString = proposalSOMap.get(propId).APTS_Approver_User_IDs__c;
                    for(String userId : proposalApproverIDMap.get(propId)){
                        userIDString = userIDString.remove(userId);
                    }
                    proposalSOMap.get(propId).APTS_Approver_User_IDs__c = userIDString;
                }
            }
        }

        //Update proposals
        if(proposalSOMap != null && proposalSOMap.values().size() >0){
            try{
                APTS_ProcessorControl.isByPassTriggerOnDML = true;
                update proposalSOMap.values();
            } catch(Exception ex){
                
            }
        }

        
        // For each of the Agreement records being inserted, do the following:
        for(Apttus_Approval__Approval_Request__c approvalRequestSo : agreementApprovalRequestSoLst) {
            
            if( approvalRequestSo.Apttus_Approval__Object_Type__c =='Apttus__APTS_Agreement__c'
                 && ( (approvalRequestSo.Apttus_Approval__HasDelegateApprover__c 
                        && approvalREquestSo.Apttus_Approval__DelegateApprover__c != null
                        && String.ValueOf(approvalRequestSo.Apttus_Approval__DelegateApprover__c).startsWith('005'))
                            ||
                      (approvalRequestSo.Apttus_Approval__Assigned_To_Id__c != null 
                        && approvalRequestSo.Apttus_Approval__Assigned_To_Id__c.startsWith('005'))
                    )
              ) {
                //Add string
                If(agreementApproverIDMap.get(approvalRequestSo.Apttus_Approval__Object_Id__c) != null){
                    agreementApproverIDMap.get(approvalRequestSo.Apttus_Approval__Object_Id__c).add(approvalREquestSo.Apttus_Approval__Assigned_To_Id__c+';');
                    //Delegate approvers
                    if( approvalRequestSo.Apttus_Approval__HasDelegateApprover__c
                        && approvalREquestSo.Apttus_Approval__DelegateApprover__c!=null) {
                        agreementApproverIDMap.get(approvalRequestSo.Apttus_Approval__Object_Id__c).add(approvalREquestSo.Apttus_Approval__DelegateApprover__c+';');                        
                    }
                }
            }
        }
        
        if(agreementApproverIDMap.values().size() >0 ){
            for(Id agreementId : agreementApproverIDMap.keySet()){
                if(agreementSOMap != null && agreementSOMap.get(agreementId) != null && String.isNotBlank(agreementSOMap.get(agreementId).APTS_Approver_User_IDs__c)){
					String userIDString = agreementSOMap.get(agreementId).APTS_Approver_User_IDs__c;
                    for(String userId : agreementApproverIDMap.get(agreementId)){
                        userIDString = userIDString.remove(userId);
                    }
                    agreementSOMap.get(agreementId).APTS_Approver_User_IDs__c = userIDString;
                }
            }
        }
        
        //Update agreements
        if(agreementSOMap != null && agreementSOMap.values().size() >0){
            try{
                APTS_ProcessorControl.isByPassTriggerOnDML = true;
                update agreementSOMap.values();
            } catch(Exception ex){
                
            }
        }
    }
}