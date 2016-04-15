/**
    @Author Shankar Anand
    @name OpportunityWarnings
    @CreateDate 2/4/2016
    @Description Handles warning messages related to Opportunity quotes.
    @Version 1.0
    **/
public with sharing class OpportunityWarnings{
Map<Id,Apttus_Proposal__Proposal__c> quoteMap = new Map<Id,Apttus_Proposal__Proposal__c>();
Opportunity oppt = new Opportunity();
/**
 * Constructor
*/
public OpportunityWarnings(ApexPages.StandardController controller){
   oppt = (Opportunity)controller.getRecord();
}

/**
 * Method MyAction
 * Handles warning messages related to Opportunity quotes.
*/
public PageReference MyAction(){
 Boolean flag = false;
 List<Opportunity> opptyList = new List<Opportunity>();
 Id id = ApexPages.currentPage().getParameters().get('id');
 Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
 quoteMap = new Map<Id,Apttus_Proposal__Proposal__c>([Select Id, Name, Apttus_Proposal__Opportunity__c, Quotation_status__c from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c =:id LIMIT :remLimit]);
 for(Apttus_Proposal__Proposal__c quot:quoteMap.values()){
    if(quot.Quotation_status__c != 'Closed'){
       flag = true;
    }
 }
 try{
 if(quoteMap.values().size() > 0 && flag == false && (!oppt.StageName.equals(System.Label.Closed_Cancelled) && !oppt.StageName.equals(System.Label.Closed_Lost) && !oppt.StageName.equals(System.Label.Closed_Lost_Without_ABB_Bid) && !oppt.StageName.equals(System.Label.Opportunity_Closed_Won))){
    oppt.All_Quotes_Closed__c = true;
    opptyList.add(oppt);
    Database.update(opptyList,false);   
 }
 else{
    oppt.All_Quotes_Closed__c = false;
    opptyList.add(oppt);
    Database.update(opptyList,false); 
 }
 }catch(Exception e){String err=e.getMessage();}
 return null;
}

}