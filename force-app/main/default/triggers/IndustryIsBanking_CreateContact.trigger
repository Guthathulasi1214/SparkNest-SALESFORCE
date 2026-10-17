trigger IndustryIsBanking_CreateContact on Account (after insert) {
    IndustryIsBanking_CreateContactHandler.afterInsert(Trigger.new);
}