/**   
* Controller for the page newVisitReportVF
*       
* Release - R5 
 *  
 * @author  - Vasanthi (Accenture)
 * @created - 2016-2-17
 * @version - 1.0
 * @Description -Req 1954:
         When the user click on the new visit report button it should populate the Account and the corresponding object link

            i) When the user creating Visit Report from Channel Pre-Qualification then it should populate the account as well as the Channel Pre qualification pre-populated
            
            ii) When the user creating Visit Report from JBP then it should populate the account as well as the JBP pre-populated
            
            iii) When the user creating Visit Report from Channel Business Review then it should populate the account &Joint Business Plan as well as the Channel Business Reviewpre-populated
* - Created
*/
public with sharing class VisitReportRedirectController {
 
/** 
* Constructor
*/
     public VisitReportRedirectController () {
               
     }
     
/** 
* Redirect methods
*/        
    public PageReference redirectToStandard() {
         
        String recId = ApexPages.currentPage().getParameters().get(Label.ApexClass_id);
        String objectName = ApexPages.currentPage().getParameters().get(Label.System_Object); //Label.System_Object => object
        String refName = ApexPages.currentPage().getParameters().get(Label.System_Reference); //Label.System_Reference => Reference
        String flds = '';
        Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
        pageReference pg = Page.RedirectVFPage;     
        pg.getParameters().put(Label.System_Object.toLowerCase(), Label.System_Visit_Report_API);
        
        //Label.System_CL0005 - ID Label.System_Underscore = underscore  System_CL00020 = /
        
        if (objectName == Label.Channel_Partner_Business_Review_API_Name) {
            
            Channel_Business_Review__c[] channelList = [ SELECT Id, Name, Account__r.Name, Account__c, Joint_Business_Plan__c, Joint_Business_Plan__r.Name 
                FROM Channel_Business_Review__c WHERE ID =: recId LIMIT :remLimit];
                
            if (channelList.size() > 0) {
                pg.getParameters().put(refName, channelList[0].Name);
                pg.getParameters().put(Label.System_CL0005+Label.System_Underscore+refName, channelList[0].Id);
                pg.getParameters().put(Label.System_ID_Account, channelList[0].Account__c);
                pg.getParameters().put(Label.System_Account, channelList[0].Account__r.Name);
                pg.getParameters().put(Label.System_CL0005+Label.System_Underscore+ Label.System_Joint_Business_Plan_object_API, channelList[0].Joint_Business_Plan__c);
                pg.getParameters().put(Label.System_Joint_Business_Plan_object_API, channelList[0].Joint_Business_Plan__r.Name);
                pg.getParameters().put(Label.System_CL00045, Label.System_CL00020+channelList[0].Id);
            }
            
        }
        if (objectName == Label.System_Channel_Qualification_object_API) {
            Channel_Qualifications__c[] channelList = [ SELECT Id, Name, Account__r.Name, Account__c
                FROM Channel_Qualifications__c WHERE ID =: recId LIMIT :remLimit];
                
            if (channelList.size() > 0) {
                pg.getParameters().put(refName, channelList[0].Name);
                pg.getParameters().put(Label.System_CL0005+Label.System_Underscore+refName, channelList[0].Id);
                pg.getParameters().put(Label.System_ID_Account, channelList[0].Account__c);
                pg.getParameters().put(Label.System_Account, channelList[0].Account__r.Name);
                pg.getParameters().put(Label.System_CL00045, Label.System_CL00020+channelList[0].Id);
            }
        }
        
       if (objectName == Label.System_Joint_Business_Plan_object_API) {
            Joint_Business_Plan__c[] channelList = [ SELECT Id, Name, Account__r.Name, Account__c
                FROM Joint_Business_Plan__c WHERE ID =: recId LIMIT :remLimit];
                
            if (channelList.size() > 0) {
                pg.getParameters().put(refName, channelList[0].Name);
                pg.getParameters().put(Label.System_CL0005+Label.System_Underscore+refName, channelList[0].Id);
                pg.getParameters().put(Label.System_ID_Account, channelList[0].Account__c);
                pg.getParameters().put(Label.System_Account, channelList[0].Account__r.Name);
                pg.getParameters().put(Label.System_CL00045, Label.System_CL00020+channelList[0].Id);
            }
        }
         
        return pg; 
     }
}