trigger trgOpportunityTeam on OpportunityTeamMember (after delete, after insert,after update) {
If(!System.label.SYS_RunOpportunityTrigger.equalsIgnoreCase('NO')){
     
    ClsTriggerFactory.createHandler(OpportunityTeamMember.sObjectType);
    }
}