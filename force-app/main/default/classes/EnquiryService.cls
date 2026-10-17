public class EnquiryService {
    public static void beforeInsert(List<Enquiry__c> newList) {
        for (Enquiry__c enquiry : newList) {

            if (String.isBlank(enquiry.Status__c)) {
                enquiry.Status__c = 'New';
            }

            if (enquiry.Customer_Budget__c != null &&
                enquiry.Customer_Budget__c < 1000) {
                enquiry.Customer_Budget__c.addError(
                    'Customer budget must be at least ₹1,000'
                );
            }
        }
    }

    public static void afterInsert(List<Enquiry__c> newList) {
        List<Task> tasksToInsert = new List<Task>();

        for (Enquiry__c enquiry : newList) {
            Task followUp = new Task();
            followUp.Subject = 'Follow up: ' + enquiry.Subject__c;
            followUp.ActivityDate = Date.today().addDays(3);
            followUp.OwnerId = enquiry.OwnerId;
            followUp.WhatId = enquiry.Id;
            followUp.Status = 'Not Started';

            tasksToInsert.add(followUp);
        }

        if (!tasksToInsert.isEmpty()) {
            insert tasksToInsert;
        }
    }

    public static void beforeUpdate(
        List<Enquiry__c> newList,
        Map<Id, Enquiry__c> oldMap
    ) {
        for (Enquiry__c enquiry : newList) {
            Enquiry__c oldEnquiry = oldMap.get(enquiry.Id);

            if (enquiry.Status__c == 'Closed' &&
                oldEnquiry.Status__c != 'Closed') {
                enquiry.Closed_Date__c = Date.today();
            }
        }
    }

    // After Update.
    public static void afterUpdate(
        List<Enquiry__c> newList,
        Map<Id, Enquiry__c> oldMap
    ) {
        // No additional after-update logic is required here.
    }
}