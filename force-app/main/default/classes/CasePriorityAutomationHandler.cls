public with sharing class CasePriorityAutomationHandler {
    public static void beforeInsert(List<Case>newCases){
        for(Case c:newCases){
            if(c.Origin== 'Email'){
                c.Priority ='Normal';
                c.Status = 'New';
            }
        }
    }
}