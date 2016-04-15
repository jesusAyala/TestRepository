/**
    @Author Shankar Anand
    @name removeOpportunityFromCaptureTeam
    @CreateDate 01/07/2016
    @Description Remove Opportunity from Capture team
    @Version 1.0
    **/
public with sharing class removeOpportunityFromCaptureTeam{
List<OpportunityWrapper> opportunities{get;set;}
 List<Opportunity> opptyList = new List<Opportunity>();
 Id id;
 public String error{get;set;}
 String errMsgs ='';
  /*  Description of the purpose of the method. 
    *  @name removeOpportunityFromCaptureTeam
    *  @Description - Constructor for removeOpportunityFromCaptureTeam. 
*/
    public removeOpportunityFromCaptureTeam(ApexPages.StandardSetController controller)
    {
    
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
        opptyList = (List<Opportunity>)setCon.getRecords();
        for(Opportunity opp:opptyList){
            opportunities.add(new OpportunityWrapper(opp));
        }
        return opportunities;
        }catch(Exception e){String err=e.getMessage();}
         return null;
    }
    /*  Description of the purpose of the method. 
    *  @name removeSelectedOpportunities
    *  @Description -Removes the selected list of Opportunities 
 */  
    public pagereference removeSelectedOpportunities(){
    
     List<Opportunity> updateList = new List<opportunity>();
      for(OpportunityWrapper wrap: opportunities ){
        if(wrap.selected ==true){
         Opportunity tempOpp = new Opportunity(Id = wrap.oppty.Id);   
         tempOpp.Capture_Team__c = null;
         updateList.add(tempOpp);
        }
      }
      if(updateList.size()>0){
        try{
            Database.Update(updateList,False);
        }
        catch(DmlException exc){
           error ='';
           errMsgs  = '';
           Integer numErrors = exc.getNumDml();
           String genErr = System.label.System_Oppty_Label2+ System.label.Line_Break;
           for(Integer i=0;i<numErrors;i++) {  
              errMsgs += exc.getDmlId(i)+ '-' + exc.getDmlMessage(i) +System.label.Line_Break;              
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