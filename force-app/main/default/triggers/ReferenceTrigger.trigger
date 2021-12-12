trigger ReferenceTrigger on Reference__c (after insert, after update, before update, before delete, after delete) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            ReferenceTriggerHandler.onAfterInsert(Trigger.newMap);
        }
       
        if(Trigger.isDelete){
            ReferenceTriggerHandler.onAfterDelete();
        }
    }
    if(Trigger.isBefore){
        
        if(Trigger.isDelete){
            ReferenceTriggerHandler.onBeforeDelete(Trigger.oldMap);
        }
    }
}