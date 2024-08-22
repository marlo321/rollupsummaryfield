@isTest
private class AccountServiceTest {

    @TestSetup
    static void setupTestData() {
        List<Account> testAccounts = new List<Account>();
        
        for (Integer i = 0; i < 3; i++) {
            Account acc = new Account(Name = 'Test Account ' + i);
            testAccounts.add(acc);
        }
        
        insert testAccounts;

        List<Case> testCases = new List<Case>();
        
        for (Account acc : testAccounts) {
            testCases.add(new Case(AccountId = acc.Id, Status = 'New'));
            testCases.add(new Case(AccountId = acc.Id, Status = 'Closed'));
        }
        
        insert testCases;
    }

    @IsTest
    static void testSelectAccountsByIds() {
        List<Account> insertedAccounts = [SELECT Id FROM Account];

        List<Id> accountIds = new List<Id>();
        for (Account acc : insertedAccounts) {
            accountIds.add(acc.Id);
        }

        AccountService accountService = new AccountService();

        Map<Id, Account> resultMap = accountService.selectAccountsByIds(accountIds);

        System.assertEquals(accountIds.size(), resultMap.size(), 'The number of accounts in the map should match the number of accountIds provided.');

        for (Account acc : resultMap.values()) {
            System.assertNotEquals(null, acc.Cases, 'Each Account in the map should have related Cases.');
            System.assertEquals(2, acc.Cases.size(), 'Each Account in the map should have 2 related Cases.');
        }
    }

    @IsTest
    static void testSelectAccountsByIds_NoAccounts() {
        List<Id> emptyAccountIds = new List<Id>();

        AccountService accountService = new AccountService();

        Map<Id, Account> resultMap = accountService.selectAccountsByIds(emptyAccountIds);

        System.assertEquals(0, resultMap.size(), 'The result map should be empty when no accountIds are provided.');
    }
}