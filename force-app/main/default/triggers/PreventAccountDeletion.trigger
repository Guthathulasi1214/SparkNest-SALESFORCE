trigger PreventAccountDeletion on Account (before delete) {
    PreventAccountDeletionHandler.beforeDelete(Trigger.old);
}