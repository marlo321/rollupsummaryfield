@isTest
private class CaseControllerTest {

    @TestSetup
    static void setupTestData() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 2; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert accounts;

        List<Case> cases = new List<Case>();
        cases.add(new Case(AccountId = accounts[0].Id, Status = 'New')); 
        cases.add(new Case(AccountId = accounts[0].Id, Status = 'Closed')); 
        cases.add(new Case(AccountId = accounts[1].Id, Status = 'New'));  
        insert cases;
    }

    @IsTest
    static void testUpdateAccountCount() {
        List<Account> accounts = [SELECT Id FROM Account];
        List<Case> cases = [SELECT Id, AccountId, Status FROM Case];

        Map<Id, Case> oldCaseMap = new Map<Id, Case>();
        Case oldCase = cases[1];
        oldCase.Status = 'New';  
        oldCaseMap.put(oldCase.Id, oldCase);

        Test.startTest();
        CaseController.updateAccountCount(cases, oldCaseMap);
        Test.stopTest();

        List<Account> updatedAccounts = [
            SELECT Id, 
                   dynplan__NumberOpenedCases__c, 
                   dynplan__NumberClosedCases__c,
                   (SELECT Id, Status FROM Cases) 
            FROM Account 
            WHERE Id IN :accounts
        ];

        System.assertEquals(2, updatedAccounts.size(), 'Two accounts should be updated.');

        for (Account acc : updatedAccounts) {
            if (acc.Id == accounts[0].Id) {
                Integer openCases = (Integer) acc.dynplan__NumberOpenedCases__c;
                Integer closedCases = (Integer) acc.dynplan__NumberClosedCases__c;
                System.assertEquals(1, openCases, 'Account 1 should have 1 open case.');
                System.assertEquals(1, closedCases, 'Account 1 should have 1 closed case.');
            } else if (acc.Id == accounts[1].Id) {
                Integer openCases = (Integer) acc.dynplan__NumberOpenedCases__c;
                Integer closedCases = (Integer) acc.dynplan__NumberClosedCases__c;
                System.assertEquals(1, openCases, 'Account 2 should have 1 open case.');
                System.assertEquals(0, closedCases, 'Account 2 should have 0 closed cases.');
            }
        }
    }

    @IsTest
    static void testUpdateAccountCount_NoOldCases() {
        List<Account> accounts = [SELECT Id FROM Account];
        List<Case> cases = [SELECT Id, AccountId, Status FROM Case];

        Test.startTest();
        CaseController.updateAccountCount(cases, null);
        Test.stopTest();

        List<Account> updatedAccounts = [
            SELECT Id, 
                   dynplan__NumberOpenedCases__c, 
                   dynplan__NumberClosedCases__c,
                   (SELECT Id, Status FROM Cases) 
            FROM Account 
            WHERE Id IN :accounts
        ];

        System.assertEquals(2, updatedAccounts.size(), 'Two accounts should be updated.');

        for (Account acc : updatedAccounts) {
            if (acc.Id == accounts[0].Id) {
                Integer openCases = (Integer) acc.dynplan__NumberOpenedCases__c;
                Integer closedCases = (Integer) acc.dynplan__NumberClosedCases__c;
                System.assertEquals(1, openCases, 'Account 1 should have 1 open case.');
                System.assertEquals(1, closedCases, 'Account 1 should have 1 closed case.');
            } else if (acc.Id == accounts[1].Id) {
                Integer openCases = (Integer) acc.dynplan__NumberOpenedCases__c;
                Integer closedCases = (Integer) acc.dynplan__NumberClosedCases__c;
                System.assertEquals(1, openCases, 'Account 2 should have 1 open case.');
                System.assertEquals(0, closedCases, 'Account 2 should have 0 closed cases.');
            }
        }
    }
}