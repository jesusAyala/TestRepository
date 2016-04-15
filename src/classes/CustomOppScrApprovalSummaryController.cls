/**
 *  Apttus Approvals Management
 *  CustomOppScrApprovalSummaryController
 *   
 *  @2012-2013 Apttus Inc. 
 */
public with sharing class CustomOppScrApprovalSummaryController {
  
  // field names
  private static final String FIELD_NAME_ID = 'Id';
  
  // state
  
  // OpportunityScreening object
  private Opportunity_Screening__c OpportunityScreeningSO = null;
  
  /**
   * Class Constructor specifying initial values
   * @param stdController the standard controller
   */
    public CustomOppScrApprovalSummaryController(ApexPages.StandardController stdController) {
      
      // get the approval rule sobject
    Apttus_Approval__Approval_Request__c requestSO = (Apttus_Approval__Approval_Request__c) stdController.getRecord();
    
    // get the OpportunityScreening sobject
    this.OpportunityScreeningSO = getOpportunityScreeningSO(requestSO.Apttus_Approval__Object_Id__c);
    
    }
    
    /**
   * Gets the OpportunityScreening sobject
   * @return the OpportunityScreening sobject
   */
  public Opportunity_Screening__c getOpportunityScreeningSO() {
    return OpportunityScreeningSO;
    
  }
  
  /**
   * Gets the OpportunityScreening sobject for the given OpportunityScreening id
   * @param OpportunityScreeningId the OpportunityScreening id
   * @return the OpportunityScreening sobject
   */
  private static Opportunity_Screening__c getOpportunityScreeningSO(ID OpportunityScreeningId) {
    
    // build the opportunity query
    String qryStr = 'SELECT ';
    
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
    
    }
    
    qryStr += ' FROM ' + Opportunity_Screening__c.getSObjectType();
    qryStr += ' WHERE ';
    qryStr += FIELD_NAME_ID + ' = :OpportunityScreeningId';
    
    qryStr += ' LIMIT 1';
  
    // get the Opportunity_Screening__c sobjects
    List<Opportunity_Screening__c> OpportunityScreenings = Database.query(qryStr);
    
    return (!OpportunityScreenings.isEmpty() ? OpportunityScreenings[0] : null);
    
  }
  
}