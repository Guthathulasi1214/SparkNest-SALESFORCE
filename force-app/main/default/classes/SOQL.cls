public class SOQL {
    public static void createOpponAccount(){
        List <Account> accList= [select Id, Name FROM Account where CreatedDate =  THIS_YEAR];
        List <Opportunity> oppToBeCreated =new List<Opportunity>();
        if(accList.size() > 0){
            for(Account acc : accList){
                Opportunity opp = new Opportunity();
                opp.Name = acc.Name;
                opp.CloseDate = System.today();
                opp.StageName = 'Prospecting';
                opp.AccountId = acc.Id;
                oppToBeCreated.add(opp);
            }
        }
        if(oppToBeCreated.size()>0){
            insert oppToBeCreated;
        }
    }
}