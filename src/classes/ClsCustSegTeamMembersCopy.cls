/**
 * Class - ClsCustSegTeamMembersCopy
 * Controller for Vf pgae - CustSegTeamMembersCopy
 * 
 * Copy Account Team Members from the Account Team along with their roles in to the Customer Segmentation Team
      and provide "Read/Write" Access. don't copy the duplicate user names. don't copy the inactive user.
 * Release R5
 * @author  Indhu Selvi Ramalingam (Accenture)
 * @created 2016-01-07
 * @version 1.0
 * Created
 */
public with sharing class ClsCustSegTeamMembersCopy{
/**
* Constructor
*/  
    public ClsCustSegTeamMembersCopy(ApexPages.StandardController controller) {    
    }
/**
* Constructor
*/    
    public ClsCustSegTeamMembersCopy(){}
    
    public String stringCustSegId = Apexpages.currentPage().getParameters().get(Label.System_CL00018);   
 // public Boolean isSubApproval{get;set;}
 // public Boolean showErrmsg{get;set;} 
      Id labelId = Label.CL00075; // System Admin profile ID  
      
/**
* Method copyAccountTeamMember
* Add account team meber to customer segmentation team
*/       
    public pagereference copyAccountTeamMember(){
        String accountId;
         Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
        Set<Id> CustSegId = new Set<Id>();        
        List<Customer_Segmentation_Team__c> addteamMembersList = new List<Customer_Segmentation_Team__c>();
        Map<Id,Set<Id>> mapCustSeg= new Map<Id,Set<Id>>();
             
        List<Customer_Segmentation__c> lstCustSeg = [SELECT Id,Name,Account__c ,OwnerId
            FROM Customer_Segmentation__c WHERE Id =: stringCustSegId LIMIT :remLimit];         
        if(lstCustSeg.size()>0){
            accountId = lstCustSeg[0].Account__c;
        }
        
        
        If(lstCustSeg.size()>0){         
            for(Customer_Segmentation__c oldrecords : lstCustSeg){
                CustSegId.add(oldrecords.Id);
            }
        }
                
        List<AccountTeamMember> listAccountTeamMember = [SELECT UserId, AccountAccessLevel, TeamMemberRole, Id, AccountId From AccountTeamMember 
                        where AccountID =: accountId AND User.ProfileID != : labelId AND UserId !=: lstCustSeg[0].OwnerId AND User.IsActive = TRUE LIMIT :remLimit];
                        
        
        
        List<Customer_Segmentation_Team__c> lstDuplicateCheck = [SELECT Id,Customer_Segmentation__c,User__c,Team_Role__c FROM 
                    Customer_Segmentation_Team__c WHERE Customer_Segmentation__c =: CustSegId Limit 50000]; 
        if(lstDuplicateCheck.size()>0){
            for(Customer_Segmentation_Team__c dupCheck : lstDuplicateCheck){
                if(mapCustSeg.containskey(dupCheck.Customer_Segmentation__c) == False){
                    mapCustSeg.put(dupCheck.Customer_Segmentation__c, new set<Id>());                                   
                }
                mapCustSeg.get(dupCheck.Customer_Segmentation__c).add(dupCheck.User__c);           
            }           
        }            
        
        If(lstCustSeg.size()>0){
            for(Customer_Segmentation__c CustSeg : lstCustSeg){  
                If(listAccountTeamMember.size()>0){      
                    for(AccountTeamMember accTeamMember : listAccountTeamMember){
                        if((mapCustSeg.containskey(CustSeg.Id) == FALSE) || (mapCustSeg.containskey(CustSeg.Id) && mapCustSeg.get(CustSeg.Id).Contains(accTeamMember.UserId) == FALSE)){                        
                            Customer_Segmentation_Team__c custSegTeamMember = new Customer_Segmentation_Team__c();
                            custSegTeamMember.Customer_Segmentation__c = CustSeg.Id;
                            custSegTeamMember.User__c = accTeamMember.UserId;
                            custSegTeamMember.Access__c = Label.System_CL00037;               // System_CL00037 -> 'Read/Write'
                            custSegTeamMember.Team_Role__c = accTeamMember.TeamMemberRole;
                            addteamMembersList.add(custSegTeamMember);   
                            }
                    }                                         
                } 
            } 
            if(addteamMembersList.size()>0){
            Database.insert(addteamMembersList); 
          }
  
        }              
                          
        PageReference pageRef = new PageReference(Label.System_CL00020+ stringCustSegId); 
        return pageRef;
    } 

 }