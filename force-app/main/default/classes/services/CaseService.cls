public class CaseService {

    
    private List<SObjectField> sobjectFields = new List<sobjectField> {    
        Constants.accountClosedNumberField, 
        Constants.accountOpenNumberField
    };

    public Set<Account> recalculateAccountCount (
            Map<Id, Account> accountNewMap, Map<Id, Account> accountOldMap,
                List<Case> cases, Map<Id, Case> oldCaseMap
        ) {
            Set<Account> accountToUpdate = new Set<Account>();
            
            for (Case theCase : cases) {
                
                Case oldCase = (oldCaseMap != null && oldCaseMap.containsKey(theCase.Id)) ? oldCaseMap.get(theCase.Id) : null;
                Account newAccount = recalculateAccount(theCase, accountNewMap);
                
                if(newAccount != null) {
                    accountToUpdate.add(newAccount);
                }  
                
                if(accountOldMap != null && oldCase != null) {
                    Account oldAccount = recalculateAccount(oldCase, accountOldMap);
                    
                    if(oldAccount != null){
                        accountToUpdate.add(oldAccount);
                    } 
                }
            }

            return accountToUpdate;
    }

    private Account recalculateAccount(Case theCase, Map<Id, Account> accountMap) {
        Account account;

        if(accountMap != null && accountMap.containsKey(theCase.AccountId)) {
            account = accountMap.get(theCase.AccountId);
            
            for(SObjectField fieldToUpdate : sobjectFields) {

                account.put(fieldToUpdate.getDescribe().getName(), countCaseNumber(fieldToUpdate, account.cases));
            }

        }
        return account;
    }

    private Integer countCaseNumber(SObjectField fieldToUpdate, List<Case> cases) { 

        List<Case> resultCases = new List<Case>();
            
        for (Case childCase : cases) {
            if(fieldToUpdate == Constants.accountClosedNumberField && childCase.IsClosed) {
                resultCases.add(childCase);
            } else if(fieldToUpdate == Constants.accountOpenNumberField && !childCase.IsClosed) {
                resultCases.add(childCase);
            }
        }
        return resultCases.size();
    }

}