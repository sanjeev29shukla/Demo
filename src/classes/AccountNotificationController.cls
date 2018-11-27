public class AccountNotificationController {
    
    
    public Account accountInfo;
    public List<Contact> contacts;
    public String accountId;
    public String baseURL;
    public String getBaseURL(){
        return System.URL.getSalesforceBaseUrl().toExternalForm();
    }
    public Account getAccountInfo(){
        System.debug('****accountId 1******* '+accountId);
        try{
            accountInfo = [SELECT Id, Name FROM Account WHERE Id =: accountId];
            System.debug('****accountInfo********* '+accountInfo);
            return accountInfo;
        }catch(Exception ex){
            
        }
        return new Account();
    }
    public void setAccountId (String pAccountId) {
        accountId = pAccountId;
    }
    public String getAccountId () {
        return accountId;
    }
    public List<Contact> getContacts(){
        System.debug('****accountId 2******* '+accountId);
        contacts = [SELECT Id, Name, Email FROM Contact WHERE AccountId =: accountId];
        System.debug('****contacts********* '+accountInfo);
        return contacts;
    }
    
}