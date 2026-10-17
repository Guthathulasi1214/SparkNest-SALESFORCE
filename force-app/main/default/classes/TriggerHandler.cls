public interface TriggerHandler {
	void beforeInsert(List<Enquiry__c>newList);
    void afterInsert(List<Enquiry__c>newList);
    void beforeUpdate(List<Enquiry__c>newList, Map<Id, Enquiry__c> oldMap);
    void afterUpdate(List<Enquiry__c> newRecords, Map<Id, Enquiry__c> oldMap);

    
}