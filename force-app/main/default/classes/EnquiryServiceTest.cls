@isTest
private class EnquiryServiceTest {

    @isTest
    static void testDefaultStatusAndFollowUpTask() {
        Enquiry__c enquiry = TestDataFactory.createEnquiry(
            'Test Subject',
            null,
            5000
        );

        Test.startTest();
        insert enquiry;
        Test.stopTest();

        Enquiry__c savedEnquiry = [
            SELECT Id, Status__c, OwnerId, Subject__c
            FROM Enquiry__c
            WHERE Id = :enquiry.Id
        ];

        System.assertEquals(
            'New',
            savedEnquiry.Status__c,
            'Blank Status should default to New.'
        );

        List<Task> tasks = [
            SELECT Id, Subject, OwnerId, WhatId, ActivityDate
            FROM Task
            WHERE WhatId = :enquiry.Id
        ];

        System.assertEquals(
            1,
            tasks.size(),
            'One follow-up Task should be created.'
        );

        System.assertEquals(
            'Follow up: Test Subject',
            tasks[0].Subject
        );

        System.assertEquals(
            savedEnquiry.OwnerId,
            tasks[0].OwnerId,
            'Task should belong to the Enquiry owner.'
        );

        System.assertEquals(
            Date.today().addDays(3),
            tasks[0].ActivityDate,
            'Task should be due in three days.'
        );
    }

    @IsTest
    static void testInvalidBudget() {
        Enquiry__c enquiry = TestDataFactory.createEnquiry(
            'Invalid Budget',
            null,
            500
        );

        Test.startTest();
        Database.SaveResult result = Database.insert(enquiry, false);
        Test.stopTest();

        System.assertEquals(
            false,
            result.isSuccess(),
            'Budget below 1000 should fail.'
        );

        Boolean expectedErrorFound = false;

        for (Database.Error err : result.getErrors()) {
            if (err.getMessage().contains(
                'Customer budget must be at least ₹1,000'
            )) {
                expectedErrorFound = true;
            }
        }

        System.assertEquals(
            true,
            expectedErrorFound,
            'The expected budget error should be returned.'
        );
    }

    @IsTest
    static void testClosedDate() {
        Enquiry__c enquiry = TestDataFactory.createEnquiry(
            'Close Me',
            'In Progress',
            5000
        );
        insert enquiry;

        Test.startTest();
        enquiry.Status__c = 'Closed';
        update enquiry;
        Test.stopTest();

        Enquiry__c savedEnquiry = [
            SELECT Status__c, Closed_Date__c
            FROM Enquiry__c
            WHERE Id = :enquiry.Id
        ];

        System.assertEquals('Closed', savedEnquiry.Status__c);

        System.assertEquals(
            Date.today(),
            savedEnquiry.Closed_Date__c,
            'Closed Date should be set to today.'
        );
    }

    @IsTest
    static void testBulkInsert200Enquiries() {
        List<Enquiry__c> enquiries =
            TestDataFactory.createEnquiries(200);

        Test.startTest();
        insert enquiries;
        Test.stopTest();

        System.assertEquals(
            200,
            [
                SELECT COUNT()
                FROM Enquiry__c
                WHERE Subject__c LIKE 'Bulk Enquiry%'
            ],
            'All 200 Enquiries should be inserted.'
        );

        Set<Id> enquiryIds = new Map<Id, Enquiry__c>(
            enquiries
        ).keySet();

        System.assertEquals(
            200,
            [
                SELECT COUNT()
                FROM Task
                WHERE WhatId IN :enquiryIds
            ],
            'Each Enquiry should have a follow-up Task.'
        );
    }
}