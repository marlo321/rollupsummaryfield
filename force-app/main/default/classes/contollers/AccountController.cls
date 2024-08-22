public class AccountController {

    private static AccountService accountService = new AccountService();
    
    public static Map<Id, Account> selectAccountsByIds(List<Id> accountIds) {
        return accountService.selectAccountsByIds(accountIds);
    }

}