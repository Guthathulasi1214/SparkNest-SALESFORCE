public class TriggerDispatcher {
	public static void dispatch(TriggerHandler handler,
    List<Enquiry__c>newList,Map<Id,Enquiry__c>oldMap
    ){
        if(Trigger.isBefore && Trigger.isInsert){
            handler.beforeInsert(newList);
        }else if (Trigger.isAfter && Trigger.isInsert) {
            handler.afterInsert(newList);
        } else if (Trigger.isBefore && Trigger.isUpdate) {
            handler.beforeUpdate(newList, oldMap);
        } else if (Trigger.isAfter && Trigger.isUpdate) {
            handler.afterUpdate(newList, oldMap);
        }
    }
}