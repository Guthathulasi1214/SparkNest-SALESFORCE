public class AccntHandler {
    public static void updateCase(List<Account> newAccountss,Map<Id,Account>oldMap){
        Set<Id> accids = new Set<Id>();
        for(Account acc: newAccountss){
            Account oldacc=oldMap.get(acc.Id);
            if(acc.Type =='Customer - Direct' && oldAcc.Type!='Customer - Direct'){
                accids.add(acc.Id);
            }
        }
        if(accids.isEmpty()){
            return;
        }
        List<Case>casesforupdate=[SELECT Id, Priority from Case where AccountId IN :accids];
        for(Case casee:casesforupdate){
            casee.Priority='High';
        }
        if(!casesforupdate.isEmpty()){
            update casesforupdate;
        }
    }
}