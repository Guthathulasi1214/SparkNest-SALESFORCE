trigger CasePriorityAutomation on Case (before insert) {
    CasePriorityAutomationHandler.beforeInsert(Trigger.new);
}