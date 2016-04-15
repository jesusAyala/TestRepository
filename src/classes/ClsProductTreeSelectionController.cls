/**   
* Controller : ProductTreeSelectionPage
* Release R4
*  
* @author  MohanRaj Kasinathan (Accenture)
* @created  2015-09-21* @version 1.0
*
*/ 
public with sharing class ClsProductTreeSelectionController
{
public Boolean IsLocal {get;set;}
public Boolean IsGlobal {get;set;}
public String opportunityId{get;set;}
public String IsLP{get;set;}

public Boolean isPanelDisplay{get;set;}
public Boolean isErrorDisplay{get;set;}
private final Opportunity  opp;

/**   
* Controller : ProductTreeSelectionPage - Constructor
* Release R4
*  
* @author  MohanRaj Kasinathan (Accenture)
* @created  2015-09-21* @version 1.0
*
*/ 
public ClsProductTreeSelectionController(ApexPages.StandardController controller) 
{
    
    this.opp = (Opportunity)controller.getRecord();     
}

public ClsProductTreeSelectionController()
{
    
}

public PageReference Pageloadfn() 
{
    opportunityId = ApexPages.currentPage().getParameters().get('id');  
    Opportunity[] opprec = [Select id, CloseDate from Opportunity where id =: opportunityId];  
    
    if(opprec != null && opprec.size() >0 && opprec[0].CloseDate != null)
    {
        Date oppclosedate = opprec[0].CloseDate;         
        Date TodayDate = Date.Today(); 
        if(oppclosedate < TodayDate ) 
        { 
            isPanelDisplay = false;
            isErrorDisplay = true;     
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Opportunity expected award date cannot be past date.'));
        } 
        else 
        { 
            isPanelDisplay = true;
            isErrorDisplay = false;
            IsLP = 'No';
            String userid = UserInfo.getUserId(); 
            User[] usr = [SELECT Id, Name, Division_DIV__c FROM user where id =:userid];
            if(usr != null && usr[0].Division_DIV__c != null)
            {
                if(usr[0].Division_DIV__c  ==  system.label.System_UserDivisionEP)
                {
                   IsLP = 'Yes';            
                }
                
            }
            if(IsLP == 'No')
            {
                String Pisurl = '/apex/AddProductsPIS?addTo='+opportunityId+'&retURL='+opportunityId+'&id='+opportunityId;                 
                PageReference PISpg= new PageReference(Pisurl );
                PISpg.setRedirect(true);
                return PISpg;  
            }
            
          }
      
       
      }
      else
      {
        isPanelDisplay = false;
        isErrorDisplay = true;     
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Opportunity expected award date cannot be past date.'));      
      }
      return null;
}

public PageReference GoBack() 
{
    PageReference PISpg= new PageReference('/'+opportunityId);
    PISpg.setRedirect(true);
    return PISpg;   
}
/**   
* Controller : ProductTreeSelectionPage - Redirection Method.
* Release R4
*  
* @author  MohanRaj Kasinathan (Accenture)
* @created  2015-11-05* @version 1.0
*
*/ 
public PageReference AddProducts() 
{
   

    if(country  =='Add Local Hierarchies/Products')
    {
    
        String ProdSeltnurl = '';
        
        Apttus_Proposal__Proposal__c[] Quote = [Select id, APTS_IS_PlaceHolder_Quote__c  from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c =: opportunityId and APTS_IS_PlaceHolder_Quote__c = True limit 1];
        
        if(Quote != null && Quote.size() >0)
        {
           ProdSeltnurl = '/apex/Apttus_QPConfig__ProposalConfiguration?id='+Quote[0].Id+'&useAdvancedApproval=true&flow=LocalProducts';              
        }
        else
        {
            ProdSeltnurl = '/apex/Apttus_QPConfig__OpptyQuoteCreate?id='+opportunityId+'&recordTypeName=LP&is_placeholder_quote=true&priceListName=EP Spain& retUrl=/'+opportunityId+'&type=Prospecting&flow=LocalProducts';                           
        }
        
        PageReference ProdSelpg = new PageReference(ProdSeltnurl);
        ProdSelpg.setRedirect(true);
        return ProdSelpg;    
    }
    if(country == 'Add Global Products')
    {
        String Pisurl = '/apex/AddProductsPIS?addTo='+opportunityId+'&retURL='+opportunityId+'&id='+opportunityId+'&PS=YES';
        PageReference PISpg= new PageReference(Pisurl );
        PISpg.setRedirect(true);
        return PISpg;          
    }
    
    return null;
    
}


    String country = null;
                
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Add Local Hierarchies/Products','Add Local Hierarchies/Products')); 
        options.add(new SelectOption('Add Global Products','Add Global Products'));            
        return options;    
    }
                   
    public String getCountry() {
        return country;
    }
                    
    public void setCountry(String country) { this.country = country; }


}