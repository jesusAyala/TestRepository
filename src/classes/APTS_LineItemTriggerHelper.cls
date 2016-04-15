/*************************************************************
@Name: APTS_LineItemTriggerHelper
@Author: Axaykumar Varu
@CreateDate: 10.DEC.2015
@Description: 
@UsedBy: Trigger APTS_LineItemTrigger
******************************************************************/
public with sharing class APTS_LineItemTriggerHelper {

    
    public static void onDeleteValidation(List<Apttus_Config2__LineItem__c> deletedLineItems){
        
        Set<String> statusForValidation = new Set<String>();
    
        //Quotation Statuses - Apttus_Proposal__Approval_Stage__c - MSPA Statuses - Apttus__Status__c 
        statusForValidation.add('Expired');
        statusForValidation.add('Approval Required');
        statusForValidation.add('Approved but failed to load on SAP');
        statusForValidation.add('Approved');
        statusForValidation.add('Approved but Action Required');
        statusForValidation.add('In Review');
        statusForValidation.add('Approval In Progress');
        statusForValidation.add('Generated');
        statusForValidation.add('Presented');
        statusForValidation.add('Rejected');
        statusForValidation.add('Pending Approval');
        
        for(Apttus_Config2__LineItem__c lineItem : deletedLineItems){
            
            if(lineItem.APTS_BusinessObjectStatus__c != null && statusForValidation.contains(lineItem.APTS_BusinessObjectStatus__c)){
                lineItem.addError(Label.APTS_LineItemDeleteValidation);
            }
        }
    }
}