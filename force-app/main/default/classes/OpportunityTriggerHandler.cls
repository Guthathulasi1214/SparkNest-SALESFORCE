public with sharing class OpportunityTriggerHandler {
    public static void beforeUpdate(
        Map<Id, Opportunity> newOppMap,
        Map<Id, Opportunity> oldOppMap
    ) {
        for (Opportunity opp : newOppMap.values()) {
            Opportunity oldOpp = oldOppMap.get(opp.Id);
            if (
                opp.StageName == 'Closed Won' &&
                oldOpp.StageName != 'Closed Won'
            ) {
                opp.CloseDate = System.today();
                opp.Type = 'New Customer';
            }
        }
    }

    public static void afterUpdate(
        Map<Id, Opportunity> newOppMap,
        Map<Id, Opportunity> oldOppMap
    ) {
        Set<Id> accountIds = new Set<Id>();
        List<Opportunity> closedWonOpportunities =
            new List<Opportunity>();
        for (Opportunity opp : newOppMap.values()) {
            Opportunity oldOpp = oldOppMap.get(opp.Id);
            if (
                opp.StageName == 'Closed Won' &&
                oldOpp.StageName != 'Closed Won'
            ) {
                if (opp.AccountId != null) {
                    accountIds.add(opp.AccountId);
                }

                closedWonOpportunities.add(opp);
            }
        }
        if (accountIds.isEmpty()) {
            return;
        }
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accountId : accountIds) {

            Account acc = new Account();

            acc.Id = accountId;
            acc.Rating = 'Hot';

            accountsToUpdate.add(acc);
        }
        Map<Id, Integer> opportunityCountMap =
            new Map<Id, Integer>();
        Map<Id, Decimal> opportunityAmountMap =
            new Map<Id, Decimal>();
        for (AggregateResult result : [
            select AccountId,
                   count(Id) opportunityCount,
                   sum(Amount) opportunityAmount
            from Opportunity
            where AccountId IN :accountIds
            group BY AccountId
        ]) {
            Id accountId = (Id) result.get('AccountId');
            Integer opportunityCount =
                (Integer) result.get('opportunityCount');
            Decimal opportunityAmount =
                (Decimal) result.get('opportunityAmount');
            opportunityCountMap.put(
                accountId,
                opportunityCount
            );
            opportunityAmountMap.put(
                accountId,
                opportunityAmount
            );
        }
        for (Account acc : accountsToUpdate) {
            if (opportunityCountMap.containsKey(acc.Id)) {
                acc.Total_Opportunity_Count__c =
                    opportunityCountMap.get(acc.Id);
                acc.Total_Opportunity_Amount__c =
                    opportunityAmountMap.get(acc.Id);

            } else {
              acc.Total_Opportunity_Count__c = 0;
                acc.Total_Opportunity_Amount__c = 0;
            }
        }
        List<OpportunityTeamMember> teamMembers =
            new List<OpportunityTeamMember>();

        Boolean hasHighValueOpportunity = false;

        for (Opportunity opp : closedWonOpportunities) {
            if (
                opp.Amount != null &&
                opp.Amount > 5000000
            ) {
                hasHighValueOpportunity = true;
            }
        }
        if (hasHighValueOpportunity) {
            User salesManager = [
                select Id
                from User
                where IsActive = true
                and Title = 'Sales Manager'
                limit 1
            ];
            for (Opportunity opp : closedWonOpportunities) {
                if (
                    opp.Amount != null &&
                    opp.Amount > 5000000
                ) {
                    OpportunityTeamMember teamMember =
                        new OpportunityTeamMember();
                    teamMember.OpportunityId = opp.Id;
                    teamMember.UserId = salesManager.Id;
                    teamMember.TeamMemberRole = 'Sales Manager';
                    teamMember.OpportunityAccessLevel = 'Edit';

                    teamMembers.add(teamMember);
                }
            }
        }
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
        if (!teamMembers.isEmpty()) {
            insert teamMembers;
        }
    }
}