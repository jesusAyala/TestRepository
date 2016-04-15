/**
 *      @description    Class for reverting opportunity record type and stage changes.  
 */
public with sharing class cancelOpptyChanges{
 /*  Description of the purpose of the method. 
    *  @name revertOpptyRecrdType
 */   
     public PageReference revertOpptyRecrdType(){
     try{
      List<Opportunity> opptyList = new List<Opportunity>();
      Id id = ApexPages.currentPage().getParameters().get(System.label.ApexClass_id);
      List <Opportunity> oppty = [Select Id, Name, StageName from Opportunity where id =:id LIMIT 1];
      //String recordtypeId = ApexPages.currentPage().getParameters().get('recordTypeId');
      String stageName = ApexPages.currentPage().getParameters().get(System.label.StageName);
      String salesProgress = ApexPages.currentPage().getParameters().get('Sales_Pursuit_Progress__c');
      //Date oldActualBidComm= Date.valueOf(ApexPages.currentPage().getParameters().get('oldActualBidComm'));
      //Date oldReqBidTech= Date.valueOf(ApexPages.currentPage().getParameters().get('oldReqBidTech'));
      //Date oldReqBidComm= Date.valueOf(ApexPages.currentPage().getParameters().get('oldReqBidComm'));
      Date oldCloseDate = Date.valueOf(ApexPages.currentPage().getParameters().get('CloseDate'));
      
      //Opportunity opp = new Opportunity(id= id,StageName=stageName,Sales_Pursuit_Progress__c=salesProgress,Actual_Bid_Submission_Date_Comm__c=oldActualBidComm,Requested_Bid_Submission_Date_Tech__c=oldReqBidTech,Requested_Bid_Submission_Date_Comm__c =oldReqBidComm,CloseDate=CloseDate);
      Opportunity opp = new Opportunity(id= id,StageName=stageName,Sales_Pursuit_Progress__c=salesProgress,CloseDate=oldCloseDate);
      opptyList.add(opp);
      Database.Update(opptyList);
      
      Pagereference prf = new Pagereference(System.label.CL0001+id);
      return prf;
      }
      catch(DMLException exc){
       String e=exc.getDMLMessage(0);
       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,+e,''));
       return null;
      }
      
  }
  /*  Description of the purpose of the method. 
    *  @name back
 */
  public PageReference back(){
  try{
      Id id = ApexPages.currentPage().getParameters().get(System.label.ApexClass_id);
      //String recordtypeId = ApexPages.currentPage().getParameters().get('recordTypeId');
      String stageName = ApexPages.currentPage().getParameters().get(System.label.StageName);
      String oldProgress = ApexPages.currentPage().getParameters().get('Sales_Pursuit_Progress__c');
      Date oldCloseDate = Date.valueOf(ApexPages.currentPage().getParameters().get('CloseDate'));
      
      //Pagereference prf = new Pagereference('/'+id+'/e?cancelURL=/apex/Cancel_Oppty_Record_Type_change?stageName='+stageName+'%26id='+id+'&saveURL=/'+id);
      Pagereference prf = new Pagereference(System.label.CL0001+id+System.label.CL00203+System.label.CL00204+stageName+'%26CloseDate='+oldCloseDate+System.Label.CL002108+oldProgress+System.label.CL00205+id+System.label.CL00206+id);
      return prf;
      }catch(Exception e){String err=e.getMessage();}
         return null; 
  }
      
}