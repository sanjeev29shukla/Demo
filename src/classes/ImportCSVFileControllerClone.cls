global class ImportCSVFileControllerClone{
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
    
    public ImportCSVFileControllerClone(){
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
       try{
           csvAsString = csvFileBody.toString();
           System.debug('*********csvFileBody**********'+csvAsString); 
           csvFileLines = csvAsString.split('\n'); 
           System.debug('*********csvFileLines **********'+csvFileLines);
           Map<String,String> mapUser = new Map<String,String>();
           for(Integer i=1;i<csvFileLines.size();i++){
               string[] csvRecordData = csvFileLines[i].split(',');
               System.debug('*********csvRecordData **********'+csvRecordData);
               Import_User__c userObj = new Import_User__c() ;
               userObj.Phone_Number__c = csvRecordData[0] ;             
               userObj.AuthToken__c = csvRecordData[1];
               userObj.User__c = csvRecordData[2];
               userObj.Status__c = csvRecordData[3];   
               listUser.add(userObj);
               mapUser.put(userObj.User__c,userObj.Phone_Number__c);
           }
           Map<String,Import_User__c> mapExitsUser = Import_User__c.getall();
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
               List<User> listUserPhone = new List<User>();// naveen Changes  starts here
           
               for(User u : [SELECT Id,Username,Phone FROM User WHERE Username IN : mapUser.keySet()]){//n Change
               System.debug('****** inside loop********'+u);
                   if(u.Phone != mapUser.get(u.Username)){
                       User iu = new User();               
                       iu.id = u.Id;                        
                       iu.Phone= mapUser.get(u.Username) ;  
                       listUserPhone.add(iu);                
                   }               
               }
               try{
                   if(!listUserPhone.isEmpty()){
                       update listUserPhone;
                   }
               }
               Catch(Exception e){
                   System.debug('******  Exception ********'+e);
               }
               listWrapperUser.clear();

               /***SOQL query is performed on Custom Setting Import_User__c to get records in descending order by LastModified Date, show this in front end  ***/
               for(Import_User__c usr : [SELECT Id,Name,Phone_Number__c,AuthToken__c,User__c,Status__c,LastModifiedDate from Import_User__c  ORDER BY LastModifiedDate DESC]){
                   WrapperUser wu = new WrapperUser();
                   wu.userObj = usr;
                   wu.isEdit = false;
                   listWrapperUser.add(wu);
                   system.debug('^^^^ '+wu.userObj);system.debug('^^^^ '+wu.isEdit);system.debug('^^^^ wu '+wu);system.debug('^^^^ usr '+usr);
               }
              
           }
        }
        catch (Exception e)
        {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occurred while importing data. Please make sure input csv file is correct');
            ApexPages.addMessage(errorMessage);
            system.debug('Exception e'+e.getlineNumber()+e.getCause());
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
            listWrapperUser[rowToEdit].isEdit   = false;
            system.debug('*******new data *******'+wu);
            Import_User__c userObj = new Import_User__c() ;
            userObj        =        wu.userObj ;             
            try{
                system.debug('*******before update*******');
                update userObj;
                try{
                    User us = [SELECT Id,Username,Phone FROM User WHERE Username =: userObj.User__c];
                    us.Phone = userObj.Phone_Number__c;
                    update us;
                }catch(Exception ex){system.debug('*******user update exception*******'+ex);}
                
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
            listUser = [SELECT Username FROM User WHERE Username LIKE : searchText +'%' AND IsActive = true];
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
    
    
    public void verifyPhoneNumber() {
        String status   =   '';
        String url      =   'https://app2.businessmessenger.com/api/4.0/account/' + phoneNumber ;
        
        // Instantiate a new http object
        Http h = new Http();
        
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        req.setHeader('AdminAccountId', 'A0FM8820-FFL3-2FM3-0FMV-AFMV39L2I4H3');
        req.setHeader('AdminPassword', 'MB9DNEOI-EDFN-3SF3-FDAL-EFFM3LIW3I32');
        
        // Send the request, and return a response
        HttpResponse res = h.send(req);                                         System.debug('HTTP Response Body *** '+res.getBody()); System.debug('HTTP Status Code ***'+res.getStatusCode());    
        
        // Parsing HttpResponse body of JSON type
        if( !String.isBlank(res.getBody()) && res.getStatusCode() == 200) {
            JSONParser parser   =   JSON.createParser(res.getBody());             System.debug('parser*** '+parser);
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                    String fieldName = parser.getText();                          System.debug('fieldName*** '+fieldName);
                    parser.nextToken();
                    if (fieldName == 'IsActive' && parser.getText() != null && parser.getText() == 'true') {
                        status  =   'Active' ;                                    System.debug('parser.getText() '+parser.getText());
                    }
                }
            }
        } else if(res.getStatusCode() !=  200) {
             status  =   'Inactive';
        }
        
        if(!String.isBlank(status) && cusId != null ) {
            Import_User__c oImportUser    =    new Import_User__c();
            oImportUser.Id                =    cusId;
            oImportUser.Status__c         =    status;
            try{
                update oImportUser;
                system.debug('oImportUser *** '+oImportUser);
                system.debug('***listWrapperUser[rowNum].userObj.Status__c ****'+listWrapperUser[rowNum].userObj.Status__c);
                listWrapperUser[rowNum].userObj.Status__c = status;
                system.debug('listWrapperUser[rowNum].userObj.Status__c'+listWrapperUser[rowNum].userObj.Status__c);
                system.debug('***listWrapperUser****'+listWrapperUser);
            } catch (Exception e) {system.debug('***Exception ****'+e);}
        }
        
        System.debug('Status*** '+status);

    }
}