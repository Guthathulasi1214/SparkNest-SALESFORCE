trigger OwnerChange on Account (after update) {
    for(Account acc: Trigger.new){
        Account oldAcc=Trigger.oldMap.get(acc.Id);
        if(acc.OwnerId!=oldAcc.ownerId){
            System.debug('Owner changed for '+ oldAcc.Name);
        }
    } 
}