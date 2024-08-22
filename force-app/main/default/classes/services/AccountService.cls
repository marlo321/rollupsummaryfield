public class AccountService {

    private AccountSelector accountSelector = new AccountSelector();

    public Map<Id, Account> selectAccountsByIds(List<Id> accountIds) {
        List<Account> accounts = accountSelector.selectAccountsByIds(accountIds);

        if(accounts != null && !accounts.isEmpty()) {
            return new Map <Id, Account> (accounts);
        }
        return new Map <Id, Account>();
    }

}