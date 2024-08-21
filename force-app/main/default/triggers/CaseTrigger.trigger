trigger CaseTrigger on Case (after insert, after update, after delete, after undelete) {
    TriggerHandlerDispatcher.dispatch(CaseTriggerHandler.Factory.class);
}