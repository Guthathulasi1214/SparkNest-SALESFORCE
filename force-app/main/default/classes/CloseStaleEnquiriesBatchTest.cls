@IsTest
private class CloseStaleEnquiriesBatchTest {

    @IsTest
    static void testBatchClosesEnquiryWithoutRecentActivity() {
        Enquiry__c enquiry =
            TestDataFactory.createEnquiry(
                'Eligible Enquiry',
                'In Progress',
                5000
            );
        insert enquiry;

        // The Enquiry trigger creates a follow-up Task.
        // Remove it so this test record has no recent Task activity.
        delete [
            SELECT Id
            FROM Task
            WHERE WhatId = :enquiry.Id
        ];

        Test.startTest();

        // Test the batch processing logic directly.
        new CloseStaleEnquiriesBatch().execute(
            null,
            new List<SObject>{ enquiry }
        );

        Test.stopTest();

        Enquiry__c result = [
            SELECT Status__c, Closed_Date__c
            FROM Enquiry__c
            WHERE Id = :enquiry.Id
        ];

        System.assertEquals(
            'Closed',
            result.Status__c,
            'An eligible Enquiry without recent activity should close.'
        );

        System.assertEquals(
            Date.today(),
            result.Closed_Date__c,
            'Closing the Enquiry should stamp Closed Date.'
        );
    }

    @IsTest
    static void testBatchKeepsRecentEnquiryOpen() {
        Enquiry__c enquiry =
            TestDataFactory.createEnquiry(
                'Recent Enquiry',
                'In Progress',
                5000
            );
        insert enquiry;

        Test.startTest();
        Database.executeBatch(
            new CloseStaleEnquiriesBatch(),
            200
        );
        Test.stopTest();

        Enquiry__c result = [
            SELECT Status__c
            FROM Enquiry__c
            WHERE Id = :enquiry.Id
        ];

        System.assertEquals(
            'In Progress',
            result.Status__c,
            'A recently modified Enquiry must remain In Progress.'
        );
    }
}