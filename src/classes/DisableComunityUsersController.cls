global class DisableComunityUsersController implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, AccountId, ContactId  FROM AccountContactRelation');
    }
    
    global void execute(Database.BatchableContext bc, List<AccountContactRelation> scope) {
        Map<Id,Id> accIdMap = new Map<Id,Id>();
        for(AccountContactRelation theACRel : scope){
            accIdMap.put(theACRel.AccountId,theACRel.ContactId);
        }
        Set<Id> conIdSet = new Set<Id>();
        for(Account theAcc : [SELECT Id,( SELECT Id FROM Contracts ) FROM Account WHERE Id IN :accIdMap.keySet()]){
            Boolean flag = true;
            for(Contract theCon : theAcc.Contracts){
                if(theCon.Status == 'Active'){
                    flag = false;
                    break;
                }
            }
            if(flag && !theAcc.Contracts.isEmpty()){
            	conIdSet.add(accIdMap.get(theAcc.Id));	   
            }
        }
        
        if(!conIdSet.isEmpty()){
            List<User> userList = new List<User>();
            for(User theUser :[SELECT Id FROM User WHERE contactid IN : conIdSet]){
                theUser.Isactive=false;
                userList.add(theUser);
            }
            if(!userList.isEmpty()){
                update userList;
            }
        }
    }
    global void finish(Database.BatchableContext BC){
        
    }
}