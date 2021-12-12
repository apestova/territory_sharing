@isTest
private class TestForAll {
    @testSetup static void setup() {
        Contact con = new Contact(LastName = 'ContactTest');
        Profile p = [SELECT Id FROM Profile WHERE Name='TerritoryUser']; 
        User user = new User(Alias = 'standt', Email='standarduser@testorg.com', 
        	EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        	LocaleSidKey='en_US', ProfileId = p.Id, 
        	TimeZoneSidKey='America/Los_Angeles', UserName='territoryUser@testorg.com');
        insert con;
        insert user;   
        Territory__c territoryParentParent = new Territory__c(Name='TestParentParent');
        insert territoryParentParent;
        Territory__c territoryParent = new Territory__c(Name='TestParent', Territory__c = territoryParentParent.id);
        insert territoryParent;
      	Territory__c territoryP = new Territory__c(Name='TestP', Territory__c = territoryParent.id);
        insert territoryP;
        Territory__c territory = new Territory__c(Name='Test', Territory__c = territoryP.id);
        insert territory;
        Territory__c territoryForChange = new Territory__c(Name='TestForChange');
        insert territoryForChange;
    }
    @isTest static void TestReference() {
        Contact con = [SELECT Id FROM Contact WHERE LastName='ContactTest']; 
        User user = [SELECT Id FROM User WHERE LastName='Testing']; 
        Territory__c territory = [SELECT Id FROM Territory__c WHERE Name='Test']; 
        Account acc = new Account(Name = 'AccountTest', Territory__c = territory.id);
        insert acc;
       	Reference__c ref = new Reference__c(Account__c = acc.id, Contact__c = con.id);
        Territory__c territoryParentParent = [SELECT Id FROM Territory__c WHERE Name='TestParentParent'];
        TerrUser__c terruser = new TerrUser__c(Territory__c = territoryParentParent.id, User__c = user.id);
        insert terruser;
        
        Test.startTest();
        Database.SaveResult resultInsert = Database.insert(ref, false);
        Database.DeleteResult resultDelete = Database.Delete(ref, false);
        Test.stopTest();
    
        System.assert(resultInsert.isSuccess());
        System.assert(resultDelete.isSuccess());
    }
    @isTest static void TestTerrUser() {
        Contact con = [SELECT Id FROM Contact WHERE LastName='ContactTest']; 
        User user = [SELECT Id FROM User WHERE LastName='Testing']; 
        Territory__c territory = [SELECT Id FROM Territory__c WHERE Name='Test']; 
        Territory__c territoryForChange = [SELECT Id FROM Territory__c WHERE Name='TestForChange']; 
        Territory__c territoryParentParent = [SELECT Id FROM Territory__c WHERE Name='TestParentParent'];
        TerrUser__c terruser = new TerrUser__c(Territory__c = territoryParentParent.id, User__c = user.id);
        Account acc = new Account(Name = 'AccountTest', Territory__c = territory.id);
        insert acc;
        Reference__c ref= new Reference__c(Account__c = acc.id, Contact__c = con.id);
       	insert ref;

        Test.startTest();
       	Database.SaveResult resultAdd = Database.insert(terruser, false);
        TerrUser__c terruserForChange = [SELECT Id, Territory__c
   											FROM Terruser__c WHERE Id = :terruser.id];
        terruserForChange.Territory__c = territoryForChange.id;
        Database.SaveResult resultUpdate = Database.update(terruserForChange, false);
        Database.DeleteResult resultRemove = Database.delete(terruserForChange, false);         
        Test.stopTest();
        
        System.assert(resultAdd.isSuccess());
        System.assert(resultRemove.isSuccess());
        System.assert(resultUpdate.isSuccess());
    }
    
   @isTest static void TestUniqueTerritory() {
      	Territory__c firstTerritory = new Territory__c(Name = 'Test');
        insert firstTerritory;
        Territory__c secondTerritory = new Territory__c(Name = 'Test');
        Territory__c thirdTerritory = new Territory__c(Name = 'SecondTest');
        Territory__c fourthTerritory = new Territory__c(Name = 'SecondTest');
        Territory__c fivTerritory = new Territory__c(Name = 'SecondTest');
       	List<Territory__c> territories = new List<Territory__c>();
        territories.add(thirdTerritory);
        territories.add(fourthTerritory);
        territories.add(fivTerritory);
       
        Test.startTest();
        Database.SaveResult result = Database.insert(secondTerritory, false);
        Database.SaveResult[] resultSecond = Database.insert(territories, false);
        Test.stopTest();
        
        for(Database.SaveResult sr : resultSecond){
            System.assert(!sr.isSuccess());
        }
        System.assert(!result.isSuccess());
   }
    @isTest static void TestAccount() {
    	Territory__c territory = [SELECT Id FROM Territory__c WHERE Name='Test'];
        Account acc = new Account(Name = 'AccountTest', Territory__c = territory.id);
        Contact con = [SELECT Id FROM Contact WHERE LastName='ContactTest'];
        Territory__c territoryForChange = [SELECT Id FROM Territory__c WHERE Name='TestForChange'];
        User user = [SELECT Id FROM User WHERE LastName='Testing'];
        Territory__c territoryParentParent = [SELECT Id FROM Territory__c WHERE Name='TestParentParent'];
        TerrUser__c terruser = new TerrUser__c(Territory__c = territoryParentParent.id, User__c = user.id);
        insert terruser;
        
        Test.startTest();
        Database.SaveResult resultAdd = Database.insert(acc, false);
        Reference__c ref= new Reference__c(Account__c = acc.id, Contact__c = con.id);
       	insert ref;
        Account accForChange = [SELECT Id, Territory__c
   								FROM Account WHERE Id = :acc.Id];
        accForChange.Territory__c = territoryForChange.id;
        Database.SaveResult resultUpdate = Database.update(accForChange, false);
        Database.DeleteResult resultRemove = Database.delete(accForChange, false);         
        Test.stopTest();
        
        System.assert(resultAdd.isSuccess());
        System.assert(resultRemove.isSuccess());
        System.assert(resultUpdate.isSuccess());
	}
}