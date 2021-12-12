public with sharing class TerritoryTriggerHandler {
    public static void onAfterInsert(List<Territory__c> newMapTerritory){
        TerritoryUniqueCheck.territoryNameCheckAfter(newMapTerritory);
    }
   
}