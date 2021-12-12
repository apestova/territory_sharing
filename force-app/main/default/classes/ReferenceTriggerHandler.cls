public with sharing class ReferenceTriggerHandler {
    public static void onAfterInsert(Map<Id,Reference__c> newMapReference){
       ReferenceSharingService.territorySharingAdd(newMapReference);
    }
   
    public static void onBeforeDelete(Map<Id,Reference__c> oldMapReference){
        ReferenceSharingService.territorySharingRemove(oldMapReference);
    }
    public static void onAfterDelete(){
        TerritorySharingService.territoryCheck();
    }
}