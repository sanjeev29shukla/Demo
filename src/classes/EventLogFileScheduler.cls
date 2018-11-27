global class EventLogFileScheduler implements Schedulable {
    
    public static void syncEventLogFile() {         
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID()); 
        req.setTimeout(50000);    
        req.setHeader('content-type', 'text/csv');        
        String url ='https://heywireapp-dev-ed.my.salesforce.com/services/data/v41.0/query?q=SELECT+Id+,+EventType+,+CreatedDate+,+LogFileContentType+,+LogFileFieldNames+,+LogFileFieldTypes+,+LogFile++,+LogDate+,+LogFileLength+FROM+EventLogFile';
        req.setEndpoint(url);
        req.setMethod('GET');
        HttpResponse res;
        Http oHttp = new Http();
        
        res = oHttp.Send(req);
        Body bd = new Body();
        bd = (Body)JSON.deserialize(res.getBody(), Body.class);
        system.debug('######theBody#####'+bd);
     
       
    }   

    global void execute(SchedulableContext SC) {
      EventLogFileScheduler.syncEventLogFile();
   }
    
    public class Body{
        public String totalSize;
        public String done;
        public List<EventLogFileWrapper> records;
        
        public Body(){
            records = new List<EventLogFileWrapper>();
        }
    }
    
    public class EventLogFileWrapper{
        public String Id;
        public String EventType;
        public String CreatedDate;
        public String LogFileContentType;
        public String LogFileFieldNames;
        public String LogFileFieldTypes;
        public String LogFile;
        public String LogDate;
        public String LogFileLength;
    }
}