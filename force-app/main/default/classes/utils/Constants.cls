public class Constants {
    
    // FYI - Provide correct ApiName fields from your org to verify code

    // Account fields
    public static SObjectField accountClosedNumberField = Account.dynplan__NumberClosedCases__c.getDescribe().getSObjectField();
    public static SObjectField accountOpenNumberField = Account.dynplan__NumberOpenedCases__c.getDescribe().getSObjectField();
    
    // Case fields
    public static SObjectField accountField = Case.AccountId.getDescribe().getSObjectField();

}