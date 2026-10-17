trigger AccntTrigger on Account (after update) {
	AccntHandler.updateCase(Trigger.new,Trigger.oldMap);
}