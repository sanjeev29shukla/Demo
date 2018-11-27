public class QuickContactController {

    @AuraEnabled
    public static Account getAccount(Id accountId) {
        // Perform isAccessible() checks here
        return [SELECT Name, BillingCity, BillingState FROM Account WHERE Id = :accountId];
    }
    
    @AuraEnabled
    public static Contact saveContactWithAccount(Contact contact, Id accountId) {
        // Perform isAccessible() and isUpdateable() checks here
        contact.AccountId = accountId;
        upsert contact;
        return contact;
    }
    
    /*
    AND($Profile.Name <> $Label.MS_PRODID , 
$Profile.Name <> $Label.MS_System_Admin, Not(ISNEW()), 
ISPICKVAL( Account.FinServ__Status__c , "Client"), 
OR(ISCHANGED(FirstName), 
ISCHANGED(LastName), 
ISCHANGED(MiddleName), 
ISCHANGED(Suffix), 
ISCHANGED(Salutation)))
    
    */

}