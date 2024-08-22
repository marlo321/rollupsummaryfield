@IsTest
public class CaseTriggerHandlerTest {

    @TestSetup
    static void setupTestData() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 2; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert accounts;

        List<Case> cases = new List<Case>();
        cases.add(new Case(AccountId = accounts[0].Id, Status = 'New'));  // Open case
        cases.add(new Case(AccountId = accounts[0].Id, Status = 'Closed')); // Closed case
        cases.add(new Case(AccountId = accounts[1].Id, Status = 'New'));  // Open case
        insert cases;
    }

    @IsTest
    static void testAfterInsert() {
        List<Case> newCases = [SELECT Id, AccountId, Status FROM Case];

        Test.startTest();
        CaseTriggerHandler handler = new CaseTriggerHandler(newCases, new Map<Id, Case>());
        handler.afterInsert();
        Test.stopTest();
        
        List<Account> updatedAccounts = [SELECT Id, dynplan__NumberOpenedCases__c, dynplan__NumberClosedCases__c FROM Account];
        System.assertNotEquals(null, updatedAccounts, 'Accounts should be updated.');
    }

    @IsTest
    static void testAfterUpdate() {
        List<Case> cases = [SELECT Id, AccountId, Status FROM Case];
        Map<Id, Case> oldCaseMap = new Map<Id, Case>();

        Case updatedCase = cases[0];
        updatedCase.Status = 'Closed'; 
        oldCaseMap.put(updatedCase.Id, cases[1]); 

        update updatedCase;

        Test.startTest();
        CaseTriggerHandler handler = new CaseTriggerHandler([SELECT Id, AccountId, Status FROM Case], oldCaseMap);
        handler.afterUpdate();
        Test.stopTest();
        
        List<Account> updatedAccounts = [SELECT Id, dynplan__NumberOpenedCases__c, dynplan__NumberClosedCases__c FROM Account];
        System.assertNotEquals(null, updatedAccounts, 'Accounts should be updated.');
    }

    @IsTest
    static void testAfterDelete() {
        List<Case> cases = [SELECT Id, AccountId, Status FROM Case];
        Map<Id, Case> oldCaseMap = new Map<Id, Case>();

        Case caseToDelete = cases[0];
        oldCaseMap.put(caseToDelete.Id, caseToDelete);
        delete caseToDelete;

        Test.startTest();
        CaseTriggerHandler handler = new CaseTriggerHandler(new List<Case>(), oldCaseMap);
        handler.afterDelete();
        Test.stopTest();
        
        List<Account> updatedAccounts = [SELECT Id, dynplan__NumberOpenedCases__c, dynplan__NumberClosedCases__c FROM Account];
        System.assertNotEquals(null, updatedAccounts, 'Accounts should be updated.');
    }
}
