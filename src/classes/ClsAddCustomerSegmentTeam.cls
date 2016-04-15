/**
 * VF Page - AddCustomerSegmentTeam
 * Trigger Class - ClsAddCustomerSegmentTeam
 * 
 * Release R5
 * @author  Indhu Selvi Ramalingam (Accenture)
 * @created 2016-01-12
 * @version 1.0
 * Created
 */
public with sharing class ClsAddCustomerSegmentTeam
{
    public Customer_Segmentation_Team__c customerSegTeam1 {get; set;}
    public Customer_Segmentation_Team__c customerSegTeam2 {get; set;}
    public Customer_Segmentation_Team__c customerSegTeam3 {get; set;}
    public Customer_Segmentation_Team__c customerSegTeam4 {get; set;}
    public Customer_Segmentation_Team__c customerSegTeam5 {get; set;}
    public List<Customer_Segmentation_Team__c> customerSegTeamList = new List<Customer_Segmentation_Team__c>() ;
    public Id customerSegId;
    public Boolean isNotQualified{get;set;}   
    public Boolean showBack{get;set;}
    public Boolean showCanvas{get;set;}
    public Boolean isSubApproval{get;set;} 
 
  /*  Description of the purpose of the method. 
    *  @name AddProductQualificationTeam
    *  @Description - Constructor for AddProductQualificationTeam.
    *  @return Nothing - 
    */
   public ClsAddCustomerSegmentTeam(ApexPages.StandardController controller) {
        
        customerSegTeam1 = new Customer_Segmentation_Team__c();
        customerSegTeam2 = new Customer_Segmentation_Team__c();
        customerSegTeam3 = new Customer_Segmentation_Team__c();
        customerSegTeam4 = new Customer_Segmentation_Team__c();
        customerSegTeam5 = new Customer_Segmentation_Team__c();
        customerSegId = Apexpages.currentPage().getParameters().get(System.label.System_CL00018);  //System.label.System_CL00018 => id
      //  system.debug('customerSegId------------'+customerSegId);
  
  
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
     // system.debug('HAIII------------');
            customerSegTeamList = new List<Customer_Segmentation_Team__c>();
            if(customerSegTeam1.User__c != null){
                customerSegTeam1.Customer_Segmentation__c = customerSegId;
                customerSegTeamList.add(customerSegTeam1);
            }    
            if(customerSegTeam2.User__c != null){
                customerSegTeam2.Customer_Segmentation__c = customerSegId;
                customerSegTeamList.add(customerSegTeam2);
            }
            if(customerSegTeam3 .User__c != null){
                customerSegTeam3 .Customer_Segmentation__c = customerSegId;
                customerSegTeamList.add(customerSegTeam3);
            } 
            if(customerSegTeam4.User__c != null){
                customerSegTeam4.Customer_Segmentation__c = customerSegId;
                customerSegTeamList.add(customerSegTeam4);
            }
            if(customerSegTeam5.User__c != null){
                customerSegTeam5.Customer_Segmentation__c = customerSegId;
                customerSegTeamList.add(customerSegTeam5);
            } 
            
           // system.debug('customerSegTeamList------------'+customerSegTeamList);
            if(customerSegTeamList.size()>0){
                Database.Insert(customerSegTeamList);
            }
        }
     catch(exception ex){
      if(ClsTriggerFactory.prodQualErrorMsg == true)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.label.CL00019)); //System_CL00019 - Insufficient Privilege. 
            return null;
        }
        PageReference pageRef = new PageReference(System.label.System_CL00020+customerSegId); //System_CL00020 => '/'
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
            customerSegTeamList = new List<Customer_Segmentation_Team__c>();
            if(customerSegTeam1.User__c != null){
                customerSegTeam1.Customer_Segmentation__c = customerSegId;
                customerSegTeamList.add(customerSegTeam1);
            }    
            if(customerSegTeam2.User__c != null){
                customerSegTeam2.Customer_Segmentation__c = customerSegId;
                customerSegTeamList.add(customerSegTeam2);
            }
            if(customerSegTeam3 .User__c != null){
                customerSegTeam3 .Customer_Segmentation__c = customerSegId;
                customerSegTeamList.add(customerSegTeam3);
            } 
            if(customerSegTeam4.User__c != null){
                customerSegTeam4.Customer_Segmentation__c = customerSegId;
                customerSegTeamList.add(customerSegTeam4);
            }
            if(customerSegTeam5.User__c != null){
                customerSegTeam5.Customer_Segmentation__c = customerSegId;
                customerSegTeamList.add(customerSegTeam5);
            } 
            if(customerSegTeamList.size()>0){
                Database.Insert(customerSegTeamList);
            }
        }
        catch(exception ex){
        if(ClsTriggerFactory.prodQualErrorMsg == true)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.label.CL00019));  //System_CL00019 - Insufficient Privilege. 
            return null;
        }
      PageReference pageRef = new PageReference(System.label.System_Add_Customer_Segmentation_Team_Id_R5+customerSegId); // System_Add_Customer_Segmentation_Team_Id_R5 => '/apex/AddCustomerSegmentTeam?id='
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
        PageReference pageRef = new PageReference(System.label.System_CL00020+customerSegId);
        return pageRef;
    }
/**
* @name GoBack
* returns to previous page.
*/    
     public Pagereference GoBack(){
        try{
                     
           PageReference pageRef = new PageReference(Label.CL0001+customerSegId); 
           return pageRef;                                           
        }catch(DMLException e){ 
            return null; 
        } 
    }
    
}