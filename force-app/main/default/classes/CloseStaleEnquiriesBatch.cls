public class CloseStaleEnquiriesBatch
    implements Database.Batchable<SObject> {

    public Database.QueryLocator start(
        Database.BatchableContext bc
    ) {
        DateTime cutoff = System.now().addDays(-30);

        return Database.getQueryLocator([
            SELECT Id, Status__c, LastModifiedDate
            FROM Enquiry__c
            WHERE Status__c = 'In Progress'
            AND LastModifiedDate < :cutoff
        ]);
    }

    public void execute(
        Database.BatchableContext bc,
        List<SObject> scope
    ) {
        Set<Id> enquiryIds = new Set<Id>();

        for (SObject item : scope) {
            enquiryIds.add(item.Id);
        }

        DateTime cutoff = System.now().addDays(-30);
        Set<Id> enquiriesWithRecentActivity = new Set<Id>();

        // Check Tasks created during the last 30 days.
        for (Task taskRecord : [
            SELECT WhatId
            FROM Task
            WHERE WhatId IN :enquiryIds
            AND CreatedDate >= :cutoff
        ]) {
            enquiriesWithRecentActivity.add(taskRecord.WhatId);
        }

        // Check Events occurring during the last 30 days.
        for (Event eventRecord : [
            SELECT WhatId
            FROM Event
            WHERE WhatId IN :enquiryIds
            AND StartDateTime >= :cutoff
        ]) {
            enquiriesWithRecentActivity.add(eventRecord.WhatId);
        }

        List<Enquiry__c> enquiriesToUpdate =
            new List<Enquiry__c>();

        for (SObject item : scope) {
            Enquiry__c enquiry = (Enquiry__c) item;

            if (!enquiriesWithRecentActivity.contains(enquiry.Id)) {
                enquiry.Status__c = 'Closed';
                enquiriesToUpdate.add(enquiry);
            }
        }

        if (!enquiriesToUpdate.isEmpty()) {
            update enquiriesToUpdate;
        }
    }

    public void finish(Database.BatchableContext bc) {
        // Batch processing is complete.
    }
}