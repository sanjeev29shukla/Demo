/*
* Created By : Sanjeev Shukla
* Description : This class is used to import user from *.csv file to custom setting and dispaly on lightinh component. Admin able to assign/reassign user to phone number.
*/


public class ImportFileController {
	public static List<Import_User__c> listUser = New List<Import_User__c>();
    
    /*
    * Created By : Sanjeev Shukla
    * Description : This method is used to import user from *.csv file to custom setting.
    */
    
    @AuraEnabled
    public static List<Import_User__c> saveTheFile(Blob base64Data) { 
        try{
            System.debug('******csvfile******** '+base64Data);
            
           String csvAsString = base64Data.toString();
           String[] csvFileLines = csvAsString.split('\n');
           Map<String,String> mapUser = new Map<String,String>();
           for(Integer i=1;i<csvFileLines.size();i++){
               List<String> csvRecordData = csvFileLines[i].split(',');
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
               List<User> listUserPhone = new List<User>();
               for(User u : [SELECT Id,Username,Phone FROM User WHERE Username IN : mapUser.keySet()]){
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
            }
        }
        catch (Exception e)
        {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured while importin data Please make sure input csv file is correct');
            ApexPages.addMessage(errorMessage);
        }  
        System.debug('list user--> '+listUser);
        return listUser;
    }
    @RemoteAction
    public static List<User> getRecords(String usrName) {
        
        List<User> listUser1 = new List<User>();
        if(usrName.length() >0){
            listUser1 = [SELECT Username,Phone FROM User WHERE Username LIKE : usrName +'%'];
            
        }
        if(!listUser.isEmpty()){
            return listUser1;
        }
        return NULL;
    }
}