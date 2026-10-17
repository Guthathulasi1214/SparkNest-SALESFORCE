trigger AccountTriggerUpdate on Account (after update) {
    for(Account acc: Trigger.new){
        Account oldacc=Trigger.oldMap.get(acc.id);
        if(acc.Name!=oldacc.Name){
            System.debug('Account Name Chnaged from '+ oldacc.Name+' to '+acc.Name);
        }
        
    }
}