public with sharing class IndustryIsBanking_CreateContactHandler {
    public static void afterInsert(List<Account> createdAccounts){
        List<Contact> contactsToCreate = new List<Contact>();
        for(Account acc: createdAccounts){
            if(acc.Industry == 'Banking'){
                Contact newContact= new Contact();
                newContact.Lastname=acc.Name;
                newContact.Phone= acc.Phone;
                newContact.AccountId =acc.Id;
                contactsToCreate.add(newContact);
            }
        }
        if(!contactsToCreate.isEmpty()){
            insert contactsToCreate;
        }
    } 
}