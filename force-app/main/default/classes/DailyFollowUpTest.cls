@isTest
public class DailyFollowUpTest {
	@isTest
    public static void testDailyFollowUp(){
        Lead l1=new Lead(
        	FirstName = 'thulasi',
            LastName =' Gutha',
            Company=' Test comapny',
            Status='Open - Not Contacted',
            OwnerId=UserInfo.getUserId()
        );
        insert l1;
        Test.startTest();
        String cronExpression = '0 0 8 * * ?';
        System.schedule(
        	'Test Daily Follow Up',
            cronExpression,
            new DailyFollowUp()
        );
        Test.stopTest();
        List<Task>tasks=[select Id, Subject, WhoId, OwnerId, Status from task where WhoId=:l1.Id];
        System.assertEquals(1, tasks.size());
        System.assertEquals(1, tasks.size());
        
        // 6. Verify Task fields
        System.assertEquals(
            'Follow up with Lead',
            tasks[0].Subject
        );
        
        System.assertEquals(
            l1.Id,
            tasks[0].WhoId
        );
        
        System.assertEquals(
            l1.OwnerId,
            tasks[0].OwnerId
        );
        
        System.assertEquals(
            'Not Started',
            tasks[0].Status
        );
        
    }
}