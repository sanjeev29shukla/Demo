global class ImportCSVFileControllerNaveen{
    public Blob csvFileBody                   {get;set;}
    public string csvAsString                 {get;set;}
    public String[] csvFileLines              {get;set;}
    public List<Import_User__c> listUser      {get;set;}
    public List<WrapperUser>  listWrapperUser {get;set;}
    private Map<String,Id> mapUserName        {get;set;}
    public Integer rowToEdit                  {get;set;}
    public String searchedRecordId { get; set; }
    public ImportCSVFileControllerNaveen(){
        csvFileLines = new String[]{};
        listUser = New List<Import_User__c>(); 
        listWrapperUser = new List<WrapperUser>();
    }
    
    public void importCSVFile(){
       try{
           Map<String,String> mUnamePhone = new Map<String,String>(); //Nchanges
          
           csvAsString = csvFileBody.toString();
           System.debug('*********csvFileBody**********'+csvAsString); 
           csvFileLines = csvAsString.split('\n'); 
           System.debug('*********csvFileLines **********'+csvFileLines);
           for(Integer i=1;i<csvFileLines.size();i++){
               string[] csvRecordData = csvFileLines[i].split(',');
               System.debug('*********csvRecordData **********'+csvRecordData);
               Import_User__c userObj = new Import_User__c() ;
               userObj.Phone_Number__c = csvRecordData[0] ;             
               userObj.AuthToken__c = csvRecordData[1];
               userObj.User__c = csvRecordData[2];
               userObj.Status__c = csvRecordData[3];   
               listUser.add(userObj);
               mUnamePhone.put(userObj.User__c,userObj.Phone_Number__c); //Nchanges
           }
           Map<String,Import_User__c> mapExitsUser = Import_User__c.getall();
           
           
           /*mapUserName = new Map<String,Id>();
           if(!listExitsUser.isEmpty()){
               for(Import_User__c  usr : listExitsUser){
                   mapUserName.put(usr.Name, usr);
               }
           }*/
           if(!mapExitsUser.isEmpty()){
               Integer i = mapExitsUser.size()+1;
               Boolean flag = true;
               for(Import_User__c usr : listUser){
                   for(Import_User__c usrEx : mapExitsUser.values()){
                       if(usrEx.User__c == usr.User__c && usrEx.Phone_Number__c == usr.Phone_Number__c ){
                           System.debug('**************break******************'+usrEx.name);
                           usr.id  = usrEx.Id;
                           usr.name = usrEx.name;
                           flag = false;
                           break;
                       }
                   }
                   if(flag){
                       System.debug('**************name******************');
                       usr.name = String.valueOf(i);
                       i++;
                   }
                   flag = true;
               }
           }else{
               Integer i = 0;
               for(Import_User__c usr : listUser){
                   usr.name = String.valueOf(i);
                   i++;
               }
           }
          
           
           
           if(!listUser.isEmpty()){
               upsert listUser;
               
               List<User> lUpdateUPhone = new List<User>();// naveen Changes  starts here
           
               for(User u : [SELECT Id,Username,Phone FROM User WHERE Username IN : mUnamePhone.keySet()]){//n Change
               System.debug('****** inside loop********'+u);
                   if(u.Phone != mUnamePhone.get(u.Username)){
                       User iu = new User();               
                       iu.id = u.Id;                        
                       iu.Phone= mUnamePhone.get(u.Username) ;  
                       lUpdateUPhone.add(iu);                
                   }               
               }
               try{
                   if(!lUpdateUPhone.isEmpty()){
                       System.debug('****** before update********'+lUpdateUPhone);
                       update lUpdateUPhone;
                       System.debug('****** after update********'+lUpdateUPhone);
                   }
               }
               Catch(Exception e){
                   System.debug('******  Exception ********'+e);
               }                                                   // naveen Changes  Ends here 
           
           
               listWrapperUser.clear();
               for(Import_User__c usr : listUser){
                   WrapperUser wu = new WrapperUser();
                   wu.userObj = usr;
                   wu.isEdit = false;
                   listWrapperUser.add(wu);                   
               }
           }
        }
        catch (Exception e)
        {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured while importin data Please make sure input csv file is correct');
            ApexPages.addMessage(errorMessage);
        }  
    }
    
    public void edit(){
        rowToEdit = Integer.valueOf(apexpages.currentpage().getparameters().get('rowToEdit'));
        listWrapperUser[rowToEdit].isEdit = true;
    }
    public PageReference saveUser(){
        rowToEdit = Integer.valueOf(apexpages.currentpage().getparameters().get('rowToEdit'));
        system.debug('*******rowToEdit *******'+rowToEdit);
        WrapperUser wu = listWrapperUser.get(rowToEdit);
        Boolean flag = true;
        for(Import_User__c usr : Import_User__c.getall().values()){
            if(wu.userObj.User__c == usr.User__c && wu.userObj.Phone_Number__c == usr.Phone_Number__c && wu.userObj.name != usr.name){
                flag = false;
                break;
            }
        }
        if(flag){
            listWrapperUser[rowToEdit].isEdit = false;
            system.debug('*******new data *******'+wu);
            Import_User__c userObj = new Import_User__c() ;
            userObj        =        wu.userObj ;             
            try{
                system.debug('*******before update*******');
                update userObj;
                system.debug('*******after update*******');
            }catch(Exception e){
                system.debug('*******exception*******'+e.getMessage());
                ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,e.getMessage());
                ApexPages.addMessage(errorMessage);
            }
        }else{
            system.debug('*******inside else*******');
            listWrapperUser[rowToEdit].isEdit = true;
            system.debug('*******listWrapperUser[rowToEdit]*******'+listWrapperUser[rowToEdit]);
            Import_User__c usrIns = Import_User__c.getInstance(wu.userObj.name);
            wu.userObj.User__c =  usrIns.User__c;
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'This record already exists');
            ApexPages.addMessage(errorMessage);
            system.debug('*******end of else*******');
        }
        return null;
    }
    
    public List<User> getUserList()
    {
       
        return [SELECT userName FROM User ];
        
    }
    
    @RemoteAction
    global static List<User> getRecords(String searchText) {
        
        List<User> listUser = new List<User>();
        if(searchText.length() >0){
            listUser = [SELECT Username,Phone FROM User WHERE Username LIKE : searchText +'%'];
            
        }
        if(!listUser.isEmpty()){
            return listUser;
        }
        return NULL;
    }
    
    public class WrapperUser{
        public Import_User__c userObj{get;set;}
        public Boolean isEdit        {get;set;}
    }   
}