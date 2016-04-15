trigger OpportunityProductTrigger on OpportunityLineItem (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
    If(!System.label.SYS_RunOpportunityProductTrigger.equalsIgnoreCase('NO')){
        ClsTriggerFactory.createHandler(OpportunityLineItem.sObjectType);
    }
}