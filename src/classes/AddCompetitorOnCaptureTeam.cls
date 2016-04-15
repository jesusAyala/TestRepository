/**
    @Author Shankar Anand
    @name AddCompetitorOnCaptureTeam
    @CreateDate 12/17/2015
    @Description Add Competitors to Capture Team
    @Version 1.0
    **/
public with sharing class AddCompetitorOnCaptureTeam{
    /*public AddCompetitorOnCaptureTeam(ApexPages.StandardController controller) {

    }*/
 private final Competitor_Capture_Team__c competitor;
 public List<CompetitorWrapper> competitors {get;set;}       
 List<Competitor__c> opptyComptrs = new List<Competitor__c>();
 List<Competitor_Capture_Team__c> toInsertCTComptrsList = new List<Competitor_Capture_Team__c>();
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
    *  @name AddCompetitorOnCaptureTeam
    *  @Description - Constructor for AddCompetitorOnCaptureTeam. 
 */
   public AddCompetitorOnCaptureTeam(ApexPages.StandardSetController stdController) {
     competitors = new List<CompetitorWrapper>();
     competitors = getCompetitorList();
    }
    
  public ApexPages.StandardSetController cmptrs {
        get {
            id = ApexPages.currentPage().getParameters().get(System.label.ApexClass_id);
            if(cmptrs == null) {
                cmptrs = new ApexPages.StandardSetController(Database.getQueryLocator([Select Id, Name, Capture_Team__c, Ranking__c, Comment__c, Account__c, Account__r.Name FROM Competitor_Capture_Team__c where Capture_Team__c =: id LIMIT 10000]));
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
    id = ApexPages.currentPage().getParameters().get(System.label.ApexClass_id);
    List<Opportunity> opps = new List<Opportunity>();

        List<Capture_Team__c> capt = [Select Id, End_User_Project__c from Capture_Team__c where Id =: id LIMIT 50000]; 
        opps = [Select Id, Name, End_User_Project__c from Opportunity where End_User_Project__c in (Select Id From End_User_Project__c where Id =: capt[0].End_User_Project__c) LIMIT 50000 ];
        opptyComptrs = [Select Id, Name, Competitor__c, Competitor__r.Name, Opportunity__c, Opportunity__r.Name from Competitor__c where Opportunity__c IN :opps order by Competitor__r.Name LIMIT 10000];
    
    try{
    if(((List<Competitor_Capture_Team__c>)cmptrs.getRecords()).isEmpty()){
        competitors = new List<CompetitorWrapper>();
        for(Competitor__c cmt: [Select Id, Name, Competitor__c, Competitor__r.Name, Opportunity__c, Opportunity__r.Name from Competitor__c where Opportunity__c IN :opps order by Competitor__r.Name LIMIT 10000]){
           competitors.add(new CompetitorWrapper(cmt));           
        }
       return competitors; 
    }
    else if(((List<Competitor_Capture_Team__c>)cmptrs.getRecords()).size()>0){ 
    competitors = new List<CompetitorWrapper>();
    Map<Id,Competitor__c> dupComptrs = new Map<Id,Competitor__c>(); 
        for(Competitor_Capture_Team__c cmp: (List<Competitor_Capture_Team__c>)cmptrs.getRecords()){
            for(Competitor__c cmt: [Select Id, Name, Competitor__c, Competitor__r.Name, Opportunity__c, Opportunity__r.Name from Competitor__c where Opportunity__c IN :opps order by Competitor__r.Name LIMIT 10000]){
                if(cmp.Account__c== cmt.Competitor__c){
                   dupComptrs.put(cmt.Id,cmt);  
                }
            }
        } 
   
      for(Competitor__c cmt: [Select Id, Name, Competitor__c, Competitor__r.Name, Opportunity__c, Opportunity__r.Name from Competitor__c where Opportunity__c IN :opps order by Competitor__r.Name LIMIT 10000]){
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
   try{
    for(CompetitorWrapper cwrap: competitors){
        if(cwrap.selected == true){
           Competitor_Capture_Team__c cmp = new Competitor_Capture_Team__c ();
           cmp.Account__c = cwrap.compt.Competitor__c;
           cmp.Capture_Team__c = id;
           toInsertCTComptrsList.add(cmp);
        }
    }
    if(toInsertCTComptrsList.size()>0){
        Database.Insert(toInsertCTComptrsList);
    }
    }catch(Exception e){String err=e.getMessage();}
    return new Pagereference(System.label.CL0001+id);
   } 
/*  Description of the purpose of the method. 
    *  @name addCompetitor
 */  
     public pageReference addCompetitor(){
     id = ApexPages.currentPage().getParameters().get(System.label.ApexClass_id);
     Map<Id,Competitor_Capture_Team__c> dupComptrs = new Map<Id,Competitor_Capture_Team__c>();
     List<Competitor_Capture_Team__c> toInsertComptrsList = new List<Competitor_Capture_Team__c>();
     List<Account> randomCompt = [Select Id, Name from Account where Id =:selectedComptId LIMIT 1];
     for(Competitor_Capture_Team__c cmp: (List<Competitor_Capture_Team__c>)cmptrs.getRecords()){
         dupComptrs.put(cmp.Account__c,cmp);
     }
     try{
     if(randomCompt.size()>0 && !dupComptrs.containsKey(randomCompt[0].Id)){
         Competitor_Capture_Team__c cmp = new Competitor_Capture_Team__c();
         cmp.Account__c = randomCompt[0].Id;
         cmp.Capture_Team__c= id;
         toInsertComptrsList.add(cmp);
         Database.Insert(toInsertComptrsList);
         return new Pagereference(System.label.CL0001+id);
     }
     else if(dupComptrs.containsKey(randomCompt[0].Id)){
         dupAcc = true;
         return null;
     }
     }catch(Exception e){String err=e.getMessage();}
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
  /*  Description of the purpose of the method. 
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