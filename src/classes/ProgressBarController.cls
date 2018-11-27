global class ProgressBarController{
    public Blob csvFileBody                       {get;set;}
    public string csvAsString                     {get;set;}
    public String[] csvFileLines                  {get;set;}
    public List<Import_User__c> listUser          {get;set;}
    public List<WrapperUser>  listWrapperUser     {get;set;}
    private Map<String,Id> mapUserName            {get;set;}
    public Integer rowToEdit                      {get;set;}
    public String searchedRecordId                {get;set;}
    public String phoneNumber                     {get;set;}
    public String cusId                           {get;set;}
    public Integer rowNum                         {get;set;}
    
    public ProgressBarController(){
        csvFileLines         =    new String[]{};
        listUser             =    new List<Import_User__c>(); 
        listWrapperUser      =    new List<WrapperUser>();
        for(Import_User__c oUser : Import_User__c.getAll().values()){
           WrapperUser wrpUsers    =    new WrapperUser();
           wrpUsers.userObj        =    oUser;
           wrpUsers.isEdit         =    false;
           listWrapperUser.add(wrpUsers);
           system.debug('^^^^ '+wrpUsers.userObj);system.debug('^^^^ '+wrpUsers.isEdit);system.debug('^^^^ wu '+wrpUsers);system.debug('^^^^ usr '+oUser);
       }
    }
    
    public void importCSVFile(){
       System.debug('Sanjeev Shukla');
    }
    
    
    
    public class WrapperUser{
        public Import_User__c userObj{get;set;}
        public Boolean isEdit        {get;set;}
    }
    
    
    
}