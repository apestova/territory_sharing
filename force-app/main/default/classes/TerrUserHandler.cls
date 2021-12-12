public with sharing class TerrUserHandler {
    public static void onAfterInsert(Map<Id,TerrUser__c> newMapTerrUsers){
       TerritorySharingService.territorySharingAdd(newMapTerrUsers);
    }
   public static void onAfterUpdate(Map<Id,TerrUser__c> newMapTerrUsers, Map<Id,TerrUser__c> oldMapTerrUsers){
       TerritorySharingService.territoryCheck();
    }
    public static void onBeforeUpdate(Map<Id,TerrUser__c> newMapTerrUsers, Map<Id,TerrUser__c> oldMapTerrUsers){
        TerritorySharingService.territorySharingRemove(newMapTerrUsers, oldMapTerrUsers);
    }
    public static void onBeforeDelete(Map<Id,TerrUser__c> oldMapTerrUsers){
        TerritorySharingService.territorySharingRemove(oldMapTerrUsers);
    }
    public static void onAfterDelete(){
        TerritorySharingService.territoryCheck();
    }
}