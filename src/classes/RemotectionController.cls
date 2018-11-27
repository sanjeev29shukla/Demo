global class RemotectionController{
    
    @RemoteAction
    global static List<Account> getRecords(String search) {
        
        List<Account> listAcc = new List<Account>();
        
            listAcc = [SELECT name, (SELECT name from contacts) from account];
        System.debug('list of account'+listAcc);
        if(!listAcc.isEmpty()){
            
            return listAcc;
        }
        return NULL;
    }
    
    @RemoteAction
    global static Boolean getAccount(List<Account> listAcc) {
        system.debug('list of acc '+listAcc);
        return true;
    
    }
    
    
}