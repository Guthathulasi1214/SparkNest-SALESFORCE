public with sharing class OpportunityAccountSummaryHandler {

    public static void afterInsert(List<Opportunity> newOpportunities) {

        Set<Id> accountIds = new Set<Id>();

        for (Opportunity opp : newOpportunities) {
            if (opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }

        recalculateAccounts(accountIds);
    }


    public static void afterUpdate(
        Map<Id, Opportunity> newOpportunityMap,
        Map<Id, Opportunity> oldOpportunityMap
    ) {

        Set<Id> accountIds = new Set<Id>();

        for (Opportunity opp : newOpportunityMap.values()) {

            Opportunity oldOpp = oldOpportunityMap.get(opp.Id);

            if (opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }

            if (oldOpp.AccountId != null) {
                accountIds.add(oldOpp.AccountId);
            }
        }

        recalculateAccounts(accountIds);
    }


    public static void afterDelete(List<Opportunity> oldOpportunities) {

        Set<Id> accountIds = new Set<Id>();

        for (Opportunity opp : oldOpportunities) {
            if (opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }

        recalculateAccounts(accountIds);
    }


    public static void recalculateAccounts(Set<Id> accountIds) {

        if (accountIds.isEmpty()) {
            return;
        }

        Map<Id, Integer> opportunityCountMap = new Map<Id, Integer>();
        Map<Id, Decimal> opportunityAmountMap = new Map<Id, Decimal>();

        for (AggregateResult result : [
            SELECT AccountId,
                   COUNT(Id) opportunityCount,
                   SUM(Amount) opportunityAmount
            FROM Opportunity
            WHERE AccountId IN :accountIds
            GROUP BY AccountId
        ]) {

            Id accountId = (Id) result.get('AccountId');
            Integer opportunityCount = (Integer) result.get('opportunityCount');
            Decimal opportunityAmount = (Decimal) result.get('opportunityAmount');

            opportunityCountMap.put(accountId, opportunityCount);
            opportunityAmountMap.put(accountId, opportunityAmount);
        }


        List<Account> accountsToUpdate = [
            SELECT Id,
                   Total_Opportunity_Count__c,
                   Total_Opportunity_Amount__c
            FROM Account
            WHERE Id IN :accountIds
        ];


        for (Account acc : accountsToUpdate) {

            if (opportunityCountMap.containsKey(acc.Id)) {
                acc.Total_Opportunity_Count__c =
                    opportunityCountMap.get(acc.Id);

                acc.Total_Opportunity_Amount__c =
                    opportunityAmountMap.get(acc.Id);
            }
            else {
                acc.Total_Opportunity_Count__c = 0;
                acc.Total_Opportunity_Amount__c = 0;
            }
        }


        update accountsToUpdate;
    }
}