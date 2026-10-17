trigger OpportunityTrigger on Opportunity (before update, after update) {
    if(Trigger.isBefore && Trigger.isUpdate){
        opportunityTriggerHandler.beforeUpdate(Trigger.newMap, Trigger.oldMap);
    }
    if(Trigger.isAfter && Trigger.isUpdate){
        OpportunityTriggerHandler.afterUpdate(Trigger.newMap, Trigger.oldMap);
    }
}