public with sharing class AccountTriggerHandler {
    public static void onAfterInsert(Map<Id,Account> newMapAccounts){
        AccountSharingService.territorySharingAdd(newMapAccounts);
    }
   public static void onAfterUpdate(Map<Id,Account> newMapAccounts,Map<Id,Account> oldMapAccounts){
      TerritorySharingService.territoryCheck();
    }
    public static void onBeforeUpdate(Map<Id,Account> newMapAccounts,Map<Id,Account> oldMapAccounts){
        AccountSharingService.territorySharingRemove(newMapAccounts, oldMapAccounts);
    }
    public static void onBeforeDelete(Map<Id,Account> oldMapAccounts){
        AccountSharingService.territorySharingRemove(oldMapAccounts);
    }
    public static void onAfterDelete(){
        TerritorySharingService.territoryCheck();
    }
}