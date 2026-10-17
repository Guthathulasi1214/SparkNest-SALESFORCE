trigger EnquiryTrigger on Enquiry__c (before insert,after insert,before update,after update) {
	 TriggerDispatcher.dispatch(
        new EnquiryTriggerHandler(),
        Trigger.new,
        Trigger.isUpdate ? Trigger.oldMap : null
    );
}