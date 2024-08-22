public class AccountSelector {

    public List<Account> selectAccountsByIds(List<Id> accountIds) {
        return [
            SELECT 
                Id, 
                (SELECT Id, IsClosed FROM Cases) 
            FROM Account 
            WHERE Id = :accountIds
        ];
    }

}