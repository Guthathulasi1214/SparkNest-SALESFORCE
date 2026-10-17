@isTest
public class casePriorityTest {
    @isTest
    static void casePriorityTest() {
        List<Case>cases=new List<Case>();
        cases.add(new Case(
            Subject='Test Case1',
            Status='New',
            Priority='High'
        ));
        cases.add(new Case(
            Subject='Test case 2',
            Status='New',
            Priority='Medium'
        ));
        cases.add(new Case(
            Subject='Test Case3',
            Status='Working',
            Priority='High'
        ));
        insert cases;
        casePriority batch=new casePriority();
        Test.startTest();
        Database.executeBatch(batch,2);
        Test.stopTest();
    }
}