@RestResource(urlMapping='/sparknest/enquiries/*')
global with sharing class SparkNestEnquiryAPI {

    global class EnquiryRequest {
        global String firstName;
        global String lastName;
        global String email;
        global String subject;
        global String enquiryType;
        global Decimal customerBudget;
    }

    global class EnquiryResponse {
        global Boolean success;
        global String message;
        global Id contactId;
        global Id enquiryId;

        global EnquiryResponse(
            Boolean success,
            String message,
            Id contactId,
            Id enquiryId
        ) {
            this.success = success;
            this.message = message;
            this.contactId = contactId;
            this.enquiryId = enquiryId;
        }
    }

    @HttpPost
    global static EnquiryResponse submitEnquiry() {
        RestResponse response = RestContext.response;

        try {
            EnquiryRequest input = (EnquiryRequest) JSON.deserialize(
                RestContext.request.requestBody.toString(),
                EnquiryRequest.class
            );

            // Scenario 1: Email is missing.
            if (input == null || String.isBlank(input.email)) {
                response.statusCode = 400;
                return new EnquiryResponse(
                    false, 'Email is required.', null, null
                );
            }

            if (String.isBlank(input.lastName) ||
                String.isBlank(input.subject) ||
                String.isBlank(input.enquiryType)) {
                response.statusCode = 400;
                return new EnquiryResponse(
                    false,
                    'Last name, subject, and enquiry type are required.',
                    null,
                    null
                );
            }

            // Search for an existing Contact by email.
            List<Contact> contacts = [
                SELECT Id
                FROM Contact
                WHERE Email = :input.email
                LIMIT 1
            ];

            Contact customer;

            if (!contacts.isEmpty()) {
                // Scenario 2: Reuse the existing Contact.
                customer = contacts[0];
            } else {
                // Scenario 3: Create a Contact for a new customer.
                customer = new Contact(
                    FirstName = input.firstName,
                    LastName = input.lastName,
                    Email = input.email
                );
                insert customer;
            }

            // Create a separate Enquiry for every submission.
            Enquiry__c enquiry = new Enquiry__c(
                Subject__c = input.subject,
                Enquiry_Type__c = input.enquiryType,
                Contact__c = customer.Id,
                Customer_Budget__c = input.customerBudget,
                Source__c = 'Website',
                Status__c = 'New'
            );

            insert enquiry;

            response.statusCode = 201;

            return new EnquiryResponse(
                true,
                'Enquiry submitted successfully.',
                customer.Id,
                enquiry.Id
            );

        } catch (Exception e) {
            response.statusCode = 400;
            return new EnquiryResponse(
                false,
                'Unable to submit enquiry: ' + e.getMessage(),
                null,
                null
            );
        }
    }
}