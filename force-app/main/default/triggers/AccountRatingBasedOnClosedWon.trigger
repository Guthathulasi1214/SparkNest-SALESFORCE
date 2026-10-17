trigger AccountRatingBasedOnClosedWon on Opportunity (after update) {
    AccountRatingBasedOnClosedWonHandler.afterUpdate(Trigger.oldMap, Trigger.newMap);
}