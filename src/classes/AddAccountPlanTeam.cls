/**
 * TriggerClass -  AddAccountPlanTeam
 * 
 * Release R5
 * @author  Abiramasundari Radha (Accenture)
 * @created 2015-01-11
 * @version 1.0
 * Created
 */
public with sharing class AddAccountPlanTeam
{
    public Account_Plan_Team__c accountPlanTeam1 {get; set;}
    public Account_Plan_Team__c accountPlanTeam2 {get; set;}
    public Account_Plan_Team__c accountPlanTeam3 {get; set;}
    public Account_Plan_Team__c accountPlanTeam4 {get; set;}
    public Account_Plan_Team__c accountPlanTeam5 {get; set;}
    public List<Account_Plan_Team__c> accountPlanTeamList = new List<Account_Plan_Team__c>() ;
    public Id accountPlanId;
    public Boolean isNotQualified{get;set;}   
    public Boolean showBack{get;set;}
    public Boolean showCanvas{get;set;}
    public Boolean isSubApproval{get;set;} 
 
  /*  Description of the purpose of the method. 
    *  @name AddAccountPlanTeam
    *  @Description - Constructor for AddAccountPlanTeam.
    *  @return Nothing - 
    */
   public AddAccountPlanTeam(ApexPages.StandardController controller) {
        
        accountPlanTeam1 = new Account_Plan_Team__c();
        accountPlanTeam2 = new Account_Plan_Team__c();
        accountPlanTeam3 = new Account_Plan_Team__c();
        accountPlanTeam4 = new Account_Plan_Team__c();
        accountPlanTeam5 = new Account_Plan_Team__c();
        accountPlanId = Apexpages.currentPage().getParameters().get(System.label.System_CL00018);  //System.label.System_CL00018 => id
       // system.debug('accountPlanId------------'+accountPlanId);
  
  /*      
    List< > lstPQ = [Select Id , Name , Initiative_Status__c from Account_Plan__c where Initiative_Status__c != 'Open' and id =:accountPlanId  limit 50000 ];
    if(lstPQ != null && lstPQ.size() >0){
        isNotQualified = True;
    }else{
        isNotQualified = False;
    }
    
    List<ProcessInstance> lstProcessInstance = [Select Id, Status, TargetObject.Name , TargetObjectId from ProcessInstance where TargetObjectId  =:accountPlanId  and Status ='Pending'  limit 50000];
    if(lstProcessInstance != null && lstProcessInstance.size() >0){
        isSubApproval = true;
    }else{
        isSubApproval = False;
    }   
    
    if(isSubApproval == True || isNotQualified == True ){
        showCanvas = False; showBack = True;
    }else{
        showCanvas = True;
        showBack = False;
    }  
       
    if(isNotQualified)
    {             
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Cannot_Save_Changes_Account_Plan_R5));  //Cannot_Save_Changes_Account_Plan_R5 => You cannot save the changes as Account Plan Status is Closed.               
    } 
        
     if(isSubApproval )
     {     
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.System_CL00096));    //System_CL00096 => Record Locked - The record you are trying to edit has been locked. Please contact your administrator if access is necessary.            
     } 
   */ 
   showCanvas = True;
    }

    /*  Description of the purpose of the method. 
    *  @name saveRecord
    *  @Description - Save the members.
    *  @return - Navigate to appropriate Account Plan team record after saving 
    *  @throws exception-Method will throw DML Exception in case of any DML issues and captures in log object
    */   
    public Pagereference saveRecord(){
      try{  
      //system.debug('HAIII------------');
            accountPlanTeamList = new List<Account_Plan_Team__c>();
            if(accountPlanTeam1.User__c != null){
                accountPlanTeam1.Account_Plan__c = accountPlanId;
                accountPlanTeamList.add(accountPlanTeam1);
            }    
            if(accountPlanTeam2.User__c != null){
                accountPlanTeam2.Account_Plan__c = accountPlanId;
                accountPlanTeamList.add(accountPlanTeam2);
            }
            if(accountPlanTeam3 .User__c != null){
                accountPlanTeam3 .Account_Plan__c = accountPlanId;
                accountPlanTeamList.add(accountPlanTeam3);
            } 
            if(accountPlanTeam4.User__c != null){
                accountPlanTeam4.Account_Plan__c = accountPlanId;
                accountPlanTeamList.add(accountPlanTeam4);
            }
            if(accountPlanTeam5.User__c != null){
                accountPlanTeam5.Account_Plan__c = accountPlanId;
                accountPlanTeamList.add(accountPlanTeam5);
            } 
            
           // system.debug('accountPlanTeamList------------'+accountPlanTeamList);
            if(accountPlanTeamList.size()>0){
                Database.Insert(accountPlanTeamList);
            }
        }
         catch(exception de){
            String error = '';
   
            for(Integer i=0;i<de.getNumDml();i++) {              
                error += de.getDmlMessage(i) +Label.Line_Break; 
            }
        
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, error)) ; //System.label.CL00019));  //System_CL00019 - Insufficient Privilege. 
            return null;
        }
        PageReference pageRef = new PageReference(System.label.System_CL00020+accountPlanId); //System_CL00020 => '/'
        return pageRef;
    }

 /*  Description of the purpose of the method. 
    *  @name saveMoreRecord
    *  @Description - Save the members.
    *  @return - Navigate to appropriate team record after saving. 
    *  @throws exception-Method will throw DML Exception in case of any DML issues and captures in log object
    */   
    public Pagereference saveMoreRecord(){    
        try{    
            accountPlanTeamList = new List<Account_Plan_Team__c>();
            if(accountPlanTeam1.User__c != null){
                accountPlanTeam1.Account_Plan__c = accountPlanId;
                accountPlanTeamList.add(accountPlanTeam1);
            }    
            if(accountPlanTeam2.User__c != null){
                accountPlanTeam2.Account_Plan__c = accountPlanId;
                accountPlanTeamList.add(accountPlanTeam2);
            }
            if(accountPlanTeam3 .User__c != null){
                accountPlanTeam3 .Account_Plan__c = accountPlanId;
                accountPlanTeamList.add(accountPlanTeam3);
            } 
            if(accountPlanTeam4.User__c != null){
                accountPlanTeam4.Account_Plan__c = accountPlanId;
                accountPlanTeamList.add(accountPlanTeam4);
            }
            if(accountPlanTeam5.User__c != null){
                accountPlanTeam5.Account_Plan__c = accountPlanId;
                accountPlanTeamList.add(accountPlanTeam5);
            } 
            if(accountPlanTeamList.size()>0){
                Database.Insert(accountPlanTeamList);
            }
        }
        catch(exception de){
            String error = '';
   
            for(Integer i=0;i<de.getNumDml();i++) {              
                error += de.getDmlMessage(i) +Label.Line_Break; 
            }
        
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, error)) ; //System.label.CL00019));  //System_CL00019 - Insufficient Privilege. 
            return null;
        }
      PageReference pageRef = new PageReference(System.label.System_Add_Account_Plan_Team_Id_R5 + accountPlanId); // System_Add_Account_Plan_Team_Id_R5 => '/apex/AddAccountPlanTeam?id='
      pageRef.setredirect(true);
      return pageRef;
    }
    
    /*  Description of the purpose of the method. 
    *  @name cancel
    *  @Description - Cancel the request.
    *  @return - Navigate to appropriate team record after saving. 
    *  @throws exception-Method will throw DML Exception in case of any DML issues and captures in log object
    */   
    public Pagereference cancel(){        
        PageReference pageRef = new PageReference(System.label.System_CL00020+accountPlanId);
        return pageRef;
    }
    /*  Description of the purpose of the method. 
    *  @name Goback
    * returns to previous page
    */     
     public Pagereference GoBack(){
        try{
                     
           PageReference pageRef = new PageReference(Label.CL0001+accountPlanId); 
           return pageRef;                                           
        }catch(DMLException e){ 
            return null; 
        } 
    }
    
}