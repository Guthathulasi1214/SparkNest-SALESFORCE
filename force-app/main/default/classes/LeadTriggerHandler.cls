public with sharing class LeadTriggerHandler {
    public static void beforeInsert(List <Lead> newLeads){
        for(Lead lead : newLeads){
            if(lead.LeadSource == 'Web'){
                lead.Rating = 'Cold';
            }else{
                lead.Rating = 'Hot';
            }
        }
    }
}