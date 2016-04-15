/**
 * TriggerClass -  Include Opportunities into the Account Plan Budget object 
 * Controller for Vf pgae - AccountPlanBudgetOpportunities
 * Release R5
 * @author  Vasanthi A (Accenture)
 * @created 2016-1-12
 * @version 1.0
 * Created
 
  Purpose: To display all the opportunities in the Account Plan.Account hierarchy and to create Budget records for the user selected opportunities.
 
  */
    


public with sharing class ClsAccPlanBudgetOppyList {

    List<OpportunityWrapper> opportunities {get;set;}       
    List<Opportunity> oppyList = new List<Opportunity>();
    List<Account_Plan__c> listAccountPlan = new List<Account_Plan__c>();
    public ApexPages.StandardSetController setCon{get;set;}
    Public String accountPlanId; 
    
    public String divs {get;set;}
    public String bus {get;set;}  
    public string oppName{get;set;}
    public Date expAwardDateFrom{get;set;}
    public Date expAwardDateTo{get;set;}
    public string prodGrp{get;set;}
    public string stage{get;set;}
    public Opportunity opp1 {get;set;}
    public opportunity opp2 {get;set;}
    public String sortDirection{get;set;}
    public String sortingColumn{get;set;}  
    public Boolean isSavehBtnClicked {get;set;}
    public Boolean isAnyError {get;set;}
    public String selectedOpt {get;set;}
    public String selectedOppId{get;set;}
    
    Account_Plan__c accPlan;
    Id rootAccount;
    String basicQuery;  
    String OriginalQuery;  
    
    Set<Id> SelectedOppIDSet = new Set<Id>(); 
    Set<Id> accIDSet = new Set<Id>();
    Set<Id> existingBudgetOppIdSet = new Set<Id>();
    
    List<String> orderByList = new List<String>();
    List<String> displayOptList = new List<String>();
    
    //Constructor
    public ClsAccPlanBudgetOppyList(ApexPages.StandardSetController controller){ 
        
        Map<Id, Id> parentChildMap = new Map<Id, Id>();
        Map<Id, Id> accIdAndTopParIdMap = new Map<Id, Id>();
        accountPlanId = ApexPages.currentPage().getParameters().get(Label.ApexClass_id); 
        
        isSavehBtnClicked = FALSE;
        isAnyError = FALSE;
        orderByList.addAll(Label.order_by_ASC_DESC.split(Label.CL00069)); //Label.CL00069 = comma(,) Label.order_by_ASC_DESC = ASC, DESC
        sortingColumn = Label.System_Name;
        sortDirection = orderByList[0];
        displayOptList.addAll(Label.Default_display_Option.split(Label.CL00069)); //0-All 1-Selected 2-Unselected
        selectedOpt = displayOptList[0]; 
        Id accId;
        opp1 = new Opportunity();
        opp2 = new Opportunity();
        
        
        if (accountPlanId != NULL) {
        
            Account_Plan__c[] accPlanList = [SELECT Id, Account__c, Account__r.Root_Account_GUID__c, Account_Plan_Year__c FROM Account_Plan__c WHERE Id = :accountPlanId AND Account__c != NULL LIMIT 1];
            
             if (accPlanList.size() > 0) {
            
                accPlan = accPlanList[0];
                
                String GUID = (accPlan.Account__r.Root_Account_GUID__c != NULL) ? accPlan.Account__r.Root_Account_GUID__c : '';
                
                if (!String.isBlank(GUID)) {
                    
                    Map<Id, Account> accountMap = new Map<Id, Account> ([ SELECT Id FROM Account WHERE Root_Account_GUID__c = :GUID ]);
                    accIDSet.addAll(accountMap.KeySet());
                } 
                
                basicQuery = 'SELECT Id, Name, StageName, Technical_Amount_USD__c, Account.Primary_Address_Country__c, AccountId, Account.Name,CloseDate, Probability, Sales_Pursuit_Progress__c,Product_Group__c, Opportunity_Value__c, Target__c, Commit__c, End_User_Project__c, Confidence_Level__c, Business_Unit__c, Division__c, Owner.Name, Alternative_Opportunity_To__r.Name FROM Opportunity WHERE (AccountId IN: accIDSet)';
                OriginalQuery = basicQuery;
                
                setCon = new ApexPages.StandardSetController ( 
                     Database.getQueryLocator([SELECT Id, Name, Technical_Amount_USD__c, Account.Primary_Address_Country__c, AccountId, Account.Name,Probability, StageName, CloseDate, Sales_Pursuit_Progress__c , Product_Group__c, Opportunity_Value__c, Target__c, Commit__c, End_User_Project__c, Confidence_Level__c, Business_Unit__c, Division__c,
                     Owner.Name, Alternative_Opportunity_To__r.Name FROM Opportunity WHERE (AccountId IN: accIDSet)  ORDER BY Name LIMIT 10000]));    
            
                setCon.SetPageSize(20);
            }
            Integer limitRows = Limits.getLimitQueryRows() - Limits.getQueryRows();
            for (Budget_Opp__c opp:[ SELECT Id, Opportunity_Name__C FROM Budget_Opp__c WHERE Account_Plan__c =:accPlan.Id LIMIT :limitRows ] ) {
                existingBudgetOppIdSet.add(opp.Opportunity_Name__c);
            }
        }        
    }
    
    //To display the opportunity in page
    public List<OpportunityWrapper> getOpportunities(){
    
         List<OpportunityWrapper> opportunityList = new List<OpportunityWrapper>();
         
         for(Opportunity opp : (List<Opportunity>) setCon.getRecords()){
             
             OpportunityWrapper wrap = new OpportunityWrapper();
             wrap.oppty = opp;
             wrap.selected = (SelectedOppIDSet.contains(opp.Id)) ? TRUE : FALSE ;
             wrap.isAlreadyExists = (existingBudgetOppIdSet.contains(opp.Id)) ? TRUE : FALSE ;
             wrap.selected = (wrap.isAlreadyExists) ? TRUE: wrap.selected;
             opportunityList.add(wrap);
         }
         return opportunityList;
    }   
    
    
    //Option All, Selected and Unselected
    public List<SelectOption> getdisplayOpt (){
        
        return new List<SelectOption>{new SelectOption(displayOptList[0], displayOptList[0]), new SelectOption(displayOptList[1], displayOptList[1]), new SelectOption(displayOptList[2], displayOptList[2])};
    }
    
    //To dynamically retrieve User Division
    public List<SelectOption> getDivItems(){
        List<SelectOption> DivisionOpts = new List<SelectOption>{new SelectOption('', Label.System_None_Pick_Value)};
        Schema.DescribeFieldResult familyPickValues = User.Division_DIV__c.getDescribe();
       
        for(Schema.Picklistentry sp: familyPickValues.getPicklistValues() ){
            DivisionOpts.add(new SelectOption(sp.getValue(), sp.getLabel()));
        }
        return DivisionOpts ;
    }
    
    //To dynamically retrieve User BU
    public List<SelectOption> getBUitems(){
        
        List<SelectOption> BUOpts = new List<SelectOption>{new SelectOption('', Label.System_None_Pick_Value)};
        Schema.DescribeFieldResult familyPickValues = User.Business_Unit_BU__c.getDescribe();
       
        for(Schema.Picklistentry sp: familyPickValues.getPicklistValues() ){
            
            String val = sp.getValue();
            
            if (val.contains(Label.System_hyphen)) {
                
                String[] st = val.split(Label.System_hyphen);
                val = st[0].trim();
            }
            
            BUOpts.add(new SelectOption(val, val));
        }
        return BUOpts;
    }
    
     //To change dispalying records
    public void changeDisplayingRecords() {
        
        String st = selectedOppId;
        addSelectedIds(st);
        String query;
        sortingColumn = Label.System_Name;
        sortDirection = orderByList[0];
        
        if (selectedOpt == displayOptList[0]) {
            query = basicQuery ;
        }
        
        if (selectedOpt == displayOptList[1]) {
            query = basicQuery + ' AND (Id IN :SelectedOppIDSet OR ID IN :existingBudgetOppIdSet)';
        } 
        
        if (selectedOpt == displayOptList[2]) {
            query = basicQuery + ' AND (Id NOT IN :SelectedOppIDSet AND ID NOT IN :existingBudgetOppIdSet)';
        } 
        
        //basicQuery = query;
        setCon = new ApexPages.StandardSetController(Database.getQueryLocator(query + ' ORDER BY Name Limit 10000'));
    }
    
    //Find the opportunity based on filter values
    public PageReference SearchOppRecords() {
        
        sortingColumn = Label.System_Name;
        sortDirection = orderByList[0];
        String query = 'SELECT Id, Name, AccountId, Account.Primary_Address_Country__c, Account.Name,StageName, Technical_Amount_USD__c, CloseDate, Probability, Sales_Pursuit_Progress__c,Product_Group__c, Opportunity_Value__c, Target__c, Commit__c, End_User_Project__c, Confidence_Level__c, Business_Unit__c, Division__c, Owner.Name, Alternative_Opportunity_To__r.Name FROM Opportunity WHERE (AccountId IN: accIDSet)';
        SelectedOppIDSet.clear();
       
        Date fromDt = (opp1.CloseDate != NULL) ? opp1.CloseDate : NULL;
        Date toDate = (opp2.CloseDate != NULL) ? opp2.CloseDate : NULL;
        
        query += (divs != NULL) ? ' AND Division__c = \'' + divs + '\'' : '';
        query += (bus != NULL) ? ' AND Business_Unit__c = \'' + bus+ '\'' : '';
        query += (String.ISblank(prodGrp) == FALSE) ? ' AND Product_Group__r.Name Like \'%'+ prodGrp +'%\'' : '';
        query += (fromDt != NULL) ? ' AND CloseDate >= :fromDt' : '';
        query += (toDate != NULL) ? ' AND CloseDate <= :toDate ' : '';
        query += (oppName != '') ? ' AND Name Like \'%'+ oppName +'%\'' : '';
        query += (opp1.StageName != '' && opp1.StageName != NULL) ? ' AND StageName = \'' + opp1.StageName + '\'' : '';
        
        basicQuery = query;
        if (selectedOpt == displayOptList[1]) {
            query = query+ ' AND (Id IN :SelectedOppIDSet OR ID IN :existingBudgetOppIdSet)';
        } 
        
        if (selectedOpt == displayOptList[2]) {
            query = query+ ' AND (Id NOT IN :SelectedOppIDSet AND ID NOT IN :existingBudgetOppIdSet)';
        } 
       
        setCon = new ApexPages.StandardSetController(Database.getQueryLocator(query + ' ORDER BY Name Limit 10000'));
        return null;
    }
    
   //Sorting
    public PageReference sortRecordsByColumn() {
        
        sortDirection = (sortDirection == orderByList[0]) ? orderByList[1] : orderByList[0]; //orderByList[0] - ASC orderByList[1] DESC
        setCon = new ApexPages.StandardSetController(Database.getQueryLocator(basicQuery + ' ORDER BY '+ sortingColumn + ' ' + sortDirection + ' NULLS LAST Limit 10000'));
        return null;
    }
    
    //Create Budgeted Opportunity records for the selected opportunity
    public pagereference SaveBudget(){
        
        isSavehBtnClicked = TRUE;
        isAnyError = FALSE;
        
        List<Budget_Opp__c> listBudToInsert = new List<Budget_Opp__c>();
        
        String st = selectedOppId;
        addSelectedIds(st);
        Integer limitRows = Limits.getLimitQueryRows() - Limits.getQueryRows();
       
        for(Opportunity opp :  [ SELECT Id, Name, Probability, AccountId, Account.Primary_Address_Country__c, Technical_Amount_USD__c, CurrencyISOCode, StageName, CloseDate, Sales_Pursuit_Progress__c , Product_Group__c, Opportunity_Value__c, Target__c, Commit__c, End_User_Project__c, Confidence_Level__c, Business_Unit__c, Division__c,
                 Owner.Name, Alternative_Opportunity_To__r.Name FROM Opportunity WHERE ID IN :SelectedOppIDSet AND ID NOT IN:existingBudgetOppIdSet LIMIT :limitRows ]) {       
            
            listBudToInsert.add( new Budget_Opp__c( Opportunity_Name__c = opp.Id, CurrencyISOCode = opp.CurrencyISOCode,
            Account_Customer_Primary_Address_Country__c = opp.Account.Primary_Address_Country__c,
                Account_Plan__c = accountPlanId, ABB_Sales_Stage__c = opp.StageName,  Account_Customer__c = opp.AccountId,         
                BU__c = opp.Business_Unit__c, Commit__c = opp.Commit__c, DIV__c = opp.Division__c, Confidence_Level__c = opp.Confidence_Level__c, 
                Expected_Award_Date__c = opp.CloseDate, End_User_Project__c = opp.End_User_Project__c, Opportunity_Value__c = opp.Opportunity_Value__c,
                Include__c = TRUE, Target__c = opp.Target__c, Opportunity_Owner__c = opp.Owner.Name, PG__c = opp.Product_Group__c,
                Alternative_Opportunity__c = opp.Alternative_Opportunity_To__c, Opportunity_Value_USD__c = opp.Technical_Amount_USD__c
            ));           
            
        }
        if(listBudToInsert.size() > 0){
            
            try { 
                insert listBudToInsert;
            
            } catch (DmlException de) {
                
                String error = '';
                isAnyError = TRUE;
                for(Integer i=0;i<de.getNumDml();i++) {
                    
                    error += de.getDmlMessage(i) +Label.Line_Break; 
                }
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, error));
                return null;
            }   
                
            
        }
        
        return null;
    
    }
    
    //Go to Account plan record
    public PageReference goToAccPlan() {
        PageReference pageref = (accountPlanId != NULL) ? new PageReference(Label.System_CL00020 + accountPlanId) : NULL;
        return pageref;
    }
    
    //Go to Account plan record
    public PageReference cancel() {        
        PageReference pageref = (accountPlanId != NULL) ? new PageReference(Label.System_CL00020 + accountPlanId) : NULL;
        return pageref;
    }
    
    
    //previous page number
    public Boolean getHasPrevious(){ 
        return this.setCon.getHasPrevious(); 
    }
 
    //next number
    public Boolean getHasNext(){ 
        return this.setCon.getHasNext(); 
    }
 
    //current page number
    public Integer getPageNumber(){ 
        return this.setCon.getPageNumber(); 
    }
    
    //Total page count
    Public Integer getTotalPages(){
 
        Decimal totalSize = this.setCon.getResultSize();
        Decimal pageSize = this.setCon.getPageSize();
 
        Decimal pages = totalSize/pageSize;
 
        return (Integer)pages.round(System.RoundingMode.CEILING);
    }
    
    //Go next
    public void doNext() { 
        
        String st = selectedOppId;
        addSelectedIds(st);
        
        if (this.setCon.getHasNext())  {
            this.setCon.next(); 
        }           
    }
 
    // returns the first page of records
    public void first() {
    
        String st = selectedOppId;
        addSelectedIds(st);
        this.setCon.first();
    }

    //returns the last page of records
    public void last() {
    
        String st = selectedOppId;
        addSelectedIds(st);
        this.setCon.last();
    }
    
    public void addSelectedIds(String st) {
        
        //selectedProductQualIds = '';
        List<Id> str = new List<Id>();
        if (st != null && !String.isBlank(st)) {
             if (st.contains(Label.CL00069)){             //Label.CL00069 - semi colon   
                str = st.split(Label.CL00069);
            } else {
                str.add(st);
            }   
            SelectedOppIdSet.addAll(str);
        }
    }
    
    //go previous
    public void doPrevious(){ 
        
        //To keep the selected id during navigation (pagination)
        String st = selectedOppId;
        addSelectedIds(st);       
        if(this.setCon.getHasPrevious())  this.setCon.previous();   
    }
    
    //Opportunity inner class    
    public class OpportunityWrapper {        
        public Opportunity oppty{get; set;}        
        public Boolean selected {get; set;}
        public Boolean isAlreadyExists {get;set;}
    }

    
}