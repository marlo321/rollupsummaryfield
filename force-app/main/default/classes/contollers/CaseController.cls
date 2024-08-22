public with sharing class CaseController {

    private static CaseService caseService = new CaseService();

    public static void updateAccountCount(List<Case> cases, Map<Id, Case> oldCaseMap ) {
            Set<Account> accountToUpdate = new Set<Account>();

            List<Case> oldCases = (oldCaseMap != null) ? oldCaseMap.values() : new List<Case>();

            Set<Id> accountNewIds = CollectionUtil.getIdSetByField(cases, Constants.accountField);
            Set<Id> accountOldIds = CollectionUtil.getIdSetByField(oldCases, Constants.accountField);

            Map<Id, Account> accountNewMap = AccountController.selectAccountsByIds(new List<Id> (accountNewIds));
            Map<Id, Account> accountOldMap = AccountController.selectAccountsByIds(new List<Id> (accountOldIds));

            accountToUpdate.addAll(
                caseService.recalculateAccountCount(accountNewMap, accountOldMap, cases, oldCaseMap)
            );

            List<Account> accountToUpdateList =  new List<Account>(accountToUpdate);

            update accountToUpdateList;
    }

}