@isTest
private class AccountSelectorTest {


    @TestSetup
    static void setupTestData() {

        List<Account> testAccounts = new List<Account>();
        
        for (Integer i = 0; i < 5; i++) {
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
        
        AccountSelector selector = new AccountSelector();
        
        List<Account> resultAccounts = selector.selectAccountsByIds(accountIds);


        System.assertEquals(accountIds.size(), resultAccounts.size(), 'The number of accounts returned should match the number of accountIds provided.');
        
        for (Account acc : resultAccounts) {
            System.assertNotEquals(null, acc.Cases, 'Each Account should have related Cases.');
            System.assertEquals(2, acc.Cases.size(), 'Each Account should have 2 related Cases.');
        }
    }
}