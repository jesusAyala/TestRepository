/**
 * Trigger factory class, centual adapter for all trigger runs
 * - creates trigger according trigger handler, throws ClsTriggerException 
 *      if no handler is registered
 * - uses test run skipper to control tests run or not 
 * - excecutes code logic seperately in before and after trigger context, 
 *      which is defined in according trigger handler itself
 * @author  Jinbo Shan
 * @created 2015-04-20
 * @version 1.0
 * @since   33.0 (Force.com ApiVersion)
 *
 * @changelog
 * 2015-04-20 Jinbo Shan <jinbo.shan@itbconsult.com>
 * - Created
 */
public class ClsTriggerFactory {

    /**
     *  Global test run skipper as privat static member
     */
    public static Boolean isRun = false;
    public static Boolean isFirstTime = false;
    public static Boolean isSkipTrigger = false;
    public static Boolean insertcheck = true;
    public static Boolean competitorUpdate = false;
    /**
     *  Public variable for skip Recursive Trigger
     */
    public static Boolean isSkipRecursiveTrigger = true;
    /**
     *  Public variable for skip LP User check
     */
    public static Boolean isLPUserTrigger = true;
     /**
     *  Public variable for allow user to delete localproduct
     */
    public static Boolean isLocalProductDelete= true;
     /**
     *  Public variable for skip Recursive Trigger
     */
    public static Boolean isSkipOpportunityRecursiveTrigger = true;
    
    /**
     *  Public variable for skip Recursive Trigger
     */
    public static Boolean isSkipRecursiveLSOTrigger = true;
    public static Boolean isSkipRecursiveEUPLSOTrigger = true;
    public static Boolean isSkipRecursiveLSOCaseTrigger = true;
    public static Boolean isSkipRecursiveAltOppTrigger = true;
    public static Boolean isSkipRecursiveVisitReportTrigger = true;
    public static Boolean isSkipOpptyTrigger = false; 
     
    /**
     *  Public variable used in Product Qualification Method check
     */
    public static Boolean prodQualErrorMsg = true;
   
    /**
     *  Test run skippers for all trigger handlers as privat static member in form of map
     */
    public static Map<String, Boolean> map_handler_isSkip = new Map<String, Boolean>();    
    /**
     *  Public static method to create and execute a trigger handler
     *  Throws a ClsTriggerException if no handler has been registered.  
     * @author Jinbo Shan
     * @created 2015-04-21
     * @version 1.0
     * @since 28.0 
     * @param   soType      the Sobject Type, on which the current trigger is running
     * @changelog
     * 2015-04-21 Jinbo Shan <jinbo.shan@itbconsult.com>
     * - Created
     */
    public static void createHandler(Schema.sObjectType soType) {

        // Get a handler appropriate to the object being processed
        IntTrigger handler = getHandler(soType);        
        // Make sure we have a handler registered, 
        //new handlers must be registered in the getHandler method.
        if (handler == null) {
            throw new ClsTriggerException(System.label.System_Trigger_Factory_Exception_Message + soType);
        }        
        // Execute the handler to fulfil the trigger
        execute(handler);
    }
    
    /**
     *  Private static method to control the execution of the handler
     * - trigger test run skipper examination
     * - runs in before trigger context
     * - runs in after trigger context
     * @author Jinbo Shan
     * @created 2015-04-21
     * @version 1.0
     * @since 28.0
     *
     * @param   handler     trigger handler interface
     *
     * @changelog
     * 2015-04-21 Jinbo Shan <jinbo.shan@itbconsult.com>
     * - Created
     */
    private static void execute(IntTrigger handler) {
        Boolean skip = false;

        // The skip flag in the map has a higher priority than global flag
        if (map_handler_isSkip.containsKey(String.valueOf(handler).split(System.label.CL00200)[0])) { // CL00200 --> ':'
            skip = map_handler_isSkip.get(String.valueOf(handler).split(System.label.CL00200)[0]);
        } else if (ClsTriggerFactory.isSkipTrigger) {
            skip = ClsTriggerFactory.isSkipTrigger;
        }else{}        
        if (skip) {
            // The handler should be skipped
            return;
        }

        ClsWrappers.TriggerContext trgCtx = new ClsWrappers.TriggerContext(Trigger.isBefore, Trigger.isAfter, Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.isUndelete, Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);

        // Before Trigger
        if (Trigger.isBefore) {
            // Call the bulk before to handle any caching of data and enable bulkification
            handler.bulkBefore(trgCtx);            
            // Execute business logic in before trigger context
            handler.beforeTrigger(trgCtx);
            
        } else {
            // Call the bulk after to handle any caching of data and enable bulkification
            handler.bulkAfter(trgCtx);
            
            // Execute business logic in after trigger context
            handler.afterTrigger(trgCtx);
            
        }
         
        // Perform any post processing
        handler.andFinally(trgCtx);
    }
    
