/*
@Name: APTS_AgreementNewController
@Author: Chetan Patel
@CreateDate: 11 Jan 2016
@Description: This apex class is an extension controller for APTS_AgreementNew VF page.
@UsedBy:  used by APTS_AgreementNew to  override Agreement standard new page.
@ModifiedBy: NA
@ModifiedDate: NA
@ChangeDescription: A brief description of what was modified.
PS: @ModifiedBy and @ChangeDescription can be repeated multiple time, based on number of changes made to the original process. */

public class APTS_AgreementNewController {
    
    public Apttus__APTS_Agreement__c agreement {get; set;}
    public boolean bHasErrors {get; set;}
    // Constructor
    public APTS_AgreementNewController (ApexPages.StandardController controller) {
        
        agreement = new Apttus__APTS_Agreement__c();
        bHasErrors = false;
        
    }
    
    public PageReference Next(){
        
        if(agreement.APTS_LP_AccountCustomer__c != null){
            
            Account account = [select name,id, RecordType.Name,RecordType.DeveloperName from Account where id=:agreement.APTS_LP_AccountCustomer__c limit 1];
            
            if(account.RecordType.DeveloperName == 'GIS_Approved'){
                
                PageReference pgRef = new PageReference('/apex/APTS_CaptureInputForLSOData?id='+ account.id + 
                                                        '&baseObject=Account' +  
                                                        '&type=' + account.RecordType.Name + 
                                                        '&targetObject=MSPA');
                pgRef.setRedirect(true);
                return pgRef;
            }else{
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select only buying account customer.'));
                bHasErrors = true;
                return null;
                
            }
            
        }else{
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select buying account customer.'));
            bHasErrors = true;
            return null;
            
      
        }
        
    }
    
    
}