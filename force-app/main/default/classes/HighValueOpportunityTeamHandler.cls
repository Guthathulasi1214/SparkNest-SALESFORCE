public with sharing class HighValueOpportunityTeamHandler {

    public static void afterInsert(List<Opportunity> newOpportunities) {

        Set<Id> opportunityIds = new Set<Id>();

        for (Opportunity opp : newOpportunities) {

            if (opp.Amount != null && opp.Amount > 5000000) {
                opportunityIds.add(opp.Id);
            }
        }

        if (opportunityIds.isEmpty()) {
            return;
        }

        User salesManager = [
            SELECT Id
            FROM User
            WHERE IsActive = true
            AND Title = 'Sales Manager'
            LIMIT 1
        ];

        List<OpportunityTeamMember> teamMembers =
            new List<OpportunityTeamMember>();

        for (Id opportunityId : opportunityIds) {

            OpportunityTeamMember teamMember =
                new OpportunityTeamMember();

            teamMember.OpportunityId = opportunityId;
            teamMember.UserId = salesManager.Id;
            teamMember.TeamMemberRole = 'Sales Manager';
            teamMember.OpportunityAccessLevel = 'Edit';

            teamMembers.add(teamMember);
        }

        if (!teamMembers.isEmpty()) {
            insert teamMembers;
        }
    }
}