    /**
     *  Public static method to set global test run skipper
     * @author Jinbo Shan
     * @created 2015-04-21
     * @version 1.0
     * @since 28.0
     *
     * @param   skip        true or false
     *
     * @changelog
     * 2015-04-21 Jinbo Shan <jinbo.shan@itbconsult.com>
     * - Created
     */
    public static void setSkipHandlers(Boolean skip) {
        isSkipTrigger = skip;
    }
    
    /**
     *  Public static method to set test run skipper a specific trigger handler
     *
     *  
     * @author Jinbo Shan
     * @created 2015-04-21
     * @version 1.0
     * @since 28.0
     *
     * @param   handlerName     the hander name as string
     * @param   skip            true or false
     *
     * @changelog
     * 2015-04-21 Jinbo Shan <jinbo.shan@itbconsult.com>
     * - Created
     */
    public static void setSkipHandler(String handlerName, Boolean skip) {
        map_handler_isSkip.put(handlerName, skip);
    }
    
    /**
     *  Private static method to get the appropriate handler for the object type.
     *  Modify this method to register any additional handlers.
     *
     *  
     * @author Jinbo Shan
     * @created 2015-04-21
     * @version 1.0
     * @since 28.0
     *
     * @param   soType      the Sobject Type, on which the current trigger is running
     * @return  IntTrigger  the trigger handler interface if exists, or null
     *
     * @changelog
     * 2015-04-21 Jinbo Shan <jinbo.shan@itbconsult.com>
     * - Created
     */
     /**
     @changelog
     * 2015-07-17 
     * - Modified for Release:3 Abiramasundari Radha (Accenture)     
     */
     
