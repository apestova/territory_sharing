public with sharing class ReferenceSharingService {
    public static void territorySharingAdd(Map<Id,Reference__c> newMapReference){
        List<ContactShare> contactShrs  = new List<ContactShare>();
        List<AccountShare> existingAccountShare = [SELECT AccountId, Id,  UserOrGroupId 
          FROM AccountShare ];
        for (Reference__c ref : newMapReference.values()){
            for (AccountShare accShr : existingAccountShare){
                if (ref.Account__c == accShr.AccountId){
                    if(accShr.UserOrGroupId!=ref.CreatedById){
                        contactShrs.add(addSharingToContact('Edit', ref, accShr));
                    }
                }
            }
        }
        insert contactShrs;
    }
    
    private static ContactShare addSharingToContact(String accessLevel, Reference__c reference, AccountShare accShr){
        ContactShare contactShr = new ContactShare();
        contactShr.ContactId = reference.Contact__c;
        contactShr.UserOrGroupId = accShr.UserOrGroupId;
        contactShr.ContactAccessLevel = accessLevel;
        return contactShr;
    }
   
    public static void territorySharingRemove(Map<Id, Reference__c> oldMapReference){
        List<Id> idsUsersInTerrUsers = new List<Id>();
        List<Id> idsContactSharDel = new List<Id>();
        List<AccountShare> existingAccountShare = [SELECT AccountId, Id,  UserOrGroupId 
          FROM AccountShare ];
        for (Reference__c ref : oldMapReference.values()){
            for (AccountShare accShr : existingAccountShare){
                if (ref.Account__c == accShr.AccountId){
                   if (accShr.UserOrGroupId!= ref.CreatedById){
                        idsContactSharDel.add(ref.Contact__c);
                        idsUsersInTerrUsers.add( accShr.UserOrGroupId);
                   }
                }
            }
        }

        system.debug(idsContactSharDel);
        if(!idsContactSharDel.isEmpty()){
            List<ContactShare> removeContactShare = new List<ContactShare>();
            List<ContactShare> existingContactShare = [SELECT ContactId, Id,  UserOrGroupId 
                                                        FROM ContactShare 
                                                        WHERE ContactId IN :idsContactSharDel];
            for(ContactShare contactShare : existingContactShare){
                if(idsUsersInTerrUsers.Contains(contactShare.UserOrGroupId) ){
                    removeContactShare.add(contactShare);
                }
            }
            if(!removeContactShare.isEmpty()){
                delete removeContactShare;
            }
        }     
    }
}