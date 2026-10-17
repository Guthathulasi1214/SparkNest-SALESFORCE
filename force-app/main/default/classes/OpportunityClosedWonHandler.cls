public with sharing class OpportunityClosedWonHandler {
    public static void beforeUpdate(Map<Id, Opportunity> newMap, Map<Id, Opportunity> oldMap){
        for(Opportunity opp : newMap.values()){
            if(opp.StageName == 'Closed Won' && oldMap.get(opp.Id).StageName != 'Closed Won'){
                opp.CloseDate = System.today();
                opp.Type='New Customer';
            }
        }

    }
}