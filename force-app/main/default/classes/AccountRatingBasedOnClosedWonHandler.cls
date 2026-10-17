public with sharing class AccountRatingBasedOnClosedWonHandler {
    public static void afterUpdate(Map<Id, Opportunity> oldOpp, Map<Id, Opportunity> newOpp) {
        Set<Id>accIds =new Set<Id>();
        for(Opportunity opp:newOpp.values()){
            if(opp.StageName == 'Closed Won' && oldOpp.get(opp.Id).StageName!='Closed Won' && opp.AccountId!=null){
                accIds.add(opp.AccountId);
            }
        }
        List <Account> accountToUpdate=new List<Account>();
        for(Id id: accIds){
            Account acc= new Account();
            acc.Id=id;
            acc.Rating='Hot';
            accountToUpdate.add(acc);
        }
        if(!accountToUpdate.isEmpty()){
            update accountToUpdate;
        }
        

    }
}