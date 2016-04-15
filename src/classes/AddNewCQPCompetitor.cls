/**
    @Author Shankar Anand
    @name AddNewCQPCompetitor
    @CreateDate 12/14/2015
    @Description Add Competitors to CQP Quote
    @Version 1.0
    **/
public without sharing class AddNewCQPCompetitor{
 private final Competitor_CQP__c competitor;
 public List<CompetitorWrapper> competitors {get;set;}       
 List<Competitor__c> opptyComptrs = new List<Competitor__c>();
 Id id;
 public String selectedComptId{get;set;}
 public Boolean dupAcc{
         get{
             if(dupAcc == null){
                 return false;}
             else{
                 return dupAcc;
             }
         }
         set;}
         
   /*  Description of the purpose of the method. 
    *  @name AddNewCQPCompetitor
    *  @Description - Constructor for AddNewCQPCompetitor 
 */
   public AddNewCQPCompetitor(ApexPages.StandardSetController stdController) {
     id= ApexPages.CurrentPage().getParameters().get(System.label.ApexClass_id);
     competitors = new List<CompetitorWrapper>();
     competitors = getCompetitorList();
    }

   public ApexPages.StandardSetController cmptrs {
        get {
            
            if(cmptrs == null) {
                cmptrs = new ApexPages.StandardSetController(Database.getQueryLocator([Select Id, Name, Description__c, Competitor_Code__c, Quote_Proposal__c, Account__c FROM Competitor_CQP__c WHERE Quote_Proposal__c =: id limit 10000]));
            }
            return cmptrs;
        }
        set;
    }

/*  Description of the purpose of the method. 
    *  @name getCompetitorList
    *  @Description -Get the list of Competitors. 
 */
   public List<CompetitorWrapper> getCompetitorList() {
    List<Apttus_Proposal__Proposal__c> quote = [Select id, Name, Apttus_Proposal__Opportunity__c from Apttus_Proposal__Proposal__c WHERE Id=: id LIMIT 50000];
    opptyComptrs = [Select Id, Name, Competitor__c, Opportunity__c, Opportunity__r.Name, Competitor__r.Name from Competitor__c where Opportunity__c =: quote[0].Apttus_Proposal__Opportunity__c order by Competitor__r.Name LIMIT 10000];
    try
    {
    if(((List<Competitor_CQP__c>)cmptrs.getRecords()).isEmpty()){
        competitors = new List<CompetitorWrapper>();
        for(Competitor__c cmt: [Select Id, Name, Competitor__c, Opportunity__c, Opportunity__r.Name, Competitor__r.Name from Competitor__c where Opportunity__c =: quote[0].Apttus_Proposal__Opportunity__c order by Competitor__r.Name LIMIT 10000]){
           competitors.add(new CompetitorWrapper(cmt));           
        }
       return competitors; 
    }
    else if(((List<Competitor_CQP__c>)cmptrs.getRecords()).size()>0){ 
    competitors = new List<CompetitorWrapper>();
    Map<Id,Competitor__c> dupComptrs = new Map<Id,Competitor__c>(); 
        for(Competitor_CQP__c cmp: (List<Competitor_CQP__c>)cmptrs.getRecords()){
            for(Competitor__c cmt: [Select Id, Name, Competitor__c, Opportunity__c, Opportunity__r.Name, Competitor__r.Name from Competitor__c where Opportunity__c =: quote[0].Apttus_Proposal__Opportunity__c order by Competitor__r.Name LIMIT 10000]){
                if(cmp.Account__c == cmt.Competitor__c){
                   dupComptrs.put(cmt.Id,cmt);  
                }
            }
        } 
   
      for(Competitor__c cmt: [Select Id, Name, Competitor__c, Opportunity__c, Opportunity__r.Name, Competitor__r.Name from Competitor__c where Opportunity__c =: quote[0].Apttus_Proposal__Opportunity__c order by Competitor__r.Name LIMIT 10000]){
           if(!dupComptrs.containsKey(cmt.Id)){
               competitors.add(new CompetitorWrapper(cmt));
           }
        }
     }
     }
    catch(Exception e){String err=e.getMessage();}
    return competitors;      
    }
    
 /*  Description of the purpose of the method. 
    *  @name addSelectedCompetitors
    *  @Description -Adds the selected list of Competitors. 
 */  
    public pageReference addSelectedCompetitors(){
    id = ApexPages.currentPage().getParameters().get(System.label.ApexClass_id);
    List<Competitor_CQP__c> toInsertCQPComptrsList = new List<Competitor_CQP__c>();
    
    for(CompetitorWrapper cwrap: competitors){
        if(cwrap.selected == true){
           Competitor_CQP__c cmp = new Competitor_CQP__c();
           cmp.Account__c = cwrap.compt.Competitor__c;
           cmp.Quote_Proposal__c = id;
           toInsertCQPComptrsList.add(cmp);
        }
    }
    try{
        if(toInsertCQPComptrsList.size()>0){
            Database.Insert(toInsertCQPComptrsList);
        }
    }catch(Exception e){String err=e.getMessage();}
    return new Pagereference(System.label.CL0001+id);
   } 
/*  Description of the purpose of the method. 
    *  @name addCompetitor
 */  
   public pageReference addCompetitor(){
     id = ApexPages.currentPage().getParameters().get(System.label.ApexClass_id);
     Map<Id,Competitor_CQP__c> dupComptrs = new Map<Id,Competitor_CQP__c>();
     List<Competitor_CQP__c> toInsertCQPComptrsList = new List<Competitor_CQP__c>();
     List<Account> randomCompt = [Select Id, Name from Account where Id =:selectedComptId LIMIT 1];
     for(Competitor_CQP__c cmp: (List<Competitor_CQP__c>)cmptrs.getRecords()){
         dupComptrs.put(cmp.Account__c,cmp);
     }
     
    try{
         if(randomCompt.size()>0 && !dupComptrs.containsKey(randomCompt[0].Id)){
             Competitor_CQP__c cmp = new Competitor_CQP__c();
             cmp.Account__c = randomCompt[0].Id;
             cmp.Quote_Proposal__c = id;
             toInsertCQPComptrsList.add(cmp);
             Database.Insert(toInsertCQPComptrsList);
             return new Pagereference(System.label.CL0001+id);
         }
         else if(dupComptrs.containsKey(randomCompt[0].Id)){
             dupAcc = true;
             return null;
         }
         }
         catch(Exception e)
         {String err=e.getMessage();}
         
          return null;
    }
  
  /*  Description of the purpose of the method. 
    *  @name back
 */   
   public pagereference back(){
   try{
        PageReference pageref = new PageReference(System.label.CL0001+id);
        return pageref;
        }catch(Exception e){String err=e.getMessage();}
         return null; 
    }
 /*   
    *  @name CompetitorWrapper
 */ 
    public with sharing class CompetitorWrapper{        
    public Competitor__c compt{get; set;}        
    public Boolean selected {get; set;}
  /*  
    *  @name CompetitorWrapper
 */        
    public CompetitorWrapper(){            
        compt = new Competitor__c();            
        selected = false;        
        } 
   /*  
    *  @name CompetitorWrapper
 */                 
    public CompetitorWrapper(Competitor__c cmp){            
        compt = cmp;            
        selected = false;        
        }    
    }
}