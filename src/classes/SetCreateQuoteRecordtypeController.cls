/**
*  @Name: SetCreateQuoteRecordtypeController
*  @return - void
*  @Description - This class helps to decide the Quote Record type based on User type
*  @Author : Rajesh Kaliyaperumal (Accenture)
*/
public with sharing class SetCreateQuoteRecordtypeController {
    /**
    *  @Name: SetCreateQuoteRecordtypeController
    *  @return - void
    *  @Description - Constructor
    */
    public SetCreateQuoteRecordtypeController() {
    }
    /**
    *  @Name: redirect
    *  @return - void
    *  @Description - Method to decide the record type based on user type
    */
    public pagereference redirect(){
        String hostname = ApexPages.currentPage().getHeaders().get(System.Label.ApexPagesGetHost); 
        //Map<String, Schema.RecordTypeInfo> pROPOSAL_RECORD_TYPES = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName();
        //String PROPOSAL_RECORD_TYPE_ID = pROPOSAL_RECORD_TYPES.get('Proposal').getRecordTypeId();
        try{
            List<User> objUser = [SELECT id,Division_DIV__c from User where id =:UserInfo.getUserId() LIMIT 1];     
            List<Account> objAcc = [SELECT id,Name,RecordType.Name from Account where id =: ApexPages.currentPage().getParameters().get(System.Label.ApexPagesGetId) LIMIT 1];
            system.debug('##### object account ##### '+objAcc);
            List<Opportunity> objOpp = [SELECT id,Name,Accountid,Opportunity_Number__c from Opportunity where id =: ApexPages.currentPage().getParameters().get(System.Label.ApexPagesGetId) LIMIT 1];
            if(objUser[0].Division_DIV__c != System.Label.UserDivisionDM){
                if(objAcc.size()>0){
                    system.debug(' #### page reference ##### '+'https://'+hostname+'/apex/APTS_CaptureInputForLSOData?id=' + objAcc[0].id + '&baseObject=Account&name=' +objAcc[0].Name +'&type='+objAcc[0].RecordType.Name+'&targetObject=Quotation');
                    PageReference pageRef = new PageReference('https://'+hostname+'/apex/APTS_CaptureInputForLSOData?id=' + objAcc[0].id + '&baseObject=Account&name=' +objAcc[0].Name +'&type='+objAcc[0].RecordType.Name+'&targetObject=Quotation');
                    return pageRef;
                    
                }
                else if(objOpp.size()>0){
                    PageReference pageRef = new PageReference('https://'+hostname+'/apex/APTS_CaptureInputForLSOData?id=' + objOpp[0].id + '&baseObject=Opportunity&targetObject=Quotation&name='+ objOpp[0].name);
                    return pageRef;
                }else{}        
            }else{            
                if(objOpp.size()>0){
                    PageReference pageRef = new PageReference('https://'+hostname+'/'+'apex/CreateQuote?accountId='+ objOpp[0].Accountid +'&opportunityNumber='+ objOpp[0].Opportunity_Number__c +'&SFDCUserId='+ objUser[0].id +'&RequestID='+ objUser[0].id + DateTime.now().getTime() +'');
                    return pageRef;
                }
                else if(objAcc.size()>0){               
                    PageReference pageRef = new PageReference('https://'+hostname+'/'+'apex/CreateQuote?accountId='+objAcc[0].id+'&SFDCUserId='+ objUser[0].id +'&RequestID='+ objUser[0].id + DateTime.now().getTime() +'');
                    return pageRef;
                }else{}
            }
        }catch(Exception ex){return null;}
        return null;
    }

}