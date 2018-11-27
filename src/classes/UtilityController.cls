public class UtilityController {
    
    /***************Account Trigger Code Start from here*****************
    trigger ContactTrigger on Contact (after update) {
        
        // Synchronous process
        if(Trigger.isAfter && Trigger.isUpdate && UtilityController.isRecursion){
            UtilityController.filterChangedAccount(Trigger.new, Trigger.oldMap);
        }

		// Aynchronous process-- Future Method 
        if(Trigger.isAfter && Trigger.isUpdate && !System.isFuture() && !System.isBatch()){
            UtilityController.filterChangedAccount(Trigger.new, Trigger.oldMap);
        }
    } 
    **************Account Trigger Code End to here******************/
    public static Boolean isRecursion = TRUE;
    public static void filterChangedAccount(List<Account> pNew, Map<Id, Account> pOldMap){
        Set<Id> theAccIds = new Set<Id>();
        for(Account theAcc : pNew){
            if(theAcc.IsChild__c && theAcc.IsChild__c != pOldMap.get(theAcc.Id).IsChild__c){
                theAccIds.add(theAcc.Id);
            }
        }
        if(!theAccIds.isEmpty()){
            UtilityController.resetSubOrdinateAcccounts1(theAccIds);
            // OR
            // UtilityController.resetSubOrdinateAcccounts2(theAccIds);
        }
    }
    
    //@future
    public static void resetSubOrdinateAcccounts1(Set<Id> pAccountIds){
        List<Account> accounts 		= new List<Account>();
        Set<String> theAccIds 		= new Set<String>();
        Integer count = 0;
        while(!pAccountIds.isEmpty() && count < 3){
            count++;
            List<Account> listAccounts = new List<Account>([SELECT Id, Name, Parent.Parent.Parent.Parent.Parent.ParentId FROM Account WHERE Id NOT IN : theAccIds AND (ParentId IN : pAccountIds OR Parent.ParentId IN : pAccountIds OR Parent.Parent.ParentId IN : pAccountIds OR Parent.Parent.Parent.ParentId IN : pAccountIds OR Parent.Parent.Parent.Parent.ParentId IN : pAccountIds OR Parent.Parent.Parent.Parent.Parent.ParentId IN : pAccountIds)]);
            pAccountIds.clear();
            for(Account theAccount : listAccounts){
                theAccIds.add(theAccount.Id);
                theAccount.IsChild__c = TRUE;
                accounts.add(theAccount);
                if(theAccount.Parent.Parent.Parent.Parent.Parent.ParentId != NULL){
                    pAccountIds.add(theAccount.Id);
                }
            }
        }
        
        if(!accounts.isEmpty()){
            UtilityController.isRecursion = FALSE;
            update accounts;
        }
    }
    
    //@future
    public static void resetSubOrdinateAcccounts2(Set<Id> pAccountIds) {
        List<Account> theAccounts = new List<Account>();
        Integer count = 0;
        while (!pAccountIds.isEmpty()) {
            count++;
            Map<Id,Account> childAccounts = new Map<Id,Account>([SELECT Id, ParentId, Name FROM Account WHERE ParentId IN :pAccountIds ]);
            pAccountIds = childAccounts.keySet();
            for (Account theAcc : childAccounts.values()) {
                theAcc.IsChild__c = TRUE;
                theAccounts.add(theAcc);
            }
        }
        if(!theAccounts.isEmpty()){
            UtilityController.isRecursion = FALSE;
            update theAccounts;
        }
    }
    
    public static void deactivateUsers(){
        List<User> users = new List<User>([SELECT IsActive FROM User WHERE Profile.Name = 'Retail Sales Manager']);
        if(!users.isEmpty()){
            for(User each : users){
                each.IsActive = false;
            }
            update users;
        }
    }
}