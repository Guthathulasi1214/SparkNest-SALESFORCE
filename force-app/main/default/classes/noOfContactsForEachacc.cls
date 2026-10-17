public class noOfContactsForEachacc {
    public static void contForEachAcc(){
        List<Account> accounts=[
            select Id, Name , (select Id from Contacts)
            from Account
        ];
        for(Account acc: accounts){
            Integer accCnt=acc.Contacts.size();
            System.debug('Account Name :'+ acc.Name + 'has' + accCnt + 'contacts');
        }
    }
}