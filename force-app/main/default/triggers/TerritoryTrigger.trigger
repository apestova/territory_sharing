trigger TerritoryTrigger on Territory__c (after insert, before insert) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            TerritoryTriggerHandler.onAfterInsert(Trigger.new);
        }
    }
   
}