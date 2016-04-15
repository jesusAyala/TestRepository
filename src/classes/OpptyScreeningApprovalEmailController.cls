/**
 *  Apttus Approvals Management
 *  OpptyScreeningApprovalEmailController 
 *  
 *  Created as part of R5 - AWA
 *  @2016-2017 Apttus Inc. 
 */
public with sharing class OpptyScreeningApprovalEmailController {
    
    // field names
    private static final String FIELD_NAME_ID = 'Id';
    
    // state
    
    // context controller
    private Apttus_Approval.ContextApprovalEmailController context = null;
    // Opportunity_Screening__c sobject
    private Opportunity_Screening__c OpportunityScreeningSO = null;
    
    /**
     * Class Constructor
     */
    public OpptyScreeningApprovalEmailController () {
        // create the context
        this.context = new Apttus_Approval.ContextApprovalEmailController();
        
    }
    
    /**
     * Gets the context controller
     * @return the context controller
     */
    public Apttus_Approval.ContextApprovalEmailController getContext() {
        return context;
        
    }
    
    /**
     * Gets the Opportunity_Screening__c sobject
     * @return the Opportunity_Screening__c sobject
     */
    public Opportunity_Screening__c getOpportunityScreeningSO() {
    try{
        
        if (OpportunityScreeningSO == null) {
            Apttus_Approval__Approval_Request__c requestSO = Context.getRequestSO();
            // make sure the object id is available. Email Template preview will not have it populated,
            // in which Opportunity_Screening__c we create an empty Opportunity_Screening__c object
            OpportunityScreeningSO = (requestSO.Apttus_Approval__Object_Id__c != null 
                      ? getOpportunityScreeningSO(requestSO.Apttus_Approval__Object_Id__c) 
                      : new Opportunity_Screening__c());
            
        }
        
        return OpportunityScreeningSO;
        }catch(DMLException e){  string err = e.getmessage();}
        return null;
    }
    
    /**
     * Gets the Opportunity_Screening__c sobject for the given Opportunity_Screening__c id
     * @param OpportunityScreeningId the OpportunityScreening id
     * @return the OpportunityScreening sobject
     */
    @TestVisible private static Opportunity_Screening__c getOpportunityScreeningSO(ID OpportunityScreeningId) {
        
        // build the Opportunity_Screening__c query
        /*String qryStr = 'SELECT ';
        
        // get field names from the object 
        List<String> fieldNames = new List<String>();
        
        Integer numFields = 0;
        // add object fields
        Schema.DescribesObjectResult metadata = Opportunity_Screening__c.getSobjectType().getDescribe();
        for (Schema.SObjectField field : metadata.fields.getMap().values()) {
            Schema.DescribeFieldResult fldMetadata = field.getDescribe();
            if (numFields > 0) {
                qryStr += ',';
                
            }
            
            // add the field
            qryStr += fldMetadata.getName();
            
            numFields++;
        
        }*/
        
        String qryStr = ' Select Opportunity__r.id,Opportunity__r.Name,Opportunity__r.Account.Name,Opportunity__r.Account_End_User__r.Name,Opportunity__r.Account.BillingCountry,Opportunity__r.Account_End_User__r.BillingCountry,Opportunity__r.CloseDate,Opportunity__r.StageName,Gate_Status__c,ABB_Location__c,Opportunity_Value_Range__c';
        qryStr += ' FROM ' + Opportunity_Screening__c.getSObjectType();
        qryStr += ' WHERE ';
        qryStr += FIELD_NAME_ID + ' = :OpportunityScreeningId';
        
        qryStr += ' LIMIT 1';
    
        // get the Opportunity_Screening__c sobjects
        List<Opportunity_Screening__c> OpportunityScreenings = Database.query(qryStr);
        
        return (!OpportunityScreenings.isEmpty() ? OpportunityScreenings[0] : null);
        
    }
    
}