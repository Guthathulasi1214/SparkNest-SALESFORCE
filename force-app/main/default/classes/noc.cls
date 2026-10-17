public class noc {
    public static void numbOfCont(){
    	List <Account> accounts=[select Id,Name from Account];
        Map<Id,String> newmap=new Map<Id,String>();
        for(Account acc: accounts){
			newmap.put(acc.Id, acc.Name);
        }
        System.debug(newmap);
    }
}