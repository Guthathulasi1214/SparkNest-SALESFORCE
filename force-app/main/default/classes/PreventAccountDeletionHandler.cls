public with sharing class PreventAccountDeletionHandler { 

    public static void beforeDelete(List<Account> accountsToDelete){ 

        Set<Id> accountIDs = new Set<Id>(); 

        for(Account acc : accountsToDelete){ 
            accountIDs.add(acc.Id); 
        } 

        Map<Id, Integer> contactsCountMap = new Map<Id, Integer>(); 

        for(AggregateResult result : [
            SELECT AccountId, COUNT(Id) contactCount
            FROM Contact
            WHERE AccountId IN :accountIDs
            GROUP BY AccountId
        ]){ 

            Id accountId = (Id) result.get('AccountId'); 
            Integer contactCount = (Integer) result.get('contactCount'); 

            contactsCountMap.put(accountId, contactCount); 
        } 

        for(Account acc : accountsToDelete){ 

            if(
                contactsCountMap.containsKey(acc.Id) &&
                contactsCountMap.get(acc.Id) >= 2
            ){ 
                acc.addError('This Account cannot be deleted because it has two or more associated Contacts.'); 
            } 
        } 
    } 
}