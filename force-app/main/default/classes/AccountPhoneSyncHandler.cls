public with sharing class AccountPhoneSyncHandler {
    public static void beforeUpdate(Map<Id, Account> newAccountMap, Map<Id, Account> oldAccountMap){
        Set<Id>AccountIDs= new Set<Id> ();
        
        for(Id accountId : newAccountMap.keyset()){
            Account oldacc=oldAccountMap.get(accountId);
            Account newacc=newAccountMap.get(accountId);
            if(oldacc.phone!=newacc.phone){
                AccountIDs.add(accountId);
            }
        }
        if(AccountIDs.isEmpty()){
            return;
        }
        List<Contact> contactsToUpdate = [select Id, AccountId from contact where accountId in :AccountIDs];
        for(Contact con: contactsToUpdate){
            con.HomePhone=newAccountMap.get(con.AccountId).Phone;
            con.OtherPhone=oldAccountMap.get(con.AccountId).Phone;
        }
        update contactsToUpdate;
    }
}