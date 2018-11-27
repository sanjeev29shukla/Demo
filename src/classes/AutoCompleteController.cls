public class AutoCompleteController{
    public Integer randomJsIden{get;set;}
    public Object cacheField{get; set;}
    public Boolean allowClear {get;set;}
    public Boolean syncManualEntry{get;set;}
    public User us {get;set;}
    public AutoCompleteController(){
        randomJsIden = getRandomNumber(1000000);
        allowClear = true;
        syncManualEntry = true;
        us = new User();
    }
    
     /*
    *Random number generator to change the js function name if multiple components us
    ***/
    private Integer getRandomNumber(Integer size){
        Double d = Math.random() * size;
        return d.intValue();
    }
    
    
    /*
    *This method queries data according to the passed parameters
    ***/
    @RemoteAction
    public static List<AutoCompleteData> getData(String param){
       
        List<AutoCompleteData> AutoCompleteDatas = new List<AutoCompleteData>();
        param = String.escapeSingleQuotes(param);
        for( User us : Database.query('SELECT UserName FROM User WHERE Username LIKE \'%'+param+'%\'')){
            AutoCompleteDatas.add(new AutoCompleteData(us.UserName));
        }
        
        return AutoCompleteDatas;
        
    }
    
    public class AutoCompleteData{
        public String text;
        
        public AutoCompleteData(String text){
            this.text = String.valueOf(text);
        }
    }
}