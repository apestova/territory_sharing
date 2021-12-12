trigger TerrUserTrigger on TerrUser__c (after insert, after update, before update, before delete, after delete) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            TerrUserHandler.onAfterInsert(Trigger.newMap);
        }
       if(Trigger.isUpdate){
            TerrUserHandler.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
        }
        if(Trigger.isDelete){
         TerrUserHandler.onAfterDelete();
        }
    }
   if(Trigger.isBefore){
        if(Trigger.isUpdate){
            TerrUserHandler.onBeforeUpdate(Trigger.newMap, Trigger.oldMap);
        }
        if(Trigger.isDelete){
            TerrUserHandler.onBeforeDelete(Trigger.oldMap);
        }
    }

}