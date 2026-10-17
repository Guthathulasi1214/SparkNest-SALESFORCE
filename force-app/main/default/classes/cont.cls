public class cont {
    public static void Ind(){
       List <Account> acc=[select Id, Name,
                          (select Id, Name from opportunities where StageName='Closed Won')
                          from Account
        ];
        for(Account acnt:acc){
            if(!acnt.Opportunities.isEmpty()){
                            System.debug('Accunt Name is: ' + acnt.Name + '\n');

            }
        }
    }
}