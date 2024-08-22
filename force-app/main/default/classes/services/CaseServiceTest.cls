@isTest
private class CaseServiceTest {


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
    static void testRecalculateAccountCount() {
        List<Account> accounts = [SELECT Id, Name, (SELECT Id, Status, IsClosed FROM Cases) FROM Account];
        List<Case> cases = [SELECT Id, AccountId, Status, IsClosed FROM Case];
        Map<Id, Account> accountNewMap = new Map<Id, Account>(accounts);
        Map<Id, Case> oldCaseMap = new Map<Id, Case>();

        Case oldCase = cases[1];
        oldCase.Status = 'New';
        oldCaseMap.put(oldCase.Id, oldCase);

        CaseService caseService = new CaseService();

        Set<Account> accountsToUpdate = caseService.recalculateAccountCount(accountNewMap, accountNewMap, cases, oldCaseMap);

        System.assertEquals(2, accountsToUpdate.size(), 'Two accounts should be marked for update.');

        for (Account acc : accountsToUpdate) {
            if (acc.Id == accounts[0].Id) {
                System.assertEquals(1, acc.get(Constants.accountOpenNumberField.getDescribe().getName()), 'Account 1 should have 1 open case.');
                System.assertEquals(1, acc.get(Constants.accountClosedNumberField.getDescribe().getName()), 'Account 1 should have 1 closed case.');
            } else if (acc.Id == accounts[1].Id) {
                System.assertEquals(1, acc.get(Constants.accountOpenNumberField.getDescribe().getName()), 'Account 2 should have 1 open case.');
                System.assertEquals(0, acc.get(Constants.accountClosedNumberField.getDescribe().getName()), 'Account 2 should have 0 closed cases.');
            }
        }
    }

    @IsTest
    static void testRecalculateAccountCount_NoOldCases() {
        List<Account> accounts = [SELECT Id, Name, (SELECT Id, Status, IsClosed FROM Cases) FROM Account];
        List<Case> cases = [SELECT Id, AccountId, Status, IsClosed FROM Case];
        Map<Id, Account> accountNewMap = new Map<Id, Account>(accounts);

        CaseService caseService = new CaseService();

        Set<Account> accountsToUpdate = caseService.recalculateAccountCount(accountNewMap, null, cases, null);

        System.assertEquals(2, accountsToUpdate.size(), 'Two accounts should be marked for update.');

        for (Account acc : accountsToUpdate) {
            if (acc.Id == accounts[0].Id) {
                System.assertEquals(1, acc.get(Constants.accountOpenNumberField.getDescribe().getName()), 'Account 1 should have 1 open case.');
                System.assertEquals(1, acc.get(Constants.accountClosedNumberField.getDescribe().getName()), 'Account 1 should have 1 closed case.');
            } else if (acc.Id == accounts[1].Id) {
                System.assertEquals(1, acc.get(Constants.accountOpenNumberField.getDescribe().getName()), 'Account 2 should have 1 open case.');
                System.assertEquals(0, acc.get(Constants.accountClosedNumberField.getDescribe().getName()), 'Account 2 should have 0 closed cases.');
            }
        }
    }
}