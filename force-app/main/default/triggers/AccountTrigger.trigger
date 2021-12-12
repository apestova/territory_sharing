trigger AccountTrigger on Account (after insert, after update, before update, before delete, after delete) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            AccountTriggerHandler.onAfterInsert(Trigger.newMap);
        }
        if(Trigger.isUpdate){
            AccountTriggerHandler.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
        }
        if(Trigger.isDelete){
            AccountTriggerHandler.onAfterDelete();
        }
    }
    if(Trigger.isBefore){
        if(Trigger.isUpdate){
            AccountTriggerHandler.onBeforeUpdate(Trigger.newMap, Trigger.oldMap);
        }
        if(Trigger.isDelete){
            AccountTriggerHandler.onBeforeDelete(Trigger.oldMap);
        }
    }
}