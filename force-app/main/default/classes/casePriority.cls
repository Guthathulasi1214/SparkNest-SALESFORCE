public  class casePriority implements Database.Batchable<Sobject>, Database.Stateful {
    public Integer totalProcessed=0;
    public Integer highPriorityCount=0;
    public Database.QueryLocator start(Database.BatchableContext bc){
        String query='SELECT Id, Status, Priority FROM Case WHERE Status=\'New\'';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc, List<Case>cases){
        for (Case c:cases){
            c.Status='Working';
            totalProcessed++;
            if(c.Priority=='High'){
                highPriorityCount++;
            }
        }
        update cases;
    }
    public void finish(Database.BatchableContext bc){
        System.debug('Totaal Cases Processed are '+totalProcessed);
        System.debug('Total High Priority Cases are '+highPriorityCount);
    }
}