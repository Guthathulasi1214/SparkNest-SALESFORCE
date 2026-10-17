trigger OpportunityClosedWon on Opportunity (before update) {   
    OpportunityClosedWonHandler.beforeUpdate(Trigger.newMap, Trigger.oldMap);
}