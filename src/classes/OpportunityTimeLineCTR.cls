/*********************************
* Name: OpportunityTimeLineCntr 
**********************************
* Author:   jens.becker@salesforce.com
* Purpose:  Controller Extension for the Opportunity Header page to display the time line and additional information.
* Created Date: 2015-3-5
**********************************
* <Modification History>
* <initials> - <date> - <reason for update>
* Jens Becker    2014-10-18      Created Class Container to identify a workable solution
*                     - <what was changed/added> 
* Sajila Kadayaprath 2016-02-12  Added method to return the edit page when a user double clicks on 
*                                ABB Sales Stages from the inline vf chart in the opportunity.
*/
public without sharing class OpportunityTimeLineCTR {
    
    public Opportunity opp;
    public String currentStage {get;set;}
    public String currentCustomerBuyingPath {get;set;}
    public boolean approvalRunning {get;set;}
    //public String changedStage {get;set;}
    public String testurl{get;set;}
    public String oppId{get;set;}
    
    /*  Description of the purpose of the class. 
    *  @name StageClass
    */
    public with sharing class StageClass{
        public String Name{
            get;
            set;
        }
        public String Color{
            get;
            set;
        }
        public String formalStage{
            get;
            set;
        }
    }
    
    public String Stage{get;set;}
    
    /*  Description of the purpose of the method. 
    *  @name getStage()
    */   
    public String getStage() {
        return Stage;
    }
    
    /*  Description of the purpose of the method. 
    *  @name setStage()
    */                
    public void setStage(String Stage) { this.Stage= Stage; }
    
    /*  Description of the purpose of the method. 
    *  @name OpportunityTimeLineCTR()
    *  @Description Constructor for the OpenPopup page
    */
    public OpportunityTimeLineCTR() {
        Stage =null;
    }

    /*  Description of the purpose of the method. 
    *  @name OpportunityTimeLineCTR()
    *  @Description Constructor for the Opportunity TimeLine page
    */
    public OpportunityTimeLineCTR(ApexPages.StandardController stdController) {
        //stdController.addFields(new List<String>{'StageName','RecordType.DeveloperName','isClosed','isWon', 'Customer_Buying_Path__c'});
        testurl = '#';
        oppId= apexpages.currentpage().getparameters().get(System.label.ApexClass_id); // ApexClass_id => 'id'
        this.opp = (Opportunity)stdController.getRecord();
        for(Opportunity oppy : [select Id, StageName, RecordType.DeveloperName, isClosed, isWon, Customer_Buying_Path__c from Opportunity where Id = :this.opp.Id limit 1]){
            this.opp = oppy;
        }
        //system.debug(opp);
        this.currentStage = opp.StageName; 
        this.currentCustomerBuyingPath = opp.Customer_Buying_Path__c; 
        this.approvalRunning = false;
    }
    
    /*  Description of the purpose of the method. 
    *  @name getItems()
    *  @Description Returns the list of closed/cancelled stages
    */
     public List<SelectOption> getItems() {
     try{
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption(System.label.Closed_Won1,System.label.Closed_Won1));
        options.add(new SelectOption(System.label.Closed_Lost,System.label.Closed_Lost));
        options.add(new SelectOption(System.label.Closed_Cancelled,System.label.Closed_Cancelled)); 
        options.add(new SelectOption(System.label.Closed_Lost_Without_ABB_Bid,System.label.Closed_Lost_Without_ABB_Bid)); 
        return options; 
    }catch(Exception e){String err=e.getMessage();return null;}
    }
    
    /*  Description of the purpose of the method. 
    *  @name getOppStages()
    *  @Description Returns the list of Opportunity stages
    */
    public Map<String,StageClass> getOppStages() {
    try{
        String x_recordType = this.opp.RecordType.DeveloperName;
        List<OpportunityStages__c> oppStageList = OpportunityStages__c.getAll().Values();
        Map<String,OpportunityStages__c>oppStageMap =OpportunityStages__c.getAll();
        Map<String,StageClass> tmpStages = new Map<String,StageClass>();
        StageClass tmpstgWonCls = new StageClass();
        for (OpportunityStages__c tmpStg : oppStageList){
            StageClass tmpstgCls = new StageClass();

            if(tmpStg.RecordType_Names__c.contains(x_recordType) && !tmpStg.isClosed__c ){
                tmpstgCls.Name = tmpStg.Name;
                tmpstgCls.formalStage = getFormalStage(tmpStg.Name);
                tmpstgCls.Color =    tmpStg.Chevron_Base_Color__c;
                tmpStages.put(String.valueOf(tmpStg.Sorter__c),tmpstgCls);
            }else{
                if(tmpStg.RecordType_Names__c.contains(x_recordType) && tmpStg.isWon__c)
                {
                    tmpstgWonCls.Name = tmpStg.Name;
                    tmpstgWonCls.formalStage = getFormalStage(tmpStg.Name);
                    tmpstgWonCls.Color =    tmpStg.Chevron_Base_Color__c;
                    //tmpStages.put(String.valueOf(tmpStg.Sorter__c),tmpstgWonCls);
                }
            }
        }
        //set last stage
        StageClass tmpstgCls = new StageClass();
        if(this.opp.isClosed && !this.opp.IsWon){
            tmpstgCls.Name = this.opp.StageName;
            tmpstgCls.formalStage = getFormalStage(oppStageMap.get(this.opp.StageName).Name);
            tmpstgCls.Color =    oppStageMap.get(this.opp.StageName).Chevron_Base_Color__c;
            tmpStages.put(String.valueOf(oppStageMap.get(this.opp.StageName).Sorter__c),tmpstgCls);
        }else{
            tmpStages.put(String.valueOf(oppStageMap.get(tmpstgWonCls.Name).Sorter__c),tmpstgWonCls);                
        }
        return tmpStages;
    }catch(Exception e){String err=e.getMessage();return null;}
    }
    
    /*  Description of the purpose of the method. 
    *  @name getOppCustomerBuyingPaths()
    *  @Description Returns the map of Customer Buying Paths in Opportunity 
    */
    public Map<String,StageClass> getOppCustomerBuyingPaths() {
    try{
        Map<String,StageClass> tmpStages = new Map<String,StageClass>();
        
        for(CustomerBuyingPath__c cbp : CustomerBuyingPath__c.getAll().Values()) {
            StageClass tmpstgCls = new StageClass();
            tmpstgCls.Name = cbp.Name;
            tmpstgCls.Color = cbp.Chevron_Base_Color__c;
            tmpstgCls.formalStage = getFormalStage(cbp.Name);
            tmpStages.put(string.valueOf(cbp.Sorter__c), tmpstgCls);
        }
        return tmpStages;
    }catch(Exception e){String err=e.getMessage();return null;}
    }
    
    /*  Description of the purpose of the method. 
    *  @name getSortedStages()
    *  @Description Returns the list of sorted Opportunity stages
    */
    public List<String> getSortedStages(){
    try{
        List<String> tmpStagesSorted = new List<String>();
        tmpStagesSorted.addAll(getOppStages().keySet());
        tmpStagesSorted.sort();
        return tmpStagesSorted;
    }catch(Exception e){String err=e.getMessage();return null;}
    }
    
    /*  Description of the purpose of the method. 
    *  @name getSortedCustomerBuyingPaths()
    *  @Description Returns the list of sorted Customer Buying paths in Opportunity
    */
    public List<String> getSortedCustomerBuyingPaths(){
    try{
        List<String> tmpCustomerBuyingPathsSorted = new List<String>();
        tmpCustomerBuyingPathsSorted.addAll(getOppCustomerBuyingPaths().keySet());
        tmpCustomerBuyingPathsSorted.sort();
        return tmpCustomerBuyingPathsSorted;
      }catch(Exception e){String err=e.getMessage();return null;}
    }
    
    /*  Description of the purpose of the method. 
    *  @name getShowApproval()
    *  @Description Returns false
    */ 
    public boolean getShowApproval(){
    
        return false;
    }

    /*  Description of the purpose of the method. 
    *  @name getFormalStage()
    */
    public String getFormalStage(String p_Stage){
    try{
        String inStr = p_Stage;
        String returnStr = inStr.replace(' - ', '_');
        String returnStr2 =returnStr.replace(' ', '_');
        String returnStr3 =returnStr2.replace('(', '');
        String returnStr4 =returnStr3.replace(')', '');
        return returnStr4;
      }catch(Exception e){String err=e.getMessage();return null;}
    }
    
    /*  Description of the purpose of the method. 
    *  @name getCurrentStage()
    *  @Description Returns current stage
    */ 
    public String getCurrentStage(){
        return currentStage;
    }
    
    /*  Description of the purpose of the method. 
    *  @name getCurrentCustomerBuyingPath()
    *  @Description Returns current Customer buying path
    */
    public String getCurrentCustomerBuyingPath(){
        return currentCustomerBuyingPath;
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
    *  @name Confirm()
    *  @Description This is invoked when a user confirms any of the 4 closed/cancelled stages from the openpopup page 
    */
    public PageReference Confirm() {
         Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
        String oppId= apexpages.currentpage().getparameters().get(System.Label.CL00215); // System.Label.CL00215 => opptyId
        //System.debug('#@#'+oppId);
        //oppId=oppId.substring(0,oppId.length()-1);
        
        Opportunity o=[select id,StageName,Sales_Pursuit_Progress__c,CloseDate,Actual_Bid_Submission_Date_Comm__c,Requested_Bid_Submission_Date_Tech__c,Requested_Bid_Submission_Date_Comm__c  from opportunity where id=:oppId LIMIT :remLimit];
        String oldStage=o.StageName;
        String oldProgress=o.Sales_Pursuit_Progress__c;
        Date oldCloseDate=o.CloseDate;
        if((oldStage.equals(System.label.Stage_Prospecting)||oldStage.equals(System.label.Stage_Opportunity_Pursuit))&&(Stage.equals(System.label.Closed_Lost)||Stage.equals(System.label.Stage_Closed_Won)))
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You cannot Close an Opportunity from Prospecting/Opportunity Pursuit Stage',''));   
            return null;
        }
        else{
        if(Stage.equals(System.label.Closed_Cancelled)){
            o.StageName=System.label.ClosedLost_Cancelled;
            o.Sales_Pursuit_Progress__c = System.label.CLOSED_Cancelled_Pursuit;
        }
        else if(Stage.equals(System.label.Closed_Lost_Without_ABB_Bid))
        {
            o.StageName=Stage;
            o.Sales_Pursuit_Progress__c = System.label.CLOSED_Lost_Without_ABB_Bid_Pursuit;
        }
        else if(Stage.equals(System.label.Closed_Lost))
        {
            o.StageName=Stage;
            o.Sales_Pursuit_Progress__c = System.label.CLOSED_Lost_Pursuit;
        }
        else
        {
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
        try{
            Database.update(o);
            //Pagereference prf=new Pagereference('/'+oppId+'/e?saveURL=%2F'+oppId+'&cancelURL=/apex/Cancel_Oppty_Record_Type_change?stageName='+oldStage+'%26Sales_Pursuit_Progress__c='+ oldProgress +'%26id='+oppId);
            Pagereference prf=new Pagereference(System.label.CL00214+oppId+System.label.CL00212+oppId+System.label.CL00213+oldStage+'%26CloseDate='+oldCloseDate+System.Label.CL002108+ oldProgress +System.Label.CL00205+oppId);
            prf.getParameters().put(System.label.CL00216,oppId);
            prf.getParameters().put(System.label.CL00217,oldStage);
            prf.setRedirect(true);
            return prf;
        }
        catch(DMLException exc)
        {
              string err = exc.getDMLMessage(0);
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,+err,''));
              return null;
        }
        }
    }
    
    //This is invoked when a user clicks cancel from the popup page
   /*  Description of the purpose of the method. 
    *  @name goBack
    *  @Description This is invoked when a user clicks cancel from the popup page
   */
    public pagereference goBack() {
        try{
            String oppId= apexpages.currentpage().getparameters().get(System.Label.CL00215); // System.Label.CL00215 => opptyId
            Pagereference prf=new Pagereference(System.label.CL00214+oppId);
            prf.setRedirect(true);
            return prf;
        }
        catch(Exception e)
        {
            String err=e.getMessage();
            return null;
        }
    }
}