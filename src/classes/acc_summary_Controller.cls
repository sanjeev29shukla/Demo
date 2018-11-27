Public class acc_summary_Controller{
Public Map<String,List<Account>> accSum{get;set;}
Public Set<String> accType{get;set;}
    public acc_summary_Controller(){
        accSum = new Map<String,List<Account>>();
        accType = new Set<String>();
        for(Account acc : [Select id,Name,Phone,type from Account where Type != NULL]){
            accType.add(acc.type);
            if(!accSum.isEmpty() && accSum.containsKey(acc.type) && accSum.get(acc.type) != NULL){
                accSum.get(acc.type).add(acc);
            }
            else{
                accSum.put(acc.type,new List<Account>{acc});
            }
        }
        system.debug('accSum ***'+accSum);
    }
    
}