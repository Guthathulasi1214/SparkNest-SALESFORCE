public class EnquiryTriggerHandler implements TriggerHandler{
	public void beforeInsert(List<Enquiry__c> newList) {
        EnquiryService.beforeInsert(newList);
    }

    public void afterInsert(List<Enquiry__c> newList) {
        EnquiryService.afterInsert(newList);
    }

    public void beforeUpdate(
        List<Enquiry__c> newList,
        Map<Id, Enquiry__c> oldMap
    ) {
        EnquiryService.beforeUpdate(newList, oldMap);
    }

    public void afterUpdate(
        List<Enquiry__c> newList,
        Map<Id, Enquiry__c> oldMap
    ) {
        EnquiryService.afterUpdate(newList, oldMap);
    }
}