trigger HighValueOpportunityTeam on Opportunity (after insert) {
        HighValueOpportunityTeamHandler.afterInsert(Trigger.new);
}