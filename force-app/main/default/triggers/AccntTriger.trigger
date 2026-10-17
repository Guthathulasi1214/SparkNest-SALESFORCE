trigger AccntTriger on Account (before update, after update) {
	 if (Trigger.isUpdate) {

        if (Trigger.isBefore) {
            AccountTriggerHandler.updatePhnDescriptio(
                Trigger.new,
                Trigger.oldMap
            );
        }

        if (Trigger.isAfter) {
            AccountTriggerHandler.updateRelatedOppPhone(
                Trigger.new,
                Trigger.oldMap
            );
        }
    }
}