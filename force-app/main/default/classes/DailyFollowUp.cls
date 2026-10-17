public class DailyFollowUp implements Schedulable{
    public void execute(SchedulableContext context){
        List<Lead>leads=[select Id, FirstName, LastName, OwnerId from 
                        Lead where Status='Open - Not Contacted'];
        List<Task>tasks=new List<Task>();
        for(Lead lead : leads){
            Task task=new Task();
            task.Subject = 'Follow up with Lead';
            task.WhoId =lead.Id;
            task.OwnerId=lead.OwnerId;
            task.Status = 'Not Started';
            tasks.add(task);
        }
        if(!tasks.isEmpty()){
            insert tasks;
        }
    }
    
}