/**   
* TriggerClass :  ClsTriggerBudgetOpp
*    
* Release R5
*  
* @author  Indhu Selvi Ramalingam (Accenture)
* @created 2016-02-15
* @version 1.0
* Req #2737
* - Created
*/
public without sharing class ClsTriggerBudgetOpp extends ClsTriggerVirtual {

/**
* @see IntHelper.beforeTrigger
*/  
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {        
              budgetOppDelete(trgCtx);
    }            
    
/* 
* Method - Cannot delete Budgeted Opportunities Records when Freeze Account Plan Budgets is True.
*/    
    @TestVisible
    public void budgetOppDelete(ClsWrappers.TriggerContext trgCtx) {
    
        Set<Id> setBudgetOppId = new Set<Id>();
        ID sysAdminProfileId = Label.CL00075;
        if(trgCtx.isDelete) {
            
            for(sobject so : trgCtx.oldList){
                Budget_Opp__c BO = (Budget_Opp__c)so;
                if (sysAdminProfileId != Userinfo.getProfileid() && BO.Account_Plan_Status__c == Label.Closed ) {
                    so.addError(Label.Cannot_Save_Changes_Account_Plan_R5); //You cannot save the changes as Account Plan Status is Closed.
                } else if(BO.Freeze_Account_Plan_Budgets__c) { 
                    so.addError(System.label.Cannot_Delete_Budget_Opp);  //Cannot_Delete_Budget_Opp => Cannot delete Budgeted Opportunities Record. 
                }
           }
       }
    }
}