trigger AccountTrigger on Account (after insert) {
    for(Account acc : Trigger.new){
        System.debug('New Account :'+acc.Name);
    }
}