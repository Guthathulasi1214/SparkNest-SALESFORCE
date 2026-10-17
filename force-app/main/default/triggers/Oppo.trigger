trigger Oppo on Opportunity (after update) {
    Set<Id>accnts=new Set<Id>();
    for(Opportunity newOpp: Trigger.new){
        Opportunity oldOpp=Trigger.oldMap.get(newOpp.Id);
        if(newOpp.StageName=='Closed Won' && oldOpp.StageName!='Closed Won'){
            accnts.add(newOpp.AccountId);
        }
    }
    List <Account>accounts= [select Id, Has_won_Opportunity__c from Account where Id in :accnts];
        for(Account acc: accounts){
            acc.Has_won_Opportunity__c = true;
        }
    if(!accounts.isEmpty()){
        update accounts;
    }
}