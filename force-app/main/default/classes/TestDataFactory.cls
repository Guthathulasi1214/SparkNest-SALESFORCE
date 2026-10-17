@isTest
public class TestDataFactory {

    public static Enquiry__c createEnquiry(
        String subject,
        String status,
        Decimal budget
    ) {
        Enquiry__c enquiry = new Enquiry__c();

        enquiry.Name = 'Test Enquiry';
        enquiry.Subject__c = subject;
        enquiry.Status__c = status;
        enquiry.Customer_Budget__c = budget;
        enquiry.Enquiry_Type__c = 'Product Enquiry';

        return enquiry;
    }

    public static List<Enquiry__c> createEnquiries(Integer count) {
        List<Enquiry__c> enquiries = new List<Enquiry__c>();

        for (Integer i = 0; i < count; i++) {
            enquiries.add(
                createEnquiry(
                    'Bulk Enquiry ' + i,
                    null,
                    5000
                )
            );
        }

        return enquiries;
    }
}