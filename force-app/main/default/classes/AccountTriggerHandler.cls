public class AccountTriggerHandler {
    public static void updatePhnDescriptio(List<Account> newList, Map<Id,Account>oldMap){
        
        for(Account acc: newList){
            if(oldMap!=null && acc.Phone !=oldMap.get(acc.Id).Phone){
                acc.Description='updated phone field on account';
            }
        }
    }
    public static void updateRelatedOppPhone(List<Account>newList, Map<Id,Account>oldMap){
        List<Opportunity>oppList=new List<Opportunity>();
        Map<Id,Account>accIds=new Map<Id,Account>();
        for(Account acc:newList){
            if(acc.Phone!=oldMap.get(acc.Id).Phone){
                accIds.put(acc.Id,acc);
            }
        }
        oppList=[select Id, AccountId ,Account_Phone__c from Opportunity where AccountId in: accIds.keySet()];
        for(Opportunity opp:oppList){
            opp.Account_Phone__c=accIds.get(opp.AccountId).Phone;
        }
        update oppList;
    }
}