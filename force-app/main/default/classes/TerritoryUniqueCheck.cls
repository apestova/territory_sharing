public with sharing class TerritoryUniqueCheck {
    public static void territoryNameCheckAfter(List<Territory__c> newMapTerritory) {
        List<Territory__c> territory = [SELECT id, name, Territory__r.id
        FROM Territory__c];
        for(Territory__c terr : newMapTerritory){
            for (Territory__c existingTerritory : territory){
                if (terr.name == existingTerritory.name){
                    if (terr.Territory__c == existingTerritory.Territory__c){
                        if (terr.id != existingTerritory.id){
                        	terr.addError('Not unique name');
                        }
                    }
                }
            }
        }
    }
}