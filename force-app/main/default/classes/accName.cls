public class accName {
    public static void createAcc(){
        Account acc=[select Id,Name from Account where Name='Annapoorna'];
        Contact con=new Contact(
        	FirstName='Venkatesh',
            LastName='warlu',
           AccountId=acc.Id
        );
        insert con;
    }
}