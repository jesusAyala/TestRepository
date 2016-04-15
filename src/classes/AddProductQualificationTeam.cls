/**
 * TriggerClass -  AddProductQualificationTeam
 * 
 * Release R4
 * @author  Abiramasundari Radha (Accenture)
 * @created 2015-08-21
 * @version 1.0
 * Created
 */
public with sharing class AddProductQualificationTeam
{
    public Product_Qualification_Team_Role__c prodQualTeam1 {get; set;}
    public Product_Qualification_Team_Role__c prodQualTeam2 {get; set;}
    public Product_Qualification_Team_Role__c prodQualTeam3 {get; set;}
    public Product_Qualification_Team_Role__c prodQualTeam4 {get; set;}
    public Product_Qualification_Team_Role__c prodQualTeam5 {get; set;}
    public List<Product_Qualification_Team_Role__c> prodQualTeamList = new List<Product_Qualification_Team_Role__c>() ;
    public Id prodId;
    public Boolean isNotQualified{get;set;}   
    public Boolean showBack{get;set;}
    public Boolean showCanvas{get;set;}
    public Boolean isSubApproval{get;set;} 
 
  /*  Description of the purpose of the method. 
    *  @name AddProductQualificationTeam
    *  @Description - Constructor for AddProductQualificationTeam.
    *  @return Nothing - 
    */
   public AddProductQualificationTeam(ApexPages.StandardController controller) {
        
        prodQualTeam1 = new Product_Qualification_Team_Role__c();
        prodQualTeam2 = new Product_Qualification_Team_Role__c();
        prodQualTeam3 = new Product_Qualification_Team_Role__c();
        prodQualTeam4 = new Product_Qualification_Team_Role__c();
        prodQualTeam5 = new Product_Qualification_Team_Role__c();
        prodId = Apexpages.currentPage().getParameters().get(System.label.System_CL00018);  //System.label.System_CL00018 => id
        
    List<Product_Qualification__c > lstPQ = [Select Id , Name , Initiative_Status__c from Product_Qualification__c where Initiative_Status__c != 'Open' and id =:prodId  limit 50000 ];
    if(lstPQ != null && lstPQ.size() >0){
        isNotQualified = True;
    }else{
        isNotQualified = False;
    }
    
    List<ProcessInstance> lstProcessInstance = [Select Id, Status, TargetObject.Name , TargetObjectId from ProcessInstance where TargetObjectId  =:prodId  and Status ='Pending'  limit 50000];
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
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.System_CL00092));                 
    } 
        
     if(isSubApproval )
     {     
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.System_CL00096));                
     } 
     
    }

    /*  Description of the purpose of the method. 
    *  @name saveRecord
    *  @Description - Save the members.
    *  @return - Navigate to appropriate Product Qualification team record after saving 
    *  @throws exception-Method will throw DML Exception in case of any DML issues and captures in log object
    */   
    public Pagereference saveRecord(){
      try{  
            prodQualTeamList = new List<Product_Qualification_Team_Role__c>();
            if(prodQualTeam1.User__c != null){
                prodQualTeam1.Product_Qualification__c = prodId;
                prodQualTeamList.add(prodQualTeam1);
            }    
            if(prodQualTeam2.User__c != null){
                prodQualTeam2.Product_Qualification__c = prodId;
                prodQualTeamList.add(prodQualTeam2);
            }
            if(prodQualTeam3 .User__c != null){
                prodQualTeam3 .Product_Qualification__c = prodId;
                prodQualTeamList.add(prodQualTeam3);
            } 
            if(prodQualTeam4.User__c != null){
                prodQualTeam4.Product_Qualification__c = prodId;
                prodQualTeamList.add(prodQualTeam4);
            }
            if(prodQualTeam5.User__c != null){
                prodQualTeam5.Product_Qualification__c = prodId;
                prodQualTeamList.add(prodQualTeam5);
            } 
            if(prodQualTeamList.size()>0){
                Database.Insert(prodQualTeamList);
            }
        }
     catch(exception ex){
      if(ClsTriggerFactory.prodQualErrorMsg == true)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.label.CL00019)); //System_CL00019 - Insufficient Privilege. 
            return null;
        }
        PageReference pageRef = new PageReference(System.label.System_CL00020+prodId); //System_CL00020 => '/'
        return pageRef;
    }

 /*  Description of the purpose of the method. 
    *  @name saveMoreRecord
    *  @Description - Save the members.
    *  @return - Navigate to appropriate capture team record after saving. 
    *  @throws exception-Method will throw DML Exception in case of any DML issues and captures in log object
    */   
    public Pagereference saveMoreRecord(){    
        try{    
            prodQualTeamList = new List<Product_Qualification_Team_Role__c>();
            if(prodQualTeam1.User__c != null){
                prodQualTeam1.Product_Qualification__c = prodId;
                prodQualTeamList.add(prodQualTeam1);
            }    
            if(prodQualTeam2.User__c != null){
                prodQualTeam2.Product_Qualification__c = prodId;
                prodQualTeamList.add(prodQualTeam2);
            }
            if(prodQualTeam3 .User__c != null){
                prodQualTeam3 .Product_Qualification__c = prodId;
                prodQualTeamList.add(prodQualTeam3);
            } 
            if(prodQualTeam4.User__c != null){
                prodQualTeam4.Product_Qualification__c = prodId;
                prodQualTeamList.add(prodQualTeam4);
            }
            if(prodQualTeam5.User__c != null){
                prodQualTeam5.Product_Qualification__c = prodId;
                prodQualTeamList.add(prodQualTeam5);
            } 
            if(prodQualTeamList.size()>0){
                Database.Insert(prodQualTeamList);
            }
        }
        catch(exception ex){
        if(ClsTriggerFactory.prodQualErrorMsg == true)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.label.CL00019));  //System_CL00019 - Insufficient Privilege. 
            return null;
        }
      PageReference pageRef = new PageReference(System.label.System_CL00047 + prodId); // System_CL00047 => '/apex/AddProductQualificationTeam?id='
      pageRef.setredirect(true);
      return pageRef;
    }
    
    /*  Description of the purpose of the method. 
    *  @name cancel
    *  @Description - Cancel the request.
    *  @return - Navigate to appropriate capture team record after saving. 
    *  @throws exception-Method will throw DML Exception in case of any DML issues and captures in log object
    */   
    public Pagereference cancel(){        
        PageReference pageRef = new PageReference(System.label.System_CL00020+prodId);
        return pageRef;
    }
    
     public Pagereference GoBack(){
        try{
                     
           PageReference pageRef = new PageReference(Label.CL0001+prodId); 
           return pageRef;                                           
        }catch(DMLException e){ 
            return null; 
        } 
    }
    
}