     /**
     @changelog
     * 2015-12-11 
     * - Modified for Release:5 Shankar Anand (Accenture) 
     * - Added handler for OpportunityCompetitorTrigger    
     */
     private static IntTrigger getHandler(Schema.sObjectType soType) {
        
        if (soType == Case.sObjectType) {
            return new ClsTriggerCaseHandler();
        }else if (soType == End_User_Project__c.sObjectType) {
        
            return new ClsTriggerEndUserProjectHandler();
        }
        else if(soType == Opportunity.sObjectType) {
        
            return new ClsTriggerOpportunityHandler();
        }else if(soType == Opportunity_Screening__c.sObjectType) {
            return new ClsTriggerOpportunityScreeningHandler();
        }else if(soType ==  Product_Qualification_Team_Role__c.sObjectType) {
            return new ClsTriggerProductQualificationTeam();
        }else if(soType ==  Capture_Team_Member__c.sObjectType) {
            return new ClsTriggerCaptureTeamMemberHandler();
        }else if(soType ==  Account.sObjectType) {
            return new ClsTriggerAccountHandler();
        }else if(soType ==  Product_Qualification_Level__c.sObjectType) {
            return new ClsTriggerProductQualLevelHandler();
        }else if(soType ==  Player__c.sObjectType) {
            return new ClsTriggerPlayerHandler();
        }else if(soType ==  Qualification_Products_List__c.sObjectType) {
            return new ClsTriggerQualProdListHandler();
        }else if(soType ==  Competitor_Product_Qualification__c.sObjectType) {
            return new ClsTriggerCompetitorProdQual();
        }else if(soType ==  Capture_Team__c.sObjectType) {
            return new ClsTriggerCaptureTeamHandler();
        }else if(soType ==  Contact_Role__c.sObjectType) {
            return new ClsTriggerContactRole();
        }else if(soType == Local_ERP_Loader__c.sObjectType) {
        
            return new ClsTriggerlocalErploaderHandler();
        }
        else if(soType == OpportunityLineItem.sObjectType) {
            
            return new ClsTriggerOpportunityProductHandler();
        }
        else if(soType == ERP_Mapping__c.sObjectType) {
        
            return new ClsTriggerErpMappingHandler();
        } 
        else if(soType == LSO_Field_Entries__c.sObjectType) {
        
            return new ClsTriggerERPDupeHandler();
        }  
        else if(soType == Channel_Qualifications__c.sObjectType) {
        
            return new ClsTriggerChannelQualifications();
        } 
        else if(soType == Competitor__c.sObjectType) {
        
            return new ClsTriggerOpptyCompetitorHandler();
        }
        // Added by Nikhil as part of R5 Integration Requirement R-2678
        else if(soType == EmailMessage.sObjectType) {
        
            return new ClsTriggerEmailMessageHandler();
        }    
        else if(soType == Customer_Segmentation__c.sObjectType) {
        
            return new ClsTriggerCustomerSegmentation();
        }
        else if(soType == Visit_Report_Team_Member__c.sObjectType) {
        
            return new ClsTriggerVisitReportTeamMemberHandler();
        }                             
        else if(soType == Budget__c.sObjectType) {
        
            return new ClsTriggerBudget();
        } else if (soType == Quote_Team_Member__c.sObjectType) { // Added as part of Release 5 Req#2503
        
            return new ClsTriggerQuoteTeamMemberHandler();
        }else if (soType == Account_Plan_Team__c.sObjectType) { // Added as part of Release 5 Req#2503
        
            return new ClsTriggerAccountPlanTeam();
        } else if (soType == Customer_Segmentation_Team__c.sObjectType) { // Added as part of Release 5 Req#2503
        
            return new ClsTriggerCustomerSegmentTeam();
        }else if (soType == Channel_Business_Review__c.sObjectType) { // Added as part of Release 5 Req#2363
        
            return new ClsTriggerChannelBusinessReview();
        } else if (soType == Account_Plan__c.sObjectType) { // Added as part of Release 5 Req#2763
        
            return new ClsTriggerAccountPlan();
        } else if (soType == Joint_Business_Plan__c.sObjectType) { // Added as part of Release 5 Req#2450 AND Req #2746 (KAD-00895)
        
            return new ClsTriggerJointBusinessPlanHandler();
        } else if (soType == Joint_Business_Plan_Product_Lines__c.sObjectType) { // Added as part of Release 5 Req#2182
        
            return new ClsTriggerJBPProductLines();
        } else if (soType == Channel_Market_Coverage_Product_Lines__c.sObjectType) { // Added as part of Release 5 Req#2182
        
            return new ClsTriggerChannelMarCovProductLines();
        } 
        // else if (soType == Channel_Pre_Qualification_Product_Line__c.sObjectType) { // Added as part of Release 5 Req#2182
        
        //    return new ClsTriggerChannelPreQualProductLine();
        //} else if (soType == JBP_Target_Ind_Gowth_Plan__c.sObjectType) { // Added as part of Release 5 Req#2723
        
         //   return new ClsTriggerJBPTargetandGrowth(); }
         else if (soType == Account_Plan_Information__c.sObjectType) { // Added as part of Release 5 Req#2738
        
            //return new ClsTriggerAccountPlanInfo();
        } else if (soType == Contact_Roles__c.sObjectType) { // Added as part of Release 5 Req#
        
            return new ClsTriggerAccountPlanContactRole();
        } else if (soType == Apttus_Proposal__Proposal__c.sObjectType) { // Added as part of Release 5 Req#2504
        
            return new ClsTriggerQuoteHandler();
        } else if (soType == RFP_Team__c.sObjectType) { // Added as part of Release 5 Req#2461
        
            return new ClsTriggerRfpTeamHandler();
        } else if (soType == Budget_Opp__c.sObjectType) { // Added as part of Release 5 Req#2737
        
            return new ClsTriggerBudgetOpp();
        } else if (soType == CampaignMember.sObjectType) { // Added as part of Release 5 integration        
            return new ClsTriggerCampaignMemberHandler();
        } 
        else if (soType == Channel_Market_Coverage__c.sObjectType) { // Added as part of Release 5 Req#2182
        
            return new ClsTriggerChannelMarketCoverageHandler();
        }
        else if (soType == Rfp_Results__c.sObjectType) { // Added as part of Release 5 Req-2461
        
            return new ClsTriggerResultsHandler();
        }
        else if (soType == Rfp_Processing__c.sObjectType) { // Added as part of Release 5 Req-2461
        
            return new ClsTriggerProcessingHandler();
        }else if (soType == Channel_Pre_Qualification_Team__c.sObjectType) {// Added as part of Release 5
            return new ClsTriggerChannelQualificationTeam();
        }else if(soType == ERP_Reference_Data__c.sObjectType) {
        
            return new ClsTriggerLSODupeHandler();
        } 
        else if(soType == OpportunityTeamMember.sObjectType) {
        
            return new ClsTriggerOpportunityTeam();
        } else if (soType == Joint_Business_Plan_Market_Coverage__c.sObjectType) {
             return new ClsTriggerMarketCoverageHandler();
        } else if (soType == Joint_Business_Team__c.sObjectType) {
            return new ClsTriggerJointBusinessTeam();
        } else if (soType == Opportunity_Information__c.sObjectType ) {
             return new ClsTriggerOpportunityInformation ();
        } else if (soType == Joint_Business_Plan_Actions__c.sObjectType ) {
             return new ClsTriggerPlanAction();
        } else if (soType == Market_Expectation__c.sObjectType ) {
             return new ClsTriggerMarketExpectation();
        } else if ( soType == Issues_and_Challenges__c.sObjectType) {
            return new ClsTriggerIssuesAndChallenges();
        }  else if ( soType == Actions__c.sObjectType) {
            return new ClsTriggerAction();
        } else if ( soType == Visit_Report__c.sObjectType) {
            return new ClsTriggerVisitReport();
        } else if (soType == Joint_Business_Plan_Contact_Role__c.sObjectType) {
            return new ClsTriggerJointBusinessPlanContactRole ();
        } else if(soType == Competitors__c.sObjectType) {
            return new ClsTriggerCompetitors();
        } else if (soType == Visit_Attendee__c.sObjectType) {
            return new ClsTriggerVisitReportAttendeeHandler();
        }else {}
        return null;  
    }  

}