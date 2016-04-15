/**
    @Author Shankar Anand
    @name addNewOpportunityOnCaptureTeam
    @CreateDate 12/16/2015
    @Description Add Opportunity to Capture Team
    @Version 1.0
    **/
public without sharing class addNewOpportunityOnCaptureTeam{

 List<OpportunityWrapper> opportunities {get;set;}       
 List<Opportunity> opptyList = new List<Opportunity>();
 Map<Id,Opportunity> opptyEUPMap = new Map<Id,Opportunity>();
 Id id;
 public String error{get;set;}
 String errMsgs ='';
  public addNewOpportunityOnCaptureTeam(ApexPages.StandardSetController controller)
    {
        id = ApexPages.currentPage().getParameters().get(System.label.ApexClass_id);
    }
    // ApexPages.StandardSetController must be instantiated
    // for standard list controllers
    public ApexPages.StandardSetController setCon 
    {
        get {
            id = ApexPages.currentPage().getParameters().get(System.label.ApexClass_id);
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Id, Name, Capture_Team__c, CloseDate, StageName, OwnerId FROM Opportunity where Capture_Team__c =: id LIMIT 50000]));
            }
            return setCon;
        }
        set;
    }
 /*  Description of the purpose of the method. 
    *  @name  getOpportunities
    *  @Description -Get the list of Opportunities. 
 */
        public List<OpportunityWrapper> getOpportunities(){
        try{
         opportunities = new List<OpportunityWrapper>();
         Map<Id,Opportunity> opptyCTMap = new Map<Id,Opportunity>((List<Opportunity>)setCon.getRecords());
         opptyEUPMap = new Map<Id,Opportunity>([Select Id, Name, End_User_Project__c, Capture_Team__c, StageName, OwnerId, CloseDate from Opportunity where Capture_Team__c = null and End_User_Project__c IN (Select End_User_Project__c from Capture_Team__c where Id =:id) LIMIT 50000]);
         for(Opportunity opp : opptyEUPMap.values()){
             if(!opptyCTMap.containsKey(opp.Id)){

                 opportunities.add(new OpportunityWrapper(opp));
             }
         }
         
         return opportunities;
         }
         catch(Exception exc){
         return null;
         }
    }
    
 /*  Description of the purpose of the method. 
    *  @name addSelectedOpportunities
    *  @Description -Adds the selected list of Opportunities 
 */      
    public pagereference addSelectedOpportunities(){
    List<Opportunity> updateList = new List<opportunity>();
      for(OpportunityWrapper wrap: opportunities ){
        if(wrap.selected ==true){
         Opportunity tempOpp = new Opportunity(Id = wrap.oppty.Id);   
         tempOpp.Capture_Team__c = id;
         updateList.add(tempOpp);
        }
      }
      if(updateList.size()>0){
        try{
            update updateList;
        }
        catch(DmlException exc){
           error ='';
           errMsgs  = '';
           Integer numErrors = exc.getNumDml();
           String genErr = System.label.System_Oppty_Label+ System.label.Break ;   
           for(Integer i=0;i<numErrors;i++) {   
              errMsgs += opptyEUPMap.get(exc.getDmlId(i)).Name+ System.label.CL0003 + exc.getDmlMessage(i) +System.label.Line_Break;              
           }
           error = genErr + errMsgs ;
           return null;  
         }
      }
      
      PageReference pageref = new PageReference(System.label.CL0001+id);
      return pageref;
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
 /*  Description of the purpose of the method. 
    *  @name OpportunityWrapper
 */ 
    public with sharing class OpportunityWrapper{        
    public Opportunity oppty{get; set;}        
    public Boolean selected {get; set;}
 /*  
    *  @name OpportunityWrapper
 */      
    public OpportunityWrapper(){            
        oppty = new Opportunity();            
        selected = false;        
        }  
 /*  
    *  @name OpportunityWrapper
 */             
    public OpportunityWrapper(Opportunity opp){            
        oppty = opp;            
        selected = false;        
        }    
    }
}