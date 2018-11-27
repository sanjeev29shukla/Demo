global class EmailNotification_Batch implements Database.Batchable<sObject>{
    global String query;
    global List<String> profiles;
    global Database.QueryLocator start(Database.BatchableContext BC){
        profiles = new List<String>();
        profiles.add('System Administrator');
        query = 'SELECT Id, Email FROM User WHERE Profile.Name IN : profiles';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        system.debug('****users**** '+scope);
    }
    
    global void finish(Database.BatchableContext BC){
    }
}