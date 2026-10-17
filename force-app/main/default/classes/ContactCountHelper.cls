public class con {
    public static void cnt(){
        List<Account>accounts=[select Id,Name, (select Id from Contacts) from Account];
        Integer max_Cnt=0;
        String name;
        for(Account acc:accounts){
            Integer count=acc.Contacts.size();
            if(count>max_Cnt){
           		max_Cnt=count;     
                name=acc.Name;
            }
        }
        System.debug('Maximum contacts are for this account ' + name + ' and the count is '+max_Cnt);
        
    }
}