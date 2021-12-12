public with sharing class TerritorySharingService {
    public static void territorySharingAdd(Map<Id,TerrUser__c> newMapTerrUsers){
        List<ContactShare> contactShrs  = new List<ContactShare>();
        List<AccountShare> accountShrs  = new List<AccountShare>();
        List<Reference__c> references = [SELECT Account__r.id, Account__r.name,
                                        Contact__r.id, Contact__r.name 
                                        FROM Reference__c];
        List<Account> AccountAndTerritory = [SELECT Id,Territory__r.id FROM Account];
        List<TerrUser__c> forBild = allChildTerritories( newMapTerrUsers);
        for(Account acc : AccountAndTerritory){
            for (TerrUser__c terruser : forBild){
                if (acc.Territory__c == terruser.Territory__c){
                    accountShrs.add(addSharingToAccount('Edit', acc, terruser));
                }
            }
        }
        insert accountShrs;
        for (Reference__c ref : references){
            for (AccountShare accShr : accountShrs){
                if (ref.Account__c == accShr.AccountId){
                    contactShrs.add(addSharingToContact('Edit', ref, accShr));
                }
            }
        }
        insert contactShrs;
    }

    private static void allChildTerritories(TerrUser__c terrUser, List<Territory__c> allTerritories, List<TerrUser__c> forBild){
        for (Territory__c territory : allTerritories){  
            if (terruser.Territory__c == territory.Territory__r.id){
                TerrUser__c newTerrUser = new TerrUser__c();
                newTerrUser.Territory__c = territory.id;
                newTerrUser.User__c = terruser.User__c;
                forBild.add(newTerrUser);
                allChildTerritories(newTerrUser, allTerritories, forBild);
            }
        }
    }

    private static List<TerrUser__c> allChildTerritories(Map<Id,TerrUser__c> mapTerrUsers){
        List<Territory__c> allTerritories= [SELECT id, Territory__r.id FROM Territory__c];
        List<TerrUser__c> forBild = new List<TerrUser__c>();
        for (TerrUser__c terruser : mapTerrUsers.values()){
            allChildTerritories(terrUser, allTerritories, forBild);
        }
        forBild.addAll(mapTerrUsers.values());
        return forBild;
    }

    private static AccountShare addSharingToAccount(String accessLevel, Account account, TerrUser__c terrUser){
        AccountShare accountShr = new AccountShare();
        accountShr.AccountId = account.Id;
        accountShr.UserOrGroupId = terrUser.User__c;
        accountShr.AccountAccessLevel = accessLevel;
        accountShr.OpportunityAccessLevel = 'Read';
        accountShr.CaseAccessLevel ='Edit';
        return accountShr;
    }
    private static ContactShare addSharingToContact(String accessLevel, Reference__c reference, AccountShare accShr){
        ContactShare contactShr = new ContactShare();
        contactShr.ContactId = reference.Contact__c;
        contactShr.UserOrGroupId = accShr.UserOrGroupId;
        contactShr.ContactAccessLevel = accessLevel;
        return contactShr;
    }

    
    public static void territoryCheck(){
        List<TerrUser__c> terrUserCheck = [SELECT Territory__c, User__c, Id
        FROM TerrUser__c];
        Map<id, TerrUser__c> terrUserCheckMap = new Map<id, TerrUser__c>();
        for (TerrUser__c terruser : terrUserCheck){
            terrUserCheckMap.put(terruser.id, terruser);   
        }
        if(!terrUserCheckMap.isEmpty()){
            territorySharingAdd(terrUserCheckMap);
        }
    }
    public static void territorySharingRemove(Map<Id, TerrUser__c> newMapTerrUsers, Map<Id, TerrUser__c> oldMapTerrUsers){
        Map<Id,TerrUser__c> terrUserMap = new Map<Id, TerrUser__c>();
        for(TerrUser__c oldTerrUser : oldMapTerrUsers.values()){
          if(  oldTerrUser.Territory__c != newMapTerrUsers.get(oldTerrUser.Id).Territory__c){
                if(oldTerrUser.Territory__c != null){
                    terrUserMap.put(oldTerrUser.Id, oldMapTerrUsers.get(oldTerrUser.Id));
                }
            }
        }
        if(!terrUserMap.isEmpty()){
            territorySharingRemove(terrUserMap);
        }
    }
    public static void territorySharingRemove(Map<Id, TerrUser__c> oldMapTerrUsers){
        List<Id> idsUsersInTerrUsers = new List<Id>();
        List<Id> idsAccountSharDel = new List<Id>();
        List<Id> idsContactSharDel = new List<Id>();
        List<Account> AccountAndTerritory = [SELECT Id,Territory__r.id FROM Account];
        List<Reference__c> references = [SELECT Account__r.id, Account__r.name,
                                        Contact__r.id, Contact__r.name 
                                        FROM Reference__c];
        List<TerrUser__c> forBild = allChildTerritories( oldMapTerrUsers);
        for(TerrUser__c oldTerrUser : forBild){
            if(oldTerrUser.Territory__c != null){
                for(Account acc : AccountAndTerritory){
                    if (acc.Territory__c == oldTerrUser.Territory__c){
                        idsAccountSharDel.add(acc.Id);
                        idsUsersInTerrUsers.add(oldTerrUser.User__c);
                    }
                }
            }
        }

        if(!idsAccountSharDel.isEmpty()){
            List<AccountShare> removeAccountShare = new List<AccountShare>();
            List<AccountShare> existingAccountShare = [SELECT AccountId, Id,  UserOrGroupId 
                                                    FROM AccountShare 
                                                    WHERE AccountId IN :idsAccountSharDel];
            for(AccountShare accountShare :  existingAccountShare){
                if(idsUsersInTerrUsers.Contains(accountShare.UserOrGroupId)){
                    removeAccountShare.add(accountShare);
                }
            }
            if(!removeAccountShare.isEmpty()){
                for (Reference__c ref : references){
                    for (AccountShare accShr :removeAccountShare){
                        if (ref.Account__c == accShr.AccountId){       
                            idsContactSharDel.add(ref.Contact__c);
                        }
                    }
                }
                delete removeAccountShare;
            }
        }
        if(!idsContactSharDel.isEmpty()){
            List<ContactShare> removeContactShare = new List<ContactShare>();
            List<ContactShare> existingContactShare = [SELECT ContactId, Id,  UserOrGroupId 
                                                        FROM ContactShare 
                                                        WHERE ContactId IN :idsContactSharDel];
            for(ContactShare contactShare : existingContactShare){
                if(idsUsersInTerrUsers.Contains(contactShare.UserOrGroupId)){
                    removeContactShare.add(contactShare);
                }
            }
            if(!removeContactShare.isEmpty()){
                delete removeContactShare;
            }
        }    
    }
}