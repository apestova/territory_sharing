public with sharing class AccountSharingService {
    public static void territorySharingAdd(Map<Id,Account> newMapAccounts){
        List<AccountShare> accountShrs  = new List<AccountShare>();
        List<TerrUser__c> listTerrUser = [SELECT Id,Territory__c, User__c FROM TerrUser__c];
        List<Account> accForBild  = findAllParents(newMapAccounts);
        for(Account acc : accForBild){
            for(TerrUser__c terruser : listTerrUser){
                if (acc.Territory__c == terruser.Territory__c){
                    accountShrs.add(addSharingToAccount('Edit', acc, terruser));
                }
            }
        }
        insert accountShrs;
    }
    private static void findAllParents(Account acc, List<Account> accForBild, List<Territory__c> allTerritories){
        for (Territory__c terr : allTerritories){
            if (acc.Territory__c == terr.id){
                if (terr.Territory__c != null){
                    Account newAcc= new Account();
                    newAcc.id = acc.id;
                    newAcc.Territory__c = terr.Territory__c;
                    accForBild.add(newAcc);
                    findAllParents(newAcc, accForBild, allTerritories);
                }
            }
        }
    }
    private static List<Account> findAllParents(Map<Id,Account> newMapAccounts){
        List<Account> accForBild  = new List<Account>();
        List<Territory__c> allTerritories = [SELECT Id,Territory__r.id  FROM Territory__c];
        for(Account acc : newMapAccounts.values()){
            findAllParents(acc, accForBild, allTerritories);
        }
        accForBild.addAll(newMapAccounts.values());
        return accForBild;
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
    public static void territorySharingRemove(Map<Id, Account> newMapAccount, Map<id, Account> oldMapAccount){
        Map<Id,Account> accountMap = new Map<Id, Account>();
        for(Account oldAccount : oldMapAccount.values()){
            if(  oldAccount.Territory__c != newMapAccount.get(oldAccount.Id).Territory__c){
                if(oldAccount.Territory__c != null){
                    accountMap.put(oldAccount.Id, oldMapAccount.get(oldAccount.Id));
                }
            }
        }
        if(!accountMap.isEmpty()){
            territorySharingRemove(accountMap);
        }
    }
    public static void territorySharingRemove(Map<Id, Account> oldMapAccount){
        List<TerrUser__c> listTerrUser = [SELECT Id,Territory__c, User__c FROM TerrUser__c];
        List<Account> accForBild  = findAllParents(oldMapAccount);
        List<Id> idsUsersInTerrUsers = new List<Id>();
        List<Id> idsAccountSharDel = new List<Id>();
        List<Id> idsContactSharDel = new List<Id>();
        List<Reference__c> references = [SELECT Account__r.id, Account__r.name,
        Contact__r.id, Contact__r.name 
        FROM Reference__c];
        for(TerrUser__c TerrUser : listTerrUser){
            for(Account acc : accForBild){
                if (acc.Territory__c == TerrUser.Territory__c){
                    idsAccountSharDel.add(acc.Id);
                    idsUsersInTerrUsers.add(TerrUser.User__c);
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