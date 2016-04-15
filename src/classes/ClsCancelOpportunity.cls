/**
    @Author Sajila Kadayaprath
    @name ClsCancelOpportunity
    @CreateDate 2/12/2016
    @Description Navigate the user to Close/cancel Opportunity page.
    @Version 1.0
    **/
public without sharing class ClsCancelOpportunity
{
    public Id oppId;
    public String Stage {get; set;}
    public Opportunity o=new Opportunity();
    Id closeOpportunityId= Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(System.label.Close_Opportunity ).getRecordTypeId();
    Id cancelOpportunityId= Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(System.label.Cancel_Opportunity).getRecordTypeId();
 /*  Description of the purpose of the method. 
    *  @name ClsCancelOpportunity
    *  @Description -Constructor for ClsCancelOpportunity
 */  
    public ClsCancelOpportunity(ApexPages.StandardController controller) {
        oppId= ApexPages.currentPage().getParameters().get(System.label.ApexClass_id);
        o=[select id,RecordTypeId,StageName,Sales_Pursuit_Progress__c,CloseDate,Actual_Bid_Submission_Date_Comm__c,Requested_Bid_Submission_Date_Tech__c,Requested_Bid_Submission_Date_Comm__c from Opportunity where Id=:oppId LIMIT 50000];
        Stage =null;
    }
  /*  Description of the purpose of the method. 
    *  @name getItems
 */
    public List<SelectOption> getItems() {
    try{
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption(System.label.Closed_Won1,System.label.Closed_Won1));
        options.add(new SelectOption(System.label.Closed_Lost,System.label.Closed_Lost)); 
        options.add(new SelectOption(System.label.Closed_Cancelled,System.label.Closed_Cancelled)); 
        options.add(new SelectOption(System.label.Closed_Lost_Without_ABB_Bid,System.label.Closed_Lost_Without_ABB_Bid)); 
        return options; 
        }catch(Exception e){String err=e.getMessage();}
         return null ; 
    }
 /*  
    *  @name getStage
*/                   
    public String getStage() {
        return Stage;
    } 
 /*  
    *  @name setStage
*/                 
    public void setStage(String Stage) { this.Stage= Stage; }    
 //This is invoked when a user clicks cancel from the popup page
 /*  Description of the purpose of the method. 
    *  @name goBack
    *  @Description -This is invoked when a user clicks cancel from the popup page
 */ 
    public pagereference goBack() {
    try{
        Pagereference prf=new Pagereference(System.label.CL0001+oppId);
        prf.setRedirect(true);
        return prf;
        }catch(Exception e){String err=e.getMessage();}
         return null; 
    }
   
   //This will check if the current stage is Closed Lost/Closed Won and display a warning message to user to not close the opportunity from Initial layout 
   public PageReference checkInfo(){
        if (Stage.equals(System.label.Closed_Lost)||Stage.equals(System.label.Closed_Won1)) {
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Closed Lost & Closed Won are only valid if the ABB Sales Stage is already Bidding or Negotiation, otherwise you will get an error message.',''));
             //ApexPages.addMessage(ApexPages.severity.Warning,'Closed Lost & Closed Won are only valid if the ABB Sales Stage is already Bidding or Negotiation, otherwise you will get an error message.');
        }
 
        return null;
 
        }
    
 //This is invoked when a user confirms any of the 4 closed/cancelled stages from the openpopup page 
 /*  Description of the purpose of the method. 
    *  @name goBack
    *  @Description - This is invoked when a user confirms any of the 4 closed/cancelled stages from the openpopup page 
 */
    public PageReference Confirm() {
        if(Stage!=null)
        {
                //Date oldActualBidComm=o.Actual_Bid_Submission_Date_Comm__c;
                //Date oldReqBidTech=o.Requested_Bid_Submission_Date_Tech__c;
                //Date oldReqBidComm=o.Requested_Bid_Submission_Date_Comm__c;
                Date oldCloseDate = o.CloseDate;
                
                if((Stage.equals(System.label.Stage_Closed_Lost)||Stage.equals(System.label.Stage_Closed_Won))&&(o.StageName.equals(System.label.Stage_Prospecting)||o.StageName.equals(System.label.Stage_Opportunity_Pursuit))){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You cannot Close an Opportunity from Prospecting/Opportunity Pursuit Stage',''));   
                    return null;
                }
                else{
                String oldProgress = o.Sales_Pursuit_Progress__c;
            //if(Stage.equals(System.label.Closed_Cancelled)||Stage.equals(System.label.Closed_Lost_Without_ABB_Bid)){
                if(Stage.equals(System.label.Closed_Cancelled)){
                    o.StageName=System.label.ClosedLost_Cancelled;
                    o.Sales_Pursuit_Progress__c = System.label.CLOSED_Cancelled_Pursuit;
                }
                else if(Stage.equals(System.label.Closed_Lost_Without_ABB_Bid))
                {
                    o.StageName=Stage;
                    o.Sales_Pursuit_Progress__c = System.label.CLOSED_Lost_Without_ABB_Bid_Pursuit;
                }
               // o.RecordTypeId = cancelOpportunityId;
            //}
                else if(Stage.equals(System.label.Closed_Lost)){
                    o.StageName=Stage;
                    o.Sales_Pursuit_Progress__c = System.label.CLOSED_Lost_Pursuit;
                }
               // o.RecordTypeId= closeOpportunityId;
                else {
                    
                    /*if(o.Actual_Bid_Submission_Date_Comm__c>System.Today()){
                        o.Actual_Bid_Submission_Date_Comm__c=System.Today();
                    }
                    if(o.Requested_Bid_Submission_Date_Tech__c>System.Today()){
                        o.Requested_Bid_Submission_Date_Tech__c=System.Today();
                    }
                    if(o.Requested_Bid_Submission_Date_Comm__c>System.Today()){
                        o.Requested_Bid_Submission_Date_Comm__c=System.Today();
                    }*/
                    o.StageName=Stage;
                    o.Sales_Pursuit_Progress__c = System.label.CLOSED_Won_Pursuit;
                }
            //}
        
           try{
                database.update(o);
                //String recordtypeId = ApexPages.currentPage().getParameters().get('recordTypeId');
                String stageName = ApexPages.currentPage().getParameters().get(System.label.StageName);
                Pagereference prf;
                /*if(Stage.equals(System.label.Stage_Closed_Won)){
                    prf = new Pagereference('/'+oppId+'/e?cancelURL=/apex/Cancel_Oppty_Record_Type_change?StageName='+stageName+'%26oldActualBidComm='+oldActualBidComm+'%26oldReqBidTech'+oldReqBidTech+'%26oldReqBidComm'+oldReqBidComm+'%26CloseDate='+CloseDate+'%26Sales_Pursuit_Progress__c='+oldProgress+'%26id='+oppId+'&saveURL=/'+oppId);
                }*/
                //else{
                    prf = new Pagereference(System.label.CL0001+oppId+System.label.CL00207+System.label.CL00204+stageName+'%26CloseDate='+oldCloseDate+System.Label.CL002108+oldProgress+System.label.CL00205+oppId+System.label.CL00206+oppId);
                //}
                return prf;
           }
           catch(DMLException exc)
           {
              string err = exc.getDMLmessage(0);
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,+err,''));
              return null;
           }
           }
        }
        else return null;
    }
}