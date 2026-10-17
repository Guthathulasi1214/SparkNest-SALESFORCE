trigger LeadTrigger on Lead (before insert) {
    LeadTriggerHandler.beforeInsert(Trigger.new);
}